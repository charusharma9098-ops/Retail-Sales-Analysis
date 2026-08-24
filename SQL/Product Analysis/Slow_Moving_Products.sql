CREATE DATABASE retail_sales_project;
USE retail_sales_project;

/*
Slow-Moving Products:
Identify the bottom 5 products based on total order volume
and evaluate their revenue and profit as supporting KPIs.
*/

SELECT `Product Name`,
sum(sales) AS total_revenue,
sum(profit) AS total_profit,
count(distinct `Order ID`) AS total_orders,
RANK()OVER(ORDER BY count(distinct `Order ID`)) AS ranking
FROM superstore
GROUP BY `Product Name`
LIMIT 5;