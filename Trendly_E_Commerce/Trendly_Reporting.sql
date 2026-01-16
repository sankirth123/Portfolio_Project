---============================ Reporting Layer ====================

---==========================================
-- Create Dimension: Reporting.dim_customers
-- ==========================================


IF OBJECT_ID('Reporting.dim_Customers', 'V') IS NOT NULL
    DROP VIEW Reporting.dim_Customers;
GO

CREATE VIEW Reporting.dim_Customers
AS
SELECT
    CustomerID,  
    CustomerKey,                              
    CustomerFirstName,                        
    CustomerLastName,                         
    CustomerMaritalStatus,                    
    CustomerGender,                           
    CustomerCreateDate                       
FROM Core.Customers c;
GO


---=========================================
-- Create Dimension: Reporting.dim_Products
-- ==========================================

IF OBJECT_ID('Reporting.dim_Products', 'V') IS NOT NULL
    DROP VIEW Reporting.dim_Products;
GO

CREATE VIEW Reporting.dim_Products
AS
SELECT
    ROW_NUMBER() OVER (ORDER BY ProductKey) AS product_key,  
    ProductKey AS ProductID,                              
    ProductName,
    ProductCost,
    ProductCategory AS Category,                         
    ProductStartDate,                    
    ProductEndDate                                                       
FROM Core.Products p;
GO


---==========================================
-- Create Dimension: Reporting.fact_Sales
-- ==========================================
IF OBJECT_ID('Reporting.fact_Sales', 'V') IS NOT NULL
    DROP VIEW Reporting.fact_Sales;
GO

CREATE VIEW Reporting.fact_Sales
AS
SELECT
    s.OrderNumber       AS OrderID,
    s.ProductID,
    s.Sales             AS Amount,
    s.CustomerID,
    s.OrderDate,
    s.ShipDate,
    s.DueDate,
    s.Quantity,
    s.Price

FROM Core.Sales s
LEFT JOIN Reporting.dim_products p
    ON s.ProductID = p.ProductID
LEFT JOIN Reporting.dim_customers c
    ON s.CustomerID = c.CustomerID;
GO
