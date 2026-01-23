# Retail Sales Dashboard (PostgreSQL + Python + Tableau)
## 🚀 Overview
This project analyzes online retail transaction data to uncover trends in revenue, refunds, product performance, and customer behavior. I built a reproducible SQL pipeline in PostgreSQL to clean raw transactions into analytics-ready tables, then created interactive Tableau Public dashboards to visualize key business KPIs.

## 📊 Dashboards included:
1. Revenue & Refund Overview
2. Product Performance
3. Customer Insights

## 📌 Key Questions Answered
1. What is the total revenue from completed sales?
2. How does revenue change over time (monthly trend)?
3. How much revenue is lost to returns/cancellations?
4. What are the top products by revenue and by units sold?
5. Which products are refunded the most?
6. What share of customers are repeat vs one-time buyers?
7. How much revenue comes from known customers vs guest customers?

## 🛠️ Tools Used
- 🐍 Python (EDA)
- 🧠 PostgreSQL (data cleaning + transformations + KPI queries)
- 📊 Tableau (dashboards + visual storytelling)
- 🗃️ CSV exports (moving final datasets into Tableau Public)

## 📁 Dataset Structure
The workflow uses 3 main stages:
1. Raw Data
Table: sales_raw
- Contains the original imported transaction-level data.
- Main fields:
  - invoice_no, stock_code, description
  - quantity, unit_price, invoice_date
  - customer_id, country
2. Cleaned Data (Completed Sales Only)
Table: sales_clean
- Filtered to include only valid completed sales transactions.
- Cleaning decisions:
  - Removed duplicates (DISTINCT)
  - Filled missing description with "Unknown"
  - Filled missing customer_id with "Guest"
  - Removed returns and invalid rows (quantity > 0 and unit_price > 0)
- ✨ Added engineered features:
  - revenue = quantity * unit_price
  - year, month, day
3. Returns / Cancellations
Table: sales_returns
- Isolates return and cancellation transactions.
- Return logic:
  - invoice_no LIKE 'C%' (cancelled invoices)
  - OR quantity < 0 (returned items)
- 🔍 KPIs Built (SQL)
- Examples of KPIs calculated from the clean tables:
  - Total revenue
  - Monthly revenue trend
  - Average order value (AOV)
  - Revenue by country
  - Top products by revenue / quantity
  - Top customers by revenue
  - Repeat vs one-time customers
  - Total refunds and monthly refund trends
  - Top refunded products
  - Guest vs known customer revenue split

## 📊 Tableau Dashboards
1. Revenue & Refund Overview
- Focus: overall business health
- Includes:
  - Total Revenue
  - Total Refund Amount
  - Monthly Revenue Trend
  - Monthly Refund Trend

![Revenue & Refund Overview](dashboards/Revenue_Refund_Overview.pdf)

2. Product Performance
- Focus: product-level contribution
- Includes:
  - Top 10 Products by Revenue
  - Top 10 Products by Units Sold
  - Top Refunded Products
 
![Product Performance](dashboards/Product_Performance.pdf)

3. Customer Insights
- Focus: customer behavior + segmentation
- Includes:
  - Repeat vs One-time Customers
  - Guest vs Known Revenue Split
  - Top Customers by Revenue

![Customer Insights](dashboards/Customer_Insights.pdf)

## ⚙️ How to Reproduce This Project
Step 1: Create raw table

Run:

1_create_tables.sql

Step 2: Transform & clean

Run:

2_clean_transform.sql

Step 3: Run KPI queries

Run:

3_kpi_queries.sql

Step 4: Export clean data for Tableau Public

Export clean tables to CSV:

sales_clean.csv

sales_returns.csv

Then connect both CSVs in Tableau Public as separate data sources.

## 📦 Deliverables

SQL pipeline scripts (raw → clean → KPIs)

Tableau Public dashboards (interactive)

Exported clean datasets for visualization

## 🔗 Tableau Public Link

[View the Tableau Dashboards](https://public.tableau.com/app/profile/kyle.nguyen6220/viz/RetailSaleDashboard_17684454872180/Dashboard1)

## 📝 Notes / Limitations

Customer IDs with missing values were labeled "Guest" to retain transactions, but this can reduce accuracy for customer-level retention analysis.

Tableau Public does not support direct PostgreSQL connections, so CSV exports are used.



