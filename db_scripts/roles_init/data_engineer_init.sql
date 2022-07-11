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
    grant usage on SCHEMA TORII_DWH.STAGE to role identifier($role_name);
    grant usage on SCHEMA TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant usage on SCHEMA STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant usage on SCHEMA STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant usage on SCHEMA TORII_DWH_DEV.STAGE_DEV to role identifier($role_name);
    grant usage on SCHEMA TORII_DWH_DEV.RAW_STAGE_DEV to role identifier($role_name);

    grant all privileges on all tables in schema TORII_DWH.STAGE to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH_DEV.STAGE_DEV to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH_DEV.RAW_STAGE_DEV to role identifier($role_name);
    grant select on all tables in schema STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant select on all tables in schema STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH.STAGE to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH_DEV.STAGE_DEV to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH_DEV.RAW_STAGE_DEV to role identifier($role_name);

{#future#}
    use role accountadmin;
    grant all privileges on future tables in schema TORII_DWH.STAGE to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH_DEV.STAGE_DEV to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH_DEV.RAW_STAGE_DEV to role identifier($role_name);
    grant select on future tables in schema STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant select on future tables in schema STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH.STAGE to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH_DEV.STAGE_DEV to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH_DEV.RAW_STAGE_DEV to role identifier($role_name);


commit;
