-- SQL example file for CST2355

USE lab5;

DROP FUNCTION IF EXISTS lab4EmployeeData.ufnGetFullName;  
GO

CREATE FUNCTION lab4EmployeeData.ufnGetFullName(@EmployeeID int)  
RETURNS varchar(50)  
AS   
-- Returns the full name for an employee.  
BEGIN  
    DECLARE @ret varchar(50);  
    SELECT @ret = [Last Name] + ', ' + [First Name]   
    FROM lab4EmployeeData.Employees e   
    WHERE e.ID = @EmployeeID;  
     IF (@ret IS NULL)   
        SET @ret = '';  
    RETURN @ret;  
END;
GO

-- Now try it
SELECT lab4EmployeeData.ufnGetFullName(e.ID) AS 'Full Name' 
FROM
lab4EmployeeData.Employees e;

-- End of file