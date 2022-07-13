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
    grant usage on schema TORII_DWH.RAW_VAULT to role BI_ENGINEER;
    grant usage on schema TORII_DWH.DATA_MART to role BI_ENGINEER;
    grant usage on schema TORII_DWH_DEV.RAW_VAULT to role BI_ENGINEER;
    grant usage on schema TORII_DWH_DEV.DATA_MART to role BI_ENGINEER;
    grant select on all tables in schema TORII_DWH_DEV.RAW_VAULT to role BI_ENGINEER;
    grant select on all tables in schema TORII_DWH_DEV.DATA_MART to role BI_ENGINEER;
    grant select on all views in schema TORII_DWH_DEV.RAW_VAULT to role BI_ENGINEER;
    grant select on all views in schema TORII_DWH_DEV.DATA_MART to role BI_ENGINEER;
    -- grant usage on future tables/views
    use role ACCOUNTADMIN;
    grant select on future tables in schema TORII_DWH_DEV.RAW_VAULT to role BI_ENGINEER;
    grant select on future tables in schema TORII_DWH_DEV.DATA_MART to role BI_ENGINEER;
    grant select on future views in schema TORII_DWH_DEV.RAW_VAULT to role BI_ENGINEER;
    grant select on future views in schema TORII_DWH_DEV.DATA_MART to role BI_ENGINEER;

commit;
