# Database Selection Notes — System Design

Organized by DB category → real-world scenario → why that category → industry players currently in production use.

---

## 1. Relational / OLTP (RDBMS)

**Use when:** strong consistency, transactions (ACID), relational data with joins, well-defined schema.

**Real-world scenario:** Banking ledger, e-commerce orders/inventory, ride-hailing trip + payment records — anywhere money or state transitions must never be lost or double-applied.

**Why:** ACID guarantees, mature tooling, strong consistency by default, foreign keys enforce integrity.

**Industry DBs:**

- **PostgreSQL** — default choice today for most new systems (extensible, JSONB support, strong ecosystem: Supabase, Neon, RDS Postgres, Aurora Postgres)
- **MySQL** — still huge at scale (YouTube, older Facebook stack, Shopify uses sharded MySQL)
- **Amazon Aurora** — Postgres/MySQL compatible, used when you want managed RDBMS with better replication/failover than vanilla RDS

**Watch out:** vertical scaling limits; sharding is manual and painful past a point.

---

## 2. NewSQL (Distributed SQL)

**Use when:** you need RDBMS semantics (ACID, SQL) but at horizontal scale across regions — the "we outgrew Postgres but don't want to lose transactions" problem.

**Real-world scenario:** Global fintech/payments system (Stripe-like) needing consistency across multiple geographic regions with no single point of failure.

**Industry DBs:**

- **CockroachDB** — horizontally scalable Postgres-wire-compatible, used by Netflix, DoorDash for specific services
- **Google Cloud Spanner** — globally consistent, used internally at Google (Ads, Play) and externally by enterprises needing global ACID
- **TiDB** — MySQL-compatible distributed SQL, popular in China/fintech (Pingcap)

**Watch out:** operational complexity and cost; overkill unless you actually need global scale + ACID together.

---

## 3. Document Stores (NoSQL)

**Use when:** schema flexibility, nested/semi-structured data, rapid iteration, read-heavy with denormalized documents.

**Real-world scenario:** Product catalog for an e-commerce site (each product has wildly different attributes), user profile service, content management systems, mobile app backends with evolving data shapes.

**Industry DBs:**

- **MongoDB** — most widely used; common in startups, CMS backends, catalog services
- **Amazon DynamoDB** — used when you need document/key-value hybrid at massive scale with predictable low-latency (Amazon itself, Lyft, Airbnb for parts of their stack)
- **Couchbase** — used where you need doc store + built-in caching layer (some telecom/retail)
- **Firestore** — mobile/web apps needing real-time sync (Google ecosystem)

**Watch out:** weaker join support, eventual consistency by default in distributed setups (DynamoDB/Couchbase), data duplication.

---

## 4. Key-Value Stores

**Use when:** simple lookups by key, extreme low-latency, caching, session storage, rate limiting counters.

**Real-world scenario:** Session tokens for a login system, leaderboard/rate-limiter for an API gateway, caching layer in front of Postgres for a high-traffic feed.

**Industry DBs:**

- **Redis** — the default: caching, pub/sub, session store, leaderboards (used everywhere — Twitter, GitHub, Instagram)
- **Memcached** — pure caching, simpler than Redis, still used at Facebook/Meta at scale
- **DynamoDB** (also fits here) — key-value at AWS scale
- **etcd** — not general purpose KV, but used for distributed config/coordination (Kubernetes uses this internally)

**Watch out:** usually not your source of truth — it's a cache/accelerator layered on a durable store, unless you deliberately choose Redis with persistence (RDB/AOF) as primary store for non-critical data.

---

## 5. Wide-Column Stores

**Use when:** massive write throughput, time-series-like or event data, need to scale horizontally across data centers, query patterns are known in advance (denormalized by query).

