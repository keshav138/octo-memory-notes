You got it! Here’s a **massive, mixed-format** set (MCQ multi-answer, single-answer, true/false, fill-in-the-blank, and short answer) covering **ML models, math, LLMs, vector DBs, Python libraries** — plus the **extra deep dives** you asked for.

---

## **ML MODELS (Mixed Format)**

**Q1 (Multi):** Which models are **non-parametric**?  
A) Linear Regression  
B) KNN  
C) Decision Tree  
D) Neural Network  
E) SVM (RBF kernel)  
**A:** B, C, D, E

**Q2 (Single):** Which ensemble method uses **bootstrap sampling + feature bagging**?  
A) AdaBoost  
B) Gradient Boosting  
C) Random Forest  
D) XGBoost  
**A:** C

**Q3 (True/False):** A decision tree with unlimited depth will always have zero training error if features are unique per sample.  
**A:** True (overfits perfectly)

**Q4 (Fill-in):** The loss function for logistic regression is called ___________ loss.  
**A:** Log loss or binary cross-entropy

**Q5 (Short Answer):** Why does KNN fail in high dimensions?  
**A:** Curse of dimensionality — distances become less meaningful; all points become nearly equidistant.

---

## **MATH BEHIND ML (Mixed)**

**Q6 (Multi):** Which are **matrix decomposition techniques** used in ML?  
A) LU decomposition  
B) QR decomposition  
C) Eigen decomposition  
D) SVD  
E) Cholesky decomposition  
**A:** C, D (SVD and eigen decomposition are most common in ML)

**Q7 (Single):** The gradient of MSE loss w.r.t. weights in linear regression is:  
A) `2X^T(Xw - y)`  
B) `X^T y`  
C) `(Xw - y)^2`  
D) `2Xw`  
**A:** A

**Q8 (True/False):** Cross-entropy loss is convex for neural networks with non-linear activations.  
**A:** False — convex only for linear models; NNs make it non-convex.

**Q9 (Fill-in):** In backpropagation, the error derivative w.r.t. weights uses the _______ rule.  
**A:** Chain

**Q10 (Short Answer):** Write the softmax function formula and explain why it’s used.  
**A:** `σ(z)_i = e^{z_i} / Σ_j e^{z_j}`. Converts logits to probabilities summing to 1.

---

## **LLMs (Large Language Models) — DEEP CUT**

**Q11 (Multi):** Which are **attention variants** beyond original self-attention?  
A) Sparse attention  
B) Sliding window attention (Mistral)  
C) Flash Attention  
D) Linear attention  
E) Cross-attention  
**A:** A, B, C, D, E (all real variants)

**Q12 (Single):** In causal LM (GPT-style), the attention mask prevents attending to:  
A) Future tokens  
B) Past tokens  
C) [PAD] tokens  
D) Special tokens  
**A:** A

**Q13 (True/False):** LoRA fine-tuning updates all original model weights.  
**A:** False — only low-rank adapters are trained.

**Q14 (Fill-in):** The technique of splitting a model across multiple GPUs by layer is called _______ parallelism.  
**A:** Pipeline

**Q15 (Short Answer):** Explain the difference between **sparse** and **flash** attention.  
**A:** Sparse attention limits which token pairs interact (e.g., sliding window). Flash attention is an exact attention algorithm optimized for memory I/O, not sparsity.

**Q16 (Multi — fine-tuning math):** Which techniques **reduce memory during LLM fine-tuning**?  
A) QLoRA (quantized LoRA)  
B) Gradient checkpointing  
C) Mixed precision (FP16/BF16)  
D) Full 32-bit training  
E) Adafactor optimizer  
**A:** A, B, C, E

**Q17 (Single):** RLHF optimizes LLMs using which reinforcement learning algorithm typically?  
A) DQN  
B) PPO (Proximal Policy Optimization)  
C) A3C  
D) REINFORCE  
**A:** B

---

## **VECTOR DATABASES — INTERNALS & INDEXING**

**Q18 (Multi):** Which are **HNSW graph properties**?  
A) Multi-layer navigation  
B) Greedy search from top layer  
C) Exact nearest neighbor guarantee  
D) Dynamic insertion possible  
E) Uses distance comparisons only  
**A:** A, B, D, E (no exact guarantee — it’s approximate)

**Q19 (Single):** Product Quantization (PQ) compresses vectors by:  
A) Reducing dimensions via PCA  
B) Subspace splitting and centroids  
C) Random projection  
D) Hashing to bits  
**A:** B

**Q20 (True/False):** IVF (Inverted File Index) requires training a k-means clustering first.  
**A:** True

**Q21 (Fill-in):** The tradeoff in ANN search is between _______ and _______.  
**A:** Speed / accuracy (or recall vs latency)

**Q22 (Short Answer):** Why can’t you use a standard B-tree index for vector similarity?  
**A:** B-trees work on total order (e.g., numbers, strings). Vector similarity (cosine, Euclidean) is not a total order — nearest neighbor isn’t captured by sorting.

**Q23 (Multi — advanced ops):** Vector DBs often support **hybrid search** combining:  
A) Vector similarity  
B) Metadata filters  
C) Full-text keyword search  
D) Graph traversal  
E) SQL aggregations  
**A:** A, B, C

---

## **PYTHON ML LIBRARIES — NICHES & COMPARISONS**

