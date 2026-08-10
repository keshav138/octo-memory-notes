## Loss functions in transformers

### Core one: Cross-Entropy Loss

This is what you used, and it's the default for basically every autoregressive/seq2seq transformer (GPT, your encoder-decoder, translation, NL-to-SQL — all of it).

**What it does:** at each output position, the model produces a probability distribution over the vocabulary (via softmax over logits). Cross-entropy compares that distribution to the true next-token (a one-hot distribution) and penalizes based on how much probability mass the model put on the wrong tokens.

`CE = -Σ y_true * log(y_pred)`

Since `y_true` is one-hot (only the correct token = 1), this collapses to: `CE = -log(p(correct_token))`

So it's just: take the predicted probability for the correct token, take negative log. If the model assigns high probability to the correct token → low loss. If it assigns low probability → loss blows up (as p→0, -log(p)→∞).

**In PyTorch specifically:** `nn.CrossEntropyLoss` combines `log_softmax` + `NLLLoss` internally — you pass raw logits, not softmax outputs. A very common interview/practical gotcha: passing already-softmaxed probabilities into it double-applies softmax and silently wrecks training.

**Key details relevant to your encoder-decoder work:**

- **Reshaping**: logits are `(batch, seq_len, vocab_size)`, targets are `(batch, seq_len)`. You flatten to `(batch*seq_len, vocab_size)` and `(batch*seq_len)` before passing to the loss.
- **`ignore_index`**: critical for padded sequences — you set `ignore_index=pad_token_id` so the loss doesn't penalize the model for predictions at padding positions. Forgetting this is a classic bug that silently degrades training on variable-length batches.
- **`label_smoothing`**: instead of a hard one-hot target (100% correct token, 0% everything else), smooth it slightly (e.g., 90% correct, 10% spread over other tokens). Prevents the model from becoming overconfident, improves calibration and generalization. Used in the original Transformer paper (ε=0.1) and still common today.
- Relation to **perplexity**: `perplexity = exp(cross_entropy_loss)` — this is the standard evaluation metric for LMs, so interviewers often ask you to connect the two.

### Other losses relevant to transformer-adjacent work

**KL Divergence** — measures how one probability distribution diverges from another: `KL(P||Q) = Σ P(x) log(P(x)/Q(x))`. Used in:

- Knowledge distillation (student matches teacher's soft output distribution)
- VAEs
- RLHF/DPO-style training (KL penalty keeping the fine-tuned policy close to a reference model — relevant since you know RLHF/DPO terminology)
- Note: cross-entropy = entropy of true distribution + KL divergence. When the true distribution is one-hot (fixed, zero entropy), minimizing CE is equivalent to minimizing KL — worth knowing this identity for interviews.

**Contrastive losses (InfoNCE / Contrastive Loss)** — relevant to your CLIP-based visual search project. Instead of predicting a class, you pull matching pairs (image-text) closer in embedding space and push non-matching pairs apart. CLIP uses a symmetric cross-entropy over cosine-similarity logits between image and text batches — technically still cross-entropy, but applied over a similarity matrix instead of a vocab.

**MSE / L2 Loss** — used for regression heads, not standard LM training. Comes up if a transformer has an auxiliary regression output (e.g., predicting a continuous score) or in older seq2seq work with continuous targets.

**Triplet Loss** — anchor/positive/negative, margin-based. Alternative to contrastive loss in retrieval/embedding tasks; more common in older metric-learning work, less so in modern LLM training, but interviewers might ask you to contrast it with InfoNCE.

**Focal Loss** — downweights easy/well-classified examples, focuses gradient on hard ones. Not standard in transformers, but relevant if you ever handle class imbalance (e.g., your Nepali fact-checking dataset with imbalanced label classes could plausibly use this).

**RL-style losses (PPO loss, DPO loss)** — since you know RLHF/DPO terms:

- PPO uses a clipped surrogate objective on the policy ratio, plus a KL penalty to the reference policy.
- DPO reframes RLHF as a classification loss directly on preference pairs (a cross-entropy-like loss on chosen-vs-rejected log-probability ratios), no reward model or RL loop needed. Good to know the intuition since it's a common current-interview LLM topic.

## Cross-entropy vs the others — quick differentiation table

|Loss|Use case|What it optimizes|
|---|---|---|
|Cross-Entropy|Classification / next-token prediction|Probability mass on correct class|
|KL Divergence|Distribution matching (distillation, RLHF constraint)|Closeness between two full distributions|
|MSE|Regression|Squared distance to a continuous target|
|Contrastive/InfoNCE|Embedding/retrieval alignment|Similarity structure across a batch|
|Triplet|Embedding/retrieval alignment|Margin between positive/negative pairs|
|Focal|Imbalanced classification|Reweighted CE emphasizing hard examples|

## Interview questions to keep on your tongue

1. **Derive cross-entropy loss from scratch and connect it to perplexity.** Extremely common — be ready to write `exp(loss)` and explain why lower CE → lower perplexity → better LM.
2. **Why do you pass raw logits (not softmax) into `nn.CrossEntropyLoss`?** Numerical stability — `log_softmax` internally is more stable than separately computing softmax then log (avoids underflow from very small probabilities).
3. **What does `ignore_index` do and why does it matter for padded batches?** — directly relevant to your encoder-decoder implementation, likely to come up given your project.
4. **What is label smoothing and why does it help?** Prevents overconfidence, improves calibration, sometimes improves generalization — but can hurt in cases needing sharp confident predictions (e.g., translation of rare/technical terms).
5. **Relationship between cross-entropy and KL divergence** — the identity `CE = H(true) + KL(true||pred)`, and why minimizing CE against a fixed one-hot target ≡ minimizing KL.
6. **Why is cross-entropy preferred over MSE for classification?** MSE + softmax gives vanishing gradients when predictions are very wrong (saturated sigmoid/softmax regions); CE's gradient is well-behaved (linear in the error) and pairs naturally with softmax's gradient — the combined gradient simplifies to `(predicted - actual)`, which is clean and doesn't vanish.
7. **How would you handle class imbalance in a loss function?** — good moment to mention focal loss or class-weighted CE, tie back to your Nepali fact-checking labels if it comes up.
8. **Explain contrastive loss / InfoNCE conceptually** — good if they probe your CLIP project.
9. **Explain the DPO loss intuition and how it differs from PPO's objective** — since you list both in your terminology and interviewers testing "how deep is your LLM knowledge" will often go here.
10. **What's teacher forcing and how does it interact with the loss during training vs. inference?** — you already know this from your encoder-decoder work, but be ready to explain the train/inference mismatch (exposure bias) it causes.

Want me to combine this with the optimizer note into a single condensed interview cheat-sheet, or drill into the CE gradient derivation (the `predicted - actual` simplification) since you're doing this from scratch in PyTorch?