{%- set yaml_metadata -%}
source_model: 'raw_stage_workflow_action_execution'
derived_columns:
    RECORD_SOURCE: '!raw_stage_workflow_action_execution'
    EFFECTIVE_FROM: DT_CREATION
    START_DATE: DT_CREATION

hashed_columns:
    HK_WORKFLOW_ACTION_EXECUTION: BK_WORKFLOW_ACTION_EXECUTION
    HK_APP: BK_APP
    HK_ORG: BK_ORG
    HK_ACTION: BK_ACTION
    HK_WORKFLOW: BK_WORKFLOW
    HK_WORKFLOW_EXECUTION: BK_WORKFLOW_EXECUTION
    HDIFF_WORKFLOW_ACTION_EXECUTION_DETAILS:
        is_hashdiff: true
        columns:
            - BK_WORKFLOW_ACTION_EXECUTION
            - DETAILS
            - CALCULATED_RUN_TIME_INFO
            - ACTION_TYPE
            - IND_RUN
            - IND_IGNORED
    HDFIF_WORKFLOW_ACTION_EXECUTION_RUN_DETAILS:
            - BK_WORKFLOW_ACTION_EXECUTION
            - RUN_TIME
            - RUN_TIME_INFO
            - RUN_TIME_ERROR
            - EXECUTION_ERROR_TYPE
            - ERROR_TIME
            - COMPLETION_TIME
            - IND_CONTINUE_ON_ERROR
            - IGNORED_TIME
            - IND_COMPLETED

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
    HK_WORKFLOW_ACTION_EXECUTION,
    HK_APP,
    HK_ORG,
    HK_ACTION,
    HK_WORKFLOW,
    HK_WORKFLOW_EXECUTION,
    HDIFF_WORKFLOW_ACTION_EXECUTION_DETAILS,
    HDFIF_WORKFLOW_ACTION_EXECUTION_RUN_DETAILS,
    BK_WORKFLOW_ACTION_EXECUTION,
    BK_APP,
    BK_ORG,
    BK_ACTION,
    BK_WORKFLOW,
    BK_WORKFLOW_EXECUTION,
    DETAILS,
    CALCULATED_RUN_TIME_INFO,
    ACTION_TYPE,
    RUN_TIME,
    RUN_TIME_INFO,
    RUN_TIME_ERROR,
    EXECUTION_ERROR_TYPE,
    ERROR_TIME,
    COMPLETION_TIME,
    IND_CONTINUE_ON_ERROR,
    IGNORED_TIME,
    IND_COMPLETED,
    IND_RUN,
    IND_IGNORED,
    DT_CREATION,
    DT_UPDATE,
    RECORD_SOURCE,
    EFFECTIVE_FROM,
    START_DATE,
    TO_DATE({{ dbt_date.now() }}) AS LOAD_DATE
FROM staging