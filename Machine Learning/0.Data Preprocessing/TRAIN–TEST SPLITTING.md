
Train–Test Split is the process of dividing your dataset into two parts:
- **Training set** → used to train the ML model  
- **Testing set** → used to evaluate the model's performance  

This is one of the most important steps in the ML workflow.

---

# 🧩 What Is Train–Test Split?

It is a method to divide the dataset:

- **Training Set (usually 70–80%)**  
Used to teach the model patterns.

- **Testing Set (usually 20–30%)**  
Used to measure accuracy on unseen data.

If you train and test on the same data → the model becomes **overfitted** and unrealistic.

---

# ✅ When to Use

Use train–test split when:
- You are preparing data for any ML model  
- You want to measure generalization performance  
- You want to avoid overfitting  
- You have a dataset that is not time-series  

---

# 🎯 Why It Matters

- Prevents models from memorizing data  
- Gives realistic performance evaluation  
- Helps detect overfitting  
- Ensures performance metrics are valid  

Without splitting your data, accuracy would be fake because the model sees the same data it was trained on.

---

# 🔁 How Train–Test Split Works Internally

The function:
```python
train_test_split(X, y, test_size=0.2)
```

1. Randomly selects 20% of data for testing  
2. Keeps 80% for training  
3. Shuffles before splitting (optional but recommended)  
4. Maintains labels and features pairing  

---

# 🛠️ Libraries Used

- **sklearn.model_selection.train_test_split**
- pandas (for data handling)

---

# 🧩 Code Examples

### ➤ Basic Train–Test Split
```python
from sklearn.model_selection import train_test_split

X = df.drop("target", axis=1)
y = df["target"]

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)
```

---

### ➤ Using 30% Test Data
```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.3
)
```

---

### ➤ Stratified Split (Classification Only)

Ensures equal class distribution in train and test sets.

```python
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)
```

---

### ➤ Train–Validation–Test Split

Convert:
- 70% training  
- 15% validation  
- 15% test  

```python
X_train, X_temp, y_train, y_temp = train_test_split(
    X, y, test_size=0.30, random_state=42
)

X_val, X_test, y_val, y_test = train_test_split(
    X_temp, y_temp, test_size=0.50, random_state=42
)
```

---

# 🔥 Choosing the Right Test Size

| Dataset Size | Recommended Test Size |
|-------------|------------------------|
| < 1,000 rows | 30% |
| 1,000–10,000 rows | 20% |
| > 10,000 rows | 10%–20% |

---

# 🚫 When NOT To Use Random Train–Test Split

### ❌ Time-series data  
You must use **chronological order**, not random splitting.

Use TimeSeriesSplit instead.

---

# 📌 Best Practices

- Keep **random_state=42** for reproducibility  
- Use **stratification** for classification  
- Do not touch test data until final evaluation  
- Fit preprocessing steps on **train only**, then transform **test**  
  - (Important to avoid data leakage)

Example:

✔️ Correct  
```python
scaler.fit(X_train)
X_train = scaler.transform(X_train)
X_test = scaler.transform(X_test)
```

❌ Wrong  
```python
scaler.fit_transform(X)
```

This would leak information.

---


