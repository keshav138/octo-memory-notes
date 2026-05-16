## Deep Dive: How One Vector Represents Multiple Tokens (With Small Examples)

This is the **magic** of embeddings. Let me make it concrete.

---

## Part 1: The Compression Problem — How 10 Words Become 1536 Numbers

**The seeming impossibility**: How does "The quick brown fox jumps over the lazy dog" (10 words, ~15 tokens) become just 1536 numbers that capture its meaning?

**Answer**: Neural networks learn to **project** variable-length sequences into fixed-length vectors through a process called **pooling**.

---

## Part 2: Step-by-Step — What Happens Inside the Model

Let me trace through **what actually happens** inside a BERT-style embedding model:

### Step 1: Tokens → Initial Vectors

Input: `"The cat sat"`

First, tokenize:
```
Token 1: "The"  → initial vector of 768 dims (random-ish)
Token 2: "cat"  → initial vector of 768 dims
Token 3: "sat"  → initial vector of 768 dims
```

At this point: **3 separate vectors** (one per token).

### Step 2: Self-Attention (Where the magic happens)

Each token looks at every other token and updates its vector based on context:

```
After attention:
"The" vector now contains information about "cat" and "sat"
"cat" vector now contains information about "The" and "sat"  
"sat" vector now contains information about "The" and "cat"
```

**Example** (simplified numbers):
```
Before attention:
"The"    = [0.1, 0.2, 0.3, ...]
"cat"    = [0.4, 0.5, 0.6, ...]
"sat"    = [0.7, 0.8, 0.9, ...]

After attention (now each knows about others):
"The"    = [0.15, 0.25, 0.35, ...]  # shifted toward "cat" and "sat"
"cat"    = [0.45, 0.55, 0.65, ...]  # shifted toward "The" and "sat"
"sat"    = [0.65, 0.75, 0.85, ...]  # shifted toward "The" and "cat"
```

### Step 3: Pooling — Collapsing Multiple Vectors into One

This is the critical step. Different models use different methods:

| Pooling Method | How it works | Example (3 vectors: A, B, C) |
|----------------|--------------|------------------------------|
| **Mean pooling** | Average all token vectors | `(A + B + C) / 3` |
| **CLS pooling** | Take only the first token's vector | `A` (but A has seen all others) |
| **Max pooling** | Take max value per dimension | `[max(A1,B1,C1), max(A2,B2,C2), ...]` |

**Most modern embedding models use Mean Pooling or CLS Pooling.**

**Concrete example with tiny 3‑dim vectors** (real models use 768 or 1536):

```
After attention, we have 3 vectors (each 3 numbers):
"The"    = [0.2, 0.5, 0.8]
"cat"    = [0.3, 0.6, 0.7]
"sat"    = [0.4, 0.7, 0.6]

MEAN POOLING:
[ (0.2+0.3+0.4)/3 , (0.5+0.6+0.7)/3 , (0.8+0.7+0.6)/3 ]
= [0.3, 0.6, 0.7]

This final vector [0.3, 0.6, 0.7] is the EMBEDDING for "The cat sat".
```

**Key insight**: The information from all 3 tokens is now **compressed** into this single 3‑dim vector.

---

## Part 3: Small Example — How "cat" vs "The cat sat" differ

Let me use **real behavior** (conceptual numbers, but accurate to how models work):

```python
# Pseudo-code with simplified 5-dim vectors
model.encode("cat")  
# → [0.8, 0.1, 0.2, 0.9, 0.3]

model.encode("The cat sat")
# → [0.7, 0.4, 0.3, 0.8, 0.5]
# Notice: Different! Adds information about "The" and "sat" (tense, article)
```

**What the model learned**:
- "cat" alone is just the concept of a feline
- "The cat sat" includes grammatical structure (past tense, definite article)
- The vector shifts to encode that additional meaning

**But here's the crucial part**: The final vector is still **5 numbers** in this example. The sentence didn't "expand" the vector — it redistributed the information.

---

## Part 4: Your Core Question — Finding Specific Lines in a Document

**Question**: "If I want specific answers from specific lines in a document, how does that work?"

**Answer**: One vector per line. Then search with a targeted query.

### Complete Small Example

**Document** (a recipe):
```
Line 1: "Preheat oven to 350 degrees."
Line 2: "Mix flour, sugar, and eggs in a bowl."
Line 3: "Bake for 30 minutes until golden brown."
Line 4: "Let cool before serving."
```

**Step 1: Chunk by line (4 chunks)**

```python
chunks = [
    "Preheat oven to 350 degrees.",
    "Mix flour, sugar, and eggs in a bowl.",
    "Bake for 30 minutes until golden brown.",
    "Let cool before serving."
]
```

**Step 2: Create embeddings (one per chunk)**

```python
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('all-MiniLM-L6-v2')  # 384 dimensions

embeddings = []
for chunk in chunks:
    vec = model.encode(chunk)  # Each is 384 numbers
    embeddings.append(vec)
```

Now each line has its **own vector**:

| Chunk | First 5 numbers of 384-dim vector (simplified) |
|-------|-----------------------------------------------|
| Line 1 | [0.23, -0.45, 0.67, -0.12, 0.34, ...] |
| Line 2 | [0.56, -0.23, 0.45, -0.78, 0.12, ...] |
| Line 3 | [0.34, -0.67, 0.23, -0.45, 0.78, ...] |
| Line 4 | [0.12, -0.34, 0.56, -0.23, 0.45, ...] |

