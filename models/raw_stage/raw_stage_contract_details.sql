{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'contract_details') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
contract_details_transform as
    (select
        t2.id,
        trim(t2.value) as value ,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_CONTRACT_DETAILS,
        s.idOrg as BK_ORG,
        s.idContract as BK_CONTRACT,
        s.idField as BK_FIELD,
        s.performedBy as BK_CONTRACT_PERFORMED_BY,
        s.idWorkflowActionExecution as BK_WORK_FLOW_ACTION_EXECUTION,
        s.idUpload as BK_UPLOAD,
        trn.value as VALUE,
        s.isDeleted as IND_DELETED,
        trn.creationtime as DT_CREATION,
        trn.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join contract_details_transform trn
        on (s.id = trn.id))
{# Final Select #}
select * from final