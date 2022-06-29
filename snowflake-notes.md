# Torii Snowflake Roles & Security Policy

## snowflake security settings
we follow snowflake best practice for security policy
https://docs.snowflake.com/en/user-guide/security-access-control-overview.html

## System Defined Roles
System-Defined Roles

| Role name     | Function                                                                                                                                                                                                                                                                                                                                                                                                                               |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ORGADMIN      | (aka Organization Administrator) Role that manages operations at the organization level. More specifically, this role: Can create accounts in the organization. Can view all accounts in the organization (using SHOW ORGANIZATION ACCOUNTS) as well as all regions enabled for the organization (using SHOW REGIONS). Can view usage information across the organization.                                                             |
| ACCOUNTADMIN  | (aka Account Administrator) Role that encapsulates the SYSADMIN and SECURITYADMIN system-defined roles. It is the top-level role in the system and should be granted only to a limited/controlled number of users in your account.                                                                                                                                                                                                     |
| SECURITYADMIN | (aka Security Administrator) Role that can manage any object grant globally, as well as create, monitor, and manage users and roles. More specifically, this role: Is granted the MANAGE GRANTS security privilege to be able to modify any grant, including revoking it. Inherits the privileges of the USERADMIN role via the system role hierarchy (i.e. USERADMIN role is granted to SECURITYADMIN).                               |
| USERADMIN     | (aka User and Role Administrator) Role that is dedicated to user and role management only. More specifically, this role: Is granted the CREATE USER and CREATE ROLE security privileges. Can create users and roles in the account. This role can also manage users and roles that it owns. Only the role with the OWNERSHIP privilege on an object (i.e. user or role), or a higher role, can modify the object properties.           |
| SYSADMIN      | (aka System Administrator) Role that has privileges to create warehouses and databases (and other objects) in an account. If, as recommended, you create a role hierarchy that ultimately assigns all custom roles to the SYSADMIN role, this role also has the ability to grant privileges on warehouses, databases, and other objects to other roles.                                                                                |
| PUBLIC        | Pseudo-role that is automatically granted to every user and every role in your account. The PUBLIC role can own securable objects, just like any other role; however, the objects owned by the role are, by definition, available to every other user and role in your account. This role is typically used in cases where explicit access control is not needed and all users are viewed as equal with regard to their access rights. |

## Torii defined roles

| Role name     | Function                                                                     | db Acess                                                           | Permission Type                                     |
|---------------|------------------------------------------------------------------------------|--------------------------------------------------------------------|-----------------------------------------------------|
| BU            | Gneral Anlytics needs| data_marts                                                         | Read Only                                           |
| Analyst       | Analyst users, future development of data marts, and testing of new features | data_marts; data_marts_dev    | Read Only (future development ability);Read Only    |
| Power_Analyst |High Level users to see all DWH prod layers| stage; data_vault; data_marts                                      | Read Only                                           |
| BI_Engineer   | BI development, future development of data marts, and testing of new features| data_marts;data_vault.biz; data_marts_dev;data_vault_dev.biz_dev                  | Read Only (future development ability);Read Only    |
| Data_Engineer | Develop DWH components| stage;data_vault;data_marts;stage_dev;data_vault_dev;data_marts_dev | Read Only |
| DBT_ROLE      | dbt User purposes, will debug/test/compile/deploy db objects of DWH| stage;data_vault;data_marts;stage_dev;data_vault_dev;data_marts_dev | read/delete/update                                  |
| LOOKER_ROLE   | looker usage| data_marts                                                         | Read Only                                           |
| FIVETRAN_ROLE | Extract & Load purposes into the DWH| stage; stage_dev?                                                  | create/update/delete                                | 

# Torii Snowflake Compute Resources - warehouses

## warehouses

| Warehouse        | Funtion | Roles                                   |
|------------------|--------|-----------------------------------------|
| BI_WH            |BI / Analytics compute resources| BU; Analyst; BI Engineer; Power Analyst |
| DWH_DEV_WH       |DWH Developer| Data_Engineer                            |
| DBT_WH           |dbt purposes| dbt                                     |
| LOOKER_WH       |looker purposes| looker                                  |
| FIVETRAN_WAREHOUSE |fivetran purposes| fivetran                                |
| COMPUTE_WH          |system purposes| ALL system defined                      |
