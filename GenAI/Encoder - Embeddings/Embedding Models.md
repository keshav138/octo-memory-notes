To clarify a common point of confusion: **Sentence-BERT (SBERT) isn't actually a single model.** It is a _framework and training methodology_.

  

When researchers release a "Sentence-BERT model," they have usually taken an existing foundational model (like standard BERT, RoBERTa, or MiniLM) and put it through the Siamese network contrastive training we discussed earlier.

  

The original authors of SBERT created the incredibly popular open-source Python library **`sentence-transformers`**, which houses thousands of these models.

  

Here is a breakdown of the specific models that use the SBERT architecture, followed by the modern alternatives that have evolved beyond it.

  

### 1. Models utilizing the SBERT Architecture (Bi-Encoders)

If you browse Hugging Face for embeddings, almost all of the traditional lightweight models were trained using the SBERT framework. They are highly efficient and great for running locally.

  

- **all-MiniLM-L6-v2:** One of the most popular open-source embedding models. It is a highly compressed (distilled) version of a BERT model that was trained using the SBERT Siamese architecture. It is extremely fast, lightweight, and perfect for basic search tasks.
    
      
    
- **all-mpnet-base-v2:** Often considered the highest-quality traditional SBERT model. It uses a slightly different foundational architecture (MPNet instead of BERT) but applies the exact same Siamese contrastive training and mean pooling to generate sentence vectors.
    
      
    
- **Paraphrase-Multilingual-MiniLM:** An SBERT model specifically trained on parallel datasets (e.g., matching an English sentence with its exact Spanish translation) so that vectors align across 50+ languages.
    
      
    

### 2. Other Embedding Architectures (Alternatives to SBERT)

While SBERT was revolutionary, the field has evolved over the last few years to solve edge cases where standard Bi-Encoders struggle. Here are the other major architectures used today:

  

#### A. Late Interaction Models (e.g., ColBERT)

**The Problem with SBERT:** SBERT forces an entire document—no matter how complex—into a single vector (Mean Pooling). This is like summarizing a whole book into one coordinate; nuanced details get lost.

**The Solution:** ColBERT (Contextualized Late Interaction over BERT) does _not_ pool the sentence into one vector. It keeps a separate vector for every single token (word) in the query and every single token in the document.

  

- **How it works:** During a search, it performs a highly optimized matrix calculation (MaxSim) to see if individual query words align with specific document words. It is vastly more accurate for complex technical searches than SBERT, though it requires much more storage space in the vector database.
    
      
    

#### B. Decoder-Only (LLM-based) Embeddings

Instead of using small, bidirectional models like BERT (which usually cap out at around 100M–300M parameters), modern commercial APIs use massive, GPT-style models to generate embeddings.

  

- **Examples:** OpenAI `text-embedding-3`, Cohere Embed, Voyage AI.
    
      
    
- **How they work:** They use the same architecture as ChatGPT (Transformers with causal attention). To get a sentence embedding, they feed the text through the massive LLM and usually extract the vector associated with the very last token in the sequence, under the assumption that the final token has "attended" to the entire sentence before it. These models understand deep semantics much better than SBERT simply due to their massive scale.
    
      
    

#### C. Instruction-Tuned Embeddings

**The Problem with SBERT:** A standard vector doesn't know _why_ you are searching for it. Are you looking for a factual answer? A text classification? A semantic similarity match?

**The Solution:** Models like **Instructor-XL** or the **BGE (BAAI General Embedding)** series require you to pass an instruction alongside your text.

  

- **How it works:** Instead of just embedding "Python syntax", you embed: _"Represent the Wikipedia document for retrieval: Python syntax"_. The model dynamically shifts the resulting vector space based on the specific task you define in the prompt.
    
      
    

#### D. Multi-Modal Embeddings (e.g., CLIP)

If you want to search a database of images using a text query, SBERT won't work because it only understands text.

  

- **How it works:** Models like OpenAI's **CLIP** use a Siamese architecture very similar to SBERT, but instead of two BERT models, they use one Text Encoder (like BERT) and one Image Encoder (like a Vision Transformer or ResNet). During contrastive training, it learns to push the text vector for "a dog" into the exact same coordinates as the image vector for a picture of a dog.

---

# LLM's as Embedding Models
When running quantized open-source models in local containerized environments, the architecture you are almost entirely interacting with is **Decoder-Only** (like Llama, Mistral, or Qwen).

  

Using these models to generate embeddings requires a clever workaround, because they were designed to predict the next word, not to summarize an entire sentence into a single mathematical point.

  

Here is exactly how the extraction process works under the hood.

  

### 1. The Challenge: Causal (Left-to-Right) Attention

In a standard Bi-Encoder (like BERT), every word can "look" at every other word in the sentence simultaneously.

  

Decoder-only models, however, use **causal attention** (also called masked self-attention). This means a token can only pay attention to the tokens that came _before_ it.

  

- If you feed the model the sentence: `"The quick brown fox"`, the word `"brown"` only knows about `"The"` and `"quick"`. It has absolutely no idea that the word `"fox"` is coming next.
    
      
    

Because of this strict left-to-right rule, you cannot just grab the vector for the word `"The"` to represent your sentence, because it contains zero information about the rest of the text.

  

### 2. The Extraction Mechanism: The `[EOS]` Token Strategy

To extract a single vector that represents the entire sentence, the model relies on the very last token in the sequence.

  

When you pass a string of text to a decoder-only embedding model, the system automatically appends a special End-of-Sequence token (usually `[EOS]`) to the end of your text.

  

- Input: `"The quick brown fox [EOS]"`
    
      
    

As the sequence passes through the transformer layers, that final `[EOS]` token acts like a sponge. Because it is positioned at the very end, the left-to-right causal attention rules allow it to "look back" and aggregate the mathematical context of every single preceding word in the sentence.

  

**The Extraction:** The system ignores the vectors generated for all the other words. It solely extracts the final hidden state (the vector) belonging to that `[EOS]` token, trusting that it has absorbed the meaning of the entire prompt.

  

_Note: Some newer decoder-based embedding architectures use Mean Pooling (averaging all the tokens together, like SBERT), but the `[EOS]` token extraction remains the standard, most native way to extract embeddings from generative LLMs._

  

### 3. Bypassing the LM Head (The Code Level)

If you look at the architecture of a generative LLM, the final layer is usually the **Language Modeling (LM) Head**. This is a massive matrix that converts the final token's vector into a probability distribution over the model's entire vocabulary (say, 32,000 words) so it can pick the next word to type.

  

When an engine pulls an embedding from a decoder model, it **completely bypasses this LM Head**.

  

Instead of asking the model "what word comes next?", the software hooks into the layer _just before_ the LM head and intercepts the raw multidimensional vector (for example, a 4,096-dimensional array of floats).

  

### 4. The Final Polish: Projection and Normalization

Once that `[EOS]` vector is intercepted, it usually goes through two quick mathematical cleanup steps before it is handed back to you:

  

1. **Projection (Dimensionality Reduction):** 4,096 dimensions is often too large and expensive to store in a vector database. The vector is usually passed through a small, trained linear layer that projects (compresses) it down to a more manageable size, like 1536 or 1024 dimensions.
    
      
    
2. **L2 Normalization:** The vector is mathematically scaled so its overall length (magnitude) is exactly 1. This ensures that when the vector database calculates Cosine Similarity later, it only has to measure the angle between vectors, ignoring their lengths, which makes search pipelines significantly faster.