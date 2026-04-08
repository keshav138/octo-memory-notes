Here are **SQL command snippets for all major categories** — 3 per category, with syntax, simple use, and complex use case.

---

## 1. DDL (Data Definition Language)

### 1.1 CREATE

**Syntax:**
```sql
CREATE TABLE table_name (column1 datatype constraint, column2 datatype constraint);
```

**Simple use:**
```sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    hire_date DATE
);
```

**Complex use:**
```sql
CREATE TABLE sales_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT CHECK (quantity > 0),
    sale_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'PENDING',
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    INDEX idx_sale_date (sale_date),
    UNIQUE KEY uk_transaction (transaction_id, customer_id)
);
```

---

### 1.2 ALTER

**Syntax:**
```sql
ALTER TABLE table_name ADD column_name datatype;
ALTER TABLE table_name DROP COLUMN column_name;
ALTER TABLE table_name MODIFY column_name new_datatype;
```

**Simple use:**
```sql
ALTER TABLE employees ADD email VARCHAR(100);
```

**Complex use:**
```sql
ALTER TABLE employees
ADD COLUMN middle_name VARCHAR(50) AFTER first_name,
ADD COLUMN department_id INT,
ADD CONSTRAINT fk_dept FOREIGN KEY (department_id) REFERENCES departments(id),
MODIFY COLUMN name VARCHAR(150) NOT NULL,
DROP COLUMN old_field,
RENAME COLUMN hire_date TO joined_date;
```

---

### 1.3 DROP

**Syntax:**
```sql
DROP TABLE table_name;
DROP DATABASE database_name;
DROP INDEX index_name ON table_name;
```

**Simple use:**
```sql
DROP TABLE temp_data;
```

**Complex use (with IF EXISTS and CASCADE):**
```sql
-- Drop table only if it exists (avoids error)
DROP TABLE IF EXISTS audit_log_2023;

-- Drop table and all dependent objects (views, FKs)
DROP TABLE customers CASCADE CONSTRAINTS;

-- Drop multiple tables at once
DROP TABLE IF EXISTS backup_jan, backup_feb, backup_mar;

-- Drop index before dropping table (cleanup)
DROP INDEX idx_employee_name ON employees;
DROP TABLE employees;
```

---

## 2. DML (Data Manipulation Language)

### 2.1 SELECT

**Syntax:**
```sql
SELECT columns FROM table WHERE condition GROUP BY column HAVING condition ORDER BY column;
```

**Simple use:**
```sql
SELECT first_name, last_name, salary FROM employees WHERE department = 'IT';
```

**Complex use:**
```sql
SELECT 
    d.department_name,
    COUNT(e.id) AS employee_count,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    SUM(CASE WHEN e.status = 'ACTIVE' THEN 1 ELSE 0 END) AS active_count,
    RANK() OVER (ORDER BY AVG(e.salary) DESC) AS salary_rank
FROM departments d
LEFT JOIN employees e ON d.id = e.department_id
WHERE e.hire_date >= '2020-01-01'
GROUP BY d.id, d.department_name
HAVING COUNT(e.id) > 5
ORDER BY avg_salary DESC
LIMIT 10;
```

---

### 2.2 INSERT

**Syntax:**
```sql
INSERT INTO table (col1, col2) VALUES (val1, val2);
INSERT INTO table SELECT ...;
INSERT INTO table DEFAULT VALUES;
```

**Simple use:**
```sql
INSERT INTO users (username, email) VALUES ('john_doe', 'john@example.com');
```

**Complex use:**
```sql
-- Insert with subquery and ON CONFLICT handling (PostgreSQL)
INSERT INTO employee_archive (id, name, salary, archive_date)
SELECT id, name, salary, CURRENT_DATE
FROM employees
WHERE termination_date IS NOT NULL
ON CONFLICT (id) 
DO UPDATE SET 
    name = EXCLUDED.name,
    salary = EXCLUDED.salary,
    archive_date = CURRENT_DATE;

-- Insert multiple rows with conditional logic
INSERT INTO monthly_sales (product_id, month, total, region)
VALUES 
    (101, '2024-01', 1500.00, 'NORTH'),
    (102, '2024-01', 2200.00, 'SOUTH'),
    (103, '2024-01', 800.00, 'EAST')
ON DUPLICATE KEY UPDATE 
    total = total + VALUES(total);
```

