{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage_torii', 'audit_log') }} as t
    limit 100),
{# Custom Hard busienss rules transforms logic CTE #}
user_transform as
    (select
        t2.id,
        trim(t2.type) as type,
        to_variant(parse_json(t2.properties))
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id,
        s.idtargetorg,
        s.idtargetapp,
        s.idtargetuser,
        s.performedby,
        ut.type,
        ut.properties,
        s.creationtime,
    from source_raw_torii s
    inner join user_transform ut
        on (s.id = ut.id))
{# Final Select #}
select * from final