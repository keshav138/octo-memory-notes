# Machine Learning Interview Question Bank

*150 questions covering Fundamental ML, ML Algorithms, Optimization, Deep Learning, NLP, CV, LLMs, and Model Evaluation — with situational/applied questions throughout.*

---

## 1. Fundamentals of ML (Q1–Q18) [[Answer Sheet - Fundamentals of ML]]

1. Explain the bias-variance tradeoff. How do you diagnose which one is dominating in a model?
2. What is overfitting vs underfitting? List 5 concrete techniques to fix each.
3. Why does L1 regularization induce sparsity while L2 doesn't?
4. Derive/explain the difference between L1 and L2 regularization geometrically (norm ball intuition).
5. What is the curse of dimensionality, and how does it affect distance-based algorithms like KNN?
6. Explain generative vs discriminative models with examples.
7. What is the difference between parametric and non-parametric models?
8. Explain the No Free Lunch theorem — what does it actually imply for practitioners?
9. What is data leakage? Give three subtle examples that are easy to miss.
10. Explain train/validation/test split philosophy. Why can't you tune hyperparameters on the test set?
11. What is k-fold cross-validation, and when would you prefer stratified k-fold?
12. Explain the difference between covariance and correlation.
13. What is multicollinearity, and how do you detect and handle it (VIF, condition number)?
14. Explain Maximum Likelihood Estimation (MLE) vs Maximum A Posteriori (MAP).
15. What's the difference between a loss function, cost function, and objective function?
16. Explain the exploration-exploitation tradeoff and where it shows up outside of RL.
17. What is feature scaling, and which algorithms genuinely require it vs don't?
18. Explain the difference between bagging and boosting at a conceptual level.

## 2. ML Algorithms (Q19–Q40) [[Answer Sheet - ML Algorithms]]

19. Derive the closed-form (normal equation) solution for linear regression. When does it fail?
20. Why is logistic regression called "regression" if it's used for classification?
21. Explain the sigmoid vs softmax function — when do you use which?
22. What assumptions does linear regression make? What happens when each is violated?
23. Explain how a decision tree chooses splits (Gini impurity vs entropy/information gain).
24. Why do decision trees overfit easily, and how does pruning help?
25. Explain Random Forest — why does bagging + feature subsampling reduce variance?
26. Explain Gradient Boosting (GBM) step by step. How does it differ from AdaBoost?
27. What's the intuition behind XGBoost's regularization terms and second-order (Newton) approximation?
28. Explain the kernel trick in SVMs. Why does it avoid explicit feature transformation?
29. What is the margin in SVM, and how do hard-margin and soft-margin SVMs differ?
30. Explain Naive Bayes and why the "naive" independence assumption often still works well in practice.
31. How does KNN work, and what's the effect of increasing k on bias/variance?
32. Explain K-Means clustering. What are its failure modes (non-convex clusters, differing densities)?
33. How do you choose the number of clusters (elbow method, silhouette score, gap statistic)?
34. Explain hierarchical clustering (agglomerative vs divisive) and linkage criteria.
35. Explain PCA step by step — what does it maximize, and what's the role of eigenvectors/eigenvalues?
36. When would you prefer PCA vs t-SNE vs UMAP for dimensionality reduction/visualization?
37. Explain DBSCAN and how it handles noise/outliers differently from K-Means.
38. What is the EM algorithm, and how does it relate to Gaussian Mixture Models?
39. Explain collaborative filtering vs content-based filtering in recommendation systems.
40. How does a Hidden Markov Model differ from a plain Markov Chain, and where is it used?

## 3. Optimization (Q41–Q55)

41. Derive gradient descent update rule. What's the role of the learning rate?
42. Explain the difference between batch, stochastic, and mini-batch gradient descent.
43. Why does SGD with a noisy gradient sometimes generalize better than full-batch GD?
44. Explain momentum in optimization — why does it help escape saddle points/local minima?
45. Explain Adam optimizer — what do the first and second moment estimates represent?
46. Compare Adam vs SGD with momentum — why might SGD generalize better despite slower convergence?
47. What is a learning rate schedule? Explain warmup, cosine decay, and step decay.
48. What is gradient clipping, and why is it critical for training RNNs/Transformers?
49. Explain convex vs non-convex optimization. Why is deep learning optimization non-convex, and does it matter in practice?
50. What are saddle points, and why are they a bigger problem than local minima in high dimensions?
51. Explain the vanishing and exploding gradient problem and their respective root causes.
52. What is Newton's method, and why isn't it commonly used for training large neural networks?
53. Explain Lagrange multipliers and their role in constrained optimization (e.g., SVM dual problem).
54. What is the difference between first-order and second-order optimization methods?
55. Explain weight decay — is it mathematically identical to L2 regularization under Adam? Why or why not?

## 4. Deep Learning (Q56–Q78)

