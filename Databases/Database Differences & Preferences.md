## 1. The Big Picture — Database Categories

```
Databases
├── Relational (SQL)
│   ├── PostgreSQL
│   ├── MySQL
│   ├── SQLite
│   └── MS SQL Server / Oracle
│
├── Document
│   ├── MongoDB
│   └── CouchDB / Firestore
│
├── Key-Value
│   ├── Redis
│   ├── DynamoDB (also document)
│   └── Memcached
│
├── Wide-Column
│   ├── Cassandra
│   └── HBase / Bigtable
│
├── Graph
│   ├── Neo4j
│   └── Amazon Neptune
│
├── Time-Series
│   ├── InfluxDB
│   └── TimescaleDB
│
└── Search Engines
    ├── Elasticsearch
    └── OpenSearch
```

---

## 2. The Core Trade-off — CAP Theorem

Every distributed database can only guarantee **2 of 3**:

|Property|Meaning|
|---|---|
|**C**onsistency|Every read returns the most recent write|
|**A**vailability|Every request gets a response (no timeout)|
|**P**artition Tolerance|System works even if network splits|

> Partition tolerance is non-negotiable in real distributed systems (networks fail). So the real choice is **CP vs AP**.

|Database|CAP Choice|Meaning|
|---|---|---|
|PostgreSQL|CP|Consistent, may be unavailable during partition|
|MongoDB|CP (default) / AP (tunable)|Tunable via write concern|
|Cassandra|AP|Always available, eventually consistent|
|Redis|CP|Consistent primary; replicas may lag|
|DynamoDB|AP (default)|Eventually consistent; strongly consistent optional|

---

## 3. ACID vs BASE

### ACID (Relational DBs)

|Property|Meaning|
|---|---|
|**A**tomicity|All or nothing — transaction either fully completes or fully rolls back|
|**C**onsistency|Data always moves from one valid state to another|
|**I**solation|Concurrent transactions don't interfere with each other|
|**D**urability|Committed data survives crashes (written to disk)|

### BASE (NoSQL DBs)

|Property|Meaning|
|---|---|
|**B**asically Available|System always responds, may return stale data|
|**S**oft State|State may change over time (even without input)|
|**E**ventually Consistent|Data will become consistent across nodes... eventually|

> **Interview answer:** "ACID prioritizes correctness. BASE prioritizes availability and scale. Banks use ACID. Social media feeds can tolerate BASE."

---

## 4. SQL Databases

### 4.1 Core SQL Concepts

#### Indexes

Speed up reads by creating a separate data structure (B-Tree by default).

```sql
-- Single column index
CREATE INDEX idx_users_email ON users(email);

-- Composite index (order matters!)
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
-- ✅ Helps: WHERE user_id = 1 AND status = 'paid'
-- ✅ Helps: WHERE user_id = 1
-- ❌ Doesn't help: WHERE status = 'paid' alone (leftmost prefix rule)

-- Unique index (also enforces constraint)
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);
```

**When NOT to index:**

- Small tables (full scan is faster)
- Columns with low cardinality (e.g., boolean, status with 2-3 values)
- Write-heavy tables (indexes slow down INSERT/UPDATE/DELETE)

#### Joins

```sql
-- INNER JOIN — only matching rows from both tables
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- LEFT JOIN — all rows from left + matching from right (NULL if no match)
SELECT u.name, o.total
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;
-- Returns users even if they have no orders

-- RIGHT JOIN — opposite of LEFT
-- FULL OUTER JOIN — all rows from both, NULLs where no match
```

#### Transactions

```sql
BEGIN;

UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;

-- If anything fails:
ROLLBACK;

-- If everything succeeds:
COMMIT;
```

#### Isolation Levels (important!)

|Level|Dirty Read|Non-Repeatable Read|Phantom Read|
|---|---|---|---|
|READ UNCOMMITTED|✅ possible|✅ possible|✅ possible|
|READ COMMITTED|❌ prevented|✅ possible|✅ possible|
|REPEATABLE READ|❌ prevented|❌ prevented|✅ possible|
|SERIALIZABLE|❌ prevented|❌ prevented|❌ prevented|

