To understand how Sentence-BERT (SBERT) modifies the architecture, we first have to look at the massive bottleneck it was designed to fix.

  

### The Problem with Standard BERT (The Cross-Encoder)

If you want standard BERT to tell you if Sentence A and Sentence B are similar, you have to feed _both_ sentences into the model at the exact same time, separated by a special `[SEP]` token. The model processes them together and spits out a single similarity score.

  

This is called a **Cross-Encoder**. It is highly accurate, but incredibly slow. If you have a database of 1 million documents and want to find the closest match to a user's query, you would have to run the massive BERT model 1 million separate times—once for every `(Query + Document)` pair.

  

### The SBERT Solution (The Bi-Encoder)

Sentence-BERT solves this by modifying the architecture into a **Siamese Network** (or Bi-Encoder). It allows you to process Sentence A and Sentence B completely independently, meaning you can pre-compute and store the embeddings for your 1 million documents ahead of time.

  

Here are the three specific architectural modifications made to achieve this:

  
![[Pasted image 20260811171101.png]]
#### 1. The Siamese Structure (Tied Weights)

Instead of feeding both sentences into one model, SBERT uses two identical BERT networks running in parallel. One processes Sentence A, and the other processes Sentence B.

  

Crucially, these two networks have **tied weights**. They are actually the exact same model just being called twice. As the network learns and updates its weights during backpropagation, the updates are applied equally to both sides.

  

#### 2. The Pooling Layer

Standard BERT doesn't naturally output a single vector for a sentence; it outputs a vector for _every single word_ in that sentence.

  

SBERT adds a **Pooling Layer** right after the BERT output to compress those word-level vectors into a single, fixed-size sentence vector. The authors of SBERT experimented with a few pooling strategies:

  

- **Mean Pooling (Default):** Taking the mathematical average of all the word vectors in the sentence.
    
      
    
- **Max Pooling:** Taking the highest value across each dimension of the word vectors.
    
      
    
- **CLS Pooling:** Just taking the vector of the special `[CLS]` token that BERT puts at the start of every sequence.
    
      
    

_Mean Pooling_ was found to perform the best, becoming the standard for creating the final sentence embedding.

  

#### 3. The Objective Function (Training Head)

To train this Siamese network using contrastive pairs, SBERT attaches specific loss functions at the very top of the architecture to force the network to adjust its weights. The two most common are:

  

- **Cosine Similarity Loss:** The network calculates the cosine similarity between Vector A and Vector B. If the sentences are a positive pair, the loss function penalizes the network unless the similarity is pushed close to `1`. If they are a negative pair, it pushes them toward `-1`.
    
      
    
- **Triplet Loss:** This uses three inputs at once: an Anchor sentence, a Positive sentence (match), and a Negative sentence (mismatch). The loss function mathematically forces the distance between the Anchor and the Positive to be significantly smaller than the distance between the Anchor and the Negative.
    
      
    

Once training is complete, this top objective layer is thrown away. You are left with a single, highly specialized BERT model plus a pooling layer that can instantly convert any sentence into a search-ready vector.


---

# Reason for two model representations

That is a great observation. It is one of the most confusing parts of looking at neural network diagrams.

  

The short answer is: **There are not actually two models.**

  

The diagram shows two BERT blocks to illustrate the _flow of data_, not the physical reality of the software. To understand why, we have to look at what "tied weights" actually means inside your computer's memory.

  

### 1. Why the Diagram Shows Two Architectures (The "Siamese" Data Flow)

The diagram visualizes a **Siamese Network**. Like conjoined twins, a Siamese network is designed to process two separate inputs side-by-side so they can be compared.

  

If you are trying to find the similarity between Sentence A and Sentence B, the diagram shows Sentence A going down the left path, and Sentence B going down the right path. It draws two BERT models simply to show that the sentences are processed independently before their vectors meet at the very top for the cosine similarity calculation.

  

However, in reality, those two paths are passing through the exact same brain.

  

### 2. What "Tied Weights" Means Internally

In a neural network, a "weight" is just a number in a massive matrix. A standard BERT model has roughly 110 million of these numbers (weights) stored in your computer's RAM or GPU.

  

**Tied weights** (also called weight sharing) means that the left BERT and the right BERT in that diagram are literally the **exact same 110 million numbers in memory**.

  

Here is how it works under the hood during a training step:

  

1. **Forward Pass 1:** The system feeds Sentence A into the model. The model does its math using its current weights and spits out Vector A.
    
      
    
2. **Forward Pass 2:** The system feeds Sentence B into the _exact same model_, using the _exact same weights_, and spits out Vector B.
    
      
    
3. **Comparison:** The system compares Vector A and Vector B.
    
      
    
4. **Backpropagation (The crucial part):** When the network calculates how wrong its prediction was, it calculates the updates needed for Sentence A's pass, and the updates needed for Sentence B's pass. It then mathematically adds those two updates together, and applies them to that **single set of weights**.
    
      
    

### Why is this necessary?

If you actually used two separate, independent BERT models (with "untied" weights) to process the two sentences, it would be a disaster.

  

If BERT 1 and BERT 2 had different weights, they would have different mathematical definitions for the same words. BERT 1 might place the vector for "bank" (financial institution) in one area of space, while BERT 2 might place "bank" (river edge) in a completely different area.

  

By tying the weights, you force the architecture to use the exact same standard of measurement for both sentences. You guarantee that if the word "apple" appears in both Sentence A and Sentence B, it goes through the exact same mathematical transformations, ensuring their final vectors exist in the exact same spatial universe and can be accurately compared.