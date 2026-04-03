# 📘 Cross-Validation (CV)

Cross-Validation is an advanced model evaluation technique used to check how a model performs on **multiple subsets** of the dataset. Instead of a single train–test split, CV splits the data into many folds and trains/evaluates the model repeatedly.

This gives a more **reliable, stable, and unbiased estimate** of model performance.

---

# 🧩 What Is Cross-Validation?

Cross-Validation splits the dataset into **K folds** (commonly 5 or 10).  
The model is trained on (K–1) folds and tested on the remaining fold.  
This process repeats **K times**, and the average score is computed.

Example with K=5:
- Train on folds: 1,2,3,4 → Test on 5  
- Train on folds: 1,2,3,5 → Test on 4  
- Train on folds: 1,2,4,5 → Test on 3  
- Train on folds: 1,3,4,5 → Test on 2  
- Train on folds: 2,3,4,5 → Test on 1  

---

# 🎯 Why Cross-Validation Is Important

- More stable performance estimation  
- Reduces risk of overfitting  
- Uses full dataset more effectively  
- Better for small datasets  
- Helps compare multiple ML models fairly  

A single train–test split can be misleading — CV gives a **truer score**.

---

# 🧠 Types of Cross-Validation

## 1️⃣ **K-Fold Cross Validation** (most common)
- Divides data into **K folds**  
- Repeats training/testing **K times**  

Use when data is not imbalanced and not time-series.

---

## 2️⃣ **Stratified K-Fold** (for Classification)
Ensures **equal class distribution** in each fold.

Use when:
- Dataset is imbalanced  
- Classification problem (binary or multi-class)

---

## 3️⃣ **Repeated K-Fold**
Runs K-Fold multiple times → more robust.

Use when:
- Dataset is small  
- You want very stable performance  

---

## 4️⃣ **Leave-One-Out CV (LOOCV)**
Each fold contains **only 1 sample**.

Use when:
- Dataset is extremely small (< 100 rows)

Very computationally expensive.

---

## 5️⃣ **TimeSeriesSplit** (for time-series data)
No random shuffling — preserves chronological order.

Use when:
- Dataset contains timestamps  
- Data must respect time order (stock prices, sensors)

---

# 🛠️ Python Libraries
- `sklearn.model_selection.KFold`  
- `sklearn.model_selection.StratifiedKFold`  
- `sklearn.model_selection.cross_val_score`  
- `sklearn.model_selection.TimeSeriesSplit`  

---

# 🧩 Code Examples

## ➤ Basic K-Fold CV
```python
from sklearn.model_selection import KFold, cross_val_score
from sklearn.linear_model import LinearRegression

X = df.drop("target", axis=1)
y = df["target"]

kfold = KFold(n_splits=5, shuffle=True, random_state=42)

model = LinearRegression()
scores = cross_val_score(model, X, y, cv=kfold)

print(scores)
print(scores.mean())
```

---

## ➤ Stratified K-Fold (Classification)
```python
from sklearn.model_selection import StratifiedKFold, cross_val_score
from sklearn.svm import SVC

skf = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)

model = SVC()
scores = cross_val_score(model, X, y, cv=skf)

print(scores.mean())
```

---

## ➤ TimeSeriesSplit
```python
from sklearn.model_selection import TimeSeriesSplit, cross_val_score
from sklearn.linear_model import LinearRegression

tscv = TimeSeriesSplit(n_splits=5)

model = LinearRegression()
scores = cross_val_score(model, X, y, cv=tscv)

print(scores)
```

---

# 🔥 When To Use What

| Scenario | Use This |
|---------|----------|
| Normal dataset | K-Fold |
| Classification with imbalance | Stratified K-Fold |
| Very small dataset | LOOCV |
| Want extra robust score | Repeated K-Fold |
| Time-series | TimeSeriesSplit |

---

# 🚫 When NOT to Use Cross-Validation

- When dataset is extremely large → takes too long  
- When deep learning models are used → expensive to retrain  
- When using time-series → must use TimeSeriesSplit, NOT normal K-Fold  

---

# 📌 Best Practices

- Use **5 or 10 folds**  
- Always enable **shuffle=True** (except time-series)  
- Combine CV with **GridSearchCV** for tuning  
- CV gives more reliable model selection  

---

# 🎉 END OF CROSS-VALIDATION NOTES
This file includes every CV concept, usage rule, code, and when-to-use guidance.

