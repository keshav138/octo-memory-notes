## Complete System Design Masterclass

This is your comprehensive guide to system design theory and components. I'll build from fundamentals to deep dives on each critical piece.

---

## PART 1: Foundational System Design Concepts

### The Golden Rules of System Design

| Principle | What It Means | Interview Hook |
|-----------|---------------|----------------|
| **Availability** | System stays up even when components fail | "We design for failure" |
| **Consistency** | All nodes see same data at same time | Trade-off with availability (CAP) |
| **Partition Tolerance** | System works despite network splits | Non-negotiable in distributed systems |
| **Latency** | Time to process a request | Lower is better, but trade with consistency |
| **Throughput** | Requests processed per second | Scale horizontally to increase |
| **Durability** | Data persists after writes | Replication + WAL (Write-Ahead Log) |

### The CAP Theorem (Must Memorize)

**Statement**: In a distributed system, you can only guarantee TWO of: Consistency, Availability, Partition Tolerance.

```
        Consistency
           /\
          /  \
         /    \
        /      \
       /  CP    \
      /    AP    \
     /            \
Availability ------ Partition Tolerance
```

| System Type | Sacrifices | Real-World Examples |
|-------------|------------|---------------------|
| **CP** (Consistency + Partition) | Availability during partition | Traditional RDBMS, HBase, MongoDB (default) |
| **AP** (Availability + Partition) | Consistency (eventual only) | Cassandra, DynamoDB, CouchDB |
| **CA** (Consistency + Availability) | Partition tolerance | Single-node databases (impossible in distributed) |

**Interview Answer**: "In distributed systems, network partitions are inevitable. So we actually choose between CP and AP. For banking, choose CP. For social media feeds, choose AP."

### Latency Numbers Every Engineer Should Know (2010s vs Now)

| Operation | 2010s Latency | 2020s Latency | Relative Scale |
|-----------|---------------|---------------|----------------|
| L1 cache reference | 0.5 ns | ~1 ns | 1x |
| L2 cache reference | 7 ns | ~4 ns | 4x |
| Mutex lock/unlock | 25 ns | ~30 ns | 30x |
| Main memory reference | 100 ns | ~100 ns | 100x |
| Compress 1KB with Snappy | 3,000 ns | ~2,000 ns | 2,000x |
| Read 1MB sequentially from memory | 30,000 ns | ~30,000 ns | 30,000x |
| SSD random read | 150,000 ns | ~100,000 ns | 100,000x |
| Read 1MB sequentially from SSD | 1,000,000 ns | ~500,000 ns | 500,000x |
| **Network: Same region** | 500,000 ns | ~500,000 ns | 500,000x |
| **Network: Cross-region** | 50,000,000 ns | ~50,000,000 ns | 50,000,000x |
| Disk seek (HDD) | 10,000,000 ns | ~3,000,000 ns | 3,000,000x |
| Read 1MB sequentially from disk | 20,000,000 ns | ~5,000,000 ns | 5,000,000x |

**Key Takeaway**: Network and disk are *millions* of times slower than CPU cache. Design to minimize them.

---

## PART 2: Core Infrastructure Components

### 2.1 Load Balancer (LB)

**What it does**: Distributes incoming traffic across multiple backend servers.

#### Types of Load Balancers

| Type | Layer | Works With | Pros | Cons |
|------|-------|------------|------|------|
| **Layer 4 (Transport)** | TCP/UDP | Any protocol | Fast, simple, low latency | No content-based routing |
| **Layer 7 (Application)** | HTTP/HTTPS | Web traffic | Smart routing, SSL termination, caching | Slower, more complex |
| **Global/Geo-LB** | DNS + L7 | Multi-region | Disaster recovery, low latency routing | DNS caching issues |

#### Load Balancing Algorithms

| Algorithm | How It Works | Best For |
|-----------|--------------|----------|
| **Round Robin** | Cycles through servers | Identical servers, simple workloads |
| **Least Connections** | Sends to server with fewest active connections | Long-lived connections (WebSockets) |
| **IP Hash** | Hash(client IP) % N | Session persistence (sticky sessions) |
| **Weighted Round Robin** | Servers get different request counts | Servers with different capacities |
| **Least Response Time** | Sends to fastest responding server | Performance-sensitive apps |

#### Health Checks

