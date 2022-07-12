{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'workflow_action_execution') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}),
{# Custom Hard busienss rules transforms logic CTE #}
wae_transform as
    (select
        t2.id,
        trim(t2.idaction) as idaction,
        to_variant(parse_json(t2.details)) as details,
        to_variant(parse_json(t2.calculatedruntimeinfo)) as calculatedruntimeinfo,
        trim(t2.actiontype) as actiontype,
        to_variant(parse_json(t2.runtimeinfo)) as runtimeinfo,
        trim(t2.runtimeerror) as runtimeerror,
        trim(t2.executionerrortype) as executionerrortype,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_WORKFLOW_ACTION_EXECUTION,
        s.idapp as BK_APP,
        s.idorg as BK_ORG,
        wae.idaction as BK_ACTION,
        s.idworkflow as BK_WORKFLOW,
        s.idworkflowexecution as BK_WORKFLOW_EXECUTION,
        wae.details as DETAILS,
        wae.calculatedruntimeinfo as CALCULATED_RUN_TIME_INFO,
        wae.actiontype as ACTION_TYPE,
        s.runtime as RUN_TIME,
        wae.runtimeinfo as RUN_TIME_INFO,
        wae.runtimeerror as RUN_TIME_ERROR,
        wae.executionerrortype as EXECUTION_ERROR_TYPE,
        s.errortime as ERROR_TIME,
        s.completiontime as COMPLETION_TIME,
        s.continueonerror as IND_CONTINUE_ON_ERROR,
        s.ignoredtime as IGNORED_TIME,
        s.iscompleted as IND_COMPLETED,
        s.isrun as IND_RUN,
        s.isignored as IND_IGNORED,
        wae.creationtime as DT_CREATION,
        wae.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join wae_transform wae
        on (s.id = wae.id))
{# Final Select #}
select * from final