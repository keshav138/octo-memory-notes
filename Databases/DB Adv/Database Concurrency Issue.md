# Database Concurrency Issues — Notes

When multiple transactions run at the same time on shared data, things can go wrong if the database doesn't coordinate them properly. Here are the classic problems:

---

## 1. Lost Update

Two transactions read the same data, both modify it, and one update **overwrites** the other — silently.

**Example:**

```
Initial balance = 100

T1: reads balance (100)
T2: reads balance (100)
T1: adds 50 → writes 150
T2: adds 30 → writes 130   ❌ (overwrites T1's update)

Final balance = 130  (should've been 180)
```

T1's `+50` is completely lost.

**Real-world case:** Two people editing the same wallet balance or inventory count at the same time.

---

## 2. Dirty Read

A transaction reads data that another transaction has changed **but not yet committed**. If that other transaction rolls back, you've read data that never actually existed.

**Example:**

```
T1: updates balance from 100 → 200 (not committed yet)
T2: reads balance → sees 200
T1: rolls back (balance goes back to 100)

T2 now has "200" — a value that never really existed
```

---

## 3. Non-Repeatable Read

A transaction reads the **same row twice** and gets **different values**, because another transaction updated and committed it in between.

**Example:**

```
T1: reads balance → 100
T2: updates balance to 150 and commits
T1: reads balance again → 150   ❌ (different from first read, same transaction)
```

The data changed "under T1's feet" mid-transaction.

---

## 4. Phantom Read

A transaction re-runs the **same query** and gets a **different set of rows** — because another transaction inserted or deleted rows matching that query in between.

**Example:**

```
T1: SELECT * FROM orders WHERE amount > 1000   → 5 rows
T2: inserts a new order with amount = 2000, commits
T1: runs same query again → 6 rows   ❌ (a "phantom" row appeared)
```

Difference from non-repeatable read: that's about a **row's value** changing; phantom read is about the **row count/set** changing.

---

## 5. Deadlock

Two (or more) transactions each hold a lock the other needs — both wait forever.

**Example:**

```
T1: locks Row A, wants Row B
T2: locks Row B, wants Row A

T1 waits for T2 → T2 waits for T1 → stuck forever
```

Databases usually detect this and kill one transaction (the "victim") to break the cycle.

---

## How These Are Solved: Isolation Levels

Databases let you choose how strict concurrency control should be (trade-off: strictness ↓ performance):

|Isolation Level|Dirty Read|Non-Repeatable Read|Phantom Read|
|---|:-:|:-:|:-:|
|Read Uncommitted|❌ Possible|❌ Possible|❌ Possible|
|Read Committed|✅ Prevented|❌ Possible|❌ Possible|
|Repeatable Read|✅ Prevented|✅ Prevented|❌ Possible|
|Serializable|✅ Prevented|✅ Prevented|✅ Prevented|

- **Read Uncommitted** — no protection at all, fastest.
- **Read Committed** — you only ever read committed data (most databases default here, e.g., PostgreSQL).
- **Repeatable Read** — a value you read once stays the same for the rest of your transaction (MySQL InnoDB default).
- **Serializable** — strictest; transactions behave as if run one after another. Slowest, but no anomalies at all.

---

## Common Fixes in Practice

- **Locking** (pessimistic): lock the row before updating (`SELECT ... FOR UPDATE`) — prevents lost updates but can cause deadlocks/waiting.
- **Optimistic concurrency control**: add a `version` column; on update, check version hasn't changed since you read it — if it has, retry.
    
    ```sql
    UPDATE accounts SET balance = 150, version = version + 1WHERE id = 1 AND version = 3;
    ```
    
- **MVCC (Multi-Version Concurrency Control)**: used by PostgreSQL, MySQL — each transaction sees a consistent "snapshot" of data, so readers don't block writers.

---

Want me to add a short section on how this connects to your FastAPI/PostgreSQL stack specifically — e.g., using `SELECT FOR UPDATE` or optimistic locking with SQLAlchemy?