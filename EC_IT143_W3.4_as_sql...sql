/****************************************************************************************************************-
-- Script Name: EC_IT143_W3.4_as.sql
-- Author: Anika Saidi
-- Purpose: AdventureWorks SQL Answers Assignment (Part 2)
-- Created Date: 2026-11-14
-- Runtime Estimate: ~5 seconds
-----------------------------------------------------------------------------------------------------------------*/

USE AdventureWorks2022;
GO

-- ==========================================
-- CATEGORY 1: Marginal Complexity (Business User)
-- ==========================================

-- Q1 (Marginal - My Question): What are the job titles and hire dates of our ten most recently hired employees?
-- Original Author: Me
SELECT TOP 10 
    JobTitle, 
    HireDate
FROM HumanResources.Employee
ORDER BY HireDate DESC;
GO

-- Q2 (Marginal - Classmate Question): Which five bike models have the highest standard manufacturing cost in our product catalog?
-- Original Author: Classmate A
SELECT TOP 5 
    Name, 
    StandardCost
FROM Production.Product
WHERE Style IS NOT NULL
ORDER BY StandardCost DESC;
GO


-- ==========================================
-- CATEGORY 2: Moderate Complexity (Business User)
-- ==========================================

-- Q3 (Moderate - Classmate Question): We want to review our sales team's performance. Which three sales territories generated the highest year-to-date sales totals?
-- Original Author: Classmate B
SELECT TOP 3 
    Name AS TerritoryName, 
    SalesYTD
FROM Sales.SalesTerritory
ORDER BY SalesYTD DESC;
GO

-- Q4 (Moderate - Classmate Question): Our warehouse team is auditing inventory levels. Which five products currently have the lowest total quantity available across all storage locations?
-- Original Author: Classmate C
SELECT TOP 5 
    ProductID, 
    SUM(Quantity) AS TotalInventory
FROM Production.ProductInventory
GROUP BY ProductID
ORDER BY TotalInventory ASC;
GO


-- ==========================================
-- CATEGORY 3: Increased Complexity (Business User)
-- ==========================================

-- Q5 (Increased - Classmate Question): I am reviewing our customer retention and order volume in North America. Specifically, I want to identify our most loyal individual buyers. Can you provide a list of the top five customers who placed the highest number of online orders during 2013, including their IDs and total order counts?
-- Original Author: Classmate D
SELECT TOP 5 
    CustomerID, 
    COUNT(SalesOrderID) AS TotalOrders
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2013-01-01' 
  AND OrderDate <= '2013-12-31' 
  AND OnlineOrderFlag = 1
GROUP BY CustomerID
ORDER BY TotalOrders DESC;
GO

-- Q6 (Increased - Classmate Question): Our purchasing department is evaluating vendor reliability for bicycle components. We need to see which suppliers provide the fastest turnaround times. Which three vendors have the shortest average lead time for products we purchase?
-- Original Author: Classmate E
SELECT TOP 3 
    BusinessEntityID AS VendorID, 
    AVG(AverageLeadTime) AS AvgLeadTimeDays
FROM Purchasing.ProductVendor
GROUP BY BusinessEntityID
ORDER BY AvgLeadTimeDays ASC;
GO


-- ==========================================
-- CATEGORY 4: Metadata Questions
-- ==========================================

-- Q7 (Metadata - Classmate Question): Can you provide a complete list of all base tables in the AdventureWorks database that belong to the Sales schema?
-- Original Author: Classmate F
SELECT 
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Sales' 
  AND TABLE_TYPE = 'BASE TABLE';
GO

-- Q8 (Metadata - My Question): Which columns in the AdventureWorks database contain the exact name BusinessEntityID?
-- Original Author: Me
SELECT 
    TABLE_SCHEMA, 
    TABLE_NAME, 
    COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME = 'BusinessEntityID';
GO