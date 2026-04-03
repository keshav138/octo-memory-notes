## PRINCIPAL COMPONENT ANALYSIS (PCA)

https://www.youtube.com/watch?v=FgakZw6K1QQ&t=2s

**Definition:** An unsupervised dimensionality reduction technique that transforms high-dimensional data into a lower-dimensional space by finding new orthogonal axes (principal components) that capture the maximum variance in the data. Projects data onto directions of greatest variance while preserving as much information as possible.

**Used For:**

- Dimensionality reduction
- Data visualization (2D/3D)
- Feature extraction
- Noise reduction
- Data compression
- Speeding up machine learning algorithms
- Removing multicollinearity
- Exploratory data analysis

**Cases of Application:**

- Image compression
- Face recognition (Eigenfaces)
- Genomics (gene expression analysis)
- Financial data analysis
- Signal processing
- Data visualization (high-dim → 2D/3D)
- Preprocessing for ML algorithms
- Anomaly detection
- Market basket analysis
- Climate data analysis
- Text mining (after TF-IDF)

**Prerequisites:**

- **Numerical features only**
- **Feature scaling CRITICAL** (StandardScaler)
- No missing values (impute first)
- Linearly correlated features work best
- Sufficient samples (n > p recommended)
- Understanding of variance/correlation

**Performance Measures:**

- Explained variance ratio
- Cumulative explained variance
- Reconstruction error
- Information retention percentage
- Scree plot analysis
- Number of components for target variance (e.g., 95%)
## **Model-Specific Guidelines:**

|Model Type|PCA Recommended?|Notes|
|---|---|---|
|**Linear Regression**|✅ Yes|Helps with multicollinearity|
|**Logistic Regression**|✅ Yes|Same as linear regression|
|**SVM (linear kernel)**|✅ Yes|Improves with orthogonal features|
|**SVM (RBF kernel)**|⚠️ Sometimes|Try both original and PCA|
|**K-Nearest Neighbors**|✅ Yes|Distance metrics work better|
|**Neural Networks**|⚠️ Depends|Can help or hurt - test!|
|**Random Forest**|❌ Usually no|Handles high-dim well|
|**XGBoost/LightGBM**|❌ Usually no|Built-in feature importance|
|**Decision Trees**|❌ No|Feature selection better|
|**K-Means Clustering**|✅ Yes|Distance-based, benefits|
|**Naïve Bayes**|⚠️ Sometimes|Test both approaches|

---

## HOW PCA WORKS

### **Core Concept:**

Find new coordinate system where:

1. First axis (PC1) points in direction of maximum variance
2. Second axis (PC2) perpendicular to PC1, max remaining variance
3. Continue until all variance captured
4. Keep only top k components (dimensionality reduction)

**Visual Intuition (2D → 1D):**

```
Original Data (2 features):

    Y
    ^
    |    •  •
    |  •      •
    | •        •  ← Data forms ellipse
    |•          •
    |____________> X

PC1 points along longest axis of ellipse (max variance)
PC2 perpendicular (min variance)

Project onto PC1:
    
    PC1
    _______________
    • •  •   •  • •  ← All data on one axis
    
Lost some info (Y direction) but kept most variance!
```

**3D Example:**

```
Original: 3 features (X, Y, Z)
Data forms 3D ellipsoid

PC1: Longest axis (most variance)
PC2: Second longest (perpendicular to PC1)
PC3: Shortest (perpendicular to PC1 & PC2)

Keep PC1 + PC2 → Reduce to 2D
Keep 95% of variance, lose only 5%!
```

---

## MATHEMATICAL FOUNDATION

### **Step-by-Step Algorithm:**

**Step 1: Standardize Data**

```
X_scaled = (X - μ) / σ

Why? Features with large scale dominate PCA
Must standardize to unit variance

Example:
Feature 1 (Age): 20-80
Feature 2 (Income): 20000-100000

Without scaling: Income dominates PC1
With scaling: Both features contribute equally
```

