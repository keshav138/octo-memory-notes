Let's start with `loader.py` — this is where documents come in and get chunked.

---

### `app/rag/loader.py`

```python
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
import tempfile
import os

def load_and_chunk_pdf(file_path: str) -> list:
    """
    Loads a PDF from a file path, splits into chunks.
    Returns list of LangChain Document objects.
    """
    loader = PyPDFLoader(file_path)
    documents = loader.load()  # returns list of Documents, one per page

    splitter = RecursiveCharacterTextSplitter(
        chunk_size=1000,       # characters per chunk
        chunk_overlap=200,     # overlap between chunks to preserve context
        separators=["\n\n", "\n", ".", " ", ""]  # tries these in order
    )

    chunks = splitter.split_documents(documents)
    return chunks


def load_and_chunk_from_bytes(file_bytes: bytes, filename: str) -> list:
    """
    For FastAPI file uploads — writes to temp file first, then loads.
    """
    with tempfile.NamedTemporaryFile(delete=False, suffix=".pdf") as tmp:
        tmp.write(file_bytes)
        tmp_path = tmp.name

    try:
        chunks = load_and_chunk_pdf(tmp_path)
    finally:
        os.unlink(tmp_path)  # clean up temp file

    return chunks
```

---

### What's happening here — learn this

**`PyPDFLoader`**

- Loads PDF page by page
- Each page becomes a `Document` object with `.page_content` (text) and `.metadata` (source, page number)
- Page number in metadata is important — this is how you later say "answer found on page 34"

**`RecursiveCharacterTextSplitter`**

- Tries to split on `\n\n` first (paragraphs), then `\n`, then `.`, then spaces
- This is "recursive" because it falls back to the next separator if chunk is still too large
- `chunk_size=1000` — good balance for financial docs, not too small (loses context) not too large (retrieval gets noisy)
- `chunk_overlap=200` — if a sentence spans two chunks, both chunks have it. Critical for financial docs where a number and its context might be on a boundary.

**Why two functions:**

- `load_and_chunk_pdf` — for local file path (useful for testing directly)
- `load_and_chunk_from_bytes` — for FastAPI `UploadFile` which gives you bytes, not a path. Writes to a temp file because `PyPDFLoader` needs a path.

---

### Quick test — run this before moving on

Create a `test_loader.py` in root:

```python
from app.rag.loader import load_and_chunk_pdf

chunks = load_and_chunk_pdf("your_10k.pdf")  # drop any PDF in root for now

print(f"Total chunks: {len(chunks)}")
print(f"\nFirst chunk:\n{chunks[0].page_content}")
print(f"\nMetadata: {chunks[0].metadata}")
```

Run:

```powershell
python test_loader.py
```

You should see chunk count, first chunk text, and metadata with page number. Share the output and we'll move to `vectorstore.py`.