```yaml
# Example health check config (like AWS ALB)
HealthCheck:
  Protocol: HTTP
  Path: /health
  Interval: 30 seconds
  Timeout: 5 seconds
  HealthyThreshold: 2
  UnhealthyThreshold: 3
  Matcher:
    HttpCode: "200-299"
```

#### Interview Scenario
**Q**: User reports intermittent 503 errors. What's happening?
**A**: Likely all backend instances failing health checks. Check:
1. Are instances actually healthy? (CPU/memory)
2. Is health check path correct?
3. Is database connection pool exhausted?

### 2.2 API Gateway

**What it does**: Sits *in front* of your APIs, acting as a single entry point. Like a load balancer but smarter.

#### Core Responsibilities

| Responsibility | What It Means | Example |
|----------------|---------------|---------|
| **Request Routing** | Route to correct microservice | `/users/*` → User Service, `/orders/*` → Order Service |
| **Authentication** | Verify tokens before reaching backend | JWT validation, OAuth2 introspection |
| **Rate Limiting** | Enforce quotas per client | 1000 req/min for free tier |
| **Request/Response Transformation** | Modify payloads | Add headers, rename fields |
| **Caching** | Cache responses | Product catalog, user profiles |
| **Logging & Monitoring** | Centralized request tracking | Trace IDs, latency metrics |
| **CORS** | Handle cross-origin requests | Add `Access-Control-Allow-Origin` |
| **Circuit Breaking** | Stop forwarding to failing services | After 5 failures in 10s, open circuit |

#### Popular API Gateways

| Gateway | Best For | Key Feature |
|---------|----------|-------------|
| **Kong** | Microservices | Plugin ecosystem (Lua) |
| **AWS API Gateway** | Serverless | Lambda integration |
| **NGINX** | High performance | Pure speed, custom config |
| **Envoy** | Service mesh | Advanced observability |
| **Traefik** | Kubernetes | Automatic service discovery |

#### Interview Scenario: Design an API Gateway for 10,000 req/s

**Answer structure**:
1. **Deployment**: Run gateway as stateless cluster behind load balancer
2. **Rate Limiting**: Use Redis with Token Bucket (global counters)
3. **Caching**: Redis/ElastiCache for response cache
4. **Authentication**: Cache JWT public keys, validate locally
5. **Routing**: Store routes in etcd/Consul for dynamic updates

### 2.3 Content Delivery Network (CDN)

**What it does**: Geographically distributed servers caching static content close to users.

#### How CDN Works

```
User in India → CDN Edge (Mumbai) ← Origin (US West)
                    ↑
                    │ Cache MISS
                    │
User in US → CDN Edge (Virginia) ← Cache HIT
```

#### What to Put on CDN

| Content Type | Cache TTL | Example |
|--------------|-----------|---------|
| **Static assets** | Long (1 year) | CSS, JS, images, fonts |
| **User-generated content** | Medium (1 hour) | Profile pictures, uploaded videos |
| **API responses** | Short (1-60 seconds) | Product lists, news headlines |
| **HTML pages** | Varies | Homepage (5 min), user-specific (no cache) |

#### Cache Invalidation Strategies

| Strategy | How | Pros | Cons |
|----------|-----|------|------|
| **TTL-based** | Expire after N seconds | Simple, predictable | Stale content until expiry |
| **Purge** | Manual/API removal | Immediate removal | Costly, race conditions |
| **Versioned URLs** | `/css/main.v2.css` | No invalidation needed | Must update all references |
| **Cache Tags** | Invalidate by tag | Granular control | CDN must support |

#### Interview Scenario: Deploying new version of website

**Problem**: Old CSS/JS cached for 1 year, users get broken layout.

**Solution**:
1. Build assets with content hash: `main.a3f4k.css`
2. Update HTML to reference new hash
3. HTML itself cached for 5 minutes
4. Result: Users get fresh assets immediately, old ones expire naturally

### 2.4 Message Queues (Async Processing)

**What it does**: Decouples producers from consumers, enables async processing.

#### Core Concepts

```
Producer → [Queue] → Consumer
           (Buffer)
```

| Concept | Explanation |
|---------|-------------|
| **Producer** | Service sending messages |
| **Consumer** | Service processing messages |
| **Message** | The data being sent |
| **Queue** | FIFO buffer (usually) |
| **Broker** | The queue system itself (RabbitMQ, Kafka) |

#### Popular Message Queues Comparison

