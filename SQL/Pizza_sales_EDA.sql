/*====================================================================
 Project: Pizza Sales Analysis 

 Description:
 This SQL script performs data cleaning and exploratory data analysis
 (EDA) on a pizza sales dataset. The output of these queries was used
 to build an interactive Power BI dashboard for analysing sales
 performance, customer purchasing behaviour, and product performance.
=====================================================================*/


/*====================================================================
 SECTION 1: DATABASE SETUP
=====================================================================*/

-- Create Database
CREATE DATABASE Pizza_DB;

-- Create Table
CREATE TABLE pizza_sales (
    pizza_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    pizza_name_id VARCHAR(50) NOT NULL,
    quantity INT NOT NULL,
    order_date VARCHAR(50),
    order_time TIME NOT NULL,
    unit_price DECIMAL(6,2) NOT NULL,
    total_price DECIMAL(8,2) NOT NULL,
    pizza_size VARCHAR(5) NOT NULL,
    pizza_category VARCHAR(20) NOT NULL,
    pizza_ingredients TEXT,
    pizza_name VARCHAR(100) NOT NULL
);

-- Preview Dataset
SELECT *
FROM pizza_sales;


/*====================================================================
 SECTION 2: DATA CLEANING
=====================================================================*/

-- Disable Safe Update Mode
SET SQL_SAFE_UPDATES = 0;

-- Verify Table Structure
SHOW CREATE TABLE pizza_sales;

-- Check Total Records
SELECT COUNT(*)
FROM pizza_sales;

-- Remove ordinal suffix from dates (e.g. 1st, 2nd)
UPDATE pizza_sales
SET order_date = REPLACE(order_date, 'st', '');

-- Convert VARCHAR to DATE
UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%Y-%M-%D');

-- Change column datatype
ALTER TABLE pizza_sales
MODIFY order_date DATE;

-- Verify converted dates
SELECT DISTINCT order_date
FROM pizza_sales
LIMIT 50;

-- Confirm final table structure
DESCRIBE pizza_sales;


/*====================================================================
 SECTION 3: KEY PERFORMANCE INDICATORS (KPIs)
=====================================================================*/

-- KPI 1: Total Revenue
SELECT
    SUM(total_price) AS Total_Revenue
FROM pizza_sales;

-- KPI 2: Average Order Value
SELECT
    SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value
FROM pizza_sales;

-- KPI 3: Total Pizzas Sold
SELECT
    SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales;

-- KPI 4: Total Orders
SELECT
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales;

-- KPI 5: Average Pizzas per Order
SELECT
    SUM(quantity) / COUNT(DISTINCT order_id) AS Avg_Pizzas_Per_Order
FROM pizza_sales;


/*====================================================================
 SECTION 4: EXPLORATORY DATA ANALYSIS (EDA)
=====================================================================*/

-- Daily Order Trend
-- Identify the busiest trading day.

SELECT
    DAYNAME(order_date) AS Order_Day,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DAYNAME(order_date)
ORDER BY Total_Orders DESC;

----------------------------------------------------------

-- Monthly Order Trend
-- Compare order volumes across each month.

SELECT
    MONTHNAME(order_date) AS Month,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY MONTHNAME(order_date)
ORDER BY Total_Orders DESC;

----------------------------------------------------------

-- Percentage of Sales by Pizza Category

SELECT
    pizza_category,
    SUM(total_price) AS Total_Sales,
    SUM(total_price) * 100 /
        (SELECT SUM(total_price) FROM pizza_sales) AS Sales_Percentage
FROM pizza_sales
GROUP BY pizza_category;

----------------------------------------------------------

-- Percentage of Sales by Pizza Size

SELECT
    pizza_size,
    SUM(total_price) AS Total_Sales,
    SUM(total_price) * 100 /
        (SELECT SUM(total_price) FROM pizza_sales) AS Sales_Percentage
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Sales_Percentage DESC;

----------------------------------------------------------

-- Total Sales by Pizza Category

SELECT
    pizza_category,
    SUM(total_price) AS Total_Sales
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Sales DESC;

----------------------------------------------------------

-- Top 5 Best-Selling Pizzas by Revenue

SELECT
    pizza_name,
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5;

----------------------------------------------------------

-- Top 5 Best-Selling Pizzas by Quantity Sold

SELECT
    pizza_name,
    SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC
LIMIT 5;

----------------------------------------------------------

-- Top 5 Best-Selling Pizzas by Total Orders

SELECT
    pizza_name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5;

----------------------------------------------------------

-- Bottom 5 Pizzas by Revenue

SELECT
    pizza_name,
    SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC
LIMIT 5;

----------------------------------------------------------

-- Bottom 5 Pizzas by Quantity Sold

SELECT
    pizza_name,
    SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity ASC
LIMIT 5;

----------------------------------------------------------

-- Bottom 5 Pizzas by Total Orders

SELECT
    pizza_name,
    COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC
LIMIT 5;


/*====================================================================
 END OF ANALYSIS

 The results from this SQL analysis were imported into Power BI to
 develop an interactive dashboard that provides insights into:

 • Sales Performance
 • Customer Purchasing Behaviour
 • Product Performance
 • Business Trends
 • Executive Decision-Making

=====================================================================