/*
Creating DB
Creating schemas Staging, Core, Reporting
*/
-- Make the table empty and load using truncate
USE TrendlyDB
GO


CREATE SCHEMA Staging; 
GO 

CREATE SCHEMA Core; 
GO 

CREATE SCHEMA Reporting; 
GO


---===================== Creating Tables in TrendlyDB - Staging.Tables(Customers, Products, Sales) RAW data =============
--TSQL logic

IF OBJECT_ID ('Staging.Customers','U') IS NOT NULL
	DROP TABLE Staging.Customers;


CREATE TABLE Staging.Customers(

	cst_id NVARCHAR(50),
	cst_key	NVARCHAR(50),
	cst_firstname	NVARCHAR(50), 
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date NVARCHAR(50)
);



IF OBJECT_ID ('Staging.Products','U') IS NOT NULL
	DROP TABLE Staging.Products;

CREATE TABLE Staging.Products(

	prd_id INT,
	prd_key	NVARCHAR(50),
	prd_nm	NVARCHAR(50),
	prd_cost NVARCHAR(50),
	prd_line NVARCHAR(50),
	prd_start_dt NVARCHAR(50),
	prd_end_dt NVARCHAR(50)
);




IF OBJECT_ID ('Staging.Sales','U') IS NOT NULL
	DROP TABLE Staging.Sales;


CREATE TABLE Staging.Sales(
    sls_OrderID NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id NVARCHAR(50),
    sls_order_dt NVARCHAR(50),
    sls_ship_dt NVARCHAR(50),
    sls_due_dt NVARCHAR(50),
	sls_sales NVARCHAR(50),
    sls_quantity NVARCHAR(50),
    sls_price NVARCHAR(50)
);
GO


---===================== Creating Core.Tables in TrendlyDB(Customers, Products, Sales) Cleaned data =============

---=== Core.Customers TABLE ===

IF OBJECT_ID ('Core.Customers','U') IS NOT NULL
	DROP TABLE Core.Customers;


CREATE TABLE Core.Customers(

	CustomerID INT PRIMARY KEY,
	CustomerKey	NVARCHAR(50),
	CustomerFirstName VARCHAR(50),
	CustomerLastName VARCHAR(50),
	CustomerMaritalStatus VARCHAR(50),
	CustomerGender VARCHAR(50),
	CustomerCreateDate DATE
);


---=== Core.Products TABLE ===--

IF OBJECT_ID ('Core.Products','U') IS NOT NULL
	DROP TABLE Core.Products;

CREATE TABLE Core.Products(

	ProductID INT PRIMARY KEY,
	ProductKey	NVARCHAR(50),
	ProductName VARCHAR(50),
	ProductCost Decimal(10,2),
	ProductCategory VARCHAR(50),
	ProductStartDate DATE,
	ProductEndDate DATE
);


---=== Core.Sales TABLE ===--

IF OBJECT_ID ('Core.Sales','U') IS NOT NULL
	DROP TABLE Core.Sales;

CREATE TABLE Core.Sales(
    OrderNumber  VARCHAR(50),
    ProductID NVARCHAR(50),
    CustomerID INT,
    OrderDate DATE,
    ShipDate DATE,
    DueDate DATE,
    Sales Decimal(10,2),
    Quantity INT,
    Price Decimal(10,2)
);
GO

---------------------------------- Bulk insert SALES data ----------------------------

/*If we run Bulk insert again we will get duplicate data, so to Make table empty and load
Truncate - Deleted all rows from a table, resetting to an empty state

*/
-- Creating stored procedure for Staging_Layer --
/*
--TRY,CATCH--
Ensures Error handling, data integrity, issues logging for easier debugging 
SQL runs TRY block if it fails, it runs CATCH block to handle errors 

--Track ETL Duration--
Helps to identify bottlenecks, optimize performance, monitor trends, detect issues

*/


------- Stored Prcedure Start
--------EXEC Staging.load_Staging 

CREATE OR ALTER PROCEDURE Staging.load_Staging AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
			PRINT '================================================'
			PRINT 'Loading Staging Layer'
			PRINT '================================================'


			PRINT '================================================'
			PRINT 'Loading Sales Table'
			PRINT '================================================'


			SET @start_time = GETDATE();
			PRINT 'Truncating Table:Staging.Sales'
			TRUNCATE TABLE Staging.Sales

  			BULK INSERT Staging.Sales
			FROM 'D:\Euron\Trendly_CSV\Sales.CSV'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'


-------------- -----------  Bulk insert PRODUCTS data  -----------------

			/*If we run Bulk insert again we will get duplicate data, so to Make table empty and load
			Truncate - Deleted all rows from a table, resetting to an empty state

			*/

		

			PRINT '================================================'
			PRINT 'Loading Products Table'
			PRINT '================================================'

			SET @start_time = GETDATE();

			PRINT 'Truncating Table:Staging.Products'
			TRUNCATE TABLE Staging.Products

			PRINT 'Inserting Data into: Staging.Products'
			BULK INSERT Staging.Products
			FROM 'D:\Euron\Trendly_CSV\Products.CSV'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'


			---------------------------   Bulk insert Customers data  -----------------
			/*If we run Bulk insert again we will get duplicate data, so to Make table empty and load
			Truncate - Deleted all rows from a table, resetting to an empty state

			*/
			PRINT '================================================'
			PRINT 'Loading Customers Table'
			PRINT '================================================'


			SET @start_time = GETDATE();
			PRINT 'Truncating Table:Staging.Customers'
			TRUNCATE TABLE Staging.Customers


			PRINT 'Inserting Data into: Staging.Customers'
			BULK INSERT Staging.Customers
			FROM 'D:\Euron\Trendly_CSV\Customers.CSV'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				TABLOCK
			);


			SET @end_time = GETDATE();
			PRINT '>>Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'




	END TRY
	BEGIN CATCH
		PRINT '===================================='
		PRINT 'ERROR OCUURED DURING lOADING STAGING LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '===================================='

	END CATCH
END


 EXEC Staging.load_Staging 

----------------- Stored Prcedure END 
----------------  EXEC Staging.load_Staging 

/*
Checking for NULL or Duplicates,Validating ROW count
Primary should be unique
*/


SELECT 
cst_id, 
COUNT(*) 
FROM Staging.Customers
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL



----Quality check & checking data not shifted and is in correct column
----Validating ROW count
SELECT * FROM Staging.Products;

SELECT COUNT(*) FROM Staging.Products;

----Quality check & checking data not shifted and is in correct column
----Validating ROW count
SELECT * FROM Staging.Sales;
SELECT COUNT(*) FROM Staging.Sales;

 /* 
 Checking for unwanted spaces
 If Original Value Not Equal to same value after trimming,
 Means there are spaces
 */

SELECT cst_firstname
FROM Staging.Customers
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname
FROM Staging.Customers
WHERE cst_lastname != TRIM(cst_lastname)

SELECT cst_marital_status
FROM Staging.Customers
WHERE cst_marital_status != TRIM(cst_marital_status)

SELECT cst_gndr
FROM Staging.Customers
WHERE cst_gndr != TRIM(cst_gndr)
