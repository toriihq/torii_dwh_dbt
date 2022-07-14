{%- set source_model = "v_stg_user" -%}
{%- set src_pk = "HK_USER" -%}
{%- set src_nk = "BK_USER" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                src_source=src_source, source_model=source_model) }}