---

### 2.3 UPDATE

**Syntax:**
```sql
UPDATE table SET col1 = val1 WHERE condition;
UPDATE table SET col1 = val1 FROM other_table WHERE join_condition;
```

**Simple use:**
```sql
UPDATE products SET price = price * 1.10 WHERE category = 'Electronics';
```

**Complex use:**
```sql
-- Update with JOIN and subquery
UPDATE orders o
SET 
    o.status = 'COMPLETED',
    o.completed_date = CURRENT_TIMESTAMP,
    o.total_with_tax = o.subtotal * (1 + t.tax_rate)
FROM tax_rates t
WHERE o.region = t.region
AND o.status = 'PENDING'
AND o.order_date < CURRENT_DATE - INTERVAL '30 days'
AND EXISTS (
    SELECT 1 FROM payments p 
    WHERE p.order_id = o.id AND p.status = 'CONFIRMED'
);

-- Conditional update with CASE
UPDATE employees
SET 
    salary = CASE 
        WHEN performance_rating = 'EXCELLENT' THEN salary * 1.15
        WHEN performance_rating = 'GOOD' THEN salary * 1.10
        WHEN performance_rating = 'AVERAGE' THEN salary * 1.05
        ELSE salary
    END,
    bonus_eligible = CASE 
        WHEN performance_rating IN ('EXCELLENT', 'GOOD') THEN TRUE
        ELSE FALSE
    END,
    last_review_date = CURRENT_DATE
WHERE department_id IN (SELECT id FROM departments WHERE budget > 1000000);
```

---

### 2.4 DELETE

**Syntax:**
```sql
DELETE FROM table WHERE condition;
DELETE FROM table USING other_table WHERE join_condition;
```

**Simple use:**
```sql
DELETE FROM sessions WHERE last_activity < NOW() - INTERVAL '7 days';
```

**Complex use:**
```sql
-- Delete with JOIN (MySQL/PostgreSQL syntax)
DELETE oi
FROM order_items oi
JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'CANCELLED'
AND o.cancelled_date < CURRENT_DATE - INTERVAL '90 days';

-- Delete using CTE (Common Table Expression)
WITH old_logs AS (
    SELECT id FROM audit_logs 
    WHERE created_at < CURRENT_DATE - INTERVAL '1 year'
    AND log_type = 'DEBUG'
)
DELETE FROM audit_logs 
WHERE id IN (SELECT id FROM old_logs)
LIMIT 10000;

-- Delete with subquery and return deleted rows (PostgreSQL)
DELETE FROM temp_users
WHERE id IN (
    SELECT id FROM users 
    WHERE verified = FALSE 
    AND created_at < CURRENT_DATE - INTERVAL '30 days'
    ORDER BY created_at
    LIMIT 5000
)
RETURNING id, email, created_at;
```

---

## 3. TCL (Transaction Control Language)

### 3.1 COMMIT

**Syntax:**
```sql
COMMIT;
COMMIT WORK;  -- standard SQL
COMMIT AND CHAIN;  -- starts new transaction after commit
```

**Simple use:**
```sql
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
```

**Complex use:**
```sql
-- Transaction with multiple operations and conditional commit
BEGIN TRANSACTION;

UPDATE inventory SET quantity = quantity - 10 WHERE product_id = 101;
INSERT INTO order_items (order_id, product_id, quantity) VALUES (5001, 101, 10);

-- Check inventory after update
IF (SELECT quantity FROM inventory WHERE product_id = 101) >= 0 THEN
    INSERT INTO transactions_log (action, status, timestamp) 
    VALUES ('ORDER_FULFILLED', 'SUCCESS', NOW());
    COMMIT;
ELSE
    INSERT INTO transactions_log (action, status, timestamp) 
    VALUES ('ORDER_FAILED', 'ROLLBACK', NOW());
    ROLLBACK;
END IF;
```

---

### 3.2 ROLLBACK

**Syntax:**
```sql
ROLLBACK;
ROLLBACK TO SAVEPOINT savepoint_name;
ROLLBACK WORK;
```

**Simple use:**
```sql
BEGIN;
DELETE FROM temp_staging;
-- Oops, wrong table! 
ROLLBACK;
```

