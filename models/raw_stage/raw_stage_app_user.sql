{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'app_user') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
app_user_transform as
    (select
        t2.id,
        trim(t2.idExternalUser) as idExternalUser,
        trim(t2.source) as source,
        trim(t2.email) as email,
        trim(t2.extensionVersion) as extensionVersion,
        concat(trim(t2.firstname), ' ', trim(t2.lastname)) as user_name,
        trim(t2.externalStatus) as externalStatus,
        trim(t2.role) as role,
        to_date(t2.lastVisitTime) as lastVisitTime,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_APP_USER,
        s.idOrg as BK_ORG,
        s.idApp as BK_APP,
        s.idAppAccount as BK_APP_ACCOUNT,
        s.sourceIdAppAccount as BK_SOURCE_APP_ACCOUNT,
        s.idUser as BK_USER,
        trn.idExternalUser as BK_EXTERNAL_USER,
        trn.source as SOURCE,
        s.subSource as SUB_SOURCE,
        trn.email as EMAIL,
        trn.extensionVersion as EXTENSION_VERSION,
        trn.user_name as USER_NAME,
        s.status as STATUS,
        trn.externalStatus as EXTERNAL_STATUS,
        trn.role as ROLE,
        s.score as SCORE,
        trn.lastVisitTime as DT_LAST_VISIT,
        s.lastAuthorizationTime as DT_LAST_AUTHORIZATION,
        s.creationTimeInApp as DT_CREATION_TIME_IN_APP,
        s.deletionTime as DT_DELETION,
        (trn.creationTime) as DT_CREATION,
        (trn.updateTime) as DT_UPDATE,
    from source_raw_torii s
    inner join app_user_transform trn
        on (s.id = trn.id))
{# Final Select #}
select * from final