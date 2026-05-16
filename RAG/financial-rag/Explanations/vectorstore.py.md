Let's build `vectorstore.py` — this is where chunks get embedded and stored in ChromaDB.

---

### `app/rag/vectorstore.py`

```python
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_chroma import Chroma
from langchain.schema import Document
import os
from dotenv import load_dotenv

load_dotenv()

CHROMA_PERSIST_DIR = os.getenv("CHROMA_PERSIST_DIR", "./chroma_db")
COLLECTION_NAME = os.getenv("COLLECTION_NAME", "financial_docs")

# initialize embeddings model once — expensive to reload
embeddings = HuggingFaceEmbeddings(
    model_name="sentence-transformers/all-MiniLM-L6-v2",
    model_kwargs={"device": "cpu"},
    encode_kwargs={"normalize_embeddings": True}
)

def get_vectorstore() -> Chroma:
    """
    Returns existing ChromaDB collection or creates one.
    Persistent — survives restarts.
    """
    return Chroma(
        collection_name=COLLECTION_NAME,
        embedding_function=embeddings,
        persist_directory=CHROMA_PERSIST_DIR
    )


def ingest_chunks(chunks: list[Document]) -> int:
    """
    Embeds and stores chunks into ChromaDB.
    Returns number of chunks stored.
    """
    vectorstore = get_vectorstore()
    vectorstore.add_documents(chunks)
    return len(chunks)


def get_retriever(k: int = 5):
    """
    Returns a retriever that fetches top-k most relevant chunks.
    """
    vectorstore = get_vectorstore()
    return vectorstore.as_retriever(
        search_type="similarity",
        search_kwargs={"k": k}
    )


def reset_vectorstore() -> None:
    """
    Clears the entire ChromaDB collection.
    """
    vectorstore = get_vectorstore()
    vectorstore.delete_collection()
```

---

### What's happening here — learn this

**`HuggingFaceEmbeddings`**

- Downloads `all-MiniLM-L6-v2` locally on first run (~80MB)
- Converts text chunks into 384-dimensional vectors
- `normalize_embeddings=True` — normalizes to unit length, makes cosine similarity == dot product, slightly better retrieval
- Initialized once at module level — you don't want this reloading on every request

**`get_vectorstore()`**

- `persist_directory` is what makes it persistent — ChromaDB writes to disk here
- Calling this multiple times is safe — it loads existing collection if present

**`ingest_chunks()`**

- `add_documents()` handles embedding + storing in one call
- LangChain passes each chunk's text through the embeddings model, gets vectors, stores vector + original text + metadata together

**`get_retriever()`**

- `k=5` — fetches 5 most similar chunks to the query
- `search_type="similarity"` — cosine similarity search
- This retriever object is what plugs directly into the LangChain chain later

**`reset_vectorstore()`**

- `delete_collection()` wipes everything — maps to your `DELETE /reset` endpoint later

---

One thing to install first:

```powershell
pip install langchain-chroma
```

---

### Quick test

```python
from app.rag.loader import load_and_chunk_pdf
from app.rag.vectorstore import ingest_chunks, get_retriever

chunks = load_and_chunk_pdf("your_10k.pdf")
count = ingest_chunks(chunks)
print(f"Ingested {count} chunks")

retriever = get_retriever(k=3)
results = retriever.invoke("what are the main risk factors?")

for i, doc in enumerate(results):
    print(f"\n--- Chunk {i+1} (page {doc.metadata.get('page')}) ---")
    print(doc.page_content[:300])
```

First run will download the embedding model — takes a minute. After that it's cached.

Run it and share what you see — then we move to `chain.py` which is where RAG actually comes together.