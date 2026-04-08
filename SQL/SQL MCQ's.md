Here are **60 SQL MCQs** covering **theory, practical output, error-based, and tricky edge cases**. Each question is immediately followed by its **correct answer and a brief explanation**.

---

## Questions 1–10: DDL, DML, & Basic Concepts

**1.** Which SQL command removes all rows from a table but keeps the table structure and does NOT reset auto-increment in MySQL?  
✅ **Answer: DELETE** (Explanation: TRUNCATE resets auto-increment; DELETE does not)

**2.** Which command is used to remove a table entirely from the database?  
✅ **Answer: DROP**

**3.** What is the output of `SELECT LENGTH(NULL)`?  
✅ **Answer: NULL** (Explanation: Any operation with NULL returns NULL)

**4.** Which constraint allows multiple NULL values in a column but prevents duplicates?  
✅ **Answer: UNIQUE** (Explanation: In most DBs, UNIQUE allows multiple NULLs because NULL ≠ NULL)

**5.** What happens when you run `DELETE FROM employees` without a WHERE clause?  
✅ **Answer: All rows are deleted, table structure remains**

**6.** Which statement correctly adds a new column `age` to an existing table `users`?  
✅ **Answer: ALTER TABLE users ADD age INT;**

**7.** Which of the following is a DCL command?  
✅ **Answer: GRANT** (Explanation: DCL = GRANT and REVOKE)

**8.** What does `SELECT COUNT(salary) FROM employees` return if 3 out of 10 rows have NULL salary?  
✅ **Answer: 7** (Explanation: COUNT(column) ignores NULLs)

**9.** Which command permanently saves a transaction?  
✅ **Answer: COMMIT**

**10.** What is the output of `SELECT '10' + 5` in MySQL?  
✅ **Answer: 15** (Explanation: MySQL implicitly converts string to number)

---

## Questions 11–20: WHERE, Operators, Pattern Matching

**11.** Which operator checks if a value matches any in a list?  
✅ **Answer: IN**

**12.** What does the pattern `'%_%'` match?  
✅ **Answer: Any string with at least one character** (Explanation: % = any chars, _ = exactly one char)

**13.** What is wrong with `SELECT * FROM users WHERE name = NULL`?  
✅ **Answer: Should be `name IS NULL`** (Explanation: = NULL never returns true)

**14.** Which query finds names starting with 'J' and exactly 3 letters?  
✅ **Answer: WHERE name LIKE 'J__'** (Explanation: Two underscores = two more characters)

**15.** What does `BETWEEN 10 AND 20` include?  
✅ **Answer: 10 and 20** (Explanation: BETWEEN is inclusive in SQL)

**16.** Which logical operator short-circuits?  
✅ **Answer: AND and OR both short-circuit in most DBs**

**17.** What is the output of `SELECT 'A' > 'a'` in a case-sensitive database?  
✅ **Answer: FALSE or 0** (Explanation: ASCII 'A' (65) < 'a' (97))

**18.** Which condition finds values that are NOT between 1 and 100?  
✅ **Answer: WHERE col NOT BETWEEN 1 AND 100**

**19.** What does `WHERE name LIKE '\%'` match if escape character is not defined?  
✅ **Answer: Names starting with %** (Explanation: Backslash escapes %, but depends on DB)

**20.** Which operator returns TRUE if a subquery returns at least one row?  
✅ **Answer: EXISTS**

---

## Questions 21–30: Aggregate Functions, GROUP BY, HAVING

**21.** Which clause filters groups after aggregation?  
✅ **Answer: HAVING**

**22.** What is the output if you run `SELECT AVG(salary) FROM employees` with no rows?  
✅ **Answer: NULL**

**23.** Which query is syntactically correct?  
✅ **Answer: SELECT dept, COUNT(*) FROM emp GROUP BY dept HAVING COUNT(*) > 5**

**24.** What is wrong with `SELECT dept, MAX(salary) FROM emp WHERE MAX(salary) > 50000 GROUP BY dept`?  
✅ **Answer: WHERE cannot contain aggregate functions** (Explanation: Use HAVING instead)

**25.** What does `SELECT COUNT(DISTINCT dept) FROM emp` return?  
✅ **Answer: Number of unique department values**

**26.** Which aggregate function ignores NULLs?  
✅ **Answer: All of them (COUNT, SUM, AVG, MIN, MAX ignore NULLs except COUNT(*))**

**27.** What is the output of `SELECT SUM(NULL)`?  
✅ **Answer: NULL**

**28.** Can you use `WHERE` with aggregates without `GROUP BY`?  
✅ **Answer: No, WHERE is row-level, aggregates need HAVING**

**29.** What does `SELECT dept, COUNT(*) FROM emp GROUP BY dept` return if a dept has 0 employees?  
✅ **Answer: That dept won't appear** (Explanation: GROUP BY only shows existing groups)

