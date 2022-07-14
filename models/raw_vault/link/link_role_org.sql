{%- set source_model = "stage_role" -%}
{%- set src_pk = "HK_ROLE_ORG" -%}
{%- set src_fk = ["HK_ORG", "HK_ROLE"] -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                 src_source=src_source, source_model=source_model) }}