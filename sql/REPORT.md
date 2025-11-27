
# REPORT.md

### Summary
Added a few targeted indexes and optional materialized views to speed up queries in `sql/queries.sql` and `sql/queries_advanced.sql`. Focus: make common filters, joins and aggregations use indexes and give fast reads for heavy reports.

---

### Changes
- **Indexes added:** `products(price)`, `products(brand_id, price DESC)`, `orders(order_date)`, `orders(customer_id)`, `order_items(order_id)`, `reviews(product_id)`, and a partial index `orders(order_date) WHERE status = 'pending'`.
- **Materialized views (optional):** `mv_total_spend` and `mv_product_ratings` for repeated aggregations.
- **Query tweak:** use date ranges instead of `EXTRACT(YEAR FROM ...)` so `orders(order_date)` can be used.

---

### Why this helps
- Indexes avoid full table scans for common filters and sorts.  
- Composite index `(brand_id, price DESC)` helps window functions that rank products per brand.  
- Partial index keeps the index small and fast when only a few rows match.  
- Materialized views speed up repeated heavy aggregations at the cost of needing refreshes.

---

### How to run
1. Load test data:  
   `psql -U <user> -d <db> -f sql/testdata.sql`  
2. Apply optimizations:  
   `psql -U <user> -d <db> -f sql/optimization.sql`  
3. Refresh views if used:  
   `REFRESH MATERIALIZED VIEW mv_total_spend;`  
   `REFRESH MATERIALIZED VIEW mv_product_ratings;`

---

### Results template (paste EXPLAIN outputs here)
Run `EXPLAIN (ANALYZE, BUFFERS)` before and after and paste outputs under each query.

**Query 1 — price filter**  
**Before**  

**After**  

**Short note:** index on `products.price` should switch Seq Scan → Index Scan and cut runtime.

**Query 2 — orders by date**  
**Before**  

**After**  

**Short note:** using a date range lets `orders(order_date)` be used and improves runtime.

**Query 3 — pending orders**  
**Before**  

**After**  

**Short note:** partial index reduces scanned rows when pending is rare.

**Query 4 — rank per brand**  
**Before**  

**After**  

**Short note:** composite index `(brand_id, price DESC)` helps window ordering.

**Query 5 — customer total spend**  
**Before**  

**After**  

**Short note:** join indexes speed live aggregation; materialized view gives fastest reads.

**Query 6 — product ratings**  
**Before**  

**After**  

**Short note:** index on `reviews.product_id` helps aggregation; materialized view helps repeated queries.

---

### Quick notes
- Use date ranges (e.g., `order_date >= '2024-01-01' AND order_date < '2025-01-01'`) instead of `EXTRACT(YEAR FROM ...)` for index-friendly filters.  
- Partial indexes are useful when only a small subset of rows match a condition (e.g., `status = 'pending'`).  
- Materialized views speed repeated heavy aggregations but must be refreshed when source data changes.

---

### Submission checklist
- [x] `sql/schema.sql` included  
- [x] `sql/testdata.sql` included  
- [x] `sql/queries.sql` and `sql/queries_advanced.sql` included  
- [x] `sql/optimization.sql` included and runnable  
- [ ] Paste EXPLAIN outputs and add short numeric comparisons (recommended for VG)



