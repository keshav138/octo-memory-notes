This script represents **Phase 5: Deployment (The API Layer)**.

Up until this point, all your RAG logic was just a collection of Python functions sitting on your hard drive. This code uses **FastAPI** to wrap those functions into a living, breathing web server. It creates URLs (endpoints) that a frontend website, mobile app, or another developer can send data to via the internet.

Here is the line-by-line breakdown of how your API layer functions.

---

## Part 1: Imports and Core Setup

Python

```
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
```

- **`FastAPI(...)`**: Instantiates your core web application. This handles incoming network traffic, automatically validates incoming data types, and inherently builds a beautiful, interactive documentation page (accessible at `/docs` when your server runs).
    
- **`UploadFile` and `File`**: Specialized FastAPI tools designed to handle binary files uploaded over the internet from a user's web browser.
    
- **`HTTPException`**: A structured way to crash a request on purpose when something goes wrong (e.g., if a user sends a text file instead of a PDF, you send back a `400 Bad Request` error status code).
    
- **`BaseModel`**: Imported from **Pydantic**. It allows you to build strict strict schemas for what incoming and outgoing JSON data structures must look like.
    
- **Your RAG Modules**: This is where you import your hard work! You pull `load_and_chunk_from_bytes` from your data loader file, `ingest_chunks` and `reset_vectorstore` from your vector database setup, and `query_rag` from your modern LCEL chain.
    

---

## Part 2: Pydantic Data Contract Structures

Before writing endpoints, you define exactly what shape your incoming requests and outgoing responses will take.

Python

```
class QueryRequest(BaseModel):
    question: str

class QueryResponse(BaseModel):
    answer: str
    sources: list
    latency_ms: float

class IngestResponse(BaseModel):
    message: str
    chunks_stored: int
```

- **`QueryRequest`**: Dictates that when a user wants to ask a question, they _must_ send a JSON body matching exactly: `{"question": "some text"}`. If they send anything else, FastAPI rejects it instantly before it ever hits your Python logic.
    
- **`QueryResponse`**: Guarantees that when your AI returns an answer, the frontend will always receive a clean structured schema containing the text `answer`, a list of `sources`, and a `latency_ms` float tracking how fast the system performed.
    

---

## Part 3: The API Endpoints (The Workhorses)

### 1. The Health Check (GET `/health`)

Python

```
@app.get("/health")
def health_check():
    return {"status": "ok"}
```

- **What it does:** A super fast, lightweight endpoint used by cloud platforms (like Docker or AWS) to periodically ping your server to verify that it is still alive and running smoothly.
    

### 2. Document Upload (POST `/ingest`)

This endpoint bridges the internet with your ingestion pipeline.

Python

```
@app.post("/ingest", response_model=IngestResponse)
async def ingest_document(file: UploadFile = File(...)):
    if not file.filename.endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF files are supported")
```

- **`@app.post(...)`**: Tells the server that this URL accepts `POST` requests, which are used when you want to modify state or submit heavy data like files.
    
- **`file: UploadFile = File(...)`**: Sets up a multi-part form field requiring a physical file input.
    
- **`if not file.filename.endswith(...)`**: Simple guardrails. If a user tries to upload an image or text file, it intercepts them early and returns a `400` error code.
    

Python

```
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
```

- **`await file.read()`**: Because network requests can take time, FastAPI uses `async`/`await` to read the incoming file bytes from the web stream asynchronously without freezing your server's entire CPU.
    
- **The Chain Reaction:** It dumps those raw `file_bytes` directly into your temporary file parser (`load_and_chunk_from_bytes`), gets the list of text chunks back, and instantly runs `ingest_chunks` to embed them and save them directly into your local ChromaDB directory.
    

### 3. Asking Questions (POST `/query`)

This endpoint acts as the core interface for your user or chatbot component.

Python

```
@app.post("/query", response_model=QueryResponse)
async def query_document(request: QueryRequest):
    if not request.question.strip():
        raise HTTPException(status_code=400, detail="Question cannot be empty")
```

- Expects the validated `QueryRequest` schema from the user. It trims whitespace to ensure they didn't just hit the spacebar.
    

Python

```
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
```

- **`start = time.time()`**: Drops a timestamp checkpoint right before calling your AI.
    
- **`query_rag(request.question)`**: Executes your modern LCEL chain! It triggers the parallel parallel retrieval pipeline, forms the prompt template, hits Groq for Llama 3 processing, parses the string, and manually grabs your source footnotes.
    
- **`latency_ms`**: Subtracts the start time from the current time to measure how many milliseconds the operation took. This is highly useful for engineering metrics to watch how fast your RAG configurations are running.
    

### 4. Clearing the System (DELETE `/reset`)

Python

```
@app.delete("/reset")
def reset_documents():
    try:
        reset_vectorstore()
        return {"message": "Vector store cleared successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

- **`@app.delete`**: Maps to standard REST architectural patterns for destructive operations. It invokes your database utility to completely wipe out your ChromaDB collection files on disk, resetting your application back to a clean slate.
    

---

### The Big Picture Checkpoint

Congratulations! By linking this file to your system, you have built a **fully production-patterned modular architecture**:

1. `loader.py` ingests text and parses raw pages.
    
2. `vectorstore.py` manages the database, local embeddings storage, and similarity search interfaces.
    
3. `chain.py` structures your modern LCEL assembly pipeline and interfaces with cloud LLMs.
    
4. `main.py` (this file) orchestrates everything as a high-speed API web service.
    

To see how you can test this running server directly without writing a single line of frontend code, open your browser while the server is running and navigate to `http://127.0.0.1:8000/docs`. You will see FastAPI's built-in Swagger interface where you can physically upload a PDF and ask your RAG questions right inside the web page UI!