**Step 2: Compute Covariance Matrix**

```
Cov(X) = (1/n) XᵀX

Covariance matrix (p × p):
- Diagonal: Variance of each feature
- Off-diagonal: Covariance between features

Example (2 features):
Cov = [ var(X₁)      cov(X₁,X₂) ]
      [ cov(X₂,X₁)   var(X₂)    ]
```

**Step 3: Compute Eigenvectors and Eigenvalues**

```
Solve: Cov(X) · v = λv

Where:
- v = eigenvector (direction of principal component)
- λ = eigenvalue (variance in that direction)

Properties:
- Eigenvectors are orthogonal (perpendicular)
- Eigenvalues measure importance (variance)
- Sort by eigenvalue (largest first)
```

**Step 4: Select Top k Components**

```
Sort eigenvalues: λ₁ ≥ λ₂ ≥ ... ≥ λₚ
Keep top k eigenvectors

Explained variance by component i:
variance_ratio_i = λᵢ / Σλⱼ

Example (4 features):
λ = [45, 30, 15, 10]
Total = 100

PC1: 45/100 = 45% variance
PC2: 30/100 = 30% variance
PC3: 15/100 = 15% variance
PC4: 10/100 = 10% variance

Keep PC1 + PC2: 75% variance retained
```

**Step 5: Transform Data**

```
X_pca = X_scaled · W

Where W = matrix of top k eigenvectors (p × k)

Original: n samples × p features
Transformed: n samples × k components
```

---

## KEY CONCEPTS

### **1. Principal Components**

**Definition:** New features (axes) that are linear combinations of original features.

```
PC1 = w₁₁X₁ + w₁₂X₂ + ... + w₁ₚXₚ
PC2 = w₂₁X₁ + w₂₂X₂ + ... + w₂ₚXₚ
...

Where wᵢⱼ = component loadings (from eigenvectors)
```

**Properties:**

- **Orthogonal** (perpendicular, uncorrelated)
- **Ordered by variance** (PC1 > PC2 > ... > PCₚ)
- **Unit length** (normalized eigenvectors)
- **Maximum variance** (each PC captures max remaining variance)

**Example:**

```
Original features: Height, Weight, Age
PC1 = 0.7×Height + 0.6×Weight + 0.3×Age
PC2 = -0.5×Height + 0.4×Weight + 0.7×Age
PC3 = 0.5×Height - 0.7×Weight + 0.5×Age

PC1 might represent "body size"
PC2 might represent "age vs youth"
PC3 captures remaining variance
```

---

### **2. Explained Variance Ratio**

**Definition:** Proportion of total variance captured by each PC.

```
explained_variance_ratio[i] = λᵢ / Σλⱼ

Must sum to 1.0 (100%)
```

**Example:**

```
4 principal components:
PC1: 0.45 (45%)
PC2: 0.30 (30%)
PC3: 0.15 (15%)
PC4: 0.10 (10%)
Total: 1.00 (100%)

Keep PC1 + PC2: 75% variance
Lose PC3 + PC4: 25% variance lost
```

**Cumulative Variance:**

```
Cumulative = running sum

PC1: 45%
PC1+PC2: 75%
PC1+PC2+PC3: 90%
PC1+PC2+PC3+PC4: 100%

Common threshold: 95% (keep enough PCs for 95% variance)
```

---

### **3. Component Loadings**

**Definition:** Weights showing contribution of each original feature to each PC.

```
High loading: Feature strongly influences PC
Low loading: Feature weakly influences PC

Example:
           PC1    PC2    PC3
Height    0.89   0.12  -0.05
Weight    0.85   0.20   0.10
Age       0.15   0.92   0.05
Gender   -0.02   0.10   0.98

PC1 driven by Height & Weight (body size)
PC2 driven by Age
PC3 driven by Gender
```

---

