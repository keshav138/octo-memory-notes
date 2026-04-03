# 📘 Feature Engineering (Machine Learning Preprocessing)

Feature Engineering is the process of creating, modifying, or selecting features to improve model performance.  
It helps the model learn patterns more effectively by giving it better input data.

This file covers:

1. Feature Selection  
2. Feature Extraction  
3. Polynomial Features  
4. Interaction Features  

For each:  
✔️ What it is  
✔️ When to use  
✔️ Why it matters  
✔️ How it works  
✔️ Code examples  
✔️ Best practices  

---

# 🧩 1. Feature Selection

Feature Selection chooses the **most important features** and removes unnecessary ones.

---

## ✅ When to Use
- Your dataset has many columns  
- Training is slow  
- Model is overfitting  
- Some features are irrelevant or redundant  

---

## 🎯 Why It Matters
- Improves accuracy  
- Reduces noise  
- Reduces overfitting  
- Reduces computation time  
- Makes model easier to interpret  

---

## 🧠 Methods of Feature Selection

### 🔹 1. Filter Methods
Based on statistical tests:
- Correlation  
- Chi-square  
- ANOVA F-test  
- Mutual information  

### 🔹 2. Wrapper Methods
Try combinations of features:
- RFE (Recursive Feature Elimination)  
- Forward selection  
- Backward elimination  

### 🔹 3. Embedded Methods
Model selects features during training:
- Lasso Regression (L1)  
- Ridge Regression (L2)  
- RandomForest feature importance  

---

## 🧩 Code Examples

### ➤ Correlation-Based Selection
```python
df.corr()
```

### ➤ Recursive Feature Elimination (RFE)
```python
from sklearn.feature_selection import RFE
from sklearn.linear_model import LinearRegression

model = LinearRegression()
rfe = RFE(model, n_features_to_select=5)
rfe.fit(X, y)
```

### ➤ SelectKBest (Chi-square)
```python
from sklearn.feature_selection import SelectKBest, chi2

selector = SelectKBest(score_func=chi2, k=5)
X_new = selector.fit_transform(X, y)
```

---

## 📌 Best Practices
- Use **filter methods first** to remove irrelevant columns  
- Use **RFE** when dataset is small  
- Use **Lasso** when many features are suspected to be useless  

---

# 🧩 2. Feature Extraction

Feature Extraction creates **new features** from existing data by transforming it.

---

## ✅ When to Use
- High-dimensional data  
- Many correlated features  
- Want compressed representation  
- Want to remove noise  

---

## 🎯 Why It Matters
- Reduces dimensionality  
- Improves training speed  
- Helps visualization  
- Removes multicollinearity  

---

## 🧠 Methods of Feature Extraction

### 🔹 PCA (Principal Component Analysis)
Reduces dimensionality while retaining maximum variance.

### 🔹 LDA (Linear Discriminant Analysis)
Reduces dimensionality based on class separability (classification problems).

---

## 🛠️ Libraries  
- sklearn.decomposition.PCA  
- sklearn.discriminant_analysis.LinearDiscriminantAnalysis  

---

## 🧩 Code Examples

### ➤ PCA
```python
from sklearn.decomposition import PCA

pca = PCA(n_components=2)
X_pca = pca.fit_transform(X)
```

### ➤ LDA
```python
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis

lda = LDA(n_components=1)
X_lda = lda.fit_transform(X, y)
```

---

## 📌 Best Practices
- Scale data before PCA  
- PCA works best when features are correlated  
- LDA works only when target is categorical  

---

# 🧩 3. Polynomial Features

Polynomial features create **new features from existing features** using powers like:

- x²  
- x³  
- x₁ × x₂  

---

## ✅ When to Use
- Data shows **non-linear relationships**  
- Linear models are underfitting  
- You want to capture curves in the data  

---

## 🎯 Why It Matters
Linear Regression can model curved relationships when polynomial terms are added.

---

## 🧩 Code Example

```python
from sklearn.preprocessing import PolynomialFeatures

poly = PolynomialFeatures(degree=2)
X_poly = poly.fit_transform(X)
```

---

## 📌 Best Practices
- Use degree 2 or 3 (higher degrees overfit)  
- Always scale Polytechnic features  

---

# 🧩 4. Interaction Features

Interaction features multiply or combine two features:

Example:
- age × income  
- distance ÷ time  

---

## ✅ When to Use
- When two features work **together** to influence the output  
- Non-linear relationships  
- Model underfitting  

---

## 🎯 Why It Matters
- Improves model expressiveness  
- Captures relationships missed by linear models  

---

## 🧩 Code Example

```python
from sklearn.preprocessing import PolynomialFeatures

poly = PolynomialFeatures(degree=2, interaction_only=True)
X_interact = poly.fit_transform(X)
```

---

## 📌 Best Practices
- Good for linear models  
- increases dataset size → use carefully  
- Helps when domain knowledge suggests interactions  

---

# 🎉 END OF FEATURE ENGINEERING NOTES
This file covers selection, extraction, polynomial features, and interactions.

