CREATE DATABASE hr_analysis;
USE hr_analysis;
SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';
SET GLOBAL local_infile = 1;

CREATE TABLE hr_1 (
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_1.csv'
INTO TABLE hr_1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE hr2 (
    EmployeeID INT,
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(5),
    OverTime VARCHAR(10),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_2.csv'
INTO TABLE hr2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- combine both tables 

CREATE TABLE hr_combined AS
SELECT *
FROM hr_1 h1
JOIN hr2 h2
ON h1.EmployeeNumber = h2.EmployeeID;


/* KPI Creation */

-- Average Attrition Rate for All Departments

SELECT 
    Department,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 AS Attrition_Rate_Percentage
FROM hr_combined
GROUP BY Department;

-- Average Hourly Rate of Male Research Scientists

SELECT 
    AVG(HourlyRate) AS Avg_Hourly_Rate
FROM hr_combined
WHERE Gender = 'Male'
AND JobRole = 'Research Scientist';

-- Attrition Rate vs Monthly Income Stats

SELECT 
    CASE 
        WHEN MonthlyIncome < 5000 THEN 'Low Income'
        WHEN MonthlyIncome BETWEEN 5000 AND 10000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS Income_Group,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 AS Attrition_Rate
FROM hr_combined
GROUP BY Income_Group;

-- Average Working Years for Each Department

SELECT 
    Department,
    AVG(TotalWorkingYears) AS Avg_Working_Years
FROM hr_combined
GROUP BY Department;

-- Job Role vs Work-Life Balance

SELECT 
    JobRole,
    AVG(WorkLifeBalance) AS Avg_WorkLifeBalance
FROM hr_combined
GROUP BY JobRole;

-- Attrition Rate vs Years Since Last Promotion

SELECT 
    YearsSinceLastPromotion,
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 AS Attrition_Rate
FROM hr_combined
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion;