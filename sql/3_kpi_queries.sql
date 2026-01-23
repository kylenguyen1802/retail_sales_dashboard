-- Total Revenue (excluding cancellations)
SELECT SUM(revenue) AS total_revenue
FROM sales_clean;

-- Monthly Revenue Trend
SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    SUM(revenue) AS monthly_revenue
FROM sales_clean
GROUP BY 1
ORDER BY 1;

-- Average Order Value (AOV)
WITH order_totals AS (
    SELECT invoice_no, SUM(revenue) AS order_revenue
    FROM sales_clean
    GROUP BY invoice_no
)
SELECT AVG(order_revenue) AS avg_order_value
FROM order_totals;

-- Revenue by Country (Top 10)
SELECT country, SUM(revenue) AS revenue
FROM sales_clean
GROUP BY country
ORDER BY revenue DESC
LIMIT 10;

-- Top Products by Revenue
SELECT description, SUM(revenue) as revenue
FROM sales_clean
GROUP BY description
ORDER BY revenue DESC
LIMIT 10;

-- Top Products by Quantity
SELECT description, SUM(quantity) AS total_units
FROM sales_clean
GROUP BY description
ORDER BY total_units DESC
LIMIT 10;

-- Top Customers by Revenue
SELECT customer_id, SUM(revenue) AS revenue
FROM sales_clean
WHERE customer_id <> 'Guest'
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;

-- Repeat vs One-Time Customers (based on invoice count)
WITH customer_orders AS (
    SELECT customer_id, COUNT(DISTINCT invoice_no) AS order_count
    FROM sales_clean
    WHERE customer_id <> 'Guest'
    GROUP BY customer_id
)
SELECT
    CASE WHEN order_count = 1 THEN 'One-time' ELSE 'Repeat' END AS customer_type,
    COUNT(*) AS customers
FROM customer_orders
GROUP BY 1
ORDER BY 2 DESC;

-- Total Refunds Amount from Returns/Cancellations
SELECT SUM(revenue) AS total_refunds
FROM sales_returns;

-- Number of Cancelled Orders
SELECT COUNT(DISTINCT invoice_no) AS cancelled_orders
FROM sales_returns;

-- NET REVENUE
-- Net revenue = Sales - Refunds
SELECT
    (SELECT COALESCE(SUM(revenue), 0) FROM sales_clean) - 
    (SELECT COALESCE(ABS(SUM(revenue)), 0) FROM sales_returns) AS net_revenue;

-- REFUND RATE
-- Refund Rate by Amount (% of sales)
SELECT
    ROUND(
        100.0 * (SELECT COALESCE(ABS(SUM(revenue)), 0) FROM sales_returns) /
        NULLIF((SELECT COALESCE(SUM(revenue), 0) FROM sales_clean), 0)
    , 2) AS refund_rate_amount;
-- Refund Rate by Orders (cancelled orders / total orders)
SELECT
    ROUND(
        100.0 * (SELECT COUNT(DISTINCT invoice_no) FROM sales_returns) /
        NULLIF ((SELECT COUNT(DISTINCT invoice_no) FROM sales_clean) + (SELECT COUNT(DISTINCT invoice_no) FROM sales_returns), 0)
    , 2) AS refund_rate_orders;

-- REFUNDS TREND OVER TIME (MONTHLY)
SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    ABS(SUM(revenue)) AS monthly_refunds
FROM sales_returns
GROUP BY 1
ORDER BY 1;

-- TOP REFUNDED PRODUCTS (By refund amount)
SELECT
    description,
    ABS(SUM(revenue)) AS refund_amount
FROM sales_returns
GROUP BY description
ORDER BY refund_amount DESC
LIMIT 10;

-- CUSTOMER CONCENTRATION (BIG INSIGHT)
-- Revenue share from Top 10 customers (%)
With cust AS (
    SELECT customer_id, SUM(revenue) AS rev
    FROM sales_clean
    WHERE customer_id <> 'Guest'
    GROUP BY customer_id
),
tot AS (
    SELECT SUM(rev) AS total_rev FROM cust
),
top10 AS (
    SELECT SUM(rev) AS top10_rev FROM (
        SELECT rev FROM cust ORDER BY rev DESC LIMIT 10
        ) t
)
SELECT
    ROUND(100.0 * top10.top10_rev / NULLIF(tot.total_rev, 0), 2) AS top10_share_pct
FROM top10, tot;

-- GUEST VS KNOWN CUSTOMERS (REVENUE SPLIT)
SELECT
    CASE WHEN customer_id = 'Guest' THEN 'Guest' ELSE 'Known' END AS customer_type,
    SUM(revenue) AS revenue
FROM sales_clean
GROUP BY 1
ORDER BY revenue DESC;