| Feature | RabbitMQ | Apache Kafka | AWS SQS | Redis Pub/Sub |
|---------|----------|--------------|---------|---------------|
| **Pattern** | Traditional queue | Log/stream | Managed queue | Pub/Sub |
| **Persistence** | Disk (optional) | Disk (mandatory) | Disk | Memory (default) |
| **Ordering** | Per queue | Per partition | FIFO queue (limited) | Not guaranteed |
| **Retention** | Until consumed | Configurable (days) | Up to 14 days | Until consumed |
| **Use Case** | Task distribution | Event streaming | Serverless apps | Real-time notifications |
| **Throughput** | ~50k msg/s | ~1M msg/s | ~3k req/s (standard) | ~1M msg/s |

#### Queue Patterns (Must Know)

**1. Point-to-Point (Work Queue)**
```
Producer → Queue → [Worker 1]
                 → [Worker 2]
                 → [Worker 3]
```
- Each message goes to ONE worker
- Use for: Email sending, image processing

**2. Pub/Sub (Topic)**
```
Producer → Topic → [Subscriber 1]
                 → [Subscriber 2]
                 → [Subscriber 3]
```
- Each message goes to ALL subscribers
- Use for: Notifications, analytics

**3. Dead Letter Queue (DLQ)**
```
Queue → Consumer (fails) → DLQ (store for later inspection)
```
- Messages that fail processing go here
- Prevents infinite retry loops

#### Exactly-Once vs At-Least-Once vs At-Most-Once

| Delivery Guarantee | What It Means | Implementation Cost |
|--------------------|---------------|---------------------|
| **At-most-once** | Message may be lost | Low (fire and forget) |
| **At-least-once** | Message may be duplicated | Medium (ack on processing) |
| **Exactly-once** | Message processed once | High (idempotent consumers + transactions) |

**Interview Truth**: "Exactly-once" is almost impossible distributed. Aim for idempotent consumers + at-least-once.

#### Interview Scenario: Order processing system

**Problem**: Customer clicks "Place Order" once, but gets two confirmation emails.

**Root cause**: Consumer crashed after processing but before acknowledging. Message re-queued and processed again.

**Solution**: Make consumer idempotent
```python
def process_order(order_id):
    # Check if already processed
    if redis.exists(f"processed:{order_id}"):
        return "already_processed"
    
    # Process order
    send_confirmation_email(order_id)
    
    # Mark as processed (with TTL)
    redis.setex(f"processed:{order_id}", 86400, "done")
    
    # Acknowledge message
    queue.ack()
```

---

## PART 3: Caching Strategies (Deep Dive)

### Cache Hierarchy

```
Browser Cache (L1)
    ↓ MISS
CDN (L2)
    ↓ MISS
API Gateway Cache (L3)
    ↓ MISS
Application Cache (Redis/Memcached) (L4)
    ↓ MISS
Database (L5)
```

### Caching Strategies (Must Know)

| Strategy | How It Works | Best For | Anti-Pattern |
|----------|--------------|----------|--------------|
| **Cache-Aside (Lazy Loading)** | App checks cache, then DB, then updates cache | Read-heavy workloads | Cache stampede on expiration |
| **Write-Through** | Write to cache + DB synchronously | Write-heavy, need consistency | Slower writes |
| **Write-Behind (Write-Back)** | Write to cache, async to DB | Very high write throughput | Data loss on cache failure |
| **Refresh-Ahead** | Cache auto-refreshes before expiry | Predictable access patterns | Wasted resources if not accessed |

### Cache-Aside Pattern (Most Common)

```python
def get_user(user_id):
    # 1. Try cache
    user = redis.get(f"user:{user_id}")
    
    if user is None:
        # 2. Cache miss - get from DB
        user = db.query("SELECT * FROM users WHERE id = %s", user_id)
        
        # 3. Write to cache
        redis.setex(f"user:{user_id}", 3600, user)
    
    return user
```

### Cache Invalidation (The Hardest Problem)

**The 2 Hard Problems in CS**:
1. Naming things
2. Cache invalidation
3. Off-by-one errors

| Problem | Scenario | Solution |
|---------|----------|----------|
| **Stale reads** | User updates profile but sees old version | Write-through cache |
| **Cache stampede** | 1000 requests all miss on expired cache | Mutex/locking on cache miss |
| **Thundering herd** | Multiple services invalidate same key | Use TTL + jitter |
| **Dog-pile effect** | Recalculating expensive query after expiry | Refresh-ahead |

