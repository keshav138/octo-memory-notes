This Python script represents **Phase 2 and Phase 3: Embedding and Vector Storage** of your RAG pipeline.

Now that you've chopped your PDF into clean, overlapping text chunks, you need a way to make those chunks searchable by their _meaning_, not just exact word matches. This code handles converting text into math (embeddings), saving them to your hard drive so they survive a computer restart, and setting up a lookup mechanism (retriever) to pull them back out.

---

## Part 1: The Imports & Setup

Python

```
from langchain_huggingface import HuggingFaceEmbeddings
from langchain_chroma import Chroma
from langchain.schema import Document
import os
from dotenv import load_dotenv

load_dotenv()

CHROMA_PERSIST_DIR = os.getenv("CHROMA_PERSIST_DIR", "./chroma_db")
COLLECTION_NAME = os.getenv("COLLECTION_NAME", "financial_docs")
```

- **`HuggingFaceEmbeddings`**: This comes from `langchain-huggingface`. It lets you download a machine learning model from Hugging Face and run it directly on your machine to translate text into numeric vectors.
    
- **`Chroma`**: This comes from `langchain-chroma`. It is the LangChain wrapper for ChromaDB. It acts as the bridge between your Python code and the database storing your vectors.
    
- **`os` and `load_dotenv()`**: Just like before, these load configuration variables.
    
    - `CHROMA_PERSIST_DIR`: Tells ChromaDB exactly which folder on your hard drive to save your database files into (`./chroma_db`).
        
    - `COLLECTION_NAME`: Think of a collection like a specific table in a traditional SQL database. Here, we are calling our specific table `"financial_docs"`.
        

---

## Part 2: Initializing the Brain (The Embedding Model)

Python

```
embeddings = HuggingFaceEmbeddings(
    model_name="sentence-transformers/all-MiniLM-L6-v2",
    model_kwargs={"device": "cpu"},
    encode_kwargs={"normalize_embeddings": True}
)
```

- **Why is this outside of a function?** This is initialized at the module level (global scope). Loading a machine learning model into your computer's RAM takes time and processing power. By putting it here, Python runs this line **exactly once** when the server starts up, rather than wasting time reloading the model every single time a user asks a question.
    
- **`model_name="sentence-transformers/all-MiniLM-L6-v2"`**: This tells LangChain to download a highly optimized, lightweight embedding model. On your very first run, it downloads a file (~80MB) and caches it locally. This model takes a text chunk and turns it into an array of exactly 384 numbers (a 384-dimensional vector).
    
- **`model_kwargs={"device": "cpu"}`**: Tells the model to execute its math equations using your computer’s CPU. (If you had a gaming PC with an Nvidia GPU, you could change this to `cuda`).
    
- **`encode_kwargs={"normalize_embeddings": True}`**: This scales all the generated vectors down to a mathematical length of 1. When vectors are normalized, calculating how similar two text chunks are becomes a much simpler math problem (dot product), making your search results lightning fast and slightly more accurate.
    

---

## Part 3: Managing the Database Connection

Python

```
def get_vectorstore() -> Chroma:
    return Chroma(
        collection_name=COLLECTION_NAME,
        embedding_function=embeddings,
        persist_directory=CHROMA_PERSIST_DIR
    )
```

- **What it does:** This function initializes or connects to your database.
    
- **Why it's smart:** You can call this function a hundred times across your app, and it will always handle the logic safely. If the folder `./chroma_db` doesn't exist yet, ChromaDB will automatically create it. If it _does_ exist, it won't overwrite it—it will simply open up the existing files so you can read from or add to them. It links your `embeddings` model directly to the database so Chroma knows how to process text strings automatically.
    

---

## Part 4: Saving Text Chunks into the Database

Python

```
def ingest_chunks(chunks: list[Document]) -> int:
    vectorstore = get_vectorstore()
    vectorstore.add_documents(chunks)
    return len(chunks)
```

- **`vectorstore = get_vectorstore()`**: Establishes the database connection.
    
- **`vectorstore.add_documents(chunks)`**: This single line triggers a massive chain reaction behind the scenes:
    
    1. LangChain extracts the `page_content` string from every `Document` object in your list.
        
    2. It passes those strings to your `all-MiniLM-L6-v2` embedding model.
        
    3. The model returns the 384 numbers for each chunk.
        
    4. ChromaDB writes the **original text**, the **metadata** (like the page number), and the **mathematical vector** side-by-side onto your hard drive.
        
- **`return len(chunks)`**: Returns the total count of items saved, which is useful for logging confirmation back to your terminal or API.
    

---

## Part 5: The Search Engine (Retrieval)

Python

```
def get_retriever(k: int = 5):
    vectorstore = get_vectorstore()
    return vectorstore.as_retriever(
        search_type="similarity",
        search_kwargs={"k": k}
    )
```

- **What is a Retriever?** A retriever is a special, lightweight LangChain object whose entire purpose is: _“Take a human string query, find matching documents, and return them.”_ It doesn't use an LLM yet; it is purely a search engine.
    
- **`search_type="similarity"`**: Tells Chroma to use standard vector similarity (cosine similarity). When a user asks a question, their question is converted into a vector, and Chroma searches its database for the chunks whose vectors point in nearly the exact same mathematical direction.
    
- **`search_kwargs={"k": k}`**: `k=5` means _"fetch the top 5 closest matching chunks."_ If your document is 1,000 pages long, Chroma will ignore 995 pages and pull only the 5 specific sentences/paragraphs that closely relate to the user's question.
    

---

## Part 6: Resetting the Database

Python

```
def reset_vectorstore() -> None:
    vectorstore = get_vectorstore()
    vectorstore.delete_collection()
```

- **`vectorstore.delete_collection()`**: This completely wipes out the collection table. It is crucial for testing. If you update your PDF document or want to clear out old data, you call this to empty the database without manually navigating your file explorer to delete folders.
    

---

## How the Quick Test Pulls It Together

Look at what happens when you run your test script:

Python

```
# 1. Page-by-page slicing into LangChain Documents
chunks = load_and_chunk_pdf("your_10k.pdf")

# 2. Text gets converted to vectors and saved to disk in ./chroma_db
count = ingest_chunks(chunks)

# 3. Creates the search interface targeting the top 3 closest chunks
retriever = get_retriever(k=3)

# 4. Triggers vector search!
results = retriever.invoke("what are the main risk factors?")
```

When you call `retriever.invoke()`, your query `"what are the main risk factors?"` gets turned into a 384-dimensional vector. ChromaDB scans your saved chunks, finds the 3 chunks with the highest mathematical match, and returns them as a list of `Document` objects—complete with their original page number metadata.

Once you run this test and confirm you can successfully search your local PDF document, the final step is to pass those retrieved chunks into `chain.py`, where your LLM (Groq) will read them and write a clean, natural sentence response!