**Real-world scenario:** IoT sensor data ingestion at millions of writes/sec, messaging app storing chat history per user (Discord's early message store), fraud detection systems logging events at scale.

**Industry DBs:**

- **Apache Cassandra** — Discord (chat messages), Netflix (viewing history), Instagram (used historically for parts of their infra)
- **ScyllaDB** — Cassandra-compatible but C++ rewrite for lower latency, used by Discord (migrated to this), Comcast
- **HBase** — Hadoop ecosystem, used in older big-data stacks (Facebook Messages used HBase originally)
- **Google Bigtable** — Google internal (Search index, Maps), available via GCP

**Watch out:** no joins, query patterns must be designed upfront (model around your queries, not your entities), eventual consistency tuning (quorum reads/writes).

---

## 6. Search Engines / Inverted Index Stores

**Use when:** full-text search, fuzzy matching, faceted search/filtering, log search & analytics.

**Real-world scenario:** E-commerce search bar ("wireless headphones under $50"), log aggregation/observability dashboards (searching application logs), autocomplete.

**Industry DBs:**

- **Elasticsearch** — the industry default (Wikipedia search, Uber's log pipeline, most ELK/EFK observability stacks)
- **OpenSearch** — AWS's Elasticsearch fork post-license change, used when avoiding Elastic's licensing
- **Apache Solr** — older but still used in some enterprise search deployments
- **Typesense / Meilisearch** — lightweight alternatives for simpler, fast typo-tolerant search in smaller apps

**Watch out:** not a source of truth — usually synced from a primary DB via CDC/pipeline; eventual consistency between primary DB and search index.

---

## 7. Time-Series Databases

**Use when:** data is timestamped and queried over time ranges/windows — metrics, monitoring, sensor readings, financial ticks.

**Real-world scenario:** Infrastructure monitoring (CPU/memory metrics per server per second), IoT temperature sensors, stock price tick data, application observability (Datadog/Prometheus style dashboards).

**Industry DBs:**

- **Prometheus** — the default for infra/app monitoring metrics (paired with Grafana)
- **InfluxDB** — general-purpose time-series, IoT and monitoring
- **TimescaleDB** — Postgres extension, chosen when you want SQL + time-series in one system (fintech ticks, SaaS analytics)
- **VictoriaMetrics** — Prometheus-compatible, chosen for lower resource footprint at scale

**Watch out:** not built for arbitrary relational queries; retention/downsampling policies matter for storage cost.

---

## 8. Columnar / OLAP (Analytics Warehouses)

**Use when:** heavy aggregations over huge datasets, BI dashboards, data warehousing, analytical (not transactional) queries.

**Real-world scenario:** "Revenue by region by quarter across 5 years of transactions," a company-wide BI dashboard, ad-hoc data science queries over billions of rows.

**Industry DBs:**

- **Snowflake** — dominant in enterprise data warehousing (separates storage/compute, pay-per-query model)
- **Google BigQuery** — serverless OLAP, common in GCP-based analytics stacks
- **Amazon Redshift** — AWS-native warehouse, common where the rest of the stack is already AWS
- **ClickHouse** — open-source, extremely fast for real-time analytics (used by Uber, Cloudflare for analytics dashboards)
- **Apache Druid / Pinot** — real-time OLAP for user-facing analytics (LinkedIn built Pinot for this)

**Watch out:** poor fit for single-row transactional lookups; designed for scanning millions of rows, not point queries.

---

## 9. Graph Databases

**Use when:** the relationships between entities matter as much as the entities themselves — traversals, recommendations, fraud rings, social graphs.

**Real-world scenario:** "Friends of friends" on a social network, fraud detection (finding rings of connected fake accounts), recommendation engines ("people who bought X also bought Y" via graph traversal), knowledge graphs.

**Industry DBs:**

- **Neo4j** — the most established graph DB, used in fraud detection (many banks), recommendation systems
- **Amazon Neptune** — managed graph DB on AWS, used for knowledge graphs/fraud detection in AWS-native stacks
- **ArangoDB** — multi-model (graph + document), used when you want flexibility without running two systems

**Watch out:** overkill if your relationships are shallow (1-2 hops) — a relational DB with proper indexes often suffices.

---

## 10. Vector Databases (relevant to your RAG work)

**Use when:** similarity search over embeddings — semantic search, RAG retrieval, recommendation via embedding similarity, image/audio similarity search.

**Real-world scenario:** RAG pipeline retrieving semantically relevant chunks for an LLM (exactly your multimodal RAG project), semantic product search, duplicate image detection.

**Industry DBs:**

- **Pinecone** — managed, most common in production RAG stacks (simple API, good at scale)
- **Weaviate** — open-source, hybrid search (vector + keyword) built in
- **Qdrant** — open-source, performance-focused, popular for self-hosted RAG
- **Milvus** — open-source, used for very large-scale vector search (billions of vectors)
- **pgvector** — Postgres extension; chosen when you want vector search without introducing a new system — good default if your dataset is small/medium and you already run Postgres
- **Redis** (with vector search module) — used when you already have Redis in your stack and want to avoid adding infra

**Watch out:** pgvector doesn't scale as well past tens of millions of vectors with high recall requirements — dedicated vector DBs win at that scale; index type (HNSW vs IVF) is a real tradeoff between recall, speed, and memory.

---

## 11. Object Storage (not a DB, but always shows up in system design)

**Use when:** storing large blobs — files, images, videos, backups, data lake raw storage.

**Real-world scenario:** User-uploaded images/videos, ML training datasets, data lake for analytics pipelines, static asset hosting.

**Industry:** **Amazon S3** (the industry default), **Google Cloud Storage**, **Azure Blob Storage**, **MinIO** (self-hosted S3-compatible).

---

## Quick Decision Cheatsheet

|Need|Reach for|
|---|---|
|Transactions, money, strict consistency|PostgreSQL / MySQL|
|Global scale + ACID|CockroachDB / Spanner|
|Flexible schema, catalogs, profiles|MongoDB / DynamoDB|
|Caching, sessions, leaderboards|Redis|
|Massive write throughput, event logs|Cassandra / ScyllaDB|
|Full-text / fuzzy search|Elasticsearch / OpenSearch|
|Metrics over time|Prometheus / TimescaleDB|
|BI dashboards, big aggregations|Snowflake / BigQuery / ClickHouse|
|Relationship traversal, fraud graphs|Neo4j|
|Semantic/embedding search (RAG)|Pinecone / Qdrant / pgvector|
|Files, blobs, media|S3|

## Real System = Multiple DBs

No serious production system uses just one DB. Typical pattern (e.g., a mid-size SaaS or e-commerce platform):

- **Postgres** → source of truth (orders, users, billing)
- **Redis** → cache + sessions
- **Elasticsearch** → product/content search
- **S3** → images, exports, backups
- **ClickHouse/BigQuery** → analytics dashboards, fed via CDC from Postgres
- **Pinecone/pgvector** → if there's any AI/recommendation feature

This "polyglot persistence" pattern is what interviewers usually want to see in system design rounds — picking one DB and justifying _why_, not name-dropping all of them.