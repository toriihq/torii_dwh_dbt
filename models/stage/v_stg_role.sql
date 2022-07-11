{%- set yaml_metadata -%}
source_model: 'raw_stage_role'
derived_columns:
    RECORD_SOURCE: '!raw_stage_role'
    EFFECTIVE_FROM: DT_UPDATE
    START_DATE: DT_CREATION

hashed_columns:
    HK_ROLE: BK_ROLE
    HK_ORG: BK_ORG
    HDIFF_ROLE:
        is_hashdiff: true
        columns:
            - BK_ROLE
            - BK_ORG
            - ROLE_NAME
            - ROLE_DESCRIPTION
            - SYSTEMKEY
            - IND_ADMIN
            - IND_INTERNAL
            - IND_DELETED
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
    HK_ROLE,
    HK_ORG,
    HDIFF_ROLE,
    BK_ROLE,
    BK_ORG,
    ROLE_NAME,
    ROLE_DESCRIPTION,
    SYSTEMKEY,
    IND_ADMIN,
    IND_INTERNAL,
    IND_DELETED,
    DT_CREATION,
    DT_UPDATE,
    RECORD_SOURCE,
    EFFECTIVE_FROM,
    START_DATE,
    TO_DATE({{ dbt_date.now() }}) AS LOAD_DATE
FROM staging