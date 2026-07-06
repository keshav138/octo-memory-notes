### 1. Retriever vs Generator Bottleneck — Context Precision/Recall

- **Context Precision**: Of the retrieved chunks, what fraction are actually relevant? Low precision = retriever is pulling in noise.
- **Context Recall**: Of all the relevant information that exists in the corpus, what fraction did the retriever actually fetch? Low recall = retriever is missing relevant content entirely.
- **Diagnosis logic**:
- Low context precision/recall + low final answer quality → **retriever is the bottleneck** (generator never had good material to work with).
- High context precision/recall + still poor/wrong final answer → **generator is the bottleneck** (it had the right context but failed to use it — reasoning or faithfulness issue).

This precision/recall split is the standard way to isolate which pipeline stage to fix first.

---

### 2. RAG Eval Metrics: Faithfulness, Answer Relevancy, BERTScore, ROUGE-L, RAGAS

|Metric|What it measures|Basis|
|---|---|---|
|**Faithfulness**|Is the generated answer factually grounded in the retrieved context (no hallucination)?|Checks if claims in answer are entailed by context|
|**Answer Relevancy**|Does the answer actually address the question asked?|Semantic similarity between generated answer and question|
|**BERTScore**|Semantic similarity between generated and reference answer at token/embedding level|Contextual embeddings, not exact match|
|**ROUGE-L**|Longest common subsequence overlap between generated and reference text|Pure lexical/surface overlap, no semantic understanding|
|**RAGAS**|A framework bundling faithfulness, answer relevancy, context precision/recall into one eval suite|Composite, RAG-specific|

**Why high everything-except-ROUGE-L can still be prod-ready**: ROUGE-L is a **surface-level lexical match** — it penalizes valid answers that are phrased differently from the reference even if semantically correct. If faithfulness, answer relevancy, and BERTScore (semantic metrics) are all high, the answer is factually grounded, relevant, and semantically equivalent — low ROUGE-L just means the wording differs from a fixed reference, which is expected and acceptable for generative (non-extractive) answers. Prod-readiness should be judged by semantic/faithfulness metrics, not lexical overlap.

---

### 3. Legal Doc RAG: Faithfulness 0.6, Context Recall 0.9 — Conclusion

- Context recall 0.9 → the retriever **is** fetching most of the relevant information from the corpus. Retrieval is not the problem.
- Faithfulness 0.6 → despite having the right context, the generator is producing claims **not fully supported** by that context (partial hallucination, overgeneralization, or unsupported inference) — common failure in legal domains where precise wording matters and LLMs tend to "fill gaps" with plausible-sounding but unverified legal claims.
- **Conclusion**: The bottleneck is the **generator**, not the retriever. Fix via: stricter prompting ("only answer using the provided context, say 'not found' otherwise"), lower temperature, or adding a faithfulness-check/self-verification step post-generation — not by improving retrieval.

---

### 4. RAG Zero Overlap Consequence

- "Zero overlap" = the retrieved context has **no overlap** with the information actually needed to answer the query (retrieval failure).
- **Consequence**: The generator has no grounding material, so it either (a) hallucinates an answer entirely from parametric knowledge, or (b) if instructed to stay strict to context, refuses/says "I don't know." Either way, the RAG pipeline is not functioning as retrieval-augmented — it degrades to a base LLM (worse, since it may still falsely cite the irrelevant retrieved context as if it were the source).

In RAG (Retrieval-Augmented Generation), **overlap** (often called "chunk overlap") is a deliberate technique where you repeat a small slice of content at the end of one chunk and the beginning of the next 

Think of it as a safety net for your data  When you split a large document into smaller, searchable pieces (chunks), there is a high risk that you will cut a sentence, a definition, or a critical idea exactly in half .

### Why Overlap is Used

- **Preserving Context at Boundaries:** If an important piece of information spans across the split point (e.g., a sentence that starts in one chunk and ends in another), overlap ensures that the full sentence or idea appears intact in at least one of the two chunks .
    
- **Improving Retrieval Accuracy:** A search engine relies on "semantic fingerprints" \. If a chunk is cut in half, it might be incomplete and "uninterpretable" to the model, causing it to rank lower in search results ]. Overlap provides enough surrounding text to keep the meaning clear.
    
- **Preventing "Broken" Fragments:** Without overlap, a retrieval system might return a fragment that is too small to be useful (e.g., a "troubleshooting step" without the preceding "warning" or "prerequisite") 
    

### The Trade-offs

While overlap is essential, it is not "free":

- **Redundancy:** Too much overlap creates near-duplicate chunks . This can flood your search results with similar variations of the same paragraph, wasting space and reducing the "diversity" of the information retrieved .
    
- **Computational Cost:** More overlap means more tokens to embed and process, which increases both storage requirements and processing time .
    
- **Not a "Fix-All":** Overlap is a mechanical patch . If your chunks are fundamentally the wrong size or if you are splitting complex structures like tables and code blocks, a 10–20% overlap may not be enough to save the context ].
    

### Best Practices

- **Start with 10–20%:** A common industry baseline is to set your overlap to about 10–20% of your total chunk size.
    
- **Test and Iterate:** If your "Hit Rate" is low, try adjusting your chunk size first—it is usually the more impactful lever . Only then fine-tune your overlap to catch the remaining boundary issues .
    
- **Consider Alternatives:** For structured data like tables or deeply nested policy documents, fixed-size chunking with overlap often fails . In those cases, you might explore "Sentence Window" retrieval or agentic chunking, which are designed to keep logical units together rather than relying on mechanical overlaps .
    

---

### 5. ROUGE-L vs "Humanization" Score

- ROUGE-L: lexical overlap (longest common subsequence) with a reference — measures **content overlap**, not fluency or naturalness.
- "Humanization" score (informal term, likely referring to fluency/naturalness/human-likeness metrics — e.g., perplexity-based fluency scores, or human-eval style ratings): measures how natural/fluent/human-like the text **reads**, independent of whether it overlaps with any reference content.
- **Key distinction**: A response can score high on ROUGE-L (matches reference wording closely) but read awkwardly if it's a stitched/copied phrasing; conversely, a fully fluent, well-written answer can score low on ROUGE-L if phrased differently from the reference despite being high quality. These two axes (content-overlap vs. fluency) are independent — a good RAG answer should ideally be evaluated on both content faithfulness (not ROUGE-L, but faithfulness/relevancy) and fluency separately, not conflated.

---

### 6. Prompt Improvements + RAG

Common prompt-side levers to improve RAG output quality (likely the "how would you improve this" style question):

- Explicit grounding instruction: "Answer only using the provided context; if the answer isn't present, say so."
- Ask model to **cite** which chunk/source supports each claim (forces traceability, reduces hallucination).
- Chain-of-thought before final answer (reason over retrieved chunks first, then answer).
- Few-shot examples showing the desired grounded-answer format.
- Instruct explicit handling of conflicting information across retrieved chunks.

---

Ready for **Group 4 — Agents & Agentic Pipelines** when you are.