-- optimization.sql
-- Short and simple. Run after loading testdata.

-- 1) price filter
-- before
EXPLAIN ANALYZE
SELECT id, name, price FROM products WHERE price > 10000;

-- add index
CREATE INDEX IF NOT EXISTS idx_pr_price ON products(price);

-- after
EXPLAIN ANALYZE
SELECT id, name, price FROM products WHERE price > 10000;

-- 2) orders by year (use range instead of EXTRACT)
-- before
EXPLAIN ANALYZE
SELECT id, customer_id, order_date, total_amount
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2024;

-- add index and use range
CREATE INDEX IF NOT EXISTS idx_ord_date ON orders(order_date);

-- after (index-friendly)
EXPLAIN ANALYZE
SELECT id, customer_id, order_date, total_amount
FROM orders
WHERE order_date >= '2024-01-01'::date AND order_date < '2025-01-01'::date;

-- 3) pending orders (partial index)
-- before
EXPLAIN ANALYZE
SELECT id, customer_id, order_date, total_amount
FROM orders
WHERE status = 'pending'
ORDER BY order_date ASC;

-- partial index for pending rows
CREATE INDEX IF NOT EXISTS idx_ord_pending_date ON orders(order_date) WHERE status = 'pending';

-- after
EXPLAIN ANALYZE
SELECT id, customer_id, order_date, total_amount
FROM orders
WHERE status = 'pending'
ORDER BY order_date ASC;

-- 4) rank products per brand (help window function)
-- before
EXPLAIN ANALYZE
SELECT p.id, p.name, p.brand_id, p.price,
  ROW_NUMBER() OVER (PARTITION BY p.brand_id ORDER BY p.price DESC) AS rank_in_brand
FROM products p
ORDER BY p.brand_id, rank_in_brand;

-- composite index to help partition + order
CREATE INDEX IF NOT EXISTS idx_prod_brand_price ON products(brand_id, price DESC);

-- after
EXPLAIN ANALYZE
SELECT p.id, p.name, p.brand_id, p.price,
  ROW_NUMBER() OVER (PARTITION BY p.brand_id ORDER BY p.price DESC) AS rank_in_brand
FROM products p
ORDER BY p.brand_id, rank_in_brand;

-- 5) customer total spend (joins)
-- before
EXPLAIN ANALYZE
SELECT c.id, c.first_name || ' ' || c.last_name AS name,
  COALESCE(SUM(oi.unit_price * oi.quantity),0) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
LEFT JOIN order_items oi ON oi.order_id = o.id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- add join indexes
CREATE INDEX IF NOT EXISTS idx_ord_customer ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_oi_order ON order_items(order_id);

-- optional: materialized view for fast reads
CREATE MATERIALIZED VIEW IF NOT EXISTS mv_total_spend AS
SELECT o.customer_id, SUM(oi.unit_price * oi.quantity) AS total_spent
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
GROUP BY o.customer_id;

CREATE INDEX IF NOT EXISTS idx_mv_total_spend_cust ON mv_total_spend(customer_id);

-- after (use mv)
EXPLAIN ANALYZE
SELECT c.id, c.first_name || ' ' || c.last_name AS name,
  COALESCE(m.total_spent,0) AS total_spent
FROM customers c
LEFT JOIN mv_total_spend m ON m.customer_id = c.id
ORDER BY total_spent DESC;
