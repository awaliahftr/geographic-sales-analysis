-- ============================================================
-- FILE: 00_run_all.sql
-- FUNGSI: Menjalankan semua file secara berurutan
-- ============================================================

-- Jalankan dari psql command line:
-- psql -U postgres -f 00_run_all.sql

\i 01_create_schema.sql
\i 02_load_data.sql
\i 03_analytical_queries.sql
\i 04_export_views.sql

-- ============================================================
-- VERIFIKASI AKHIR
-- ============================================================
\c global_superstore

SELECT 'Jumlah Data:' AS info;
SELECT COUNT(*) FROM superstore AS total_rows;

SELECT 'Daftar View:' AS info;
SELECT table_name FROM information_schema.views WHERE table_schema = 'public' ORDER BY table_name;