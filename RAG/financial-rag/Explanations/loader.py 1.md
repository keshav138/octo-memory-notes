This Python script represents **Phase 1: Ingestion and Chunking** of a RAG pipeline.

Before an AI can answer questions about your data, the data needs to be broken down into bite-sized, readable pieces. This code handles two scenarios: reading a local PDF file already on your computer, and handling a raw binary file uploaded over the internet (like via a FastAPI web server).

Here is a line-by-line, contextual breakdown of exactly what is happening under the hood.

---

## Part 1: The Imports

Python

```
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
import tempfile
import os
```

- **`PyPDFLoader`**: LangChain doesn't natively know how to read binary PDF formats. This loader acts as a parser. It opens the PDF, extracts the raw text page-by-page, and wraps it into a standardized LangChain object called a `Document` (which holds both the raw page text and metadata, like the page number).
    
- **`RecursiveCharacterTextSplitter`**: This is the brain of your data preparation. LLMs have a limited memory capacity (context window). If you feed a whole textbook into an embedding model at once, the mathematical meaning gets diluted. This utility slices large text into precise, overlapping segments.
    
- **`tempfile`**: A standard Python library used to create temporary files that automatically vanish when you're done with them. This is critical for web servers so your hard drive doesn't fill up with uploaded user files.
    
- **`os`**: Python's standard operating system module. You use it here specifically to delete files from your storage when they are no longer needed.
    

---

## Part 2: Reading & Slicing a Local PDF

This function takes a physical file path on your hard drive, extracts the text, and chops it up.

Python

```
def load_and_chunk_pdf(file_path: str) -> list:
```

- **What it does:** Defines a function that expects a string path (like `"documents/f1_rules.pdf"`) and promises to return a `list` of small text chunks.
    

Python

```
    loader = PyPDFLoader(file_path)
    documents = loader.load()
```

- **`loader = PyPDFLoader(...)`**: Instantiates the parser and points it at your file. It hasn't read it yet; it just sets up the connection.
    
- **`documents = loader.load()`**: This is where the work happens. It opens the file, reads it, and returns a list of LangChain `Document` objects. If your PDF has 15 pages, this list will contain exactly 15 objects—one for each page.
    

Python

```
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=1000,       
        chunk_overlap=200,     
        separators=["\n\n", "\n", ".", " ", ""]  
    )
```

- **`chunk_size=1000`**: Tells the splitter, _"Try to make each piece of text roughly 1,000 characters long."_ This is approximately 150–200 words.
    
- **`chunk_overlap=200`**: To prevent a critical sentence from being cut exactly in half between chunk 1 and chunk 2, this forces the splitter to look backward by 200 characters when starting a new chunk. It maintains contextual continuity across boundaries.
    
- **`separators=[...]`**: This is why it’s called **Recursive**. Instead of blindly cutting text at exactly 1,000 characters (which would rip words apart), it looks for the best places to cut based on priority. It tries to split at a double newline (`\n\n` for paragraphs) first. If a paragraph is too big, it tries a single newline (`\n`). If that's still too big, it looks for periods (`.`), then spaces ( ), and finally individual characters (`""`) as a last resort. This keeps paragraphs and sentences intact.
    

Python

```
    chunks = splitter.split_documents(documents)
    return chunks
```

- **`splitter.split_documents(documents)`**: Takes your 15 page-sized documents and runs them through the recursive slicing logic. It returns a brand-new, much larger list of smaller `Document` chunks, each roughly 1,000 characters long.
    
- **`return chunks`**: Sends that processed list back to whatever called the function, ready to be converted into mathematical vectors.
    

---

## Part 3: Handling Web/API File Uploads

When a user uploads a file through a web framework like **FastAPI**, the file doesn't land on your hard drive as a neat file path; it streams into the server's memory as raw binary data (`bytes`). However, `PyPDFLoader` _requires_ a real file path to work. This function solves that catch-22.

Python

```
def load_and_chunk_from_bytes(file_bytes: bytes, filename: str) -> list:
```

- **What it does:** Accepts the raw incoming binary stream (`file_bytes`) and the original name of the file.
    

Python

```
    with tempfile.NamedTemporaryFile(delete=False, suffix=".pdf") as tmp:
        tmp.write(file_bytes)
        tmp_path = tmp.name
```

- **`with tempfile.NamedTemporaryFile(...) as tmp`**: Creates a secure, uniquely named placeholder file on your operating system's temporary storage directory. `suffix=".pdf"` ensures the OS knows it's a PDF file. `delete=False` keeps the file alive even after the code block closes so our loader can read it.
    
- **`tmp.write(file_bytes)`**: Dumps the raw internet binary data into this physical temporary file.
    
- **`tmp_path = tmp.name`**: Grabs the actual generated string path of that temp file (e.g., `C:\Users\Name\AppData\Local\Temp\tmpabc123.pdf`).
    

Python

```
    try:
        chunks = load_and_chunk_pdf(tmp_path)
    finally:
        os.unlink(tmp_path)  
```

- **`try...finally`**: This is a defensive programming safety net. It guarantees that no matter what happens inside the `try` block (even if the PDF is corrupt and crashes the script), the code inside the `finally` block **will run**.
    
- **`chunks = load_and_chunk_pdf(tmp_path)`**: Reuses the exact function we analyzed in Part 2! It hands over the temporary file path, extracts the text, and chunks it.
    
- **`os.unlink(tmp_path)`**: Deletes the temporary file from your hard drive immediately. Since the text is now safely chunked and saved inside your active Python memory (`chunks`), you no longer need the physical file wasting disk space.
    

Python

```
    return chunks
```

- **`return chunks`**: Hands back the final list of beautifully structured text segments to your web application endpoint.
    

### Where does this go next?

Once this script outputs your list of `chunks`, the next step in your pipeline is to pass them into a library like `sentence-transformers` to turn them into vector numbers, and then drop them into `chromadb` for retrieval.