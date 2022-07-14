{%- set source_model = "stage_audit_log" -%}
{%- set src_pk = "HK_AUDIT_LOG" -%}
{%- set src_fk = ["HK_TARGET_ORG","HK_TARGET_APP","HK_TARGET_USER","HK_USER_PERFORM"] -%}
{%- set src_payload = ["TYPE","PROPERTIES"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.t_link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                   src_payload=src_payload, src_eff=src_eff,
                   src_source=src_source, source_model=source_model) }}

