### 1. `response.source_nodes` vs `response.response`

- `response.response` → the final generated **text answer** (string) from the LLM after synthesis over retrieved context.
- `response.source_nodes` → the list of underlying **retrieved nodes/chunks** (with `.node`, `.score`, `.metadata`) that were used to generate that answer — lets you trace _which_ documents/chunks contributed, their similarity scores, and metadata (e.g., page number, source file).
- **Use case distinction**: `.response` for the user-facing answer; `.source_nodes` for citation/traceability, debugging retrieval quality, or building "show sources" UI features.

**Likely mock angle**: "How would you verify faithfulness of an answer?" → cross-check `response.response` claims against `response.source_nodes` content programmatically or via an eval step.

---

### 2. "LlamaIndex for Everything" — Architectural Flaw

- LlamaIndex is optimized around **indexing + retrieval** abstractions (its core strength). Using it as the framework for _everything_ in an agentic system (orchestration, multi-agent coordination, complex control flow, tool chaining) forces those concerns through retrieval-shaped abstractions it wasn't primarily designed for.
- **Consequences**:
- Less flexibility/control over agent orchestration logic compared to frameworks built specifically for that (e.g., LangGraph for stateful multi-step workflows).
- Tighter coupling — swapping out just the retrieval piece or just the orchestration piece becomes harder if everything is inside one framework's opinionated structure.
- Overhead: pulling in a heavy indexing-focused framework for parts of the system that don't need indexing at all (e.g., simple tool-calling logic).
- **General principle** the question is testing: use the right tool per concern — LlamaIndex for retrieval/indexing, LangGraph/custom orchestration for agent control flow, rather than one framework doing all jobs.

---That covers Group 5 — it's short since most of the depth (sentence window retrieval) was already in Group 2.

Quick check before Group 6 (LangChain/LCEL): want the same depth/format as previous groups, or should I keep it even tighter given the token-mindfulness preference?