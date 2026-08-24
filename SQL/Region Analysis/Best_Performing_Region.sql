CREATE DATABASE retail_sales_project;
USE retail_sales_project;

/*
Best Performing Region:
Identify the top-performing region based on total revenue
and evaluate its profit and order volume as supporting KPIs.
*/

SELECT `Region`,
sum(sales) AS total_revenue,
sum(profit) AS total_profit,
count(distinct `Order ID`) AS total_orders,
RANK()OVER(ORDER BY sum(sales) DESC) AS ranking
FROM superstore
GROUP BY `Region`;