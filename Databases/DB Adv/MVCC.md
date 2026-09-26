# MVCC (Multi-Version Concurrency Control) — Expanded

## The Core Idea

Instead of locking rows for reads, MVCC keeps **multiple versions of the same row** in the database. Each transaction sees a **snapshot** of the data as it existed at some point in time — so readers never block writers, and writers never block readers.

> "Don't lock the data — just show everyone the version they're supposed to see."

---

## Why It Exists

With traditional locking, if T1 is reading a row, T2 has to wait to write it (and vice versa). At scale, that kills throughput. MVCC solves this by never overwriting data in place — updates create a **new version** instead of destroying the old one.

---

## How It Actually Works (conceptually)

Every row gets extra hidden metadata — typically:

- `xmin` → the transaction ID that **created** this row version
- `xmax` → the transaction ID that **deleted/updated** this row version (marking it obsolete)

When you `UPDATE`, the database doesn't modify the row in place. It:

1. Marks the old row version as "expired" (sets `xmax`)
2. Inserts a **new row version** with the updated data (sets `xmin`)

### Example (PostgreSQL-style)

```
Row: id=1, balance=100, xmin=50, xmax=NULL      <- created by T50

T60 starts, reads balance → sees 100 (T50 committed before T60 started)

T60: UPDATE balance = 150

Now two versions exist:
Row v1: id=1, balance=100, xmin=50, xmax=60   <- old version, now "dead" to future txns
Row v2: id=1, balance=150, xmin=60, xmax=NULL <- new version
```

Any transaction that started **before** T60 committed still sees `balance=100` (v1). Any transaction starting **after** sees `balance=150` (v2). Nobody was blocked.

---

## Snapshot Isolation

Each transaction gets a **snapshot** — a consistent view of "which transaction IDs were already committed when I started." A row version is visible to your transaction only if:

- It was created by a transaction that committed before your snapshot, **and**
- It wasn't deleted/expired by a transaction that committed before your snapshot

This is what gives you **Repeatable Read** almost for free — you keep seeing the same snapshot throughout your transaction, no matter what others commit in the meantime.

---

## Reads vs Writes: The Big Win

||Traditional Locking|MVCC|
|---|---|---|
|Reader blocks Writer?|Yes|**No**|
|Writer blocks Reader?|Yes|**No**|
|Writer blocks Writer?|Yes|Yes (still need coordination on the _same_ row)|

Only **write-write** conflicts still need handling (two transactions trying to update the same row) — MVCC doesn't magically remove that; it just frees up read concurrency, which is the majority of traffic in most apps.

---

## Write-Write Conflicts Under MVCC

If T1 and T2 both try to update the same row concurrently:

- **PostgreSQL**: the second writer either **waits** for the first to commit/rollback, then re-checks, or throws a **serialization failure** (`could not serialize access due to concurrent update`) depending on isolation level — the app must retry.
- **MySQL InnoDB**: similar — detects the conflict and can raise a deadlock/serialization error.

So MVCC doesn't eliminate the **Lost Update** problem discussed earlier — you still need explicit locking (`SELECT FOR UPDATE`) or optimistic version checks for read-modify-write logic. MVCC only protects plain reads from being blocked or seeing dirty/inconsistent data.

---

## Garbage Collection: Dead Row Versions

Since old versions aren't deleted immediately (other transactions might still need them), they pile up as **dead tuples**.

- **PostgreSQL**: cleans these up via `VACUUM` (autovacuum runs periodically). If vacuuming falls behind, you get "table bloat."
- **MySQL InnoDB**: uses a rollback segment/undo log for old versions, purged by a background purge thread.

This is a real operational concern — heavy-update tables need vacuum tuning, or performance degrades over time.

---

## MVCC in Postgres vs MySQL (quick contrast)

||PostgreSQL|MySQL (InnoDB)|
|---|---|---|
|Old versions stored|In the table itself (extra row versions)|In a separate **undo log**|
|Cleanup mechanism|VACUUM|Purge thread|
|Default isolation|Read Committed|Repeatable Read|

---

## Quick Mental Model

Think of MVCC like **Git**:

- Every `UPDATE` = a new commit (new version), old version isn't deleted, just no longer the "HEAD."
- Every transaction = checking out a specific commit (snapshot) and working from that view.
- `VACUUM` = garbage-collecting old commits nobody references anymore.

Want me to connect this specifically to SQLAlchemy/PostgreSQL patterns — like how `SELECT FOR UPDATE` interacts with MVCC, or how to implement optimistic locking with a `version` column in your FastAPI stack?