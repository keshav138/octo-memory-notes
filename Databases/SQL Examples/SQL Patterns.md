Here's a consolidated "signal → tool" cheat sheet, pulled from the patterns across all 10 queries plus a few extra common ones worth knowing.

## Pattern Recognition Cheat Sheet

**Signal: "top N per group" / "best X per category" / "highest per Y"** → Window function: `RANK()` / `DENSE_RANK()` / `ROW_NUMBER()` partitioned by the group, then filter on rank in an outer query/CTE.

- `ROW_NUMBER()` — always unique rank, use when ties don't matter or you want exactly 1 row per group.
- `RANK()` — ties get same rank, next rank skips (1,1,3).
- `DENSE_RANK()` — ties get same rank, no skip (1,1,2). Use for "Nth distinct value."

**Signal: "Nth highest/lowest" without LIMIT/OFFSET** → Same as above — `DENSE_RANK()` + filter `WHERE rnk = N`. LIMIT/OFFSET can't be scoped per group; ranking can.

**Signal: "running total" / "cumulative" / "balance over time"** → Window aggregate with `ORDER BY` inside `OVER()`: `SUM(...) OVER (PARTITION BY ... ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`.

**Signal: "compare to previous/next row" / "month-over-month" / "day-over-day"** → `LAG()` / `LEAD()`. Wrap any division by the lagged value in `NULLIF(x, 0)` to avoid divide-by-zero.

**Signal: "never" / "no matching records" / "products with zero orders"** → Anti-join: `LEFT JOIN ... WHERE right.key IS NULL`, or `NOT EXISTS (subquery)`. Prefer `NOT EXISTS` — handles NULLs safely and often optimizes better.

**Signal: "in every X" / "no gaps" / "all months/periods"** → `COUNT(DISTINCT unit)` compared against the known total count of units (e.g., `= 12` for months).

**Signal: "at least once" / "has at least one matching record"** → `EXISTS (subquery)` or a simple `JOIN` (if you don't need row multiplication, use `EXISTS`/`IN` over `JOIN` to avoid duplicate rows).

**Signal: condition on a raw/individual row value** → `WHERE`.

**Signal: condition on an aggregated value (SUM, AVG, COUNT of the group)** → `HAVING` (or, if the aggregate itself needs its own aggregate — e.g., comparing to a grand average — push it into a CTE and filter with `WHERE` outside).

**Signal: "average of an average" / "compare group aggregate to overall aggregate" / multi-level rollup** → Chain of CTEs, one grain-reduction step at a time. You can't nest aggregates directly in SQL (`AVG(SUM(x))` in one `GROUP BY` pass doesn't work).

**Signal: "relationship between two rows in the same table" (pairs, hierarchies, employee-manager)** → Self-join. Add an inequality (`a.id < b.id`) to avoid self-pairing and duplicate mirrored pairs.

**Signal: "products/customers with X but also Y" (two aggregate thresholds)** → Single `GROUP BY` with compound `HAVING` conditions — don't overcomplicate with multiple CTEs if one aggregation pass covers it.

**Signal: "percentage of total" / "share of category"** → Window function without partition-collapse: `value / SUM(value) OVER (PARTITION BY group)`.

**Signal: "pivot rows into columns" / "count per status as separate columns"** → Conditional aggregation: `SUM(CASE WHEN status = 'X' THEN 1 ELSE 0 END)`.

**Signal: "duplicate records" / "find and remove dupes"** → `ROW_NUMBER() OVER (PARTITION BY dedup_columns ORDER BY tiebreaker)`, then filter `rn > 1` (to find) or `rn = 1` (to keep one).

**Signal: recursive structure (org chart, category tree, bill of materials)** → `WITH RECURSIVE` CTE.

### Quick decision flow

1. Does it involve comparing a row to _other rows in the same group_ (rank, running total, prev/next)? → **Window function**.
2. Does it involve _presence/absence_ of a match in another table? → **JOIN+IS NULL / EXISTS / NOT EXISTS**.
3. Does it need aggregation on top of aggregation? → **CTE chain**.
4. Is it a straight group-and-filter? → **GROUP BY + HAVING**.
5. Is it comparing rows within the same table to each other? → **Self-join**.

Want me to give you a fresh batch of 5-10 questions now, unlabeled, so you can practice identifying which pattern applies before I show the solution?