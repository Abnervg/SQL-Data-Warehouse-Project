/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:
    > Null or duplicate primary keys.
    > Unwanted spaces in string fields.
    > Data standardization and consistency.
    > Invalid dataa ranges and orders.
    > Data consistency between related fields.

Usage notes:
    > Run these checks after data loading Silver Layer.
    > Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/


/*
================================================
	Data validation for CRM source
================================================
*/
--================================
-- Checking 'silver.crm_cust_info'
--================================
-- Check for nulls or duplicates in Primary Key
-- Expectation: No result

SELECT
	cst_id,
	COUNT(*)
	FROM silver.crm_cust_info
	GROUP BY cst_id
	HAVING COUNT(*) > 1 OR cst_id IS NULL;

--Check for unwanted spaces

SELECT
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Data standardization & consistency

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

--================================
-- Checking 'silver.crm_prd_info'
--================================
-- Check for duplicates or nulls in primary key
-- Expectation: No result

SELECT
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

--  Data Standardization &  Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


--=====================================
-- Checking 'silver.crm_sales_details'
--=====================================
--Date Validation

SELECT
	sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt = 0 OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20250101
OR sls_order_dt < 19000000;

SELECT
	sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20250101
OR sls_ship_dt < 19000000;

SELECT
	sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt = 0 OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20250101
OR sls_due_dt < 19000000;


-- Check for invalid date orders

SELECT
	*
FROM bronze.crm_sales_details
WHERE sls_ship_dt < sls_order_dt OR sls_order_dt > sls_due_dt;

--Check data consistency between : Sales, Quantity and Price
-- >> Values must not be NULL, zero or negative

SELECT
	sls_sales,
	sls_quantity,
	sls_price,
	sls_price*sls_quantity AS sls_cal_sales
FROM bronze.crm_sales_details
WHERE sls_sales != sls_price*sls_quantity
OR sls_sales IS NULL;


/*
================================================
	Data validation for ERP source
================================================
*/

--================================
-- Checking 'silver.erp_cust_az12'
--================================
--Data validation
-- Dates within range

SELECT DISTINCT
	bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Data Standardization & Consistency
SELECT DISTINCT
	gen
FROM silver.erp_cust_az12;

--================================
-- Checking 'silver.erp_loc_a101'
--================================

--Data Standardization & Consistency

SELECT DISTINCT
	cntry
FROM silver.erp_loc_a101;

--================================
-- Checking 'silver.erp_px_cat_g1v2'
--================================

--Data Standardization & Consistency

-- Check for coincident IDS
SELECT DISTINCT cat_id
FROM silver.crm_prd_info
WHERE cat_id NOT IN (SELECT DISTINCT
	id
FROM bronze.erp_px_cat_g1v2);

--Check for unwanted spaces

SELECT
	cat
FROM bronze.erp_px_cat_g1v2
WHERE	cat != TRIM(cat);

SELECT
	subcat
FROM bronze.erp_px_cat_g1v2
WHERE	subcat != TRIM(subcat);


-- Data Standardization & Consistency

SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2;

