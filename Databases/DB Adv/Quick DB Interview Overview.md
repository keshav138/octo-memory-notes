This is an excellent topic for backend interviews. Below are **structured notes** covering the mandatory database knowledge you’ll need. I’ve included SQL vs. NoSQL, tradeoffs, scenarios, schema design, indexing, and normalization.

---

## 1. Core Database Concepts (Must-Know)

- **ACID** (Atomicity, Consistency, Isolation, Durability) – for SQL/relational DBs.
- **BASE** (Basically Available, Soft state, Eventual consistency) – for many NoSQL DBs.
- **CAP Theorem** (Consistency, Availability, Partition tolerance) – you can have only two.
- **Transactions** – unit of work; SQL uses multi-row/table transactions, NoSQL varies.
- **Scaling** – Vertical (more power) vs. Horizontal (more machines).

---

## 2. SQL vs. NoSQL – Differences & Tradeoffs

| Feature | SQL (Relational) | NoSQL (Non-relational) |
|--------|----------------|------------------------|
| **Schema** | Fixed, predefined | Dynamic, schema-less or flexible |
| **Data model** | Tables with rows & columns | Document, key-value, column-family, graph |
| **Relationships** | Foreign keys, joins | Embedded docs or references (no joins typically) |
| **Scalability** | Vertical (or complex horizontal sharding) | Horizontal (native sharding) |
| **ACID** | Strong ACID across multiple tables | Often BASE, some offer ACID per document |
| **Query language** | SQL (standardized) | API-specific (e.g., MongoDB query language) |
| **Use case** | Complex queries, multi-row transactions | High volume, rapid iteration, varied data shapes |

### Tradeoffs Summary

- **SQL** – Better consistency, complex joins, but harder to scale horizontally.
- **NoSQL** – Better scalability & speed for simple patterns, but weaker consistency and no complex joins.

### When to use which? (Scenario-based)

| Scenario | Choose | Why |
|----------|--------|-----|
| E-commerce orders & inventory with strict consistency | SQL | ACID transactions across payments, stock, user accounts |
| Real-time leaderboard for a game | Redis (NoSQL) | Key-value, super fast, TTL, sorted sets |
| Blog platform with comments & users | SQL | Clear relationships, need joins, reporting queries |
| Chat messages / logs (write-heavy) | NoSQL (Cassandra, MongoDB) | High write throughput, easy horizontal scaling |
| Product catalog with varying attributes (different for each category) | NoSQL (MongoDB) | Flexible schema, embedded specs |
| Social network user profiles + posts | Both possible; Graph DB (Neo4j) for recommendations | SQL works, but graph DBs excel for relationship traversals |
| Financial ledger | SQL | Immutable transactions, ACID, auditing |

---

## 3. Schema Design – SQL vs. NoSQL

### SQL Schema Design

- **Normalization** (see section 5) reduces redundancy.
- **Denormalization** (e.g., for reporting) adds redundancy for read speed.
- Use **foreign keys** to enforce referential integrity.
- Design for **joins** – but beware of too many joins slowing queries.

**Example** – Users & Orders (normalized):
```sql
Users (id, name, email)
Orders (id, user_id, total, created_at)
OrderItems (id, order_id, product_name, quantity)
```

### NoSQL Schema Design

- **Embed** related data that is always accessed together.
- **Reference** data that is large or independent.
- **Duplication** is acceptable (denormalization by design).

**Example** – MongoDB (embedding):
```json
{
  "_id": "user123",
  "name": "Alice",
  "orders": [
    { "order_id": "ord1", "total": 100, "items": [{"product": "laptop", "qty": 1}] }
  ]
}
```
**Tradeoff**: Embedding avoids joins but can lead to document growth and duplication.

---

## 4. Indexing (Critical for Performance)

### What is an index?
A data structure (usually B-tree or hash) that speeds up `WHERE`, `JOIN`, `ORDER BY`, `GROUP BY`.

