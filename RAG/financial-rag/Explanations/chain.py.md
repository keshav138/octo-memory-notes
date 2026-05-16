That's actually a really important observation — note it for interviews.

The retrieval quality issue at this stage is expected and comes down to a few things we can tune later:

- `k=5` might be too low or too high
- `chunk_size=1000` with `chunk_overlap=200` might be splitting context awkwardly for financial docs
- `all-MiniLM-L6-v2` is a general model, not finance-specific
- No reranking yet

We'll revisit this after the full pipeline is working. It's a good interview talking point — _"I identified retrieval quality issues and here's how I addressed them."_

---

Now `chain.py` — this is where everything connects.

### `app/rag/prompts.py` first — keep it separate

```python
from langchain.prompts import PromptTemplate

RAG_PROMPT = PromptTemplate(
    input_variables=["context", "question"],
    template="""
You are a financial analyst assistant. Answer the question using ONLY the context provided below.
If the answer is not in the context, say "I cannot find this information in the provided document."
Do not make up numbers, dates, or financial figures.

Context:
{context}

Question:
{question}

Answer:
"""
)
```

---

### `app/rag/chain.py`

```python
from langchain_groq import ChatGroq
from langchain_core.runnables import RunnablePassthrough # sort of a placeholder, keeps the value it recieves as it is

from langchain_core.output_parsers import StrOutputParser # llm returns a ai_object, this parses it as a raw string

from app.rag.vectorstore import get_retriever
from app.rag.prompts import RAG_PROMPT

import os
from dotenv import load_dotenv

load_dotenv()


def get_llm():
    """
    Function to fetch llm object
    """
    return ChatGroq(
        api_key = os.getenv('GROQ_API_KEY'),
        model = 'llama3-8b-8192',
        temperature = 0.1, # remains factual
        max_tokens = 1024
    )
  
def format_docs(docs) -> str:
    """
    Joins returned docs by ChromaDB and joins them into one cohesive string
    """
    return "\n\n".join(doc.page_content for doc in docs)

def get_rag_chain():

    llm = get_llm()
    retriever = get_retriever(k=5)
    
    """
    this is just a created object, a blueprint, a single value when passed will go the first one's first, the dictonary, both to question and context
    both get a copy of the question
    """

    chain = (
        {
            "question":RunnablePassthrough(),
            "context": retriever | format_docs
        }
        | RAG_PROMPT
        | llm
        | StrOutputParser()
    )
    return chain, retriever


def query_rag(question: str) -> dict:
    chain, retriever = get_rag_chain()
    # one call to get context, because the llm output strips everything, only keeps answer
    source_docs = retriever.invoke(question)
    # one call to get the output
    
    answer  = chain.invoke(question)
    sources = [
        {
            'page' : doc.metadata.get('page'),
            'content': doc.page_content[:200]
        }
        for doc in source_docs
    ]

    return {
        "answer" : answer,
        "source" : sources
    }
```

---

### What's happening here — learn this

**`temperature=0.1`**

- Low temperature = deterministic, factual answers
- For financial data you never want high temperature — hallucinated numbers are dangerous
- Good interview point: _"I deliberately set low temperature because financial accuracy is non-negotiable"_

---

### Quick test

```python
from app.rag.chain import query_rag

result = query_rag("what are the main risk factors?")

print("Answer:", result["answer"])
print("\nSources:")
for s in result["sources"]:
    print(f"  Page {s['page']}: {s['snippet'][:100]}")
```

Run this and check if the answer is grounded. Once working we move to `main.py` — the FastAPI layer.