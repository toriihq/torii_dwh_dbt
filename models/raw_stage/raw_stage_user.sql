{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_torii', 'user') }} as t
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
        s.ID as bk_user,
        s.IDORG as bk_org,
        s.IDROLE as bk_role,
        s.OFFBOARDINGSTARTEDBYIDUSER as bk_off_board_by_user,
        s.OFFBOARDINGSTARTEDBYIDWORKFLOWACTION as bk_off_board_by_workflow_action,
        ut.user_name as user_name,
        ut.STATUS as user_status,
        ut.LIFECYCLESTATUS as life_cycle_status,
        ut.EMAIL as user_email,
        ut.CANONICALEMAIL as user_canonical_email,
        ut.PHOTOURL as user_photo_url,
        s.ISRESTRICTEDTORIIADMIN as ind_restricted_torii_admin,
        s.ISDELETEDINIDENTITYSOURCES as ind_deleted_inidentity_sources,
        s.ISEXTERNAL as ind_user_external,
        s.ISTORIIADMIN as ind_torii_admin,
        ut.IDENTITYSOURCESDELETIONTIME as dt_identity_sources_deletion,
        ut.LASTSEENPRODUCTUPDATESTIME as dt_last_seen_product_updates,
        ut.OFFBOARDINGSTARTTIME as dt_off_board_start,
        ut.OFFBOARDINGENDTIME as dt_off_board_end,
        ut.CREATIONTIME as dt_creation,
        ut.UPDATETIME as dt_update
    from source_raw_torii s
    inner join user_transform ut
        on (s.id = ut.id))
{# Final Select #}
select * from final