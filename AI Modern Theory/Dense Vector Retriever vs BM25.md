Using BM25 and a vector retriever together—a technique known as **Hybrid Search**—allows you to combine the "literal" precision of keyword matching with the "conceptual" understanding of vector search.

This approach is highly effective because it covers the blind spots of both methods: BM25 excels at exact matches (like product codes or technical terms), while vector search excels at understanding intent and context (like synonyms or paraphrased questions).

### How to Implement Hybrid Search

The process generally follows a three-step workflow: **Parallel Retrieval**, **Normalization**, and **Fusion**.

#### 1. Parallel Retrieval

When a user submits a query, it is sent to both systems simultaneously:

- **BM25 Retriever:** Searches for documents containing exact keywords or phrases based on term frequency (TF-IDF).
    
- **Vector Retriever:** Converts the query into a high-dimensional embedding and retrieves documents that are semantically similar.
    

#### 2. Normalization (The "Apple-to-Apples" Step)

The biggest challenge is that BM25 scores (unbounded) and vector scores (typically -1 to 1) operate on different scales. You cannot simply add them together. You must normalize them first:

- **Min-Max Scaling:** Scales scores to a range of 0 to 1 based on the maximum and minimum values in the result set.
    
- **Rank-Based Methods:** Ignore raw scores entirely and focus only on the _position_ of the document in the list (e.g., 1st, 2nd, 3rd).
    

#### 3. Fusion (Merging the Results)

Once normalized, you merge the lists into one. Two common techniques are:

- **Reciprocal Rank Fusion (RRF):** The industry standard. It assigns a score to documents based on their rank: $\text{Score} = \frac{1}{\text{rank} + k}$ (where $k$ is a constant, usually 60). It prioritizes documents that appear in the top results of _both_ systems.
    
- **Weighted Sum (Alpha Blending):** If you know one method is more reliable for your data, you can assign weights:
    
    $$\text{Final Score} = (\alpha \times \text{Normalized BM25}) + ((1 - \alpha) \times \text{Normalized Vector Score})$$
    

### Comparison of Strengths

|**Search Type**|**Best At**|**Weakness**|
|---|---|---|
|**BM25**|Exact keywords, IDs, acronyms, technical jargon.|Fails if the user uses different words for the same concept.|
|**Vector**|Intent, synonyms, natural language, cross-lingual queries.|Can "hallucinate" relevance or miss exact technical matches.|
|**Hybrid**|**Precision + Intent.** Provides the most complete, contextually relevant context.|Slightly more complex to tune and maintain.|

### Pro-Tip: The "Reranker" Pattern

For production systems, many teams add a **fourth step**:

After the hybrid search retrieves a combined list (e.g., the top 50 candidates), they use a **Cross-Encoder Reranker**. Unlike the bi-encoders used in vector search, a cross-encoder looks at the query and the document _at the same time_. It is computationally expensive but provides the highest possible precision, ensuring that the documents sent to your LLM for the final answer are the most relevant ones possible.

**Where to start?** If you are just beginning, use **RRF** as your baseline fusion method. It requires no "tuning" (like picking weights for $\alpha$) and is robust enough to outperform single-method search in almost all cases.