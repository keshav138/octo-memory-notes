## Chunking — Complete Ground Understanding

You now understand embeddings (one vector per chunk) and vector DBs (store/retrieve those vectors). Chunking is where you **decide what each vector represents**. Get this wrong, RAG fails regardless of everything else.

---

## Part 1: What Chunking Actually Is

**Definition**: Splitting a document into smaller pieces (chunks) before embedding.

**Why chunking exists** (3 reasons):

| Reason | Explanation |
|--------|-------------|
| **Token limits** | Embedding models have max input (512-8192 tokens). Whole book won't fit. |
| **Retrieval granularity** | A single vector for a whole book can't find specific answers. |
| **LLM context windows** | Even if embedding model could take 100K tokens, retrieval would suck. |

**The fundamental trade-off**:

| Chunk size | Pros | Cons |
|------------|------|------|
| **Very small** (1 sentence) | High precision, finds exact lines | Lacks context, may miss cross-sentence meaning |
| **Medium** (1 paragraph) | Balanced — good for most RAG | None for general use |
| **Large** (1 page) | Has full context | Low precision, retrieves too much irrelevant text |
| **Very large** (whole doc) | Maximum context | Terrible retrieval, almost useless |

**Standard practice**: 500-1000 characters OR 100-250 tokens per chunk.

---

## Part 2: Three Chunking Strategies — Deep Comparison

### Strategy 1: Fixed-size Chunking

**How it works**: Split by exact character or token count, regardless of sentence boundaries.

```python
# Character-based
chunk_size = 500  # characters
chunk_overlap = 50  # characters

text = "This is my document. It has multiple sentences. We'll split it blindly."
# Splits every 500 chars, even mid-word or mid-sentence
```

**Token-based (better)**:
```python
import tiktoken

encoder = tiktoken.encoding_for_model("text-embedding-3-small")
tokens = encoder.encode(long_text)

chunk_size_tokens = 500
overlap_tokens = 50

chunks = []
for i in range(0, len(tokens), chunk_size_tokens - overlap_tokens):
    chunk_tokens = tokens[i:i + chunk_size_tokens]
    chunk_text = encoder.decode(chunk_tokens)
    chunks.append(chunk_text)
```

**Pros**:
- Simple, deterministic
- Fastest to implement
- Works on any text

**Cons**:
- Breaks sentences mid-way
- Breaks paragraphs
- Can lose meaning at boundaries

**When to use**: Log files, code, structured data where boundaries don't matter.

---

### Strategy 2: Sentence-level Chunking

**How it works**: Split by sentence boundaries (period, exclamation, question mark), then group sentences into chunks.

```python
from nltk.tokenize import sent_tokenize

sentences = sent_tokenize(document)

chunk_size_sentences = 3
overlap_sentences = 1

chunks = []
for i in range(0, len(sentences), chunk_size_sentences - overlap_sentences):
    chunk_sentences = sentences[i:i + chunk_size_sentences]
    chunk_text = " ".join(chunk_sentences)
    chunks.append(chunk_text)
```

**Example with overlap**:
```
Sentences: [S1, S2, S3, S4, S5, S6]
Chunk size = 3, overlap = 1

Chunk 1: S1, S2, S3
Chunk 2: S3, S4, S5  (S3 overlaps)
Chunk 3: S5, S6      (last partial)
```

**Pros**:
- Preserves sentence boundaries
- Maintains grammatical coherence
- Overlap works cleanly

**Cons**:
- Variable chunk sizes (some sentences are 5 words, some 50)
- Periods in abbreviations ("Dr. Smith") break incorrectly
- Requires sentence tokenizer (NLTK, spaCy)

**When to use**: Most general RAG, news articles, fiction, emails.

---

### Strategy 3: Semantic Chunking (Most Advanced)

**How it works**: Use embeddings to find natural topic boundaries. Split where meaning changes.

**Algorithm**:
```
1. Compute embeddings for each sentence
2. Calculate similarity between consecutive sentences
3. If similarity drops below threshold → split here
4. Group sentences between splits into chunks
```

**Complete small example**:

```python
from sentence_transformers import SentenceTransformer
import numpy as np

model = SentenceTransformer('all-MiniLM-L6-v2')

document = """
The company was founded in 2005. It started as a small startup. 
The founders had a vision for cloud computing.
Interest rates rose sharply. The Fed announced a 0.5% increase. 
Markets reacted negatively to the news.
"""

sentences = [
    "The company was founded in 2005.",
    "It started as a small startup.",
    "The founders had a vision for cloud computing.",
    "Interest rates rose sharply.",
    "The Fed announced a 0.5% increase.",
    "Markets reacted negatively to the news."
]

# Get embeddings for each sentence
embeddings = model.encode(sentences)

# Calculate similarity between consecutive sentences
similarities = []
for i in range(len(embeddings) - 1):
    sim = np.dot(embeddings[i], embeddings[i+1]) / (
        np.linalg.norm(embeddings[i]) * np.linalg.norm(embeddings[i+1])
    )
    similarities.append(sim)

# Similarities output:
# S1-S2: 0.89 (high → keep together)
# S2-S3: 0.92 (high → keep together)  
# S3-S4: 0.34 (LOW DROP → SPLIT HERE)
# S4-S5: 0.85 (high → keep together)
# S5-S6: 0.91 (high → keep together)

# Result chunks:
Chunk1: sentences 1-3 (company topic)
Chunk2: sentences 4-6 (interest rates topic)
```