**Step 3: Query to find specific information**

```python
# Question 1: "What temperature for the oven?"
query1 = "What temperature for the oven?"
query_vec1 = model.encode(query1)

# Find closest chunk
similarities = cosine_similarity(query_vec1, embeddings)
# Results: Line 1: 0.92, Line 3: 0.45, Line 2: 0.31, Line 4: 0.12
# → Returns Line 1 ✅

# Question 2: "How long to bake?"
query2 = "How long to bake?"
query_vec2 = model.encode(query2)
# Results: Line 3: 0.89, Line 1: 0.34, Line 2: 0.28, Line 4: 0.15
# → Returns Line 3 ✅
```

**Why this works**: 
- The query "What temperature for the oven?" gets converted to a vector
- That vector is **close to** the "Preheat oven to 350 degrees" vector
- Because both contain temperature concepts (350°, oven, preheat)

---

## Part 5: The "Specific Line" Problem — How Granularity Matters

**Scenario**: You need an exact answer from Line 3, word 5.

**Problem**: If you chunk by paragraph (4 paragraphs), a query might pull the whole paragraph but not highlight the specific line.

**Solutions**:

### Solution 1: Fine-grained chunking (one vector per line)
```
Pro: Exact line retrieval
Con: Many vectors (slower, more storage)
```

### Solution 2: Hierarchical retrieval (two-stage)
```
Stage 1: Retrieve paragraph (coarse)
Stage 2: Within that paragraph, search lines (fine)
```

### Solution 3: Metadata + overlap
```python
# Store chunk + metadata about position
chunk = "Bake for 30 minutes until golden brown."
metadata = {
    "doc_id": "recipe_1",
    "line_number": 3,
    "start_char": 45,
    "end_char": 78
}
# After retrieval, you know EXACTLY where it came from
```

---

## Part 6: Live Demonstration — Making It Real

Let me simulate **actual model behavior** with a small open-source model you could run:

```python
from sentence_transformers import SentenceTransformer, util

model = SentenceTransformer('all-MiniLM-L6-v2')

# Document lines
lines = [
    "The capital of France is Paris.",
    "Paris is known for the Eiffel Tower.",
    "France is famous for wine and cheese.",
    "The Louvre museum is in Paris."
]

# Create embeddings
line_embeddings = model.encode(lines)

# Query: "What is the capital of France?"
query = "What is the capital of France?"
query_embedding = model.encode(query)

# Compute similarities
similarities = util.cos_sim(query_embedding, line_embeddings)[0]

print(similarities)
# Output: [0.87, 0.52, 0.41, 0.63]
#        Line 1 has 0.87 → returns "The capital of France is Paris." ✅

# Query: "What museum is in Paris?"
query2 = "What museum is in Paris?"
query_embedding2 = model.encode(query2)
similarities2 = util.cos_sim(query_embedding2, line_embeddings)[0]

print(similarities2)
# Output: [0.34, 0.56, 0.28, 0.79]
#        Line 4 has 0.79 → returns "The Louvre museum is in Paris." ✅
```

**Notice**: 
- Each line is its own vector (384 numbers)
- The query becomes a vector of the same length
- Cosine similarity finds the right line

---

## Part 7: The Information Loss Question

**You might ask**: "Doesn't compressing 10 words into 1536 numbers lose information?"

**Answer**: Yes, but that's by design. The model learns to preserve **semantic information** (meaning) while discarding surface details (exact wording, order, punctuation).

**What's preserved**:
- Meaning ("oven temperature 350" as a concept)
- Relationships ("bake" and "30 minutes" stay together)

**What's lost**:
- Exact word order
- Formatting (capitalization, line breaks)
- Fine details get averaged

**Example**:
```
"Bake at 350° for 30 minutes"
"30 minutes at 350° in the oven"  
```
These will have **very similar vectors** even though wording differs. That's the goal — semantic similarity despite surface differences.

---

## Part 8: Summary Table — One Vector Per Input

| Input Type | Number of Vectors | What each vector represents |
|------------|-------------------|----------------------------|
| Single word "cat" | 1 | The concept of "cat" |
| 3-word phrase "the cat sat" | 1 | The grammatical and semantic meaning of that phrase |
| 100-word paragraph | 1 | The gist of that paragraph (compressed) |
| Entire 1000-word document | 1 (bad idea) | The overall topic (loses details) |

**The rule**: One input string → One output vector. Always. The input length determines what information fits, not how many vectors.

---

## Part 9: The Exact Interview Answer

**If they ask**: "How can one vector represent multiple words without losing the ability to find specific lines?"

**You say**:
> "The model uses self-attention to let each token see all others, then pools them into a single vector. For specific line retrieval, we don't embed whole documents — we embed each line or small chunk separately. The query 'What temperature?' gets embedded and compared to each line's embedding. The line about '350 degrees' will have a similar vector because the model learned that temperature concepts cluster together. The lossy compression actually helps — it ignores exact wording variations and focuses on meaning, so 'preheat to 350' and 'set oven to 350°F' end up near the same point in vector space."

---

**Ready to move on?** Say "go to chunking" and I'll show you exactly how to choose chunk sizes, overlap amounts, and strategies for different document types.