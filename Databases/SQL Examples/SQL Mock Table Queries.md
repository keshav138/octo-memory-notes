## Database Schema

```sql
customers(customer_id PK, name, email, city, signup_date)

categories(category_id PK, category_name)

products(product_id PK, product_name, category_id FK -> categories, price, stock_qty)

orders(order_id PK, customer_id FK -> customers, order_date, status)  -- status: 'placed','shipped','delivered','cancelled'

order_items(order_item_id PK, order_id FK -> orders, product_id FK -> products, quantity, unit_price)

payments(payment_id PK, order_id FK -> orders, payment_date, amount, method)

reviews(review_id PK, product_id FK -> products, customer_id FK -> customers, rating, review_date)
```

Relationships: one customer → many orders; one order → many order_items; one product → many order_items & reviews; one order → one payment (assume 1:1 for simplicity).

## 10 Medium–High Level Questions

1. Find the top 3 customers by total amount spent (based on `payments`), including their name and total.
2. For each category, find the best-selling product (by total quantity sold via `order_items`).
3. List customers who have placed orders in every month of 2025 (no gaps).
4. Find products that have never been ordered.
5. Calculate each customer's running total spend over time, ordered by order date (window function).
6. Find the second-highest priced product in each category without using `LIMIT`/`OFFSET` (use `RANK()`/subquery).
7. Identify customers whose average order value is above the overall average order value.
8. Find the month-over-month percentage growth in total revenue.
9. List products with an average rating below 3 but more than 5 reviews.
10. Find pairs of products frequently bought together in the same order (self-join on `order_items`), ordered by frequency.
---

## Answers

**1. Top 3 customers by total spend**


- Ask: what am I aggregating, and at what grain? → Spend is in `payments`, but I need customer name, so I need to join up: payments → orders → customers.
- Approach: join the three tables, `GROUP BY` the customer (grain = one row per customer), `SUM` the amount, then `ORDER BY ... DESC LIMIT 3`.
- Pattern to internalize: **join to get context → aggregate → sort → limit**.
```sql
SELECT c.customer_id, c.name, SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN payments p ON p.order_id = o.order_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 3;
```

**2. Best-selling product per category**

- Ask: "best per group" always signals a window function, not a plain `GROUP BY`, because you need to rank _within_ a partition.
- Approach: first compute quantity sold per product (join products + order_items, group by product), then wrap that in `RANK() OVER (PARTITION BY category_id ORDER BY qty DESC)` and filter `rnk = 1`.
- Pattern: **aggregate first in a CTE → rank on top of the aggregate**, never try to rank and aggregate in the same `SELECT` — it won't work because window functions run after `GROUP BY`.
```sql
WITH sales AS (
  SELECT p.category_id, p.product_id, p.product_name,
         SUM(oi.quantity) AS qty_sold,
         RANK() OVER (PARTITION BY p.category_id ORDER BY SUM(oi.quantity) DESC) AS rnk
  FROM products p
  JOIN order_items oi ON oi.product_id = p.product_id
  GROUP BY p.category_id, p.product_id, p.product_name
)
SELECT category_id, product_id, product_name, qty_sold
FROM sales
WHERE rnk = 1;
```

**3. Customers who ordered in every month of 2025**
- Ask: "every month" = a counting/completeness check, not a filter on individual rows.
- Approach: filter to 2025 orders, extract the month number from each order, group by customer, and check `COUNT(DISTINCT month) = 12`. The `DISTINCT` matters — otherwise multiple orders in the same month inflate the count.
- Pattern: **"in every X" → COUNT(DISTINCT unit) = total possible units**.
```sql
SELECT customer_id
FROM orders
WHERE order_date >= '2025-01-01' AND order_date < '2026-01-01'
GROUP BY customer_id
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM order_date)) = 12;
```

**4. Products never ordered**

- Ask: "never" = anti-join territory. Two standard tools: `LEFT JOIN ... WHERE right.key IS NULL`, or `NOT EXISTS`.
- Approach: `LEFT JOIN` products to order_items, then filter where the joined row is missing (`oi.order_item_id IS NULL`).
- Pattern: **"products with no matching X" → LEFT JOIN + IS NULL, or NOT EXISTS** (NOT EXISTS is often safer with NULLs and usually performs better on large tables).
```sql
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;
```

**5. Running total spend per customer**


- Ask: "running/cumulative" = window function with a frame clause, not a subquery-per-row.
- Approach: get each order's payment amount, then `SUM(amount) OVER (PARTITION BY customer ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`.
- Pattern: **cumulative/running metric → SUM/AVG/COUNT with an ORDER BY inside OVER()**. The frame clause is technically optional (default frame does the same thing when ORDER BY is present), but writing it explicitly avoids ambiguity.
```sql
SELECT c.customer_id, c.name, o.order_id, o.order_date, p.amount,
       SUM(p.amount) OVER (PARTITION BY c.customer_id ORDER BY o.order_date
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN payments p ON p.order_id = o.order_id
ORDER BY c.customer_id, o.order_date;
```

