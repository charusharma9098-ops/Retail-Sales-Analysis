CREATE DATABASE retail_sales_project;
USE retail_sales_project;
/*
Overall Month Comparison

Purpose:
Compare selected months at the overall business level
to validate the identified return-rate increase before
starting category-level drill-down analysis.

KPIs:
- Total Revenue
- Total Orders
- Returned Orders
- Return Rate
- Absolute Change
- Percentage Change

This analysis is used to confirm the selected month pair
for further return-rate driver analysis.
*/

WITH Overall AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders,
COUNT(DISTINCT CASE WHEN returned = 'Yes' THEN `Order ID` END) AS returned_orders,
COUNT(DISTINCT CASE
	WHEN returned = 'Yes'
	THEN `Order ID`
	END) * 100.0 / NULLIF(COUNT(DISTINCT `Order ID`), 0) AS return_rate
FROM superstore
WHERE `Order Date` >= '2024-08-01'
AND `Order Date` < '2024-10-01'
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`)
),

Overall_with_previous AS (
SELECT *,
LAG(total_revenue) OVER (ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (ORDER BY year_, month_no) AS previous_orders,
LAG(returned_orders) OVER (ORDER BY year_, month_no) AS previous_returned_orders,
LAG(return_rate) OVER (ORDER BY year_, month_no) AS previous_return_rate
FROM Overall
)

SELECT *,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,
returned_orders - previous_returned_orders AS Absolute_returned_orders_change,
return_rate - previous_return_rate AS Absolute_return_rate_change,


ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change,
ROUND((returned_orders- previous_returned_orders ) * 100/ NULLIF( previous_returned_orders, 0),2) AS returned_orders_pct_change,
ROUND((return_rate - previous_return_rate) * 100/ NULLIF(previous_return_rate, 0),2) AS return_rate_pct_change

FROM Overall_with_previous
ORDER BY
    year_,
    month_no;
    
    
/*
Category-level drill-down for Return Rate:
Compare category-level return rate between the selected months
to identify the category contributing most to the return-rate increase.
*/

WITH Category_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Category`,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders,
COUNT(DISTINCT CASE WHEN returned = 'Yes'THEN `Order ID`END) AS returned_orders,
COUNT(DISTINCT CASE
	WHEN returned = 'Yes'
	THEN `Order ID`
	END) * 100.0 / NULLIF(COUNT(DISTINCT `Order ID`), 0) AS return_rate
FROM superstore
WHERE `Order Date` >= '2024-08-01'
AND `Order Date` < '2024-10-01'
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Category`
),

Category_with_previous AS (
SELECT *,

LAG(total_revenue) OVER (PARTITION BY `Category` ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_orders,
LAG(returned_orders) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_returned_orders,
LAG(return_rate) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_return_rate

FROM Category_wise
)

SELECT *,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,
returned_orders - previous_returned_orders AS Absolute_returned_orders_change,
return_rate - previous_return_rate AS Absolute_return_rate_change,

ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change,
ROUND((returned_orders - previous_returned_orders)*100/ NULLIF(previous_returned_orders, 0),2) AS returned_orders_pct_change,
ROUND((return_rate - previous_return_rate) * 100/ NULLIF(previous_return_rate, 0),2)AS return_rate_pct_change
FROM Category_with_previous
ORDER BY
    year_,
    month_no;    
    
    
 
 /*
Product-level drill-down for Return Rate:
Compare product-level return rates between the selected months
to identify the product contributing most to the return-rate increase.
*/

WITH Product_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Product Name`,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders,
COUNT(DISTINCT CASE WHEN returned = 'Yes' THEN `Order ID` END) AS returned_orders,
COUNT(DISTINCT CASE
	WHEN returned = 'Yes'
	THEN `Order ID`
	END) * 100.0/ NULLIF(COUNT(DISTINCT `Order ID`), 0) AS return_rate
FROM superstore
WHERE `Order Date` >= '2024-08-01'
AND `Order Date` < '2024-10-01'
AND `Category` = 'Furniture'
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Product Name`
),

Product_with_previous AS (
SELECT *,

LAG(total_revenue) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_orders,
LAG(returned_orders) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_returned_orders,
LAG(return_rate) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_return_rate
FROM Product_wise
)

SELECT *,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,
returned_orders - previous_returned_orders AS Absolute_returned_orders_change,
return_rate - previous_return_rate AS Absolute_return_rate_change,

ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change,
ROUND((returned_orders - previous_returned_orders)*100/ NULLIF(previous_returned_orders, 0),2) AS returned_orders_pct_change,
ROUND((return_rate - previous_return_rate) * 100/ NULLIF(previous_return_rate, 0),2) AS return_rate_pct_change

FROM Product_with_previous
ORDER BY
    year_,
    month_no;
    
    
  
/*
Regional drill-down for Return Rate:
Compare regional return rates for Laptop Stand
to identify the region contributing most to the return-rate increase.
*/

WITH Region_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
Region,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders,
COUNT(DISTINCT CASE WHEN returned = 'Yes'THEN `Order ID`END) AS returned_orders,
COUNT(DISTINCT CASE WHEN returned = 'Yes' THEN `Order ID` END) * 100.0/ NULLIF(COUNT(DISTINCT `Order ID`), 0) AS return_rate
FROM superstore
WHERE `Order Date` >= '2024-08-01'
AND `Order Date` < '2024-10-01'
AND `Category` = 'Furniture'
AND `Product Name` = 'Laptop Stand'
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
Region
),

Region_with_previous AS (
SELECT *,

LAG(total_revenue) OVER (PARTITION BY Region ORDER BY year_, month_no ) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY Region ORDER BY year_, month_no ) AS previous_orders,
LAG(returned_orders) OVER ( PARTITION BY Region ORDER BY year_, month_no) AS previous_returned_orders,
LAG(return_rate) OVER (PARTITION BY Region ORDER BY year_, month_no) AS previous_return_rate 
FROM Region_wise
)

SELECT *,

total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,
returned_orders - previous_returned_orders AS Absolute_returned_orders_change,
return_rate - previous_return_rate AS Absolute_return_rate_change,
ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change,
ROUND((returned_orders - previous_returned_orders) * 100/ NULLIF(previous_returned_orders, 0),2) AS returned_orders_pct_change,
ROUND((return_rate - previous_return_rate) * 100/ NULLIF(previous_return_rate, 0),2) AS return_rate_pct_change
FROM Region_with_previous
ORDER BY
    year_,
    month_no;  