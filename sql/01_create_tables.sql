DROP TABLE IF EXISTS sales_raw;

CREATE TABLE sales_raw (
    invoice_no   TEXT,
    stock_code   TEXT,
    description  TEXT,
    quantity     INTEGER,
    invoice_date TIMESTAMP,
    unit_price   NUMERIC(10,2),
    customer_id  TEXT,
    country      TEXT
);

-- Indexes
CREATE INDEX idx_sales_raw_invoice_date ON sales_raw (invoice_date);
CREATE INDEX idx_sales_raw_customer_id ON sales_raw (customer_id);
