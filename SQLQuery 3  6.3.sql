-- Materialize the view into a permanent physical table
USE EC_IT143_DA;
GO

-- Drop the table if it already exists from a previous primer task
IF OBJECT_ID('dbo.t_w3_schools_customers', 'U') IS NOT NULL
    DROP TABLE dbo.t_w3_schools_customers;

-- Materialize the table structural layout
SELECT * INTO dbo.t_w3_schools_customers 
FROM dbo.v_w3_schools_customers;

-- Add auditing tracking columns required for our triggers sequence
ALTER TABLE dbo.t_w3_schools_customers
ADD last_modified_date DATETIME NULL,
    last_modified_by   VARCHAR(100) NULL;

-- Q: How can we isolate just the First Name from the combined ContactName column?
-- A: We can calculate the location of the space character using CHARINDEX, 
--    then slice the string from the beginning to that space index using SUBSTRING.
SELECT 
    ContactName,
    SUBSTRING(ContactName, 1, CHARINDEX(' ', ContactName + ' ') - 1) AS FirstName
FROM dbo.t_w3_schools_customers;
-- Research Source URL: https://learn.microsoft.com/en-us/sql/t-sql/functions/substring-transact-sql
-- Handled cases where names do not contain spaces by appending a trailing space padding matrix.

USE EC_IT143_DA;
GO

-- 5.1 First Name Function
CREATE FUNCTION dbo.fn_get_first_name (@FullName VARCHAR(200))
RETURNS VARCHAR(100)
AS
BEGIN
    RETURN SUBSTRING(@FullName, 1, CHARINDEX(' ', @FullName + ' ') - 1);
END;
GO

-- 5.2 Last Name Function (Step 8: Next Question Extension)
CREATE FUNCTION dbo.fn_get_last_name (@FullName VARCHAR(200))
RETURNS VARCHAR(100)
AS
BEGIN
    RETURN SUBSTRING(@FullName, CHARINDEX(' ', @FullName + ' ') + 1, LEN(@FullName));
END;
GO

SELECT 
    ContactName,
    dbo.fn_get_first_name(ContactName) AS Function_First,
    dbo.fn_get_last_name(ContactName) AS Function_Last
FROM dbo.t_w3_schools_customers;

;WITH TestCTE AS (
    SELECT 
        ContactName,
        dbo.fn_get_first_name(ContactName) AS FName,
        SUBSTRING(ContactName, 1, CHARINDEX(' ', ContactName + ' ') - 1) AS AdHocFName
    FROM dbo.t_w3_schools_customers
)
SELECT * FROM TestCTE WHERE FName <> AdHocFName; -- Must return 0 rows if flawless!