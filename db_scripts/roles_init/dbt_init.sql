-- initiate Role Hierarchy: Access control designed to inherit permissions
-- ----------------------------------------------------------------------
-- 1.dbt settings
begin;

   -- create variables for user / password / role / warehouse / database (needs to be uppercase for objects)
   set role_name = 'DBT_ROLE';
   set user_name = 'DBT_USER';
--    set user_password = 'password123'; -- password changed
   set warehouse_name = 'DBT_WH';

   -- change role to securityadmin for user / role steps
   use role securityadmin;

   -- create role for dbt
   create role if not exists identifier($role_name);
   grant role identifier($role_name) to role SYSADMIN;

   -- create a user for dbt
   create user if not exists identifier($user_name)
{#   password = $user_password#}
   default_role = $role_name
   default_warehouse = $warehouse_name;

   grant role identifier($role_name) to user identifier($user_name);

   -- change role to sysadmin for warehouse / database steps
   use role sysadmin;

   -- grant dbt role access to warehouse
   grant USAGE
   on warehouse identifier($warehouse_name)
   to role identifier($role_name);

    -- grant dbt access to database
    grant usage on database STAGE_FIVETRAN to role identifier($role_name);
    grant all privileges on database TORII_DWH to role identifier($role_name);
    grant all privileges on database TORII_DWH_DEV to role identifier($role_name);
    grant usage on schema STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant usage on schema STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant all privileges on schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant all privileges on schema TORII_DWH.STAGE to role identifier($role_name);
    grant all privileges on schema TORII_DWH.RAW_VAULT to role identifier($role_name);
    grant all privileges on schema TORII_DWH.DATA_MART to role identifier($role_name);
    grant all privileges on schema TORII_DWH_DEV.RAW_STAGE to role identifier($role_name);
    grant all privileges on schema TORII_DWH_DEV.STAGE to role identifier($role_name);
    grant all privileges on schema TORII_DWH_DEV.RAW_VAULT to role identifier($role_name);
    grant all privileges on schema TORII_DWH_DEV.DATA_MART to role identifier($role_name);
    grant select on all tables in schema STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant select on all tables in schema STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH.STAGE to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH.RAW_VAULT to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH.DATA_MART to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH_DEV.RAW_STAGE to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH_DEV.STAGE to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH_DEV.RAW_VAULT to role identifier($role_name);
    grant all privileges on all tables in schema TORII_DWH_DEV.DATA_MART to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH.STAGE to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH.RAW_VAULT to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH.DATA_MART to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH_DEV.RAW_STAGE to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH_DEV.STAGE to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH_DEV.RAW_VAULT to role identifier($role_name);
    grant all privileges on all views in schema TORII_DWH_DEV.DATA_MART to role identifier($role_name);
{#future#}
    use role ACCOUNTADMIN;

    grant select on future tables in schema STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant select on future tables in schema STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH.STAGE to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH.RAW_VAULT to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH.DATA_MART to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH_DEV.RAW_STAGE to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH_DEV.STAGE to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH_DEV.RAW_VAULT to role identifier($role_name);
    grant all privileges on future tables in schema TORII_DWH_DEV.DATA_MART to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH.RAW_STAGE to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH.STAGE to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH.RAW_VAULT to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH.DATA_MART to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH_DEV.RAW_STAGE to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH_DEV.STAGE to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH_DEV.RAW_VAULT to role identifier($role_name);
    grant all privileges on future views in schema TORII_DWH_DEV.DATA_MART to role identifier($role_name);


 commit;

use role ACCOUNTADMIN;

alter user DBT_USER set rsa_public_key='check pub key with udi';

-- desc user DBT_USER

-- drop user DBT_USER;
-- drop role DBT_ROLE;