{# Imports #}
with source_raw_torii as
    (select
        *
    from {{ source('raw_stage_torii', 'user') }} as t
    limit 100),
{# Custom Hard busienss rules transforms logic CTE #}
user_transform as
    (select
        t2.id,
        trim(t2.firstname) as firstname,
        trim(t2.lastname) as lastname,
        trim(t2.status) as status,
        trim(t2.email) as email,
        trim(t2.canonicalemail) as canonicalemail,
        trim(t2.photourl) as photourl,
        trim(t2.lifecyclestatus) as lifecyclestatus
    from source_raw_torii t2),
{# Final CTE #}
final as
    (select
        s.id,
        s.idorg,
        ut.firstname,
        ut.lastname,
        ut.status,
        ut.email,
        ut.canonicalemail,
        s.offboardingstartedbyiduser,
        s.offboardingstartedbyidworkflowaction,
        ut.photourl,
        s.idrole,
        ut.lifecyclestatus,
        s.isrestrictedtoriiadmin,
        s.isdeletedinidentitysources,
        s.isexternal,
        s.istoriiadmin,
        s.identitysourcesdeletiontime,
        s.lastseenproductupdatestime,
        s.offboardingstarttime,
        s.offboardingendtime,
        s.creationtime,
        s.updatetime
    from source_raw_torii s
    inner join user_transform ut
        on (s.id = ut.id))
{# Final Select #}
select * from final