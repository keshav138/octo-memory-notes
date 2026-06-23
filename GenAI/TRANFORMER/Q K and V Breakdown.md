Let's go deeper than "they're three different learned projections" — the actual mechanics of _how_ the split happens, and _why_ it has to be three separate things rather than one, with the math made explicit.

## Why one embedding vector can't just play all three roles directly

Recall: after embedding + positional encoding, each token is a single vector — say "AI" is `[1.1, 1.1, 0.0, 0.0]`. If we just used this raw vector directly as Q, K, _and_ V (no projections at all), here's what breaks:

**Problem 1 — self-attention would always be dominated by self-similarity.** `Q · K` for the same token is `x · x = ||x||²` — the squared magnitude of the vector, which is the _maximum possible value_ a dot product of `x` with anything can reach (by Cauchy-Schwarz). So without any transformation, every token would always score highest when attending to _itself_, structurally, regardless of context or learned meaning. You'd never get useful patterns like "the pronoun 'it' should attend strongly to the noun it refers to" — self-attention would just trivially collapse toward "everyone mostly looks at themselves."

**Problem 2 — "relevance" and "content" are different questions, and one vector can't encode both independently.** Think about what attention is actually asking: _"does token A's query match token B's key?"_ and separately, _"if it matches, what content should flow from B?"_ These are different jobs:

- Query/Key answer: _should I attend here?_
- Value answers: _what do I get if I do?_

If you forced these onto the same vector, the model couldn't learn them independently — any change made to help "matching" would also distort "the content delivered," because it's the same numbers serving both jobs. Splitting into separate learned matrices lets gradient descent adjust each role's geometry independently, without one job's optimization corrupting the other's.

## How the split actually happens, mechanically

There are **three separate weight matrices**, each learned independently during training:

```
W_Q : shape (d_model, d_k)
W_K : shape (d_model, d_k)
W_V : shape (d_model, d_v)     (d_k and d_v are often equal, but don't have to be)
```

For a single token vector `x` (shape `(d_model,)`):

```
q = x · W_Q     →  shape (d_k,)
k = x · W_K     →  shape (d_k,)
v = x · W_V     →  shape (d_v,)
```

That's it — **it's just three separate matrix multiplications of the _same_ input vector through three _different_ weight matrices.** The "split" isn't slicing the embedding into three pieces (that's a common misconception) — the full embedding vector goes through each projection in full. You get three _different output vectors_ from one input vector, because each weight matrix linearly transforms it differently.

### Concrete numeric continuation of our earlier example

Recall "AI" `= [1.1, 1.1, 0.0, 0.0]`. Earlier I used identity matrices for simplicity (so Q=K=V=X). Let's now use **actual different** small matrices to show what really happens:

```
W_Q = [[1, 0, 0, 0],
       [0, 1, 0, 0],
       [1, 1, 0, 0],
       [0, 0, 1, 1]]

W_K = [[0, 1, 0, 0],
       [1, 0, 0, 0],
       [0, 0, 1, 0],
       [0, 0, 0, 1]]

W_V = [[1, 1, 1, 1],
       [0, 1, 0, 1],
       [1, 0, 1, 0],
       [0, 0, 1, 1]]
```

`q = x · W_Q` (x is a row vector `[1.1, 1.1, 0, 0]`, multiplying by each column of W_Q):

```
q[0] = 1.1×1 + 1.1×0 + 0×1 + 0×0 = 1.1
q[1] = 1.1×0 + 1.1×1 + 0×1 + 0×0 = 1.1
q[2] = 1.1×0 + 1.1×0 + 0×0 + 0×1 = 0.0
q[3] = 1.1×0 + 1.1×0 + 0×0 + 0×1 = 0.0

q = [1.1, 1.1, 0.0, 0.0]
```

`k = x · W_K`:

```
k[0] = 1.1×0 + 1.1×1 + 0 + 0 = 1.1
k[1] = 1.1×1 + 1.1×0 + 0 + 0 = 1.1
k[2] = 0 + 0 + 0×1 + 0 = 0.0
k[3] = 0 + 0 + 0 + 0×1 = 0.0

k = [1.1, 1.1, 0.0, 0.0]
```

(Same as q here because of how I picked these particular toy matrices — in a real trained model they'd diverge more. Let's make `v` clearly different to make the point:)

`v = x · W_V`:

```
v[0] = 1.1×1 + 1.1×0 + 0×1 + 0×0 = 1.1
v[1] = 1.1×1 + 1.1×1 + 0×0 + 0×0 = 2.2
v[2] = 1.1×1 + 1.1×0 + 0×1 + 0×1 = 1.1
v[3] = 1.1×1 + 1.1×1 + 0×0 + 0×1 = 2.2

v = [1.1, 2.2, 1.1, 2.2]
```

So from the **same input vector** `[1.1, 1.1, 0.0, 0.0]`, three genuinely different vectors emerge: `q=[1.1,1.1,0,0]`, `k=[1.1,1.1,0,0]`, `v=[1.1,2.2,1.1,2.2]`. Notice `v` is in a completely different scale/shape than `q`/`k` — because `W_V`'s job (encoding "content to deliver") is being optimized completely independently from `W_Q`/`W_K`'s job (encoding "matching geometry").

**This is the entire "split"** — not a slicing operation, but three independent linear maps applied to the full vector, producing three differently-shaped/scaled outputs that each play a distinct role downstream: `q` and `k` get dot-producted together to produce attention _weights_, and `v` gets weighted-summed using those weights to produce the actual _output content_.

## Why this is learnable rather than fixed

Crucially, `W_Q, W_K, W_V` are **not hand-designed** — they start as random numbers and get updated via backpropagation, exactly like every other weight in the network. Training pressure shapes them: if the model needs "AI" to strongly attend to a preceding adjective in many training examples, gradient descent nudges `W_Q` and `W_K` so that the dot product between an adjective's key and a noun's query comes out large in that kind of context. The _split itself_ (having three matrices) is architecture; _what each matrix actually does_ is entirely learned from data.

## One more subtlety worth flagging: per-head splitting is a different "split" than this

You'll often hear "split into heads" too, and it's easy to conflate the two splits. To be precise:

- **Q/K/V split**: same input vector, three _different weight matrices_, producing three _different_ vectors (different roles).
- **Multi-head split**: _after_ computing Q (say shape `d_model=512`), you literally **slice** that single Q vector into, say, 8 contiguous chunks of 64 dims each — `Q_head1 = Q[0:64]`, `Q_head2 = Q[64:128]`, etc. — and run independent attention per chunk. This second split _is_ a literal slicing operation, unlike the Q/K/V split.

So: Q/K/V separation = three different learned transformations of the same vector. Multi-head separation = literally chopping one of those resulting vectors into pieces for parallel, independent attention computations. Different mechanisms, easy to blur together under the word "split."