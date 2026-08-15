Here is a complete summation of the different model architectures and training paradigms we discussed, organized from the foundational mechanics to modern production pipelines.

  

## 1. Encoders (The Generalists)

_Used for understanding deep context in text or images._

  

- **Primary Goal:** To learn the underlying "physics" and structure of language or imagery.
    
      
    
- **Pre-Training Method:** Masked Language Modeling (BERT) or surrounding word prediction (Word2Vec). The model plays a massive fill-in-the-blank game to learn how concepts cluster based on context.
    
      
    
- **Contrastive Phase:** Used heavily in computer vision (SimCLR, MoCo) to prevent representation collapse by pulling augmented positive pairs together and pushing negative pairs apart.
    
      
    
- **Simplified Alternative:** Non-contrastive learning (SimSiam) removes negative pairs entirely, relying on stop-gradients and predictor heads to prevent collapse.
    
      
    

## 2. Bi-Encoders / Siamese Networks (The Search Specialists)

_Used for semantic search, vector databases, and matching._

  

- **Primary Goal:** To independently process two separate inputs (like a query and a document) so they can be mathematically compared at scale without running both through the same model simultaneously.
    
      
    
- **Training Method:** Contrastive Learning. It takes an already pre-trained encoder (like BERT) and fine-tunes it using pairs of sentences.
    
      
    
- **Mechanism:** Uses **tied weights** (one model in memory processing two inputs) and a pooling layer to compress sequences into single vectors. The loss function (Cosine Similarity or Triplet Loss) physically reshapes the vector space so related concepts land in the same coordinates.
    
      
    

## 3. Decoders (The Generators)

_Used for generative AI, chatbots, and following instructions (e.g., Llama, GPT)._

  

- **Primary Goal:** To generate text left-to-right.
    
      
    
- **Pre-Training Method:** Autoregressive Next-Token Prediction. Uses causal attention where each token can only "look back" at previous tokens.
    
      
    
- **Contrastive Phase (Alignment):** Uses techniques like DPO (Direct Preference Optimization) where the model is given a prompt with a good and bad response. Contrastive loss mathematically forces the weights to favor the good path over the bad one.
    
      
    
- **Embedding Workaround:** To use a decoder for embeddings, the system bypasses the Language Modeling Head and extracts the internal vector belonging to the final `[EOS]` token, which has absorbed the preceding context.
    
      
    

## 4. Encoder-Decoders (The Translators)

_Used for Sequence-to-Sequence tasks like Machine Translation._

  

- **Primary Goal:** To read an input sequence of varying length and map it to an output sequence of varying length (e.g., English to Italian).
    
      
    
- **Training Method:** Supervised learning using **Teacher Forcing** and Maximum Likelihood Estimation. The decoder is given the perfect ground-truth translation for the previous step to predict the next token, updating weights via Cross-Entropy Loss.
    
      
    
- **Contrastive Phase:** Added later to solve "exposure bias." Sequence-level contrastive learning evaluates the translation of entire sentences—rewarding the model for generating complete sequences that align with high-quality human translations rather than just predicting single words in a vacuum.