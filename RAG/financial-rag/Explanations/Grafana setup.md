2.4GB is reasonable for a project with sentence-transformers + torch CPU. Good.

Now let's set up Grafana dashboards so the metrics are actually visible.

---

### Grafana Setup

Open `http://localhost:3000`, login with `admin/admin`.

---

### Step 1 — Add Prometheus as data source

1. Left sidebar → **Connections** → **Data Sources**
2. Click **Add data source**
3. Select **Prometheus**
4. Set URL to `http://prometheus:9090` (use service name, not localhost — they're on the same Docker network)
5. Click **Save & Test** — should say "Successfully queried"

---

### Step 2 — Create Dashboard

Left sidebar → **Dashboards** → **New** → **New Dashboard** → **Add visualization**

Build these 4 panels:

---

**Panel 1 — Total RAG Queries (Stat panel)**

```promql
rag_requests_total
```

- Visualization: `Stat`
- Title: `Total Queries`

---

**Panel 2 — RAG Inference Latency P95 (Gauge panel)**

```promql
histogram_quantile(0.95, rate(rag_inference_latency_seconds_bucket[5m]))
```

- Visualization: `Gauge`
- Title: `Latency P95`
- Unit: `seconds`

---

**Panel 3 — Request Rate (Time series)**

```promql
rate(http_requests_total[2m])
```

- Visualization: `Time series`
- Title: `Request Rate`

---

**Panel 4 — Failed Queries (Stat panel)**

```promql
rag_failed_requests_total
```

- Visualization: `Stat`
- Title: `Failed Queries`

---

### What's happening here — learn this

**`rate(metric[2m])`**

- Calculates per-second rate over last 2 minutes
- Used on counters — raw counter value isn't useful for graphs, rate is

**`histogram_quantile(0.95, ...)`**

- Calculates 95th percentile latency from histogram buckets
- P95 means 95% of requests are faster than this value
- Industry standard metric — interviewers expect you to know this

---

Make a few `/query` calls from Swagger, come back to Grafana and you should see the panels updating.

Once confirmed we move to Jenkins. Ready?