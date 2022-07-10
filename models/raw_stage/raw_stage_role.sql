{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage', 'role') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
    ),
{# Custom Hard busienss rules transforms logic CTE #}
role_transform as
    (select
        t2.id,
        trim(t2.name) as name,
        trim(t2.description) as description,
        trim(t2.systemkey) as systemkey
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id,
        s.idorg,
        rt.name,
        rt.description,
        rt.systemkey,
        s.isadmin,
        s.isinternal,
        s.isdeleted,
        s.creationtime,
        s.updatetime
    from source_raw_torii s
    inner join role_transform rt
        on (s.id = rt.id))
{# Final Select #}
select * from final