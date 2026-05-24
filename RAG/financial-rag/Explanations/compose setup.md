Exactly — that `/metrics` page is just a raw scrape endpoint, it's not meant for humans to read. Prometheus collects from it, Grafana visualizes it. That wall of text becomes clean graphs.

The flow is:

```
/metrics (raw) → Prometheus (stores + queries) → Grafana (dashboards)
```

Now let's containerize everything together.

---

### `Dockerfile`

```dockerfile
FROM python:3.11.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

### Generate `requirements.txt` first

```powershell
pip freeze > requirements.txt
```

---

### `prometheus.yml`

Create this in root:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "financial-rag"
    static_configs:
      - targets: ["app:8000"]  # "app" is the docker-compose service name
```

---

### `docker-compose.yml`

```yaml
version: "3.8"

services:
  app:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - ./chroma_db:/app/chroma_db  # persist ChromaDB across container restarts
    env_file:
      - .env
    depends_on:
      - prometheus

  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.retention.time=7d"  # keep 7 days of metrics

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_SECURITY_ADMIN_USER=admin
    depends_on:
      - prometheus

volumes:
  prometheus_data:
  grafana_data:
```

---

### What's happening here — learn this

**`volumes` in compose:**

- `./chroma_db:/app/chroma_db` — maps local folder into container, ChromaDB persists even if container dies
- `prometheus_data` and `grafana_data` are named volumes — Docker manages them, data survives container restarts

**`env_file: .env`**

- Passes your API keys into the container without hardcoding — never put secrets in Dockerfile or compose directly

**`depends_on`**

- Controls startup order — app waits for prometheus, grafana waits for prometheus
- Doesn't guarantee the service is ready, just that it's started — fine for our use case

**`--storage.tsdb.retention.time=7d`**

- Prometheus keeps 7 days of metrics data — good default for dev/small project

---

### Run it

```powershell
docker-compose up --build
```

Then verify:

- `http://localhost:8000/docs` — FastAPI
- `http://localhost:8000/metrics` — raw metrics
- `http://localhost:9090` — Prometheus UI
- `http://localhost:3000` — Grafana (login: admin/admin)

---

### Quick Prometheus sanity check

In Prometheus UI (`localhost:9090`), go to Graph tab and query:

```
rag_requests_total
```

Make a few `/query` calls from Swagger, refresh — you should see the counter incrementing.

Let me know once all four services are up and we'll set up the Grafana dashboard.