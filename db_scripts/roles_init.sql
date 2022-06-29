
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


-- change role to sysadmin for user / role steps
use role securityadmin;

-- create role for BU
set role_name = 'BU';
create role if not exists identifier($role_name);

-- create role for Analyst
set role_name = 'Analyst';
create role if not exists identifier($role_name);

-- create role for Power_Analyst
set role_name = 'Power_Analyst';
create role if not exists identifier($role_name);

-- create role for BI_Engineer
set role_name = 'BI_Engineer';
create role if not exists identifier($role_name);

-- create role for Data_Engineer
set role_name = 'Data_Engineer';
create role if not exists identifier($role_name);


-- grant roles by hierarchy
grant role identifier('BU') to role Analyst;
grant role identifier('Analyst') to role Power_Analyst;
grant role identifier('Power_Analyst') to role SYSADMIN;

grant role identifier('Analyst') to role BI_ENGINEER;
grant role identifier('BI_ENGINEER') to role DATA_ENGINEER;
grant role identifier('DATA_ENGINEER') to role dbt;

-- create platform users dbt/looker

-- change role to sysadmin for warehouse / database steps
use role SYSADMIN;

-- grant usage on future schemas in database mydb to role role1;

//add read access to roles BU
grant usage on DATABASE "DATA_MARTS" to role BU;
grant usage on schema "DATA_MARTS"."MART_GLOBAL" to role BU;
grant usage on schema "DATA_MARTS"."MART_ACTION_AUDIT" to role BU;
grant select on all tables in schema DATA_MARTS.MART_ACTION_AUDIT to role BU;
grant select on all tables in schema DATA_MARTS.MART_GLOBAL to role BU;
-- add usage and select for future
use role ACCOUNTADMIN;
grant usage on future schemas in database "DATA_MARTS" to role BU;
grant select on future tables in schema DATA_MARTS.MART_ACTION_AUDIT to role BU;
grant select on future tables in schema DATA_MARTS.MART_GLOBAL to role BU;

//add read access to roles Analyst
use role SYSADMIN;
grant role BU to role Analyst;
grant usage on DATABASE "DATA_MARTS_DEV" to role Analyst;
grant usage on schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role Analyst;
grant usage on schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role Analyst;
grant select on all tables in schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role Analyst;
grant select on all tables in schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role Analyst;
-- add usage and select for future
use role ACCOUNTADMIN;
grant usage on future schemas in database "DATA_MARTS_DEV" to role Analyst;
grant select on future tables in schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role Analyst;
grant select on future tables in schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role Analyst;

//add read access to roles Power_Analyst
use role SYSADMIN;
grant role BU to role Power_Analyst;
grant usage on DATABASE "DATA_VAULT" to role Power_Analyst;
grant usage on DATABASE "STAGE" to role Power_Analyst;
grant usage on DATABASE "STAGE_FIVETRAN" to role Power_Analyst;
grant usage on schema DATA_VAULT.RAW_VAULT to role Power_Analyst;
grant usage on schema DATA_VAULT.BIZ to role Power_Analyst;
grant usage on schema STAGE_FIVETRAN.RAW_TORII to role POWER_ANALYST;
grant select on all tables in schema DATA_VAULT.BIZ to role Power_Analyst;
grant select on all tables in schema DATA_VAULT.RAW_VAULT to role Power_Analyst;
grant select on all tables in schema STAGE.RAW_STAGE to role Power_Analyst;
grant select on all tables in schema STAGE_FIVETRAN.RAW_TORII to role Power_Analyst;
-- add usage and select for future
use role ACCOUNTADMIN;
grant usage on future schemas in database "DATA_VAULT" to role Power_Analyst;
grant usage on future schemas in database "STAGE" to role Power_Analyst;
grant usage on future schemas in database "STAGE_FIVETRAN" to role Power_Analyst;
grant select on future tables in schema DATA_VAULT.BIZ to role Power_Analyst;
grant select on future tables in schema DATA_VAULT.RAW_VAULT to role Power_Analyst;
grant select on future tables in schema STAGE.RAW_STAGE to role Power_Analyst;
grant select on future tables in schema STAGE_FIVETRAN.RAW_TORII to role Power_Analyst;

