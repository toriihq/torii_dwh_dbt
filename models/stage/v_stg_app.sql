{%- set yaml_metadata -%}
source_model: 'raw_stage_app'
derived_columns:
    RECORD_SOURCE: '!raw_stage_app'
    EFFECTIVE_FROM: DT_UPDATE
    START_DATE: DT_CREATION

hashed_columns:
    HK_APP: BK_APP
    HK_ORG: BK_ORG
    HDIFF_APP:
        is_hashdiff: true
        columns:
            - BK_APP
            - BK_ORG
            - BK_APP_NAME
            - APP_DESCRIPTION
            - APP_IMAGE_URL
            - SEARCH_TERM
            - NET_SUITE_SEARCH_TERM
            - APP_URL
            - APP_PRICING_URL
            - CATEGORY
            - VENDOR
            - IND_INTEGRATION
            - IND_PUBLIC
            - IND_CUSTOM
            - IND_ARCHIVED
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
    HK_APP,
    HK_ORG,
    HDIFF_APP,
    BK_APP,
    BK_ORG,
    BK_APP_NAME,
    APP_DESCRIPTION,
    APP_IMAGE_URL,
    SEARCH_TERM,
    NET_SUITE_SEARCH_TERM,
    APP_URL,
    APP_PRICING_URL,
    CATEGORY,
    VENDOR,
    IND_INTEGRATION,
    IND_PUBLIC,
    IND_CUSTOM,
    IND_ARCHIVED,
    DT_CREATION,
    DT_UPDATE,
    RECORD_SOURCE,
    EFFECTIVE_FROM,
    START_DATE,
    TO_DATE({{ dbt_date.now() }}) AS LOAD_DATE
FROM staging