**Complex use:**
```sql
BEGIN TRANSACTION;

SAVEPOINT before_update;

UPDATE products SET price = price * 1.5 WHERE category = 'Luxury';

-- Check if any prices exceeded threshold
IF EXISTS (SELECT 1 FROM products WHERE price > 10000 AND category = 'Luxury') THEN
    ROLLBACK TO SAVEPOINT before_update;
    INSERT INTO audit_log (action, reason) VALUES ('PRICE_ROLLBACK', 'Exceeded limit');
END IF;

INSERT INTO price_history (product_id, old_price, new_price, change_date)
SELECT id, price/1.5, price, NOW() FROM products WHERE category = 'Luxury';

COMMIT;
```

---

### 3.3 SAVEPOINT

**Syntax:**
```sql
SAVEPOINT savepoint_name;
ROLLBACK TO SAVEPOINT savepoint_name;
RELEASE SAVEPOINT savepoint_name;
```

**Simple use:**
```sql
BEGIN;
SAVEPOINT sp1;
UPDATE accounts SET balance = balance - 500 WHERE id = 1;
-- Something wrong? Rollback to sp1
ROLLBACK TO sp1;
COMMIT;
```

**Complex use:**
```sql
BEGIN;

SAVEPOINT start_batch;

INSERT INTO batch_jobs (job_name, status, start_time) VALUES ('Payroll', 'RUNNING', NOW());

-- Process first department
UPDATE employees SET salary = salary * 1.05 WHERE dept_id = 1;
SAVEPOINT dept1_done;

-- Process second department
UPDATE employees SET salary = salary * 1.10 WHERE dept_id = 2;
SAVEPOINT dept2_done;

-- Process third department (might fail)
BEGIN TRY
    UPDATE employees SET salary = salary / 0 WHERE dept_id = 3;  -- Will error
END TRY
BEGIN CATCH
    ROLLBACK TO SAVEPOINT dept2_done;
    INSERT INTO error_log (batch_id, error) VALUES (currval('batch_jobs_id_seq'), 'Dept3 failed');
END CATCH;

RELEASE SAVEPOINT dept2_done;
UPDATE batch_jobs SET status = 'COMPLETED', end_time = NOW() WHERE job_name = 'Payroll';
COMMIT;
```

---

## 4. DCL (Data Control Language)

### 4.1 GRANT

**Syntax:**
```sql
GRANT privilege ON object TO user;
GRANT role TO user WITH ADMIN OPTION;
```

**Simple use:**
```sql
GRANT SELECT ON employees TO readonly_user;
```

**Complex use:**
```sql
-- Grant multiple privileges on schema level
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA sales TO sales_team;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA sales TO sales_team;
GRANT EXECUTE ON FUNCTION calculate_commission TO sales_team;
GRANT SELECT ON sales_reports_view TO manager_role WITH GRANT OPTION;

-- Grant role with hierarchical permissions
GRANT data_analyst TO john_doe;
GRANT data_scientist TO data_analyst WITH ADMIN OPTION;  -- data_analyst inherits
```

---

### 4.2 REVOKE

**Syntax:**
```sql
REVOKE privilege ON object FROM user;
REVOKE role FROM user;
REVOKE GRANT OPTION FOR privilege ON object FROM user;
```

**Simple use:**
```sql
REVOKE DELETE ON employees FROM temp_user;
```

**Complex use:**
```sql
-- Revoke with cascade (affects users who got access via this user)
REVOKE ALL PRIVILEGES ON SCHEMA finance FROM analyst_role CASCADE;

-- Revoke specific privileges while keeping others
REVOKE INSERT, UPDATE ON orders FROM order_processor;
REVOKE EXECUTE ON FUNCTION generate_report FROM report_user;

-- Revoke grant option but keep base privilege
REVOKE GRANT OPTION FOR SELECT ON customers FROM team_lead;
```

---

### 4.3 DENY (SQL Server specific, but important)

**Syntax:**
```sql
DENY privilege ON object TO user;
```

**Simple use:**
```sql
DENY DELETE ON employees FROM intern_user;
```

**Complex use:**
```sql
-- DENY overrides GRANT
GRANT SELECT, INSERT, UPDATE, DELETE ON all_tables TO junior_dev;
DENY DELETE ON sensitive_table TO junior_dev;  -- Can't delete this specific table

-- DENY at column level
DENY SELECT (ssn, salary, bank_account) ON employees TO hr_assistant;
GRANT SELECT (id, name, department) ON employees TO hr_assistant;
```

