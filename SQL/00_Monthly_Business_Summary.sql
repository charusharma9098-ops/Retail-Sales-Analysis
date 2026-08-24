CREATE DATABASE IF NOT EXISTS retail_sales_project;
USE retail_sales_project;

/*
Monthly Business Summary

Purpose:
Summarize key business KPIs at monthly level and identify
significant changes for further drill-down analysis.
*/

WITH monthly_summary AS (
SELECT
YEAR(`Order Date`) AS year_,
MONTH(`Order Date`) AS month_,
MONTHNAME(`Order Date`) AS month_name,
ROUND(SUM(Sales), 2) AS total_revenue,
COUNT(DISTINCT `Order ID`) AS total_orders,
ROUND(SUM(Sales) / COUNT(DISTINCT `Order ID`),2) AS total_AOV,
COUNT(DISTINCT `Customer ID`) AS total_customers,
ROUND(SUM(CASE WHEN `Returned` = 'Yes' THEN 1 ELSE 0 END)*100/ COUNT(DISTINCT `Order ID`),2) AS return_rate,
ROUND(SUM(Profit), 2) AS total_profit,
ROUND(SUM(Cost), 2) AS total_cost,
ROUND(AVG(Discount) * 100, 2) AS avg_discount
FROM superstore
GROUP BY
YEAR(`Order Date`),
MONTH(`Order Date`),
MONTHNAME(`Order Date`)
),

monthly_with_previous AS (
SELECT*,
        
LAG(total_revenue) OVER (ORDER BY year_, month_) AS previous_revenue,
LAG(total_orders) OVER (ORDER BY year_, month_) AS previous_orders,
LAG(total_AOV) OVER (ORDER BY year_, month_) AS previous_AOV,
LAG(total_customers) OVER (ORDER BY year_, month_) AS previous_customers,
LAG(return_rate) OVER (ORDER BY year_, month_) AS previous_return_rate,
LAG(total_profit) OVER (ORDER BY year_, month_) AS previous_profit,
LAG(total_cost) OVER (ORDER BY year_, month_) AS previous_cost,
LAG(avg_discount) OVER (ORDER BY year_, month_) AS previous_discount
FROM monthly_summary
)

SELECT*,
ROUND((total_revenue - previous_revenue) * 100/ NULLIF(previous_revenue, 0),2) AS revenue_pct_change,
ROUND((total_orders - previous_orders) * 100/ NULLIF(previous_orders, 0),2) AS orders_pct_change,
ROUND((total_AOV - previous_AOV) * 100/ NULLIF(previous_AOV, 0),2) AS AOV_pct_change,
ROUND((total_customers - previous_customers) * 100/ NULLIF(previous_customers, 0),2) AS customers_pct_change,
ROUND((return_rate - previous_return_rate) * 100/ NULLIF(previous_return_rate, 0),2) AS return_rate_pct_change,
ROUND((total_profit - previous_profit) * 100/ NULLIF(previous_profit, 0),2) AS profit_pct_change,
ROUND((total_cost - previous_cost) * 100/ NULLIF(previous_cost, 0),2) AS cost_pct_change,
ROUND((avg_discount - previous_discount) * 100/ NULLIF(previous_discount, 0),2) AS discount_pct_change
FROM monthly_with_previous
ORDER BY year_,
month_;

