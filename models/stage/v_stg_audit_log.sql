{%- set yaml_metadata -%}
source_model: 'raw_stage_audit_log'
derived_columns:
    RECORD_SOURCE: '!raw_stage_audit_log'
    EFFECTIVE_FROM: DT_CREATION
    START_DATE: DT_CREATION

hashed_columns:
    HK_AUDIT_LOG: BK_AUDIT_LOG
    HK_TARGET_ORG: BK_TARGET_ORG
    HK_TARGET_APP: BK_TARGET_APP
    HK_TARGET_USER: BK_TARGET_USER
    HK_USER_PERFORM: BK_USER_RAN_ACTION
    HDIFF_AUDIT_LOG:
        is_hashdiff: true
        columns:
            - BK_AUDIT_LOG
            - BK_TARGET_ORG
            - BK_TARGET_APP
            - BK_TARGET_USER
            - BK_USER_RAN_ACTION
            - TYPE
            - PROPERTIES
            - DT_CREATION
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
    HK_AUDIT_LOG,
    HK_TARGET_ORG,
    HK_TARGET_APP,
    HK_TARGET_USER,
    HK_USER_PERFORM,
    HDIFF_AUDIT_LOG,
    BK_AUDIT_LOG,
    BK_TARGET_ORG,
    BK_TARGET_APP,
    BK_TARGET_USER,
    BK_USER_RAN_ACTION,
    TYPE,
    PROPERTIES,
    DT_CREATION,
    RECORD_SOURCE,
    EFFECTIVE_FROM,
    START_DATE,
    TO_DATE({{ dbt_date.now() }}) AS LOAD_DATE
FROM staging