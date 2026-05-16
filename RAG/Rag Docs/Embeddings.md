## Embeddings — Complete Ground Understanding

No fluff. This is what you must know cold.

---

## Part 1: What An Embedding Actually Is

**Definition**: A dense vector (list of floats) that captures semantic meaning of text. Similar meanings → close vectors.

**Example** (simplified 3‑dim):
```
"king" → [0.95, 0.32, -0.78]
"queen" → [0.92, 0.35, -0.74]  (very close to king)
"car"   → [-0.21, 0.86, 0.43]   (far from both)
```

**Dimensions in reality**:
- OpenAI `text-embedding-3-small`: 1536 dimensions
- OpenAI `text-embedding-3-large`: 3072 dimensions
- Cohere v3: 1024 dimensions
- BGE-base: 768 dimensions

**Why dense vs sparse (old way like TF‑IDF)?**
- Sparse: most values zero, only exact word matches. Misses synonyms ("car" ≠ "automobile").
- Dense: most values non‑zero, captures relationships. "car" close to "automobile" because they appear in similar contexts during training.

---

## Part 2: How Embeddings Are Created (Training)

**Core idea**: Predict surrounding words (Word2Vec) or predict next sentence (BERT‑style).

**Simplified training process**:

1. Take massive text corpus (Wikipedia, web pages, books)
2. For each word/token, try to predict its neighbors
3. Backpropagate to adjust vector values
4. Result: Words that appear in similar contexts get similar vectors

**Example**: "I drink ___" → model learns coffee, tea, water, juice fill the blank → their vectors cluster.

**Modern approach (Contrastive Learning)**:
- Take pairs (question, relevant passage) → pull their vectors closer
- Take pairs (question, irrelevant passage) → push their vectors apart
- Used by: OpenAI `text-embedding-3`, Cohere, BGE, E5

**Key insight**: The embedding space is *learned*, not arbitrary. Every dimension has no human meaning — it's emergent.

---

## Part 3: Cosine Similarity — Why It's the Gold Standard

**Formula**:
```
cosine_similarity(A,B) = (A·B) / (||A|| × ||B||)
                       = dot product / (length_A × length_B)
```

**Range**: -1 (opposite) → 0 (unrelated) → 1 (identical direction)

**What it actually measures**: The cosine of the angle between two vectors.

**Visualize**:
- Vector A = [1, 0]  (points right)
- Vector B = [0.8, 0.6] (points same general direction, angle ~37°)
- Cosine = cos(37°) ≈ 0.8 → similar

**Why it works for text**:
- Text embeddings are often **normalized** (length = 1) by the model
- With unit vectors, cosine = dot product (computationally cheap)
- Only direction matters for meaning, not magnitude

**Example showing magnitude irrelevant**:
```
Sentence 1: "good" → [0.5, 0.5] (length = 0.71)
Sentence 2: "very very good" → [1.0, 1.0] (length = 1.41)
Same direction (45° angle), so cosine = 1.0 → perfectly similar
L2 distance = √[(0.5-1.0)² + (0.5-1.0)²] = 0.71 → different! (wrong)
```

---

## Part 4: L2 Distance — Why It's Worse for Text

**Formula**:
```
L2(A,B) = √[(a₁-b₁)² + (a₂-b₂)² + ... + (aₙ-bₙ)²]
```

**What it measures**: Straight‑line distance between points.

**Three reasons L2 fails for text**:

1. **Magnitude sensitivity** — A longer document with same meaning gets farther away
2. **Scale dependent** — If one dimension ranges 0-1000 and another 0-1, the large‑scale dimension dominates (embeddings avoid this via normalization, but still)
3. **Counterintuitive thresholds** — Cosine has natural 0→1 range; L2 depends on dimension count

**When L2 is acceptable**:
- Only if embeddings are normalized to unit length first
- Then L2 distance = √[2 - (2 × cosine)] — mathematically equivalent
- But cosine is **conceptually clearer** and industry standard

**Interview answer**: "Cosine all the way for raw embeddings. If I had to use L2 for some reason, I'd normalize vectors first."

---

## Part 5: Distance Metrics Comparison

| Metric | Formula | Range | Best for | Why |
|--------|---------|-------|----------|-----|
| **Cosine** | (A·B)/(‖A‖‖B‖) | [-1, 1] | Text embeddings | Ignores magnitude, only cares about direction/meaning |
| **Dot product** | Σ aᵢbᵢ | (-∞, ∞) | Normalized vectors | Identical to cosine if ‖A‖=‖B‖=1, faster |
| **L2 (Euclidean)** | √Σ(aᵢ-bᵢ)² | [0, ∞) | Image features, coordinates | Gets confused by vector length |
| **L1 (Manhattan)** | Σ\|aᵢ-bᵢ\| | [0, ∞) | Sparse vectors, outliers | Rare in text embeddings |

