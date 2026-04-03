
Data Cleaning is the first and most important step of preprocessing. The goal is to fix issues in the raw dataset so that machine learning models can work properly.  
This file covers all components of data cleaning:

1. Missing Values  
2. Outliers  
3. Duplicates  
4. Wrong Data Types  

Each section includes:  
• What it is  
• When to use  
• Why it matters  
• How it works  
• Libraries  
• Coding examples  
• Best practices  

---

# 🧩 1. Missing Values

Missing values occur when some entries in the dataset have no recorded value. ML models cannot handle missing data directly.

---

## ✅ When to Use
Use missing value treatment when:
- A column contains NaN, null, blank values.
- Dataset is collected from surveys, sensors, logs.
- Model throws errors due to incomplete rows.

---

## 🎯 Why It Matters
- Algorithms like SVM, KNN, Logistic Regression cannot train on NaNs.
- Missing data reduces accuracy.
- Distorts mean, variance, correlations.
- Causes biased model outputs.

---

## 🧠 How to Handle Missing Values

### 🔹 Numerical Columns
- **Mean Imputation** → use when distribution is normal  
- **Median Imputation** → use when outliers exist  
- **KNN Imputation** → uses similar rows to fill values  

### 🔹 Categorical Columns
- **Mode Imputation** → "most frequent" category  
- **"Unknown" category"** → for heavy missing categorical data  

---

## 🛠️ Libraries
- pandas  
- sklearn.impute.SimpleImputer  
- sklearn.impute.KNNImputer  

---

## 🧩 Code Examples

### ➤ Check missing values
```python
df.isnull().sum()
```

### ➤ Numerical: Mean
```python
from sklearn.impute import SimpleImputer

imputer = SimpleImputer(strategy='mean')
df['age'] = imputer.fit_transform(df[['age']])
```

### ➤ Categorical: Mode
```python
imputer = SimpleImputer(strategy='most_frequent')
df['gender'] = imputer.fit_transform(df[['gender']])
```

### ➤ KNN Imputer
```python
from sklearn.impute import KNNImputer

knn = KNNImputer(n_neighbors=3)
df[['age','salary']] = knn.fit_transform(df[['age','salary']])
```

---

## 📌 Best Practices
- Use **median** for skewed data.  
- Avoid dropping rows unless missing > 50%.  
- Never impute test data separately → always use `fit` on train, `transform` on test.  

---

# 🧩 2. Outliers

Outliers are values far away from the rest of the observations. They can ruin many ML models.

---

## ✅ When to Use
Use outlier detection when:
- Data shows extreme values.
- Regression line looks unstable.
- Boxplot shows long whiskers.
- Standard deviation is unexpectedly high.

---

## 🎯 Why It Matters
- Distorts mean, variance.
- Hurts regression model accuracy.
- Breaks algorithms based on distance (KNN, SVM).
- Degrades gradient descent performance.

---

## 🧠 Outlier Detection Methods

### 🔹 1. Z-Score
- Marks values beyond ±3 standard deviations.

### 🔹 2. IQR Method
Outlier = value outside range:  
`[Q1 - 1.5*IQR , Q3 + 1.5*IQR]`

### 🔹 3. Isolation Forest
- Tree-based anomaly detection method.

---

## 🛠️ Libraries
- pandas  
- numpy  
- scipy.stats  
- sklearn.ensemble.IsolationForest  

---

## 🧩 Code Examples

### ➤ IQR Method
```python
Q1 = df['salary'].quantile(0.25)
Q3 = df['salary'].quantile(0.75)
IQR = Q3 - Q1

df_clean = df[(df['salary'] > Q1 - 1.5*IQR) &
              (df['salary'] < Q3 + 1.5*IQR)]
```

### ➤ Z-score
```python
from scipy import stats

df['z'] = abs(stats.zscore(df['salary']))
df_clean = df[df['z'] < 3]
```

### ➤ Isolation Forest
```python
from sklearn.ensemble import IsolationForest

iso = IsolationForest(contamination=0.02)
df['outlier'] = iso.fit_predict(df[['salary']])

df_clean = df[df['outlier'] == 1]
```

---

## 📌 Best Practices
- Use **IQR** for skewed data.  
- Use **Z-score** for normally distributed data.  
- Use **Isolation Forest** for advanced anomaly detection.  
- Never remove outliers blindly → understand the domain.  

---

# 🧩 3. Duplicates

Duplicates are repeated rows in the dataset that should not be counted twice.

---

## ✅ When to Use
Use duplicate removal when:
- Data was merged from multiple sources.
- Data contains logs/transactions.
- Multiple identical entries appear.

---

## 🎯 Why It Matters
- Increases dataset size unnecessarily.
- Causes model bias (repeated info).
- Affects distribution.
- Slows training.

---

## 🧠 How to Handle Duplicates
- Remove duplicate rows.
- Check duplicates on specific columns.

---

## 🛠️ Libraries
- pandas

---

## 🧩 Code Examples

### ➤ Find duplicates
```python
df.duplicated().sum()
```

### ➤ Remove all duplicates
```python
df = df.drop_duplicates()
```

### ➤ Remove duplicates based on specific columns
```python
df = df.drop_duplicates(subset=['email'])
```

---

## 📌 Best Practices
- Always check duplicates before analysis.  
- In time-series data → duplicates might be valid (be careful).  

---

# 🧩 4. Wrong Data Types

Wrong data types occur when values are stored incorrectly (e.g., numbers stored as strings).

---

## ✅ When to Use
Use data type correction when:
- Numbers appear as `"25"` instead of `25`
- Categories are stored as integers or floats
- Dates are stored as plain text

---

## 🎯 Why It Matters
- Scaling fails  
- Encoding fails  
- Mathematical operations break  
- ML models throw errors  

---

## 🧠 How to Fix Data Types

### 🔹 Convert type of a column
- string → int  
- string → float  
- string → datetime  
- int → category  

---

## 🛠️ Libraries
- pandas

---

## 🧩 Code Examples

### ➤ Convert to int
```python
df['age'] = df['age'].astype(int)
```

### ➤ Convert to float
```python
df['salary'] = df['salary'].astype(float)
```

### ➤ Convert to string
```python
df['city'] = df['city'].astype(str)
```

### ➤ Convert to datetime
```python
df['date'] = pd.to_datetime(df['date'])
```

---

## 📌 Best Practices
- Always inspect data types using:
```python
df.info()
```
- Fix data types before encoding or scaling.  
- Convert dates early and extract useful components (year/month).  

---



