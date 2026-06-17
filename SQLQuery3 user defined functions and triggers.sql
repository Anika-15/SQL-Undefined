-- Q: How can the database automatically log who altered a row and when that change happened?
-- A: We can bind an AFTER UPDATE database trigger to our table that captures modifications 
--    and updates our metadata columns using GETDATE() and SUSER_NAME().

-- Research Source URL: https://learn.microsoft.com/en-us/sql/t-sql/statements/create-trigger-transact-sql
-- Validated execution paths using the virtual system tracking table 'inserted'.

USE EC_IT143_DA;
GO

CREATE TRIGGER dbo.tr_w3_customers_after_update
ON dbo.t_w3_schools_customers
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Avoid recursive looping issues by verifying if this operation changes metadata columns directly
    IF NOT UPDATE(last_modified_date) AND NOT UPDATE(last_modified_by)
    BEGIN
        UPDATE target
        SET target.last_modified_date = GETDATE(),
            target.last_modified_by = SUSER_NAME()
        FROM dbo.t_w3_schools_customers AS target
        INNER JOIN inserted AS i ON target.CustomerID = i.CustomerID;
    END
END;
GO

-- Run a localized test to see if our trigger intercepts the modification event successfully
UPDATE dbo.t_w3_schools_customers
SET CustomerName = 'Alfreds Futterkiste (Modified Test)'
WHERE CustomerID = 1;

-- Verify that the trigger instantly recorded when and who performed the command
SELECT CustomerID, CustomerName, last_modified_date, last_modified_by
FROM dbo.t_w3_schools_customers
WHERE CustomerID = 1;

