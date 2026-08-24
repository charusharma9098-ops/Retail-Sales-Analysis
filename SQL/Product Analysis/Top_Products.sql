CREATE DATABASE retail_sales_project;
USE retail_sales_project;


/*
Top 5 Products by Revenue:
Identify the highest-revenue products and evaluate
their profit and order volume as supporting KPIs.
*/

SELECT `Product Name`,
sum(sales) AS total_revenue,
sum(profit) AS total_profit,
count(distinct `Order ID`) AS total_orders,
RANK()OVER(ORDER BY sum(sales) DESC) AS ranking
FROM superstore
GROUP BY `Product Name`
LIMIT 5;
