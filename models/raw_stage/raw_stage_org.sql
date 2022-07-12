{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'org') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
),
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
        to_variant(parse_json(t2.USERLIFECYCLECONFIG)) as userlifecycleconfig,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime,
        to_date(t2.trialendtime) as dt_trial_end ,
        to_date(t2.paidplanendtime) as dt_paid_plan
from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_ORG,
        ot.domain as ORG_DOMAIN,
        ot.companyname as COMPANY_NAME,
        ot.nickname as ORG_NICK_NAME,
        ot.emailalias as ORG_EMAIL_ALIAS,
        ot.logourl as ORG_LOGO_URL,
        ot.extensionmode as EXTENSION_MODE,
        ot.defaultcurrency as DEFAULT_CURRENCY,
        ot.userlifecycleconfig as USER_LIFE_CYCLE_CONFIG,
        s.appnotinuseperiod as APP_NOT_IN_USER_PERIOD,
        ot.dt_trial_end as DT_TRIAL_END,
        ot.dt_paid_plan as DT_PAID_PLAN,
        s.inactivitytimeout as INACTIVITY_TIMEOUT,
        s.isdemo as IND_DEMO,
        s.iswhitelabel as IND_WHITE_LABEL,
        s.isdisabled as IND_DISABLED,
        ot.creationtime as DT_CREATION,
        ot.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join org_transform ot
        on (s.id = ot.id))
{# Final Select #}
select * from final