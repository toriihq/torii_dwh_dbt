{% snapshot app_snapshot %}

        {{
            config(
              target_database='TORII_DWH_DEV',
              target_schema='RAW_STAGE_SNAPSHOTS',
              unique_key='ID',

              strategy='timestamp',
              updated_at='UPDATETIME',
            )
        }}

        select * from {{ source('raw_torii', 'app') }}

{% endsnapshot %}
