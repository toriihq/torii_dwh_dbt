{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'contract') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
contract_transform as
    (select
        t2.id,
        trim(t2.source) as source ,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_CONTRACT,
        s.idOrg as BK_ORG,
        s.idApp as BK_APP,
        s.createdBy as BK_CONTRACT_CREATED_BY,
        trim(s.source) as SOURCE,
        s.isDeleted as IND_DELETED,
        ot.creationtime as DT_CREATION,
        ot.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join contract_transform ot
        on (s.id = ot.id))
{# Final Select #}
select * from final