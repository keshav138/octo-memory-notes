Here’s a comprehensive overview of **Prometheus**, from its core purpose to practical scripting.

---

## What Prometheus Actually Is

Prometheus is an **open-source systems monitoring and alerting toolkit** originally built at SoundCloud. It collects and stores metrics as time-series data, meaning every data point is recorded with a timestamp and optional key-value labels (e.g., `method="GET"`, `status="500"`).

Unlike traditional monitoring (e.g., Nagios) that *pushes* data or just checks “up/down,” Prometheus **pulls** metrics from targets at regular intervals via HTTP. It’s designed for reliability in dynamic cloud environments.

---

## What It Does (Core Mechanics)

1. **Scrapes metrics** from instrumented targets (applications, databases, servers, etc.) using a pull model.
2. **Stores all data** locally on disk (or remote storage) with high-performance time-series indexing.
3. **Queries** metrics with a functional language called **PromQL** (Prometheus Query Language).
4. **Triggers alerts** based on rules defined against those queries.
5. **Visualizes** via its built-in expression browser or integrates with Grafana (most common).

---

## Best Use Cases

| Use Case | Why Prometheus Excels |
|----------|------------------------|
| **Microservices & Kubernetes** | Native service discovery, container-aware metrics, seamless K8s integration. |
| **Application performance monitoring** | Track request rates, error rates, latency, resource usage. |
| **Infrastructure monitoring** | Servers, databases, message queues, load balancers. |
| **Custom business metrics** | e.g., “orders per minute,” “active users” — if it’s numeric and time-stamped. |
| **Multi-cloud & hybrid** | Single tool across AWS, GCP, on-prem. |

**What it’s NOT best for**:
- Long-term data retention (>months) without external storage.
- High-cardinality logging or events (use Loki for logs).
- Complex anomaly detection/ML (use specialized tools).

---

## Why Choose Prometheus Over Others?

- **Simple, reliable operation** – one binary, no external dependencies (except optional storage).
- **Powerful query language (PromQL)** – can calculate percentiles, rates, predictions over time.
- **No configuration push** – targets are defined via static files or service discovery.
- **Active ecosystem** – exporters for Redis, PostgreSQL, Nginx, AWS, etc.; native integration with Grafana, Alertmanager, Kubernetes.

---

## Slight Intro into Writing Prometheus Scripts

“Scripts” in Prometheus typically mean **recording rules** (precompute expensive queries) and **alerting rules**. These are written in YAML and loaded into Prometheus.

### Basic Rule File Structure
```yaml
groups:
  - name: example_rules
    interval: 30s   # evaluation frequency
    rules:
      - record: job:http_requests_per_second
        expr: rate(http_requests_total[5m])

      - alert: HighRequestLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
        for: 2m
        annotations:
          summary: "High latency on {{ $labels.job }}"
```

### Key Elements
- **`record`** – gives a name to a frequently used PromQL expression.
- **`alert`** – defines an alert condition.
- **`expr`** – PromQL expression that returns a vector.
- **`for`** – how long condition must be true before firing (prevents flapping).

### Simple PromQL Examples (to use in rules or ad-hoc)

```promql
# Memory usage percentage
(1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100

# 5-minute average request rate per endpoint
rate(http_requests_total[5m])

# 99th percentile request latency
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))

# Prediction of disk space exhaustion in 4 hours
predict_linear(node_filesystem_free_bytes[1h], 4*3600) < 0
```

### How to Load & Test Rules
1. Add your rule file to `prometheus.yml` under `rule_files:`.
2. Check syntax:  
   `promtool check rules rules.yml`
3. Reload Prometheus via SIGHUP or `/-/reload` endpoint (if enabled).

---

## Typical Architecture

```
Application/Exporters  →  Prometheus (scrapes)  →  Storage (local/remote)
                             ↑
Alertmanager ← alerts   ← Prometheus rules
                             ↓
                          Grafana (visualization)
```

---

## Summary Table

| Feature | Detail |
|---------|--------|
| **Data model** | Time-series with label-value pairs |
| **Pull vs push** | Pull (HTTP) — optional push gateway for short-lived jobs |
| **Query language** | PromQL (functional, powerful) |
| **Storage** | Local TSDB, supports remote read/write |
| **Scaling** | Sharding & federation (best for ~hundreds of nodes) |
| **Alerting** | Separate Alertmanager (deduplication, grouping, routing) |

If you’d like a hands-on example (e.g., instrumenting a Python app with Prometheus client library + writing a custom rule), let me know.