{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'workflow') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
contract_fields_transform as
    (select
        t2.id,
        trim(t2.name) as name,
        trim(t2.triggerType) as triggerType,
        to_variant(parse_json(trim(t2.triggerConfiguration))) as triggerConfiguration,
        to_variant(parse_json(trim(t2.actions))) as actions,
        to_variant(parse_json(trim(t2.storage))) as storage,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_WORKFLOW,
        s.idOrg as BK_ORG,
        s.createdBy as BK_WORKFLOW_CREATED_BY,
        s.idApp as BK_APP,
        s.triggerIdApp as BK_TRIGGER_APP,
        s.triggerIdAppAccount as BK_TRIGGER_APP_ACCOUNT,
        trn.name as NAME,
        s.type as WORKFLOW_TYPE,
        trn.triggerType as WORKFLOW_TRIGGER_TYPE,
        trn.triggerConfiguration as TRIGGER_CONFIGURATION,
        trn.actions as ACTIONS,
        trn.storage as STORAGE,
        s.isHiddenForCustomers as IND_HIDDEN_FOR_CUSTOMERS,
        s.isDeleted as IND_DELETED,
        s.isValid as IND_VALID,
        s.isActive as IND_ACTIVE,
        s.lastActivationTime as DT_LAST_ACTIVATION,
        s.lastTriggeredTime as DT_LAST_TRIGGERED,
        trn.creationtime as DT_CREATION,
        trn.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join contract_fields_transform trn
        on (s.id = trn.id))
{# Final Select #}
select * from final