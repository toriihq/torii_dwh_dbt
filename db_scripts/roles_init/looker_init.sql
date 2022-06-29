-- change role to securityadmin
use role securityadmin;

-- set variables
-- create role for looker
set role_name = 'LOOKER_ROLE';

-- create role for looker
create role if not exists identifier($role_name);
grant role LOOKER_ROLE to role SYSADMIN;

-- Note that we are not making the looker_role a SYSADMIN,
-- but rather granting users with the SYSADMIN role to modify the looker_role

-- create a user for looker
create user if not exists LOOKER_USER
password = 'password123!'; --will change
grant role looker_role to user looker_user;
alter user looker_user
set default_role = looker_role
default_warehouse = 'LOOKER_WH';

-- change role
use role SYSADMIN;

-- create a warehouse for looker (optional)

grant all privileges
on warehouse looker_wh
to role looker_role;

-- grant read only database access (repeat for all database/schemas)
grant usage on database <database> to role looker_role;
grant usage on schema <database>.<schema> to role looker_role;

-- rerun the following any time a table is added to the schema
grant select on all tables in schema <database>.<schema> to role looker_role;
-- or
grant select on future tables in schema <database>.<schema> to role looker_role;

-- create schema for looker to write back to
use database <database>;
create schema if not exists looker_scratch;
use role ACCOUNTADMIN;
grant ownership on schema looker_scratch to role SYSADMIN revoke current grants;
grant all on schema looker_scratch to role looker_role;


grant role identifier('BU') to role looker;
grant role identifier('looker') to role SYSADMIN;

-- variables for looker
set role_name = 'looker';
set user_name = 'looker_user';
set user_password = 'password123'; -- password changed
set warehouse_name = 'LOOKER_WH';

-- create a user for looker
create user if not exists identifier($user_name)
password = $user_password
default_role = $role_name
default_warehouse = $warehouse_name;

grant role identifier($role_name) to user identifier($user_name);
