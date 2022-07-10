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
        trim(t2.calculatedruntimeinfo) as calculatedruntimeinfo,
        trim(t2.actiontype) as actiontype,
        trim(t2.runtimeinfo) as runtimeinfo,
        trim(t2.runtimeerror) as runtimeerror,
        trim(t2.executionerrortype) as executionerrortype
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id,
        s.idapp,
        s.idorg,
        wae.idaction,
        s.idworkflow,
        s.idworkflowexecution,
        wae.details,
        wae.calculatedruntimeinfo,
        wae.actiontype,
        s.runtime,
        wae.runtimeinfo,
        wae.runtimeerror,
        wae.executionerrortype,
        s.errortime,
        s.completiontime,
        s.continueonerror,
        s.ignoredtime,
        s.iscompleted,
        s.isrun,
        s.isignored,
        s.creationtime,
        s.updatetime
    from source_raw_torii s
    inner join wae_transform wae
        on (s.id = wae.id))
{# Final Select #}
select * from final