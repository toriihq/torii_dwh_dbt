{%- set source_model = "stage_app" -%}
{%- set src_pk = "HK_APP" -%}
{%- set src_hashdiff = "HDIFF_APP" -%}
{%- set src_payload = ["APP_NAME", "APP_DESCRIPTION", "APP_IMAGE_URL", "SEARCH_TERM", "NET_SUITE_SEARCH_TERM", "APP_URL",
                        "APP_PRICING_URL", "CATEGORY", "VENDOR", "IND_INTEGRATION", "IND_PUBLIC",
                        "IND_CUSTOM","IND_ARCHIVED"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                src_payload=src_payload, src_eff=src_eff,
                src_ldts=src_ldts, src_source=src_source,
                source_model=source_model) }}
