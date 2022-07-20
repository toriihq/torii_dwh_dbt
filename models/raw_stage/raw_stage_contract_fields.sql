{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'contract_fields') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
contract_fields_transform as
    (select
        t2.id,
        trim(t2.name) as name,
        trim(t2.formQuestion) as formQuestion,
        trim(t2.systemKey) as systemKey,
        trim(t2.category) as category,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_CONTRACT_FIELDS,
        s.idOrg as BK_ORG,
        s.idGroup as BK_GROUP,
        trn.name as NAME,
        trn.formQuestion as FORM_QUESTION,
        trn.systemKey as SYSTEM_KEY,
        s.type as TYPE,
        s.position as POSITION,
        trn.category as CATEGORY,
        s.isCalculated as IND_CALCULATED,
        s.isReadonly as IND_READ_ONLY,
        trn.creationtime as DT_CREATION,
        trn.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join contract_fields_transform trn
        on (s.id = trn.id))
{# Final Select #}
select * from final