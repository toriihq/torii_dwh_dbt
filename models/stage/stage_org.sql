{%- set yaml_metadata -%}
source_model: 'raw_stage_org'
derived_columns:
    RECORD_SOURCE: '!raw_stage_org'
    EFFECTIVE_FROM: DT_UPDATE
    START_DATE: DT_CREATION

hashed_columns:
    HK_ORG: BK_ORG
    HDIFF_ORG:
        is_hashdiff: true
        columns:
            - BK_ORG
            - ORG_DOMAIN
            - COMPANY_NAME
            - ORG_NICK_NAME
            - ORG_EMAIL_ALIAS
            - ORG_LOGO_URL
            - EXTENSION_MODE
            - DEFAULT_CURRENCY
            - USER_LIFE_CYCLE_CONFIG
            - APP_NOT_IN_USER_PERIOD
            - DT_TRIAL_END
            - DT_PAID_PLAN
            - INACTIVITY_TIMEOUT
            - IND_DEMO
            - IND_WHITE_LABEL
            - IND_DISABLED
            - EFFECTIVE_FROM

{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict['source_model'] %}
{% set hashed_columns = metadata_dict['hashed_columns'] %}
{% set derived_columns = metadata_dict['derived_columns'] %}

WITH staging AS (
{{ dbtvault.stage(include_source_columns=true,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=none) }}
)

SELECT
    HK_ORG,
    HDIFF_ORG,
    BK_ORG,
    ORG_DOMAIN,
    COMPANY_NAME,
    ORG_NICK_NAME,
    ORG_EMAIL_ALIAS,
    ORG_LOGO_URL,
    EXTENSION_MODE,
    DEFAULT_CURRENCY,
    USER_LIFE_CYCLE_CONFIG,
    APP_NOT_IN_USER_PERIOD,
    DT_TRIAL_END,
    DT_PAID_PLAN,
    INACTIVITY_TIMEOUT,
    IND_DEMO,
    IND_WHITE_LABEL,
    IND_DISABLED,
    DT_CREATION,
    DT_UPDATE,
    RECORD_SOURCE,
    EFFECTIVE_FROM,
    START_DATE,
    TO_DATE({{ dbt_date.now() }}) AS LOAD_DATE
FROM staging
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}