56. Derive backpropagation for a simple 2-layer neural network.
57. Explain the chain rule's role in backpropagation and why computational graphs make this tractable.
58. Compare ReLU, Sigmoid, Tanh, and GELU — pros, cons, and when to use each.
59. What is the dying ReLU problem, and how do Leaky ReLU/ELU address it?
60. Explain dropout — why does it work, and why is it turned off at inference (with scaling)?
61. Explain Batch Normalization — what problem does it solve, and how does it behave differently in train vs eval mode?
62. Compare BatchNorm, LayerNorm, GroupNorm, and InstanceNorm — when is each appropriate?
63. Why is LayerNorm preferred over BatchNorm in Transformers?
64. Explain weight initialization strategies (Xavier/Glorot, He initialization) and why they matter.
65. What is the universal approximation theorem, and what does it NOT tell you about trainability?
66. Explain skip/residual connections — why do they help train very deep networks?
67. What is the difference between a generative and discriminative deep learning model (e.g., GAN vs classifier)?
68. Explain how a GAN is trained — describe the minimax game between generator and discriminator.
69. What is mode collapse in GANs, and how can it be mitigated?
70. Explain the architecture and purpose of a Variational Autoencoder (VAE), including the reparameterization trick.
71. Explain how RNNs process sequences, and why they suffer from vanishing gradients over long sequences.
72. Explain LSTM gates (forget, input, output) and how they mitigate vanishing gradients.
73. Compare GRU vs LSTM — what's simplified and what's the tradeoff?
74. What is teacher forcing in sequence models, and what problem (exposure bias) does it introduce?
75. Explain the concept of an embedding layer and how it differs from one-hot encoding.
76. What is transfer learning, and how does fine-tuning differ from feature extraction?
77. Explain knowledge distillation — how does a smaller "student" model learn from a "teacher"?
78. What is mixed-precision training, and why does it speed up training without hurting accuracy much?

## 5. NLP (Q79–Q94)

79. Explain the difference between stemming and lemmatization.
80. Compare Bag-of-Words, TF-IDF, and word embeddings — what does each capture (or fail to capture)?
81. Explain how Word2Vec (Skip-gram vs CBOW) learns embeddings.
82. What is the difference between static embeddings (Word2Vec/GloVe) and contextual embeddings (BERT)?
83. Explain subword tokenization (BPE, WordPiece, SentencePiece) — why not use word-level or character-level tokenization?
84. Explain the self-attention mechanism step by step (Q, K, V matrices, scaled dot product).
85. Why is attention scaled by √d_k in "Scaled Dot-Product Attention"?
86. Explain multi-head attention — why use multiple heads instead of one large attention operation?
87. What is positional encoding, and why do Transformers need it (unlike RNNs)?
88. Explain the encoder-decoder Transformer architecture and where cross-attention fits in.
89. Compare BERT's masked language modeling objective vs GPT's autoregressive/causal LM objective.
90. What is the difference between encoder-only, decoder-only, and encoder-decoder architectures? Give a use case for each.
91. Explain Named Entity Recognition (NER) and typical modeling approaches (CRF, BiLSTM-CRF, transformer-based).
92. What is perplexity as a language model evaluation metric, and what are its limitations?
93. Explain beam search vs greedy decoding vs top-k/nucleus (top-p) sampling for text generation.
94. What is the difference between extractive and abstractive summarization?

## 6. Computer Vision (Q95–Q109)

95. Explain how a convolution operation works, including stride, padding, and kernel size effects on output shape.
96. Why do CNNs use parameter sharing, and how does that help with translation invariance?
97. Explain pooling layers (max vs average) — what do they achieve, and why are they used less in modern architectures?
98. What is the receptive field of a CNN layer, and why does it matter for deep architectures?
99. Explain the intuition behind ResNet's residual blocks and why they solved the degradation problem in very deep CNNs.
100. Compare VGG, ResNet, and Inception architectures — what design philosophy differs?
101. Explain the difference between semantic segmentation, instance segmentation, and panoptic segmentation.
102. How does a Region Proposal Network (RPN) work in Faster R-CNN?
103. Explain the difference between one-stage (YOLO/SSD) and two-stage (Faster R-CNN) object detectors — tradeoffs?
104. What is Non-Maximum Suppression (NMS), and why is it needed in object detection?
105. Explain Intersection over Union (IoU) and its role in detection evaluation and anchor matching.
106. What is a Vision Transformer (ViT), and how does it adapt the Transformer architecture (built for sequences) to images?
107. Explain data augmentation techniques for CV and why they act as implicit regularization.
108. What is CLIP, and how does contrastive learning align image and text embeddings in a shared space?
109. Explain the difference between anchor-based and anchor-free object detection approaches.

## 7. LLMs (Q110–Q128)

