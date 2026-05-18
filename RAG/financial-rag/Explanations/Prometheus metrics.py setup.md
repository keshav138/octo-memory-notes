Let's start with instrumentation first — adding metrics to the FastAPI app before containerizing.

---

### Install

```powershell
pip install prometheus-fastapi-instrumentator prometheus-client
```

---

### `app/monitoring/metrics.py`

```python
from prometheus_client import Histogram, Counter
from prometheus_fastapi_instrumentator import Instrumentator

# custom metrics
RAG_LATENCY = Histogram(
    name="rag_inference_latency_seconds",
    documentation="Time taken for RAG chain to return an answer",
    buckets=[0.5, 1.0, 2.0, 5.0, 10.0, 20.0, 30.0]  # realistic for LLM calls
)

RAG_REQUESTS_TOTAL = Counter(
    name="rag_requests_total",
    documentation="Total number of RAG queries made"
)

RAG_FAILED_REQUESTS = Counter(
    name="rag_failed_requests_total",
    documentation="Total number of failed RAG queries"
)

DOCUMENTS_INGESTED = Counter(
    name="documents_ingested_total",
    documentation="Total number of document chunks ingested into ChromaDB"
)

def setup_instrumentator(app):
    """
    Sets up automatic HTTP metrics on all endpoints.
    Exposes /metrics endpoint for Prometheus to scrape.
    """
    Instrumentator(
        should_group_status_codes=True,
        should_ignore_untemplated=True,
        should_respect_env_var=False,
        should_instrument_requests_inprogress=True,
        excluded_handlers=["/metrics", "/health"]
    ).instrument(app).expose(app)
```

---

### Update `app/main.py`

Two things to add — import and wire up metrics:

```python
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from app.rag.loader import load_and_chunk_from_bytes
from app.rag.vectorstore import ingest_chunks, reset_vectorstore
from app.rag.chain import query_rag
from app.monitoring.metrics import (
    setup_instrumentator,
    RAG_LATENCY,
    RAG_REQUESTS_TOTAL,
    RAG_FAILED_REQUESTS,
    DOCUMENTS_INGESTED
)
import time

app = FastAPI(
    title="Financial RAG API",
    description="RAG pipeline over SEC financial filings",
    version="1.0.0"
)

setup_instrumentator(app)

# --- Request/Response Models ---

class QueryRequest(BaseModel):
    question: str

class QueryResponse(BaseModel):
    answer: str
    sources: list
    latency_ms: float

class IngestResponse(BaseModel):
    message: str
    chunks_stored: int

# --- Endpoints ---

@app.get("/health")
def health_check():
    return {"status": "ok"}


@app.post("/ingest", response_model=IngestResponse)
async def ingest_document(file: UploadFile = File(...)):
    if not file.filename.endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF files are supported")

    try:
        file_bytes = await file.read()
        chunks = load_and_chunk_from_bytes(file_bytes, file.filename)
        count = ingest_chunks(chunks)
        DOCUMENTS_INGESTED.inc(count)   # track chunks ingested
        return IngestResponse(
            message=f"Successfully ingested {file.filename}",
            chunks_stored=count
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/query", response_model=QueryResponse)
async def query_document(request: QueryRequest):
    if not request.question.strip():
        raise HTTPException(status_code=400, detail="Question cannot be empty")

    RAG_REQUESTS_TOTAL.inc()

    try:
        start = time.time()
        result = query_rag(request.question)
        latency = time.time() - start

        RAG_LATENCY.observe(latency)    # record in histogram

        return QueryResponse(
            answer=result["answer"],
            sources=result["sources"],
            latency_ms=round(latency * 1000, 2)
        )
    except Exception as e:
        RAG_FAILED_REQUESTS.inc()
        raise HTTPException(status_code=500, detail=str(e))


@app.delete("/reset")
def reset_documents():
    try:
        reset_vectorstore()
        return {"message": "Vector store cleared successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

---

### What's happening here — learn this

**Metric types — know these for interviews:**

|Type|Use case|Our usage|
|---|---|---|
|`Counter`|Only goes up, tracks totals|total requests, failures, chunks ingested|
|`Histogram`|Tracks distribution of values, buckets|RAG latency|
|`Gauge`|Can go up and down, current state|e.g. active connections (not used here)|
|`Summary`|Like histogram but calculates quantiles client-side|less common|

**Why these bucket values for latency:**

- LLM calls are slow — 0.5s to 30s is realistic
- Buckets let Prometheus calculate percentiles (p50, p95, p99) later in Grafana
- Interview point: _"I chose buckets based on realistic LLM response times, not default HTTP buckets"_

**`Instrumentator` auto-gives you:**

- `http_requests_total` — per endpoint, method, status code
- `http_request_duration_seconds` — latency histogram for all endpoints
- `/metrics` endpoint automatically — no extra code needed

---

### Quick test

Run the app:

```powershell
uvicorn app.main:app --reload --port 8000
```

Hit a few endpoints, then visit `http://localhost:8000/metrics` — you should see raw Prometheus metrics. Look for:

- `rag_requests_total`
- `rag_inference_latency_seconds_bucket`
- `http_requests_total`

Once confirmed, we move to `docker-compose.yml` — spinning up Prometheus + Grafana alongside the app.