//add read access to roles BI_Engineer
use role SYSADMIN;
grant role Analyst to role BI_ENGINEER;
grant usage on DATABASE "DATA_VAULT" to role BI_ENGINEER;
grant usage on DATABASE "DATA_VAULT_DEV" to role BI_ENGINEER;
grant usage on schema DATA_VAULT.RAW_VAULT to role BI_ENGINEER;
grant usage on schema DATA_VAULT.BIZ to role BI_ENGINEER;
grant usage on schema DATA_VAULT_DEV.RAW_VAULT_DEV to role BI_ENGINEER;
grant usage on schema DATA_VAULT_DEV.BIZ_DEV to role BI_ENGINEER;
grant select on all tables in schema DATA_VAULT.BIZ to role BI_ENGINEER;
grant select on all tables in schema DATA_VAULT_DEV.BIZ_DEV to role BI_ENGINEER;
-- add usage and select for future
use role ACCOUNTADMIN;
grant select on future tables in schema DATA_VAULT.BIZ to role BI_ENGINEER;
grant select on future tables in schema DATA_VAULT_DEV.BIZ_DEV to role BI_ENGINEER;

//add read access to roles Data_Engineer
use role SYSADMIN;
grant role BI_ENGINEER to role DATA_ENGINEER;
grant usage on DATABASE "STAGE" to role DATA_ENGINEER;
grant usage on DATABASE "STAGE_DEV" to role DATA_ENGINEER;
grant usage on DATABASE "STAGE_FIVETRAN" to role DATA_ENGINEER;
grant usage on SCHEMA STAGE.RAW_STAGE to role DATA_ENGINEER;
grant usage on SCHEMA STAGE_DEV.RAW_STAGE_DEV to role DATA_ENGINEER;
grant usage on SCHEMA STAGE_FIVETRAN.RAW_TORII to role DATA_ENGINEER;
grant select on all tables in schema DATA_VAULT.RAW_VAULT to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_VAULT_DEV.RAW_VAULT_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_VAULT_DEV.BIZ_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema STAGE_DEV.RAW_STAGE_DEV to role DATA_ENGINEER;
grant select on all tables in schema STAGE.RAW_STAGE to role DATA_ENGINEER;
grant select on all tables in schema STAGE_FIVETRAN.RAW_TORII to role DATA_ENGINEER;
-- add usage and select for future
use role ACCOUNTADMIN;
grant usage on future schemas in database "STAGE" to role DATA_ENGINEER;
grant usage on future schemas in database "STAGE_DEV" to role DATA_ENGINEER;
grant usage on future schemas in database "STAGE_FIVETRAN" to role DATA_ENGINEER;
grant select on future tables in schema DATA_VAULT.RAW_VAULT to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema DATA_VAULT_DEV.RAW_VAULT_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema DATA_VAULT_DEV.BIZ_DEV to role DATA_ENGINEER;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema STAGE_DEV.RAW_STAGE_DEV to role DATA_ENGINEER;
grant select on future tables in schema STAGE.RAW_STAGE to role DATA_ENGINEER;
grant select on future tables in schema STAGE_FIVETRAN.RAW_TORII to role DATA_ENGINEER;

use role sysadmin;
-- grant Power_Analyst role access to warehouse
   grant USAGE
   on warehouse BI_WH
   to role POWER_ANALYST;

-- grant Analyst role access to warehouse
   grant USAGE
   on warehouse BI_WH
   to role ANALYST;

-- grant BU role access to warehouse
   grant USAGE
   on warehouse BI_WH
   to role BU;

-- grant BI_Engineer role access to warehouse
   grant USAGE
   on warehouse BI_WH
   to role BI_ENGINEER;

-- grant Data_Engineer role access to warehouse
   grant USAGE
   on warehouse DWH_DEV_WH
   to role Data_Engineer;
