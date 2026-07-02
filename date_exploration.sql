SELECT
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
DATEDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_year,
DATEDIFF(month, MIN(order_date), MAX(order_date)) AS order_range_month

FROM gold.fact_sales



SELECT 
MIN(birthdate) AS oldest_person,
DATEDIFF(year, MIN(birthdate), GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_person,
DATEDIFF(year, MAX(birthdate), GETDATE()) AS youngest_age
FROM gold.dim_customers 