**6. Second-highest priced product per category (no LIMIT/OFFSET)**
-  Ask: why can't I just use LIMIT 1 OFFSET 1 per category? Because LIMIT/OFFSET works globally, not per-group.
- Approach: rank prices within each category using `DENSE_RANK()` (not `RANK()` — `RANK()` skips numbers on ties, `DENSE_RANK()` doesn't, which matters if two products tie for 1st), then filter `rnk = 2`.
- Pattern: **"Nth per group" → DENSE_RANK/RANK partitioned by group, filter on rank value**. Choose DENSE_RANK when ties shouldn't skip a rank.
```sql
WITH ranked AS (
  SELECT product_id, product_name, category_id, price,
         DENSE_RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rnk
  FROM products
)
SELECT category_id, product_id, product_name, price
FROM ranked
WHERE rnk = 2;
```

**7. Customers with avg order value above overall average**


- Ask: this needs two aggregation levels — order-level totals, then customer-level average of those totals, then compare to the _overall_ average. That's a strong signal for CTEs, because you can't nest aggregates directly (`AVG(SUM(...))` in one query without grouping tricks).
- Approach: CTE 1 (`order_totals`) collapses order_items to one row per order. CTE 2 (`customer_avg`) collapses that to one row per customer. Final query filters against a scalar subquery computing the grand average.
- Pattern: **multi-level aggregation → chain CTEs, one grain-reduction per step**.
```sql
WITH order_totals AS (
  SELECT o.order_id, o.customer_id, SUM(oi.quantity * oi.unit_price) AS order_value
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  GROUP BY o.order_id, o.customer_id
),
customer_avg AS (
  SELECT customer_id, AVG(order_value) AS avg_order_value
  FROM order_totals
  GROUP BY customer_id
)
SELECT customer_id, avg_order_value
FROM customer_avg
WHERE avg_order_value > (SELECT AVG(order_value) FROM order_totals);
```

**8. Month-over-month revenue growth %**

- Ask: "compare to previous period" = `LAG()`.
- Approach: first collapse payments to one row per month (`DATE_TRUNC` + `SUM`), then use `LAG(revenue) OVER (ORDER BY month)` to pull the prior month into the same row, then compute the percentage difference. `NULLIF` guards against divide-by-zero if a prior month had 0 revenue.
- Pattern: **period-over-period comparison → LAG/LEAD, always wrap the divisor in NULLIF if it could be zero**.
```sql
WITH monthly AS (
  SELECT DATE_TRUNC('month', p.payment_date) AS month, SUM(p.amount) AS revenue
  FROM payments p
  GROUP BY DATE_TRUNC('month', p.payment_date)
)
SELECT month, revenue,
       LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / NULLIF(LAG(revenue) OVER (ORDER BY month), 0), 2) AS growth_pct
FROM monthly
ORDER BY month;
```

**9. Products with avg rating < 3 and > 5 reviews**

 
- Ask: this is a plain aggregate with two conditions on the _aggregated_ values, not the raw rows — so it must go in `HAVING`, not `WHERE`.
- Approach: join products to reviews, group by product, then `HAVING AVG(rating) < 3 AND COUNT(*) > 5`.
- Pattern: **condition on a raw column → WHERE; condition on an aggregate result → HAVING**.
```sql
SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating, COUNT(*) AS review_count
FROM products p
JOIN reviews r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.rating) < 3 AND COUNT(*) > 5;
```

**10. Frequently bought-together product pairs**

- Ask: I need to compare rows within the same order to each other — that's a self-join.
- Approach: join `order_items` to itself on matching `order_id`, and add `a.product_id < b.product_id` to (a) avoid pairing a product with itself and (b) avoid counting (A,B) and (B,A) as two separate pairs. Then group by the pair and count.
- Pattern: **"relationships between rows in the same table" → self-join, with an inequality condition to dedupe pairs**.
```sql
SELECT a.product_id AS product_a, b.product_id AS product_b, COUNT(*) AS times_bought_together
FROM order_items a
JOIN order_items b ON a.order_id = b.order_id AND a.product_id < b.product_id
GROUP BY a.product_id, b.product_id
ORDER BY times_bought_together DESC;
```


**General approach checklist I'd apply to any medium/hard SQL question:**

1. Identify the grain of the final answer (one row per what?).
2. Identify which tables need joining to get there.
3. Decide: single-pass aggregate, or does it need multiple aggregation levels (→ CTEs)?
4. Does it need row-to-row comparison (previous row, top-N per group, running value)? → window function.
5. Filter on raw columns → `WHERE`; filter on aggregates → `HAVING`; filter on window function output → wrap in a CTE/subquery and filter outside.