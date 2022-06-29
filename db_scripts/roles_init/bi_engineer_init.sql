-- initiate Role Hierarchy: Access control designed to inherit permissions
-- ----------------------------------------------------------------------
-- 1.BI_Engineer settings
begin;

    -- create variables for user / password / role / warehouse / database (needs to be uppercase for objects)
    set role_name = 'BI_Engineer';
    set warehouse_name = 'BI_WH';

    -- change role to securityadmin for user / role steps
    use role securityadmin;

    -- create role for BI_Engineer
    create role if not exists identifier($role_name);
    grant role identifier($role_name) to role SYSADMIN;

    grant role ANALYST to role identifier($role_name);

    -- change role to sysadmin for warehouse / database steps
    use role sysadmin;

    -- grant BI_Engineer role access to warehouse
    grant USAGE
    on warehouse identifier($warehouse_name)
    to role identifier($role_name);

    -- grant BI_Engineer access to database

    grant usage on DATABASE "DATA_VAULT" to role BI_ENGINEER;
    grant usage on DATABASE "DATA_VAULT_DEV" to role BI_ENGINEER;
    grant usage on schema DATA_VAULT.RAW_VAULT to role BI_ENGINEER;
    grant usage on schema DATA_VAULT.BIZ to role BI_ENGINEER;
    grant usage on schema DATA_VAULT_DEV.RAW_VAULT_DEV to role BI_ENGINEER;
    grant usage on schema DATA_VAULT_DEV.BIZ_DEV to role BI_ENGINEER;
    grant select on all tables in schema DATA_VAULT.BIZ to role BI_ENGINEER;
    grant select on all tables in schema DATA_VAULT_DEV.BIZ_DEV to role BI_ENGINEER;

commit;
