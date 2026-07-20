```

This is the rule of language, we havent learnt any french though, also we're seeing word by word, does the decoder in training see this <BOS>

Le

chat

boit

du, or just BOS. And what is the difference between training and inference for a transformer
```

Excellent. This is **the** question that separates understanding the architecture from understanding how the model actually learns.

Your intuition is pointing out something important:

> **"How does the model know that 'The' corresponds to 'Le'? We never taught it French."**

Exactly.

**It doesn't know initially.**

Everything starts from random weights.

Let's walk through training from the very beginning.

---

# Day 1 of training

Suppose our dataset has one translation pair.

```text
English:
The cat drinks milk

French:
Le chat boit du lait
```

The model has never seen French.

All weights are random.

So initially

```text
Wq
Wk
Wv
Wo
Embeddings
FFN
Final Linear Layer
```

are random numbers.

The model literally knows nothing.

---

# First forward pass

Encoder receives

```text
The
cat
drinks
milk
```

The decoder receives

```text
<BOS>
Le
chat
boit
du
```

Notice this.

## During TRAINING

The decoder **does not receive only `<BOS>`**.

It receives

```text
<BOS>
Le
chat
boit
du
```

This is called **teacher forcing**.

We'll come back to why.

---

# Wait...

You might say

> "If the decoder already sees the answer, what's the point?"

The decoder **cannot see future words** because of the causal mask.

Let's draw it.

Decoder input

```text
Position 1 : <BOS>
Position 2 : Le
Position 3 : chat
Position 4 : boit
Position 5 : du
```

The causal mask looks like

```text
       BOS  Le  chat boit du

BOS     ✓

Le      ✓   ✓

chat    ✓   ✓    ✓

boit    ✓   ✓    ✓    ✓

du      ✓   ✓    ✓    ✓   ✓
```

Notice

When predicting

```text
chat
```

the model **cannot see**

```text
boit
du
lait
```

Those positions are masked.

So every position predicts the next token independently.

---

# What is it predicting?

Decoder Input

```text
<BOS>

Le

chat

boit

du
```

Target

```text
Le

chat

boit

du

lait
```

So each position predicts one word.

|Input visible at this position|Target|
|---|---|
|`<BOS>`|Le|
|`<BOS> Le`|chat|
|`<BOS> Le chat`|boit|
|`<BOS> Le chat boit`|du|
|`<BOS> Le chat boit du`|lait|

This all happens in **one forward pass**.

This is one of the biggest advantages of transformers over RNNs.

---

# But how does it learn French?

Initially the predictions are nonsense.

Suppose after the first forward pass

the decoder predicts

```text
Dog

House

Apple

Blue

Chair
```

Obviously wrong.

The targets were

```text
Le

chat

boit

du

lait
```

Loss becomes huge.

Backpropagation now says

> "Whatever weights produced those predictions,  
> move them slightly toward producing the correct words."

Nothing magical happens.

Just gradient descent.

---

After millions of sentence pairs

the model starts discovering patterns.

For example it may notice

```text
The

↓

Le
```

appears extremely often.

No one explicitly tells it this.

The optimizer gradually adjusts the embeddings and attention weights until predicting **Le** after English **The** reduces the loss.

The same happens for

```text
cat

↓

chat
```

Eventually

```text
drinks

↓

boit
```

and so on.

Language emerges because predicting correctly minimizes the loss.

---

# Now your second question

> During training does the decoder only receive `<BOS>`?

No.

This is the biggest difference between training and inference.

---

# TRAINING

Entire decoder input already exists.

```text
<BOS>

Le

chat

boit

du
```

The decoder processes **all positions simultaneously**.

Remember attention.

Every position can be computed in parallel because the causal mask prevents cheating.

So training looks like

```text
Encoder

↓

Decoder

↓

Predict every next word simultaneously

↓

Loss

↓

Backprop
```

One forward pass predicts

```text
Le

chat

boit

du

lait
```

all together.

---

# INFERENCE

Now imagine someone gives the model

```text
The cat drinks milk
```

There is no French sentence anymore.

The model has to generate it.

Initially decoder input is only

```text
<BOS>
```

That's all.

---

Pass 1

Input

```text
<BOS>
```

Predict

```text
Le
```

Append it.

Now decoder input becomes

```text
<BOS>

Le
```

---

Pass 2

Predict

```text
chat
```

Append it.

Decoder input

```text
<BOS>

Le

chat
```

---

Pass 3

Predict

```text
boit
```

Append.

---

Pass 4

Predict

```text
du
```

Append.

---

Pass 5

Predict

```text
lait
```

Append.

---

Eventually

Predict

```text
<EOS>
```

Stop.

---

# Why not do inference like training?

Because during inference

the future French words don't exist yet.

Training has

```text
Le

chat

boit

du
```

because they're in the dataset.

Inference doesn't.

The model must create them itself.

---

# Visual comparison

Training

```text
English

↓

Encoder

↓

Decoder Input

<BOS> Le chat boit du

↓

Predict

Le chat boit du lait

↓

Loss
```

Everything happens in one pass.

---

Inference

```text
English

↓

Encoder

↓

<BOS>

↓

Predict Le

↓

<BOS> Le

↓

Predict chat

↓

<BOS> Le chat

↓

Predict boit

↓

...
```

One prediction at a time.

---

# One subtle but very important point

You asked:

> "We're seeing word by word."

During **training**, the decoder is **not** generating the sentence word by word. It is computing hidden states for all positions in parallel:

```text
<BOS>      → predicts Le
<BOS> Le   → predicts chat
<BOS> Le chat → predicts boit
<BOS> Le chat boit → predicts du
<BOS> Le chat boit du → predicts lait
```

These contexts are all represented simultaneously using the causal mask.

During **inference**, however, the model doesn't have the future tokens, so it truly generates one token, appends it, runs the decoder again, and repeats.

This difference—**parallel teacher-forced training versus autoregressive inference**—is one of the defining characteristics of transformer sequence generation models.

[[Transformer Encoder Decoder Doubt 3]]