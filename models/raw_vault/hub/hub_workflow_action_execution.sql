{%- set source_model = "stage_workflow_action_execution" -%}
{%- set src_pk = "HK_WORKFLOW_ACTION_EXECUTION" -%}
{%- set src_nk = ["BK_WORKFLOW_ACTION_EXECUTION", "BK_WORKFLOW", "BK_ACTION"] -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}