### Cache Eviction Policies

| Policy | What It Does | Use Case |
|--------|--------------|----------|
| **LRU** (Least Recently Used) | Evicts oldest accessed | General purpose |
| **LFU** (Least Frequently Used) | Evicts least popular | Long-tail content |
| **FIFO** | Evicts oldest created | Time-series data |
| **TTL** | Expires after fixed time | Session data |
| **Random** | Random eviction | Simplicity |

### Redis vs Memcached

| Feature | Redis | Memcached |
|---------|-------|-----------|
| **Data structures** | Strings, hashes, lists, sets, sorted sets, bitmaps | Strings only |
| **Persistence** | RDB snapshots + AOF logs | None (volatile) |
| **Replication** | Master-slave, Sentinel, Cluster | No native |
| **Atomic operations** | Rich (INCR, LPUSH, SADD) | CAS only |
| **Max key size** | 512MB | 1MB |
| **Use case** | Caching + queues + rate limiting + sessions | Pure caching |

---

## PART 4: Asynchronous Patterns

### Sync vs Async

```
SYNC:
Client ──req──> Server ──DB──> ──resp──> Client
(Blocked)

ASYNC:
Client ──req──> Server ──Queue──> Worker (background)
         └── 202 Accepted ──> Client (immediate)
                              │
                              ↓ Webhook/WebSocket/Polling
```

### Async Patterns

| Pattern | How | Use Case |
|---------|-----|----------|
| **Fire-and-Forget** | No response needed | Logging, analytics |
| **Request-Reply** | Get immediate acceptance, later result | Report generation |
| **Callback/Webhook** | Server calls client when done | Payment processing |
| **Polling** | Client checks status endpoint | Long-running tasks |
| **WebSocket** | Bidirectional real-time | Chat, live updates |

### Implementation Example: Async Report Generation

```python
# POST /reports - Request report generation
def create_report(request):
    report_id = uuid4()
    # Store initial status
    redis.set(f"report:{report_id}:status", "processing")
    
    # Queue the job
    queue.send({
        "report_id": report_id,
        "filters": request.filters
    })
    
    return {"report_id": report_id, "status_url": f"/reports/{report_id}/status"}

# GET /reports/{id}/status - Check status
def get_status(request, report_id):
    status = redis.get(f"report:{report_id}:status")
    
    if status == "completed":
        return {"status": "completed", "download_url": f"/reports/{report_id}/download"}
    else:
        return {"status": status}

# GET /reports/{id}/download - Get result
def download_report(request, report_id):
    return FileResponse(open(f"/reports/{report_id}.pdf", "rb"))
```

---

## PART 5: Microservices Architecture

### Monolith vs Microservices

| Aspect | Monolith | Microservices |
|--------|----------|---------------|
| **Deployment** | One unit | Per service |
| **Scaling** | Scale everything | Scale only what's needed |
| **Development** | Single codebase | Multiple teams, repos |
| **Technology** | Single stack | Polyglot (each service can choose) |
| **Data** | Single database | Database per service |
| **Communication** | In-memory calls | Network (HTTP/gRPC) |
| **Complexity** | Low initially | High (distributed systems) |

### When to Choose Microservices

| ✅ Good for Microservices | ❌ Bad for Microservices |
|--------------------------|-------------------------|
| Large engineering team (50+) | Small team (1-5) |
| Multiple business domains | Simple CRUD app |
| Need independent scaling | Startup/early product |
| Different tech per domain | Tight latency requirements |
| Organizational boundaries | Simple transaction needs |

### Microservices Patterns

**1. API Gateway Pattern**
```
Client → API Gateway → [User Service]
                     → [Order Service]
                     → [Product Service]
```

**2. Service Discovery**
```
Service A → Service Registry → Get Service B IP → Call Service B
```

**3. Circuit Breaker**
```
Normal: Request → [=====] → Service
Failure: Request → [XXX] → Fast fail (open circuit)
After timeout: Request → [====] → Test (half-open)
```

### Distributed Transaction Patterns

| Pattern | How It Works | When to Use |
|---------|--------------|-------------|
| **2-Phase Commit (2PC)** | Prepare → Commit/Rollback | Rare (blocking, complex) |
| **Saga** | Series of local transactions with compensating actions | Long-running business processes |
| **Eventual Consistency** | Accept temporary inconsistency | High availability needs |
| **Outbox Pattern** | DB + message in same transaction | Reliable event publishing |

