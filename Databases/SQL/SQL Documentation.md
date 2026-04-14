# 📚 SQL Quick Reference Guide for MCQ Test

## 1. Categories of SQL Commands

| Category | Purpose | Common Commands |
|----------|---------|------------------|
| **DDL** (Data Definition) | Define/modify database structure | `CREATE`, `ALTER`, `DROP`, `TRUNCATE`, `RENAME` |
| **DML** (Data Manipulation) | Manage data inside tables | `SELECT`, `INSERT`, `UPDATE`, `DELETE` |
| **DCL** (Data Control) | Manage permissions | `GRANT`, `REVOKE` |
| **TCL** (Transaction Control) | Manage transactions | `COMMIT`, `ROLLBACK`, `SAVEPOINT` |

## 2. Most Important Commands & Syntax

### `SELECT` – Retrieve data
```sql
SELECT col1, col2 FROM table WHERE condition ORDER BY col ASC/DESC;
SELECT DISTINCT col FROM table;  -- no duplicates
SELECT * FROM table LIMIT 10;    -- top N rows
```

### `INSERT` – Add rows
```sql
INSERT INTO table (col1, col2) VALUES (val1, val2);
INSERT INTO table VALUES (val1, val2);  -- all columns in order
```

### `UPDATE` – Modify existing rows
```sql
UPDATE table SET col1 = val1 WHERE condition;
```

### `DELETE` – Remove rows
```sql
DELETE FROM table WHERE condition;  -- rows
DELETE FROM table;  -- all rows (faster than DROP? No, DROP removes table)
```

### `CREATE TABLE`
```sql
CREATE TABLE table_name (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT CHECK (age >= 0)
);
```

### `ALTER TABLE`
```sql
ALTER TABLE table ADD column datatype;
ALTER TABLE table DROP COLUMN column;
ALTER TABLE table MODIFY column datatype;  -- different per DB
```

### `DROP` vs `TRUNCATE` vs `DELETE` (Common MCQ trap!)

| Command | Speed | Can Rollback? | Removes Structure? | Resets Auto-increment? | WHERE clause? |
|---------|-------|---------------|--------------------|------------------------|----------------|
| `DELETE` | Slow | ✅ Yes | ❌ No | ❌ No | ✅ Yes |
| `TRUNCATE` | Fast | ❌ No (in most DBs) | ❌ No | ✅ Yes | ❌ No |
| `DROP` | Fast | ❌ No | ✅ Yes (entire table) | N/A | ❌ No |

## 3. Filtering & Conditions

### `WHERE` operators
- Comparison: `=`, `<>` or `!=`, `>`, `<`, `>=`, `<=`
- Logical: `AND`, `OR`, `NOT`
- Range: `BETWEEN A AND B` (inclusive)
- List: `IN (val1, val2, ...)`
- Pattern: `LIKE` with `%` (any chars) and `_` (one char)
- Null: `IS NULL`, `IS NOT NULL` (never use `= NULL`)

## 4. Aggregate Functions (Always used with `GROUP BY` or alone)
- `COUNT(*)` – count rows
- `SUM(col)`, `AVG(col)`, `MIN(col)`, `MAX(col)`

## 5. `GROUP BY` & `HAVING`
```sql
SELECT dept, AVG(salary) 
FROM employees 
GROUP BY dept
HAVING AVG(salary) > 50000;
```
- `WHERE` filters **before** grouping (rows)
- `HAVING` filters **after** grouping (aggregates)

## 6. Joins (Heavy MCQ area)

```sql
-- INNER JOIN: matching rows only
SELECT * FROM A JOIN B ON A.id = B.a_id;

-- LEFT JOIN: all A + matching B
-- RIGHT JOIN: all B + matching A
-- FULL OUTER JOIN: all rows from both (union)

-- CROSS JOIN: Cartesian product (every A × every B)
-- SELF JOIN: table joins to itself (need alias)
```

### Quick table:
| Join Type | Result |
|-----------|--------|
| `INNER` | Only matches |
| `LEFT` | All left table rows |
| `RIGHT` | All right table rows |
| `FULL OUTER` | All rows from both |
| `CROSS` | Every combination |

## 7. Set Operations (columns must match)
- `UNION` – combines, removes duplicates
- `UNION ALL` – combines, keeps duplicates
- `INTERSECT` – rows in both queries
- `EXCEPT` (or `MINUS`) – rows in first but not second

## 8. Constraints

| Constraint | Purpose |
|------------|---------|
| `PRIMARY KEY` | Unique + NOT NULL, only one per table |
| `FOREIGN KEY` | Links to PK of another table (referential integrity) |
| `UNIQUE` | No duplicates, can be NULL (except one NULL row in some DBs) |
| `NOT NULL` | Cannot be empty |
| `CHECK` | Validates condition on insert/update |
| `DEFAULT` | Default value if not provided |

## 9. Indexes
```sql
CREATE INDEX idx_name ON table(col);
DROP INDEX idx_name;
```
- Speeds up `WHERE`, `JOIN`, `ORDER BY`
- Slows down `INSERT`/`UPDATE`/`DELETE`

## 10. Subqueries
```sql
-- Scalar (returns one value)
SELECT name FROM emp WHERE salary > (SELECT AVG(salary) FROM emp);

-- Row, Table, EXISTS
SELECT name FROM emp WHERE dept_id IN (SELECT id FROM dept WHERE name='IT');

-- Correlated subquery (refers to outer query)
SELECT name FROM emp e1 WHERE salary > (SELECT AVG(salary) FROM emp e2 WHERE e2.dept_id = e1.dept_id);
```

## 11. Transaction Commands (TCL)
```sql
BEGIN;  -- or START TRANSACTION
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;  -- save permanently

-- or
ROLLBACK;  -- undo all changes since BEGIN

SAVEPOINT sp1;
ROLLBACK TO sp1;
```

**ACID Properties** (know for theory MCQs):
- **Atomicity** – all or nothing
- **Consistency** – valid state before/after
- **Isolation** – concurrent transactions don't interfere
- **Durability** – committed changes persist

## 12. Views
```sql
CREATE VIEW view_name AS SELECT ...;
DROP VIEW view_name;
```
- Virtual table (no data stored unless materialized)
- Can simplify complex queries, provide security

## 13. Common MCQ Traps

| Misconception | Truth |
|---------------|-------|
| `DELETE` removes table | ❌ No, `DROP` does |
| `WHERE` works on aggregates | ❌ Use `HAVING` |
| `NULL = NULL` is true | ❌ It's unknown → use `IS NULL` |
| `TRUNCATE` can be rolled back in all DBs | ❌ In MySQL/PostgreSQL it's auto-commit |
| `UNION` keeps duplicates | ❌ `UNION ALL` does |
| `COUNT(col)` counts NULLs | ❌ `COUNT(*)` counts rows; `COUNT(col)` ignores NULLs |
| `PRIMARY KEY` allows one NULL | ❌ No NULLs at all |
| `FOREIGN KEY` can reference non-PK | ✅ Yes, but must be UNIQUE |

## 14. Execution Order (Very important!)
```sql
SELECT col, AGG()
FROM table
JOIN other ON condition
WHERE row_filter
GROUP BY col
HAVING agg_filter
ORDER BY col
LIMIT n;
```
**Logical execution order:**
1. `FROM` + `JOIN`
2. `WHERE`
3. `GROUP BY`
4. `HAVING`
5. `SELECT` (including aggregates)
6. `ORDER BY`
7. `LIMIT` / `OFFSET`

---
