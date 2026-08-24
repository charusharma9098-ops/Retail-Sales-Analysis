CREATE DATABASE retail_sales_project;
USE retail_sales_project;


/*
Overall analysis for Profit Down due to Cost Increase:
Compare profit, cost and revenue between July 2025 and August 2025
to identify the overall change in profit and cost.
*/

WITH Overall AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,

ROUND(SUM(Profit), 2) AS total_profit,
ROUND(SUM(Cost), 2) AS total_cost,
ROUND(SUM(Sales), 2) AS total_revenue

FROM superstore

WHERE `Order Date` >= '2025-07-01'
AND `Order Date` < '2025-09-01'

GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`)
),

Overall_with_previous AS (

SELECT *,

LAG(total_profit) OVER (ORDER BY year_, month_no) AS previous_profit,
LAG(total_cost) OVER (ORDER BY year_, month_no) AS previous_cost,
LAG(total_revenue) OVER (ORDER BY year_, month_no) AS previous_revenue

FROM Overall
)

SELECT *,

total_profit - previous_profit AS Absolute_profit_change,
total_cost - previous_cost AS Absolute_cost_change,
total_revenue - previous_revenue AS Absolute_revenue_change,

ROUND((total_profit - previous_profit) * 100 /NULLIF(previous_profit, 0), 2) AS profit_pct_change,
ROUND((total_cost - previous_cost) * 100 /NULLIF(previous_cost, 0), 2) AS cost_pct_change,
ROUND((total_revenue - previous_revenue) * 100 /NULLIF(previous_revenue, 0), 2) AS revenue_pct_change

FROM Overall_with_previous

ORDER BY
year_,
month_no;




/*
Category-level drill-down for Profit Down due to Cost Increase:
Compare profit and cost across categories between the selected months
to identify the category where cost increased and profit declined the most.
*/

WITH Category_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Category`,

ROUND(SUM(Profit), 2) AS total_profit,
ROUND(SUM(Cost), 2) AS total_cost,
ROUND(SUM(Sales), 2) AS total_revenue

FROM superstore

WHERE `Order Date` >= '2025-07-01'
AND `Order Date` < '2025-09-01'

GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Category`
),

Category_with_previous AS (

SELECT *,

LAG(total_profit) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_profit,
LAG(total_cost) OVER (PARTITION BY `Category` ORDER BY year_, month_no) AS previous_cost,
LAG(total_revenue) OVER (PARTITION BY `Category`ORDER BY year_, month_no) AS previous_revenue

FROM Category_wise
)

SELECT *,

total_profit - previous_profit AS Absolute_profit_change,
total_cost - previous_cost AS Absolute_cost_change,
total_revenue - previous_revenue AS Absolute_revenue_change,

ROUND((total_profit - previous_profit) * 100 /NULLIF(previous_profit, 0), 2) AS profit_pct_change,
ROUND((total_cost - previous_cost) * 100 /NULLIF(previous_cost, 0), 2) AS cost_pct_change,
ROUND((total_revenue - previous_revenue) * 100 /NULLIF(previous_revenue, 0), 2) AS revenue_pct_change

FROM Category_with_previous

ORDER BY
year_,
month_no;




/*
Product-level drill-down for Profit Down due to Cost Increase:
Analyze products within the selected category between the selected months
to identify products with the largest cost increase
and profit decline.
*/

WITH Product_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Product Name`,

ROUND(SUM(Profit), 2) AS total_profit,
ROUND(SUM(Cost), 2) AS total_cost,
ROUND(SUM(Sales), 2) AS total_revenue

FROM superstore

WHERE `Order Date` >= '2025-07-01'
AND `Order Date` < '2025-09-01'

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
LAG(total_cost) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_cost,
LAG(total_revenue) OVER (PARTITION BY `Product Name`ORDER BY year_, month_no) AS previous_revenue

FROM Product_wise
)

SELECT *,

total_profit - previous_profit AS Absolute_profit_change,
total_cost - previous_cost AS Absolute_cost_change,
total_revenue - previous_revenue AS Absolute_revenue_change,

ROUND((total_profit - previous_profit) * 100 /NULLIF(previous_profit, 0), 2) AS profit_pct_change,
ROUND((total_cost - previous_cost) * 100 /NULLIF(previous_cost, 0), 2) AS cost_pct_change,
ROUND((total_revenue - previous_revenue) * 100 /NULLIF(previous_revenue, 0), 2) AS revenue_pct_change

FROM Product_with_previous

ORDER BY
year_,
month_no;



/*
Region-level drill-down for Profit Down due to Cost Increase:
Analyze the selected product across regions between the selected months
to identify the region with the largest cost increase
and profit decline.
*/

WITH Region_wise AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_no,
MONTHNAME(`Order Date`) AS month_name,
`Region`,

ROUND(SUM(Profit), 2) AS total_profit,
ROUND(SUM(Cost), 2) AS total_cost,
ROUND(SUM(Sales), 2) AS total_revenue

FROM superstore

WHERE `Order Date` >= '2025-07-01'
AND `Order Date` < '2025-09-01'

AND `Category` = 'Technology'
AND `Product Name` = '27-inch Monitor'

GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`),
`Region`
),

Region_with_previous AS (

SELECT *,

LAG(total_profit) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_profit,
LAG(total_cost) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_cost,
LAG(total_revenue) OVER (PARTITION BY `Region`ORDER BY year_, month_no) AS previous_revenue

FROM Region_wise
)

SELECT *,

total_profit - previous_profit AS Absolute_profit_change,
total_cost - previous_cost AS Absolute_cost_change,
total_revenue - previous_revenue AS Absolute_revenue_change,

ROUND((total_profit - previous_profit) * 100 /NULLIF(previous_profit, 0), 2) AS profit_pct_change,
ROUND((total_cost - previous_cost) * 100 /NULLIF(previous_cost, 0), 2) AS cost_pct_change,
ROUND((total_revenue - previous_revenue) * 100 /NULLIF(previous_revenue, 0), 2) AS revenue_pct_change

FROM Region_with_previous

ORDER BY
year_,
month_no;