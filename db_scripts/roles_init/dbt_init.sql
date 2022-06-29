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
   password = $user_password
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
    grant usage on DATABASE "STAGE_FIVETRAN" to role identifier($role_name);
    grant all privileges on DATABASE "STAGE" to role identifier($role_name);
    grant all privileges on DATABASE "STAGE_DEV" to role identifier($role_name);
    grant all privileges on DATABASE "DATA_VAULT" to role identifier($role_name);
    grant all privileges on DATABASE "DATA_VAULT_DEV" to role identifier($role_name);
    grant all privileges on DATABASE "DATA_MARTS" to role identifier($role_name);
    grant all privileges on DATABASE "DATA_MARTS_DEV" to role identifier($role_name);
    grant usage on schema STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant usage on schema STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant usage on schema STAGE.RAW_STAGE to role identifier($role_name);
    grant usage on schema STAGE_DEV.RAW_STAGE_DEV to role identifier($role_name);
    grant usage on schema DATA_VAULT.RAW_VAULT to role identifier($role_name);
    grant usage on schema DATA_VAULT_DEV.RAW_VAULT_DEV to role identifier($role_name);
    grant usage on schema DATA_VAULT.BIZ to role identifier($role_name);
    grant usage on schema DATA_VAULT_DEV.BIZ_DEV to role identifier($role_name);
    grant usage on schema DATA_MARTS.MART_ACTION_AUDIT to role identifier($role_name);
    grant usage on schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role identifier($role_name);
    grant usage on schema DATA_MARTS.MART_GLOBAL to role identifier($role_name);
    grant usage on schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role identifier($role_name);
    grant select on all tables in schema STAGE_FIVETRAN.RAW_SALESFORCE to role identifier($role_name);
    grant select on all tables in schema STAGE_FIVETRAN.RAW_TORII to role identifier($role_name);
    grant all privileges on all tables in schema STAGE.RAW_STAGE to role identifier($role_name);
    grant all privileges on all tables in schema STAGE_DEV.RAW_STAGE_DEV to role identifier($role_name);
    grant all privileges on all tables in schema DATA_VAULT.RAW_VAULT to role identifier($role_name);
    grant all privileges on all tables in schema DATA_VAULT_DEV.RAW_VAULT_DEV to role identifier($role_name);
    grant all privileges on all tables in schema DATA_VAULT.BIZ to role identifier($role_name);
    grant all privileges on all tables in schema DATA_VAULT_DEV.BIZ_DEV to role identifier($role_name);
    grant all privileges on all tables in schema DATA_MARTS.MART_ACTION_AUDIT to role identifier($role_name);
    grant all privileges on all tables in schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role identifier($role_name);
    grant all privileges on all tables in schema DATA_MARTS.MART_GLOBAL to role identifier($role_name);
    grant all privileges on all tables in schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role identifier($role_name);

 commit;

use role ACCOUNTADMIN;

alter user DBT_USER set rsa_public_key='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1IHGITztpeaj5SkcKJn8
Gz/zqpgfPxgMEspr8f4LeOHgwC9gb9QujYfWcdCHhN3wNAnFbwbfZENGZb5n9cnc
0S2vhM+HDyUlVen1E78isFlWMNwioGkwY0A1j33GnmrOAfYD+5zI/9BSKgMPAK5I
sUbhSr+KdvTjfNbB45WRWR76JF7nfkcQE/S6bZUk41QmH/ZI5YsKIDPe7GIOsrfZ
V+jun+cK3KaeOw5reJwavA3SEH+IZp2Pj077yAztHQ3TwlZ15eU5hLBojNd4G2S/
QykRJPHJYr1HX7kvRnzIBdxADGz1TITidgBcxFHkvRgq/Gxh0MhsejxG0pBiFCxo
nQIDAQAB';

-- desc user DBT_USER

-- drop user DBT_USER;
-- drop role DBT_ROLE;