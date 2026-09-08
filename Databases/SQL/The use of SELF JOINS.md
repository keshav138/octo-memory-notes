Let's build it up with tiny sample data so the mechanics are visible.

## The data

Say `order_items` has this (simplified — just order_id and product_id):

|order_item_id|order_id|product_id|
|---|---|---|
|1|101|A|
|2|101|B|
|3|101|C|
|4|102|A|
|5|102|B|
|6|103|B|
|7|103|C|

So: Order 101 has products A, B, C. Order 102 has A, B. Order 103 has B, C.

## Why a self-join?

The question is really: _"for every order, which pairs of products showed up together in it?"_ That means comparing rows **within the same order_id** to each other — row-to-row comparison inside a group. A normal join needs two different tables; here we need to compare `order_items` against itself, so we alias it twice: `a` and `b`, both pointing at the same table.

## Step 1: join the table to itself on order_id

```sql
SELECT a.order_id, a.product_id AS product_a, b.product_id AS product_b
FROM order_items a
JOIN order_items b ON a.order_id = b.order_id;
```

This says: "for every row `a`, find every row `b` that shares the same order_id" — that includes pairing a row with itself, and pairing it both ways. For order 101 (A, B, C) this produces **all combinations**, including junk:

|order_id|product_a|product_b|
|---|---|---|
|101|A|A|
|101|A|B|
|101|A|C|
|101|B|A|
|101|B|B|
|101|B|C|
|101|C|A|
|101|C|B|
|101|C|C|

9 rows for 3 products — that's 3×3, because every row is joining to every row including itself. That's the raw self-join before cleanup.

## Step 2: fix it with `a.product_id < b.product_id`

```sql
SELECT a.order_id, a.product_id AS product_a, b.product_id AS product_b
FROM order_items a
JOIN order_items b ON a.order_id = b.order_id AND a.product_id < b.product_id;
```

The `<` condition does two jobs at once:

- **Removes self-pairs** (A,A / B,B / C,C) — a value can never be less than itself.
- **Removes mirror duplicates** — of (A,B) and (B,A), only (A,B) satisfies `A < B`, so (B,A) is dropped. You keep exactly one direction per pair.

Now order 101 gives you just:

|order_id|product_a|product_b|
|---|---|---|
|101|A|B|
|101|A|C|
|101|B|C|

Clean — 3 unique pairs, which is correct (3 products → C(3,2) = 3 pairs).

## Step 3: do this across all orders, then count

Repeating for orders 102 (A,B) and 103 (B,C):

|order_id|product_a|product_b|
|---|---|---|
|101|A|B|
|101|A|C|
|101|B|C|
|102|A|B|
|103|B|C|

Now `GROUP BY product_a, product_b` and count:

```sql
SELECT a.product_id AS product_a, b.product_id AS product_b, COUNT(*) AS times_together
FROM order_items a
JOIN order_items b ON a.order_id = b.order_id AND a.product_id < b.product_id
GROUP BY a.product_id, b.product_id
ORDER BY times_together DESC;
```

Result:

|product_a|product_b|times_together|
|---|---|---|
|B|C|2|
|A|B|2|
|A|C|1|

That matches the raw data: (A,B) appears in orders 101 and 102 → 2 times. (B,C) appears in orders 101 and 103 → 2 times. (A,C) appears only in order 101 → 1 time.

## The mental model to keep

Self-join = "match each row to its siblings in the same group (here, same order_id), then use an inequality to kill self-matches and duplicate mirrors." Whenever you see **"pairs / combinations / relationships between rows in the same table"**, that `a.key < b.key` trick is the standard move.