**Pros**:
- Most coherent chunks
- Aligns with topic shifts
- Best retrieval accuracy

**Cons**:
- Computationally expensive (embed each sentence)
- Requires tuning threshold
- Slower for large documents

**When to use**: High-stakes RAG (legal, medical, research), long documents with many topics.

---

## Part 3: Overlap — Why It Matters (With Example)

**The problem without overlap**:

```
Document: "The capital of France is Paris. Paris is a beautiful city."

3-sentence chunks, no overlap:
Chunk 1: "The capital of France is Paris."
Chunk 2: "Paris is a beautiful city."

Query: "What is the capital of France?"
- Chunk 1 retrieved ✅ works

Query: "What is beautiful about Paris?"
- Chunk 2 has no context about "capital" — might answer fine

Query: "Why is Paris the capital of France?"
- Neither chunk has full answer
- Chunk 1 has capital fact but no "why" context
- Chunk 2 has irrelevant beauty info
```

**With overlap (50%)**:

```
Document: [Sentence A] [Sentence B] [Sentence C] [Sentence D]

Chunk size = 3 sentences, overlap = 1 sentence

Chunk 1: [A, B, C]
Chunk 2: [C, D]  (C repeats)
```

**Real example showing overlap value**:

```python
document = """
The patient was diagnosed with hypertension. 
Blood pressure was 150/95. 
Treatment with lisinopril was initiated. 
Follow-up in 2 weeks showed improvement.
"""

# NO OVERLAP (chunk size = 2 sentences)
chunks_no_overlap = [
    "The patient was diagnosed with hypertension. Blood pressure was 150/95.",
    "Treatment with lisinopril was initiated. Follow-up in 2 weeks showed improvement."
]

# Query: "What was the blood pressure before treatment?"
# → First chunk has BP but no mention of treatment
# → Second chunk has treatment but no BP
# → Neither chunk has both → LLM can't connect them

# WITH OVERLAP (chunk size = 2 sentences, overlap = 1 sentence)
chunks_with_overlap = [
    "The patient was diagnosed with hypertension. Blood pressure was 150/95.",
    "Blood pressure was 150/95. Treatment with lisinopril was initiated.",
    "Treatment with lisinopril was initiated. Follow-up in 2 weeks showed improvement."
]

# Now chunk 2 has BP + treatment together ✅
```

**Overlap math**:

| Overlap % | What it means | Effect |
|-----------|---------------|--------|
| 0% | No repeated content | Maximum unique chunks, risk missing boundaries |
| 10-20% | Small overlap | Cheap boundary protection |
| 25-50% | Standard overlap | Safe for most RAG |
| 75%+ | High overlap | Many duplicate vectors, wasteful |

**Formula**:
```
Number of chunks = ceil((total_tokens - overlap_tokens) / (chunk_tokens - overlap_tokens))

Example: 1000 tokens, chunk=200, overlap=50
Chunks = (1000-50)/(200-50) = 950/150 = 6.33 → 7 chunks
```

---

## Part 4: Document-aware Chunking (Advanced)

**Problem**: Different document types need different chunking.

**Solution**: Use document structure:

