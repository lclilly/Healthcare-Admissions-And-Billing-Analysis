CREATE DATABASE Healthcare_Synthetic_Data

--What does the data look like?
SELECT TOP 10*
FROM Healthcare_Dataset

--How many records do we have?
SELECT COUNT(*) AS Total_Records
FROM Healthcare_Dataset;

--Checking for nulls across key columns
SELECT
	SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
	SUM(CASE WHEN Billing_Amount IS NULL THEN 1 ELSE 0 END) AS Null_Billing,
	SUM(CASE WHEN Admission_Type IS NULL THEN 1 ELSE 0 END) AS Null_Admission_Type
FROM Healthcare_Dataset;

--Finding negative length of stay records
SELECT COUNT(*) AS Bad_Records
FROM Healthcare_Dataset
WHERE DATEDIFF(DAY, Date_of_Admission, Discharge_Date) <0;

--Ranking top 10 patients by billing amount
SELECT TOP 10 Age, Billing_Amount,
	ROW_NUMBER() OVER (ORDER BY Billing_Amount DESC) AS BillingRank
FROM Healthcare_Dataset;

--Ranking patients with each admission type
SELECT Admission_Type, Billing_Amount,
	RANK() OVER (
	PARTITION BY Admission_Type
	ORDER BY Billing_Amount DESC) AS RankWithinType
FROM Healthcare_Dataset;


--Running Total of Billing Amount over time
SELECT Date_of_Admission, Billing_Amount,
	SUM(Billing_Amount) OVER (
	ORDER BY Date_of_Admission
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM Healthcare_Dataset;

-- Ranking medical conditions by avg billing
SELECT Medical_Condition, AVG(Billing_Amount) AS Avg_Billing,
	RANK() OVER (ORDER BY AVG(Billing_Amount) DESC) AS Billing_Rank
FROM Healthcare_Dataset
GROUP BY Medical_Condition;

--Running total of admissions over time
SELECT DATENAME (MONTH, Date_of_Admission) AS Month_Name, COUNT(*) AS Monthly_Admissions,
	SUM(COUNT(*)) OVER (ORDER BY MIN(Date_of_Admission)) AS Running_Total
FROM Healthcare_Dataset
GROUP BY DATENAME(MONTH, Date_of_Admission);

--Identifying high-cost patients relative to their condition average
WITH Condition_Avg AS (
    SELECT 
        Medical_Condition,
        AVG(Billing_Amount) AS Avg_Billing
    FROM Healthcare_Dataset
    GROUP BY Medical_Condition
)
SELECT 
    h.Medical_Condition,
    h.Billing_Amount,
    c.Avg_Billing,
    h.Billing_Amount - c.Avg_Billing AS Variance_From_Average
FROM Healthcare_Dataset h
JOIN Condition_Avg c ON h.Medical_Condition = c.Medical_Condition
WHERE h.Billing_Amount > c.Avg_Billing * 1.5
ORDER BY Variance_From_Average DESC;

--Age grouping
SELECT 
    CASE 
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 50 THEN '31-50'
        WHEN Age BETWEEN 51 AND 70 THEN '51-70'
        ELSE '70+'
    END AS Age_Group,
    COUNT(*) AS Total_Patients,
    AVG(Billing_Amount) AS Avg_Billing,
    AVG(DATEDIFF(DAY, Date_of_Admission, Discharge_Date)) AS Avg_Length_of_Stay
FROM Healthcare_Dataset
GROUP BY 
    CASE 
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 50 THEN '31-50'
        WHEN Age BETWEEN 51 AND 70 THEN '51-70'
        ELSE '70+'
    END
ORDER BY Avg_Billing DESC;