{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'app_token') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
app_token_transform as
    (select
        t2.id,
        trim(t2.idExternalUser) as idExternalUser,
        trim(t2.source) as source,
        trim(t2.type) as type,
        trim(t2.permission) as permission,
        trim(t2.scope) as scope,
        trim(t2.accessUrl) as accessUrl,
        trim(t2.syncStatus) as syncStatus,
        trim(t2.syncError) as syncError,
        trim(t2.errorMessage) as errorMessage,
        trim(t2.runtimeError) as runtimeError,
        trim(t2.runtimeUsageError) as runtimeUsageError,
        trim(t2.devComments) as devComments,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_APP_TOKEN,
        s.idOrg as BK_ORG,
        s.idUser as BK_USER,
        s.idApp as BK_APP,
        s.idAppAccount as BK_APP_ACCOUNT,
        s.idExternalUser as BK_EXTERNAL_USER,
        trn.source as SOURCE,
        trn.type as TYPE,
        trn.permission as PERMISSION,
        trn.scope as SCOPE,
        trn.accessUrl as ACCESS_URL,
        trn.syncStatus as SYNC_STATUS,
        s.syncRetries as SYNC_RETRIES,
        trn.syncError as SYNC_ERROR,
        trn.errorMessage as ERROR_MESSAGE,
        trn.runtimeError as RUNTIME_ERROR,
        trn.runtimeUsageError as RUNTIME_USAGE_ERROR,
        trn.devComments as DEV_COMMENTS,
        s.expirationTime as EXPIRATION_TIME,
        s.connectionTime as CONNECTION_TIME,
        s.isEnabled as IND_ENABLED,
        s.connectedViaLink as IND_CONNECTED_VIA_LINK,
        trn.creationTime as DT_CREATION,
        trn.updateTime as DT_UPDATE
    from source_raw_torii s
    inner join app_token_transform trn
        on (s.id = trn.id))
{# Final Select #}
select * from final