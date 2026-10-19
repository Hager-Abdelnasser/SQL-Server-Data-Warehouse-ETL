# 🏦 SQL Server Data Warehouse ETL & Transformation Pipeline

An end-to-end relational data warehousing and ETL project built using Microsoft SQL Server (T-SQL). This pipeline extracts operational data from a legacy source database (`E-commerce`), performs rigorous data cleaning, deduplication, and schema validation, and safely loads the structured data into a target Analytical Data Warehouse (`E-commerce-altered`) without modifying the original source.

---

## 🏗️ Data Architecture & Pipeline Flow

[ Legacy Source Database ] ──► (T-SQL Clean-up & Deduplication via CTEs) ──► [ Target Data Warehouse ]
   (E-commerce.dbo)                                                           (E-commerce-altered)

1. **Source Layer:** Raw relational database with operational logs, duplicate rows, and untrimmed strings.
2. **Transformation Layer:** 
   - Deduplication using `ROW_NUMBER() OVER (PARTITION BY ...)` to preserve latest valid records.
   - String normalization via `TRIM()` and data type casting via `CAST()`.
   - Null-handling and boundary check constraints.
3. **Storage/Analytical Layer:** Clean staging DW (`E-commerce-altered`) populated with enforced Primary & Foreign Key relationships.

---

## 🛠️ Tech Stack & Key SQL Techniques
- **Database Engine:** Microsoft SQL Server / T-SQL
- **ETL Concepts:** Non-Destructive Data Pipeline, Data Staging, Deduplication, Data Integrity Enforcement
- **SQL Functions:** Common Table Expressions (CTEs), Window Functions (`ROW_NUMBER()`), Data Type Conversion (`CAST`), Data Constraints (`CHECK`, `PRIMARY KEY`, `FOREIGN KEY`)

---

## 📁 Repository Structure
SQL-Server-Data-Warehouse-ETL/
│
├── sql/
│   └── 01_data_warehouse_transformation.sql   # DDL & DML script creating tables, cleaning data & adding FK constraints
│
└── README.md                                  # Project documentation & architecture overview

---

## 🚀 How to Run the Pipeline
1. Ensure **Microsoft SQL Server** is installed and running.
2. Load the source dataset into a database named `[E-commerce]`.
3. Open and execute `sql/01_data_warehouse_transformation.sql` in SQL Server Management Studio (SSMS) or Azure Data Studio.
4. The script will automatically create `[E-commerce-altered]`, clean the records, populate all tables, and establish foreign key constraints.
