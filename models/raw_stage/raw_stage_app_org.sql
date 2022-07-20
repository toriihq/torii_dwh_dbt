{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'app_org') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
app_org_transform as
    (select
        t2.id,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        (s.id) as BK_APP_ORG,
        (s.idOrg) as BK_ORG,
        (s.idApp) as BK_APP,
        (s.owner) as BK_USER_OWNER,
        (s.score) as SCORE,
        (s.isCore) as IND_CORE,
        (s.isHidden) as IND_HIDDEN,
        (trn.creationTime) as DT_CREATION,
        (trn.updateTime) as DT_UPDATE,
    from source_raw_torii s
    inner join app_org_transform trn
        on (s.id = trn.id))
{# Final Select #}
select * from final