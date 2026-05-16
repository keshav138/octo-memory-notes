## Vector Databases — Complete Ground Understanding

You now understand embeddings. Vector DB is where they live. Let's make this cold.

---

## Part 1: What a Vector DB Actually Is

**Definition**: A database optimized for storing and searching high-dimensional vectors using **Approximate Nearest Neighbor (ANN)** algorithms.

**What it does differently from a normal DB**:

| Operation | Normal DB (PostgreSQL) | Vector DB |
|-----------|------------------------|-----------|
| **Search type** | Exact match, range, full-text | Similarity search (ANN) |
| **Index structure** | B-tree, hash, GIN | HNSW, IVF, PQ |
| **Query** | `WHERE id = 5` or `text LIKE '%cat%'` | `ORDER BY cosine_similarity(embedding, query_vec) LIMIT 10` |
| **Performance** | Fast for exact queries | Fast for nearest neighbor (even with millions of vectors) |

**The core problem Vector DB solves**: Brute force similarity search is O(N × D) — for 1M vectors of 1536 dimensions, that's ~1.5B operations per query. Too slow.

**ANN solution**: Build indexes that skip most vectors. Sacrifice ~1-5% accuracy for 100-1000x speedup.

---

## Part 2: Index Types You Must Know (HNSW, IVF, PQ)

### HNSW (Hierarchical Navigable Small World) — Most Important

**What it is**: Graph-based index that creates multi-layer navigation structure.

**How it works visually**:
```
Layer 2 (top):   A ——————————— F
                 │ \           /
Layer 1:    A — B — C — D — E — F
            │       │       │
Layer 0:    A — B — C — D — E — F — G — H — I — J — K — L (all vectors)
```

**The algorithm in plain English**:
1. Build multiple layers (like express vs local train stops)
2. Top layer has few vectors (long-range connections)
3. Each lower layer has more vectors
4. Search: Start at top layer, navigate to closest node, drop to next layer, repeat

**Characteristics**:
| Property | Value |
|----------|-------|
| Speed | Very fast (O(log N)) |
| Accuracy | High (90-99% recall) |
| Build time | Slow (hours for 10M vectors) |
| Memory | High (stores graph edges) |
| Updates | Slow (needs rebuild or partial repair) |

**When to use**: Production RAG where read speed matters most, vectors don't change frequently.

---

### IVF (Inverted File Index) / IVF-FLAT

**What it is**: Cluster-based index. K-means on all vectors → assign each vector to nearest centroid → search only nearest clusters.

**How it works**:
```
Step 1: Create 100 centroids (cluster centers)
Step 2: Assign each vector to its closest centroid
Step 3: At query time:
   - Find 3 closest centroids to query
   - Only search vectors in those 3 clusters
   - Skip the other 97 clusters entirely
```

**Characteristics**:
| Property | Value |
|----------|-------|
| Speed | Medium-Fast |
| Accuracy | Good (tunable via nprobe parameter) |
| Build time | Fast |
| Memory | Low (stores cluster assignments) |
| Updates | Easy (assign to nearest centroid) |

**Parameter**: `nprobe` = how many clusters to search. Higher = slower but more accurate.

---

### PQ (Product Quantization) — For Compression

**What it is**: Compresses vectors by splitting dimensions and quantizing each subspace.

**How it works**:
```
Original vector (1536 dims) → Split into 96 subspaces of 16 dims each
Subspace 1: [0.23, -0.45, 0.67, ... 16 numbers] → compresses to 1 byte (256 possible values)
Result: 1536 floats (12KB) → 96 bytes → 128x compression
```

**Characteristics**:
| Property | Value |
|----------|-------|
| Memory | Extremely low (compressed) |
| Accuracy | Lower (approximation) |
| Speed | Fast (pre-computed distance tables) |
| Use case | Billion-scale vectors on limited RAM |

---

### Common Combinations (What Production Uses)

| Index | What it combines | Use case |
|-------|-----------------|----------|
| **IVF-PQ** | IVF + PQ | Large scale (100M+ vectors), memory constrained |
| **HNSW** | Graph only | Speed-critical, manageable memory (10M vectors) |
| **IVF-FLAT** | IVF only | Smaller datasets, high accuracy needed |

