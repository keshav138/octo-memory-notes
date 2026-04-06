Here’s a structured, category-wise list of classic machine learning models to cover in your revision folder, ending right before the transformer era (i.e., up to but not including BERT/GPT/Transformer architectures). These are the foundational models every ML practitioner should know.

---

## 1. Supervised Learning – Regression & Classification

### Linear Models
- **Linear Regression** (Ordinary Least Squares)
- **Ridge Regression** (L2 regularization)
- **Lasso Regression** (L1 regularization)
- **Elastic Net** (L1 + L2)
- **Logistic Regression** (binary & multinomial)

### Nearest Neighbor
- **k-Nearest Neighbors (k-NN)** – for classification & regression

### Support Vector Machines
- **Linear SVM**
- **Kernel SVM** (polynomial, RBF, sigmoid kernels)
- **SVR (Support Vector Regression)**

### Naive Bayes
- Gaussian Naive Bayes
- Multinomial Naive Bayes
- Bernoulli Naive Bayes

### Decision Trees
- **ID3** (Iterative Dichotomiser 3)
- **C4.5** (successor to ID3)
- **CART** (Classification & Regression Trees)

---

## 2. Ensemble Methods

### Bagging
- **Bagged Decision Trees**
- **Random Forest**

### Boosting
- **AdaBoost** (Adaptive Boosting)
- **Gradient Boosting Machines (GBM)**
- **XGBoost** (2014 – late classic, pre-transformer)
- **LightGBM** & **CatBoost** (optional – slightly later but still classic)

### Stacking & Voting
- **Stacked Generalization**
- **Hard/Soft Voting Classifiers**

---

## 3. Unsupervised Learning

### Clustering
- **k-Means**
- **k-Medoids (PAM)**
- **Hierarchical Clustering** (Agglomerative, Divisive)
- **DBSCAN**
- **Gaussian Mixture Models (GMM)** – EM algorithm

### Dimensionality Reduction
- **PCA** (Principal Component Analysis)
- **SVD** (Singular Value Decomposition)
- **LDA** (Linear Discriminant Analysis – supervised, but often grouped here)
- **t-SNE** (for visualization – 2008)
- **Isomap**
- **LLE** (Locally Linear Embedding)

### Anomaly Detection (classic)
- **Isolation Forest**
- **One-Class SVM**

### Association Rule Learning
- **Apriori Algorithm**
- **FP-Growth**

---

## 4. Probabilistic Graphical Models (Classic ML)

- **Naive Bayes** (already in supervised)
- **Hidden Markov Models (HMMs)**
- **Gaussian Mixture Models (GMMs)**
- **Latent Dirichlet Allocation (LDA)** – topic modeling
- **Markov Random Fields** (basics)

---

## 5. Neural Networks (Pre-Transformer)

### Feedforward
- **Perceptron**
- **Multi-Layer Perceptron (MLP)** with backpropagation

### Early Deep Architectures
- **Deep Belief Networks (DBN)** – Hinton et al.
- **Autoencoders** (Undercomplete, Denoising, Sparse)
- **Stacked Autoencoders**

### Convolutional Networks (Early)
- **LeNet-5** (1998)
- **AlexNet** (2012 – key transition to deep learning)
- **VGG**, **GoogLeNet (Inception)** – optional if focusing on classic

### Recurrent Networks
- **Vanilla RNN**
- **Long Short-Term Memory (LSTM)**
- **Gated Recurrent Unit (GRU)** – 2014

### Word Embeddings (Pre-Transformer)
- **Word2Vec** (CBOW, Skip-gram – 2013)
- **GloVe** (2014)

### Sequence-to-Sequence (Pre-Transformer)
- **Seq2Seq with Attention** (Bahdanau et al., 2014 – *this is the immediate predecessor to Transformers*)

---

## 6. Dimensionality Reduction & Feature Learning (Classic)

- **Factor Analysis**
- **Independent Component Analysis (ICA)**
- **Non-negative Matrix Factorization (NMF)**
- **Autoencoders** (listed above, but also here for feature learning)

---

## 7. Model Selection & Evaluation (Concepts to revise)

- Train/Validation/Test Split
- k-Fold Cross-Validation
- Bias-Variance Tradeoff
- Overfitting & Regularization (L1/L2)
- Evaluation metrics (Accuracy, Precision, Recall, F1, ROC-AUC, MSE, MAE, R²)

---

## 8. Optimization Algorithms (Classic)

- **Gradient Descent** (Batch, Stochastic, Mini-batch)
- **Momentum** & Nesterov Accelerated Gradient
- **Adagrad, RMSprop, Adam** (2014 – late classic)
- **Newton’s Method** (for reference)

---

## Suggested Order for Revision

1. Linear models → k-NN → Naive Bayes  
2. Decision Trees → Bagging → Random Forest → Boosting  
3. SVM → Logistic Regression  
4. Clustering (k-Means, Hierarchical, DBSCAN)  
5. PCA, t-SNE, LDA  
6. HMMs, GMMs  
7. Neural Networks: MLP → RNN → LSTM → GRU  
8. Word2Vec, GloVe  
9. Seq2Seq with Attention (stop here – before Transformers)

---

Would you like me to also provide a checklist template or a folder structure (e.g., PDFs, code notebooks, summaries) for organizing these topics?