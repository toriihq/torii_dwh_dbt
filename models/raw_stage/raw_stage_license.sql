{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'license') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
contract_fields_transform as
    (select
        t2.id,
        trim(t2.type),
        trim(t2.name),
        trim(t2.uniqueKey),
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_LICENSE,
        s.idOrg as BK_ORG,
        s.idApp as BK_APP,
        s.type as TYPE,
        s.name as NAME,
        s.uniqueKey as UNIQUE_KEY,
        s.isPaid as IND_PAID,
        trn.creationtime as DT_CREATION,
        trn.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join contract_fields_transform trn
        on (s.id = trn.id))
{# Final Select #}
select * from final