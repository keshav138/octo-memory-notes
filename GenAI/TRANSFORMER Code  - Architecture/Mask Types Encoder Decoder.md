
# Doubt

> why does encoder class recieve a mask and why does every layer get it, i'm assuming other functions had it since we had to use them in decoder but why encoder?


That's a very good observation. Most people think:

> "The encoder can see the whole sentence, so why would it need a mask at all?"

The answer is: **the encoder does not need a causal mask, but it often does need a padding mask.**

Let's distinguish the two.

---

# There are two completely different masks

## 1. Padding Mask (Encoder uses this)

Imagine two sentences in a batch.

```text
Sentence 1:
I love transformers

Sentence 2:
Hello
```

Neural networks need every sentence in a batch to have the same length, so we pad the shorter one.

```text
Sentence 1

I
love
transformers

Sentence 2

Hello
<PAD>
<PAD>
```

The tokenizer might produce

```text
Sentence 1

[45, 81, 932]

Sentence 2

[17, 0, 0]
```

where

```text
0 = PAD token
```

---

## What happens without a mask?

Suppose we're computing attention for "Hello".

Without masking, attention can look at

```text
Hello

PAD

PAD
```

The PAD tokens aren't real words, but they still have embeddings.

Attention might assign weights like

```text
Hello → 0.4

PAD → 0.3

PAD → 0.3
```

Now 60% of the information comes from meaningless padding.

That's bad.

---

## Padding mask fixes this

The mask says

```text
Real token

✔

Real token

✔

PAD

✘
```

During attention we do

```python
attention_scores.masked_fill(mask == 0, -1e9)
```

Before softmax:

```text
[2.1, 0.8, 1.3]
```

After masking:

```text
[2.1, -∞, -∞]
```

Softmax becomes

```text
[1,0,0]
```

The PAD tokens receive zero attention.

---

# So every encoder layer needs this mask

Why every layer?

Because **every encoder layer performs self-attention**.

Suppose you have six encoder blocks.

```text
Encoder Block 1
```

computes attention.

It must ignore PAD tokens.

Then

```text
Encoder Block 2
```

computes attention again.

It must ignore PAD tokens too.

Same for

```text
Block3

Block4

Block5

Block6
```

The padding hasn't disappeared.

So every attention layer needs the same mask.

---

# The second mask

This is the one you're probably thinking of.

## Causal (Look-ahead) Mask

This is **NOT** used in the encoder.

Suppose the decoder is generating

```text
I love ___
```

When predicting the third word,

it should **not** look at

```text
future words
```

because they don't exist yet.

So the decoder uses

```text
1 0 0

1 1 0

1 1 1
```

to prevent cheating.

The encoder never predicts left-to-right.

It already has the whole sentence.

So it doesn't need this mask.

---

# Then why is it called `src_mask`?

Because it masks the **source sentence**.

For translation

```text
English

↓

French
```

The source is

```text
English
```

Only the encoder sees this sentence.

So

```python
src_mask
```

means

```text
Mask for the source sentence.
```

Almost always,

this is just a padding mask.

---

# Why does the Encoder class receive the mask?

The encoder itself doesn't use it directly.

Look here:

```python
for layer in self.layers:
    x = layer(x, mask)
```

The encoder is simply passing the mask down to each `EncoderBlock`.

Think of the `Encoder` as a manager.

```text
Encoder

↓

Block1

↓

Block2

↓

Block3
```

The manager says

```text
"Everyone,

here's the same padding mask."
```

Each block then passes it further to its own attention layer.

The flow is:

```text
Encoder.forward(x, src_mask)
            │
            ▼
EncoderBlock.forward(x, src_mask)
            │
            ▼
ResidualConnection(...)
            │
            ▼
SelfAttention(x, x, x, src_mask)
            │
            ▼
attention(...)
```

The encoder never inspects the mask itself—it just ensures that every attention layer receives it.

---

# Why didn't the FeedForward block need the mask?

Because the FeedForward Network never compares tokens.

Remember what the FFN does.

For every token independently:

```text
Token1

↓

Linear

↓

ReLU

↓

Linear

↓

Output
```

Then

```text
Token2

↓

Linear

↓

ReLU

↓

Linear
```

It never computes

```text
Token1

↓

looks at

↓

Token2
```

Therefore there's nothing to mask.

Masks are only needed wherever **attention scores** are computed.

---

# Complete encoder flow

```text
Input Sentence
      │
Padding Mask Created
      │
      ▼
Encoder
      │
      ▼
Block 1
      │
      ├── Self-Attention (uses padding mask)
      └── FeedForward (no mask)
      │
      ▼
Block 2
      │
      ├── Self-Attention (uses same padding mask)
      └── FeedForward (no mask)
      │
      ▼
...
      │
      ▼
Final Encoder Output
```

So your intuition was almost right:

- **The encoder does not need a causal/look-ahead mask.**
    
- **It does need a padding mask** so that every self-attention layer ignores `<PAD>` tokens introduced for batching. That's why the `Encoder` receives `src_mask` and passes it unchanged to every encoder block.