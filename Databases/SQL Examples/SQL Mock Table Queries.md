I'll use an **e-commerce order management** schema — it's rich enough for joins, aggregations, window functions, and subqueries. Let me know if you'd prefer a different domain (HR, banking, library, etc.) and I'll swap it.

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

```sql
SELECT customer_id
FROM orders
WHERE order_date >= '2025-01-01' AND order_date < '2026-01-01'
GROUP BY customer_id
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM order_date)) = 12;
```

**4. Products never ordered**

```sql
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL;
```

**5. Running total spend per customer**

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

```sql
SELECT p.product_id, p.product_name, AVG(r.rating) AS avg_rating, COUNT(*) AS review_count
FROM products p
JOIN reviews r ON r.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING AVG(r.rating) < 3 AND COUNT(*) > 5;
```

**10. Frequently bought-together product pairs**

```sql
SELECT a.product_id AS product_a, b.product_id AS product_b, COUNT(*) AS times_bought_together
FROM order_items a
JOIN order_items b ON a.order_id = b.order_id AND a.product_id < b.product_id
GROUP BY a.product_id, b.product_id
ORDER BY times_bought_together DESC;
```

A few of these assume specific dialect behavior (`EXTRACT`, `DATE_TRUNC` — Postgres syntax). Let me know if you're targeting MySQL/SQL Server and I'll adjust the syntax.

