{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage', 'app') }} as t
    {% if target.name == 'dev' %}
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
        s.id as BK_APP,
        s.idorg as BK_ORG,
        ot.name as BK_APP_NAME,
        ot.description as APP_DESCRIPTION,
        ot.imageurl as APP_IMAGE_URL,
        ot.searchterm as SEARCH_TERM,
        ot.netsuitesearchterm as NET_SUITE_SEARCH_TERM,
        ot.url as APP_URL,
        ot.pricingurl as APP_PRICING_URL,
        ot.category as CATEGORY,
        ot.vendor as VENDOR,
        s.hasintegration as IND_INTEGRATION,
        s.ispublic as IND_PUBLIC,
        s.iscustom as IND_CUSTOM,
        s.isarchived as IND_ARCHIVED,
        ot.creationtime as DT_CREATION,
        ot.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join app_transform ot
        on (s.id = ot.id))
{# Final Select #}
select * from final