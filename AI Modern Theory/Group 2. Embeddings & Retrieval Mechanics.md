### 1. Bi-Encoder vs Cross-Encoder

- **Bi-Encoder**: Query and document are encoded **independently** into separate embeddings, then compared via cosine similarity/dot product. Fast — documents can be pre-embedded and indexed once; at query time you only embed the query and do a vector search.
- **Cross-Encoder**: Query and document are concatenated and passed **together** through the model in one forward pass, producing a single relevance score directly. More accurate (captures token-level interaction between query and doc) but expensive — can't be precomputed, must run per query-document pair.
- **Practical use**: Bi-encoder for first-stage retrieval (fast, scales to millions of docs), cross-encoder for **re-ranking** the top-k candidates (slow but precise).

**Likely mock angle**: "Why not use cross-encoder for retrieval directly?" — no precomputation possible, O(n) forward passes per query against every document = infeasible at scale.

---

### 2. Dense Vector Retriever vs BM25

||BM25|Dense Retriever|
|---|---|---|
|Basis|Term frequency/sparse lexical match (TF-IDF variant)|Semantic embedding similarity|
|Strength|Exact keyword/entity match, rare terms, numbers/IDs|Paraphrases, synonyms, conceptual similarity|
|Weakness|Misses semantic similarity (synonyms, rephrasing)|Can miss exact term matches, weaker on rare/OOV terms, numbers|
|Cost|Cheap, no training needed|Needs embedding model + vector index|

**Common answer pattern**: Hybrid retrieval (BM25 + dense, combined via reciprocal rank fusion or weighted scoring) usually outperforms either alone — this is a likely "how would you improve retrieval" answer.

---

### 3. Sentence Window Retrieval

- **Problem it solves**: Small chunks give precise retrieval matches but lack surrounding context; large chunks give context but dilute embedding precision (too much irrelevant text averaged into one vector).
- **Technique**: Embed and retrieve at the **sentence level** (small, precise unit for matching), but when returning the result, **replace/expand it with a window of surrounding sentences** (e.g., ±2-3 sentences before/after) from the original document for the LLM's context.
- In LlamaIndex: `SentenceWindowNodeParser` splits into sentence nodes but stores adjacent sentences as metadata; a `MetadataReplacementPostProcessor` swaps the sentence back out for its window at retrieval time before passing to the generator.

**This directly answers your later topic**: "vector store lacks surrounding context — LlamaIndex fix" → sentence window retrieval is the fix.

---

### 4. HyDE (Hypothetical Document Embeddings)

- **How it works**: Instead of embedding the raw query, an LLM first generates a **hypothetical answer/document** to the query, and _that_ hypothetical document is embedded and used for retrieval (matching document-to-document semantics rather than query-to-document).
- **Why it helps normally**: Queries are often short/underspecified; a hypothetical answer is closer in style/content to what's actually in the corpus, improving retrieval match.
- **Why it performs poorly on time-sensitive questions**: The LLM generates the hypothetical document **from its own parametric knowledge**, which is frozen at training time. For a question like "who won the election yesterday," the LLM hallucinates a plausible-sounding but **outdated or wrong** hypothetical answer, and retrieval then matches against that wrong hypothesis — actively steering retrieval away from the correct (recent) documents rather than helping.

**Likely mock angle**: "When would you avoid HyDE?" — anything requiring current/fast-changing facts, since it relies on the LLM's stale internal knowledge to construct the retrieval query.

---

Next up: **Group 3 — RAG Evaluation & Failure Diagnosis**. Want me to continue?