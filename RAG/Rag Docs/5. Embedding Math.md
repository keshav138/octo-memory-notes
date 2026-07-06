Sure. Let's use numbers that are closer to what modern LLMs actually deal with.

### Step 1: Token IDs

The tokenizer doesn't feed text directly into the model.

Suppose:

```text
"The cat sat on the mat"
```

becomes:

```text
[791, 8415, 6532, 389, 279, 5634]
```

These are token IDs from a vocabulary.

A modern LLM vocabulary is often around:

- 50,000–200,000 tokens
    
- Many current models are roughly 100k+ vocabulary size
    

---

### Step 2: Embedding lookup

Each token ID maps to a vector.

For a smaller model:

```text
Embedding size = 768
```

For larger models:

```text
Embedding size = 4096
6144
8192
12288
```

Let's say a model uses:

```text
Embedding dimension = 8192
```

Then token 8415 ("cat" or whatever it represents) becomes:

```text
[-0.17, 0.44, 1.21, ..., 0.08]
```

with **8192 numbers**.

---

### Step 3: A sentence becomes a matrix

Suppose your prompt contains:

```text
1000 tokens
```

Each token gets an 8192-dimensional embedding.

The model is now processing a matrix of:

```text
1000 × 8192
```

which is:

```text
8,192,000 numbers
```

just to represent the current state of the tokens.

---

### Step 4: Attention explodes the computation

The expensive part is attention.

For every token, the model asks:

```text
How relevant is token 1?
How relevant is token 2?
How relevant is token 3?
...
How relevant is token 1000?
```

For 1000 tokens:

```text
1000 × 1000
= 1,000,000
```

pairwise comparisons.

For 10,000 tokens:

```text
10,000 × 10,000
= 100,000,000
```

comparisons.

For 100,000 tokens:

```text
100,000 × 100,000
= 10,000,000,000
```

comparisons.

This is why long-context models are so computationally expensive.

---

### Step 5: Parameter scale

The embedding table itself can be huge.

Suppose:

```text
Vocabulary = 100,000 tokens
Embedding size = 8192
```

Embedding table size:

```text
100,000 × 8192
= 819,200,000
```

About **819 million parameters** just for embeddings.

A large model might have:

```text
70 billion parameters
```

or more.

So embeddings are actually only a small fraction of the total model.

---

### Step 6: What happens when you type one word?

Suppose you type:

```text
"embeddings"
```

Tokenizer:

```text
["embed", "dings"]
```

2 tokens.

Each token becomes:

```text
8192 numbers
```

So immediately:

```text
2 × 8192
= 16,384
```

floating-point values enter the network.

These then pass through dozens or hundreds of transformer layers, each performing huge matrix multiplications involving billions of parameters.

---

### A useful mental picture

Imagine every token is a point in an **8192-dimensional space**.

The model isn't thinking:

> "cat means a small animal."

Instead it's manipulating something more like:

```text
cat
=
(-0.17, 0.44, 1.21, ..., 0.08)
```

and after many layers the vector evolves into:

```text
(2.91, -1.33, 0.51, ..., 4.72)
```

which now represents:

> "the meaning of 'cat' in this specific sentence, after considering every other token in the context."

That's the key idea: **tokens start as embedding vectors, and the transformer continuously transforms those vectors into richer contextual representations until it can predict the next token.**