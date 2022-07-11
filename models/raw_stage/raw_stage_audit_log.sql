{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage', 'audit_log') }} as t
    {% if target.name == 'dev' %}
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
        s.id as BK_AUDIT_LOG,
        s.idtargetorg as BK_TARGET_ORG,
        s.idtargetapp as BK_TARGET_APP,
        s.idtargetuser as BK_TARGET_USER,
        s.performedby as BK_USER_RAN_ACTION,
        ut.type as TYPE,
        ut.properties as PROPERTIES,
        s.creationtime as DT_CREATION
    from source_raw_torii s
    inner join user_transform ut
        on (s.id = ut.id))
{# Final Select #}
select * from final