CREATE DATABASE reatil_sales_project;
USE retail_sales_project;

/*
Overall Month Comparison

Purpose:
Compare selected months at the overall business level
to validate the identified customer decline before
starting category-level drill-down analysis.

KPIs:
- Total Revenue
- Total Orders
- Total AOV
- Total Customers
- Absolute Change
- Percentage Change

This analysis is used to confirm the selected month pair
for further customer driver analysis.
*/

WITH Overall AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders,
ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`),2) AS total_AOV,
COUNT(DISTINCT `Customer ID`) AS total_customers
FROM superstore
WHERE `Order Date` >= '2024-09-01'
AND `Order Date` < '2024-11-01'
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`)
),

Overall_with_previous AS (
SELECT *,
LAG(total_revenue) OVER (ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (ORDER BY year_, month_no) AS previous_orders,
LAG(total_AOV) OVER (ORDER BY year_, month_no) AS previous_AOV,
LAG(total_customers) OVER (ORDER BY year_, month_no) AS previous_customers
FROM Overall
)

SELECT  *,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,
total_AOV - previous_AOV AS Absolute_AOV_change,
total_customers - previous_customers AS Absolute_customers_change,

ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change,
ROUND((total_AOV - previous_AOV) * 100/ NULLIF(previous_AOV, 0),2) AS AOV_pct_change,
ROUND((total_customers - previous_customers) * 100/ NULLIF(previous_customers, 0),2) AS customers_pct_change

FROM Overall_with_previous
ORDER BY
year_,
month_no;
    


/*
Category-level drill-down for Customers Down:
Compare category-level customers between the selected months
to identify the category contributing most to the customer decline.
*/

WITH Category_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Category`,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders,
ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`),2) AS total_AOV,
COUNT(DISTINCT `Customer ID`) AS total_customers
FROM superstore
WHERE `Order Date` >= '2024-09-01'
AND `Order Date` < '2024-11-01'
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Category`
),

Category_with_previous AS (
SELECT *,

LAG(total_revenue) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_orders,
LAG(total_AOV) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_AOV,
LAG(total_customers) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_customers
FROM Category_wise
)

SELECT *,
Total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,
total_AOV - previous_AOV AS Absolute_AOV_change,
total_customers - previous_customers AS Absolute_customers_change,

ROUND((total_revenue - previous_revenue) * 100 / NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change,
ROUND((total_AOV - previous_AOV) * 100/ NULLIF(previous_AOV, 0),2) AS AOV_pct_change,
ROUND((total_customers - previous_customers) * 100/ NULLIF(previous_customers, 0),2) AS customers_pct_change

FROM Category_with_previous
ORDER BY
    year_,
    month_no;    
    
    
    
    /*
Product-level drill-down for Customers Down:
Compare product-level customers between the selected months
to identify products contributing most to the customer decline.
*/

WITH Product_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Product Name`,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders,
ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`),2) AS total_AOV,
COUNT(DISTINCT `Customer ID`) AS total_customers
FROM superstore
WHERE `Order Date` >= '2024-09-01'
AND `Order Date` < '2024-11-01'
AND `Category` = 'Technology'
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Product Name`
),

Product_with_previous AS (
SELECT *,

LAG(total_revenue) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Product Name` ORDER BY year_, month_no) AS previous_orders,
LAG(total_AOV) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_AOV,
LAG(total_customers) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_customers

FROM Product_wise
)

SELECT
    *,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,
total_AOV - previous_AOV AS Absolute_AOV_change,
total_customers - previous_customers AS Absolute_customers_change,

ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change,
ROUND((total_AOV - previous_AOV) * 100/ NULLIF(previous_AOV, 0),2) AS AOV_pct_change,
ROUND((total_customers - previous_customers) * 100/ NULLIF(previous_customers, 0),2) AS customers_pct_change

FROM Product_with_previous
ORDER BY
    year_,
    month_no;
    



/*
Region-level drill-down for Customers Down:
Compare region-level customers between the selected months
to identify regions contributing most to the customer decline.
*/
    
    
WITH Region_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Region`,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders,
ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`),2) AS total_AOV,
COUNT(DISTINCT `Customer ID`) AS total_customers
FROM superstore
WHERE `Order Date` >= '2024-09-01'
AND `Order Date` < '2024-11-01'
AND `Category` = 'Technology'
AND `Product Name`="Noise cancelling headset"
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Region`
),

Region_with_previous AS (
SELECT *,

LAG(total_revenue) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Region` ORDER BY year_, month_no) AS previous_orders,
LAG(total_AOV) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_AOV,
LAG(total_customers) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_customers

FROM Region_wise
)

SELECT
    *,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,
total_AOV - previous_AOV AS Absolute_AOV_change,
total_customers - previous_customers AS Absolute_customers_change,

ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change,
ROUND((total_AOV - previous_AOV) * 100/ NULLIF(previous_AOV, 0),2) AS AOV_pct_change,
ROUND((total_customers - previous_customers) * 100/ NULLIF(previous_customers, 0),2) AS customers_pct_change

FROM Region_with_previous
ORDER BY
    year_,
    month_no;