### **4. Scree Plot**

**Definition:** Graph of explained variance by component number.

```
Variance
    ^
0.5 |•
    |
0.3 | •
    |
0.15|  •
    |   •
0.1 |    •___•___•___
    |________________> Component
       1  2  3  4  5  6

"Elbow" at component 3
Keep components before elbow
```

---

## KEY HYPERPARAMETERS

### **1. n_components**

**Definition:** Number of components to keep.

**Values:**

- **int:** Specific number of components (1, 2, 3, ...)
- **float (0, 1):** Variance threshold (e.g., 0.95 = 95%)
- **'mle':** Automatic selection via MLE (requires n > p)
- **None:** Keep all components (no reduction)

**Examples:**

```python
from sklearn.decomposition import PCA

# Keep 2 components (for visualization)
pca = PCA(n_components=2)

# Keep components explaining 95% variance
pca = PCA(n_components=0.95)

# Keep all (just for rotation/analysis)
pca = PCA(n_components=None)

# Automatic selection
pca = PCA(n_components='mle')
```

**Choosing n_components:**

**Fixed number (int):**

```python
# Visualization: 2D or 3D
pca = PCA(n_components=2)  # For 2D plot
pca = PCA(n_components=3)  # For 3D plot

# Specific reduction
pca = PCA(n_components=10)  # From 100 to 10 features
```

**Variance threshold (float):**

```python
# Keep 95% variance (common choice)
pca = PCA(n_components=0.95)
pca.fit(X_scaled)
print(f"Components kept: {pca.n_components_}")
# Output: Components kept: 8 (example)

# Keep 99% variance (more conservative)
pca = PCA(n_components=0.99)
```

**Recommendations:**

- **Visualization:** n_components=2 or 3
- **ML preprocessing:** n_components=0.95 (95% variance)
- **Compression:** n_components=0.90 (90% variance)
- **Exploration:** Fit with None first, analyze scree plot, then decide

---

### **2. whiten**

**Definition:** Whether to whiten the components.

**Values:** True or False (default)

**Impact:**

**False (default):**

- Keep original variance
- PCs have different scales
- More interpretable

**True:**

- Scale all PCs to unit variance
- All components equal importance
- Useful for some ML algorithms
- Less interpretable

**Formula (when True):**

```
X_whitened = X_pca / √λᵢ

Divides each PC by sqrt of eigenvalue
Result: All PCs have variance = 1
```

**Example:**

```python
# Standard PCA
pca = PCA(n_components=10, whiten=False)

# Whitened PCA
pca = PCA(n_components=10, whiten=True)
```

**When to Use:**

- **False:** Most cases (default)
- **True:** ICA preprocessing, some neural networks

---

### **3. svd_solver**

**Definition:** Algorithm for computing SVD (Singular Value Decomposition).

**Values:** 'auto' (default), 'full', 'arpack', 'randomized'

**Comparison:**

**'auto' (recommended):**

- Automatically selects best solver
- Good default choice

**'full':**

- Exact solution
- Computes all components
- Slow for large datasets
- Most accurate

**'arpack':**

- Iterative method
- Good for sparse matrices
- When n_components << min(n_features, n_samples)

**'randomized':**

- Approximate method
- Very fast
- Good for large datasets
- Small accuracy trade-off

**Example:**

```python
# Default (auto-select)
pca = PCA(svd_solver='auto')

# Large dataset (fast approximation)
pca = PCA(n_components=50, svd_solver='randomized')

# Exact solution
pca = PCA(svd_solver='full')
```

**Recommendations:**

- **Keep 'auto'** for most cases
- **'randomized'** for large data (n > 10000, p > 1000)
- **'arpack'** for sparse data

---

### **4. random_state**

**Definition:** Seed for randomized solver.

**Impact:**

- Controls reproducibility
- Only affects 'randomized' and 'arpack' solvers
- Important for consistent results

**Example:**