**Industry note**: Many vector DBs use **dot product** internally because:
- They auto‑normalize embeddings to unit length
- Then dot product = cosine (same result, fewer operations)

---

## Part 6: Key Properties You Must Internalize

**Property 1: Semantic Arithmetic**
```
"king" - "man" + "woman" ≈ "queen"
```
Embedding space allows vector math. Works because dimensions capture abstract relationships (royalty, gender, etc.)

**Property 2: Distributional Hypothesis**
- Words that appear in similar contexts have similar meanings
- The entire embedding paradigm rests on this

**Property 3: Curse of Dimensionality**
- High‑dim spaces are mostly empty
- 1536 dimensions is enormous — all points are nearly equidistant in theory
- But embeddings are *structured* — they don't fill space uniformly
- This is why ANN indexes (HNSW) exist — brute force is too slow

**Property 4: Normalization**
- Most modern embedding models output unit vectors by default
- Check your model: `response['data'][0]['embedding']` — if not normalized, normalize yourself:
  ```python
  import numpy as np
  norm = vec / np.linalg.norm(vec)
  ```

---

## Part 7: Popular Embedding Models (Know These)

| Model | Dimensions | Context length | Best for | Cost |
|-------|-----------|---------------|----------|------|
| **OpenAI text-embedding-3-small** | 1536 | 8192 tokens | General purpose, cheap | $0.02/1M tokens |
| **OpenAI text-embedding-3-large** | 3072 | 8192 tokens | Highest accuracy | $0.13/1M tokens |
| **Cohere embed-english-v3** | 1024 | 512 tokens | Long docs, compression | $0.10/1M tokens |
| **BGE-large-en** | 1024 | 512 tokens | Open source, MTEB top | Free (self‑host) |
| **Voyage-2** | 1024 | 32000 tokens | Very long contexts | $0.06/1M tokens |

**MTEB Benchmark** (Massive Text Embedding Benchmark) — the leaderboard. Check it before choosing.

**Interview tip**: "For production, I'd start with OpenAI v3‑small for cost/quality balance. For open source, BGE or E5."

---

## Part 8: Common Pitfalls (What Will Break Your RAG)

**Pitfall 1: Inconsistent embedding models**
- Embed documents with Model A, query with Model B → completely different spaces → garbage results
- **Rule**: Same model for both, always.

**Pitfall 2: Not handling token limits**
- Model has max input (e.g., 512 tokens)
- Chunk exceeds limit → truncation → lost information
- **Fix**: Check `tiktoken` count before embedding

**Pitfall 3: Domain shift**
- Embedding model trained on Wikipedia
- Applied to medical texts → poor performance
- **Fix**: Fine‑tune embeddings on your domain (Cohere supports this)

**Pitfall 4: Storing raw vectors without metadata**
- Retrieved vectors give you nothing to show user
- **Fix**: Always store `id`, `text`, `source`, `page_number` alongside embedding

---

## Part 9: Quick Reference Card (Memorize This)

```
What is embedding?        → Dense vector capturing semantic meaning
Why dense over sparse?    → Handles synonyms, generalizes
How trained?              → Predict neighbors or contrastive learning
Best similarity metric?   → Cosine (ignores magnitude)
Why not L2?               → Magnitude ≠ meaning in text
Dimensions typical?       → 768 to 3072
Normalization?            → Unit vectors (most models auto‑normalize)
Production pick?          → OpenAI v3‑small or BGE‑large
```

---

## Part 10: Code You Might Need to Write in Interview

**Manual cosine similarity**:
```python
import numpy as np

def cosine_similarity(a, b):
    a = np.array(a)
    b = np.array(b)
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))
```

**Normalize vectors** (if model doesn't):
```python
def normalize(vec):
    norm = np.linalg.norm(vec)
    return vec / norm if norm > 0 else vec
```

**Check embedding dimensions**:
```python
response = openai.embeddings.create(input="test", model="text-embedding-3-small")
dimensions = len(response.data[0].embedding)
print(dimensions)  # 1536
```

---

## Summary for Interview Recite

**If they ask "What are embeddings?"**:
> "Dense vector representations of text where semantic similarity equals vector closeness. They're trained using contrastive learning on large corpora."

**If they ask "Why cosine?"**:
> "Cosine measures angle, not magnitude. In text embeddings, the direction encodes meaning — length is just verbosity or repetition. L2 distance penalizes those differences incorrectly."

**If they ask "What embedding would you choose?"**:
> "OpenAI text-embedding-3-small for production speed/quality trade‑off. BGE or E5 for self‑hosted. I'd check MTEB benchmarks for the specific task."

---

**Ready for next?** Say "go to vector DB" and I'll cover:
- FAISS vs Chroma vs Pinecone internals
- HNSW indexing (how it actually works)
- Hybrid search (vector + keyword)
- Production considerations (metadata filtering, batching, updates)