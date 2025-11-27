-- queries_advanced.sql

-- 1) Show products priced above the average

SELECT
  p.id,                                 -- product id
  p.name,                               -- product name
  p.category,                           -- product category
  p.brand_id,                           -- brand id (reference to brands)
  p.price                                -- product price
FROM products p
WHERE p.price > (
  SELECT AVG(price) FROM products       -- average price across all products
)
ORDER BY p.price DESC;                  -- show most expensive first
-----------------------------------------------------------------------------

-- 2) Count orders per customer and show those above the average.

SELECT
  c.id,                                 
  c.first_name,                         
  c.last_name,                          
  c.email,                              
  COUNT(o.id) AS order_count            -- number of orders for this customer
FROM customers c
JOIN orders o ON o.customer_id = c.id   -- join to count orders per customer
GROUP BY c.id, c.first_name, c.last_name, c.email
HAVING COUNT(o.id) > (                  -- compare to average of per-customer counts
  SELECT AVG(cnt) FROM (
    SELECT COUNT(*) AS cnt
    FROM orders
    GROUP BY customer_id
  ) AS counts_sub
)
ORDER BY order_count DESC;              -- most active customers first
-----------------------------------------------------------------------------

-- 3) Rank products by price per brand.

SELECT
  p.id,
  p.name AS product_name,
  b.name AS brand_name,
  p.category,
  p.price,
  ROW_NUMBER() OVER (
    PARTITION BY p.brand_id            -- restart ranking for each brand
    ORDER BY p.price DESC              -- highest price gets rank 1
  ) AS price_rank_in_brand
FROM products p
LEFT JOIN brands b ON b.id = p.brand_id
ORDER BY b.name, price_rank_in_brand;   -- order by brand then rank
---------------------------------------------------------------------------

-- 4) Each customer's total spending and their rank among customers.

SELECT
  c.id,
  c.first_name,
  c.last_name,
  COALESCE(s.total_spent, 0) AS total_spent,  -- 0 if no purchases
  RANK() OVER (ORDER BY COALESCE(s.total_spent, 0) DESC) AS spending_rank
FROM customers c
LEFT JOIN (
  SELECT o.customer_id, SUM(oi.unit_price * oi.quantity) AS total_spent
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.id
  GROUP BY o.customer_id
) s ON s.customer_id = c.id
ORDER BY spending_rank;                 -- rank 1 = highest spender
--------------------------------------------------------------------------

-- 5) Map product prices to Budget/Medium/Premium

SELECT
  p.id,
  p.name,
  p.category,
  p.price,
  CASE
    WHEN p.price < 1000 THEN 'Budget'                 -- under 1000 => Budget
    WHEN p.price BETWEEN 1000 AND 5000 THEN 'Medium'  -- 1000-5000 => Medium
    ELSE 'Premium'                                    -- above 5000 => Premium
  END AS price_category
FROM products p
ORDER BY p.price ASC;                   -- show cheapest first
-----------------------------------------------------------------------------

-- 6) Classify customers by number of orders (VIP/Regular/New)

SELECT
  c.id,
  c.first_name,
  c.last_name,
  c.email,
  COALESCE(o_counts.order_count, 0) AS order_count,  -- 0 if no orders
  CASE
    WHEN COALESCE(o_counts.order_count, 0) > 3 THEN 'VIP'         -- >3 => VIP
    WHEN COALESCE(o_counts.order_count, 0) BETWEEN 2 AND 3 THEN 'Regular' -- 2-3 => Regular
    WHEN COALESCE(o_counts.order_count, 0) = 1 THEN 'New'         -- 1 => New
    ELSE 'No Orders'                                              -- 0 => No Orders
  END AS customer_status
FROM customers c
LEFT JOIN (
  SELECT customer_id, COUNT(*) AS order_count
  FROM orders
  GROUP BY customer_id
) o_counts ON o_counts.customer_id = c.id
ORDER BY order_count DESC;              -- customers with most orders first