```python
pca = PCA(n_components=10, random_state=42)
```

---

## PRACTICAL WORKFLOW

### **Step 1: Explore Data**

```python
import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt

# Load data
X = your_data  # n_samples × n_features

print(f"Original shape: {X.shape}")
print(f"Features: {X.columns.tolist()}")  # If DataFrame
```

---

### **Step 2: Standardize (CRITICAL!)**

```python
# ALWAYS standardize before PCA
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Verify standardization
print(f"Mean: {X_scaled.mean(axis=0)}")  # Should be ~0
print(f"Std: {X_scaled.std(axis=0)}")    # Should be ~1
```

**Why standardization is critical:**

```python
# Example: Without scaling
X_bad = pd.DataFrame({
    'age': [25, 30, 35, 40],        # Range: 15
    'income': [30000, 50000, 70000, 90000]  # Range: 60000
})

pca_bad = PCA()
pca_bad.fit(X_bad)
print(pca_bad.explained_variance_ratio_)
# Output: [0.9999, 0.0001]
# PC1 captures income (large variance), PC2 captures age (small variance)
# AGE INFORMATION LOST!

# With scaling
X_scaled = StandardScaler().fit_transform(X_bad)
pca_good = PCA()
pca_good.fit(X_scaled)
print(pca_good.explained_variance_ratio_)
# Output: [0.85, 0.15]
# Both features contribute fairly
```

---

### **Step 3: Fit PCA (Analyze Variance)**

```python
# Fit with all components first
pca_full = PCA()
pca_full.fit(X_scaled)

# Check explained variance
print("Explained variance ratio:")
print(pca_full.explained_variance_ratio_)

print("\nCumulative variance:")
cumsum = np.cumsum(pca_full.explained_variance_ratio_)
print(cumsum)

# Find components for 95% variance
n_95 = np.argmax(cumsum >= 0.95) + 1
print(f"\nComponents for 95% variance: {n_95}")
```

---

### **Step 4: Visualize with Scree Plot**

```python
# Scree plot
plt.figure(figsize=(10, 6))

# Individual variance
plt.subplot(1, 2, 1)
plt.bar(range(1, len(pca_full.explained_variance_ratio_) + 1),
        pca_full.explained_variance_ratio_)
plt.xlabel('Principal Component')
plt.ylabel('Explained Variance Ratio')
plt.title('Scree Plot')
plt.xticks(range(1, len(pca_full.explained_variance_ratio_) + 1))

# Cumulative variance
plt.subplot(1, 2, 2)
plt.plot(range(1, len(cumsum) + 1), cumsum, 'bo-')
plt.axhline(y=0.95, color='r', linestyle='--', label='95% threshold')
plt.xlabel('Number of Components')
plt.ylabel('Cumulative Explained Variance')
plt.title('Cumulative Variance')
plt.legend()
plt.grid(True)

plt.tight_layout()
plt.show()
```

---

### **Step 5: Transform Data**

```python
# Choose number of components
n_components = 10  # Or based on scree plot

# Fit and transform
pca = PCA(n_components=n_components)
X_pca = pca.fit_transform(X_scaled)

print(f"Original shape: {X_scaled.shape}")
print(f"Reduced shape: {X_pca.shape}")
print(f"Variance retained: {pca.explained_variance_ratio_.sum():.3f}")
```

---

### **Step 6: Analyze Components**

```python
# Component loadings
loadings = pca.components_  # Shape: (n_components, n_features)

# Create loadings DataFrame
loadings_df = pd.DataFrame(
    loadings.T,  # Transpose
    columns=[f'PC{i+1}' for i in range(n_components)],
    index=X.columns  # Original feature names
)

print("Top features for PC1:")
print(loadings_df['PC1'].abs().sort_values(ascending=False).head())

# Visualize loadings
plt.figure(figsize=(10, 6))
plt.imshow(loadings_df.T, cmap='RdBu_r', aspect='auto')
plt.colorbar(label='Loading')
plt.xlabel('Original Features')
plt.ylabel('Principal Components')
plt.xticks(range(len(X.columns)), X.columns, rotation=90)
plt.yticks(range(n_components), [f'PC{i+1}' for i in range(n_components)])
plt.title('PCA Component Loadings')
plt.tight_layout()
plt.show()
```