---

## 5. Advanced/Utility Commands

### 5.1 WITH (CTE - Common Table Expression)

**Syntax:**
```sql
WITH cte_name AS (subquery) SELECT * FROM cte_name;
```

**Simple use:**
```sql
WITH high_earners AS (
    SELECT * FROM employees WHERE salary > 100000
)
SELECT department, COUNT(*) FROM high_earners GROUP BY department;
```

**Complex use (Recursive CTE):**
```sql
-- Find all subordinates under a manager (hierarchy traversal)
WITH RECURSIVE org_tree AS (
    -- Anchor member: starting point
    SELECT id, name, manager_id, 1 AS level
    FROM employees
    WHERE id = 101  -- CEO
    
    UNION ALL
    
    -- Recursive member: find direct reports
    SELECT e.id, e.name, e.manager_id, ot.level + 1
    FROM employees e
    INNER JOIN org_tree ot ON e.manager_id = ot.id
    WHERE ot.level < 10  -- Prevent infinite loops
)
SELECT 
    REPEAT('  ', level - 1) || name AS hierarchy,
    level,
    id
FROM org_tree
ORDER BY level, name;
```

---

### 5.2 MERGE / UPSERT

**Syntax:**
```sql
MERGE INTO target_table USING source_table ON condition
WHEN MATCHED THEN UPDATE SET ...
WHEN NOT MATCHED THEN INSERT ...;
```

**Simple use:**
```sql
MERGE INTO products AS target
USING product_updates AS source
ON target.id = source.id
WHEN MATCHED THEN UPDATE SET target.price = source.price
WHEN NOT MATCHED THEN INSERT (id, name, price) VALUES (source.id, source.name, source.price);
```

**Complex use:**
```sql
-- Full sync with delete for rows not in source
MERGE INTO inventory AS target
USING (
    SELECT product_id, SUM(quantity) AS total_qty
    FROM daily_stock_movements
    WHERE movement_date = CURRENT_DATE
    GROUP BY product_id
) AS source
ON target.product_id = source.product_id
WHEN MATCHED AND target.quantity != source.total_qty THEN
    UPDATE SET 
        quantity = source.total_qty,
        last_updated = CURRENT_TIMESTAMP,
        change_flag = TRUE
WHEN NOT MATCHED THEN
    INSERT (product_id, quantity, last_updated, source_type)
    VALUES (source.product_id, source.total_qty, CURRENT_TIMESTAMP, 'NEW')
WHEN NOT MATCHED BY SOURCE AND target.last_updated < CURRENT_DATE - INTERVAL '30 days' THEN
    DELETE
OUTPUT $action, inserted.product_id, deleted.quantity;
```

---

### 5.3 EXPLAIN (Query Analysis)

**Syntax:**
```sql
EXPLAIN SELECT query;
EXPLAIN ANALYZE SELECT query;
EXPLAIN (FORMAT JSON) SELECT query;
```

**Simple use:**
```sql
EXPLAIN SELECT * FROM orders WHERE customer_id = 12345;
```

**Complex use:**
```sql
-- Detailed execution plan with timing
EXPLAIN (ANALYZE, BUFFERS, TIMING, FORMAT TEXT)
SELECT 
    c.name,
    COUNT(o.id) AS order_count,
    SUM(o.total) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= '2024-01-01'
GROUP BY c.id, c.name
HAVING COUNT(o.id) > 5
ORDER BY total_spent DESC
LIMIT 100;

-- Output helps identify:
-- 1. Sequential scans vs index scans
-- 2. Join types (hash, merge, nested loop)
-- 3. Memory usage and temp files
-- 4. Actual vs estimated rows (statistics accuracy)
```

---

## Quick Reference Card

| Category | Commands | When to Use |
|----------|----------|-------------|
| **DDL** | CREATE, ALTER, DROP, TRUNCATE | Define/modify structure |
| **DML** | SELECT, INSERT, UPDATE, DELETE | Work with data |
| **TCL** | COMMIT, ROLLBACK, SAVEPOINT | Manage transactions |
| **DCL** | GRANT, REVOKE, DENY | Control access |
| **Utility** | WITH, MERGE, EXPLAIN | Complex queries, sync, debug |

---

Want me to now create **MCQs specifically testing these snippets** — asking things like "Which query will cause an error?" or "What will this complex UPDATE do?"