---

## Part 3: ChromaDB vs FAISS vs Pinecone — Deep Comparison

### FAISS (Facebook AI Similarity Search)

**What it is**: Library, NOT a database. No persistence, no server, no built-in updates.

**Architecture**:
```python
import faiss

index = faiss.IndexFlatL2(dimension)  # In-memory only
index.add(vectors)                     # Vectors lost if program exits
# No: durability, replication, user management, network API
```

**When to pick FAISS**:
- Batch processing (run a job, search, then exit)
- Research experiments
- You need absolute speed and control
- You're willing to manage storage/indexing yourself

**What it lacks**:
- No persistence (you must save/load manually)
- No concurrent writes
- No metadata filtering
- No network layer

---

### ChromaDB

**What it is**: Embedded vector database with persistence. "SQLite for vectors."

**Architecture**:
```python
import chromadb

client = chromadb.PersistentClient(path="./my_db")  # Persists to disk
collection = client.create_collection("docs")

# Stores both vectors AND metadata AND documents
collection.add(
    ids=["1", "2"],
    embeddings=[[0.1, 0.2], [0.3, 0.4]],
    metadatas=[{"source": "wiki"}, {"source": "news"}],
    documents=["First doc", "Second doc"]
)

# Filter by metadata
results = collection.query(
    query_embeddings=[[0.1, 0.2]],
    where={"source": "wiki"}  # ← Chroma advantage
)
```

**When to pick ChromaDB**:
- Local development
- Single-machine production (small to medium scale)
- You need metadata filtering without complexity
- Quick prototypes → production without changing code

**Limits**:
- Not distributed (single node)
- No built-in replication
- Performance degrades after ~1M vectors

---

### Pinecone

**What it is**: Fully managed cloud vector database.

**Architecture**:
```python
import pinecone

pinecone.init(api_key="xxx")
index = pinecone.Index("my-index")

# Index is hosted, replicated, auto-scaled
index.upsert(vectors=[("id1", [0.1, 0.2], {"source": "wiki"})])

# Pinecone handles: sharding, replication, load balancing, updates
results = index.query(vector=[0.1, 0.2], top_k=10, filter={"source": "wiki"})
```

**When to pick Pinecone**:
- Production at scale (millions to billions of vectors)
- You don't want to manage infrastructure
- High availability required
- Team has no dedicated infrastructure engineer

