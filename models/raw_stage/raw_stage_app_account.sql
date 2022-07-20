{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'app_account') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
app_account_transform as
    (select
        t2.id,
        trim(t2.nameBySyncer) as nameBySyncer,
        trim(t2.nameByUser) as nameByUser,
        trim(t2.idExternal) as idExternal,
        to_variant(parse_json(trim(t2.config))) as config,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        (s.id) as BK_APP_ACCOUNT,
        (trn.idOrg) as BK_ORG,
        (trn.idApp) as BK_APP,
        (trn.isCustom) as IND_CUSTOM,
        (s.nameBySyncer) as NAME_BY_SYNCER,
        (s.nameByUser) as NAME_BY_USER,
        (s.idExternal) as BK_EXTERNAL,
        (s.config) as CONFIG,
        (trn.lastSyncTime) as DT_LAST_SYNC,
        (trn.lastExpenseTime) as DT_LAST_EXPENSE,
        (trn.lastEventTime) as DT_LAST_EVENT,
        (trn.creationTime) as DT_CREATION,
        (trn.updateTime) as DT_UPDATE,
    from source_raw_torii s
    inner join app_account_transform trn
        on (s.id = trn.id))
{# Final Select #}
select * from final