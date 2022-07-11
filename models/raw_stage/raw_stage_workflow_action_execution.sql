{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage', 'workflow_action_execution') }} as t
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
        trim(t2.runtimeinfo) as runtimeinfo,
        trim(t2.runtimeerror) as runtimeerror,
        trim(t2.executionerrortype) as executionerrortype,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as bk_workflow_action_execution,
        s.idapp as bk_app,
        s.idorg as bk_org,
        wae.idaction as bk_action,
        s.idworkflow as bk_workflow,
        s.idworkflowexecution as bk_workflow_execution,
        wae.details as details,
        wae.calculatedruntimeinfo as calculated_run_time_info,
        wae.actiontype as action_type,
        s.runtime as run_time,
        wae.runtimeinfo as run_time_info,
        wae.runtimeerror as run_time_error,
        wae.executionerrortype as execution_error_type,
        s.errortime as error_time,
        s.completiontime as completion_time,
        s.continueonerror as continue_on_error,
        s.ignoredtime as ignored_time,
        s.iscompleted as ind_completed,
        s.isrun as ind_run,
        s.isignored as ind_ignored,
        wae.creationtime as dt_creation,
        wae.updatetime as dt_update
    from source_raw_torii s
    inner join wae_transform wae
        on (s.id = wae.id))
{# Final Select #}
select * from final