### 1. Agent Episodic Memory

- **Episodic memory** in agents = memory of specific past events/interactions (what happened in a particular session/task), as opposed to **semantic memory** (general facts/knowledge) or **procedural memory** (learned skills/how-to).
- Used to let an agent recall "what did I try before, what worked/failed" across a task or across sessions — enables learning from past attempts rather than repeating mistakes.
- Typically implemented as a log/store of (state, action, outcome) tuples, often retrieved via similarity search when facing a similar situation again.

**Likely mock angle**: "Why would an agent need episodic memory vs just context window?" — context window is bounded and lost after a session ends; episodic memory persists across sessions and can be selectively retrieved.

---

### 2. Agentic Pipeline Step Removal — Consequences

- Agentic pipelines are usually structured as sequential/graph steps (e.g., plan → retrieve → tool-call → verify → respond). Removing a step depends on which one:
- Remove **verification/self-check step** → higher risk of hallucinated/incorrect final output going unchecked.
- Remove **planning step** → agent jumps straight to action without decomposing the task, more likely to fail on multi-step tasks.
- Remove **retrieval step** → loses grounding, falls back to parametric knowledge (hallucination risk).
- General consequence: reduced pipeline robustness — likely faster/cheaper but with a direct tradeoff in accuracy, grounding, or error-recovery ability. The mock question likely wants you to reason about _which specific step_ and _what specific failure mode_ results, not a generic "it gets worse" answer.

---

### 3. Agentic Loop Failures / Errors

Common agentic loop failure modes:

- **Infinite loop**: agent repeats the same action without making progress (e.g., stuck calling the same tool because it doesn't recognize task completion).
- **Tool misuse**: wrong tool selected, or correct tool called with malformed arguments.
- **State drift**: agent loses track of goal across many steps (context window pressure, no persistent state).
- **Premature termination**: agent decides it's "done" before actually completing the task.
- **Cascading errors**: an early wrong tool result poisons all subsequent reasoning since the agent trusts its own prior outputs.

Mitigations: max iteration caps, explicit stopping criteria, self-consistency checks, human-in-the-loop checkpoints.

---

### 4. Multi-Agent Review Chain — Quality Plateau After Time

- Setup: multiple agents review/critique each other's output in a chain (e.g., generator → critic → reviser → critic...).
- **Why quality plateaus**: after a few rounds, agents start converging on **agreement rather than improvement** — critics run out of genuinely new critique to offer and start rephrasing prior feedback, or the reviser makes only cosmetic changes. This is similar to diminishing returns in iterative refinement — without new information/context injected into the loop, the agents are just re-processing the same signal.
- **Fix pattern**: inject fresh external context per round (new retrieval, new tool calls), or use a _diverse_ set of critics with different evaluation criteria rather than the same one looping, or cap rounds and add a hard convergence/stopping metric.

---

### 5. AutoGen Group Chat (Situational)

- AutoGen's `GroupChat` lets multiple agents (each with a role/system prompt) converse in a shared thread, coordinated by a `GroupChatManager` that decides which agent speaks next (round-robin, or LLM-selected based on relevance).
- Situational question likely tests: how to control speaker selection (custom `speaker_selection_method`), how to prevent one agent from dominating, or how to terminate the chat (via `is_termination_msg` or max rounds) — since without proper termination/selection logic, a group chat can loop indefinitely or ignore quieter agents with relevant input.

---

### 6. Agent Eval — High Score but Reasoning Flawed

- A common failure: an agent scores well on **outcome-based metrics** (task completion, final answer correctness) while its **reasoning trace** is flawed (wrong logic that coincidentally arrives at the right answer, or skipped verification steps).
- This is why agent eval increasingly needs **process-level evaluation** (checking intermediate steps/tool calls/reasoning chain), not just final-answer scoring — a high final score can mask brittle reasoning that will fail on slightly different inputs.

---

### 7. ReAct for Code Q&A

- **ReAct** = Reasoning + Acting — the agent interleaves **thought** (reasoning about what to do next) with **action** (tool call, e.g., running code, searching docs) and **observation** (tool result), looping until it can answer.
- For code Q&A specifically: agent reasons about what the question needs (e.g., "I need to check this function's definition"), acts (calls a code-search/execution tool), observes the result, and iterates — rather than answering purely from the LLM's memory of the codebase, which risks being stale or hallucinated.
- Advantage over plain prompting: grounds answers in actual current code state (via tool calls) rather than assumed/remembered code behavior.

---

Ready for **Group 5 — LlamaIndex Specifics** next.****