-- SQL example file for CST2355
-- Author:  Douglas King

-- Clean up the source data table and created reporting tables for "Calls"
USE LAB5;

DROP TABLE IF EXISTS CallsData
DROP TABLE IF EXISTS CallsCube;
DROP TABLE IF EXISTS CallsCube2;
-- End of Clean up section

-- Create the CallsData
--   For lab5 - students need to create the table and then edit the inserts to use the foreign key 
--   values in the Departments and Employees tables already in their lab4EmployeeData schema
--
CREATE TABLE CallsData ( Country VARCHAR(50), Region VARCHAR(50), DepartmentID INT, EmployeeID INT, CallTime datetime, Calls INT );

INSERT INTO CallsData VALUES (N'Canada', N'Alberta', 1, 2, CONVERT(DATETIME, '2021-08-15', 102), 100);
INSERT INTO CallsData VALUES (N'Canada', N'Ontario', 2, 3, CONVERT(DATETIME, '2019-06-12', 102), 200);
INSERT INTO CallsData VALUES (N'Canada', N'British Columbia', 1, 4, CONVERT(DATETIME, '2019-08-15', 102), 300);
INSERT INTO CallsData VALUES (N'United States', N'New York', 1, 3, CONVERT(DATETIME, '2020-08-15', 102), 100);
INSERT INTO CallsData VALUES (N'Canada', N'Alberta', 2, 4, CONVERT(DATETIME, '2020-07-15', 102), 100);
INSERT INTO CallsData VALUES (N'Canada', N'Ontario', 1, 2, CONVERT(DATETIME, '2020-04-15', 102), 200);
INSERT INTO CallsData VALUES (N'Canada', N'British Columbia', 2, 1, CONVERT(DATETIME, '2020-05-15', 102), 300);
INSERT INTO CallsData VALUES (N'United States', N'New York', 2, 4, CONVERT(DATETIME, '2019-11-15', 102), 100);
-- End of Create CallsData section


-- Here are some examples to demonstrate ROLLUP and CUBE operations to look at and edit
--   For lab5 - need to join with Employees and Departments tables to get employee names and department names.

SELECT Country, Region, DepartmentID, EmployeeID, SUM(Calls) AS TotalCalls
FROM CallsData
GROUP BY Country, Region, DepartmentID, EmployeeID;

SELECT YEAR(CallTime) as 'Year', MONTH(CallTime) as 'Month', DAY(CallTime) as 'Day', SUM(Calls) AS TotalCalls
FROM CallsData
GROUP BY ROLLUP (YEAR(CallTime),MONTH(CallTime),DAY(CallTime));

SELECT Country, Region, DepartmentID, EmployeeID, SUM(Calls) AS TotalCalls
FROM CallsData
GROUP BY CUBE (Country, Region, DepartmentID, EmployeeID);
-- End of examples to demonstrate ROLLUP and CUBE operations

-- These examples use the SELECT ... INTO to build "cubes"
SELECT Country, Region, DepartmentID, EmployeeID, SUM(Calls) AS TotalCalls 
INTO CallsCube 
FROM CallsData
GROUP BY CUBE (Country, Region, DepartmentID, EmployeeID);

SELECT * FROM CallsCube;

SELECT Country, Region, DepartmentID, EmployeeID, YEAR(CallTime) as 'Year', MONTH(CallTime) as 'Month', DAY(CallTime) as 'Day', SUM(Calls) AS TotalCalls 
INTO CallsCube2 
FROM CallsData
GROUP BY GROUPING SETS(CUBE(Country, Region, DepartmentID, EmployeeID), ROLLUP(YEAR(CallTime),MONTH(CallTime),DAY(CallTime)))

SELECT * FROM CallsCube2;
-- End of examples that build cubes

-- End of File