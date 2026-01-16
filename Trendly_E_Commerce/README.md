# 📊 Trendly – E‑Commerce Sales Analytics Project

## 🔍 Project Overview

**Trendly** is an end‑to‑end E‑Commerce Sales Analytics project designed to demonstrate a **real‑world data engineering and BI reporting pipeline** using SQL Server and Power BI.

The project follows a **layered (Medallion‑style) architecture** with clear separation between raw ingestion, cleaned business data, and analytics‑ready reporting models. It showcases best practices used in enterprise data platforms, including data cleansing, transformation, deduplication, surrogate keys, and star schema modeling.

This repository is suitable for **Data Analyst, BI Developer, and Data Engineer portfolios**.

---

## 🏗️ Architecture Overview

```
Source CSV Files
      ↓
Staging Layer (Raw Data)
      ↓
Core Layer (Clean & Standardized Data)
      ↓
Reporting Layer (Star Schema)
      ↓
Power BI Dashboards
```

### Layer Responsibilities

| Layer         | Purpose                                   |
| ------------- | ----------------------------------------- |
| **Staging**   | Raw data ingestion, no transformations    |
| **Core**      | Data cleansing, renaming, standardization |
| **Reporting** | Dimensional model for analytics           |

---

## 🛠️ Technology Stack

* **Database:** SQL Server
* **Tooling:** SSMS (SQL Server Management Studio)
* **Data Modeling:** Star Schema (Fact & Dimensions)
* **ETL Logic:** Stored Procedures
* **Analytics & Visualization:** Power BI
* **Version Control:** Git / GitHub

---

## 📁 Project Structure

```
trendly/
│── README.md
│── database/
│     ├── staging/
│     │     ├── load_staging.sql
│     │     └── clean_staging.sql
│     ├── core/
│     │     ├── create_core_tables.sql
│     │     └── load_core.sql
│     └── reporting/
│           ├── create_reporting_tables.sql
│           └── load_reporting.sql
│── powerbi/
│     ├── dax_measures.md
│     └── dashboard_layout.md
│── docs/
│     ├── architecture.md
│     └── data_dictionary.md
```

---

## 📊 Data Model (Reporting Layer)

### Dimensions

* **DimCustomer** – customer attributes
* **DimProduct** – product attributes

### Fact Table

* **FactSales** – transactional sales data

This star schema is optimized for fast querying and Power BI consumption.

---

## 🔄 End‑to‑End Data Flow

1. **Bulk load CSV files** into `Staging` tables
2. **Clean & validate data** (trim spaces, handle nulls, standardize values)
3. **Transform & rename columns** in Core layer
4. **Deduplicate records** using `ROW_NUMBER()`
5. **Build dimensions & fact tables** in Reporting layer
6. **Expose analytics‑ready data** to Power BI

---

## ⚙️ How to Run the Project

### Step 1 – Load Raw Data

```sql
EXEC Staging.Load_Staging;
```

### Step 2 – Clean & Transform Data

```sql
EXEC Core.Load_Core;
```

### Step 3 – Build Reporting Layer

```sql
EXEC Reporting.Load_Reporting;
```

---

## 📈 Key Business Metrics Supported

* Total Sales
* Average Order Value (AOV)
* Sales Trends (Daily / Monthly)
* Top Products
* Customer Segmentation

---

## ✅ Best Practices Demonstrated

* Layered data architecture
* Data cleansing before transformation
* Business‑friendly column naming
* Surrogate keys for dimensions
* Fact‑dimension relationships
* SQL performance optimization
* BI‑ready data modeling

---

## 🚀 Future Enhancements

* Incremental data loads
* Slowly Changing Dimensions (SCD Type‑2)
* Audit & error logging tables
* SQL Agent job automation
* Row‑Level Security (RLS)
* Forecasting & trend analysis

---

## 👤 Author

**Sankirth San**
Data Analyst / Data Engineer

---

## 📌 Note

This project is designed for **learning and portfolio demonstration** and uses simulated e‑commerce data.

---

⭐ *If you find this project useful, feel free to star the repository!*
