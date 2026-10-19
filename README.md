# 🏦 SQL Server Data Warehouse ETL & Transformation Pipeline

An end-to-end relational data warehousing and ETL project built using Microsoft SQL Server (T-SQL). This pipeline extracts operational data from a legacy source database (`E-commerce`), performs rigorous data cleaning, deduplication, and schema validation, and safely loads the structured data into a target Analytical Data Warehouse (`E-commerce-altered`) without modifying the original source.

---

## 🏗️ Data Architecture & Pipeline Flow

```text
[ Legacy Source Database ] ──► (T-SQL Clean-up & Deduplication via CTEs) ──► [ Target Data Warehouse ]
   (E-commerce.dbo)                                                           (E-commerce-altered)
