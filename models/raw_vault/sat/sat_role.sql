{%- set source_model = "stage_role" -%}
{%- set src_pk = "HK_ROLE" -%}
{%- set src_hashdiff = "HDIFF_ROLE" -%}
{%- set src_payload = ["ROLE_NAME","ROLE_DESCRIPTION","SYSTEMKEY","IND_ADMIN","IND_INTERNAL","IND_DELETED"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                src_payload=src_payload, src_eff=src_eff,
                src_ldts=src_ldts, src_source=src_source,
                source_model=source_model) }}