---

### **Step 7: Visualize Data (2D/3D)**

```python
# 2D Visualization
pca_2d = PCA(n_components=2)
X_2d = pca_2d.fit_transform(X_scaled)

plt.figure(figsize=(10, 8))
plt.scatter(X_2d[:, 0], X_2d[:, 1], alpha=0.5)
plt.xlabel(f'PC1 ({pca_2d.explained_variance_ratio_[0]:.2%})')
plt.ylabel(f'PC2 ({pca_2d.explained_variance_ratio_[1]:.2%})')
plt.title('PCA 2D Projection')
plt.grid(True)
plt.show()

# With labels (if supervised)
if y is not None:
    plt.figure(figsize=(10, 8))
    for label in np.unique(y):
        mask = y == label
        plt.scatter(X_2d[mask, 0], X_2d[mask, 1], 
                   label=f'Class {label}', alpha=0.6)
    plt.xlabel(f'PC1 ({pca_2d.explained_variance_ratio_[0]:.2%})')
    plt.ylabel(f'PC2 ({pca_2d.explained_variance_ratio_[1]:.2%})')
    plt.title('PCA 2D Projection by Class')
    plt.legend()
    plt.grid(True)
    plt.show()
```

---

### **Step 8: Use for ML**

```python
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y, test_size=0.2, random_state=42
)

# Apply PCA
pca = PCA(n_components=0.95)  # Keep 95% variance
X_train_pca = pca.fit_transform(X_train)
X_test_pca = pca.transform(X_test)

print(f"Components kept: {pca.n_components_}")
print(f"Original features: {X_train.shape[1]}")
print(f"Reduced features: {X_train_pca.shape[1]}")

# Train model on reduced data
model = LogisticRegression()
model.fit(X_train_pca, y_train)

# Evaluate
train_score = model.score(X_train_pca, y_train)
test_score = model.score(X_test_pca, y_test)
print(f"\nTrain accuracy: {train_score:.3f}")
print(f"Test accuracy: {test_score:.3f}")
```

---

### **Step 9: Inverse Transform (Reconstruction)**

```python
# Reconstruct original data from PCA
X_reconstructed = pca.inverse_transform(X_pca)

# Compute reconstruction error
reconstruction_error = np.mean((X_scaled - X_reconstructed) ** 2)
print(f"Reconstruction error (MSE): {reconstruction_error:.6f}")

# Visualize reconstruction (example: first sample)
sample_idx = 0
original = X_scaled[sample_idx]
reconstructed = X_reconstructed[sample_idx]

plt.figure(figsize=(12, 5))
plt.subplot(1, 2, 1)
plt.plot(original, 'bo-', label='Original')
plt.plot(reconstructed, 'ro-', label='Reconstructed')
plt.xlabel('Feature Index')
plt.ylabel('Standardized Value')
plt.title(f'Sample {sample_idx}: Original vs Reconstructed')
plt.legend()
plt.grid(True)

plt.subplot(1, 2, 2)
plt.bar(range(len(original)), original - reconstructed)
plt.xlabel('Feature Index')
plt.ylabel('Error')
plt.title('Reconstruction Error per Feature')
plt.grid(True)
plt.tight_layout()
plt.show()
```

---

## ADVANTAGES OF PCA

1. **Dimensionality Reduction**
    - Reduce 100s of features to 10s
    - Faster ML algorithms
    - Less memory
2. **Removes Multicollinearity**
    - PCs are uncorrelated
    - Better for linear models
    - Stable coefficients
