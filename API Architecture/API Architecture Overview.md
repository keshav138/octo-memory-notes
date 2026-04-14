Excellent follow-up. API design is often the differentiator between a junior and mid-level/senior backend engineer. Here are **comprehensive notes** covering your requested topics plus must-know extras.

---

## 1. API Design & Architecture – Must-Know Fundamentals

### Core API Types

| Type | Protocol | Use Case |
|------|----------|----------|
| **REST** | HTTP | CRUD, web APIs |
| **GraphQL** | HTTP/WS | Complex queries, mobile, over-fetching avoidance |
| **gRPC** | HTTP/2 | Microservices, high performance, polyglot |
| **WebSocket** | WS | Real-time, bidirectional |
| **Webhook** | HTTP | Event-driven, async callbacks |

**Interview tip**: Know REST deeply; mention others as tradeoffs.

### API-First Design Principles
- **Contract-first** – Define OpenAPI/Swagger before coding.
- **Backward compatibility** – Never break clients without versioning.
- **Statelessness** – Each request contains all necessary info.

---

## 2. REST Principles (Roy Fielding's constraints)

| Principle | Explanation | Example |
|-----------|-------------|---------|
| **Resource-based** | Everything is a resource (noun, not verb) | `/users/123` not `/getUser?id=123` |
| **HTTP methods** | Use verbs semantically | `GET`, `POST`, `PUT`, `PATCH`, `DELETE` |
| **Stateless** | No client context stored on server | Session data in client (JWT) |
| **Cacheable** | Responses mark cacheability | `Cache-Control`, `ETag` |
| **Uniform interface** | Consistent naming, formats | `/users`, `/users/123/posts` |
| **Layered system** | Proxies, gateways, load balancers | Client unaware of internals |

### Common REST anti-patterns (avoid!)
```
❌ /getAllUsers
❌ /createNewUser
❌ /user/delete/123
❌ Nested > 3 levels: /api/v1/schools/1/classes/2/students/3/attendance/4
✅ /users (GET, POST, DELETE, PUT)
```

---

## 3. Idempotency, Status Codes, Versioning, HATEOAS

### Idempotency (Critical for reliability)

**Definition**: Multiple identical requests produce same result as one request.

| Method | Idempotent? | Safe? | Notes |
|--------|-------------|-------|-------|
| `GET` | ✅ | ✅ | Read-only |
| `PUT` | ✅ | ❌ | Full replace – same data, same result |
| `DELETE` | ✅ | ❌ | Deleting already deleted = 404 or 204 |
| `POST` | ❌ | ❌ | Creates new resource each time |
| `PATCH` | ❌ | ❌ | Partial update – can be idempotent if designed |

**Implementation**: Use `Idempotency-Key` header for `POST`/`PATCH`
```http
POST /payments
Idempotency-Key: uuid-1234-5678
```
Server stores key+response for 24h; duplicate keys return cached response.

### HTTP Status Codes – Must memorize

| Category             | Codes                                                                                                   | Meaning            |
| -------------------- | ------------------------------------------------------------------------------------------------------- | ------------------ |
| **2xx Success**      | 200 OK, 201 Created, 202 Accepted (async), 204 No Content                                               | All good           |
| **3xx Redirect**     | 301 Moved Permanently, 304 Not Modified (caching)                                                       | Client must resend |
| **4xx Client Error** | 400 Bad Request, 401 Unauthorized, 403 Forbidden, 404 Not Found, 409 Conflict, 422 Unprocessable Entity | Client's fault     |
| **5xx Server Error** | 500 Internal Error, 502 Bad Gateway, 503 Service Unavailable, 504 Gateway Timeout                       | Server's fault     |

---
**400 Status Errors Reasons**
Common Causes

- **Malformed URL Syntax:** The web address contains typos, illegal characters (like extra spaces or improper symbols), or incorrect percent-encoding.
- **Corrupted Browser Cache or Cookies:** Your browser may be sending outdated or "broken" data (such as an expired session cookie) that the server no longer recognizes.
- **Oversized Headers or Cookies:** If the request headers—often bloated by too many cookies—exceed the server's allowed size limit, it will trigger this error.
- **File Size Too Large:** Attempting to upload a file that exceeds the server's configured maximum upload limit.
- **DNS Issues:** Your computer's local DNS cache might be pointing to an outdated or incorrect IP address for the website.
- **Conflicting Extensions:** Browser add-ons (like ad blockers or VPN plugins) can sometimes modify request headers in a way that the server considers invalid.


