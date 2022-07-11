-- initiate Role Hierarchy: Access control designed to inherit permissions
-- ----------------------------------------------------------------------
-- 1.BU settings
begin;

   -- create variables for user / password / role / warehouse / database (needs to be uppercase for objects)
   set role_name = 'BU';
   set warehouse_name = 'BI_WH';

   -- change role to securityadmin for user / role steps
   use role securityadmin;

   -- create role for bu
   create role if not exists identifier($role_name);
   grant role identifier($role_name) to role SYSADMIN;

   -- change role to sysadmin for warehouse / database steps
   use role sysadmin;

   -- grant bu role access to warehouse
   grant USAGE
   on warehouse identifier($warehouse_name)
   to role identifier($role_name);

    -- grant bu access to database
    grant USAGE on database torii_dwh to role identifier($role_name);
    grant USAGE on schema torii_dwh.data_mart to role identifier($role_name);
    grant select on all tables in schema torii_dwh.data_mart to role identifier($role_name);
    grant select on all views in schema torii_dwh.data_mart to role identifier($role_name);
    -- grant bu access to database future tables
    use role ACCOUNTADMIN;
    grant select on future tables in schema torii_dwh.data_mart to role identifier($role_name);
    grant select on future views in schema torii_dwh.data_mart to role identifier($role_name);

commit;