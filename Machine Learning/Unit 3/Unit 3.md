# Supervised Learning: Classification - Comprehensive Notes

## 1. K-Nearest Neighbors (KNN) - Lazy Learning

### Intuition

KNN is called "lazy learning" because it doesn't build an explicit model during training. Instead, it memorizes the entire training dataset and makes predictions by finding the K most similar examples to a new data point. Think of it as asking your K closest neighbors for their opinion and taking a majority vote.

### Key Concepts

- **Instance-based learning**: Stores all training data and makes decisions at prediction time
- **Distance metric**: Typically uses Euclidean distance to measure similarity
- **K parameter**: Number of neighbors to consider (hyperparameter)
- **Voting mechanism**: Classification by majority vote among K neighbors

### Math Outline

- **Euclidean Distance**: d(x, y) = √(Σ(xᵢ - yᵢ)²)
- **Manhattan Distance**: d(x, y) = Σ|xᵢ - yᵢ|
- **Prediction**: ŷ = mode({yᵢ : i ∈ K nearest neighbors})

### Advantages & Disadvantages

**Pros**: Simple, no training phase, effective for non-linear boundaries **Cons**: Computationally expensive at prediction time, sensitive to feature scaling, curse of dimensionality

---

## 2. Naïve Bayes

### Intuition

Naïve Bayes applies Bayes' theorem with a "naïve" assumption: all features are independent given the class label. Despite this strong assumption rarely holding in practice, it works surprisingly well for many real-world problems like spam detection and text classification.

### Key Concepts

- **Probabilistic classifier**: Calculates probability of each class given features
- **Independence assumption**: Features are conditionally independent given the class
- **Prior probability**: P(Class) - probability of each class in training data
- **Likelihood**: P(Features|Class) - probability of features given a class

### Math Outline

**Bayes' Theorem**:

- P(C|X) = P(X|C) × P(C) / P(X)

**Naïve Bayes Classifier**:

- P(C|x₁, x₂, ..., xₙ) ∝ P(C) × ∏P(xᵢ|C)

**Classification**:

- ŷ = argmax_c P(C=c) × ∏P(xᵢ|C=c)

### Variants

- **Gaussian Naïve Bayes**: For continuous features (assumes normal distribution)
- **Multinomial Naïve Bayes**: For discrete counts (text classification)
- **Bernoulli Naïve Bayes**: For binary features

### Advantages & Disadvantages

**Pros**: Fast training and prediction, works well with high dimensions, handles missing values **Cons**: Independence assumption often violated, can't learn feature interactions

---

## 3. Decision Trees - Divide and Conquer

### Intuition

Decision trees learn a sequence of if-then-else rules by recursively splitting the data based on features that best separate classes. Like a flowchart, each internal node represents a test on a feature, each branch represents an outcome, and each leaf represents a class label.

### Key Concepts

- **Recursive partitioning**: Split data into subsets based on feature values
- **Splitting criteria**: Choose features that maximize information gain or minimize impurity
- **Stopping criteria**: Max depth, minimum samples per leaf, minimum impurity decrease
- **Pruning**: Remove branches to prevent overfitting

### Math Outline

**Entropy** (measure of impurity):

- H(S) = -Σ pᵢ log₂(pᵢ)
- Where pᵢ is proportion of class i in set S

**Information Gain**:

- IG(S, A) = H(S) - Σ (|Sᵥ|/|S|) × H(Sᵥ)
- Where Sᵥ is subset of S where attribute A has value v

**Gini Impurity**:

- Gini(S) = 1 - Σ pᵢ²
- Used in CART (Classification and Regression Trees)

### Advantages & Disadvantages

**Pros**: Interpretable, handles non-linear relationships, requires little preprocessing **Cons**: Prone to overfitting, unstable (small data changes cause different trees), biased toward features with more levels

---

## 4. Support Vector Machine (SVM)

### Intuition

SVM finds the optimal hyperplane that maximally separates different classes by maximizing the margin (distance) between the hyperplane and the nearest data points from each class (support vectors). Think of it as finding the widest possible street separating two neighborhoods.

### Key Concepts

- **Maximum margin classifier**: Finds the decision boundary with largest margin
- **Support vectors**: Data points closest to the decision boundary
- **Kernel trick**: Maps data to higher dimensions to find linear separations for non-linear problems
- **Soft margin**: Allows some misclassification with penalty parameter C

### Math Outline

**Linear SVM Objective**:

- Minimize: ½||w||² + C × Σξᵢ
- Subject to: yᵢ(w·xᵢ + b) ≥ 1 - ξᵢ, ξᵢ ≥ 0

