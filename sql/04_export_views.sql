-- ============================================================
-- FILE: 04_export_views.sql
-- FUNGSI: Export view ke CSV untuk Tableau
-- ============================================================

\c global_superstore

-- ============================================================
-- EKSPOR VIA \copy (psql command line)
-- ============================================================
-- Jalankan dari command line:

-- 1. Sales by State 
\copy vw_sales_by_state TO 'D:/Project End-to-End/Geographic Sales Analysis/data/processed/sales_by_state.csv' CSV HEADER;

-- 2. Sales by City
\copy vw_sales_by_city TO 'D:/Project End-to-End/Geographic Sales Analysis/data/processed/sales_by_city.csv' CSV HEADER;

-- 3. Sales by Category
\copy vw_sales_by_category TO 'D:/Project End-to-End/Geographic Sales Analysis/data/processed/sales_by_category.csv' CSV HEADER;

-- 4. Sales by Segment
\copy vw_sales_by_segment TO 'D:/Project End-to-End/Geographic Sales Analysis/data/processed/sales_by_segment.csv' CSV HEADER;

-- 5. Monthly Trend
\copy vw_monthly_trend TO 'D:/Project End-to-End/Geographic Sales Analysis/data/processed/monthly_trend.csv' CSV HEADER;

-- 6. Top Products
\copy vw_top_products TO 'D:/Project End-to-End/Geographic Sales Analysis/data/processed/top_products.csv' CSV HEADER;

-- 7. Regional Performance
\copy vw_regional_performance TO 'D:/Project End-to-End/Geographic Sales Analysis/data/processed/regional_performance.csv' CSV HEADER;

-- 8. Tableau Geo Data
\copy vw_tableau_geo TO 'D:/Project End-to-End/Geographic Sales Analysis/data/processed/tableau_geo_data.csv' CSV HEADER;

-- 9. Cohort Retention (Bonus)
\copy vw_cohort_retention TO 'D:/Project End-to-End/Geographic Sales Analysis/data/processed/cohort_retention.csv' CSV HEADER;

-- ============================================================
-- VERIFIKASI FILE
-- ============================================================
-- Cek jumlah baris yang diekspor
SELECT 'sales_by_state' AS view_name, COUNT(*) FROM vw_sales_by_state
UNION ALL
SELECT 'sales_by_city', COUNT(*) FROM vw_sales_by_city
UNION ALL
SELECT 'sales_by_category', COUNT(*) FROM vw_sales_by_category
UNION ALL
SELECT 'sales_by_segment', COUNT(*) FROM vw_sales_by_segment
UNION ALL
SELECT 'monthly_trend', COUNT(*) FROM vw_monthly_trend
UNION ALL
SELECT 'top_products', COUNT(*) FROM vw_top_products
UNION ALL
SELECT 'regional_performance', COUNT(*) FROM vw_regional_performance
UNION ALL
SELECT 'tableau_geo_data', COUNT(*) FROM vw_tableau_geo
UNION ALL
SELECT 'cohort_retention', COUNT(*) FROM vw_cohort_retention;