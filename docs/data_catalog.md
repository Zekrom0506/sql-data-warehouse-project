# Data Catalog — Gold Layer

## Overview
The Gold layer is the business-level representation of the data, structured for analytics and reporting. It is a **star schema** made of two **dimension** views and one **fact** view, all built as SQL views on top of the Silver layer.

![Data Model](data_model.svg)

| Object | Type | Grain | Rows* |
|---|---|---|---|
| `gold.dim_customers` | Dimension | one row per customer | 18,484 |
| `gold.dim_products` | Dimension | one row per current product | 295 |
| `gold.fact_sales` | Fact | one row per order line (order × product) | 60,398 |

\* Row counts from a full load of the provided datasets.

**Relationships:** `fact_sales.customer_key` → `dim_customers.customer_key` (many-to-one) and `fact_sales.product_key` → `dim_products.product_key` (many-to-one).

**Business rule:** `sales_amount = quantity * price`.

---

### 1. gold.dim_customers
- **Purpose:** Stores customer details enriched with demographic and geographic data.
- **Sources:** `silver.crm_cust_info` (master), `silver.erp_cust_az12` (birthdate, fallback gender), `silver.erp_loc_a101` (country).

| Column Name | Data Type | Description |
|---|---|---|
| customer_key | INT | Surrogate key uniquely identifying each customer record in the dimension. |
| customer_id | INT | Unique numerical identifier assigned to each customer in the CRM (e.g. 11000). |
| customer_number | NVARCHAR(50) | Alphanumeric identifier of the customer, used for tracking and referencing (e.g. 'AW00011000'). |
| first_name | NVARCHAR(50) | The customer's first name, as recorded in the system. |
| last_name | NVARCHAR(50) | The customer's last name or family name. |
| country | NVARCHAR(50) | Country of residence (e.g. 'Australia', 'United States'); 'n/a' when unknown. |
| marital_status | NVARCHAR(50) | Marital status of the customer (e.g. 'Married', 'Single'). |
| gender | NVARCHAR(50) | Gender of the customer ('Male', 'Female', 'n/a'). CRM value wins; ERP is used as a fallback. |
| birthdate | DATE | Date of birth, YYYY-MM-DD (e.g. 1971-10-06). Future dates from the source are set to NULL. |
| create_date | DATE | The date when the customer record was created in the CRM. |

---

### 2. gold.dim_products
- **Purpose:** Provides information about the products and their attributes. Only the current version of each product is kept (no history).
- **Sources:** `silver.crm_prd_info` (master), `silver.erp_px_cat_g1v2` (category data).

| Column Name | Data Type | Description |
|---|---|---|
| product_key | INT | Surrogate key uniquely identifying each product record in the dimension. |
| product_id | INT | Unique identifier assigned to the product for internal tracking. |
| product_number | NVARCHAR(50) | Structured alphanumeric product code (e.g. 'BK-R93R-62'). |
| product_name | NVARCHAR(50) | Descriptive name of the product including type, color and size (e.g. 'Road-150 Red- 62'). |
| category_id | NVARCHAR(50) | Identifier of the product's category (e.g. 'BI_RB'). |
| category | NVARCHAR(50) | Broad classification of the product (e.g. 'Bikes', 'Components'). |
| subcategory | NVARCHAR(50) | Detailed classification within the category (e.g. 'Road Bikes'). |
| maintenance | NVARCHAR(50) | Whether the product requires maintenance ('Yes', 'No'). |
| cost | INT | Cost / base price of the product in whole currency units; 0 when unknown. |
| product_line | NVARCHAR(50) | Product line (e.g. 'Road', 'Mountain', 'Touring', 'Other Sales', 'n/a'). |
| start_date | DATE | The date when the product (current version) became available. |

---

### 3. gold.fact_sales
- **Purpose:** Stores transactional sales data for analytical purposes.
- **Sources:** `silver.crm_sales_details`, with surrogate-key lookups into both dimensions.

| Column Name | Data Type | Description |
|---|---|---|
| order_number | NVARCHAR(50) | Alphanumeric identifier of the sales order (e.g. 'SO54496'). |
| product_key | INT | Surrogate key linking the order line to `dim_products`. |
| customer_key | INT | Surrogate key linking the order line to `dim_customers`. |
| order_date | DATE | The date when the order was placed (NULL if the source date was invalid). |
| shipping_date | DATE | The date when the order was shipped to the customer. |
| due_date | DATE | The date when the order payment was due. |
| sales_amount | INT | Total value of the order line in whole currency units (= quantity × price). |
| quantity | INT | Number of units ordered for the line item (e.g. 1). |
| price | INT | Price per unit for the line item, in whole currency units (e.g. 25). |

---

### Example query

```sql
-- Revenue by country and product category
SELECT
    c.country,
    p.category,
    SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products  p ON p.product_key  = f.product_key
GROUP BY c.country, p.category
ORDER BY total_sales DESC;
```