3. **Noise Reduction**
    - Minor components = noise
    - Removing them improves signal
4. **Visualization**
    - High-dim → 2D/3D plots
    - Understand data structure
5. **Data Compression**
    - Store less data
    - Faster processing
6. **Improves ML Performance**
    - Less overfitting (fewer features)
    - Faster training
    - Sometimes better accuracy
7. **Unsupervised**
    - No labels needed
    - Works on any numerical data
8. **Mathematical Guarantees**
    - Maximizes variance
    - Optimal linear transformation
    - Well-understood theory

---

## DISADVANTAGES OF PCA

1. **Loss of Interpretability**
    - PCs are combinations of features
    - Hard to explain: "PC1 = 0.3×age + 0.7×income..."
    - Not intuitive
2. **Linear Method**
    - Assumes linear relationships
    - Misses non-linear patterns
    - May need kernel PCA
3. **Sensitive to Scaling**
    - MUST standardize
    - Outliers affect results
    - Extra preprocessing
4. **Information Loss**
    - Throwing away components = losing info
    - May lose important signals
5. **Not Suitable for All Data**
    - Works best with correlated features
    - Poor with independent features
    - Categorical data needs encoding
6. **Direction of Variance ≠ Direction of Importance**
    - PCA finds max variance
    - High variance ≠ high predictive power
    - May keep wrong features for classification
7. **Computationally Expensive**
    - O(min(n²p, p²n)) complexity
    - Slow for very large datasets
8. **Number of Components Unclear**
    - How many to keep?
    - Subjective decision
    - No clear threshold

---

## WHEN TO USE PCA

**Use PCA When:**

✓ High-dimensional data (p > 20) ✓ Features are correlated ✓ Need visualization (2D/3D) ✓ Want to speed up ML algorithms ✓ Remove multicollinearity ✓ Reduce overfitting ✓ Data compression needed ✓ Have mostly numerical features ✓ Can afford to lose interpretability ✓ Linear relationships present

**Avoid PCA When:**

