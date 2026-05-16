This gets straight to the conceptual heart of LCEL (LangChain Expression Language). Understanding these two design choices will change how you think about LangChain pipelines entirely.

---

### 1. What is the use of `RunnablePassthrough`?

Think of `RunnablePassthrough` as a **dummy pipeline step that acts like a straight, empty data pipe**. Its sole job is to take whatever input it receives and forward it to the next step completely untouched.

#### Why do we need it here?

When you trigger your pipeline by running `chain.invoke(question)`, you pass a single raw string into the chain (e.g., `"What is a consensus algorithm?"`).

However, right at the start of your chain, you are splitting that single string into a dictionary.

- Your `context` track needs that question string to look up vectors in ChromaDB.
    
- Your `question` track _also_ needs that exact same question string to eventually paste it into the prompt.
    

Python

```
{
    "context": retriever | format_docs,  # 1. Question goes here to find documents
    "question": RunnablePassthrough()    # 2. Question ALSO goes here completely untouched
}
```

If `RunnablePassthrough()` wasn't there, the user's question string would enter the dictionary, find nothing to handle it on the right side of `"question":`, and get dropped. By using `RunnablePassthrough()`, you are telling LangChain: _"Take the exact string the user typed to trigger this chain, do absolutely nothing to it, and map it directly to the key name `'question'`."_

---

### 2. Why exactly are we putting `context` and `question` in curly brackets?

In Python, curly brackets `{}` define a **Dictionary** (a map of key-value pairs). In LCEL, when you place a dictionary at the beginning of a pipe sequence, LangChain automatically treats it as a **`RunnableParallel`** block.

You are using curly brackets for two vital structural reasons:

#### Reason A: To match your Prompt Template

Your `RAG_PROMPT` is an template that acts like a Python f-string. It sits waiting for two explicit variables to fill in its empty slots: `{context}` and `{question}`.

Plaintext

```
Answer the question based on the background data.
Context: {context}
Question: {question}
```

An LLM prompt template cannot accept a raw string and a raw list of documents simultaneously. It _requires_ an input dictionary where the keys match its variable names exactly. The curly brackets construct that exact dictionary wrapper.

#### Reason B: Parallel Processing (Speed)

When LangChain encounters a dictionary inside an LCEL pipe, it fires off all the values inside that dictionary **concurrently (in parallel)**.

```
                  ┌──> retriever | format_docs ──> (Fetches Text from DB) ──┐
                  │                                                         │
User Question ────┼─────────────────────────────────────────────────────────┼──> Combined Dictionary {context, question} ──> RAG_PROMPT
                  │                                                         │
                  └──> RunnablePassthrough ──────> (Holds Raw Question) ────┘
```

Instead of waiting for the database to finish searching _before_ passing the question along, LangChain splits the workload instantly:

1. Track 1 runs your vector search and text formatting.
    
2. Track 2 simply holds onto your question.
    

The moment both tracks finish their jobs, LangChain bundles their outputs into a single completed dictionary—`{"context": "...", "question": "..."}`—and shoots it down the pipe directly into the prompt template.

Without those curly brackets, you wouldn't have a structured dictionary to feed your prompt, and you wouldn't be able to run those operations side-by-side!

---

To see these components applied visually in real-time workflows, this [LangChain Runnables Tutorial](https://www.youtube.com/watch?v=bJNOZSffpRc) breaks down the differences between `RunnableParallel`, `RunnableLambda`, and `RunnablePassthrough` using easy-to-follow code examples.