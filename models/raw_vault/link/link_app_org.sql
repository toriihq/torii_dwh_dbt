{%- set source_model = "stage_app" -%}
{%- set src_pk = "HK_APP_ORG" -%}
{%- set src_fk = ["HK_APP", "HK_ORG"] -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                 src_source=src_source, source_model=source_model) }}