This snippet of code introduces **monitoring and observability** to your RAG pipeline.

Once your RAG pipeline is running as a FastAPI web server, you need a way to know if it's healthy, how fast it is responding, and how many people are using it. This code sets up **Prometheus metrics**.

Prometheus is an industry-standard open-source monitoring system. It works by "scraping" (visiting) a special URL on your server—usually `http://localhost:8000/metrics`—where it collects numbers about your application's performance over time. You can then plug those numbers into a dashboard tool like **Grafana** to draw real-time graphs of your system.

Here is a breakdown of what every part of this monitoring setup is doing.

---

## Part 1: Metric Types (Counter vs. Histogram)

You are importing two primary types of metrics from the core `prometheus_client` library:

- **`Counter`**: A metric that **only goes up**. Think of it like an odometer in a car or a turnstile at a stadium. It tracks how many times an event has happened since the server booted up. If the server restarts, it resets to zero.
    
- **`Histogram`**: A metric used to measure the **duration or size** of events. It doesn’t just track _how many_ times something happened; it tracks _how long_ it took. It organizes those durations into configurable "buckets" so you can calculate things like average response times or your 95th percentile latency.
    

---

## Part 2: Your Custom RAG Metrics

You define four global metric trackers to capture the exact business logic of a RAG pipeline.

Python

```
RAG_LATENCY = Histogram(
    name="rag_inference_latency_seconds",
    documentation="Time taken for RAG chain to return an answer",
    buckets=[0.5, 1.0, 2.0, 5.0, 10.0, 20.0, 30.0]
)
```

- **What it tracks:** How long your user waits for an answer. Because LLMs take time to stream or generate words, standard web metrics aren't enough.
    
- **`buckets=[...]`**: When your code records a latency, Prometheus checks which bucket it falls into. For example, if an inference takes `1.4 seconds`, it falls into the `< 2.0` bucket. This makes it incredibly easy to draw graphs showing: _"90% of our users get an answer in under 2 seconds."_
    

Python

```
RAG_REQUESTS_TOTAL = Counter(
    name="rag_requests_total",
    documentation="Total number of RAG queries made"
)

RAG_FAILED_REQUESTS = Counter(
    name="rag_failed_requests_total",
    documentation="Total number of failed RAG queries"
)
```

- **`RAG_REQUESTS_TOTAL`**: Increments every time a user triggers your `/query` endpoint.
    
- **`RAG_FAILED_REQUESTS`**: Increments if your `try/except` block catches a network failure or a Groq API outage.
    
- **Why use both?** By comparing these two numbers in a graph, you can calculate your **error rate** (e.g., `Failed Requests / Total Requests`). If your error rate climbs above 1%, you know your API key might have expired or Groq is experiencing downtime.
    

Python

```
DOCUMENTS_INGESTED = Counter(
    name="documents_ingested_total",
    documentation="Total number of document chunks ingested into ChromaDB"
)
```

- **What it tracks:** The size of your database. Every time someone uploads a PDF to `/ingest`, you will increment this by the number of chunks stored. It helps you monitor how fast your storage footprint is growing.
    

---

## Part 3: The Automatic Endpoint Instrumentator

Manually adding tracking code to every single URL route is tedious. The `prometheus_fastapi_instrumentator` library automates this for all standard web traffic.

Python

```
def setup_instrumentator(app):
    Instrumentator(
        should_group_status_codes=True,
        should_ignore_untemplated=True,
        should_respect_env_var=False,
        should_instrument_requests_inprogress=True,
        excluded_handlers=["/metrics", "/health"]
    ).instrument(app).expose(app)
```

This function wraps around your `app = FastAPI()` instance and configures the automatic monitoring behavior:

- **`should_group_status_codes=True`**: Groups HTTP responses by their hundreds place (`2xx` for success, `4xx` for user errors, `5xx` for server crashes). This prevents your database from being flooded with a million separate tracking entries for every unique status code.
    
- **`should_instrument_requests_inprogress=True`**: Tracks how many requests are actively hanging open _right now_. If your LLM gets bogged down, this metric will spike up, alerting you that your server is bottlenecked.
    
- **`excluded_handlers=["/metrics", "/health"]`**: Tells the instrumentator **not** to monitor the monitoring endpoints themselves. You don't want Prometheus scraping the server to count as a "user request."
    
- **`.instrument(app)`**: Attaches invisible middleware to all your routes (like `/query` and `/ingest`) to secretly log request count and time elapsed.
    
- **`.expose(app)`**: **This is the magic line.** It automatically creates a brand-new endpoint at `/metrics` on your server.
    

---

## How You Actually Use This in Your Project

To make these metrics actually work, you need to do two quick things:

### 1. Register it at startup in your `main.py`

Python

```
from app.rag.monitoring import setup_instrumentator # Assuming you named the file monitoring.py

app = FastAPI(...)

# Call it right after initializing your app
setup_instrumentator(app)
```

### 2. Increment your custom counters inside your endpoints

Inside your existing endpoints, you will explicitly increment your custom counters. For example, in your `/query` endpoint:

Python

```
from app.rag.monitoring import RAG_REQUESTS_TOTAL, RAG_FAILED_REQUESTS, RAG_LATENCY

@app.post("/query")
def query_document(request: QueryRequest):
    RAG_REQUESTS_TOTAL.inc() # Increment the traffic counter by 1
    
    try:
        start_time = time.time()
        result = query_rag(request.question)
        
        # Observe the latency in seconds
        RAG_LATENCY.observe(time.time() - start_time) 
        return ...
    except Exception as e:
        RAG_FAILED_REQUESTS.inc() # Increment the error counter if it breaks
        raise HTTPException(...)
```

When you boot up your server and visit `http://localhost:8000/metrics` in your web browser, you won't see a clean webpage. Instead, you'll see a plain text wall of key-value pairs representing the exact real-time health data of your production RAG system!