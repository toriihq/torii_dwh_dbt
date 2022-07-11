{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage', 'user') }} as t
    {% if target.name == 'dev' %}
    limit 100
    {% endif %}
    ),
{# Custom Hard busienss rules transforms logic CTE #}
user_transform as
    (select
        t2.id,
        concat(trim(t2.firstname), ' ', trim(t2.lastname)) as user_name,
        trim(t2.status) as status,
        trim(t2.email) as email,
        trim(t2.canonicalemail) as canonicalemail,
        trim(t2.photourl) as photourl,
        trim(t2.lifecyclestatus) as lifecyclestatus,
        to_date(t2.identitysourcesdeletiontime) as identitysourcesdeletiontime,
        to_date(t2.lastseenproductupdatestime) as lastseenproductupdatestime,
        to_date(t2.offboardingstarttime) as offboardingstarttime,
        to_date(t2.offboardingendtime) as offboardingendtime,
        to_date(t2.creationtime) as creationtime,
        to_date(t2.updatetime) as updatetime
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id as BK_USER,
        s.idorg as BK_ORG,
        ut.user_name as BK_ROLE,
        ut.status as BK_OFF_BOARDING_STARTED_BY_USER,
        ut.email as BK_OFF_BOARDING_STARTED_BY_WORKFLOW_ACTION,
        ut.canonicalemail as USER_NAME,
        s.offboardingstartedbyiduser as USER_STATUS,
        s.offboardingstartedbyidworkflowaction as LIFE_CYCLE_STATUS,
        ut.photourl as USER_EMAIL,
        s.idrole as USER_CANONICAL_EMAIL,
        ut.lifecyclestatus as USER_PHOTO_URL,
        s.isrestrictedtoriiadmin as IND_RESTRICTED_TORII_ADMIN,
        s.isdeletedinidentitysources as IND_DELETED_INIDENTITY_SOURCES,
        s.isexternal as IND_USER_EXTERNAL,
        s.istoriiadmin as IND_TORII_ADMIN,
        ut.identitysourcesdeletiontime as DT_IDENTITY_SOURCES_DELETION,
        ut.lastseenproductupdatestime as DT_LAST_SEEN_PRODUCT_UPDATES,
        ut.offboardingstarttime as DT_OFF_BOARDING_START,
        ut.offboardingendtime as DT_OFF_BOARDING_END,
        ut.creationtime as DT_CREATION,
        ut.updatetime as DT_UPDATE
    from source_raw_torii s
    inner join user_transform ut
        on (s.id = ut.id))
{# Final Select #}
select * from final