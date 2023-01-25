USE nested_queries;

CREATE TABLE EmployeeSalary
(
  EmployeeID INT,
  JobTitle VARCHAR(250),
  Salary float
);
CREATE TABLE EmployeeDemographics
(
	EmployeeID INT,
    FirstName VARCHAR(250),
    LastName VARCHAR(250),
    Age INT,
    Gender VARCHAR(250)
);

INSERT INTO EmployeeSalary (EmployeeID, JobTitle, Salary)
VALUES('1', 'Data Scientist','120000'),
('2','Software Engineer','150000'),
('3','Data analyst','80000'),
('4','Accountant','70000'),
('5','Receptionist','40000');


INSERT INTO EmployeeDemographics (EmployeeID, FirstName, LastName, Age, Gender)
VALUES('1','Diane','Umurerwa','25','Female'),
('2','Dorcy','Shema','20','Male'),
('3','Alex','Johnson','45','Male'),
('4','Galvin','Jones','40','Male'),
('5','Iyanna','Jones','32','Female');


 

SELECT EmployeeID, JobTitle, Salary
FROM EmployeeSalary;

-- subquery in select average salary for every employee

SELECT EmployeeID, Salary, (SELECT AVG(SALARY) FROM EmployeeSalary) as allAvgSalary
FROM EmployeeSalary;

-- How do it with Partition By 
SELECT EmployeeID, Salary, AVG(Salary ) over() as AllAvgSalary 
FROM EmployeeSalary;

/* Group By does not work since we have to group by both the EmployeeID and Salary 
 so we will not be able to get the all average salary 
*/
SELECT EmployeeID, salary, AVG(Salary) as AllAvgSalary 
FROM EmployeeSalary
GROUP BY EmployeeID, salary
ORDER BY 1,2;


-- Subquery in From ( not recommended to use this) instead use CTE or temp table 

SELECT a.EmployeeID, AllAvgSalary

FROM

      (SELECT EmployeeID, Salary, AVG(Salary) over() as AllAvgSalary
      FROM EmployeeSalary ) a

ORDER BY a.EmployeeID;


-- Subquery in Where could join the tables instead of this method 

SELECT EmployeeID, JobTitle, Salary 
FROM EmployeeSalary 
WHERE EmployeeID in(
   SELECT EmployeeID
   FROM EmployeeDemographics
   WHERE Age <30)


