use role SYSADMIN;

-- init dev databases
create database torii_dwh_dev;

-- init prod databases
create database torii_dwh;

use role SYSADMIN;
-- init dev schema
create schema torii_dwh_dev.raw_stage_dev;
create schema torii_dwh_dev.stage_dev;
create schema torii_dwh_dev.data_vault_dev;
create schema torii_dwh_dev.data_mart_dev;


-- init prod schema
create schema torii_dwh.raw_stage;
create schema torii_dwh.stage;
create schema torii_dwh.data_vault;
create schema torii_dwh.data_mart;
