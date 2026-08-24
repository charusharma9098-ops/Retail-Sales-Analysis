/* Data Understanding - Database and Table Setup */

CREATE DATABASE IF NOT EXISTS retail_sales_project;
USE retail_sales_project;

DROP TABLE IF EXISTS superstore;

CREATE TABLE superstore (
    `Order ID` VARCHAR(20) NOT NULL,
    `Order Date` DATE NOT NULL,
    `Customer ID` VARCHAR(20) NOT NULL,
    `Customer Name` VARCHAR(100) NOT NULL,
    `Customer Type` VARCHAR(20) NOT NULL,
    `Segment` VARCHAR(30) NOT NULL,
    `Region` VARCHAR(20) NOT NULL,
    `State` VARCHAR(50) NOT NULL,
    `City` VARCHAR(50) NOT NULL,
    `Category` VARCHAR(30) NOT NULL,
    `Sub-Category` VARCHAR(50) NOT NULL,
    `Product ID` VARCHAR(20) NOT NULL,
    `Product Name` VARCHAR(100) NOT NULL,
    `Sales` DECIMAL(12,2) NOT NULL,
    `Quantity` INT NOT NULL,
    `Discount` DECIMAL(5,2) NOT NULL,
    `Cost` DECIMAL(12,2) NOT NULL,
    `Profit` DECIMAL(12,2) NOT NULL,
    `Returned` VARCHAR(5) NOT NULL,
    `First Purchase Date` DATE NOT NULL
);

/*Total Rows*/

SELECT COUNT(*) AS total_rows
FROM superstore;

/* Date Range*/
SELECT
MIN(`Order Date`) AS first_order_date,
MAX(`Order Date`) AS last_order_date
FROM superstore;

/*Total Customers*/
SELECT COUNT(DISTINCT `Customer ID`) AS total_customers
FROM superstore;

/* Total Ordes*/
SELECT COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore;

/* Overall Revenue, Cost and Profit */
SELECT
    ROUND(SUM(Sales), 2) AS total_revenue,
    ROUND(SUM(Cost), 2) AS total_cost,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore;

/* Available Categories */
SELECT DISTINCT Category
FROM superstore;

/* Available Sub-Categories */
SELECT DISTINCT `Sub-Category`
FROM superstore
ORDER BY `Sub-Category`;

/* Available Regions */
SELECT DISTINCT Region
FROM superstore
ORDER BY Region;

/* Available Customer Types */
SELECT DISTINCT `Customer Type`
FROM superstore
ORDER BY `Customer Type`;

/* Available Return Status */
SELECT DISTINCT `Returned`
FROM superstore
ORDER BY `Returned`;

/* Discount Range and Average */
SELECT
    MIN(Discount) AS min_discount,
    MAX(Discount) AS max_discount,
    AVG(Discount) AS avg_discount
FROM superstore;