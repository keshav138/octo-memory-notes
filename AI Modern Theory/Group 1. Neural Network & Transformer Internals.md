### 1. Neural Networks & Activation Functions

**Core recap:**

- A neural network is layers of linear transformations (`Wx + b`) interleaved with non-linear activation functions. Without non-linearity, stacking layers collapses into one linear function — activations are what let NNs approximate non-linear boundaries.

**Activation functions to know cold:**

|Function|Range|Key property|Problem it solves/causes|
|---|---|---|---|
|Sigmoid|(0,1)|Smooth, probabilistic|Vanishing gradients at extremes|
|Tanh|(-1,1)|Zero-centered|Still vanishes at extremes|
|ReLU|[0,∞)|max(0,x), cheap|Dying ReLU (dead neurons when x<0 always)|
|Leaky ReLU|(-∞,∞)|small slope for x<0|Fixes dying ReLU|
|GELU|~smooth ReLU|Used in transformers (BERT, GPT)|Smoother gradient than ReLU|
|Softmax|sums to 1|Output layer for multi-class|Used in attention & classification|

**Likely mock-test angle:** "Why GELU over ReLU in transformers?" — GELU weights inputs by their magnitude probabilistically (via the Gaussian CDF) rather than hard-gating at 0, giving smoother gradients — empirically better for deep transformer stacks.

---

### 2. FFN in Transformers

- Every transformer block has: **Multi-Head Attention → Add & Norm → FFN → Add & Norm**.
- The FFN (Feed-Forward Network) is applied **position-wise** — same two-layer MLP applied independently to each token's vector: `FFN(x) = W2 · activation(W1·x + b1) + b2`.
- Typically expands dimension (e.g., 768 → 3072 → 768) — this expansion-then-contraction is where a lot of the model's "knowledge storage" is believed to live (per interpretability research, FFNs act like key-value memories).
- **Why needed if attention already mixes info across tokens?** Attention mixes information _across_ tokens (contextualizing), FFN transforms _each token's_ representation independently — it's where per-token non-linear feature transformation happens. Attention alone is a weighted sum (linear in values), so without FFN's non-linearity, expressive power is limited.

**Likely mock-test angle:** "What happens if you remove the FFN layer?" → Model loses the non-linear, per-token transformation capacity; attention still mixes context but can't do the more complex feature recombination — performance degrades significantly, especially on tasks needing compositional reasoning.

---

### 3. Attention Entropy: Layer 1 vs Layer 11

- **Entropy of attention** = how spread out the attention weights are across tokens for a given query. High entropy = attention is diffuse (spread across many tokens). Low entropy = attention is sharp/focused (peaky on few tokens).
- **Empirical pattern found in research** (e.g., on BERT/GPT-style models):
- **Early layers (layer 1)**: tend to have **higher entropy** — attention is more diffuse, often attending broadly or to local/positional patterns (syntax, adjacent tokens). Some early layers also show "attention sink" behavior (heavy attention to the first token).
- **Later layers (layer 11)**: tend to have **lower entropy** — attention becomes sharper/more selective, focusing on semantically relevant tokens needed for the final prediction (task-specific, content-based attention).
- **Intuition**: early layers build general/broad contextual representations (syntax, local structure), later layers refine toward task-specific, high-level semantic focus.

**Likely mock-test framing:** "Why does entropy differ between layer 1 and layer 11, and what does it tell you about what each layer is doing?" — answer along the above lines: progression from broad/syntactic to narrow/semantic attention.

---

### 4. CNN: 95% Train / 72% Test → 84% Test After Dropout

This is a classic **overfitting → regularization** question.

- **Diagnosis**: 95% train vs 72% test = large generalization gap = **overfitting**. The model has memorized training data patterns (including noise) rather than learning generalizable features.
- **Why dropout helps**: Dropout randomly zeroes a fraction of neurons during each training forward pass. This:

1. Prevents co-adaptation — neurons can't rely on specific other neurons always being present, forcing more robust, distributed feature representations.
2. Acts like implicit ensemble training — each forward pass trains a slightly different sub-network, and at test time you're effectively averaging over these.
3. Reduces effective model capacity during training, discouraging memorization.

- **Why test accuracy improves (72%→84%) specifically**: the model is now forced to learn features that are useful even when parts of the network are missing — these tend to be more generalizable, transferable features rather than dataset-specific noise fits.
- **Note**: Train accuracy would likely **drop** with dropout added (since regularization intentionally hurts training fit) — if asked, that's expected and healthy, not a bug.

**Likely mock-test angle:** "Why does test accuracy go up but not train accuracy?" and "What does the remaining gap (84% test vs presumably lower train now) tell you?" — still might need more regularization (weight decay, more data, augmentation) or the dropout rate might need tuning further.

---

That's Group 1. Ready to move to **Group 2: Embeddings & Retrieval Mechanics** whenever you are — or let me know if you want deeper math (e.g., derivation of attention entropy formula, dropout backprop mechanics) on anything above first.