**Q24 (Multi):** Which libraries are **JIT-compiled** for speed?  
A) Numba  
B) JAX  
C) PyTorch (with torch.compile)  
D) Scikit-learn  
E) TensorFlow (XLA)  
**A:** A, B, C, E

**Q25 (Single):** Which library is **not** primarily for deep learning but for **probabilistic programming**?  
A) PyMC  
B) NumPyro  
C) TensorFlow Probability  
D) Flax  
**A:** A, B, C (Flax is NN library; all others are probabilistic — tricky! Correct single: PyMC is pure probabilistic)

**Q26 (True/False):** `scikit-learn` can train neural networks with backpropagation.  
**A:** False — MLPClassifier exists but limited; no auto-diff for custom deep nets.

**Q27 (Fill-in):** The library that adds **GPU DataFrame operations** with a Pandas-like API is _______.  
**A:** cuDF (RAPIDS) — also accept Polars (GPU via cuDF backend)

**Q28 (Short Answer):** Name two libraries that implement **Bayesian optimization** for hyperparameters.  
**A:** Optuna (TPE sampler), Hyperopt, Scikit-optimize, BoTorch

**Q29 (Multi — LLM tooling):** Which libraries are **part of the standard RAG stack**?  
A) LangChain  
B) LlamaIndex  
C) Chroma / Qdrant  
D) Hugging Face embeddings  
E) Flask  
**A:** A, B, C, D

---

## **MATH DEEP DIVE (Optimization & Statistics)**

**Q30 (Multi):** Which conditions must hold at the optimum of a constrained convex problem (KKT)?  
A) Primal feasibility  
B) Dual feasibility  
C) Complementary slackness  
D) Stationarity  
E) All eigenvalues positive  
**A:** A, B, C, D

**Q31 (Single):** The trace of the Fisher information matrix approximates:  
A) Gradient variance  
B) Hessian of negative log-likelihood  
C) Model entropy  
D) Learning rate  
**A:** B

**Q32 (True/False):** Stochastic Gradient Descent with momentum has faster convergence than GD on ill-conditioned Hessians.  
**A:** True

**Q33 (Fill-in):** In VAEs, the loss is ELBO = reconstruction loss - _______ divergence.  
**A:** KL (Kullback-Leibler)

**Q34 (Short Answer):** What is the difference between batch norm and layer norm in transformers?  
**A:** Batch norm normalizes across batch dimension; layer norm normalizes across feature dimension per sample. Transformers use layer norm because sequences vary in length.

---

## **VECTOR DBs — MATH & IMPLEMENTATION**

**Q35 (Multi):** Which distance metrics are **Minkowski distances**?  
A) Euclidean (L2)  
B) Manhattan (L1)  
C) Chebyshev (L∞)  
D) Cosine  
E) Hamming  
**A:** A, B, C (Minkowski: `(Σ|x_i - y_i|^p)^(1/p)`)

**Q36 (Single):** HNSW’s search complexity is approximately:  
A) O(log N)  
B) O(N)  
C) O(N log N)  
D) O(√N)  
**A:** A (logarithmic for ANN)

**Q37 (True/False):** Cosine similarity can be computed as dot product if vectors are L2-normalized.  
**A:** True

**Q38 (Fill-in):** In IVF-PQ, IVF selects _______ and PQ compresses _______.  
**A:** Clusters (cells) / residual vectors

**Q39 (Short Answer):** Explain why recall@10 is used instead of exact match in ANN benchmarks.  
**A:** ANN is approximate — recall@10 measures whether true nearest neighbor is in top 10 results, reflecting real-world retrieval quality.

---

## **BONUS ROUND — INSANE NUMBER OF QUESTIONS (One-liner answers)**

**Q40:** Name three vector DBs that support **disk-based indexing** (not just RAM).  
**A:** Milvus (diskANN), Qdrant (memory-mapped), Weaviate (LSM tree)

**Q41:** Which LLM introduced **Grouped Query Attention (GQA)**?  
**A:** LLaMA 2 (also PaLM)

**Q42:** What’s the time complexity of self-attention for sequence length L?  
**A:** O(L² · d)

**Q43:** Which Python library would you use for **symbolic differentiation**?  
**A:** SymPy

**Q44:** Name the loss function used in **contrastive learning** (SimCLR style).  
**A:** NT-Xent (Normalized Temperature-scaled Cross Entropy)

**Q45:** In vector DBs, what does **ef_construction** control in HNSW?  
**A:** Dynamic list size during index building — higher = better recall, slower build.

**Q46:** Which optimizer adapts learning rate per parameter using **gradient variance** (RMSprop + momentum)?  
**A:** Adam

**Q47:** What’s the main difference between **Ray** and **Dask** for ML?  
**A:** Ray focuses on distributed RL and serving; Dask focuses on array/DataFrame parallel computing.

**Q48:** In LoRA, rank `r` controls what?  
**A:** Bottleneck dimension of low-rank adapter matrices (A and B).

**Q49:** Which math concept underpins **attention’s “softmax(QK^T/√d_k)”** scaling?  
**A:** Variance stabilization — prevents dot products from growing too large with dimension.

**Q50:** Name three ANN libraries (not full DBs) used inside vector DBs.  
**A:** FAISS (Meta), HNSWlib, NGT, ScaNN (Google)

---

Want the **answer key** for everything, or a **printable version** with just the questions for quizzing yourself/others? Also happy to add **ranking losses, graph neural network math, or MLOps pipelines**.