110. Explain the three stages of building a modern LLM: pretraining, supervised fine-tuning (SFT), and alignment (RLHF/DPO).
111. What are scaling laws (Chinchilla-style), and what do they say about the optimal ratio of model size to training tokens?
112. Explain RLHF end to end — reward model training and policy optimization (PPO).
113. What is DPO (Direct Preference Optimization), and why does it avoid training an explicit reward model?
114. Explain what "hallucination" means in LLMs and 3 mitigation strategies at inference/architecture level.
115. What is in-context learning, and why can a frozen LLM "learn" a task from a few examples in the prompt without gradient updates?
116. Explain the difference between prompt engineering, prompt tuning, and fine-tuning.
117. What is LoRA (Low-Rank Adaptation)? Why is it parameter-efficient, and how does it get merged back into the base model?
118. Compare full fine-tuning vs LoRA vs QLoRA — what's the tradeoff in memory, speed, and quality?
119. Explain Retrieval-Augmented Generation (RAG) architecture end to end.
120. What is the difference between dense retrieval (embedding-based) and sparse retrieval (BM25), and when would you combine them (hybrid search)?
121. Explain re-ranking in a RAG pipeline — why is a two-stage retrieve-then-rerank system often better than retrieval alone?
122. What is HyDE (Hypothetical Document Embeddings), and what retrieval problem does it try to solve?
123. Explain KV-caching in autoregressive decoding — why is it essential for inference speed?
124. What is the difference between quantization (INT8/INT4) and distillation for reducing LLM inference cost?
125. Explain the difference between causal (autoregressive) masking and bidirectional attention, and why decoder-only models dominate current LLMs.
126. What is context window / context length, and what architectural techniques (RoPE, ALiBi, sliding window attention) help extend it?
127. Explain agentic LLM systems — what does "tool use" or "function calling" actually change about how the model operates?
128. What is catastrophic forgetting in the context of fine-tuning an LLM on a narrow domain, and how do you mitigate it?

## 8. Model Evaluation (Q129–Q143)

129. Explain precision, recall, and F1-score. When would you prioritize precision over recall, or vice versa?
130. What is a ROC curve, and how does it differ from a Precision-Recall curve? When is PR curve more informative than ROC?
131. Explain AUC-ROC — what does an AUC of 0.5 vs 1.0 mean intuitively?
132. What is a confusion matrix, and how do you derive all major classification metrics from it?
133. Explain the difference between macro, micro, and weighted averaging for multi-class F1/precision/recall.
134. What is calibration in classification models, and how do you measure it (reliability diagrams, Brier score)?
135. Explain R², Adjusted R², RMSE, and MAE for regression — when does R² mislead you?
136. What is the bias in using accuracy as a metric on an imbalanced dataset? Give a concrete failure example.
137. Explain how you'd design an A/B test to validate a new ML model in production, including guardrail metrics.
138. What is statistical significance vs practical significance in model comparison, and why do both matter?
139. Explain BLEU and ROUGE scores for text generation — what are their known weaknesses?
140. How do RAGAS-style metrics (faithfulness, answer relevancy, context precision/recall) evaluate a RAG pipeline?
141. What is concept drift vs data drift, and how would you monitor for each in a production model?
142. Explain cross-validation strategies for time-series data — why can't you use standard k-fold?
143. What is the difference between offline evaluation and online evaluation, and why can they disagree?

## 9. Situational / Applied Questions (Q144–Q150)

144. Your model has 99% accuracy on a fraud detection dataset with 0.5% fraud rate, but the business says it's useless. What's going on, and how do you fix your evaluation and modeling approach?
145. You're training a Transformer and the loss becomes NaN after a few hundred steps. Walk through your debugging process.
146. Your team lead asks you to reduce inference latency of a production LLM-based system by 3x with minimal quality loss. What levers would you pull, in order of effort vs impact?
147. You built a RAG pipeline, but it keeps retrieving irrelevant chunks for domain-specific queries (e.g., a low-resource language corpus). How do you diagnose whether the issue is chunking, embeddings, or retrieval, and what would you try first?
148. A stakeholder wants to deploy a model that performs well offline but you suspect it won't generalize because your train/test split leaked future information. How do you explain and prove this, and how do you redesign the split?
149. You have a small labeled dataset (~5k examples) for a text classification task and a huge unlabeled corpus. Compare at least 3 strategies (fine-tuning a pretrained LM, few-shot prompting an LLM, semi-supervised/pseudo-labeling) and how you'd decide between them given compute constraints.
150. Your CNN-based image classifier performs great on validation but degrades sharply on real-world production images. List the possible causes (distribution shift, augmentation mismatch, preprocessing bugs, label noise) and how you'd isolate the actual root cause.

---
*Tip: For each topic section, try answering out loud in under 2 minutes per question — that's roughly the depth expected in a screening round. Save deeper derivations (backprop, attention, gradient descent) for whiteboard-style rounds.*
