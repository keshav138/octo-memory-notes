### 1. Architecture for: Doc Search Engine, Chatbot, Fraud Alert Summarizer

**Doc Search Engine**

- Ingestion: doc loader → chunking → embedding → vector DB (+ metadata for filters like date/author)
- Retrieval: hybrid (BM25 + dense) → optional re-ranker (cross-encoder) → return top-k with citations
- No generation needed unless summarized snippets are required

**Chatbot (conversational, likely RAG-backed)**

- Query → retriever → context assembly → LLM generation with conversation history
- Needs: session/memory management, guardrails (input/output), streaming response, fallback for out-of-scope queries

**Fraud Alert Summarizer**

- Likely event-driven: fraud detection system emits alerts (structured data: transaction, risk score, flags) → LLM summarizes into human-readable analyst report
- Needs: strict faithfulness to structured input (no hallucinated numbers), templated/constrained generation, possibly batch processing (not real-time chat-style), audit trail (summarized output must be traceable to raw alert data)

**Common thread across all three**: the differentiator is retrieval-heavy + citation-focused (doc search) vs conversational state (chatbot) vs structured-data-to-text with strict faithfulness (fraud summarizer) — mock questions likely probe whether you'd reuse the same RAG pipeline for all three (you shouldn't — fraud summarizer especially needs stricter grounding, less "creative" generation).

---

### 2. Web Scraping: WebBaseLoader vs BeautifulSoup

- **BeautifulSoup**: a raw HTML parsing library — you fetch the page yourself (e.g., via `requests`) and manually parse tags/structure. Full control, but you write the extraction logic yourself.
- **WebBaseLoader** (LangChain): a higher-level wrapper that uses BeautifulSoup under the hood but handles fetching + parsing + returning LangChain `Document` objects directly, ready to plug into a chain/pipeline.
- **When to use which**: `WebBaseLoader` for quick, standard use in a LangChain pipeline (less code, standard output format); raw `BeautifulSoup` when you need custom parsing logic (specific tag extraction, handling non-standard page structures) that the loader's defaults don't handle well.

---That's all 10 groups covered. Want a consolidated summary doc pulling all groups together, or are you set to move into practice questions/mock drilling from here?