| Document type | Chunking strategy | Why |
|---------------|-------------------|-----|
| **Code** | By function/class | Code is naturally modular |
| **Markdown** | By heading (#, ##, ###) | Headers define topics |
| **PDF** | By page + paragraph | Pages are retrieval units |
| **Legal contract** | By clause (Section X.X) | Each clause is independent |
| **Conversation/chat** | By speaker turn | Keep speaker+response together |

**Example: Markdown-aware chunking**:

```python
import re

def chunk_markdown(markdown_text):
    # Split by headings (lines starting with #)
    sections = re.split(r'\n(#+ .+)\n', markdown_text)
    
    chunks = []
    for i in range(0, len(sections), 2):
        if i+1 < len(sections):
            heading = sections[i]
            content = sections[i+1]
            chunk = f"{heading}\n{content}"
            chunks.append(chunk)
    
    return chunks
```

**Example: Code-aware chunking**:

```python
import ast

def chunk_python(code_string):
    tree = ast.parse(code_string)
    chunks = []
    
    for node in ast.walk(tree):
        if isinstance(node, (ast.FunctionDef, ast.ClassDef)):
            chunk = ast.unparse(node)  # Get the function/class code
            chunks.append(chunk)
    
    return chunks
```

---

## Part 5: Chunking Evaluation — How to Know You're Right

**Metrics to measure**:

| Metric | What it measures | How to compute |
|--------|------------------|----------------|
| **Answer recall** | Does retrieved chunk contain answer? | Check if answer string in retrieved chunk |
| **Context relevance** | Is retrieved chunk actually relevant? | LLM-as-judge or human label |
| **Chunk coherence** | Does chunk make sense alone? | Readability score or LLM judgment |

**Quick test for your chunks**:

```python
# Test 1: Can a human understand the chunk alone?
chunk = "Blood pressure was 150/95. Treatment started."
# ✅ Good — stands alone

bad_chunk = "was initiated. Follow-up in 2 weeks"
# ❌ Bad — starts mid-sentence

# Test 2: Does the chunk contain the answer for common queries?
queries = [
    "What was the blood pressure?",
    "When was follow-up?"
]

for query in queries:
    # Check if any chunk contains answer
    # If not, chunking failed
```

---

## Part 6: Simple Implementation (Production-ready pattern)

```python
from langchain.text_splitter import RecursiveCharacterTextSplitter

# MOST COMMON PRODUCTION PATTERN
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=500,        # characters
    chunk_overlap=50,      # characters
    length_function=len,
    separators=["\n\n", "\n", ".", " ", ""]  # Try to break at paragraphs first
)

chunks = text_splitter.split_text(document)

# For token-aware chunking (better but slower)
from langchain.text_splitter import TokenTextSplitter

token_splitter = TokenTextSplitter(
    chunk_size=200,        # tokens
    chunk_overlap=20,      # tokens
    encoding_name="cl100k_base"  # OpenAI's tokenizer
)
```

**Why `RecursiveCharacterTextSplitter` wins**:
- Tries to break at double-newlines first (paragraphs)
- Falls back to single newlines, then spaces, then characters
- Best balance of coherence and simplicity

---

## Part 7: Common Pitfalls (What Will Break Your RAG)

| Pitfall | What happens | Fix |
|---------|--------------|-----|
| **No overlap** | Answers split across boundaries → lost information | Add 10-20% overlap |
| **Chunks too small** | Missing context → LLM can't understand | Increase chunk size |
| **Chunks too large** | Retrieves irrelevant text → LLM distracted | Reduce chunk size |
| **Splitting mid-table** | Table broken → meaningless data | Use document-aware splitter |
| **Ignoring document structure** | Heading separated from content | Preserve headers in chunk |
| **Chunking code by lines** | Functions broken | Use AST parser |

---

## Part 8: Quick Reference Card

| Strategy | Implementation difficulty | Accuracy | Speed | When to use |
|----------|--------------------------|----------|-------|--------------|
| **Fixed-size** | Easiest | Low | Fastest | Logs, code, structured |
| **Sentence** | Easy | Medium | Fast | News, emails, general |
| **Semantic** | Hard | Highest | Slow | Legal, medical, research |
| **Document-aware** | Medium | High | Medium | Markdown, PDFs, contracts |

**Standard defaults**:
- Chunk size: 500-1000 characters or 100-250 tokens
- Overlap: 10-20% of chunk size
- Separator priority: `\n\n` > `\n` > `.` > ` ` > character

---

## Part 9: The Exact Interview Answer

**If they ask**: "How do you choose chunk size and overlap?"

**You say**:
> "I start with 500-character chunks with 50-character overlap using recursive character splitting. That's a safe baseline. Then I measure answer recall: if answers missing, I increase overlap. If chunks retrieved are irrelevant, I reduce chunk size. For structured documents like legal contracts or markdown, I use document-aware chunking that preserves section boundaries. The key is that chunking is empirical — there's no universal perfect setting. I iterate based on retrieval metrics on my specific dataset."

**If they ask**: "What's the most common mistake in chunking?"

**You say**:
> "No overlap. Engineers think they're saving tokens, but they're actually losing answers that cross chunk boundaries. A 10-20% overlap is cheap insurance that costs almost nothing but prevents a catastrophic class of retrieval failures."

---

## Part 10: Full Pipeline Example (Putting It All Together)

```python
# Complete RAG pipeline with chunking
from langchain.text_splitter import RecursiveCharacterTextSplitter
from sentence_transformers import SentenceTransformer
import chromadb

# 1. Load document
with open("document.txt") as f:
    text = f.read()

# 2. Chunk
splitter = RecursiveCharacterTextSplitter(
    chunk_size=500,
    chunk_overlap=50
)
chunks = splitter.split_text(text)

# 3. Embed
model = SentenceTransformer('all-MiniLM-L6-v2')
embeddings = model.encode(chunks)

# 4. Store
client = chromadb.Client()
collection = client.create_collection("docs")
collection.add(
    ids=[f"chunk_{i}" for i in range(len(chunks))],
    embeddings=embeddings.tolist(),
    documents=chunks
)

# 5. Query
query = "What temperature should I bake at?"
query_embedding = model.encode([query])[0]

results = collection.query(
    query_embeddings=[query_embedding.tolist()],
    n_results=3
)

# 6. Generate (simplified)
context = "\n".join(results['documents'][0])
answer = llm_generate(f"Context: {context}\nQuery: {query}\nAnswer:")
```

---

**You now have complete grounding**: RAG purpose → embeddings → vector DB → chunking.

**Want to go deeper on any topic?** Say:
- "Advanced retrieval" (reranking, hybrid search, query rewriting)
- "Evaluation metrics" (how to measure RAG performance)
- "Production patterns" (caching, streaming, monitoring)