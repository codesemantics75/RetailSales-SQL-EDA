WITH monthly_sales AS (
    SELECT 
        DATETRUNC(month, order_date) AS sales_month,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
)
SELECT 
    sales_month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY sales_month) AS prev_month_sales,
    total_sales - LAG(total_sales) OVER (ORDER BY sales_month) AS mom_change,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY sales_month)) * 100.0 
        / NULLIF(LAG(total_sales) OVER (ORDER BY sales_month), 0), 2
    ) AS mom_growth_pct
FROM monthly_sales
ORDER BY sales_month;


WITH rfm_base AS (
    SELECT 
        c.customer_key,
        c.first_name,
        c.last_name,
        DATEDIFF(day, MAX(f.order_date), (SELECT MAX(order_date) FROM gold.fact_sales)) AS recency_days,
        COUNT(DISTINCT f.order_number) AS frequency,
        SUM(f.sales_amount) AS monetary
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
    GROUP BY c.customer_key, c.first_name, c.last_name
),
rfm_scores AS (
    SELECT *,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
    FROM rfm_base
)
SELECT *,
    (r_score + f_score + m_score) AS rfm_total,
    CASE 
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 2 THEN 'Loyal Customers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost/Churned'
        ELSE 'Potential Loyalist'
    END AS customer_segment
FROM rfm_scores
ORDER BY rfm_total DESC;


WITH first_purchase AS (
    SELECT 
        customer_key,
        MIN(DATETRUNC(month, order_date)) AS cohort_month
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY customer_key
),
customer_activity AS (
    SELECT 
        f.customer_key,
        fp.cohort_month,
        DATEDIFF(month, fp.cohort_month, DATETRUNC(month, f.order_date)) AS months_since_first
    FROM gold.fact_sales f
    JOIN first_purchase fp ON fp.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
)
SELECT 
    cohort_month,
    months_since_first,
    COUNT(DISTINCT customer_key) AS active_customers
FROM customer_activity
GROUP BY cohort_month, months_since_first
ORDER BY cohort_month, months_since_first;

WITH product_sales AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(f.sales_amount) AS total_revenue
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
    GROUP BY p.category, p.product_name
),
ranked_products AS (
    SELECT *,
        RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rank_in_category
    FROM product_sales
)
SELECT *
FROM ranked_products
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;
