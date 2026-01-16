---========================================== CORE ============================================

----------------- Stored Prcedure Start 
----------------  EXEC Core.load_Core

---===============================  INSERT DATA FROM STAGING.Customers TO CORE.Customers  ====================

CREATE OR ALTER PROCEDURE Core.load_Core AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
    BEGIN TRY
            PRINT '================================================'
			PRINT 'Loading Core Layer'
			PRINT '================================================'


			PRINT '================================================'
			PRINT 'Loading Customers Table'
			PRINT '================================================'

            
			SET @start_time = GETDATE();
			PRINT 'Truncating Table:Core.Customers'
			TRUNCATE TABLE Core.Customers




            INSERT INTO Core.Customers
                (
                    CustomerID,
                    CustomerKey,
                    CustomerFirstName,
                    CustomerLastName,
                    CustomerMaritalStatus,
                    CustomerGender,
                    CustomerCreateDate
                )


        --Row_Number : Assign a uninque number to each row in a resultset, based on defined order
        -- Checking unwanted spaces and TRI M 
            SELECT 
                    TRY_CAST(cst_id AS INT)     AS CustomerID,
                    cst_key                     AS CustomerKey,
                    TRIM(cst_firstname)         AS CustomerFirstName,
                    TRIM(cst_lastname)          AS CustomerLastName,
    
    
                    CASE 
                        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                        ELSE 'N/A'
                    END                         AS CustomerMaritalStatus,


                    CASE 
                        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'FEMALE'
                        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'MALE'
                        ELSE 'N/A'
                    END                         AS CustomerGender,


                    TRY_CAST(cst_create_date AS DATE) AS CustomerCreateDate
            FROM
            (
                SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
                FROM Staging.Customers
            ) t

            WHERE flag_last = 1
            AND TRY_CAST(cst_id AS INT) IS NOT NULL       -- prevents PK NULL error

            SET @end_time = GETDATE();
		    PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'





---=================================== INSERT DATA FROM STAGING.Products TO CORE.Products  ====================


            PRINT '================================================'
			PRINT 'Loading Products Table'
			PRINT '================================================'

			SET @start_time = GETDATE();

			PRINT 'Truncating Table:Core.Products'
			TRUNCATE TABLE Core.Products

            INSERT INTO Core.Products(
	            ProductID, 
	            ProductKey,	
	            ProductName, 
	            ProductCost,
	            ProductCategory, 
	            ProductStartDate, 
	            ProductEndDate 
            )

            SELECT 

	            TRY_CAST(prd_id AS INT) AS ProductID,

	            SUBSTRING(prd_key, 7, LEN(prd_key)) AS ProductKey,

	            prd_nm AS ProductName,	

	            TRY_CAST(NULLIF(prd_cost, '') AS DECIMAL(10,2)) AS ProdutCost,
	

	            CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
		             WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
		             WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
		             WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
		             ELSE 'n/a'
	            END AS ProductCategory,

            ---Formatted start_dt
	            CONVERT(VARCHAR(10), TRY_CAST(prd_start_dt AS DATE), 103) AS ProductStartDate,
	
            ---Formatted end_dt
	            CONVERT(
	            VARCHAR(10), 
	            DATEADD(
		            DAY,
		            -1,
	            LEAD(TRY_CAST(prd_start_dt AS DATE))
		            OVER (PARTITION BY prd_key ORDER BY TRY_CAST(prd_start_dt AS DATE))
		            ),
		            103)
		            AS ProductEndDate


            FROM Staging.Products;

            SET @end_time = GETDATE();
			PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'


/*
-- Quality Checks After inserting data
-- Check for Nulls or Duplicates 
SELECT 
ProductKey,
COUNT(*)
FROM Core.Products
GROUP BY ProductKey
HAVING COUNT(*) > 1 OR ProductKey IS NULL

-- Check for unwanted spaces
SELECT ProductKey 
FROM Core.Products
WHERE ProductKey != TRIM(ProductKey)

--Check for Invalid Date Orders
SELECT *
FROM Core.Products
WHERE ProductEndDate < ProductStartDate
*/


---======================== INSERT DATA FROM STAGING.Sales TO CORE.Sales ======================
            
            PRINT '================================================'
			PRINT 'Loading Core.Sales Table'
			PRINT '================================================'


			DECLARE @start_time DATETIME;
			DECLARE @end_time   DATETIME;
            
			BEGIN TRY

			SET @start_time = GETDATE();
			PRINT 'Truncating Table:Core.Sales'
			TRUNCATE TABLE Core.Sales

            INSERT INTO Core.Sales (
                OrderNumber,
                ProductID,
                CustomerID,
                OrderDate,
                ShipDate,
                DueDate,
                Sales,
                Quantity,
                Price
            )
            SELECT
                TRY_CAST(sls_OrderID AS VARCHAR(50))          AS OrderNumber,
                TRY_CAST(sls_prd_key AS NVARCHAR(50))         AS ProductID,
                TRY_CAST(sls_cust_id AS INT)                  AS CustomerID,

                -- Order Date
                CASE 
                    WHEN sls_order_dt = 0 OR LEN(sls_order_dt) <> 8 THEN NULL
                    ELSE CONVERT(DATE, CONVERT(VARCHAR(8), sls_order_dt))
                END AS OrderDate,

                -- Ship Date
                CASE 
                    WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) <> 8 THEN NULL
                    ELSE CONVERT(DATE, CONVERT(VARCHAR(8), sls_ship_dt))
                END AS ShipDate,

                -- Due Date
                CASE 
                    WHEN sls_due_dt = 0 OR LEN(sls_due_dt) <> 8 THEN NULL
                    ELSE CONVERT(DATE, CONVERT(VARCHAR(8), sls_due_dt))
                END AS DueDate,

                -- Sales (recalculate if missing or incorrect)
                CASE 
                    WHEN TRY_CAST(sls_sales AS DECIMAL(18,2)) IS NULL
                      OR TRY_CAST(sls_sales AS DECIMAL(18,2)) <= 0
                      OR TRY_CAST(sls_sales AS DECIMAL(18,2)) 
                         <> TRY_CAST(sls_quantity AS INT) * ABS(TRY_CAST(sls_price AS DECIMAL(18,2)))
                    THEN 
                        TRY_CAST(sls_quantity AS INT) * ABS(TRY_CAST(sls_price AS DECIMAL(18,2)))
                    ELSE 
                        TRY_CAST(sls_sales AS DECIMAL(18,2))
                END AS Sales,

                -- Quantity
                TRY_CAST(sls_quantity AS INT) AS Quantity,

                -- Price (derive if invalid)
                CASE 
                    WHEN TRY_CAST(sls_price AS DECIMAL(18,2)) IS NULL
                      OR TRY_CAST(sls_price AS DECIMAL(18,2)) <= 0
                    THEN 
                        TRY_CAST(sls_sales AS DECIMAL(18,2)) 
                        / NULLIF(TRY_CAST(sls_quantity AS INT), 0)
                    ELSE 
                        TRY_CAST(sls_price AS DECIMAL(18,2))
                END AS Price

            FROM Staging.Sales;


            SET @end_time = GETDATE();
			PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'



	END TRY

	BEGIN CATCH
		PRINT '===================================='
		PRINT 'ERROR OCUURED DURING lOADING CORE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '===================================='

    END CATCH
	
END


EXEC Core.load_Core

----------------- Stored Prcedure END 
----------------- EXEC Core.load_Core

