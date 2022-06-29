-- initiate Role Hierarchy: Access control designed to inherit permissions
-- ----------------------------------------------------------------------
-- 1.Analyst settings
begin;

   -- create variables for user / password / role / warehouse / database (needs to be uppercase for objects)
   set role_name = 'Analyst';
   set warehouse_name = 'BI_WH';

   -- change role to securityadmin for user / role steps
   use role securityadmin;

   -- create role for Analyst
   create role if not exists identifier($role_name);
   grant role identifier($role_name) to role SYSADMIN;

-- use role ACCOUNTADMIN;
    grant role BU to role identifier($role_name);

   -- change role to sysadmin for warehouse / database steps
   use role sysadmin;

   -- grant Analyst role access to warehouse
   grant USAGE
   on warehouse identifier($warehouse_name)
   to role identifier($role_name);

    -- grant Analyst access to database
    grant usage on DATABASE "DATA_MARTS_DEV" to role identifier($role_name);
    grant usage on schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role identifier($role_name);
    grant usage on schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role identifier($role_name);
    grant select on all tables in schema DATA_MARTS_DEV.MART_ACTION_AUDIT_DEV to role identifier($role_name);
    grant select on all tables in schema DATA_MARTS_DEV.MART_GLOBAL_DEV to role identifier($role_name);

commit;
