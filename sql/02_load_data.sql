-- ============================================================
-- FILE: 02_load_data.sql
-- FUNGSI: Import data dari CSV ke PostgreSQL
-- ============================================================

\c global_superstore

-- ============================================================
-- METODE 1: Menggunakan \copy (psql command line)
-- ============================================================
-- Jalankan dari command line:
-- psql -U postgres -d global_superstore -c "\copy superstore FROM 'D:/Project End-to-End/Geographic Sales Analysis/data/raw/superstore.csv' DELIMITER ',' CSV HEADER;"

-- ============================================================
-- METODE 2: Menggunakan COPY (jika file di server)
-- ============================================================
-- COPY superstore FROM 'D:/Project End-to-End/Geographic Sales Analysis/data/raw/superstore.csv' DELIMITER ',' CSV HEADER;

-- ============================================================
-- METODE 3: Import via pgAdmin (GUI)
-- ============================================================
-- 1. Buka pgAdmin
-- 2. Klik kanan pada tabel superstore
-- 3. Pilih Import/Export Data
-- 4. Pilih file CSV
-- 5. Centang Header
-- 6. Encoding: LATIN1 (jika ada error character)
-- 7. Klik OK

-- ============================================================
-- VERIFIKASI IMPORT
-- ============================================================
SELECT COUNT(*) AS total_rows FROM superstore;
SELECT * FROM superstore LIMIT 10;