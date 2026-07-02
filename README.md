# Retail Sales EDA (SQL)

Exploratory data analysis on a retail sales dataset (AdventureWorks — bike manufacturing and retail company) using SQL Server, covering customer demographics, product performance, and revenue trends.

## Dataset
Star schema with 3 tables:
- `dim_customers` — customer demographics (country, gender, birthdate)
- `dim_products` — product catalog (category, subcategory, cost, product line)
- `fact_sales` — transaction-level sales (order date, quantity, price, sales amount)

## Key Questions Answered
- What's the total revenue, quantity sold, and average price across all orders?
- What's the date range of orders, and the age range of customers?
- Which products generate the most (and least) revenue?
- How does revenue break down by product category and customer country?
- What's the customer base's gender and country distribution?

## Tools
SQL Server Management Studio (T-SQL)

## Next Steps
- RFM customer segmentation using window functions (NTILE)
- Cohort retention analysis (first-purchase-month cohorts tracked over time)
- Market basket / product affinity analysis (which categories are bought together)
- Visualization layer in PowerBI connected live to the database
