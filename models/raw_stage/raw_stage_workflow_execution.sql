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
        trim(t2.workflowName) as workflowName,
        to_variant(parse_json(trim(t2.actions))) as actions,
        trim(t2.triggerType) as triggerType,
        to_variant(parse_json(trim(t2.triggerOutput))) as triggerOutput,
        trim(t2.uniqueKey) as uniqueKey,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_WORKFLOW_EXECUTION,
        s.idOrg as BK_ORG,
        s.idWorkflow as BK_WORKFLOW,
        s.idUser as BK_USER,
        s.idWorkflowExecutionGroup as BK_WORKFLOW_EXECUTION_GROUP,
        s.triggeredBy as BK_TRIGGERED_BY,
        trn.workflowName as WORKFLOW_NAME,
        s.type as TYPE,
        trn.actions as ACTIONS,
        trn.triggerType as TRIGGER_TYPE,
        trn.triggerOutput as TRIGGER_OUTPUT,
        trn.uniqueKey as UNIQUE_KEY,
        s.isCompleted as IND_COMPLETED,
        s.isIgnored as IND_IGNORED,
        s.completionTime as DT_COMPLETION,
        s.ignoredTime as DT_IGNORED,
        trn.creationtime as DT_CREATION,
        trn.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join contract_fields_transform trn
        on (s.id = trn.id))
{# Final Select #}
select * from final