**Interview scenario**: What status for validation failure? → `400` or `422` (if format is correct but semantics fail)

### Versioning Strategies

| Strategy | Example | Pros/Cons |
|----------|---------|------------|
| **URL path** | `/v1/users` | Simple, visible, caching works |
| **Custom header** | `Accept: version=1` | Clean URL, harder to discover |
| **Content negotiation** | `Accept: application/vnd.myapi.v1+json` | RESTful, complex |
| **Query param** | `/users?version=1` | Simple but ugly, caching issues |

**Best practice**: URL versioning for public APIs; header for internal.

### HATEOAS (Hypermedia as Engine of Application State)

**Definition**: Server tells client what actions are possible next.

**Example response**:
```json
{
  "id": 123,
  "name": "John",
  "links": [
    { "rel": "self", "href": "/users/123", "method": "GET" },
    { "rel": "update", "href": "/users/123", "method": "PUT" },
    { "rel": "delete", "href": "/users/123", "method": "DELETE" },
    { "rel": "posts", "href": "/users/123/posts", "method": "GET" }
  ]
}
```

**Interview note**: HATEOAS is rarely fully implemented; mention it as "level 3 Richardson Maturity Model" to show depth.

---

## 4. Request/Response Lifecycle (Full Stack)

```
Client → Load Balancer → API Gateway → Middleware → Router → Controller → Service → Repository → DB
         ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← Response
```

### Detailed steps:
1. **Client** sends HTTP request
2. **API Gateway** – rate limiting, auth, routing
3. **Middleware** (express, Django, Spring) – logging, parsing, CORS, compression
4. **Router** – matches URL + method to handler
5. **Controller** – extracts params, body, headers
6. **Service** – business logic
7. **Repository** – data access
8. **Response** – serialized (JSON/Protobuf) + status code

### Serialization formats

| Format | Pros | Cons |
|--------|------|------|
| **JSON** | Human-readable, universal | Verbose, no schema by default |
| **Protobuf** | Small, fast, schema-enforced | Binary, not human-readable |
| **MessagePack** | Binary JSON alternative | Less tooling |
| **XML** | Legacy enterprise | Heavy, outdated |

**Best practice**: JSON for public REST APIs; Protobuf for gRPC.

### Error handling patterns

**Consistent error response structure**:
```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Try again in 30 seconds",
    "details": { "retry_after": 30, "limit": 100 },
    "trace_id": "abc-123-def"
  }
}
```

**Must-have**: Include `trace_id` for debugging.

---

## 5. Authentication & Authorization Flows

### Session vs Token (JWT)

| Aspect          | Session (Stateful)        | JWT Token (Stateless)        |
| --------------- | ------------------------- | ---------------------------- |
| **Storage**     | Server (Redis/memcached)  | Client (localStorage/cookie) |
| **Scalability** | Need shared session store | No server storage            |
| **Revocation**  | Easy (delete session)     | Hard (need blacklist)        |
| **Payload**     | Small reference           | Can contain user data        |
| **Size**        | ~32 bytes                 | Often >1KB                   |

### JWT Structure (Base64 encoded)
```
Header.Payload.Signature
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEyMywicm9sZSI6ImFkbWluIn0.sflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```
- **Header** – algorithm, type
- **Payload** – claims (user, roles, exp, iat, jti)
- **Signature** – verifies integrity

### OAuth2 Simplified (Authorization framework) (Open Authorization)

**Roles**:
- Resource Owner (user)
- Client (app requesting access)
- Authorization Server (login + consent)
- Resource Server (API)

**Grant types** (most common):
| Grant | Use Case |
|-------|----------|
| **Authorization Code** | Web apps (most secure) |
| **PKCE** | Mobile/SPA (no client secret) |
| **Client Credentials** | Machine-to-machine |
| **Refresh Token** | Get new access token without re-login |

**Basic flow (Authorization Code)**:
```
1. User → Client: "Login with Google"
2. Client → Auth Server: Redirect with client_id, redirect_uri
3. Auth Server → User: Login + consent
4. Auth Server → Client: Authorization code
5. Client → Auth Server: Exchange code + client_secret for tokens
6. Auth Server → Client: access_token + refresh_token
7. Client → Resource Server: access_token in Authorization header
```

### Refresh Token Rotation (Security best practice)

**Problem**: Stolen refresh token gives indefinite access.

**Solution**: Each refresh issues new refresh token (one-time use).

