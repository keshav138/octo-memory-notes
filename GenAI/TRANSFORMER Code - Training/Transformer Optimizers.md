Since you're deep in transformer implementation and prepping for ML interviews, here's the full picture — dense but complete.

## Why optimizers matter here

Plain gradient descent updates weights using only the current gradient. Transformers have huge, non-convex, ill-conditioned loss landscapes (different parameters need very different step sizes), so raw SGD converges too slowly or diverges. Optimizers add memory of past gradients to adapt step size/direction per-parameter.

## The core lineage
SGD -> Stochastic Gradient Descent

**1. SGD (vanilla)** `θ = θ - lr * ∇L` No memory, treats all parameters identically. Rarely used alone for transformers — too slow, sensitive to LR choice, gets stuck in ravines.

**2. SGD + Momentum** Adds a velocity term: `v = β*v + ∇L; θ = θ - lr*v` Smooths updates by accumulating gradient direction over time — dampens oscillation in ravines, speeds convergence. Still uses one global LR for all parameters.

**3. RMSProp** Divides the LR by a running average of squared gradients per parameter: `s = β*s + (1-β)*∇L²; θ = θ - lr*∇L/√(s+ε)` This gives each parameter its own effective LR — parameters with consistently large gradients get smaller steps, sparse/small-gradient parameters get relatively bigger ones. No momentum term though.

**4. Adam (Adaptive Moment Estimation)** Combines momentum (1st moment, mean of gradients) + RMSProp-style scaling (2nd moment, uncentered variance):

```
m = β1*m + (1-β1)*∇L        (momentum)
v = β2*v + (1-β2)*∇L²       (adaptive scaling)
m̂ = m/(1-β1^t), v̂ = v/(1-β2^t)   (bias correction, important early in training)
θ = θ - lr * m̂/(√v̂ + ε)
```

This is the default for transformers because it's robust to noisy/sparse gradients and doesn't need much LR tuning. Defaults: β1=0.9, β2=0.999, ε=1e-8.

**5. AdamW — what's actually used in every modern transformer** Adam has a subtle bug: if you add L2 regularization the naive way (adding `λθ` to the gradient before the Adam update), the weight decay gets scaled by the adaptive `1/√v̂` term too — which is wrong and inconsistent across parameters. AdamW **decouples** weight decay from the gradient update:

```
θ = θ - lr*(m̂/(√v̂+ε)) - lr*λ*θ
```

Weight decay is applied directly and uniformly, not run through the adaptive machinery. This is the single most important optimizer fact for transformer interviews — Adam vs AdamW is almost always asked.

**Other variants worth knowing (less commonly used but interview-relevant):**

- **AdaGrad**: accumulates squared gradients _forever_ (not a running average) → LR shrinks monotonically to zero, so it dies out on long training runs. RMSProp fixed this with a decay factor.
- **Nadam**: Adam + Nesterov momentum (look-ahead gradient instead of current).
- **LAMB / LARS**: layer-wise adaptive LR, used for large-batch training (BERT was originally trained with LAMB to scale to huge batch sizes without instability).
- **Adafactor**: used in T5 — approximates the second-moment matrix with much less memory (factored into row/column vectors instead of storing a full per-parameter `v`), critical when model size makes storing two extra copies of parameters (m and v) for Adam expensive.
- **Sophia / Lion**: newer, sign-based or second-order-ish optimizers claiming faster convergence than AdamW on LLM pretraining — good to namedrop as "recent research directions."

## What differs, in one line each

|Optimizer|Adapts LR per-param?|Has momentum?|Handles weight decay correctly?|
|---|---|---|---|
|SGD|No|No|N/A|
|SGD+Momentum|No|Yes|N/A|
|RMSProp|Yes|No|No|
|Adam|Yes|Yes|No (couples decay into adaptive term)|
|AdamW|Yes|Yes|Yes (decoupled)|

## The other half: LR schedules

Optimizer choice is only half of transformer training stability — the LR _schedule_ matters just as much:

- **Warmup**: LR increases linearly from ~0 for the first N steps. Needed because Adam's variance estimates (`v̂`) are unreliable early on with few samples — without warmup, early updates can be huge and destabilize training.
- **Cosine decay / linear decay** after warmup, down to near-zero by end of training.
- This warmup+decay + AdamW combo is essentially the standard recipe across GPT, BERT, LLaMA, etc.

## Interview questions to have ready

1. **Why AdamW over Adam for transformers?** (the decoupled weight decay explanation above — this is the #1 question)
2. **Walk through the Adam update rule from memory**, including why bias correction (`1-β1^t`) is needed.
3. **Why is warmup necessary with Adam?** (variance estimate instability early in training)
4. **What happens if you use SGD to train a transformer from scratch?** (much harder to tune, slower/unstable convergence — Adam's adaptivity compensates for the wildly different gradient scales across attention/FFN/embedding layers)
5. **Memory cost of Adam vs SGD** — Adam stores 2 extra tensors (m, v) per parameter, doubling optimizer memory footprint; this is exactly why Adafactor/8-bit Adam exist for large-model training.
6. **AdaGrad's flaw and how RMSProp/Adam fix it.**
7. **What's the effect of β1/β2 values?** Higher β2 (0.999) → smoother, slower-adapting variance estimate → more stable but slower to react to gradient scale changes.
8. **Gradient clipping** — often paired with AdamW in transformer training (clip global norm to ~1.0) to prevent exploding gradients; be ready to explain why this is separate from but complementary to the optimizer.
9. **Layer-wise LR / LLRD** (used in fine-tuning) — different LR per layer, lower for earlier/pretrained layers.
10. Given your Nepali LM pretraining work — be ready to discuss the **practical Colab-constraint angle**: why Adafactor or 8-bit Adam (bitsandbytes) might matter for you specifically when memory-limited, since that's a very natural follow-up if you mention your own project in an interview.

If you want, I can quiz you on these or dig into the AdamW decoupling math in more detail given your from-scratch PyTorch work.