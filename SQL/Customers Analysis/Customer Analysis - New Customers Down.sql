CREATE DATABASE retail_sales_project;
USE retail_sales_project;

/*
Overall Month Comparison

Purpose:
Compare selected months at the overall business level
to identify a significant decline in new customers
before starting category-level drill-down analysis.

KPIs:
- New Customers
- Total Revenue
- Total Orders
- Absolute Change
- Percentage Change

This analysis is used to confirm the selected month pair
for further new-customer driver analysis.
*/

WITH Overall AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
COUNT(DISTINCT CASE WHEN `Customer Type` = 'New' THEN `Customer ID`END) AS new_customers,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`)
),

Overall_with_previous AS (
SELECT *,
     
LAG(new_customers) OVER (ORDER BY year_, month_no) AS previous_new_customers,
LAG(total_revenue) OVER (ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (ORDER BY year_, month_no) AS previous_orders

FROM Overall
)

SELECT *,
  
new_customers - previous_new_customers AS Absolute_new_customer_change,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((new_customers - previous_new_customers) * 100/ NULLIF(previous_new_customers, 0),2) AS new_customer_pct_change,
ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change

FROM Overall_with_previous

ORDER BY
    year_,
    month_no;
    
    

/*
Category-level drill-down for New Customers Down:
Compare new customers across categories between the selected months
to identify the category with the largest new-customer decline.
*/


WITH Category_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Category`,
COUNT(DISTINCT CASE WHEN `Customer Type` = 'New' THEN `Customer ID` END) AS new_customers,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders
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

LAG(new_customers) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_new_customers,
LAG(total_revenue) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_orders

FROM Category_wise
)

SELECT *,

new_customers - previous_new_customers AS Absolute_new_customer_change,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((new_customers - previous_new_customers) * 100/ NULLIF(previous_new_customers, 0),2) AS new_customer_pct_change,
ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change

FROM Category_with_previous

ORDER BY
    year_,
    month_no;
    
    /*
Product-level drill-down for New Customers Down:
Compare new customers across Technology products between the selected months
to identify the product contributing most to the new-customer decline.
*/

WITH Product_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Product Name`,
COUNT(DISTINCT CASE WHEN `Customer Type` = 'New'THEN `Customer ID`END) AS new_customers,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders
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

LAG(new_customers) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_new_customers,
LAG(total_revenue) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_orders

FROM Product_wise
)

SELECT *,

new_customers - previous_new_customers AS Absolute_new_customer_change,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((new_customers - previous_new_customers) * 100/ NULLIF(previous_new_customers, 0),2) AS new_customer_pct_change,
ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change

FROM Product_with_previous

ORDER BY
    year_,
    month_no;
    
    
    
/*
Region-level drill-down for New Customers Down:
Compare Webcam new customers across regions between the selected months
to identify the region contributing most to the decline.
*/

WITH Region_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Region`,

COUNT(DISTINCT CASE WHEN `Customer Type` = 'New' THEN `Customer ID`END) AS new_customers,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore
WHERE `Order Date` >= '2024-09-01'
AND `Order Date` < '2024-11-01'
AND `Category` = 'Technology'
AND `Product Name` = 'Webcam'

GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Region`
),

Region_with_previous AS (
SELECT *,

LAG(new_customers) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_new_customers,
LAG(total_revenue) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_orders

FROM Region_wise
)

SELECT *,

new_customers - previous_new_customers AS Absolute_new_customer_change,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,


ROUND((new_customers - previous_new_customers) * 100/ NULLIF(previous_new_customers, 0),2) AS new_customer_pct_change,
ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change

FROM Region_with_previous

ORDER BY
    year_,
    month_no;
    
    