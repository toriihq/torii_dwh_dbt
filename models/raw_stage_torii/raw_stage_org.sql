{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage_torii', 'org') }} as t
    limit 100),
{# Custom Hard busienss rules transforms logic CTE #}
org_transform as
    (select
        t2.id,
        trim(t2.DOMAIN) as DOMAIN,
        trim(t2.COMPANYNAME) as COMPANYNAME,
        trim(t2.NICKNAME) as NICKNAME,
        trim(t2.EMAILALIAS) as EMAILALIAS,
        trim(t2.LOGOURL) as LOGOURL,
        trim(t2.EXTENSIONMODE) as EXTENSIONMODE,
        trim(t2.DEFAULTCURRENCY) as DEFAULTCURRENCY,
        to_variant(parse_json(t2.USERLIFECYCLECONFIG)) as userlifecycleconfig
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id,
        ot.domain,
        ot.companyname,
        ot.nickname,
        ot.emailalias,
        ot.logourl,
        ot.extensionmode,
        ot.userlifecycleconfig,
        s.appnotinuseperiod,
        ot.defaultcurrency,
        s.inactivitytimeout,
        s.isdemo,
        s.iswhitelabel,
        s.isonboarded,
        s.isdisabled,
        s.paidplanendtime,
        s.trialendtime,
        s.creationtime,
        s.updatetime
    from source_raw_torii s
    inner join org_transform ot
        on (s.id = ot.id))
{# Final Select #}
select * from final