✗ Features are independent (PCA won't help) ✗ Need interpretability (use feature selection) ✗ Very small dataset (n < 50) ✗ Non-linear relationships (use kernel PCA, t-SNE) ✗ Categorical features dominate (encode first) ✗ Don't want preprocessing complexity ✗ Already low-dimensional (p < 10) ✗ Variance doesn't align with importance

---

## PCA VS OTHER METHODS

### **PCA vs Feature Selection:**

**PCA:**

- Creates new features (combinations)
- Loses interpretability
- Keeps all information (in reduced form)
- Unsupervised

**Feature Selection:**

- Keeps original features
- Maintains interpretability
- Discards some features entirely
- Can be supervised

**Example:**

```
Original: [age, income, education, debt]

PCA:
PC1 = 0.5×age + 0.6×income + 0.3×education + 0.5×debt
PC2 = -0.3×age + 0.2×income + 0.8×education - 0.4×debt
Hard to interpret!

Feature Selection:
Keep: [income, education]
Discard: [age, debt]
Still interpretable!
```

---

### **PCA vs t-SNE:**

|Aspect|PCA|t-SNE|
|---|---|---|
|**Type**|Linear|Non-linear|
|**Purpose**|Dimensionality reduction|Visualization only|
|**Speed**|Fast|Slow|
|**Deterministic**|Yes|No (random)|
|**Global structure**|Preserves|May not preserve|
|**Local structure**|May lose|Preserves|
|**Interpretable**|Somewhat|No|
|**Use for ML**|Yes|No|

**When to use each:**

- **PCA:** General reduction, preprocessing, fast
- **t-SNE:** Final visualization only, explore clusters

---

### **PCA vs Autoencoders:**

|Aspect|PCA|Autoencoders|
|---|---|---|
|**Type**|Linear|Non-linear|
|**Method**|Eigendecomposition|Neural network|
|**Training**|Fast (closed-form)|Slow (iterative)|
|**Flexibility**|Linear only|Any complexity|
|**Data needed**|Less|More|
|**Interpretability**|Medium|Low|

---

## COMMON ISSUES AND SOLUTIONS

### **Issue 1: Forgot to Standardize**

**Problem:**

```python
# ❌ WRONG
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X)  # Not scaled!

# Feature with large variance dominates
# Other features ignored
```

**Solution:**

```python
# ✓ CORRECT
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_scaled)
```

---

### **Issue 2: Applied to Test Data Incorrectly**

**Problem:**

```python
# ❌ WRONG - Data leakage
X_scaled = scaler.fit_transform(X)  # Uses test data!
X_train, X_test = train_test_split(X_scaled)
X_train_pca = pca.fit_transform(X_train)
X_test_pca = pca.transform(X_test)
```

**Solution:**

```python
# ✓ CORRECT
X_train, X_test = train_test_split(X)

# Fit on train only
X_train_scaled = scaler.fit_transform(X_train)
X_train_pca = pca.fit_transform(X_train_scaled)

# Transform test with same scaler/pca
X_test_scaled = scaler.transform(X_test)
X_test_pca = pca.transform(X_test_scaled)
```

---

### **Issue 3: Too Many/Few Components**

**Problem:**

```python
# Too many: No reduction
pca = PCA(n_components=100)  # Original has 105 features

# Too few: Lost information
pca = PCA(n_components=2)  # Keeps only 30% variance
```

**Solution:**

```python
# Use variance threshold
pca = PCA(n_components=0.95)  # Keep 95% variance
pca.fit(X_scaled)
print(f"Components: {pca.n_components_}")  # Auto-selected

# Or analyze scree plot and decide
```

---

### **Issue 4: Using PCA with Categorical Data**

**Problem:**

```python
# Data: [age, income, gender, color, country]
# PCA on categorical features makes no sense!
```

**Solution:**

```python
# Option 1: Encode then PCA
X_encoded = pd.get_dummies(X)
X_scaled = scaler.fit_transform(X_encoded)
X_pca = pca.fit_transform(X_scaled)

# Option 2: PCA only on numerical
numerical_cols = ['age', 'income']
X_numerical = X[numerical_cols]
X_scaled = scaler.fit_transform(X_numerical)
X_pca = pca.fit_transform(X_scaled)
```

---

### **Issue 5: Applying PCA When Features Independent**

**Problem:**

```python
# Features completely independent
# PCA won't help much
```

**Solution:**

```python
# Check correlation first
corr_matrix = X.corr()
print(corr_matrix)

# If low correlations, PCA may not help
# Consider feature selection instead
```

---

## VARIANTS OF PCA

### **1. Kernel PCA**

**For non-linear patterns:**

```python
from sklearn.decomposition import KernelPCA

# RBF kernel for non-linear data
kpca = KernelPCA(n_components=2, kernel='rbf', gamma=0.1)
X_kpca = kpca.fit_transform(X_scaled)
```

**Kernels:** 'linear', 'poly', 'rbf', 'sigmoid', 'cosine'

---

### **2. Sparse PCA**

**For interpretable components:**

```python
from sklearn.decomposition import SparsePCA

# Sparse loadings (many zeros)
spca = SparsePCA(n_components=10, alpha=0.1)
X_spca = spca.fit_transform(X_scaled)

# Easier to interpret (fewer non-zero loadings)
```

---

### **3. Incremental PCA**

**For large datasets (out-of-core):**

```python
from sklearn.decomposition import IncrementalPCA

# Process data in batches
ipca = IncrementalPCA(n_components=10, batch_size=1000)

# Fit in batches
for batch in data_batches:
    ipca.partial_fit(batch)

X_ipca = ipca.transform(X_scaled)
```

---

## BEST PRACTICES

1. **Always standardize features**
    - Use StandardScaler