{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage', 'role') }} as t
    {% if target.name == 'raw_stage_dev' %}
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
        s.id as bk_role,
        s.idorg as bk_org,
        rt.name as role_name,
        rt.description as role_description,
        rt.systemkey as systemkey,
        s.isadmin as ind_admin,
        s.isinternal as ind_internal,
        s.isdeleted as ind_deleted,
        s.creationtime as dt_creation,
        s.updatetime as dt_update
    from source_raw_torii s
    inner join role_transform rt
        on (s.id = rt.id))
{# Final Select #}
select * from final