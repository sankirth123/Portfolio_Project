/*
=============
DDL script: Create Staging Table
=============

Creating DB
Creating schemas Staging, Core, Reporting
*/
-- Make the table empty and load using truncate
USE TrendlyDB



CREATE SCHEMA Staging; 
GO 

CREATE SCHEMA Core; 
GO 

CREATE SCHEMA Reporting; 
GO


---Creating Tables in Trendly DB (Staging, RAW data)
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
    sls_quantity NVARCHAR(50),
    sls_price NVARCHAR(50)
);


---------------------------------- Bulk insert SALES data ----------------------------

/*If we run Bulk insert again we will get duplicate data, so to Make table empty and load
Truncate - Deleted all rows from a table, resetting to an empty state

*/
-- Creating stored procedure for Staging_Layer --
EXEC Staging.load_Staging

CREATE OR ALTER PROCEDURE Staging.load_Staging AS
BEGIN
	PRINT '================================================'
	PRINT 'Loading Staging Layer'
	PRINT '================================================'

	PRINT 'Truncating Table:Staging.Sales'
	TRUNCATE TABLE Staging.Sales

	PRINT 'Inserting Data into: Staging.Sales'
	BULK INSERT Staging.Sales
	FROM 'D:\Euron\Trendly_CSV\Sales.CSV'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	-------------------------  Bulk insert PRODUCTS data  -----------------

	/*If we run Bulk insert again we will get duplicate data, so to Make table empty and load
	Truncate - Deleted all rows from a table, resetting to an empty state

	*/
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



	---------------------------   Bulk insert Customers data  -----------------
	/*If we run Bulk insert again we will get duplicate data, so to Make table empty and load
	Truncate - Deleted all rows from a table, resetting to an empty state

	*/
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


END



----Quality check & checking data not shifted and is in correct column
----Validating ROW count
SELECT * FROM Staging.Customers;

SELECT COUNT(*) FROM Staging.Customers;

----Quality check & checking data not shifted and is in correct column
----Validating ROW count
SELECT * FROM Staging.Products;

SELECT COUNT(*) FROM Staging.Products;

----Quality check & checking data not shifted and is in correct column
----Validating ROW count
SELECT * FROM Staging.Sales;

SELECT COUNT(*) FROM Staging.Sales;
