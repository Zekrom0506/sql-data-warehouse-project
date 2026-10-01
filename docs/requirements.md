# Project Requirements

## Building the Data Warehouse (Data Engineering)

### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

## Design Decisions

### Data management approach
**Data Warehouse** (structured data only, focus on reporting & BI), built with the **Medallion Architecture** (Bronze → Silver → Gold).

### Layer definitions

| | Bronze | Silver | Gold |
|---|---|---|---|
| **Definition** | Raw, unprocessed data as-is from sources | Clean & standardized data | Business-ready data |
| **Objective** | Traceability & debugging | (Intermediate layer) prepare data for analysis | Provide data to be consumed for reporting & analytics |
| **Object type** | Tables | Tables | Views |
| **Load method** | Full load (truncate & insert) | Full load (truncate & insert) | None |
| **Transformations** | None (as-is) | Data cleansing, standardization, normalization, derived columns, enrichment | Data integration, aggregations, business logic & rules |
| **Data modeling** | None (as-is) | None (as-is) | Star schema, aggregated objects, flat tables |
| **Target audience** | Data engineers | Data engineers, data analysts | Data analysts, business users |

**Separation of concerns:** each layer has a unique job — no business rules in Silver, no data cleansing in Gold, and every source lands in Bronze first.

### ETL techniques used in this project

| Step | Technique chosen |
|---|---|
| Extraction method | Pull |
| Extraction type | Full extraction |
| Extraction technique | File parsing (CSV) |
| Transformations | Enrichment, integration, derived columns, normalization & standardization, business rules, aggregation, data cleansing (dedup, filtering, missing/invalid values, unwanted spaces, type casting, outliers) |
| Processing type | Batch processing |
| Load method | Full load — truncate & insert |
| Slowly changing dimensions | SCD Type 1 (overwrite) |

---

## BI: Analytics & Reporting (Data Analysis)

### Objective
Develop SQL-based analytics to deliver detailed insights into:
- **Customer Behavior**
- **Product Performance**
- **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.
