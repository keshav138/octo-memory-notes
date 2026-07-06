### 1. 429 Rate Limit at Regular Intervals — Thundering Herd Problem

- **Symptom**: 429 errors recurring at regular intervals (not random) suggests many clients/requests hitting the API **simultaneously in sync**, rather than a genuine sustained overload.
- **Thundering herd cause**: often triggered by synchronized retry logic — e.g., all clients retry after a fixed delay (say every 60s), so failed requests pile up and re-fire together each interval, repeatedly exceeding the rate limit at the same moments, then going quiet, then spiking again.
- **Fix**:
- **Exponential backoff with jitter** — add randomized delay so retries spread out instead of firing in lockstep.
- **Client-side rate limiting/queuing** — throttle request rate proactively rather than reactively hitting limits and retrying.
- **Request batching** to reduce total call volume.

---

### 2. Client-Side vs Server-Side Rate Limiting — Why Client-Side Isn't Redundant

- **Server-side rate limiting**: protects the server from overload; enforces the actual hard limit.
- **Client-side rate limiting**: proactively paces outgoing requests _before_ they hit the server.
- **Junior's argument**: "server already enforces the limit, so client-side is redundant."
- **Why they're wrong**:

1. **Wasted requests** — without client-side throttling, requests get sent, rejected (429), and must be retried — burning latency, connection overhead, and sometimes cost (some APIs charge or count rejected calls against quota).
2. **Cascading retries** — server-side limiting alone doesn't prevent the thundering herd problem above; client-side pacing (with jitter) is what actually prevents synchronized retry storms.
3. **Better UX/predictability** — client-side limiting lets you smooth request rate proactively (e.g., queue and drip-feed) rather than bursty send-fail-retry cycles, which server-side limiting alone can't provide since it only reacts after the fact.
4. **Multi-tenant fairness** — if a client shares a rate-limited API key across multiple internal services, client-side limiting can fairly allocate the quota internally before ever reaching the server.

---

### 3. Customer Callback → Architectural Pattern

- "Callback" pattern here likely refers to the **webhook/callback URL pattern**: instead of a client polling for a long-running task's result, the client provides a callback URL, and the server **pushes** the result to that URL once processing completes.
- **Why used**: avoids polling overhead (repeated requests checking "is it done yet"), suited for long-running async agentic/LLM tasks (e.g., batch processing, long agent runs) where the response time is unpredictable and polling doesn't scale well.
- **Architecture**: client submits request → server queues job, returns immediate ack (job ID) → server processes async → server POSTs result to client's registered callback URL when done. Often paired with a retry/backoff mechanism on the callback delivery itself (in case client's endpoint is briefly down) and idempotency keys to prevent duplicate processing if retried.

---

### 4. MCP Using stdio — Prod Requires Simultaneous Connections, Change Requirements

- **stdio transport in MCP**: the client spawns the MCP server as a **local subprocess** and communicates via stdin/stdout. This is inherently **single-connection, single-process** — one client process, one server process, tightly coupled 1:1.
- **Prod requirement**: multiple simultaneous client connections (many users hitting the same MCP-backed tool concurrently).
- **Why stdio breaks down**: stdio ties one server process to one client session; it doesn't natively support multiple concurrent remote clients talking to a shared server instance — spawning a new subprocess per user doesn't scale well (process overhead, no shared state/connection pooling, no network-accessible endpoint).
- **Required change**: switch to a **network-based transport** — MCP's **HTTP+SSE (or streamable HTTP)** transport, which runs the server as a standalone network service that can accept multiple concurrent client connections over HTTP, rather than a locally-spawned subprocess per client.

---

Ready for **Group 8 — Multi-Provider / Tool-Use Abstraction** next.