**Flow**:
```
Initial login → RT1 + AT1
Use RT1 → Get RT2 + AT2, invalidate RT1
Use RT2 → Get RT3 + AT3, invalidate RT2
```

**Detection**: If RT1 used again → attacker detected; revoke user's all tokens.

---

## 6. Rate Limiting & Throttling

### Why rate limit?
- Prevent abuse (DDoS, brute force)
- Fair usage across tenants
- Cost control (paid APIs)
- Backend protection

### Algorithms – Must know

| Algorithm | How it works | Pros | Cons |
|-----------|--------------|------|------|
| **Token Bucket** | Tokens added at fixed rate; each request consumes token | Burst allowed, simple | Memory per key |
| **Leaky Bucket** | Requests queue at constant outflow | Smooth traffic | No bursting |
| **Fixed Window** | Counter resets every minute | Easy to implement | Spike at boundaries |
| **Sliding Window** | Rolling time window | Accurate | More memory/compute |
| **Sliding Log** | Store timestamps of requests | Most accurate | High memory |

**Interview favorite**: Token Bucket (burst-friendly) or Sliding Window (accurate).

### Implementation with Redis (Lua script for atomicity)

**Token Bucket in Redis**:
```lua
-- KEYS[1] = bucket_key
-- ARGV[1] = tokens_to_add_per_second
-- ARGV[2] = bucket_capacity
-- ARGV[3] = requested_tokens (usually 1)
-- ARGV[4] = current_time

local bucket = redis.call('hmget', KEYS[1], 'tokens', 'last_refill')
local tokens = tonumber(bucket[1]) or ARGV[2]
local last_refill = tonumber(bucket[2]) or ARGV[4]

local delta = math.max(0, ARGV[4] - last_refill)
local new_tokens = math.min(ARGV[2], tokens + delta * ARGV[1])

if new_tokens >= tonumber(ARGV[3]) then
    new_tokens = new_tokens - tonumber(ARGV[3])
    redis.call('hmset', KEYS[1], 'tokens', new_tokens, 'last_refill', ARGV[4])
    return {1, new_tokens}
else
    return {0, new_tokens}
end
```

**Headers to return** (RFC compliant):
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 42
X-RateLimit-Reset: 1640995200
Retry-After: 30  (when rate limited)
```

### Rate limiting strategies by level

| Level | Identified by | Example |
|-------|---------------|---------|
| **Global** | IP address | 1000 req/min per IP |
| **User** | API key / JWT subject | 100 req/min per user |
| **Endpoint** | URL + method | `/login` = 5 req/min |
| **Tenant** | Organization ID | 10k req/min per tenant |

---

## 7. Must-Know API Interview Scenarios

### Scenario 1 – Design a file upload API (1GB files)
**Considerations**:
- Use `multipart/form-data` or presigned URLs (S3)
- Implement resumable uploads (Tus protocol or custom byte ranges)
- Return `202 Accepted` + `Location` header for async processing
- Use chunking + checksums for integrity

### Scenario 2 – Your API is slow under load
**Debugging steps**:
1. Check rate limiting – are you throttling?
2. Add pagination (`cursor` > `offset/limit`)
3. Implement caching (Redis, CDN, ETags)
4. Move sync operations to async (webhook + status endpoint)
5. Add indexes on filtered fields

### Scenario 3 – Breaking change needed
**Options** (in order of preference):
1. Add new optional field (backward compatible)
2. Deprecate old field (`Deprecation` header)
3. New version (`/v2/resource`)
4. Sunset old version (6+ months notice)

---

## 8. Quick Cheat Sheet for Interviews

| Topic | Key phrase |
|-------|-------------|
| REST | "Resources over actions, HTTP semantics, stateless" |
| Idempotency | "Same request multiple times = same outcome; use idempotency keys for POST" |
| Status codes | "2xx success, 3xx redirect, 4xx client, 5xx server" |
| Versioning | "URL path for simplicity, headers for purity" |
| JWT | "Stateless, self-contained, but hard to revoke" |
| OAuth2 | "Authorization framework, not authentication; use PKCE for mobile" |
| Refresh rotation | "One-time use refresh tokens detect theft" |
| Rate limiting | "Token bucket for bursts, sliding window for accuracy; implement with Redis Lua" |
| Error handling | "Consistent structure with trace_id; never expose internals" |

---

**Next up**: Let me know when you're ready for caching (Redis, CDN, cache invalidation), message queues (RabbitMQ, Kafka), or system design patterns.