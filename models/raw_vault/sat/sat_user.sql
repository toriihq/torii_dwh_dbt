{%- set source_model = "stage_user" -%}
{%- set src_pk = "HK_USER" -%}
{%- set src_hashdiff = ["HDIFF_USER_DETAILS", "HDIFF_USER_OFF_BOARD"] -%}
{%- set src_payload = ["USER_NAME","USER_STATUS","LIFE_CYCLE_STATUS","USER_EMAIL","USER_CANONICAL_EMAIL",
                        "USER_PHOTO_URL","IND_RESTRICTED_TORII_ADMIN","IND_DELETED_INIDENTITY_SOURCES",
                        "IND_USER_EXTERNAL","IND_TORII_ADMIN","DT_IDENTITY_SOURCES_DELETION",
                        "DT_LAST_SEEN_PRODUCT_UPDATES","DT_OFF_BOARD_START","DT_OFF_BOARD_END"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                src_payload=src_payload, src_eff=src_eff,
                src_ldts=src_ldts, src_source=src_source,
                source_model=source_model) }}