**Saga Example (Order Processing)**:
```yaml
Order Saga:
  1. Create Order (pending)
  2. Reserve Payment → COMPENSATION: Cancel Payment
  3. Reserve Inventory → COMPENSATION: Release Inventory
  4. Ship Order → COMPENSATION: Return Order
  5. Complete Order
```

---

## PART 6: Monitoring & Observability

### The Three Pillars

| Pillar | What | Example |
|--------|------|---------|
| **Metrics** | Numeric time-series data | Request rate, error rate, latency, CPU |
| **Logs** | Discrete events | "User 123 logged in at 2024-01-01 10:00" |
| **Traces** | Request path through system | Trace ID through API Gateway → Auth → DB |

### Golden Signals (Google SRE)

| Signal | Definition | Alert When |
|--------|------------|-------------|
| **Latency** | Time to process request | p99 > 500ms |
| **Traffic** | Request rate | Sudden drop/spike |
| **Errors** | % of failed requests | >1% 5xx errors |
| **Saturation** | How "full" the service is | CPU > 80% |

### Monitoring Stack Example

```
Prometheus (Metrics collection)
    ↓
Grafana (Visualization)
    ↓
AlertManager (Alerting) → PagerDuty/Slack

ELK Stack:
Elasticsearch (Log storage)
Logstash (Log processing)
Kibana (Log visualization)

Jaeger/Zipkin (Distributed tracing)
```

### Health Check Endpoint Example

```python
# GET /health
{
    "status": "healthy",  # or "degraded", "unhealthy"
    "timestamp": "2024-01-01T10:00:00Z",
    "checks": {
        "database": {"status": "up", "latency_ms": 5},
        "redis": {"status": "up", "latency_ms": 2},
        "queue": {"status": "down", "error": "Connection refused"},
        "disk": {"status": "up", "free_gb": 42}
    },
    "version": "v2.3.1",
    "uptime_seconds": 86400
}
```

---

## PART 7: Quick Cheat Sheet for Interviews

| Topic | Key Phrases to Use |
|-------|---------------------|
| **Load Balancer** | "Layer 4 vs Layer 7, health checks, round robin, least connections, sticky sessions" |
| **API Gateway** | "Single entry point, auth, rate limiting, routing, transformation, circuit breaking" |
| **CDN** | "Edge caching, TTL, cache invalidation, purge, versioned URLs, geo-distribution" |
| **Message Queue** | "Decouple, async, buffer, at-least-once, idempotency, DLQ, pub/sub vs work queue" |
| **Caching** | "Cache-aside, write-through, TTL, LRU, cache stampede, Redis vs Memcached" |
| **Async** | "Fire-and-forget, webhook, polling, WebSocket, SQS/SNS, Kafka for streaming" |
| **Microservices** | "Database per service, saga pattern, eventual consistency, API gateway, service discovery" |
| **Monitoring** | "Golden signals: latency, traffic, errors, saturation; metrics, logs, traces" |

---

## Sample System Design Interview Question

**Design Twitter (simplified)**

```
Requirements:
- Post tweet
- View home timeline (tweets from followed users)
- 100M daily active users
- 500M tweets/day
```

**High-level answer**:
1. **Write path**: 
   - Client → Load Balancer → API Gateway → Tweet Service
   - Tweet Service writes to: 
     - Primary DB (Cassandra for write scalability)
     - Fanout queue (Kafka)

2. **Fanout service**:
   - Consumes from Kafka
   - For each tweet, writes tweet ID to timeline of all followers
   - Use Redis sorted sets (timeline per user, score = timestamp)

3. **Read path**:
   - Client → CDN (for media) → API Gateway → Timeline Service
   - Timeline Service reads from Redis (timeline set)
   - Paginate with `ZREVRANGEBYSCORE`

4. **Key tradeoffs**:
   - Use AP (Cassandra/Redis) for timeline (eventual consistency acceptable)
   - CP for critical data (user accounts in PostgreSQL)
   - Accept that followers might see tweet after 1-2 seconds

---

This is your complete system design reference. Let me know which component you want to explore deeper, or when you're ready for the next topic (e.g., databases deep dive, real-world case studies).