**30.** Which runs first: `HAVING` or `ORDER BY`?  
✅ **Answer: HAVING** (Explanation: Order: WHERE → GROUP BY → HAVING → SELECT → ORDER BY)

---

## Questions 31–40: Joins (Theory & Practical)

**31.** Which join returns only matching rows from both tables?  
✅ **Answer: INNER JOIN**

**32.** What does `LEFT JOIN` return for a row in the left table with no match in the right?  
✅ **Answer: All left table columns + NULLs for right table columns**

**33.** How many rows does a `CROSS JOIN` between a table of 3 rows and a table of 4 rows produce?  
✅ **Answer: 12** (Explanation: Cartesian product = 3 × 4)

**34.** Which join is the same as `INNER JOIN`?  
✅ **Answer: JOIN** (Explanation: JOIN defaults to INNER JOIN)

**35.** What is a `SELF JOIN`?  
✅ **Answer: Joining a table to itself using aliases**

**36.** Which join returns all rows from both tables, matching where possible?  
✅ **Answer: FULL OUTER JOIN**

**37.** What happens if you forget the `ON` clause in an `INNER JOIN`?  
✅ **Answer: Syntax error** (Explanation: INNER JOIN requires ON or USING)

**38.** Which join is typically the most efficient for large tables?  
✅ **Answer: INNER JOIN** (Explanation: It eliminates non-matching rows early)

**39.** Can you `JOIN` more than two tables in one query?  
✅ **Answer: Yes**

**40.** What does `RIGHT JOIN` return that `LEFT JOIN` does not?  
✅ **Answer: Nothing—they are mirrors; just swap table order**

---

## Questions 41–50: Subqueries, Set Operations, Indexes

**41.** Which type of subquery returns a single value?  
✅ **Answer: Scalar subquery**

**42.** What is a correlated subquery?  
✅ **Answer: Subquery that references columns from the outer query**

**43.** Which set operation removes duplicates by default?  
✅ **Answer: UNION** (Explanation: UNION removes duplicates; UNION ALL keeps them)

**44.** What is the output of `SELECT 1 UNION SELECT 1 UNION SELECT 2`?  
✅ **Answer: 1, 2** (two rows)

**45.** Which set operation returns rows found in the first query but not the second?  
✅ **Answer: EXCEPT (or MINUS)**

**46.** What happens if two `UNION` queries have different numbers of columns?  
✅ **Answer: Syntax error**

**47.** Which statement creates an index on the `last_name` column?  
✅ **Answer: CREATE INDEX idx_last ON users(last_name);**

**48.** What is a downside of adding too many indexes?  
✅ **Answer: Slower INSERT/UPDATE/DELETE**

**49.** Can you create an index on a `NULL` value?  
✅ **Answer: Yes, indexes usually include NULLs (except some unique indexes)**

**50.** Which subquery operator compares a value to a list returned by a subquery?  
✅ **Answer: IN**

---

## Questions 51–60: Transactions, Views, Constraints, Errors

**51.** What does `ROLLBACK` do?  
✅ **Answer: Undoes all changes since the last COMMIT**

**52.** Which command creates a virtual table based on a SELECT query?  
✅ **Answer: CREATE VIEW**

**53.** Can you `INSERT` into a view?  
✅ **Answer: Yes, if the view maps directly to a single table without aggregates**

**54.** What is an error when inserting into a table with a `FOREIGN KEY` constraint?  
✅ **Answer: Foreign key constraint violation** (if referenced value doesn't exist)

**55.** Which constraint prevents a negative salary?  
✅ **Answer: CHECK (salary >= 0)**

**56.** What happens if you try to insert a duplicate value into a `PRIMARY KEY` column?  
✅ **Answer: Primary key violation error**

**57.** What is the difference between `DELETE` and `TRUNCATE` regarding transaction logs?  
✅ **Answer: DELETE logs each row; TRUNCATE logs only page deallocations (faster)**

**58.** Can you rollback `TRUNCATE` in PostgreSQL?  
✅ **Answer: Yes** (Explanation: PostgreSQL wraps TRUNCATE in a transaction; MySQL does not by default)

**59.** What error does `SELECT * FROM nonexistent_table` produce?  
✅ **Answer: Table not found error**

**60.** What happens with `UPDATE users SET age = age * 1.1 WHERE age IS NULL`?  
✅ **Answer: No rows updated** (Explanation: NULL * 1.1 = NULL, so nothing changes)

---

## ✅ Summary of Question Types Covered

| Type | Example Questions |
|------|------------------|
| **Theory** | 1, 2, 4, 7, 18, 31, 47, 51, 54 |
| **Practical Output** | 3, 8, 10, 15, 22, 25, 27, 33, 44 |
| **Error-Based** | 13, 16, 24, 37, 46, 55, 56, 59 |
| **Tricky/Edge Cases** | 5, 9, 12, 19, 29, 35, 40, 57, 58, 60 |

---

Let me know when you want **Part 2** (another 60 questions) or a **timed mock test** with answer sheet!