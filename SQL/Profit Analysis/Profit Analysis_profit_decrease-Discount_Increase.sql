CREATE DATABASE retail_sales_project;
USE retail_sales_project;
/*
Overall-level analysis for Profit Down due to Discount Increase:
Compare profit and discount between the selected months
to identify whether the profit decline is associated
with an increase in average discount.
*/

WITH Overall AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
ROUND(SUM(Profit), 2) AS total_profit,
ROUND(AVG(Discount) * 100, 2) AS avg_discount,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore
WHERE `Order Date` >= '2024-04-01'
AND `Order Date` < '2024-06-01'

GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`)
),

Overall_with_previous AS (

SELECT
 *,
LAG(total_profit) OVER (ORDER BY year_, month_no) AS previous_profit,
LAG(avg_discount) OVER (ORDER BY year_, month_no) AS previous_discount,
LAG(total_revenue) OVER (ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (ORDER BY year_, month_no) AS previous_orders

    FROM Overall
)

SELECT *,

total_profit - previous_profit AS Absolute_profit_change,
avg_discount - previous_discount AS Absolute_discount_change,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((total_profit - previous_profit) * 100/ NULLIF(previous_profit, 0),2) AS profit_pct_change,
ROUND((avg_discount - previous_discount) * 100/ NULLIF(previous_discount, 0),2) AS discount_pct_change,
ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change

FROM Overall_with_previous

ORDER BY
    year_,
    month_no;
    



/*
Category-level drill-down for Profit Down due to Discount Increase:
Compare profit and discount across categories between the selected months
to identify the category where discount increased and profit declined the most.
*/

WITH Category_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Category`,
ROUND(SUM(Profit), 2) AS total_profit,
ROUND(AVG(Discount) * 100, 2) AS avg_discount,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders

FROM superstore
WHERE `Order Date` >= '2024-04-01'
AND `Order Date` < '2024-06-01'

GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Category`
),

Category_with_previous AS (

SELECT *,

LAG(total_profit) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_profit,
LAG(avg_discount) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_discount,
LAG(total_revenue) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_orders

    FROM Category_wise
)

SELECT *,

total_profit - previous_profit AS Absolute_profit_change,
avg_discount - previous_discount AS Absolute_discount_change,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((total_profit - previous_profit) * 100/ NULLIF(previous_profit, 0),2) AS profit_pct_change,
ROUND((avg_discount - previous_discount) * 100/ NULLIF(previous_discount, 0),2) AS discount_pct_change,
ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change

FROM Category_with_previous

ORDER BY
    year_,
    month_no;
    
    
    
    /*
Product-level drill-down for Profit Down due to Discount Increase:
Analyze Technology products between the selected months
to identify products with the largest profit decline
and discount increase.
*/

WITH Product_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Product Name`,
ROUND(SUM(Profit), 2) AS total_profit,
ROUND(AVG(Discount) * 100, 2) AS avg_discount,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders

FROM superstore

WHERE `Order Date` >= '2024-04-01'
AND `Order Date` < '2024-06-01'
AND `Category` = 'Technology'

GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Product Name`
),

Product_with_previous AS (

SELECT *,
    
LAG(total_profit) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_profit,
LAG(avg_discount) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_discount,
LAG(total_revenue) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_orders
FROM Product_wise
)

SELECT *,

total_profit - previous_profit AS Absolute_profit_change,
avg_discount - previous_discount AS Absolute_discount_change,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((total_profit - previous_profit) * 100/ NULLIF(previous_profit, 0),2) AS profit_pct_change,
ROUND((avg_discount - previous_discount) * 100/ NULLIF(previous_discount, 0),2) AS discount_pct_change,
ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change

FROM Product_with_previous

ORDER BY
    year_,
    month_no;
    
    
    
/*
Region-level drill-down for Profit Down due to Discount Increase:
Analyze External SSD 1TB across regions between the selected months
to identify the region with the largest profit decline
and discount increase.
*/

WITH Region_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Region`,
ROUND(SUM(Profit), 2) AS total_profit,
ROUND(AVG(Discount) * 100, 2) AS avg_discount,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore
WHERE `Order Date` >= '2024-04-01'
AND `Order Date` < '2024-06-01'
AND `Category` = 'Technology'
AND `Product Name` = 'Laser Printer'
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Region`
),

Region_with_previous AS (

SELECT *,

LAG(total_profit) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_profit,
LAG(avg_discount) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_discount,
LAG(total_revenue) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_revenue,
LAG(total_orders) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_orders

FROM Region_wise
)

SELECT *,

total_profit - previous_profit AS Absolute_profit_change,
avg_discount - previous_discount AS Absolute_discount_change,
total_revenue - previous_revenue AS Absolute_revenue_change,
total_orders - previous_orders AS Absolute_orders_change,

ROUND((total_profit - previous_profit) * 100/ NULLIF(previous_profit, 0),2) AS profit_pct_change,
ROUND((avg_discount - previous_discount) * 100/ NULLIF(previous_discount, 0),2) AS discount_pct_change,
ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change

FROM Region_with_previous

ORDER BY
    year_,
    month_no;