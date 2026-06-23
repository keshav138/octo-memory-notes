# Transformer Architecture — Full Breakdown

## 1. The Problem It Solves

Before transformers, sequence models (RNNs, LSTMs) processed tokens one at a time, in order. That created two problems:

- **No parallelism**: token 5 needs token 4's output, which needs token 3's, etc. Training is slow.
- **Long-range dependency decay**: information from token 1 has to survive being squeezed through a fixed-size hidden state across 999 steps to influence token 1000. It degrades.

The transformer's core idea: **let every token look directly at every other token, in parallel, weighted by relevance.** That mechanism is _self-attention_. Everything else in the architecture exists to support, stabilize, or compensate for this one idea.

---

## 2. Step-by-Step Flow

### Step A: Tokenization → Embeddings

**Input**: raw text string. **Output**: sequence of integers (token IDs), then a sequence of vectors.

Text is split into subword tokens (via BPE or similar — chosen over word-level because it handles rare/unseen words via subword composition, and over character-level because it keeps sequences shorter). Each token ID indexes into an embedding table: a learned matrix of shape `(vocab_size, d_model)`. Lookup gives you a vector per token.

**Why learned embeddings and not something like one-hot vectors?** One-hot vectors are sparse, huge (vocab_size-dimensional), and carry no notion of similarity — "cat" and "dog" are as different as "cat" and "refrigerator." A dense embedding space lets the model learn that similar words land near each other geometrically.

### Step B: Positional Encoding

**Input**: the embedding sequence. **Output**: same shape, but now position-aware.

Self-attention has no inherent sense of order — it's a set operation, computing pairwise relevance regardless of position. So position has to be injected explicitly. The original paper used fixed sinusoidal functions (sin/cos at different frequencies) added directly to embeddings; modern models (GPT, LLaMA) mostly use **RoPE (Rotary Position Embeddings)**, which rotates query/key vectors by an angle proportional to position instead of adding a separate vector.

**Why RoPE over sinusoidal addition?** RoPE encodes _relative_ position naturally inside the attention dot product itself, which generalizes better to sequence lengths longer than what was seen in training. Additive sinusoidal encoding bakes in absolute position, which is weaker for extrapolation.

### Step C: Self-Attention (the core mechanism)

**Input**: a matrix `X` of shape `(seq_len, d_model)` — one vector per token. **Output**: same shape, but each vector is now a context-aware blend of other tokens.

Each token's vector is projected through three separate learned weight matrices into:

- **Query (Q)**: "what am I looking for?"
- **Key (K)**: "what do I contain, that others might want?"
- **Value (V)**: "what do I actually offer if picked?"

```
Attention(Q,K,V) = softmax(QKᵀ / √d_k) · V
```

**Why three separate projections instead of using the raw token vectors directly?** If you used the same vector as both query and key, every token would maximally attend to itself (dot product of a vector with itself is its squared norm, generally the max). Q/K/V are _learned, separate_ linear transformations so the model can decide "relevance" along a different axis than "content," and "what to retrieve" along yet another axis. This separation is what lets attention be flexible and learnable rather than a fixed similarity metric.

**Why divide by √d_k?** As dimensionality `d_k` grows, dot products grow in magnitude, pushing softmax into extremely peaked (near one-hot) or saturated regions, where gradients vanish. Scaling keeps the softmax in a well-behaved range. This is a stability fix, not a representational choice.

**Why softmax and not, say, a hard top-1 selection?** Softmax gives a differentiable, soft weighting — every token contributes something, gradients flow through all of it during training. Hard selection (like argmax) isn't differentiable and can't be trained with backprop directly.

### Step D: Multi-Head Attention

**Input/Output shape**: identical to single-head attention.

Instead of one Q/K/V projection of size `d_model`, you split into `h` heads, each projecting into `d_model/h` dimensions, run attention independently per head, then concatenate and project back through one more linear layer.

**Why multiple heads instead of one big attention operation?** A single attention operation computes one notion of "relevance" per token pair. But relevance is multi-faceted — one head might learn to track syntactic dependency (subject-verb), another might track coreference (pronoun-to-noun), another might track local adjacency. Multiple heads let the model learn several relevance patterns in parallel, then combine them. It's essentially an ensemble baked into one layer.

### Step E: Residual Connection + Layer Normalization

**Input/Output**: same shape throughout.

After attention: `X = LayerNorm(X + Attention(X))`

**Why the residual (skip) connection?** As you stack many layers (modern LLMs have 30–100+), gradients have to backpropagate through all of them. Without a residual path, gradients can vanish or explode across depth. The residual gives gradients a direct shortcut back to earlier layers — this is the same motivation as ResNets in vision.

