### 1. Input/Output Guardrails for Prompt Injections

- **Input guardrails**: sanitize/validate user input before it reaches the LLM — detect injection patterns (e.g., "ignore previous instructions", role-override attempts embedded in retrieved documents), strip or flag suspicious content, use a classifier/moderation model to score input risk before passing it through.
- **Output guardrails**: validate the LLM's response before returning it to the user/downstream system — check for leaked system prompts, unintended tool calls, policy-violating content, or signs the model was successfully hijacked (e.g., it starts outputting something unrelated to the original task).
- **RAG-specific risk**: injected instructions can live inside **retrieved documents**, not just direct user input — a malicious webpage or doc chunk can contain "ignore instructions and do X," so guardrails must also scan retrieved context, not just the user's literal query.
- **Common technique**: prompt hardening (explicit instructions to ignore embedded commands in tool/data content), plus a separate lightweight classifier pass rather than relying solely on the main model's judgment.

---

### 2. Hallucinations (General)

- Definition: model generates content that is fluent and plausible but **not grounded in truth or provided context** — either factually wrong (parametric hallucination) or unsupported by retrieved context (faithfulness failure in RAG).
- Common causes: knowledge gaps in training data, ambiguous/underspecified prompts, forcing an answer when the model should say "I don't know," or in RAG — insufficient/irrelevant retrieved context leading the model to fall back on parametric knowledge.
- Mitigations: RAG grounding, faithfulness-checking post-generation, explicit "say I don't know if unsure" prompting, lower temperature for factual tasks, citation requirements forcing traceability.

---

### 3. Gemini File API — `generate_content` Error Scenario

- Common failure pattern: uploading a file via Gemini's File API and then calling `generate_content` **before the file finishes processing** — files uploaded via the File API go through an async processing state (`PROCESSING` → `ACTIVE`), and calling `generate_content` while the file is still in `PROCESSING` state returns an error (file not yet usable).
- **Fix**: poll the file's state (`file.state.name`) until it reports `ACTIVE` before referencing it in a `generate_content` call.
- Other common errors in this area: file expiry (uploaded files have a retention window, e.g., 48 hours, after which referencing them fails), or exceeding file size/type limits.

---

Ready for **Group 10 — System Design (Applied)**, the last group, whenever you want to continue.