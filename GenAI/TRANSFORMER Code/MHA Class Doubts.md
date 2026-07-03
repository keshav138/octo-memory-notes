# Doubt 1
> Does this mean 4 words/tokens, 1 query and each represented by 512 embeddings per token, then this is converted into 8 different 3d matrixes/vectors

Let me correct a couple of the terms so the shape makes full sense.

**`(1, 4, 512)` — breaking down each number:**

|Position|Value|What it actually is|
|---|---|---|
|1st|`1`|**batch size** — how many sequences/sentences you're processing at once. Not "1 query." Q, K, V are three separate tensors, each with this same shape.|
|2nd|`4`|**seq_len** — number of tokens in that one sequence|
|3rd|`512`|**d_model** — embedding size per token|

So yes: 1 sentence, 4 tokens, each token a 512-dim vector. Correct so far, just swap "1 query" for "1 sequence in the batch" — batch size has nothing to do with Q/K/V, it's just how many sequences are in this forward pass.

**On the "8 different 3D matrices" part — this is the bit to adjust:**

It's not 8 separate matrices sitting side by side. It's **one single 4D tensor**, shape `(1, 8, 4, 64)`, where the `8` is just a new dimension inserted to represent heads.

Think of it like this: each token's 512-dim vector gets **cut into 8 contiguous slices of 64 numbers each** (no computation, just slicing). Slice 1 → head 1, slice 2 → head 2, etc. Every token contributes one slice to every head.

```
token vector (512 numbers):
[███████████ 512 dims ███████████]

sliced into 8 pieces of 64:
[64][64][64][64][64][64][64][64]
 h1  h2  h3  h4  h5  h6  h7  h8
```

So per head, you do have something you could call a "3D chunk": shape `(1, 4, 64)` — 1 sequence, 4 tokens, 64 dims each. There are 8 of these chunks, but PyTorch doesn't store them as 8 separate objects — it stores all 8 stacked together in one tensor `(1, 8, 4, 64)`, and operations run on all 8 in parallel via that extra dimension.

**One-line summary:** 4 tokens × 512-dim each → each token's 512 dims sliced into 8 groups of 64 → all 8 groups processed simultaneously (not as 8 separate matrices, but as one tensor with a "heads" axis).

# Doubt 2
> how are we sending values in self.W_q(Q), isnt W_q a variable

That is a great catch and one of the most common sources of confusion when first learning PyTorch!

You are completely right that `self.W_q` is stored as an instance variable. However, it is not a basic variable like an integer or a simple array; it is an **object**—specifically, an instance of the `nn.Linear` class.

Here is exactly why you can pass a value to it like a function:

### The Magic of Python's `__call__`

In Python, any object can be treated like a function if its class defines a special, hidden method named `__call__()`.

When you defined this in the `__init__` block:

Python

```
self.W_q = nn.Linear(d_model, d_model)
```

You created an `nn.Linear` object. Because `nn.Linear` inherits from PyTorch's base `nn.Module` class, it has a `__call__()` method built into it.

When you write `self.W_q(Q)`, Python sees that `W_q` is an object and secretly translates your code into this:

Python

```
self.W_q.__call__(Q)
```

### What happens inside `__call__`?

In PyTorch, the `__call__` method acts as a wrapper. When it is triggered, it does a few background tasks (like checking for PyTorch hooks) and then **automatically executes the layer's `forward()` function**.

So, writing `self.W_q(Q)` is essentially PyTorch shorthand for passing your input tensor `Q` through the forward pass of that specific Linear layer.

### The Mathematical Reality

Under the hood, passing `Q` into `self.W_q` executes the standard linear algebra operation for a fully connected layer:

$Q_{projected} = Q \cdot W_{weights}^T + b_{bias}$

- **$Q$** is the input you passed in.
    
- **$W_{weights}$** is the internal weight matrix that `nn.Linear` created and initialized when you instantiated it.
    
