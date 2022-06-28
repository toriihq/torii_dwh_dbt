use role securityadmin;

show roles
-- create role for dbt
set role_name = 'dbt';
create role if not exists identifier($role_name);

-- grant roles by hierarchy
grant role identifier('dbt') to role SYSADMIN;

-- create a user for dbt
set role_name = 'dbt';
set user_name = 'dbt_user';
set user_password = 'password123'; -- password changed
set warehouse_name = 'DBT_WH';

-- create a user for dbt
create user if not exists identifier($user_name)
password = $user_password
default_role = $role_name
default_warehouse = $warehouse_name;

grant role identifier($role_name) to user identifier($user_name);
alter user identifier($user_name) set rsa_public_key = 'the public key for dbt';


//add read access to roles dbt
use role SYSADMIN;
grant role DATA_ENGINEER to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_MARTS.MART_GLOBAL to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_MARTS.MART_ACTION_AUDIT to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_VAULT.RAW_VAULT to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema DATA_VAULT.BIZ to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema STAGE.RAW_STAGE to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on all tables in schema STAGE_FIVETRAN.RAW_TORII to role dbt;
use role ACCOUNTADMIN;
grant usage on future schemas in database "STAGE_FIVETRAN" to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema DATA_MARTS.MART_GLOBAL to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema DATA_MARTS.MART_ACTION_AUDIT to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema DATA_VAULT.RAW_VAULT to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema DATA_VAULT.BIZ to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema STAGE.RAW_STAGE to role dbt;
grant select,insert,UPDATE,DELETE,TRUNCATE on future tables in schema STAGE_FIVETRAN.RAW_TORII to role dbt;
