{%- set source_model = "stage_workflow_action_execution" -%}
{%- set src_pk = "HK_WORKFLOW_ACTION_EXECUTION" -%}
{%- set src_fk = ["HK_APP","HK_ORG","HK_ACTION","HK_WORKFLOW","HK_WORKFLOW_EXECUTION"] -%}
{%- set src_payload = ["DETAILS","CALCULATED_RUN_TIME_INFO","ACTION_TYPE","RUN_TIME","RUN_TIME_INFO","RUN_TIME_ERROR",
                        "EXECUTION_ERROR_TYPE","ERROR_TIME","COMPLETION_TIME","IND_CONTINUE_ON_ERROR","IGNORED_TIME",
                        "IND_COMPLETED","IND_RUN","IND_IGNORED"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.t_link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                   src_payload=src_payload, src_eff=src_eff,
                   src_source=src_source, source_model=source_model) }}