**Why LayerNorm specifically, and not BatchNorm?** BatchNorm normalizes across the batch dimension, which is problematic for variable-length sequences and breaks down with small batch sizes or at inference with batch size 1. LayerNorm normalizes across the feature dimension per token independently, so it works identically regardless of batch size or sequence length. Modern models often use **RMSNorm** instead, which drops the mean-centering step LayerNorm does and only rescales by root-mean-square — cheaper to compute, and shown empirically to work just as well for LLMs.

**Pre-norm vs post-norm**: Original paper applied norm _after_ the residual add (post-norm). Most modern LLMs apply norm _before_ the sublayer (pre-norm: `X + Attention(LayerNorm(X))`), because it stabilizes training at greater depth — post-norm transformers become hard to train past a certain layer count without very careful learning rate warmup.

### Step F: Feed-Forward Network (FFN / MLP)

**Input**: `(seq_len, d_model)`, processed independently per token (no cross-token mixing here — that already happened in attention). **Output**: same shape.

```
FFN(x) = W2 · activation(W1·x + b1) + b2
```

Typically expands `d_model` to `4×d_model` in the hidden layer, then projects back down.

**Why is this here at all, if attention already mixed information across tokens?** Attention is fundamentally a _weighted averaging_ operation — linear combination of value vectors. It cannot, by itself, do nonlinear feature transformation. The FFN is where the actual nonlinear "thinking" / feature recombination happens per token, after attention has gathered the relevant context. Attention decides _what to look at_; the FFN decides _what to do with it_.

**Why expand to 4× then compress back?** Gives the network more capacity/parameters to represent complex functions in a bottleneck-expand-compress pattern — similar reasoning to why autoencoders or inception-style nets use dimension changes for representational capacity.

**Why GELU/SwiGLU instead of ReLU?** ReLU has a hard zero cutoff with discontinuous gradient at 0, and the original paper used it, but it can cause "dead neurons." GELU is smooth and probabilistic (gates based on a Gaussian CDF), giving better gradient flow. SwiGLU (used in LLaMA, PaLM) adds a learned gating mechanism — another linear projection multiplied elementwise — which empirically improves performance further at modest extra compute cost.

Another residual + norm wraps this block too: `X = LayerNorm(X + FFN(X))`.

### Step F.5: One Encoder/Decoder Block

Steps C–F together (Attention → residual/norm → FFN → residual/norm) constitute **one transformer block/layer**. This block is stacked N times (N = 12 for GPT-2 small, 96 for GPT-3, etc.) — each block takes the previous block's output as its input, same shape in, same shape out, refining the representation progressively. Early layers tend to capture more syntactic/local patterns; later layers capture more abstract/semantic patterns (empirically observed, not architecturally enforced).

---

## 3. Encoder vs Decoder vs Encoder-Decoder — Why Three Variants Exist

The original "Attention is All You Need" paper proposed an **encoder-decoder** architecture for translation. Today, three families exist, and the choice depends on the task:

### Encoder-only (BERT-style)

- Self-attention is **bidirectional** — every token attends to every other token, including future ones.
- **Why**: good for tasks where you have the full input and need to _understand_ it (classification, embeddings, search retrieval). There's no "future" to leak — you're not generating anything sequentially.
- Used to produce a representation, not generate text.

### Decoder-only (GPT-style — what powers ChatGPT, Claude, LLaMA, etc.)

- Self-attention is **causally masked** — token `i` can only attend to tokens `1...i`, not future tokens. This is done by setting future positions in the `QKᵀ` matrix to `-∞` before softmax, so they get zero weight.
- **Why mask the future?** Because the task is autoregressive generation: predict the next token given only what's been generated so far. If a token could "see" the future during training, it would trivially cheat (just copy the next token), and at inference time there _is_ no future yet — it's being generated one step at a time. Masking enforces consistency between train and inference conditions.
- This is the dominant architecture for modern LLMs because most useful tasks (chat, completion, code generation, reasoning) can be framed as "predict the next token" — it's a generic, scalable training objective requiring no labeled data, just raw text.

### Encoder-Decoder (T5, original Transformer, translation models)

- Encoder processes the full input bidirectionally → produces representations.
- Decoder generates output autoregressively (causally masked), but additionally has **cross-attention**: each decoder token's query attends to the encoder's output as keys/values (not to other decoder tokens for this particular sub-layer).
- **Why this split?** Natural for tasks with a clear "source" and "target" sequence of different lengths/languages (translation, summarization) — you want full bidirectional understanding of the source, while generating the target token-by-token, conditioned on that full source context.
- **Cross-attention input/output**: Query comes from the decoder's current state; Key/Value come from the encoder's final output. Output is the decoder representation now infused with source-sequence information.

