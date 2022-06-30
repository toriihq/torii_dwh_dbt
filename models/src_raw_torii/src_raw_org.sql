with source_raw_torii as (
    select * from {{ source('src_raw_torii', 'org') }} limit 100
),

final as
    (select
        *
    from source_raw_torii)

select * from final