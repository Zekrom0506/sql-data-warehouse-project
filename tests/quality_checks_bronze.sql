/*
===============================================================================
Quality Checks: Bronze Layer
===============================================================================
Script Purpose:
    Validates the bronze load (Source -> Bronze):
    - Completeness: row counts must equal the CSV line count minus the header.
    - Schema check: values land in the right columns (spot-check a few rows).

Usage Notes:
    - Run in the DataWarehouse database after EXEC bronze.load_bronze;
===============================================================================
*/

-- Completeness: compare with the source files
-- Expectation: actual_rows = expected_rows for every table
SELECT 'bronze.crm_cust_info'     AS table_name, COUNT(*) AS actual_rows, 18494 AS expected_rows FROM bronze.crm_cust_info
UNION ALL
SELECT 'bronze.crm_prd_info',       COUNT(*), 397   FROM bronze.crm_prd_info
UNION ALL
SELECT 'bronze.crm_sales_details',  COUNT(*), 60398 FROM bronze.crm_sales_details
UNION ALL
SELECT 'bronze.erp_cust_az12',      COUNT(*), 18484 FROM bronze.erp_cust_az12
UNION ALL
SELECT 'bronze.erp_loc_a101',       COUNT(*), 18484 FROM bronze.erp_loc_a101
UNION ALL
SELECT 'bronze.erp_px_cat_g1v2',    COUNT(*), 37    FROM bronze.erp_px_cat_g1v2;

-- Schema check: eyeball that each value sits in the correct column (no shifting)
SELECT TOP 10 * FROM bronze.crm_cust_info;
SELECT TOP 10 * FROM bronze.crm_prd_info;
SELECT TOP 10 * FROM bronze.crm_sales_details;
SELECT TOP 10 * FROM bronze.erp_cust_az12;
SELECT TOP 10 * FROM bronze.erp_loc_a101;
SELECT TOP 10 * FROM bronze.erp_px_cat_g1v2;
