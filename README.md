# 📊 Northwind Traders: SQL Data Analytics Project

The primary goal of this project is to conduct a comprehensive business analysis of customer behavior, sales metrics, employee performance, and logistics operations for **Northwind Traders** using **PostgreSQL** and **VS Code**.

The project covers the complete end-to-end data analytics workflow: from database schema design and DDL scripts to solving complex business problems using advanced SQL features (CTEs, Window Functions, and Cohort Analysis).

---

## 🛠 Tech Stack

* **RDBMS:** PostgreSQL
* **IDE / Environment:** Visual Studio Code (PostgreSQL extension, psql CLI)
* **Language:** SQL (ANSI SQL / PL/pgSQL features)
* **Version Control:** Git & GitHub

---

## 📐 Database Architecture & Schema

The database consists of **7 core entities** linked via `PRIMARY KEY` — `FOREIGN KEY` constraints:

* `customers` — B2B customer profiles and geographic attributes.
* `employees` — Employee organizational data (includes a `reports_to` self-referencing relationship).
* `shippers` — Delivery service provider reference table.
* `categories` — Product category mappings.
* `products` — Product catalog and pricing details (references `categories`).
* `orders` — Core transaction table connecting customers, employees, and shipping partners.
* `order_details` — Transaction line items with unit prices, order quantities, and discounts (composite primary key: `order_id + product_id`).

---

## 📁 Project Structure

```text
sql-analytics/
├── .gitignore
├── README.md
├── datasets/                           # Raw CSV source data files
│   ├── categories.csv
│   ├── customers.csv
│   ├── employees.csv
│   ├── order_details.csv
│   ├── orders.csv
│   ├── products.csv
│   └── shippers.csv
└── sql/
    ├── 01_setup/                       # Database deployment scripts
    │   ├── 01_create_tables.sql        # DDL: Schema creation, tables, and foreign keys
    │   └── 02_import_data.sql          # DML: Data ingestion via \copy
    └── 02_analytics/                   # Analytical SQL scripts
        ├── 01_basic_metrics.sql        # Core sales performance and geographic insights
        ├── 02_intermediate_analysis.sql # Logistics efficiency, customer retention, and CTEs
        └── 03_advanced_analytics.sql   # Window functions, cumulative totals, and LTV