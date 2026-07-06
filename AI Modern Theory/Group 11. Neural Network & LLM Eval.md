## D. Neural Network Adjacent

### 1. Vanishing/Exploding Gradients
[[Vanishing Gradient Issue]]
[[Vanishing Gradient Solution]]

- **Symptom**: deep network's early layers barely update (loss plateaus early, weights near-unchanged) = vanishing. Loss becomes NaN/explodes suddenly = exploding.
- **Cause**: repeated multiplication of gradients through many layers — if weights/derivatives are consistently <1, gradient shrinks exponentially with depth (vanishing); if consistently >1, it grows exponentially (exploding). Sigmoid/tanh activations worsen vanishing since their derivative max is 0.25/1.0 and saturates near 0 at extremes.
- **Fixes**:
- Vanishing → ReLU/GELU (non-saturating), residual/skip connections (gradient has a direct path back, bypassing multiplicative decay), better init (He/Xavier), batch norm (keeps activations in a stable range).
- Exploding → gradient clipping, lower learning rate, weight regularization, batch norm.

**Likely question framing**: "50-layer network, loss stuck near initial value, first 10 layers' weights unchanged after training — diagnose and fix" → vanishing gradients, prescribe residual connections + non-saturating activation.



---

### 2. Learning Rate Too High/Low — Loss Curve Diagnosis

- **Too high**: loss oscillates wildly, diverges, or NaNs — steps overshoot the minimum each update.
- **Too low**: loss decreases but extremely slowly, or plateaus early looking like convergence when it's actually just crawling.
- **Fix pattern**: learning rate schedules (warmup + decay), LR range test to find a good starting value, adaptive optimizers (Adam) that adjust per-parameter, reduce-on-plateau scheduling.

**Likely question framing**: given two loss curves (one erratic/spiky, one flat-but-not-converged), identify which is high-LR vs low-LR and prescribe the fix.

---

### 3. Overfitting Fixes Beyond Dropout — Scenario Matching

|Symptom|Best fix|
|---|---|
|Small dataset, model memorizing|Data augmentation, transfer learning|
|Large train-test gap, plenty of data available|More data, or reduce model capacity|
|Train loss still decreasing but val loss rising|Early stopping|
|Weights growing very large|Weight decay (L2 regularization)|
|Works with dropout but still overfits|Combine with data augmentation + early stopping (stacked regularization is normal)|

**Likely question framing**: given a scenario description (e.g., "small image dataset, val loss starts rising after epoch 15 while train loss keeps falling"), pick the single most appropriate fix and justify why that one over the others — mock tests in this style tend to want you to reject the less-fitting options explicitly (e.g., "more data isn't feasible/available here, so...").

---

## E. LLM Eval — Metric Disagreement (Non-RAG)

### 1. BLEU/ROUGE vs Embedding-Based Metrics Disagreeing

- **BLEU/ROUGE**: n-gram/lexical overlap with a reference — penalize valid paraphrases, reward exact wording match regardless of actual quality.
- **Embedding-based (BERTScore, cosine similarity of embeddings)**: capture semantic equivalence even with different wording.
- **Disagreement scenario**: high BERTScore + low ROUGE → output is semantically correct but phrased differently (acceptable, especially for abstractive summarization/translation where multiple correct phrasings exist). Low BERTScore + high ROUGE → output copies reference wording but misses meaning (rare, but can happen with garbled/reordered text that coincidentally shares n-grams).
- **Which to trust**: for generative tasks (summarization, translation, open-ended generation), prioritize semantic metrics — lexical metrics were designed for tasks with a narrower space of acceptable outputs (e.g., original BLEU for MT with close reference translations) and don't hold up well for tasks with legitimate output diversity.

**Likely question framing**: mirrors the Group 3 RAG question exactly, but applied to translation/summarization — "translation model scores low BLEU but human eval and BERTScore are high — is this prod ready?" → yes, likely, since BLEU's rigidity against valid paraphrasing is the known limitation, not the model's quality.

---

### 2. Fine-Tuning Failure Modes (LLM + Classical Crossover)

- **Catastrophic forgetting**: fine-tuning on a narrow dataset causes the model to lose general capabilities it had before (overwrites pretrained knowledge). Symptom: great on fine-tune task, noticeably worse on general/unrelated queries it used to handle fine.
- Fix: lower learning rate, fewer epochs, PEFT/LoRA (updates a small subset of parameters, leaving most pretrained weights frozen — inherently less prone to forgetting than full fine-tuning), or mix in some general-domain data during fine-tuning (replay).
- **Overfitting on small fine-tune dataset**: symptom is model memorizing training examples verbatim, poor generalization to slightly different phrasing at inference.
- Fix: more diverse data, early stopping, lower LoRA rank (less capacity to memorize), regularization/dropout in adapter layers.
- **LoRA rank too low**: model underfits the fine-tuning task — not enough capacity in the low-rank adapters to capture the needed behavior change. Symptom: fine-tuned model barely differs from base model on the target task.
- **LoRA rank too high**: approaches full fine-tuning capacity/cost, increasing overfitting risk and losing LoRA's efficiency benefit — defeats the purpose (large rank ≈ small efficiency gain, more memorization risk).

**Likely question framing**: "fine-tuned model performs worse on tasks it used to handle well before fine-tuning" → catastrophic forgetting, prescribe LoRA/PEFT over full fine-tuning, or add replay data.