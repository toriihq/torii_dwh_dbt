-- initiate Role Hierarchy: Access control designed to inherit permissions
-- ----------------------------------------------------------------------
-- 1.Power_Analyst settings
begin;

    -- create variables for user / password / role / warehouse / database (needs to be uppercase for objects)
    set role_name = 'Power_Analyst';
    set warehouse_name = 'BI_WH';

    -- change role to securityadmin for user / role steps
    use role securityadmin;

    -- create role for Power_Analyst
    create role if not exists identifier($role_name);
    grant role identifier($role_name) to role SYSADMIN;

    grant role ANALYST to role identifier($role_name);

    -- change role to sysadmin for warehouse / database steps
    use role sysadmin;

    -- grant Power_Analyst role access to warehouse
    grant USAGE
    on warehouse identifier($warehouse_name)
    to role identifier($role_name);

    -- grant Power_Analyst access to database
    grant usage on database STAGE_FIVETRAN to role identifier($role_name);
    grant usage on schema TORII_DWH.DATA_VAULT to role identifier($role_name);
    grant usage on schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant usage on schema TORII_DWH.STAGE to role identifier($role_name);
    grant usage on schema STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant usage on schema STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant select on all tables in schema TORII_DWH.DATA_VAULT to role identifier($role_name);
    grant select on all tables in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant select on all tables in schema TORII_DWH.STAGE to role identifier($role_name);
    grant select on all tables in schema STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant select on all tables in schema STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant select on all views in schema TORII_DWH.DATA_VAULT to role identifier($role_name);
    grant select on all views in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant select on all views in schema TORII_DWH.STAGE to role identifier($role_name);
    -- gratn future on tables/schemas
    use role ACCOUNTADMIN;
    grant select on future tables in schema TORII_DWH.DATA_VAULT to role identifier($role_name);
    grant select on future tables in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant select on future tables in schema TORII_DWH.STAGE to role identifier($role_name);
    grant select on future tables in schema STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant select on future tables in schema STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant select on future views in schema TORII_DWH.DATA_VAULT to role identifier($role_name);
    grant select on future views in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant select on future views in schema TORII_DWH.STAGE to role identifier($role_name);

commit;