- **$b_{bias}$** is the internal bias vector (which is included by default in `nn.Linear`).
    

By writing `Q = self.split_heads(self.W_q(Q))`, you are telling PyTorch: "Take my input $Q$, run it through the $W_q$ linear layer to project it to a new vector space, and then immediately pass that resulting tensor into the `split_heads` function."

# Doubt 3
> How does the transpose function work, what does (1,2) translate to

This is another excellent question. Transposing a flat 2D grid (where rows just become columns) is easy to visualize, but when you jump to 4D tensors, it gets abstract very quickly.

Here is exactly how `transpose(1, 2)` works in this specific context.

### 1. Understanding the Dimensions (Axes)

Whenever you have a tensor in PyTorch, every dimension has an index number, starting at $0$.

Right before the transpose happens in the `split_heads` function, we reshaped our tensor into 4 dimensions using `.view(batch_size, seq_length, self.num_heads, self.d_k)`.

Here is how Python indexes those dimensions:

- **Dimension 0:** `batch_size` (How many sequences/sentences we are processing at once)
    
- **Dimension 1:** `seq_length` (How many words/tokens are in each sequence)
    
- **Dimension 2:** `num_heads` (How many attention heads we split the data into)
    
- **Dimension 3:** `d_k` (The number of values in each head's vector)
    

### 2. What `transpose(1, 2)` Translates To

When you call `.transpose(1, 2)`, you are giving PyTorch a very literal command: **"Take the data in Dimension 1 and swap its position with the data in Dimension 2. Leave everything else exactly where it is."**

**The Before and After:**

- **Before transpose:** `(batch_size, seq_length, num_heads, d_k)` $\rightarrow$ Indices: $(0, 1, 2, 3)$
    
- **After transpose:** `(batch_size, num_heads, seq_length, d_k)` $\rightarrow$ Indices: $(0, 2, 1, 3)$
    

### 3. Why We Are Doing This (The Mathematical Reality)

We do this swap entirely to set up the matrix multiplication (`torch.matmul`) that happens later in the `scaled_dot_product_attention` function.

When PyTorch does matrix multiplication on tensors with more than 2 dimensions, it applies a specific rule: **It only performs the matrix multiplication on the _last two_ dimensions.** It treats any dimensions before those as "batch" dimensions (meaning it just runs the operation in parallel for every item in those leading dimensions).

If we did _not_ transpose, the last two dimensions would be `(num_heads, d_k)`. We cannot multiply a "heads" matrix by a "features" matrix; that mathematically means nothing.

By swapping dimensions 1 and 2, our last two dimensions become `(seq_length, d_k)`.

- Now, PyTorch sees a grid where the rows are the **words** (`seq_length`) and the columns are the **features** (`d_k`).
    
- Because `batch_size` and `num_heads` are now sitting in positions $0$ and $1$, PyTorch treats them both as batches.
    

This allows the GPU to mathematically multiply the queries and keys for _every_ word, across _every_ attention head, for _every_ sentence in the batch, all simultaneously in one massive, highly parallelized operation.

# Doubt 4

> How are we categorizing d_k as features, I understand keep seq_length as words but what about d_k?

This is a great clarifying question. When you transition from natural language (words) to machine learning (matrices), the terminology can get a bit abstract.

To understand why `d_k` represents "features," we have to trace it back to how words are fed into the Transformer in the first place.

### 1. From Words to Embeddings (The Full Feature Set)

Computers cannot read the word "apple," so we convert it into a vector of numbers called an **embedding**.

If your `d_model` is $512$, it means the word "apple" is represented by a list of $512$ different numbers. In machine learning, every single one of those numbers is called a **feature**.

- In a perfect, human-readable world, feature #1 might represent "fruit-ness," feature #2 might represent "redness," and feature #3 might represent "crunchiness."
    
- In mathematical reality, these $512$ numbers are _latent features_—abstract, continuous values the neural network learns during training to capture the semantic meaning of the word.
    

So, a tensor of size `(seq_length, d_model)` is just a 2D spreadsheet where the rows are the words in your sentence, and the $512$ columns are the features describing those words.

### 2. Slicing the Features: Where `d_k` Comes In

In Multi-Head Attention, we don't want a single attention mechanism looking at all $512$ features at once. It gets overwhelmed. Instead, we want different "heads" to specialize in looking at different subsets of those features.

This is exactly what `self.d_k = d_model // num_heads` does.

- If `d_model` is $512$ and we have $8$ heads, then `d_k` is $64$.
    
- We literally chop that massive $512$-feature vector into $8$ smaller chunks of $64$ features.
    

### 3. The Mathematical Reality of `(seq_length, d_k)`

When PyTorch looks at that final transposed matrix of size `(seq_length, d_k)`, it sees a grid where:

- **The rows (`seq_length`):** Are still the words in your sequence.
    
- **The columns (`d_k`):** Are now just $64$ specific features out of the original $512$.
    

By categorizing `d_k` as the features dimension, we are telling the math: "For this specific attention head, calculate the dot product similarity between the words based _only_ on these $64$ numerical traits."

One head might use its $64$ features (`d_k`) to calculate similarities based on grammar (e.g., matching verbs to nouns). Another head might use its $64$ features to calculate similarities based on sentiment (e.g., matching "not" to "good").

# Doubt 5
> Can you also clarify the masking step,where we change 0's with -1e9's

This is one of the most clever mathematical tricks in the entire Transformer architecture.

To understand why we use `-1e9` (which is scientific notation for $-1,000,000,000$, acting as a stand-in for negative infinity), we have to look at the exact mathematical operation that happens immediately _after_ the mask is applied: the **Softmax** function.

Here is the breakdown of why we do this.

### 1. The Purpose of the Mask

Before we do the math, we need to know what the mask is actually doing. In natural language processing, sequences are often padded with empty "filler" tokens to make them all the same length. Additionally, in tasks like text generation, we want to prevent the model from "looking ahead" at words it hasn't generated yet.

The mask is just a grid of 1s and 0s:

- **1** means "this is a valid word, you are allowed to pay attention to it."
    
- **0** means "this is padding or a future word, completely ignore it."
    

### 2. The Mathematical Reality of Softmax

Right after we apply the mask to our `attn_scores`, we run this line of code:

Python

```
attn_probs = torch.softmax(attn_scores, dim=-1)
```

The mathematical formula for Softmax relies on Euler's number ($e \approx 2.718$). It takes a vector of raw scores and turns them into probabilities (percentages that add up to 1.0) by calculating $e$ to the power of every score:

$$Softmax(x_i) = \frac{e^{x_i}}{\sum e^{x_j}}$$

### 3. Why We Can't Just Use 0

If we want the model to ignore a word, your first instinct might be to just multiply the score by 0 to zero it out. But look at what happens when we plug 0 into the Softmax formula:

$e^{0} = 1$

If we replace the masked scores with 0, Softmax calculates $e^0$ and outputs a 1. Because the numerator is now 1, the Softmax function will still assign a positive percentage (probability) to that word. The model would end up paying a small amount of attention to empty padding tokens, which corrupts the output.

### 4. The -1e9 Trick (Negative Infinity)

Instead of using 0, the code uses `.masked_fill(mask == 0, -1e9)` to replace all the invalid scores with a massive negative number.

Look at what happens when we plug negative infinity into the Softmax formula:

$e^{-\infty} \approx 0$

By replacing the raw scores of padded or future words with `-1e9`, we force the math to yield exactly zero. When Softmax calculates $e^{-1000000000}$, the result is so infinitesimally small that the computer rounds it down to a flat 0.0.

Because the resulting probability is exactly 0.0, when we do the final matrix multiplication with the Value matrix ($V$), those invalid words contribute absolutely nothing to the final output. They are mathematically erased.