{# Imports #}
with source_raw_torii as
    (select
        t1.id,
        t1.idOrg,
        t1.idUser,
        t1.idApp,
        t1.idAppAccount,
        t1.sourceIdAppAccount,
        t1.usageDate,
        t1.source,
        t1.hostname,
        t1.country,
        t1.creationTime,
        t1.updateTime
    from {{ source('raw_torii', 'app_usage_log_up_to_dec_2021') }} as t1
    where
        to_date(creationTime) <= '2022-01-21'
    union
    select
        t2.id,
        t2.idOrg,
        t2.idUser,
        t2.idApp,
        t2.idAppAccount,
        t2.sourceIdAppAccount,
        t2.usageDate,
        t2.source,
        t2.hostname,
        t2.country,
        t2.creationTime,
        t2.updateTime
    from {{ source('raw_torii', 'app_usage_log_up_to_mar_2022') }} as t2
    where
        to_date(creationTime) > '2022-01-21' and to_date(creationTime) < '2022-04-20'
    union
    select
        t3.id,
        t3.idOrg,
        t3.idUser,
        t3.idApp,
        t3.idAppAccount,
        t3.sourceIdAppAccount,
        t3.usageDate,
        t3.source,
        t3.hostname,
        t3.country,
        t3.creationTime,
        t3.updateTime
        from {{ source('raw_torii', 'app_usage_log') }} as t3
        where
            to_date(creationTime) >= '2022-04-20'
    {% if target.name == 'dev' %}
    limit 100
    {% endif %} ),
{# Custom Hard busienss rules transforms logic CTE #}
app_usage_log_transform as
    (select
        t2.id,
        trim(t2.source) as source,
        trim(t2.hostname) as hostname,
        trim(t2.country) as country,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_APP_USAGE_LOG,
        s.idOrg as BK_ORG,
        s.idUser as BK_USER,
        s.idApp as BK_APP,
        s.idAppAccount as BK_APP_ACCOUNT,
        s.sourceIdAppAccount as BK_SOURCE_APP_ACCOUNT,
        s.usageDate as DT_USAGE,
        trn.source as SOURCE,
        trn.hostname as HOST_NAME,
        trn.country as COUNTRY,
        trn.creationTime as DT_CREATION,
        trn.updateTime as DT_UPDATE
    from source_raw_torii s
    inner join app_usage_log_transform trn
        on (s.id = trn.id))
{# Final Select #}
select * from final