**Decision Function**:

- f(x) = sign(w·x + b)

**Kernel Function** (for non-linear):

- K(x, x') = φ(x)·φ(x')
- Common kernels: Linear, Polynomial, RBF (Radial Basis Function)

**RBF Kernel**:

- K(x, x') = exp(-γ||x - x'||²)

### Advantages & Disadvantages

**Pros**: Effective in high dimensions, memory efficient (uses support vectors only), versatile (different kernel functions) **Cons**: Doesn't scale well to large datasets, requires feature scaling, sensitive to hyperparameters

---

## 5. Model Performance Evaluation Metrics

### Confusion Matrix

A table showing the counts of true positive (TP), true negative (TN), false positive (FP), and false negative (FN) predictions.

```
                Predicted
              Pos      Neg
Actual  Pos   TP       FN
        Neg   FP       TN
```

### Accuracy

**Intuition**: Proportion of correct predictions out of all predictions.

**Formula**: Accuracy = (TP + TN) / (TP + TN + FP + FN)

**When to use**: Balanced datasets where all errors are equally important **Limitation**: Misleading for imbalanced datasets (e.g., 95% negative class → always predicting negative gives 95% accuracy)

---

### Precision

**Intuition**: Of all positive predictions, how many were actually positive? Answers: "When the model says positive, how often is it right?"

**Formula**: Precision = TP / (TP + FP)

**When to use**: When false positives are costly (e.g., spam detection - you don't want legitimate emails marked as spam)

---

### Recall (Sensitivity, True Positive Rate)

**Intuition**: Of all actual positives, how many did we correctly identify? Answers: "How many of the actual positives did we catch?"

**Formula**: Recall = TP / (TP + FN)

**When to use**: When false negatives are costly (e.g., cancer detection - you don't want to miss actual cancer cases)

---

### F1 Score

**Intuition**: Harmonic mean of precision and recall, providing a single score that balances both metrics.

**Formula**: F1 = 2 × (Precision × Recall) / (Precision + Recall)

**When to use**: When you need to balance precision and recall, especially with imbalanced datasets

---

### Logarithmic Loss (Log Loss)

**Intuition**: Measures the uncertainty of predictions by penalizing confident wrong predictions heavily. Lower is better.

**Formula**: LogLoss = -1/N × Σ[yᵢ log(pᵢ) + (1-yᵢ) log(1-pᵢ)]

Where:

- N = number of samples
- yᵢ = true label (0 or 1)
- pᵢ = predicted probability for class 1

**When to use**: When you care about the confidence of predictions, not just the class label. Used in probability-based classifiers.

---

### Area Under ROC Curve (AUC-ROC)

**Intuition**: The ROC curve plots True Positive Rate (TPR/Recall) vs False Positive Rate (FPR) at various classification thresholds. AUC measures the entire area under this curve.

**ROC Curve**:

- X-axis: FPR = FP / (FP + TN)
- Y-axis: TPR = TP / (TP + FN)

**AUC Interpretation**:

- AUC = 1.0: Perfect classifier
- AUC = 0.5: Random classifier (diagonal line)
- AUC < 0.5: Worse than random

**When to use**:

- Evaluating model performance across all classification thresholds
- Comparing models regardless of chosen threshold
- Works well for imbalanced datasets

**Advantages**: Threshold-independent, provides aggregate measure of performance **Disadvantages**: May be overly optimistic for highly imbalanced datasets, doesn't reflect specific threshold performance

---

## Summary: Choosing the Right Algorithm

|Algorithm|Best For|Key Strength|Main Weakness|
|---|---|---|---|
|KNN|Small datasets, non-linear boundaries|Simple, no training|Slow prediction, curse of dimensionality|
|Naïve Bayes|Text classification, real-time prediction|Fast, works with high dimensions|Independence assumption|
|Decision Trees|Interpretability, mixed feature types|Easy to understand, no scaling needed|Overfitting, instability|
|SVM|High-dimensional spaces, clear margin|Effective, versatile kernels|Doesn't scale, parameter-sensitive|

## Summary: Choosing the Right Metric

|Metric|Use When|Key Consideration|
|---|---|---|
|Accuracy|Balanced classes, equal error costs|Can be misleading with imbalance|
|Precision|False positives are costly|Minimizes false alarms|
|Recall|False negatives are costly|Minimizes missed cases|
|F1 Score|Need balance, imbalanced data|Harmonic mean of precision/recall|
|Log Loss|Probability predictions matter|Penalizes confident errors|
|AUC-ROC|Threshold-independent evaluation|Overall model discrimination ability|