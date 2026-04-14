## Situational System Design: Real-World Decision Framework

This is your **decision matrix** for when to use what component, with concrete scenarios. I'll give you the "why" behind each choice.

---

## 1. LOAD BALANCER SCENARIOS

### Scenario 1: E-commerce Flash Sale (Amazon Prime Day)
**Problem**: 10x normal traffic for 1 hour. Requests spike from 1,000 req/s to 10,000 req/s.

**Decision**: **Layer 7 (Application) Load Balancer**

**Why**: 
- Can inspect HTTP headers to route cart/checkout requests differently
- Supports sticky sessions (user's cart must stay on same server)
- Can do content-based routing (`/api/payment` → payment service pool)

**What NOT to use**: Layer 4 LB - can't do session affinity based on cookies, would break carts.

### Scenario 2: Real-time Gaming Server (Call of Duty matchmaking)
**Problem**: 10,000 concurrent WebSocket connections, each long-lived (30 minutes).

**Decision**: **Layer 4 Load Balancer + Least Connections algorithm**

**Why**:
- Layer 4 is faster (no HTTP parsing overhead)
- Least Connections prevents any single game server from being overwhelmed
- TCP-level balancing works perfectly for WebSockets

**What NOT to use**: Round Robin - would cause imbalance because games have different durations.

### Scenario 3: Multi-region Disaster Recovery (Global SaaS)
**Problem**: US-East region goes offline, need to route all traffic to EU-West.

**Decision**: **Global Load Balancer (DNS-based + Health Checks)**

**Why**:
- DNS GSLB (Global Server Load Balancing) can route users to healthy region
- Health checks detect region failure in <30 seconds
- Can implement geo-routing (EU users go to EU region normally)

**What NOT to use**: Single-region LB - single point of failure.

---

## 2. API GATEWAY SCENARIOS

### Scenario 4: Microservices Migration (Monolith to 20 services)
**Problem**: Breaking monolith into services. Mobile apps can't handle 20 different endpoints.

**Decision**: **API Gateway with Request Routing**

**Why**:
- Mobile app talks to ONE endpoint: `https://api.company.com`
- Gateway routes: `/users/*` → User Service, `/orders/*` → Order Service
- Gateway aggregates responses (BFF pattern - Backend for Frontend)

**Example**:
```javascript
// Mobile app makes ONE request to:
GET /api/mobile/dashboard

// Gateway internally fans out to:
- User service (get profile)
- Order service (get recent orders)
- Recommendation service (get products)

// Gateway aggregates into single response
```

### Scenario 5: Third-party API Provider (Stripe/Twilio)
**Problem**: 10,000 customers each with different rate limits and API keys.

**Decision**: **API Gateway with Rate Limiting + Auth**

**Why**:
- Store customer tier in Redis: "basic" = 100 req/min, "pro" = 10,000 req/min
- Gateway validates API keys before hitting backend
- Can implement quota tracking and billing integration

**Implementation**:
```yaml
Rate Limit Rules:
  customer_123 (basic): 100 req/min
  customer_456 (pro): 10,000 req/min
  customer_789 (enterprise): unlimited with burst protection
```

### Scenario 6: Security Compliance (PCI-DSS for payments)
**Problem**: Payment card data must never hit application servers in logs.

**Decision**: **API Gateway with Request Transformation + Tokenization**

**Why**:
- Gateway strips credit card numbers from logs BEFORE hitting backend
- Gateway can replace PAN with token before forwarding
- Single place to enforce TLS 1.3, cipher suite restrictions

**What NOT to use**: Letting individual services handle security - too many places to miss.

---

## 3. CDN SCENARIOS

### Scenario 7: Viral Video Platform (TikTok/YouTube Shorts)
**Problem**: Video goes viral (10M views in 1 hour), 90% from India.

**Decision**: **CDN with Edge Storage + Regional Caching**

**Why**:
- CDN edge nodes in Mumbai, Chennai, Bangalore serve video
- 10M views × 50MB video = 500TB transferred from origin without CDN
- With CDN: Origin serves once to Mumbai edge, edge serves 10M users

**What NOT to use**: Serving from origin (US-West) - 200ms latency for India users.

### Scenario 8: News Website with Breaking Story
**Problem**: Story updates every 5 minutes, but 1M users refresh constantly.

**Decision**: **CDN with Short TTL (30 seconds) + Cache Tags**

**Why**:
- Set `Cache-Control: max-age=30`
- Use cache tags: `tag:story-123`
- When story updates, purge just that tag
- 30s TTL means even without purge, stale content expires quickly

**Implementation**:
```http
# Response headers
Cache-Control: max-age=30, stale-while-revalidate=10
Cache-Tag: breaking-news, category-world
CDN-Cache-Status: HIT
```

### Scenario 9: User Profile Pictures (Facebook)
**Problem**: Billions of profile pictures, rarely change, accessed globally.

**Decision**: **CDN with Long TTL (1 year) + Versioned URLs**

**Why**:
- Profile picture URL includes hash: `/profile/123/photo.a3f4k.jpg`
- When user changes photo, new hash generated, old URL abandoned
- No invalidation needed - old photos expire naturally
- CDN can cache indefinitely

**What NOT to use**: TTL-based expiration - would cause unnecessary refetches.

---

## 4. MESSAGE QUEUE SCENARIOS

### Scenario 10: Order Processing System (Amazon checkout)
**Problem**: Payment processing takes 2 seconds, but user expects instant response.

**Decision**: **RabbitMQ (Work Queue) with At-Least-Once Delivery**

**Why**:
- Order created → immediate 202 Accepted response
- Queue message: `{"order_id": 123, "payment_details": "..."}`
- Workers process payments asynchronously
- User gets "Order confirmed" email 2 seconds later (acceptable)

**Why RabbitMQ over Kafka**:
- RabbitMQ better for task distribution (each message to one worker)
- Lower latency for small message volumes
- Simpler consumer model

### Scenario 11: Real-time Analytics Pipeline (Uber ride events)
**Problem**: 10,000 ride events/second, need to feed multiple systems (metrics, billing, fraud detection).

**Decision**: **Apache Kafka with Pub/Sub Pattern**

**Why**:
- Kafka retains messages for 7 days (replay capability)
- Multiple consumer groups read same stream:
  - Group 1: Metrics (Prometheus)
  - Group 2: Billing (Spark job)
  - Group 3: Fraud detection (Flink)
- Partition by `ride_id` for ordering guarantees

**What NOT to use**: RabbitMQ - would need to copy message to 3 queues (inefficient).

### Scenario 12: Email Newsletter Service (Mailchimp)
**Problem**: Send 1M emails, but SMTP servers rate-limit to 100 emails/second.

**Decision**: **SQS with Dead Letter Queue + Exponential Backoff**

**Why**:
- Queue buffers emails
- Consumers respect SMTP rate limits
- Failed emails go to DLQ after 3 retries
- Exponential backoff: 1s → 2s → 4s → 8s → DLQ

**Implementation**:
```python
# Consumer with retry logic
def process_email(email):
    try:
        smtp.send(email)
    except RateLimitError:
        # Requeue with delay
        queue.send(email, delay_seconds=backoff_time)
    except PermanentError:
        queue.send_to_dlq(email)
```

### Scenario 13: IoT Sensor Data (Smart home)
**Problem**: 1M sensors sending temperature every second. Data loss acceptable, but must handle bursts.

**Decision**: **Redis Pub/Sub with Fire-and-Forget**

**Why**:
- Lowest latency (<1ms)
- No persistence needed (data is ephemeral)
- If consumer crashes, missed data is fine (next reading in 1 second)
- Redis can handle 1M msg/s easily

**What NOT to use**: Kafka - overkill with persistence overhead.

---

## 5. CACHING SCENARIOS

### Scenario 14: Product Catalog (E-commerce homepage)
**Problem**: 10,000 products, 1M users/hour, products update hourly.

**Decision**: **Cache-Aside + TTL (1 hour)**

**Why**:
```python
def get_product(product_id):
    # Cache miss ratio: ~1% (only when TTL expires)
    product = redis.get(f"product:{product_id}")
    if not product:
        product = db.query("SELECT * FROM products WHERE id = %s", product_id)
        redis.setex(f"product:{product_id}", 3600, product)
    return product
```
- 99% cache hit rate
- Stale data acceptable for 1 hour
- Simple implementation

### Scenario 15: Live Sports Scores (ESPN)
**Problem**: Scores update every second, 5M users polling every 5 seconds.

**Decision**: **Write-Through Cache with Pub/Sub**

**Why**:
- Score updates go: API → Redis (cache) → DB (async)
- When score updates, Redis PUBLISH to all connected clients
- Clients get real-time updates via WebSocket
- No cache stampede (everyone reading same key)

**Implementation**:
```python
# Update score
def update_score(game_id, new_score):
    # Write to cache synchronously
    redis.set(f"score:{game_id}", new_score)
    # Publish change
    redis.publish(f"game:{game_id}:updates", new_score)
    # Queue DB write
    queue.send({"game_id": game_id, "score": new_score})
```

### Scenario 16: User Session Store (Logged-in users)
**Problem**: 10M active sessions, need TTL (24 hours), need fast lookups.

**Decision**: **Redis with TTL + LRU eviction**

**Why**:
- `SETEX session:token 86400 user_data` (auto-expires)
- Redis LRU evicts least recently used when memory full
- Sub-millisecond lookup time
- Supports atomic updates (`HSET`, `INCR` for session counters)

**What NOT to use**: Memcached - can't do complex session data structures (nested user objects).

### Scenario 17: Database Query Cache (Expensive joins)
**Problem**: Complex analytics query takes 30 seconds, runs every hour.

**Decision**: **Refresh-Ahead Cache**

**Why**:
- Cache auto-refreshes 5 minutes before expiry
- Query results always available
- No user ever waits for query execution

**Implementation**:
```python
# Scheduled job runs 5 min before expiry
def refresh_cache():
    result = run_expensive_query()
    redis.setex("analytics:daily_sales", 3600, result)

# User request always hits cache
def get_daily_sales():
    return redis.get("analytics:daily_sales")  # Always present
```

---

## 6. DATABASE SCENARIOS (SQL vs NoSQL)

### Scenario 18: Banking Transaction System
**Problem**: Money transfers require ACID, no double spending.

**Decision**: **PostgreSQL (SQL)**

**Why**:
- ACID transactions across accounts
- `BEGIN; UPDATE accounts SET balance = balance - 100 WHERE id = 1; UPDATE accounts SET balance = balance + 100 WHERE id = 2; COMMIT;`
- Strong consistency guarantees

**What NOT to use**: MongoDB (even with transactions, weaker isolation).

### Scenario 19: Chat Message History (WhatsApp)
**Problem**: Billions of messages, write-heavy, need to query by user and timestamp.

**Decision**: **Cassandra (NoSQL - Wide Column)**

**Why**:
- Partition by `user_id`, cluster by `timestamp`
- Query: `SELECT * FROM messages WHERE user_id = 123 ORDER BY timestamp DESC LIMIT 50`
- Linear write scalability (add nodes, get more write throughput)
- No single point of failure

**Schema**:
```sql
CREATE TABLE messages (
    user_id uuid,
    timestamp timestamp,
    message_id uuid,
    content text,
    PRIMARY KEY (user_id, timestamp)
) WITH CLUSTERING ORDER BY (timestamp DESC);
```

### Scenario 20: Social Graph (LinkedIn connections)
**Problem**: "People you may know" requires traversing friend-of-friend relationships.

**Decision**: **Neo4j (Graph Database)**

**Why**:
- SQL would need multiple joins: `SELECT * FROM users WHERE id IN (SELECT friend_id FROM friends WHERE user_id IN (SELECT friend_id FROM friends WHERE user_id = 123))`
- Graph DB: `MATCH (u:User {id:123})-[:FRIEND]->(f)-[:FRIEND]->(fof) RETURN fof`
- 100x faster for graph traversals

---

## 7. ASYNC PATTERN SCENARIOS

### Scenario 21: Report Generation (Yearly sales report)
**Problem**: Query takes 5 minutes, user can't wait.

**Decision**: **Request-Reply with Polling**

**Why**:
1. Client POST `/reports` → returns `{"report_id": "abc", "status_url": "/reports/abc"}`
2. Client polls every 2 seconds
3. When complete, GET `/reports/abc/download` returns file

**Why not WebSocket**: Simple polling is fine for occasional long operations.

### Scenario 22: Payment Webhook (Stripe)
**Problem**: Payment processor (Stripe) needs to notify your system when payment completes.

**Decision**: **Webhook (Callback)**

**Why**:
- Stripe calls your endpoint: `POST /webhooks/stripe`
- Your system updates order status
- No need to poll Stripe API

**Idempotency required**:
```python
def stripe_webhook(request):
    event_id = request.headers['Stripe-Signature']
    
    # Idempotency check
    if redis.exists(f"webhook:{event_id}"):
        return HttpResponse(status=200)
    
    # Process once
    process_payment(request.body)
    redis.setex(f"webhook:{event_id}", 86400, "processed")
```

---

## 8. MICROSERVICES SCENARIOS

### Scenario 23: Ride-hailing App (Uber)
**Problem**: 5 teams (Riders, Drivers, Payments, Matching, Analytics) need independent deployment.

**Decision**: **Microservices with API Gateway + Kafka**

**Why**:
- Each team owns service, deploys independently
- Kafka decouples: Driver location events → Matching service consumes
- API Gateway routes mobile traffic
- Payment service can be rewritten without affecting others

**Service boundaries**:
```
Rider Service   → PostgreSQL (riders)
Driver Service  → PostgreSQL (drivers) + Redis (location)
Matching Service → Cassandra (ride history)
Payment Service → PostgreSQL (ACID)
```

### Scenario 24: Startup MVP (Todo app)
**Problem**: 2 developers, 100 users, need to launch fast.

**Decision**: **Monolith (Django/Rails)**

**Why**:
- One codebase, one deployment
- No distributed system complexity
- Can migrate to microservices later if needed (likely never)
- 1000x simpler

**What NOT to use**: Microservices - over-engineering for scale that doesn't exist.

---

## 9. MONITORING SCENARIOS

### Scenario 25: Black Friday E-commerce
**Problem**: Need to know BEFORE site goes down.

**Decision**: **Golden Signals + Anomaly Detection**

**Why**:
Alert on:
- **Latency**: p99 > 500ms for 2 minutes → page slow
- **Errors**: 5xx rate > 1% for 1 minute → service failing
- **Saturation**: CPU > 80% for 5 minutes → need to scale
- **Traffic**: Sudden 50% drop → DNS/CDN issue

**Example alert**:
```yaml
Alert: HighErrorRate
Condition: rate(http_requests_total{status=~"5.."}[1m]) > 0.01
Severity: P1 (page engineer)
Action: Auto-scale checkout service
```

---

## QUICK DECISION REFERENCE TABLE

| When you need... | Use... | Why |
|-----------------|--------|-----|
| Distribute traffic | Layer 7 LB | Smart routing, sticky sessions |
| Long-lived connections | Layer 4 LB | Lower overhead |
| Multi-region failover | Global DNS LB | Route around outages |
| Single entry point for 20 services | API Gateway | Mobile app simplicity |
| Rate limiting per customer | API Gateway | Centralized enforcement |
| Serve video globally | CDN | Edge caching, low latency |
| Viral content | CDN with long TTL | Cache once, serve millions |
| Async task processing | RabbitMQ | Work queue pattern |
| Event streaming to multiple systems | Kafka | Pub/sub with replay |
| IoT data with loss tolerance | Redis Pub/Sub | Ultra-low latency |
| Cache product catalog | Cache-aside + TTL | Simple, 99% hit rate |
| Real-time scores | Write-through + Pub/Sub | Immediate consistency |
| User sessions | Redis with TTL | Auto-expiry, fast lookups |
| Banking transactions | PostgreSQL | ACID guarantees |
| Chat history | Cassandra | Write scaling, time-ordered |
| Social graph | Neo4j | Traversal performance |
| Report generation | Async with polling | User doesn't wait |
| Payment notifications | Webhook | Event-driven, efficient |
| Large team, multiple domains | Microservices | Independent deployment |
| Small startup MVP | Monolith | Simplicity, speed |
| Prevent outages | Golden Signals | Proactive alerting |

---

This decision framework will help you answer any "why would you use X?" question in interviews. Want me to drill down on any specific component or move to the next topic (e.g., security patterns, database internals, real-world case studies)?