### Types of indexes
- **Primary / Clustered** – data stored in index order (one per table).
- **Secondary / Non-clustered** – separate structure pointing to rows.
- **Composite** – multiple columns (e.g., `(last_name, first_name)`).
- **Unique** – prevents duplicate values.
- **Full-text** – for text search.
- **Partial / Filtered** – only index a subset (e.g., `WHERE active = true`).

### Tradeoffs
| Pros | Cons |
|------|------|
| Faster reads (especially large tables) | Slower writes (INSERT/UPDATE/DELETE) |
| Enforces uniqueness | Uses disk/memory space |
| Helps sorting & grouping | Over-indexing harms performance |

### Interview scenario
**Q:** You have a `users` table with 10M rows. Query: `SELECT * FROM users WHERE last_name = 'Smith' ORDER BY created_at`.  
**A:** Create composite index `(last_name, created_at)` to cover both filter & sort. Avoid `SELECT *` if possible; use covering index.

### Indexing in NoSQL
- MongoDB – create indexes on frequently queried fields.
- Cassandra – indexing works differently; secondary indexes are tricky (partition keys first).
- Redis – all keys are indexed by design (hash lookup).

---

## 5. Normalization (SQL Focus)

### Purpose
Eliminate redundancy & anomalies (insert, update, delete anomalies).

### Normal Forms (simplified)

| Form | Rule | Example issue |
|------|------|---------------|
| **1NF** | Atomic values, no repeating groups | One cell can't have "apple, banana" |
| **2NF** | No partial dependency on composite key | If key is (order_id, product_id), `product_name` depends only on `product_id` → bad |
| **3NF** | No transitive dependency | `zip_code → city`; city depends on zip, not directly on PK |

### Tradeoffs: Normalized vs. Denormalized

| Normalized | Denormalized |
|------------|--------------|
| Less storage, less redundancy | More storage, redundant data |
| Slower reads (more joins) | Faster reads (no/little joins) |
| Faster writes (single place to update) | Slower writes (multiple places to update) |
| Complex queries | Simpler queries |

### When to denormalize?
- Reporting / analytics (OLAP)
	OLTP (Online Transaction Processing) manages real-time, day-to-day operational data (e.g., banking transactions, e-commerce orders) with fast, write-heavy operations. OLAP (Online Analytical Processing) analyzes large-scale historical data for business insights (e.g., trend analysis, sales reporting) using complex, read-heavy queries
- High-read, low-write systems
- Caching (Redis as a denormalized view)

---

## 6. Scenario-Based Interview Questions (Practice)

### Scenario 1 – Ride-hailing app (Uber)
**Requirement**: Store trips, drivers, riders, payments, locations. Need ACID for payments, high read/write for live location tracking.  
**Answer**:
- Use **SQL** for user accounts, payments, trip history (relational, ACID).
- Use **NoSQL (Redis)** for driver live location (key-value, TTL, fast updates).
- Use **TimescaleDB (SQL extension)** or **Cassandra** for time-series trip stats.

### Scenario 2 – Analytics dashboard with millions of events/day
**Answer**:
- **NoSQL (Cassandra or ClickHouse)** – write-optimized, columnar storage for aggregations.
- Or **Elasticsearch** if you need search + aggregation.
- Avoid standard SQL for raw event ingestion (write bottleneck).

### Scenario 3 – Social media feed
**Answer**:
- **NoSQL (Cassandra)** for storing posts by user ID (wide rows).
- **Redis** for feed ranking & caching.
- **SQL** for user profiles & auth.
- **Graph DB** for "people you may know."

---

## 7. Quick Cheat Sheet for Interviews

| If asked about... | Say... |
|------------------|--------|
| Consistency | SQL gives strong consistency; NoSQL often eventual |
| Scalability | NoSQL scales horizontally easily; SQL needs sharding or read replicas |
| Joins | SQL supports them; avoid in NoSQL (design around it) |
| Indexing | Speeds reads, slows writes; use composite indexes carefully |
| Normalization | Reduces redundancy but increases joins; denormalize for read-heavy |
| When to use NoSQL | High volume, flexible schema, simple queries, horizontal scaling |
| When to use SQL | Complex queries, multi-row transactions, strong integrity |

---
