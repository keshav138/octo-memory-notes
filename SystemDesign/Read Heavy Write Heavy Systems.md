# Read-Heavy vs Write-Heavy Systems — DB Strategy Notes

Same DB can behave completely differently depending on whether your bottleneck is reads or writes. This is about _architecture around_ the DB as much as which DB you pick.

---

## PART 1 — READ-HEAVY SYSTEMS

**Signature:** reads massively outnumber writes (100:1, 1000:1+). Data doesn't change often, but everyone wants to see it.

**Real-world scenario:** News homepage, product detail pages on Amazon, a celebrity's Twitter/X profile, "trending" feeds, YouTube video metadata.

### Core strategies

**1. Caching layer in front of the DB**

- **Redis / Memcached** sit in front of Postgres/MySQL to absorb repeat reads.
- Pattern: cache-aside (app checks cache → miss → hits DB → writes to cache).
- Used by: virtually every large-scale web app (Twitter, Reddit, Facebook feed caching).

**2. Read replicas**

- Primary handles writes, N replicas handle reads, app routes read queries to replicas.
- Postgres streaming replication, MySQL read replicas, Aurora Read Replicas (up to 15).
- Real scenario: an e-commerce catalog service where product pages get replicated reads while inventory writes go to primary.
- **Watch out:** replication lag → stale reads. Fine for product pages, not fine for "did my payment go through."

**3. CDN + edge caching**

- For read-heavy _content_ (not just DB rows): Cloudflare, Fastly, CloudFront caching API responses or static content close to users.
- Used for: image/video metadata, public API responses that rarely change.

**4. Denormalization / materialized views**

- Precompute expensive joins/aggregations into a flat, read-optimized table.
- Postgres materialized views, or a separate denormalized table updated async.
- Real scenario: a dashboard showing "total orders per user per month" — precomputed nightly instead of joining live.

**5. Search-optimized read paths**

- Elasticsearch/OpenSearch as a read-only projection of the primary DB, synced via CDC (Debezium) or dual-write.
- Real scenario: product search on an e-commerce site — Postgres is truth, Elasticsearch serves the read-heavy search traffic.

**6. Read-optimized DB choice**

- **DynamoDB** with DAX (in-memory accelerator) for read-heavy key-value lookups at AWS scale.
- **Cassandra** tuned with `QUORUM` reads only when needed, `ONE` for max read throughput on tolerant data.

### Read-heavy stack example (real pattern)

```
Client → CDN (edge cache) → App → Redis (cache) → Read Replica (Postgres) 
                                                  → Elasticsearch (for search queries)
```

---

## PART 2 — WRITE-HEAVY SYSTEMS

**Signature:** massive ingestion rate, writes >> reads, or writes need to survive bursts without falling over.

**Real-world scenario:** IoT sensor ingestion, ad-click tracking, ride-hailing location pings (Uber driver GPS every few seconds), chat message ingestion (Discord), log/event pipelines, payment transaction processing at Black Friday scale.

### Core strategies

**1. Write-optimized DB choice**

- **Cassandra / ScyllaDB** — LSM-tree storage engines are built for sequential high-throughput writes (append-heavy, compaction handles cleanup later).
- **DynamoDB** — auto-scales write capacity, used for high-throughput write workloads at AWS scale.
- Real scenario: Discord moved chat message storage to Cassandra, then ScyllaDB, specifically because message writes at their scale overwhelmed relational DBs.

**2. Write buffering via message queues**

- Don't write directly to the DB from the request path — put a queue in front.
- **Kafka** absorbs the write burst, consumers batch-write to the DB at a sustainable rate.
- Real scenario: ad-click/impression tracking — millions of events/sec go to Kafka first, then batch-flushed into ClickHouse/Cassandra/S3.
- This decouples "accept the write" from "durably persist the write," so spikes don't take down your DB.

**3. Batching writes**

