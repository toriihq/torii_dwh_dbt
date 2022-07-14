{%- set source_model = "stage_user" -%}
{%- set src_pk = "HK_USER_ROLE" -%}
{%- set src_fk = ["HK_USER", "HK_ROLE"] -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                 src_source=src_source, source_model=source_model) }}
