-- initiate Role Hierarchy: Access control designed to inherit permissions
-- ----------------------------------------------------------------------
-- 1.fivetran settings
begin;

   -- create variables for user / password / role / warehouse / database (needs to be uppercase for objects)
   set role_name = 'FIVETRAN_ROLE';
   set user_name = 'FIVETRAN_USER';
   set user_password = 'password123'; -- password changed
   set warehouse_name = 'FIVETRAN_WAREHOUSE';
   set database_name = 'STAGE_FIVETRAN';

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
