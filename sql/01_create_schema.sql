-- ============================================================
-- FILE: 01_create_schema.sql
-- FUNGSI: Membuat database, tabel, dan struktur awal
-- ============================================================

-- Buat database (jika belum ada)
CREATE DATABASE global_superstore;

-- Connect ke database
\c global_superstore

-- ============================================================
-- TABEL UTAMA: superstore (20 kolom sesuai CSV)
-- ============================================================
CREATE TABLE superstore (
    row_id INT,
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(200),
    segment VARCHAR(50),
    country VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    product_name TEXT,
    sales NUMERIC(10,2),
    quantity INT,
    discount NUMERIC(5,2),
    profit NUMERIC(10,2)
);

-- ============================================================
-- INDEX UNTUK PERFORMA
-- ============================================================
CREATE INDEX idx_superstore_country ON superstore(country);
CREATE INDEX idx_superstore_city ON superstore(city);
CREATE INDEX idx_superstore_state ON superstore(state);
CREATE INDEX idx_superstore_category ON superstore(category);
CREATE INDEX idx_superstore_segment ON superstore(segment);
CREATE INDEX idx_superstore_order_date ON superstore(order_date);
CREATE INDEX idx_superstore_product ON superstore(product_id);

-- ============================================================
-- VIEW UNTUK TABLEAU (GEOGRAPHY MAP)
-- ============================================================

-- 1. Sales by Country (Choropleth Map)
CREATE VIEW vw_sales_by_country AS
SELECT 
    country,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY country
ORDER BY total_sales DESC;

-- 2. Sales by City (Bubble Map)
CREATE VIEW vw_sales_by_city AS
SELECT 
    country,
    state,
    city,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM superstore
GROUP BY country, state, city
ORDER BY total_sales DESC;

-- 3. Sales by Category
CREATE VIEW vw_sales_by_category AS
SELECT 
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

-- 4. Sales by Segment
CREATE VIEW vw_sales_by_segment AS
SELECT 
    segment,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY segment
ORDER BY total_sales DESC;

-- 5. Monthly Trend
CREATE VIEW vw_monthly_trend AS
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    TO_CHAR(order_date, 'Month') AS month_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date), TO_CHAR(order_date, 'Month')
ORDER BY year, month;

-- 6. Top 10 Products
CREATE VIEW vw_top_products AS
SELECT 
    product_name,
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY product_name, category, sub_category
ORDER BY total_sales DESC
LIMIT 10;

-- 7. Regional Performance
CREATE VIEW vw_regional_performance AS
SELECT 
    region,
    country,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT customer_id) AS unique_customers,
    ROUND(SUM(profit)/NULLIF(SUM(sales),0)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY region, country
ORDER BY total_sales DESC;