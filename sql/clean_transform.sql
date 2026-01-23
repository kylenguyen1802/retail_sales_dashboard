/*
EDA notebook = exploring the data and answers what to clean
clean_transform.sql = the exact production logic that answers how to clean. Repeatable cleaning.
*/

-- Create clean sales table (completed sales only)
DROP TABLE IF EXISTS sales_clean;

CREATE TABLE sales_clean AS
WITH base AS ( -- Base cleaning layer
    SELECT DISTINCT -- remove duplicate rows from sales_raw
        invoice_no,
        stock_code,
        COALESCE(description, 'Unknown') AS description, -- replaces NULL description with "Unknown"
        quantity,
        invoice_date,
        unit_price,
        COALESCE(customer_id, 'Guest') AS customer_id, -- replaces missing customer IDs with "Guest"
        country
    FROM sales_raw
)
SELECT -- Feature engineering + enrichment
    *,
    (quantity * unit_price) AS revenue, -- create variable "revenue"
    EXTRACT(YEAR FROM invoice_date) AS year, -- add time features: year, month, day
    EXTRACT(MONTH FROM invoice_date) AS month,
    EXTRACT(DAY FROM invoice_date) AS day
FROM base
WHERE quantity > 0 AND unit_price > 0;



-- Create returns / cancellations table
DROP TABLE IF EXISTS sales_returns;

CREATE TABLE sales_returns AS
SELECT DISTINCT
    invoice_no,
    stock_code,
    COALESCE(description, 'Unknown') AS description,
    quantity,
    invoice_date,
    unit_price,
    COALESCE(customer_id, 'Guest') AS customer_id,
    country,
    (quantity * unit_price) AS revenue
FROM sales_raw
WHERE invoice_no LIKE 'C%'
    OR quantity < 0;