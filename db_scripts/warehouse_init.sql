-- create warehouses
use role SYSADMIN;
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
    auto_suspend = 60;
create warehouse LOOKER_WH
    warehouse_size='X-SMALL'
    auto_resume = true
    initially_suspended = true
    auto_suspend = 1800;
