{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'user') }} as t
    {% if target.name == 'dev' %}
    where
        OFFBOARDINGSTARTEDBYIDUSER is not null or
        OFFBOARDINGSTARTEDBYIDWORKFLOWACTION is not null
    limit 1000
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
        s.ID as BK_USER,
        s.IDORG as BK_ORG,
        s.IDROLE as BK_ROLE,
        s.OFFBOARDINGSTARTEDBYIDUSER as BK_OFF_BOARD_BY_USER,
        s.OFFBOARDINGSTARTEDBYIDWORKFLOWACTION as BK_OFF_BOARD_BY_WORKFLOW_ACTION,
        ut.user_name as USER_NAME,
        ut.STATUS as USER_STATUS,
        ut.LIFECYCLESTATUS as LIFE_CYCLE_STATUS,
        ut.EMAIL as USER_EMAIL,
        ut.CANONICALEMAIL as USER_CANONICAL_EMAIL,
        ut.PHOTOURL as USER_PHOTO_URL,
        s.ISRESTRICTEDTORIIADMIN as IND_RESTRICTED_TORII_ADMIN,
        s.ISDELETEDINIDENTITYSOURCES as IND_DELETED_INIDENTITY_SOURCES,
        s.ISEXTERNAL as IND_USER_EXTERNAL,
        s.ISTORIIADMIN as IND_TORII_ADMIN,
        ut.IDENTITYSOURCESDELETIONTIME as DT_IDENTITY_SOURCES_DELETION,
        ut.LASTSEENPRODUCTUPDATESTIME as DT_LAST_SEEN_PRODUCT_UPDATES,
        ut.OFFBOARDINGSTARTTIME as DT_OFF_BOARD_START,
        ut.OFFBOARDINGENDTIME as DT_OFF_BOARD_END,
        ut.CREATIONTIME as DT_CREATION,
        ut.UPDATETIME as DT_UPDATE
    from source_raw_torii s
    inner join user_transform ut
        on (s.id = ut.id))
{# Final Select #}
select * from final