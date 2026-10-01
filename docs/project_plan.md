# Project Plan

Epics and tasks used to run the project (mirrors the Notion board from the course).
Every epic follows the same rhythm: **Analyze → Code → Validate → Document → Commit**.

## 1. Requirements Analysis — ✅ 100%
- [x] Analyze & understand the requirements

## 2. Design Data Architecture — ✅ 100%
- [x] Choose data management approach (Data Warehouse, Medallion Architecture)
- [x] Brainstorm & design the layers (Bronze / Silver / Gold)
- [x] Draw the data architecture → [`data_architecture.svg`](data_architecture.svg)

## 3. Project Initialization — ✅ 100%
- [x] Create detailed project tasks
- [x] Define project naming conventions → [`naming_conventions.md`](naming_conventions.md)
- [x] Create Git repo & prepare the structure
- [x] Create database & schemas → [`scripts/init_database.sql`](../scripts/init_database.sql)

## 4. Build Bronze Layer — ✅ 100%
- [x] Analyze source systems (interview source experts: ownership, docs, access, load type, volume)
- [x] Code: data ingestion (DDL + `bronze.load_bronze` with BULK INSERT)
- [x] Validate: data completeness & schema checks → [`tests/quality_checks_bronze.sql`](../tests/quality_checks_bronze.sql)
- [x] Document: draw data flow → [`data_flow.svg`](data_flow.svg)
- [x] Commit code in Git repo

## 5. Build Silver Layer — ✅ 100%
- [x] Analyze: explore & understand the data
- [x] Document: draw data integration → [`data_integration.svg`](data_integration.svg)
- [x] Code: data cleansing (`silver.load_silver`)
- [x] Validate: data correctness checks → [`tests/quality_checks_silver.sql`](../tests/quality_checks_silver.sql)
- [x] Document: extend data flow
- [x] Commit code in Git repo

## 6. Build Gold Layer — ✅ 100%
- [x] Analyze: explore business objects (Customers, Products, Sales)
- [x] Code: data integration (`scripts/gold/ddl_gold.sql`)
- [x] Validate: data integration checks → [`tests/quality_checks_gold.sql`](../tests/quality_checks_gold.sql)
- [x] Document: draw data model of star schema → [`data_model.svg`](data_model.svg)
- [x] Document: create data catalog → [`data_catalog.md`](data_catalog.md)
- [x] Document: extend data flow
- [x] Commit code in Git repo
