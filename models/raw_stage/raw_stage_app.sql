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
        trim(t2.vendor) as vendor
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id,
        s.idorg,
        ot.name,
        ot.description,
        ot.imageurl,
        ot.searchterm,
        ot.netsuitesearchterm,
        ot.url,
        ot.pricingurl,
        ot.category,
        ot.vendor,
        s.hasintegration,
        s.ispublic,
        s.iscustom,
        s.isarchived,
        s.creationtime,
        s.updatetime
    from source_raw_torii s
    inner join app_transform ot
        on (s.id = ot.id))
{# Final Select #}
select * from final