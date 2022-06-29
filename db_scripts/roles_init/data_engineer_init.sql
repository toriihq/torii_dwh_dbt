-- initiate Role Hierarchy: Access control designed to inherit permissions
-- ----------------------------------------------------------------------
-- 1.Data_Engineer settings
begin;

    -- create variables for user / password / role / warehouse / database (needs to be uppercase for objects)
    set role_name = 'Data_Engineer';
    set warehouse_name = 'DWH_DEV_WH';

    -- change role to securityadmin for user / role steps
    use role securityadmin;

    -- create role for Data_Engineer
    create role if not exists identifier($role_name);
    grant role identifier($role_name) to role SYSADMIN;

    grant role BI_Engineer to role identifier($role_name);

    -- change role to sysadmin for warehouse / database steps
    use role sysadmin;

    -- grant Data_Engineer role access to warehouse
    grant USAGE
    on warehouse identifier($warehouse_name)
    to role identifier($role_name);

    -- grant Data_Engineer access to database

    grant usage on DATABASE "STAGE" to role DATA_ENGINEER;
    grant usage on DATABASE "STAGE_DEV" to role DATA_ENGINEER;
    grant usage on DATABASE "STAGE_FIVETRAN" to role DATA_ENGINEER;
    grant usage on SCHEMA STAGE.RAW_STAGE to role DATA_ENGINEER;
    grant usage on SCHEMA STAGE_DEV.RAW_STAGE_DEV to role DATA_ENGINEER;
    grant usage on SCHEMA STAGE_FIVETRAN.RAW_TORII to role DATA_ENGINEER;
    grant usage on SCHEMA STAGE_FIVETRAN.RAW_SALESFORCE to role DATA_ENGINEER;
    grant select on all tables in schema DATA_VAULT.RAW_VAULT to role DATA_ENGINEER;
    grant all privileges on all tables in schema STAGE_DEV.RAW_STAGE_DEV to role DATA_ENGINEER;
    grant all privileges on all tables in schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role DATA_ENGINEER;
    grant all privileges on all tables in schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role DATA_ENGINEER;
    grant all privileges on all tables in schema DATA_VAULT_DEV.RAW_VAULT_DEV to role DATA_ENGINEER;
    grant all privileges on all tables in schema DATA_VAULT_DEV.BIZ_DEV to role DATA_ENGINEER;
    grant all privileges on all tables in schema STAGE_DEV.RAW_STAGE_DEV to role DATA_ENGINEER;
    grant select on all tables in schema STAGE.RAW_STAGE to role DATA_ENGINEER;
    grant select on all tables in schema STAGE_FIVETRAN.RAW_TORII to role DATA_ENGINEER;
    grant select on all tables in schema STAGE_FIVETRAN.RAW_SALESFORCE to role DATA_ENGINEER;

commit;
