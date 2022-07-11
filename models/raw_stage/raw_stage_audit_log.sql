{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage', 'audit_log') }} as t
    {% if target.name == 'raw_stage_dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
user_transform as
    (select
        t2.id,
        trim(t2.type) as type,
        to_variant(parse_json(t2.properties)) as properties,
        to_date(t2.creationtime) as creationtime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as bk_audit_log,
        s.idtargetorg as bk_target_org,
        s.idtargetapp as bk_target_app,
        s.idtargetuser as bk_target_user,
        s.performedby as bk_user_ran_action,
        ut.type as type,
        ut.properties as properties,
        s.creationtime as dt_creation
    from source_raw_torii s
    inner join user_transform ut
        on (s.id = ut.id))
{# Final Select #}
select * from final