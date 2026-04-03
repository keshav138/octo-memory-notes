# **Machine Learning Metrics Explained**

## **1. REGRESSION METRICS** (Predicting continuous values)

### **Mean Absolute Error (MAE)**
```python
from sklearn.metrics import mean_absolute_error
mae = mean_absolute_error(y_true, y_pred)
```
**What it measures:** Average absolute difference between predictions and actual values  
**Range:** 0 to ∞ (lower is better)  
**Interpretation:** "On average, predictions are off by MAE units"  
**Example:** If MAE = 5, predictions are off by 5 units on average

### **Mean Squared Error (MSE)**
```python
from sklearn.metrics import mean_squared_error
mse = mean_squared_error(y_true, y_pred)
```
**What it measures:** Average squared difference (penalizes large errors more)  
**Range:** 0 to ∞ (lower is better)  
**Use:** When large errors are particularly bad

### **Root Mean Squared Error (RMSE)**
```python
rmse = np.sqrt(mse)
```
**What it measures:** Square root of MSE (back to original units)  
**Interpretation:** Similar to MAE but gives more weight to large errors

### **R² Score (Coefficient of Determination)**
```python
from sklearn.metrics import r2_score
r2 = r2_score(y_true, y_pred)
```
**What it measures:** Proportion of variance explained by model  
**Range:** -∞ to 1 (1 = perfect fit, 0 = baseline mean model, negative = worse than mean)  
**Interpretation:** "Model explains R²% of variance in target"

### **Mean Absolute Percentage Error (MAPE)**
```python
mape = np.mean(np.abs((y_true - y_pred) / y_true)) * 100
```
**What it measures:** Average percentage error  
**Range:** 0% to ∞% (lower is better)  
**Use:** When relative error matters more than absolute

---

## **2. CLASSIFICATION METRICS** (Predicting categories)

### **Confusion Matrix**
```
              Predicted
              Class 0   Class 1
Actual Class0 [ TN       FP ]
Actual Class1 [ FN       TP ]
```
**Terms:**
- **TP (True Positive):** Correctly predicted positive
- **TN (True Negative):** Correctly predicted negative  
- **FP (False Positive):** Wrongly predicted positive (Type I error)
- **FN (False Negative):** Wrongly predicted negative (Type II error)

### **Accuracy**
```python
accuracy = (TP + TN) / (TP + TN + FP + FN)
```
**What it measures:** Overall correct prediction rate  
**Problem:** Misleading with imbalanced classes

### **Precision**
```python
precision = TP / (TP + FP)
```
**What it measures:** "How many selected items are relevant?"  
**Use:** When false positives are costly (e.g., spam detection)

### **Recall (Sensitivity)**
```python
recall = TP / (TP + FN)
```
**What it measures:** "How many relevant items are selected?"  
**Use:** When false negatives are costly (e.g., disease detection)

### **F1-Score**
```python
f1 = 2 * (precision * recall) / (precision + recall)
```
**What it measures:** Harmonic mean of precision and recall  
**Use:** When you need balance between precision and recall

### **ROC-AUC Score**
```python
from sklearn.metrics import roc_auc_score
roc_auc = roc_auc_score(y_true, y_proba)
```
**What it measures:** Ability to distinguish between classes  
**Range:** 0 to 1 (0.5 = random, 1 = perfect)  
**Interpretation:** "Probability that model ranks random positive higher than random negative"

### **Log Loss (Cross-Entropy)**
```python
from sklearn.metrics import log_loss
logloss = log_loss(y_true, y_proba)
```
**What it measures:** How close predicted probabilities are to actual labels  
**Range:** 0 to ∞ (lower is better)  
**Use:** When probability confidence matters

---

## **3. CLUSTERING METRICS** (Grouping similar items)

### **Silhouette Score**
```python
from sklearn.metrics import silhouette_score
score = silhouette_score(X, labels)
```
**What it measures:** How similar points are to their own cluster vs other clusters  
**Range:** -1 to 1 (higher is better)  
**Interpretation:**
- 1: Perfect clustering
- 0: Overlapping clusters  
- -1: Wrong clustering

### **Davies-Bouldin Index**
```python
from sklearn.metrics import davies_bouldin_score
db = davies_bouldin_score(X, labels)
```
**What it measures:** Average similarity between each cluster and its most similar cluster  
**Range:** 0 to ∞ (lower is better)  
**Use:** When clusters should be well-separated

### **Inertia (Within-Cluster Sum of Squares)**
```python
inertia = kmeans.inertia_
```
**What it measures:** Sum of squared distances to cluster centers  
**Range:** 0 to ∞ (lower is better)  
**Use:** For K-Means elbow method

### **Calinski-Harabasz Index**
```python
from sklearn.metrics import calinski_harabasz_score
ch = calinski_harabasz_score(X, labels)
```
**What it measures:** Ratio of between-cluster to within-cluster dispersion  
**Range:** Higher is better  
**Use:** For comparing different clusterings

---

## **4. ASSOCIATION RULES METRICS** (Market Basket Analysis)

### **Support**
```python
support(A → B) = P(A ∪ B)
```
**What it measures:** How frequently itemset appears in transactions  
**Example:** Support(milk, bread) = 0.15 means 15% of transactions contain both

### **Confidence**
```python
confidence(A → B) = P(B|A) = support(A ∪ B) / support(A)
```
**What it measures:** How often B is bought when A is bought  
**Example:** Confidence(milk → bread) = 0.8 means 80% of milk buyers also buy bread

### **Lift**
```python
lift(A → B) = confidence(A → B) / support(B)
```
**What it measures:** How much more likely B is bought when A is bought  
**Interpretation:**
- Lift = 1: A and B are independent  
- Lift > 1: Positive correlation  
- Lift < 1: Negative correlation

### **Conviction**
```python
conviction(A → B) = (1 - support(B)) / (1 - confidence(A → B))
```
**What it measures:** How often rule would be wrong if items were independent  
**Range:** 1 to ∞ (higher = stronger association)

### **Leverage**
```python
leverage(A → B) = support(A ∪ B) - (support(A) × support(B))
```
**What it measures:** Difference between observed and expected co-occurrence

---

## **QUICK REFERENCE TABLE:**

| **Task** | **Key Metrics** | **When to Use** |
|----------|----------------|-----------------|
| **Regression** | MAE, RMSE, R² | Predicting prices, sales, temperatures |
| **Binary Classification** | Accuracy, Precision, Recall, F1, ROC-AUC | Spam detection, disease diagnosis |
| **Multi-class Classification** | Accuracy, F1-macro, F1-weighted | Handwriting recognition, image classification |
| **Clustering** | Silhouette, Davies-Bouldin, Inertia | Customer segmentation, document grouping |
| **Association Rules** | Support, Confidence, Lift | Market basket analysis, recommendation systems |

## **GOLDEN RULES:**
1. **Regression:** Use RMSE when large errors are dangerous, MAE otherwise
2. **Classification:** Use F1 for imbalanced data, Accuracy for balanced
3. **Clustering:** Use Silhouette for density-based, Inertia for K-Means
4. **Association:** Support filters rare rules, Confidence measures rule strength