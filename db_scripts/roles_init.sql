-- initiate Role Hierarchy: Access control designed to inherit permissions
-- ----------------------------------------------------------------------
-- 1.fivetran settings
begin;

   -- create variables for user / password / role / warehouse / database (needs to be uppercase for objects)
   set role_name = 'FIVETRAN_ROLE';
   set user_name = 'FIVETRAN_USER';
   set user_password = 'password123'; -- password changed
   set warehouse_name = 'FIVETRAN_WAREHOUSE';
   set database_name = 'STAGE_DEV';

   -- change role to securityadmin for user / role steps
   use role securityadmin;

   -- create role for fivetran
   create role if not exists identifier($role_name);
   grant role identifier($role_name) to role SYSADMIN;

   -- create a user for fivetran
   create user if not exists identifier($user_name)
   password = $user_password
   default_role = $role_name
   default_warehouse = $warehouse_name;

   grant role identifier($role_name) to user identifier($user_name);

   -- change role to sysadmin for warehouse / database steps
   use role sysadmin;

   -- create a warehouse for fivetran
   create warehouse if not exists identifier($warehouse_name)
   warehouse_size = xsmall
   warehouse_type = standard
   auto_suspend = 60
   auto_resume = true
   initially_suspended = true;

   -- create database for fivetran
   create database if not exists identifier($database_name);

   -- grant fivetran role access to warehouse
   grant USAGE
   on warehouse identifier($warehouse_name)
   to role identifier($role_name);

   -- grant fivetran access to database
   grant CREATE SCHEMA, MONITOR, USAGE
   on database identifier($database_name)
   to role identifier($role_name);

 commit;

-- https://fivetran.com/docs/getting-started/ips#usregions
CREATE NETWORK POLICY fivetran_ip_whitelist_us ALLOWED_IP_LIST = ('35.227.135.0/29', '35.234.176.144/29', '52.0.2.4/32');
-- US	us-west-2 (Oregon)	35.80.36.104/29	35.80.36.104 - 35.80.36.111 AWS
-- CREATE NETWORK POLICY fivetran_ip_whitelist_us ALLOWED_IP_LIST = ('35.80.36.104/29',	'35.80.36.104/8');

-- key is located on private location of udi lerner
alter user FIVETRAN_USER set rsa_public_key='<public key value>';

-- 2. General Torii's User settings

-- Torii dwh custom roles list:
-- ----------------------------
-- 1.BU - read only - okta account - BI_WH - xsmall - readonly data_mart
-- 2.Analyst - read only - okta account -BI_WH - xsmall - readonly data_mart
-- 3.BI engineer - okta account - BI_WH - xsmall - readonly data_mart
-- 4.DWH Developer - okta account - DEVELOPER_WH - xsmall - [BU] + [Analyst] + [BI Engineer] + insert/updates/deletes data_mart/data_vault/stage
-- 5.dbt - service account - dbt_WH - xsmall - [DWH Developer]
-- 6.looker - service account - LOOKER_WH - xsmall - readonly data_mart
-- 7.fivetran - service account - FIVETRAN_WAREHOUSE - xsmall
-- 8.account admin -already setup - service account
-- 9.system admin - already setup - service account

-- https://docs.snowflake.com/en/user-guide/scim-okta.html
-- https://docs.snowflake.com/en/user-guide/oauth-okta.html
-- https://docs.snowflake.com/en/user-guide/admin-security-fed-auth-configure-snowflake.html

-- create warehouses
use role accountadmin;
create warehouse BI_WH
    warehouse_size='X-SMALL'
    auto_resume = true
    initially_suspended = true
    auto_suspend = 300;
create warehouse DWH_DEV_WH
    warehouse_size='X-SMALL'
    auto_resume = true
    initially_suspended = true
    auto_suspend = 60;
create warehouse DBT_WH
    warehouse_size='X-SMALL'
    auto_resume = true
    initially_suspended = true
    auto_suspend = 0;
create warehouse LOOKER_WH
    warehouse_size='X-SMALL'
    auto_resume = true
    initially_suspended = true
    auto_suspend = 300;

-- create roles

-- add BU role
use role USERADMIN;
//create role BU
create role BU;
create role Analyst;
create role Power_Analyst;
create role BI_Engineer;
create role Data_Engineer;
create role dbt;
create role looker;

use role SECURITYADMIN;
//verify no grants on BU
show grants to role BU;

//grant role to my user
grant role BU to user udilerner;
grant role Analyst to user udilerner;
grant role BI_Engineer to user udilerner;
grant role Data_Engineer to user udilerner;
grant role dbt to user udilerner;
grant role looker to user udilerner;

//add read access to roles BU
grant usage on DATABASE "DATA_MARTS" to role BU;
grant select on all tables in schema DATA_MARTS.MART_ACTION_AUDIT to role BU;
grant select on future tables in schema DATA_MARTS.MART_ACTION_AUDIT to role BU;
grant select on all tables in schema DATA_MARTS.MART_GLOBAL to role BU;

//add read access to roles Analyst
grant role BU to role Analyst;
grant usage on DATABASE "DATA_MARTS_DEV" to role Analyst;
grant select on all tables in schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role Analyst;
grant select on all tables in schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role Analyst;

//add read access to roles Power_Analyst
grant role BU to role Power_Analyst;
grant usage on DATABASE "DATA_VAULT" to role Power_Analyst;
grant usage on DATABASE "STAGE" to role Power_Analyst;
grant select on all tables in schema DATA_VAULT.BIZ to role Power_Analyst;
grant select on all tables in schema DATA_VAULT.RAW_VAULT to role Power_Analyst;
grant select on all tables in schema STAGE.RAW_STAGE to role Power_Analyst;

//add read access to roles BI_Engineer
grant role Analyst to role BI_ENGINEER;
grant usage on DATABASE "DATA_VAULT" to role BI_ENGINEER;
grant select on all tables in schema DATA_VAULT.BIZ to role BI_ENGINEER;
grant usage on DATABASE "DATA_VAULT_DEV" to role BI_ENGINEER;
grant select on all tables in schema DATA_VAULT_DEV.BIZ_DEV to role BI_ENGINEER;

//add read access to roles Data_Engineer
grant role BI_ENGINEER to role DATA_ENGINEER;
grant select on all tables in schema DATA_VAULT.RAW_VAULT to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_VAULT_DEV.RAW_VAULT_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_VAULT_DEV.BIZ_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema STAGE_DEV.RAW_STAGE_DEV to role DATA_ENGINEER;
grant usage on DATABASE "STAGE" to role DATA_ENGINEER;
grant select on all tables in schema STAGE.RAW_STAGE to role DATA_ENGINEER;
grant usage on DATABASE "STAGE_DEV" to role DATA_ENGINEER;

//add read access to roles dbt
grant role DATA_ENGINEER to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_MARTS.MART_GLOBAL to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_MARTS.MART_ACTION_AUDIT to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_VAULT.RAW_VAULT to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_VAULT.BIZ to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema STAGE.RAW_STAGE to role DATA_ENGINEER;

//add read access to roles looker
grant role BU to role looker;

