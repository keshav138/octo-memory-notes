LangChain and LangGraph are both open-source tools built by the same team, but they serve different roles in the AI development stack [1.1.2, 1.1.3]. You do not have to choose between them; they are designed to work together [1.1.2, 1.1.4].

### At a Glance: The Core Difference

- **LangChain** is the **framework for building** [1.1.2, 1.3.1]. It provides the modular building blocks (prompts, tool integrations, retrievers) and a way to connect them in simple, linear pipelines [1.1.2, 1.1.4].
    
- **LangGraph** is the **runtime for orchestrating** [1.1.1, 1.1.2]. It provides a graph-based engine that allows you to build complex, stateful applications that require loops, branching, and persistence [1.1.1, 1.1.4].
    

### Detailed Comparison

|**Feature**|**LangChain**|**LangGraph**|
|---|---|---|
|**Primary Goal**|Building modular LLM workflows [1.1.4]|Orchestrating complex, stateful agents [1.1.4]|
|**Workflow Shape**|Linear (Directed Acyclic Graph) [1.1.2, 1.3.1]|Cyclic/Graph (Loops, branches, cycles) [1.1.2, 1.3.1]|
|**State**|Mostly implicit or component-local [1.1.4]|Centralized, explicit, and persistent [1.1.3, 1.1.4]|
|**Best For**|Prototyping, RAG, linear tasks [1.1.4, 1.3.1]|Resilient, production-ready, multi-agent systems [1.1.4, 1.3.1]|

### When to Use Which

In practice, most developers use both [1.1.2, 1.3.1]. You can build your core components (like tool connectors and prompt templates) using **LangChain**, and then use **LangGraph** to manage the execution logic if that logic needs to be dynamic [1.1.3, 1.1.4].

#### Use LangChain if:

- You are building a **linear pipeline** (e.g., Query $\rightarrow$ Retrieve $\rightarrow$ Summarize $\rightarrow$ Answer) [1.1.4, 1.2.2].
    
- You need to prototype quickly or build a simple MVP [1.2.2].
    
- Your workflow does not require complex loops, retries, or long-term memory across sessions [1.1.4, 1.2.2].
    

#### Use LangGraph if:

- Your application needs to **loop** (e.g., "try a tool, check if it worked, if not, retry or switch tools") [1.1.4, 1.2.2].
    
- You are building **multi-agent systems** where different agents collaborate [1.1.6, 1.3.1].
    
- You need **persistence** (the ability to pause, save state, and resume later) or human-in-the-loop approval steps [1.1.4, 1.1.7].
    
- Your logic needs to adapt dynamically based on previous intermediate results [1.1.6, 1.2.2].
    

### Summary

Think of **LangChain as your "Lego kit"**—it gives you the pieces to build individual parts of your application [1.1.4]. **LangGraph is your "Control Panel"**—it allows you to arrange those pieces into a complex, intelligent machine that can think, loop, and handle failures in the real world [1.1.4, 1.1.5].