**Why has the field largely moved to decoder-only for general-purpose LLMs?** Empirically, decoder-only models scale well, and a single autoregressive objective unifies tasks that used to need separate architectures — translation, summarization, QA, chat all become "predict next token given a prompt." You lose the clean bidirectional encoding BERT has, but you gain massive architectural simplicity and one universal training recipe, which has mattered more at scale.

---

## 4. Final Output Layer

**Input**: final block's output, shape `(seq_len, d_model)`. **Output**: probability distribution over vocabulary for the next token, shape `(vocab_size,)`, per position.

A final linear layer (often weight-tied with the input embedding matrix, to save parameters) projects `d_model → vocab_size`, then softmax converts logits into a probability distribution. The next token is sampled from this distribution (greedy, top-k, top-p/nucleus, or temperature-scaled sampling — a decoding-strategy choice, separate from the architecture itself).

---

## 5. How Multiple Transformers Are "Threaded Together" Into a Final Product

This is the part that often gets skipped in architecture explanations, so here's how it actually composes into something like ChatGPT/Claude:

**a) Stacking blocks (depth)** — already covered: N decoder blocks stacked sequentially is "one transformer model." This alone gives you a raw next-token predictor.

**b) Pretraining → base model**: Train this stack on massive raw text with the next-token-prediction objective. Output: a "base model" that completes text plausibly but isn't necessarily helpful, safe, or conversational — it just continues patterns.

**c) Instruction tuning / SFT (Supervised Fine-Tuning)**: Take the _same_ architecture and weights, continue training on curated (prompt, ideal-response) pairs. This doesn't add new transformer blocks — it's the same network, weights updated further so its next-token predictions are steered toward helpful-assistant-style outputs.

**d) RLHF / RLAIF (preference-based fine-tuning)**: A second model (a "reward model," itself often a smaller transformer with a classification head instead of a vocab-prediction head) is trained to score outputs by human/AI preference. The base assistant model's weights are then further updated (via RL, e.g., PPO, or simpler methods like DPO) to produce outputs the reward model scores highly. **Why is a separate transformer needed here?** Because "is this response good" isn't a next-token-prediction task — it's a scalar judgment task, so it needs a differently-headed model trained on comparison data, even though its backbone is architecturally similar.

**e) Retrieval-Augmented Generation (RAG)** — relevant to your Financial RAG project: here, _two_ separate models are threaded together at inference time, not training time:

- An **embedding model** (often a smaller, encoder-only transformer, e.g., BERT-derived) converts documents and the user query into vectors, stored in/queried from a vector DB (your ChromaDB).
- The **generative decoder-only model** (Llama3 via Groq, in your case) then receives the retrieved text concatenated into its prompt context and generates an answer conditioned on it.
- **Why two different transformers instead of one?** The embedding model is optimized for _semantic similarity_ (its output is a vector, not text) — small, fast, cheap to run on every document at index time. The generative model is optimized for _fluent, instruction-following text generation_ — larger, more expensive, only run once per query. Using one model for both jobs would be inefficient; each is specialized for its objective function.

**f) Multi-stage/agentic pipelines**: In more complex products, you may chain transformer calls — e.g., one call to decide "do I need to search the web," another (the same or different model) to generate the final answer given search results, another to verify/critique its own output. This is orchestration _around_ one or more transformer models via code, not a new architecture — each call is still a standard forward pass through a decoder-only stack as described above.

---

## Summary Table

|Component|Input shape|Output shape|Core "why"|
|---|---|---|---|
|Embedding|token IDs|(seq, d_model)|dense, learnable similarity space|
|Positional encoding|(seq, d_model)|(seq, d_model)|attention is order-agnostic by default|
|Self-attention|(seq, d_model)|(seq, d_model)|dynamic, learned, parallel context mixing|
|Multi-head|same|same|multiple relevance patterns simultaneously|
|Residual+Norm|same|same|stable gradients across deep stacks|
|FFN|same|same|nonlinear per-token transformation|
|Causal mask (decoder)|attention scores|masked scores|enforce train/inference consistency for generation|
|Cross-attention (enc-dec only)|decoder Q, encoder K/V|decoder repr. infused with source|conditions generation on separate source sequence|
|Output projection|(seq, d_model)|(seq, vocab)|convert representation to token probabilities|

Want me to go deeper on any one piece — e.g., actually walk through the matrix math of attention with real numbers, or get into how KV-caching makes inference fast (relevant since you're doing backend/infra work), or how this connects to what's actually happening inside your RAG pipeline?