- **Dirty read**: Reading uncommitted data from another transaction
- **Non-repeatable read**: Same query returns different results within a transaction
- **Phantom read**: New rows appear between two reads in the same transaction

> PostgreSQL default: **READ COMMITTED**. MySQL InnoDB default: **REPEATABLE READ**.

#### Normalization (1NF → 3NF)

|Form|Rule|
|---|---|
|**1NF**|No repeating groups; each cell has atomic (single) value|
|**2NF**|1NF + no partial dependencies (non-key columns depend on full PK)|
|**3NF**|2NF + no transitive dependencies (non-key columns don't depend on other non-key columns)|

> **Denormalization**: Intentionally breaking normalization for read performance (e.g., storing user name in orders table to avoid JOIN).

---

### 4.2 PostgreSQL vs MySQL

|Feature|PostgreSQL|MySQL|
|---|---|---|
|**Type**|Object-relational|Relational|
|**ACID compliance**|Full|Full (InnoDB engine)|
|**JSON support**|✅ Excellent (JSONB — binary, indexable)|✅ Good (JSON type, less powerful)|
|**Full-text search**|✅ Built-in|✅ Basic|
|**Advanced data types**|Arrays, hstore, UUID, range types, enums|Limited|
|**Window functions**|✅ Full support|✅ MySQL 8+|
|**CTEs (WITH clause)**|✅ Recursive CTEs|✅ MySQL 8+|
|**Replication**|Logical + streaming|Master-slave, Group Replication|
|**Performance (reads)**|Slightly slower out of box|Faster simple reads|
|**Performance (complex queries)**|Better query planner|Weaker on complex|
|**Concurrency**|MVCC (no read locks)|MVCC (InnoDB)|
|**Community/extensions**|PostGIS, TimescaleDB, pg_vector|Limited ecosystem|
|**License**|PostgreSQL (fully open)|GPL (Oracle-owned)|

#### When to use PostgreSQL

- Complex queries, reporting, analytics
- Need JSON storage + querying (JSONB)
- Geospatial data (PostGIS)
- Financial data requiring strict ACID
- Open source projects (no Oracle dependency)

#### When to use MySQL

- Simple read-heavy web apps
- WordPress / legacy PHP apps
- When raw read speed > advanced features
- Large existing MySQL ecosystem in team

> **Honest answer:** For new projects, default to PostgreSQL. It does everything MySQL does + more.

---

### 4.3 PostgreSQL — Must-Know Features

#### JSONB

```sql
-- Store JSON as binary (indexable, faster queries)
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    metadata JSONB
);

INSERT INTO products (metadata)
VALUES ('{"brand": "Nike", "tags": ["shoe", "sport"], "price": 99.99}');

-- Query inside JSON
SELECT * FROM products WHERE metadata->>'brand' = 'Nike';
SELECT * FROM products WHERE metadata->'price' > '50';

-- Index on JSON field
CREATE INDEX idx_products_brand ON products((metadata->>'brand'));
```

#### Window Functions

```sql
-- Rank users by order total within each region
SELECT
    name,
    region,
    total_orders,
    RANK() OVER (PARTITION BY region ORDER BY total_orders DESC) as rank
FROM users;

-- Running total
SELECT
    order_date,
    amount,
    SUM(amount) OVER (ORDER BY order_date) as running_total
FROM orders;
```

#### Common Table Expressions (CTEs)

```sql
-- Cleaner than subqueries
WITH top_users AS (
    SELECT user_id, COUNT(*) as order_count
    FROM orders
    GROUP BY user_id
    HAVING COUNT(*) > 10
)
SELECT u.name, t.order_count
FROM users u
JOIN top_users t ON u.id = t.user_id;
```

#### EXPLAIN ANALYZE — Query Optimization

```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 42;
-- Shows: query plan, actual execution time, rows scanned
-- Look for: "Seq Scan" (bad on large tables) vs "Index Scan" (good)
```

---

## 5. NoSQL Databases

### 5.1 When to Use NoSQL (generally)

- Schema is flexible / evolving
- Horizontal scaling is a must (sharding)
- Data doesn't fit naturally into tables (documents, graphs, time-series)
- Eventual consistency is acceptable
- Very high write throughput needed

---

### 5.2 MongoDB (Document Store)

Stores data as **BSON documents** (binary JSON). No fixed schema.

#### Data Model

```javascript
// Instead of users + orders tables with FK, embed related data
{
  "_id": ObjectId("..."),
  "name": "Keshav",
  "email": "k@test.com",
  "address": {
    "city": "Darjeeling",
    "state": "WB"
  },
  "orders": [           // embedded array — good for "owned" data
    { "product": "Laptop", "total": 80000, "date": "2024-01-15" }
  ],
  "tags": ["premium", "verified"]
}
```

#### Embed vs Reference

|Strategy|When to use|Example|
|---|---|---|
|**Embed**|Data is owned by parent, queried together, small, bounded|User → Address, Blog → Comments|
|**Reference** (like FK)|Data is shared, large, queried independently|Order → Product (product exists independently)|

```javascript
// Reference pattern
{
  "_id": ObjectId("order1"),
  "user_id": ObjectId("user42"),   // reference
  "product_id": ObjectId("prod5"), // reference
  "quantity": 2
}
```

#### Core Queries

```javascript
// Insert
db.users.insertOne({ name: "Keshav", email: "k@test.com" })
db.users.insertMany([{...}, {...}])

// Find
db.users.find({ city: "Darjeeling" })
db.users.findOne({ email: "k@test.com" })
db.users.find({ age: { $gt: 18, $lt: 30 } })
db.users.find({ tags: { $in: ["premium", "vip"] } })
db.users.find({ "address.city": "Darjeeling" })  // nested field

// Update
db.users.updateOne({ _id: id }, { $set: { name: "New Name" } })
db.users.updateMany({ is_active: false }, { $set: { deleted: true } })
db.users.updateOne({ _id: id }, { $push: { tags: "verified" } })  // add to array

// Delete
db.users.deleteOne({ _id: id })

// Sort, Limit, Skip
db.orders.find().sort({ total: -1 }).limit(10).skip(20)
```

#### Aggregation Pipeline

```javascript
db.orders.aggregate([
  { $match: { status: "paid" } },           // filter
  { $group: {
      _id: "$user_id",
      total_spent: { $sum: "$amount" },
      order_count: { $sum: 1 }
  }},
  { $sort: { total_spent: -1 } },           // sort
  { $limit: 10 },                           // top 10
  { $lookup: {                              // JOIN with users collection
      from: "users",
      localField: "_id",
      foreignField: "_id",
      as: "user_info"
  }}
])
```

#### Indexes in MongoDB

```javascript
db.users.createIndex({ email: 1 })                    // ascending
db.users.createIndex({ email: 1 }, { unique: true })  // unique
db.users.createIndex({ name: "text" })                // full-text search
db.users.createIndex({ location: "2dsphere" })        // geospatial
db.users.createIndex({ user_id: 1, status: 1 })       // compound
```

#### Transactions in MongoDB (4.0+)

```javascript
const session = client.startSession();
session.startTransaction();
try {
    await orders.insertOne({ ... }, { session });
    await inventory.updateOne({ ... }, { $inc: { stock: -1 } }, { session });
    await session.commitTransaction();
} catch (e) {
    await session.abortTransaction();
}
```

> **Caveat:** MongoDB transactions work best within a single replica set. Cross-shard transactions are expensive.

---

### 5.3 MongoDB vs Other Document DBs

|Feature|MongoDB|Firestore (Google)|CouchDB|
|---|---|---|---|
|Hosting|Self-host / Atlas|GCP only|Self-host / CouchDB Cloud|
|Query power|Excellent (aggregation pipeline)|Limited|Limited (MapReduce)|
|Offline sync|No|✅ Yes (mobile)|✅ Yes|
|Real-time updates|Change streams|✅ Native listeners|✅ via _changes feed|
|Scale|Manual sharding or Atlas|Auto (serverless)|Auto|
|Best for|General backend, complex queries|Mobile apps, Firebase ecosystem|Offline-first apps|

---

### 5.4 Cassandra (Wide-Column Store)

Designed for **massive write throughput** and **high availability** with no single point of failure.

#### Key Concepts

- Data stored in rows with dynamic columns (column families)
- Distributed across nodes in a ring — no master
- CAP: **AP** — always available, eventually consistent
- Write path: writes go to commit log + memtable → flushed to SSTable on disk
- No JOINs. No aggregations. Design queries first, schema second.

#### Data Modeling — Query-Driven Design

```sql
-- In Cassandra, you design tables FOR your queries
-- Not the other way around like in SQL

-- Query: "Get all orders for a user, sorted by date"
CREATE TABLE orders_by_user (
    user_id UUID,
    order_date TIMESTAMP,
    order_id UUID,
    total DECIMAL,
    PRIMARY KEY (user_id, order_date)  -- user_id = partition key, order_date = clustering key
) WITH CLUSTERING ORDER BY (order_date DESC);

-- Partition key → determines which node stores the data
-- Clustering key → determines sort order within a partition
```

#### Cassandra vs MongoDB

|Feature|Cassandra|MongoDB|
|---|---|---|
|CAP|AP (always available)|CP (consistent)|
|Write speed|Extremely high|High|
|Query flexibility|Very limited (no JOINs, no ad-hoc)|Excellent|
|Schema design|Query-driven (rigid)|Flexible|
|Consistency|Eventual (tunable)|Strong (default)|
|Scale model|Linear horizontal scale|Sharding (complex)|
|Best for|Time-series, IoT, logs, high-write|General apps, e-commerce, CMS|
|Bad for|Ad-hoc queries, analytics|Massive write throughput|

> **When to pick Cassandra:** Netflix uses it for viewing history. IoT sensor data. Log aggregation. Anything with millions of writes/sec and read patterns you know in advance.

---

## 6. Redis (Key-Value + More)

Redis is an **in-memory** data structure store. Used as cache, message broker, session store, and real-time leaderboard.

### Data Types

|Type|Commands|Use case|
|---|---|---|
|**String**|GET, SET, INCR, EXPIRE|Cache, counters, session tokens|
|**Hash**|HGET, HSET, HGETALL|User profiles, config objects|
|**List**|LPUSH, RPUSH, LRANGE, LPOP|Queues, recent activity|
|**Set**|SADD, SMEMBERS, SISMEMBER, SINTER|Unique tags, follower lists|
|**Sorted Set**|ZADD, ZRANGE, ZRANK|Leaderboards, priority queues|
|**Pub/Sub**|PUBLISH, SUBSCRIBE|Real-time messaging|
|**Stream**|XADD, XREAD|Event logs, message queues (Kafka-lite)|

```python
import redis
r = redis.Redis()

# String — cache with TTL
r.setex("user:42", 300, json.dumps(user_data))   # expires in 300s
r.get("user:42")

# Hash — partial updates without re-serializing
r.hset("user:42", mapping={"name": "Keshav", "email": "k@test.com"})
r.hget("user:42", "name")
r.hgetall("user:42")

# Sorted Set — leaderboard
r.zadd("leaderboard", {"player1": 1500, "player2": 2300})
r.zrange("leaderboard", 0, 9, withscores=True, rev=True)  # top 10
r.zrank("leaderboard", "player1")                          # rank of player

# Counter — atomic increment (no race condition)
r.incr("page_views:home")
r.incrby("user:42:credits", 100)
```

### Redis Persistence Options

|Mode|How|Durability|Performance|
|---|---|---|---|
|**No persistence**|Pure in-memory|None (data lost on restart)|Fastest|
|**RDB (snapshot)**|Dump to disk every N seconds/changes|Some loss|Fast|
|**AOF (append-only file)**|Log every write command|Near-zero loss|Slower|
|**RDB + AOF**|Both|Best|Moderate|

### Redis vs Memcached

|Feature|Redis|Memcached|
|---|---|---|
|Data types|Rich (string, hash, list, set, sorted set)|String only|
|Persistence|✅ RDB + AOF|❌ None|
|Pub/Sub|✅ Yes|❌ No|
|Clustering|✅ Redis Cluster|✅ Yes|
|Lua scripting|✅ Yes|❌ No|
|Memory efficiency|Slightly more overhead|Slightly leaner|
|Best for|Cache + more (queues, leaderboards, sessions)|Pure simple cache|

> **Default choice:** Redis. Memcached only makes sense if you're purely caching strings and need max simplicity.

### Redis as Message Queue vs Kafka

|Feature|Redis (Streams/Pub-Sub)|Kafka|
|---|---|---|
|Throughput|High|Extremely high|
|Persistence|Optional|Always (log-based)|
|Consumer groups|✅ Streams|✅ Yes|
|Message replay|✅ Streams (limited)|✅ Full (configurable retention)|
|Ordering|Per-stream|Per-partition|
|Scale|Single node / cluster|Distributed by design|
|Best for|App-level queues, real-time events|High-volume event pipelines, audit logs|

---

## 7. The Big Comparison — Which DB for What?

### Scenario-Based Decision Guide

|Scenario|Best Choice|Why|
|---|---|---|
|User accounts, orders, payments|**PostgreSQL**|ACID, relations, complex queries|
|Product catalog with variable attributes|**MongoDB**|Flexible schema per product type|
|Session storage|**Redis**|In-memory, fast TTL|
|Real-time leaderboard|**Redis (Sorted Set)**|O(log n) rank operations|
|IoT sensor data, 1M writes/sec|**Cassandra**|Linear scale, high write throughput|
|Full-text search on products|**Elasticsearch**|Inverted index, relevance scoring|
|Social graph (who follows whom)|**Neo4j**|Graph traversal is native|
|Financial transactions|**PostgreSQL**|ACID, strict consistency|
|ML feature store|**Redis**|Low-latency feature retrieval|
|Analytics / data warehouse|**PostgreSQL + TimescaleDB** or **BigQuery**|Columnar, window functions|
|Multi-tenant SaaS|**PostgreSQL**|Row-level security, schemas per tenant|

### SQL vs NoSQL Decision Tree

```
Does data have clear relationships and fixed schema?
    → YES → SQL (PostgreSQL)

Is schema unknown/evolving OR data is document-like?
    → YES → MongoDB

Is the primary use case caching / sessions / counters?
    → YES → Redis

Is write volume extreme (millions/sec) with known query patterns?
    → YES → Cassandra

Is data a time-series (metrics, logs, events)?
    → YES → InfluxDB / TimescaleDB

Is data highly connected (social graph, recommendations)?
    → YES → Neo4j
```

---

## 8. Database Scaling Patterns

### Vertical Scaling (Scale Up)

Add more RAM/CPU to existing server. Simple but has limits and single point of failure.

### Horizontal Scaling (Scale Out)

#### Replication

One **primary** (handles writes) → multiple **replicas** (handle reads).

```
Client writes → Primary DB
                    ↓ async replication
              Replica 1 (read)
              Replica 2 (read)
              Replica 3 (read)
```

- **Pros:** Read scaling, failover, backup
- **Cons:** Replication lag (eventual consistency for reads)

#### Sharding (Partitioning)

Split data across multiple DB instances by a **shard key**.

```
Users 1-1M    → Shard 1
Users 1M-2M   → Shard 2
Users 2M-3M   → Shard 3
```

**Sharding strategies:**

|Strategy|How|Pros|Cons|
|---|---|---|---|
|**Range**|Shard by value range|Simple|Hot spots (new users all in last shard)|
|**Hash**|Hash(key) % N shards|Even distribution|Can't do range queries|
|**Directory**|Lookup table maps key → shard|Flexible|Lookup table is bottleneck|

> **MongoDB** supports automatic sharding. **PostgreSQL** needs Citus or app-level sharding.

#### Connection Pooling

DB connections are expensive. Pool reuses existing connections.

```python
# Django — configure in settings.py
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "CONN_MAX_AGE": 60,   # reuse connections for 60 seconds
    }
}

# FastAPI with SQLAlchemy
engine = create_engine(DATABASE_URL, pool_size=10, max_overflow=20)
```

---

## 9. Indexing Deep Dive

### Types of Indexes

|Type|Structure|Best for|
|---|---|---|
|**B-Tree** (default)|Balanced tree|Equality, range queries, sorting|
|**Hash**|Hash table|Equality only (=), faster than B-Tree for exact match|
|**GIN** (PostgreSQL)|Inverted index|Arrays, JSONB, full-text search|
|**GiST** (PostgreSQL)|Generalized search tree|Geospatial, range types|
|**Partial**|Index on subset of rows|`WHERE is_active = true`|
|**Composite**|Multiple columns|Multi-column WHERE / ORDER BY|
|**Covering**|Includes extra columns|Index-only scans (no heap access)|

```sql
-- Partial index — only index active users
CREATE INDEX idx_active_users ON users(email) WHERE is_active = true;

-- Covering index — include extra column to avoid table lookup
CREATE INDEX idx_orders_covering ON orders(user_id) INCLUDE (status, total);
```

### Index vs Full Table Scan

- Index is faster for **selective** queries (< ~5-10% of rows)
- Full scan is faster for **non-selective** queries (fetching most rows)
- Query planner decides automatically — use `EXPLAIN ANALYZE` to verify

---

## 10. Quick-Fire Interview Q&A

**Q: What is the difference between SQL and NoSQL?**  
A: SQL = structured, relational, ACID, fixed schema, joins. NoSQL = flexible schema, horizontal scale, BASE, designed for specific access patterns. Neither is universally better — choose based on data shape and access patterns.

**Q: When would you use MongoDB over PostgreSQL?**  
A: When schema is flexible or varies per document (product catalog with different attributes per category), when data is naturally document-shaped, or when horizontal sharding is needed without complex setup. For anything requiring strong consistency + relational data, PostgreSQL wins.

**Q: What is an index and when would you NOT use one?**  
A: An index is a data structure (usually B-Tree) that speeds up reads by allowing the DB to find rows without scanning the whole table. Don't index: small tables, low-cardinality columns (boolean), write-heavy tables, or columns rarely used in WHERE/JOIN/ORDER BY.

**Q: What is the N+1 query problem in SQL?**  
A: Fetching a list and then making one query per row for related data. Example: fetch 100 orders, then 100 separate queries for each user. Fix: JOIN or subquery to get everything in one query.

**Q: What is sharding?**  
A: Splitting a DB horizontally across multiple machines by a shard key. Each shard holds a subset of data. Used when vertical scaling maxes out. Trade-off: loses easy cross-shard JOINs.

**Q: What's the difference between Redis and Memcached?**  
A: Redis has richer data types (lists, sets, sorted sets, hashes), persistence options, and pub/sub. Memcached is simpler, strings only, no persistence. Default to Redis unless you need pure minimal caching.

**Q: What is eventual consistency?**  
A: In distributed systems, after a write, all nodes will eventually reflect the change — but not immediately. Reads right after a write might return stale data. Cassandra and DynamoDB default to this. Trade-off for availability + partition tolerance.

**Q: How does replication differ from sharding?**  
A: Replication = copies of the same data on multiple nodes (for read scale + failover). Sharding = different subsets of data on different nodes (for write scale + storage). They're often used together.

**Q: What is a covering index?**  
A: An index that includes all columns needed to satisfy a query — the DB can answer the query from the index alone without touching the actual table (heap). Faster but uses more storage.

**Q: PostgreSQL vs MySQL — which would you choose?**  
A: PostgreSQL for new projects — better JSONB support, richer data types, stronger ACID, more powerful query planner, and open license. MySQL for legacy systems or when team already uses it.