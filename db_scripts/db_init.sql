use role ACCOUNTADMIN;
-- init dev databases
create database data_marts_dev;
create  database data_vault_dev;
create  database stage_dev;

-- init prod databases
create database data_marts;
create database data_vault;
create database stage;

-- init dev schema
create schema data_marts_dev.mart_global_dev;
create schema data_marts_dev.mart_action_audit_dev;

create schema data_vault_dev.raw_vault_dev;
create schema data_vault_dev.biz_dev;

create schema stage_dev.raw_stage_dev;
create schema stage_dev.stage_dev;

-- init prod schema
create schema data_marts.mart_global;
create schema data_marts.mart_action_audit;

create schema data_vault.raw_vault;
create schema data_vault.biz;

create schema stage.raw_stage;
create schema stage.stage;