**Trade-offs**:
- Expensive (pay per vector + queries)
- Vendor lock-in
- Network latency (can't run on your hardware)

---

### Quick Selection Guide

| Your situation | Pick |
|----------------|------|
| "I'm building a prototype on my laptop" | ChromaDB |
| "I have 100K vectors and one server" | ChromaDB or FAISS+Postgres |
| "I have 10M vectors and need speed" | FAISS with HNSW (self-managed) |
| "I have 100M+ vectors and no infra team" | Pinecone |
| "I need exact search, not approximate" | None (use brute force or Postgres pgvector) |
| "I need hybrid search (vector + keyword)" | Weaviate or Qdrant |

---

## Part 4: How ANN Search Actually Works (HNSW Deep Dive)

**Step by step** (what you'd explain in interview):

1. **Build phase**:
   - Start with empty graph
   - Insert vectors one by one
   - For each new vector, find its nearest neighbors in existing graph
   - Connect it to M nearest neighbors (bidirectional edges)
   - With probability ~1/ln(N), promote to higher layer

2. **Search phase** (given query vector Q):
   ```
   current = entry_point (top layer)
   
   For layer L from top to bottom:
       While there's a neighbor closer to Q than current:
           current = that neighbor
       # Now at nearest node in this layer
       Move down to same node in next layer
   
   # At bottom layer (layer 0)
   Results = M closest neighbors to Q using greedy search
   ```

**Complexity**: O(log N) — same as binary search but in graph space.

**Visualization**: Like finding a street address using highway → arterial → local streets.

---

## Part 5: Metadata Filtering — Why It's Critical

**Problem**: Vector similarity alone isn't enough. You often need to restrict by user, date, source, etc.

**Example**:
```python
# Only search within user's documents
results = collection.query(
    query_vector=query_embedding,
    filter={"user_id": "alice", "date": {"$gte": "2025-01-01"}}
)
```

**How different DBs handle it**:

| DB | Filter approach | Performance |
|----|----------------|-------------|
| **ChromaDB** | Post-filter (apply after vector search) | Can miss results if filter is very selective |
| **Pinecone** | Pre-filter (metadata index + vector search) | Better, uses separate inverted index |
| **Qdrant** | Hybrid (filter-aware HNSW) | Best for complex filters |
| **FAISS** | No native support (you implement yourself) | Manual |

**The nuance**: If your filter eliminates 99% of vectors, post-filtering might return empty results because top-k vectors all get filtered out. Pre-filtering solves this but is harder to implement efficiently.

---

## Part 6: Distance Metrics in Vector DBs

**What each DB supports**:

| DB | Cosine | L2 | Dot Product |
|----|--------|-----|--------------|
| FAISS | ✅ (IndexFlatIP) | ✅ (IndexFlatL2) | ✅ (same as cosine if normalized) |
| Chroma | ✅ | ✅ | ❌ (uses cosine under hood) |
| Pinecone | ✅ | ✅ | ✅ |

**Important**: If you store embeddings that are *not* normalized, dot product gives different results than cosine. Most DBs warn you.

**Best practice**: Normalize all vectors before storing. Then:
- Cosine similarity = dot product (faster)
- L2 distance = √(2 - 2*dot) — equivalent ranking

---

## Part 7: Production Considerations

**Batching**:
```python
# DON'T: One at a time (slow)
for doc in documents:
    collection.add(ids=[doc.id], embeddings=[get_embedding(doc.text)])

# DO: Batch (100x faster)
batch_size = 100
for i in range(0, len(documents), batch_size):
    batch = documents[i:i+batch_size]
    collection.add(
        ids=[doc.id for doc in batch],
        embeddings=[get_embedding(doc.text) for doc in batch]
    )
```

**Indexing strategies for updates**:
- **HNSW**: Bad for frequent updates (rebuild nightly)
- **IVF**: Good for streaming updates
- **Pinecone**: Handles automatically

**Monitoring metrics**:
- Query latency (p95, p99)
- Recall@10 (how many relevant docs in top 10)
- Index build time
- Memory usage

---

## Part 8: Quick Reference Card

| Concept | One‑sentence answer |
|---------|---------------------|
| What problem does vector DB solve? | Brute-force similarity search is O(N×D) — too slow for large datasets. ANN indexes trade tiny accuracy loss for 100-1000x speedup. |
| HNSW vs IVF? | HNSW uses graph layers (fastest reads, slow updates, high memory). IVF uses clusters (balanced, better for streaming). |
| Chroma vs Pinecone? | Chroma is embedded (local, simple). Pinecone is managed cloud (scale, high availability, expensive). |
| What is metadata filtering? | Restricting search by attributes (user_id, date, source) before or after vector search. |
| When to choose FAISS? | When you need maximum speed/control and can manage persistence yourself. |

---

## Part 9: Sample Interview Answer

**Question**: "How would you choose a vector database for a customer support RAG system with 5 million documents, updated daily?"

**Answer**:
> "With 5M documents and daily updates, I'd eliminate HNSW-based solutions because rebuilds would be painful. I'd look at IVF-based indexes. 
> 
> If I had infrastructure support, I'd use FAISS with IVF-PQ on a single large instance — cheap and fast enough. 
> 
> If I had no infra team, I'd use Pinecone or Qdrant Cloud for managed updates and filtering by customer ID. 
> 
> ChromaDB would fail at 5M scale. I'd pre-filter by customer ID to ensure results aren't emptied by post-filtering."

---

**Ready for chunking?** Say "go to chunking" and I'll cover strategies, overlap calculations, and document‑aware splitting.