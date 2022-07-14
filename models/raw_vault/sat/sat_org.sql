{%- set source_model = "stage_org" -%}
{%- set src_pk = "HK_ORG" -%}
{%- set src_hashdiff = "HDIFF_ORG" -%}
{%- set src_payload = ["ORG_DOMAIN","COMPANY_NAME","ORG_NICK_NAME","ORG_EMAIL_ALIAS","ORG_LOGO_URL","EXTENSION_MODE",
                        "DEFAULT_CURRENCY","USER_LIFE_CYCLE_CONFIG","APP_NOT_IN_USER_PERIOD","DT_TRIAL_END",
                        "DT_PAID_PLAN","INACTIVITY_TIMEOUT","IND_DEMO","IND_WHITE_LABEL","IND_DISABLED"] -%}
{%- set src_eff = "EFFECTIVE_FROM" -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ dbtvault.sat(src_pk=src_pk, src_hashdiff=src_hashdiff,
                src_payload=src_payload, src_eff=src_eff,
                src_ldts=src_ldts, src_source=src_source,
                source_model=source_model) }}

