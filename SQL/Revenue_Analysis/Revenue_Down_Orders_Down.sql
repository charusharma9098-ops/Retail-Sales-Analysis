CREATE DATABASE retail_sales_project;
USE retail_sales_project;

/*
Overall Month Comparison

Purpose:
Compare selected months at the overall business level
to validate the identified business variation before
starting category-level drill-down analysis.

KPIs:
- Total Revenue
- Total Orders
- Absolute Change
- Percentage Change

This analysis is used to confirm the selected month pair
for further business driver analysis.
*/
WITH Overall AS (
SELECT 
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore
WHERE `Order Date` >= '2023-05-01'
AND `Order Date` < '2023-07-01'
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`)
),

Overall_with_previous AS (
SELECT *,
LAG(total_revenue) OVER (ORDER BY year_, month_no) AS previous_revenue,

LAG(total_orders) OVER (ORDER BY year_, month_no) AS previous_orders

FROM Overall
)

SELECT*,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,

ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change
FROM Overall_with_previous
ORDER BY
year_,
month_no;


/* Category-level drill-down to identify the main driver of order decline */

WITH Category_wise AS (
SELECT 
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Category`,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore
WHERE `Order Date` >= '2023-05-01'
AND `Order Date` < '2023-07-01'
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Category`

),

Category_with_previous AS (
SELECT *,
LAG(total_revenue) OVER ( PARTITION BY Category ORDER BY year_, month_no) AS previous_revenue,

LAG(total_orders) OVER (PARTITION BY Category ORDER BY year_, month_no) AS previous_orders

FROM Category_wise
)

SELECT*,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,

ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change
FROM Category_with_previous
ORDER BY
year_,
month_no;


/*
Product-level drill-down for Orders Down:
Compare product revenue and orders between the selected months
to identify the product with the largest order decline.
*/

WITH Product_wise AS (
SELECT 
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Product Name`,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore
WHERE `Order Date` >= '2023-05-01'
AND `Order Date` < '2023-07-01'
AND Category="Furniture"
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Product Name`
),


Product_with_previous AS (
SELECT *,
LAG(total_revenue) OVER (PARTITION BY `Product Name` ORDER BY year_, month_no) AS previous_revenue,

LAG(total_orders) OVER (PARTITION BY `Product Name` ORDER BY year_, month_no) AS previous_orders

FROM Product_wise
)

SELECT*,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,

ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change
FROM Product_with_previous
ORDER BY
year_,
month_no;


/*
Regional drill-down for Orders Down:
Compare regional orders between the selected months
to identify the regions contributing most to the order decline.
*/

WITH Region_wise AS (
SELECT 
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
Region,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore
WHERE `Order Date` >= '2023-05-01'
AND `Order Date` < '2023-07-01'
AND `Product Name`="Laptop Stand"
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
Region
),

Region_with_previous AS (
SELECT *,
LAG(total_revenue) OVER (PARTITION BY Region ORDER BY year_, month_no) AS previous_revenue,

LAG(total_orders) OVER (PARTITION BY Region ORDER BY year_, month_no) AS previous_orders

FROM Region_wise
)

SELECT*,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,

ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change
FROM Region_with_previous
ORDER BY
year_,
month_no;



