Let's build `main.py` — the FastAPI layer wrapping the RAG pipeline.

---

### `app/main.py`

```python
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from app.rag.loader import load_and_chunk_from_bytes
from app.rag.vectorstore import ingest_chunks, reset_vectorstore
from app.rag.chain import query_rag
import time

app = FastAPI(
    title="Financial RAG API",
    description="RAG pipeline over SEC financial filings",
    version="1.0.0"
)

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

    try:
        start = time.time()
        result = query_rag(request.question)
        latency_ms = round((time.time() - start) * 1000, 2)

        return QueryResponse(
            answer=result["answer"],
            sources=result["sources"],
            latency_ms=latency_ms
        )
    except Exception as e:
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

**Pydantic models**

- `BaseModel` for request/response validation — FastAPI auto-validates and auto-generates OpenAPI docs
- If request doesn't match the model, FastAPI returns a 422 automatically — no manual validation needed

**`UploadFile`**

- FastAPI's way of handling file uploads
- `await file.read()` reads bytes asynchronously
- We pass bytes to `load_and_chunk_from_bytes` which handles the temp file internally

**Latency tracking**

- Manual `time.time()` for now — we'll replace this with Prometheus histograms later
- Good to have in response so frontend/client can see it

**Error handling pattern**

- All endpoints wrapped in try/except
- `HTTPException` with proper status codes — 400 for bad input, 500 for internal errors

---

### Run it

```powershell
uvicorn app.main:app --reload --port 8000
```

Then open `http://localhost:8000/docs` — FastAPI auto-generates Swagger UI, test all endpoints from there directly.

Test flow:

1. Hit `/health` — should return `{"status": "ok"}`
2. Upload your PDF via `/ingest`
3. Ask a question via `/query`
4. Hit `/reset` to clear

Let me know once it's working and we move to Prometheus instrumentation.