- Instead of one write per event, batch N events into a single write (bulk insert).
- Common in time-series ingestion (InfluxDB, TimescaleDB batch inserts) and Elasticsearch's `_bulk` API.

**4. Sharding / partitioning writes**

- Split writes across multiple DB instances by a shard key (user_id, region, etc.) so no single node is a write bottleneck.
- Real scenario: a multi-tenant SaaS sharding Postgres by `tenant_id`, or Cassandra's built-in partitioning by partition key.
- **Vitess** (used by YouTube, Slack) — sharding layer on top of MySQL specifically for this.

**5. Write-ahead log / append-only patterns**

- Kafka itself, or DB engines using WAL (Postgres WAL, Cassandra's commit log) — sequential disk writes are much faster than random writes, so append-first designs scale better.
- Real scenario: event-sourcing systems where every state change is an immutable append to a log (Kafka as source of truth) rather than in-place updates.

**6. Async / eventual consistency where acceptable**

- Don't force synchronous multi-replica writes if the use case tolerates slight delay.
- Cassandra tunable consistency: write with `ONE`, replicate async to other nodes — huge throughput gain vs `QUORUM`/`ALL`.
- Real scenario: view counters, "likes" counts — approximate/eventually-consistent counts are fine; exact-real-time isn't worth the write cost.

**7. Separate hot path from cold path**

- Hot path: fast, lightweight write acknowledgment (Kafka, Redis increment).
- Cold path: async ETL/batch job moves data into the analytical/durable store (ClickHouse, S3, data warehouse).
- Real scenario: Uber's location ping ingestion — pings go to a fast stream first, aggregated/persisted downstream.

### Write-heavy stack example (real pattern)

```
Client → Load Balancer → Kafka (buffer/absorb burst) → Stream consumers (batch)
                                                        → Cassandra/ScyllaDB (hot writes)
                                                        → S3/ClickHouse (cold storage/analytics)
```

---

## PART 3 — WHEN BOTH ARE HEAVY (mixed workload)

**Real-world scenario:** Instagram/Twitter feed — heavy writes (posts, likes, comments) AND heavy reads (everyone scrolling feeds).

**Common pattern: CQRS (Command Query Responsibility Segregation)**

- Separate the write model from the read model entirely.
- Writes go to a normalized, transactional store (Postgres).
- A separate process (CDC/event stream) projects that data into a read-optimized store (denormalized Postgres table, Elasticsearch, Redis-cached feed).
- Real scenario: Twitter's timeline — fan-out-on-write for most users (precompute each follower's feed on a new tweet) vs fan-out-on-read for celebrity accounts (too many followers to fan out, computed at read time instead).

**Key techniques combined:**

- Kafka/event streaming to decouple write path from read-model updates
- Redis for hot read paths (timelines, counters)
- Cassandra/DynamoDB for write-heavy raw event storage
- Elasticsearch for searchable read projections
- Postgres as the transactional source of truth for critical writes (payments, account state)

---

## Quick Cheatsheet

|Bottleneck|First lever to pull|
|---|---|
|Read-heavy, data rarely changes|Cache (Redis) + CDN|
|Read-heavy, complex queries|Read replicas + materialized views|
|Read-heavy, search/filter|Elasticsearch as read projection|
|Write-heavy, bursty|Kafka buffer + async batch writes|
|Write-heavy, sustained high volume|Cassandra/ScyllaDB/DynamoDB (LSM-tree engines)|
|Write-heavy, need to scale one DB|Sharding (Vitess, partition keys)|
|Both heavy|CQRS — split read model from write model|

## The interview-answer version

Don't say "use Cassandra for write-heavy." Say: _"Writes are bursty and high-volume, so I'd put a Kafka buffer in front to absorb spikes, batch-write into an LSM-tree-based store like Cassandra for durability, and if reads need to be fast on that same data, maintain a separate denormalized read projection (Redis or Elasticsearch) updated asynchronously via the same event stream."_ That's the CQRS + streaming pattern most real systems (Twitter, Uber, Discord) actually use.