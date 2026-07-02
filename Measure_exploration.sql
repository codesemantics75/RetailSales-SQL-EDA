SELECT SUM(sales_amount) AS total_sales 
FROM gold.fact_sales 

SELECT SUM(quantity) AS total_quantity 
FROM gold.fact_sales 

SELECT AVG(price) AS avg_price 
FROM gold.fact_sales 

SELECT COUNT(order_number) AS total_orders 
FROM gold.fact_sales

SELECT COUNT( DISTINCT order_number) AS total_orders 
FROM gold.fact_sales 

SELECT COUNT(product_key) AS tota_products 
FROM gold.dim_products 

SELECT COUNT(customer_key) AS total_customers 
FROM gold.dim_customers

SELECT COUNT( DISTINCT customer_key) AS total_customers 
FROM gold.fact_sales 

SELECT  'Total_sales' AS measure_name, 
SUM(sales_amount) AS mesaure_value 
FROM gold.fact_sales 
UNION ALL
SELECT  'Total_quantity' AS measure_name, 
SUM(quantity) AS mesaure_value 
FROM gold.fact_sales 
UNION ALL 
SELECT  'Avg Price' AS measure_name, 
AVG(price) AS mesaure_value 
FROM gold.fact_sales 
UNION ALL
SELECT  'Total nr of orders' AS measure_name, 
COUNT( DISTINCT order_number) AS mesaure_value 
FROM gold.fact_sales 
UNION ALL
SELECT 'Total nr of products' AS measure_name, 
COUNT(product_key) AS measure_value 
FROM gold.dim_products
UNION ALL
SELECT 'Total nr of customers' AS measure_name, 
COUNT(customer_key) AS measure_value 
FROM gold.dim_customers 



