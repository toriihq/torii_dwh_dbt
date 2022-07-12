{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'role') }} as t
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
        s.id as BK_ROLE,
        s.idorg as BK_ORG,
        rt.name as ROLE_NAME,
        rt.description as ROLE_DESCRIPTION,
        rt.systemkey as SYSTEMKEY,
        s.isadmin as IND_ADMIN,
        s.isinternal as IND_INTERNAL,
        s.isdeleted as IND_DELETED,
        s.creationtime as DT_CREATION,
        s.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join role_transform rt
        on (s.id = rt.id))
{# Final Select #}
select * from final