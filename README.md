# 🌍 Geographic Sales Analysis

### End-to-End Data Analytics Project | PostgreSQL + Python + Tableau

![Dashboard Preview](https://github.com/awaliahftr/geographic-sales-analysis/blob/b4768dd68b9d867fc08349c0507e2570def2c8c6/docs/dashboard.png)

## 🎯 Problem Statement
Analisis performa penjualan berdasarkan wilayah geografis untuk mengidentifikasi peluang ekspansi dan optimasi distribusi.

## 🛠️ Tools & Technologies
| Tool              | Kegunaan                                      |
|-------------------|-----------------------------------------------|
| PostgreSQL 15+    | Data storage & query processing               |
| Python 3.11+      | EDA, data cleaning, ETL pipeline              |
| Tableau Desktop   | Interactive geographic dashboard              |

## 📌 Key Visualizations
- 🗺️ **Choropleth Map** – Sales distribution by state
- 🔵 **Bubble Map** – Sales concentration by city
- 📈 **Monthly Sales** – Sales performance over time
- 📊 **KPI Cards** – Total Sales, Profit, Orders, Customers

## 🗃️ Dataset
- Source: Global Superstore Dataset
- Records: 9,994 transactions
- Columns: 20+ including Country, State, City, Sales, Profit

## 🔍 Key Findings
- California contributes highest sales ($457K)
- Technology category has highest profit margin (22%)
- Q4 shows peak sales season
- Los Angeles is top performing city

## 📂 Project Structure
├── data/ ← Raw & processed CSV files
├── sql/ ← PostgreSQL schema & queries
├── tableau/ ← Tableau workbook
└── docs/ ← Dashboard screenshot


## 🚀 How to Run
1. Clone repo: `git clone https://github.com/awaliahftr/geographic-sales-analysis.git`
2. Setup PostgreSQL and run `sql/01_create_schema.sql`
3. Import data using `sql/02_load_data.sql`
4. Run analytical queries `sql/03_analytical_queries.sql`
5. Open Tableau workbook in `tableau/` folder


## 👤 Author
**Awaliah Fitri Nur Ananda** – [GitHub](https://github.com/awaliahftr)
