{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage', 'app') }} as t
    {% if target.name == 'raw_stage_dev' %}
    limit 100
    {% endif %}
),
{# Custom Hard busienss rules transforms logic CTE #}
app_transform as
    (select
        t2.id,
        trim(t2.name) as name ,
        trim(t2.description) as description ,
        trim(t2.imageurl) as imageurl ,
        trim(t2.searchterm) as searchterm ,
        trim(t2.netsuitesearchterm) as netsuitesearchterm ,
        trim(t2.url) as url ,
        trim(t2.pricingurl) as pricingurl ,
        trim(t2.category) as category ,
        trim(t2.vendor) as vendor,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as bk_app,
        s.idorg as bk_org,
        ot.name as bk_app_name,
        ot.description as app_description,
        ot.imageurl as app_image_url,
        ot.searchterm as search_term,
        ot.netsuitesearchterm as net_suite_search_term,
        ot.url as app_url,
        ot.pricingurl as app_pricing_url,
        ot.category as category,
        ot.vendor as vendor,
        s.hasintegration as ind_integration,
        s.ispublic as ind_public,
        s.iscustom as ind_custom,
        s.isarchived as ind_archived,
        ot.creationtime as dt_creation,
        ot.updatetime as dt_update
    from source_raw_torii s
    inner join app_transform ot
        on (s.id = ot.id))
{# Final Select #}
select * from final