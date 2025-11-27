-- queries.sql
-- Minst 10 kommenterade frågor som visar SELECT, JOIN, GROUP BY, aggregation osv.


-- 1) Alla produkter sorterade efter namn
SELECT id, name, price, category
FROM products
ORDER BY name ASC;

-- 2) Produkter som kostar mer än 5000 kr
SELECT id, name, price
FROM products
WHERE price > 5000
ORDER BY price DESC;

-- 3) Alla beställningar från år 2024
SELECT id, customer_id, order_date, total_amount, status
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2024
ORDER BY order_date ASC;

-- 4) Beställningar med status 'pending'
SELECT id, customer_id, order_date, total_amount
FROM orders
WHERE status = 'pending'
ORDER BY order_date ASC;

-- 5) Produkter med sina tillverkares namn (inkluderar brands utan produkter)
SELECT b.id AS brand_id, b.name AS brand_name,
       p.id AS product_id, p.name AS product_name, p.price
FROM brands b
LEFT JOIN products p ON p.brand_id = b.id
ORDER BY b.name, p.name;

-- 6) Beställningar med kundens namn
SELECT o.id AS order_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       o.order_date,
       o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.id
ORDER BY o.order_date DESC;

-- 7) Vilka produkter varje kund köpt (en rad per orderrad)
SELECT c.id AS customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       o.id AS order_id,
       o.order_date,
       p.id AS product_id,
       p.name AS product_name,
       oi.quantity,
       oi.unit_price
FROM order_items oi
JOIN orders o    ON oi.order_id = o.id
JOIN customers c ON o.customer_id = c.id
JOIN products p  ON oi.product_id = p.id
ORDER BY customer_name, o.order_date, product_name;

-- 8) Antal produkter per tillverkare
SELECT b.id AS brand_id,
       b.name AS brand_name,
       COUNT(p.id) AS antal_produkter
FROM brands b
LEFT JOIN products p ON p.brand_id = b.id
GROUP BY b.id, b.name
ORDER BY antal_produkter DESC;

-- 9) Kunder som spenderat mest totalt (summa av orderbelopp)
SELECT c.id AS customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       COALESCE(SUM(o.total_amount), 0) AS total_spend
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY total_spend DESC;

-- 10) Produkter med genomsnittligt betyg från recensioner
SELECT p.id AS product_id,
       p.name AS product_name,
       COUNT(r.id) AS antal_recensioner,
       ROUND(AVG(r.rating)::numeric, 2) AS avg_rating
FROM products p
LEFT JOIN reviews r ON r.product_id = p.id
GROUP BY p.id, p.name
ORDER BY avg_rating DESC NULLS LAST;
