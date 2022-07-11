{%- set yaml_metadata -%}
source_model: 'raw_stage_user'
derived_columns:
    RECORD_SOURCE: '!raw_stage_user'
    EFFECTIVE_FROM: DT_UPDATE
    START_DATE: DT_CREATION

hashed_columns:
    HK_USER: BK_USER
    HK_ORG: BK_ORG
    HK_ROLE: BK_ROLE
    HK_OFF_BOARDING_STARTED_BY_USER: BK_OFF_BOARDING_STARTED_BY_USER
    HK_OFF_BOARDING_STARTED_BY_WORKFLOW_ACTION: BK_OFF_BOARDING_STARTED_BY_WORKFLOW_ACTION
    HDIFF_USER_DETAILS:
        is_hashdiff: true
        columns:
            - BK_USER
            - BK_ORG
            - BK_ROLE
            - USER_NAME
            - USER_STATUS
            - LIFE_CYCLE_STATUS
            - USER_EMAIL
            - USER_CANONICAL_EMAIL
            - USER_PHOTO_URL
            - IND_RESTRICTED_TORII_ADMIN
            - IND_DELETED_INIDENTITY_SOURCES
            - IND_USER_EXTERNAL
            - IND_TORII_ADMIN
            - DT_IDENTITY_SOURCES_DELETION
            - DT_LAST_SEEN_PRODUCT_UPDATES
            - DT_OFF_BOARDING_START
            - DT_OFF_BOARDING_END
            - EFFECTIVE_FROM

    HDIFF_USER_OFFBOARDING:
        is_hashdiff: true
        columns:
            - BK_OFF_BOARDING_STARTED_BY_USER
            - BK_OFF_BOARDING_STARTED_BY_WORKFLOW_ACTION
            - DT_OFF_BOARDING_START
            - DT_OFF_BOARDING_END

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
    HK_USER,
    HK_ORG,
    HK_ROLE,
    HK_OFF_BOARDING_STARTED_BY_USER,
    HK_OFF_BOARDING_STARTED_BY_WORKFLOW_ACTION,
    HDIFF_USER_DETAILS,
    HDIFF_USER_OFFBOARDING,
    BK_USER,
    BK_ORG,
    BK_ROLE,
    BK_OFF_BOARDING_STARTED_BY_USER,
    BK_OFF_BOARDING_STARTED_BY_WORKFLOW_ACTION,
    USER_NAME,
    USER_STATUS,
    LIFE_CYCLE_STATUS,
    USER_EMAIL,
    USER_CANONICAL_EMAIL,
    USER_PHOTO_URL,
    IND_RESTRICTED_TORII_ADMIN,
    IND_DELETED_INIDENTITY_SOURCES,
    IND_USER_EXTERNAL,
    IND_TORII_ADMIN,
    DT_IDENTITY_SOURCES_DELETION,
    DT_LAST_SEEN_PRODUCT_UPDATES,
    DT_OFF_BOARDING_START,
    DT_OFF_BOARDING_END,
    DT_CREATION,
    DT_UPDATE,
    RECORD_SOURCE,
    EFFECTIVE_FROM,
    START_DATE,
    TO_DATE({{ dbt_date.now() }}) AS LOAD_DATE
from staging