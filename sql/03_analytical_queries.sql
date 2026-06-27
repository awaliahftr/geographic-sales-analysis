-- ============================================================
-- FILE: 03_analytical_queries.sql
-- FUNGSI: Query analisis untuk eksplorasi data
-- ============================================================

\c global_superstore

-- ============================================================
-- 1. TOP 10 STATE DENGAN PENJUALAN TERTINGGI
-- ============================================================
CREATE VIEW vw_sales_by_state AS
SELECT 
    state,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY state
ORDER BY total_sales DESC;

-- ============================================================
-- 2. TOP 10 KOTA DENGAN PENJUALAN TERTINGGI
-- ============================================================
SELECT 
    country,
    state,
    city,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY country, state, city
ORDER BY total_sales DESC
LIMIT 10;

-- ============================================================
-- 3. PENJUALAN PER KATEGORI
-- ============================================================
SELECT 
    category,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

-- ============================================================
-- 4. PENJUALAN PER SEGMEN PELANGGAN
-- ============================================================
SELECT 
    segment,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2) AS total_profit,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(AVG(sales)::NUMERIC, 2) AS avg_order_value
FROM superstore
GROUP BY segment
ORDER BY total_sales DESC;

-- ============================================================
-- 5. TREN BULANAN
-- ============================================================
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    TO_CHAR(order_date, 'Month') AS month_name,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date), TO_CHAR(order_date, 'Month')
ORDER BY year, month;

-- ============================================================
-- 6. PROFIT MARGIN PER REGION
-- ============================================================
SELECT 
    region,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    ROUND(SUM(profit)::NUMERIC, 2) AS total_profit,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY region
ORDER BY profit_margin_pct DESC;

-- ============================================================
-- 7. TOP 10 PRODUK TERLARIS
-- ============================================================
SELECT 
    product_name,
    category,
    sub_category,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY product_name, category, sub_category
ORDER BY total_sales DESC
LIMIT 10;

-- ============================================================
-- 8. DISTRIBUSI DISKON PER KATEGORI
-- ============================================================
SELECT 
    category,
    ROUND(AVG(discount)::NUMERIC, 3) AS avg_discount,
    ROUND(MIN(discount)::NUMERIC, 3) AS min_discount,
    ROUND(MAX(discount)::NUMERIC, 3) AS max_discount,
    ROUND(SUM(sales)::NUMERIC, 2) AS total_sales
FROM superstore
GROUP BY category
ORDER BY avg_discount DESC;

-- ============================================================
-- 9. QUERY UNTUK TABLEAU (GEOGRAPHY MAP - ALL IN ONE)
-- ============================================================
CREATE VIEW vw_tableau_geo AS
SELECT 
    country,
    state,
    city,
    region,
    segment,
    category,
    sub_category,
    ROUND(SUM(sales)::NUMERIC, 2) AS sales,
    ROUND(SUM(profit)::NUMERIC, 2) AS profit,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(quantity) AS quantity,
    ROUND(AVG(discount)::NUMERIC, 2) AS avg_discount,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100, 2) AS profit_margin_pct,
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month
FROM superstore
GROUP BY country, state, city, region, segment, category, sub_category, EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date);

-- ============================================================
-- 10. COHORT RETENTION ANALYSIS 
-- ============================================================
WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order_date
    FROM superstore
    GROUP BY customer_id
),
cohort_data AS (
    SELECT 
        s.customer_id,
        DATE_TRUNC('month', fp.first_order_date) AS cohort_month,
        DATE_TRUNC('month', s.order_date) AS order_month,
        EXTRACT(YEAR FROM AGE(s.order_date, fp.first_order_date)) * 12 + 
        EXTRACT(MONTH FROM AGE(s.order_date, fp.first_order_date)) AS month_number
    FROM superstore s
    JOIN first_purchase fp ON s.customer_id = fp.customer_id
)
SELECT 
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort,
    month_number,
    COUNT(DISTINCT customer_id) AS retained_customers,
    COUNT(DISTINCT customer_id) OVER (PARTITION BY cohort_month) AS cohort_size,
    ROUND(COUNT(DISTINCT customer_id)::NUMERIC / 
          COUNT(DISTINCT customer_id) OVER (PARTITION BY cohort_month) * 100, 1) AS retention_rate
FROM cohort_data
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;