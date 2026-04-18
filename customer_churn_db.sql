CREATE DATABASE customer_churn_db;
USE customer_churn_db;

CREATE TABLE Customer_Churn (customerID VARCHAR(20),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(5),
    OnlineBackup VARCHAR(5),
    DeviceProtection VARCHAR(5),
    TechSupport VARCHAR(5),
    StreamingTV VARCHAR(5),
    StreamingMovies VARCHAR(5),
    Contract VARCHAR(20),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(5));

#Either create database and table and import CSV dataset, or create database and then import CSV dataset.

SELECT * FROM `wa_fn-usec_-telco-customer-churn`;

SELECT * FROM Customer_Churn
LIMIT 10;

SELECT tenure, churn FROM Customer_Churn
WHERE Churn = 'Yes'
ORDER BY tenure;

#Checking duplicates
SELECT customerID, COUNT( customerID ) as count_ID
FROM Customer_Churn
GROUP BY customerID
HAVING count(customerID) > 1;

#Total Customers
SELECT COUNT(*) AS TotalCustomers
FROM Customer_Churn;

#Total Customers excluding those who have joined recently, like month-to-month contracts, and checking for long term customers
 SELECT COUNT(*) AS TotalCustomers1
FROM Customer_Churn
WHERE Contract <> 'Month-to-month';

#Total Customers who have not churned, providing a clear picture of cutomer retention
SELECT COUNT(*) AS Longterm_Customers
FROM Customer_Churn
WHERE Churn = 'No';

#Viewing remaining customers details
SELECT customerID, gender, SeniorCitizen, Contract
FROM Customer_Churn
WHERE Churn = 'No';

#Checking missing values
SELECT COUNT(*) AS missing_values
FROM Customer_Churn
WHERE TotalCharges IS NULL OR TotalCharges = '';


#--------------------------PRIMARY KPI: CHURN RATE----------------------------

#Overall Churn rate: 
#Computes the overall churn rate for the dataset, 
#indicating the percentage of customers that have left the service over a specified period.
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS churn_rate_percentage
FROM Customer_Churn;

#Overall Churn rate based on gender
#This query evaluates the churn rate segmented by customer gender, offering insights into whether gender influences retention.
SELECT 
    gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS churn_rate_percentage
FROM Customer_Churn
GROUP BY gender; 

# Churn rate based on SeniorCitizen
SELECT 
    SeniorCitizen,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS churn_rate_percentage
FROM Customer_Churn
GROUP BY SeniorCitizen; 

#Churn rate based on Total Charges
SELECT 
    TotalCharges,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS churn_rate_percentage
FROM Customer_Churn
GROUP BY TotalCharges; 

#Churn rate based on phone service or multiple services
#This query calculates the churn rate grouped 
#by the type of phone service and whether customers have multiple lines, providing insights into service features that may affect churn.

SELECT PhoneService, MultipleLines, COUNT(*) AS ChurnCounts, 
       (COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100 AS ChurnRate
FROM Customer_Churn
WHERE Churn = 'Yes'
GROUP BY PhoneService, MultipleLines
ORDER BY ChurnRate DESC;


##---------------REVENUE KPI------------------
#Average charges based on total charges
SELECT 
    ROUND(AVG(TotalCharges), 2) AS avg_total_charges
FROM Customer_Churn
WHERE Churn = 'Yes';

#Average based on monthly charges
SELECT 
    ROUND(AVG(MonthlyCharges), 2) AS avg_total_charges
FROM Customer_Churn
WHERE Churn = 'Yes';

#





