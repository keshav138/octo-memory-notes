
Data Transformation prepares the data so ML models can understand and learn from it effectively.  
This stage includes:

1. Scaling  
2. Encoding  
3. Normalization  
4. Binning  

Each transformation changes the data in a meaningful way to improve model performance.

---

# 🧩 1. Feature Scaling

Scaling means adjusting numerical features so they all exist on a similar range.  
Many ML algorithms perform poorly if features have different scales.

---

## ✅ When to Use
Use scaling when:
- Features have different ranges (e.g., age=0–100, income=0–100000)
- You’re using algorithms that depend on distance or gradient

---

## 🎯 Why It Matters
- Prevents one feature from dominating others  
- Makes gradient descent converge faster  
- Essential for distance-based algorithms  

---

## 🚨 Scaling Is **Mandatory** For:
- KNN  
- SVM  
- Logistic Regression  
- Linear Regression (gradient descent version)  
- PCA  
- Neural Networks  

---

## 🧠 Types of Scaling

### 🔹 StandardScaler (Z-score scaling)
Transforms values to mean=0, std=1  
Use when data is normally distributed.

### 🔹 MinMaxScaler (0 to 1)
Scales all values between 0 and 1  
Use when preserving original shape is important.

### 🔹 RobustScaler
Uses median & IQR  
Use when dataset contains outliers.

---

## 🛠️ Libraries
- sklearn.preprocessing.StandardScaler  
- sklearn.preprocessing.MinMaxScaler  
- sklearn.preprocessing.RobustScaler  

---

## 🧩 Code Examples

### StandardScaler
```python
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
df[['age','salary']] = scaler.fit_transform(df[['age','salary']])
```

### MinMaxScaler
```python
from sklearn.preprocessing import MinMaxScaler

scaler = MinMaxScaler()
df[['age','salary']] = scaler.fit_transform(df[['age','salary']])
```

### RobustScaler
```python
from sklearn.preprocessing import RobustScaler

scaler = RobustScaler()
df[['age','salary']] = scaler.fit_transform(df[['age','salary']])
```

---

## 📌 Best Practices
- Use StandardScaler for most algorithms  
- Use RobustScaler when outliers exist  
- Never fit scaler on test set → use train fit  
---

# 🧩 2. Encoding (Categorical → Numerical)

ML models cannot read text labels.  
Encoding converts categories to numbers.

---

## ✅ When to Use
Use encoding when:
- Your dataset has non-numerical columns like gender, city, color, product type
- The model requires numeric input (almost all models)

---

## 🎯 Why It Matters
- Models fail on string data  
- Hard to compare categories without numeric form  
- Encoding improves training stability  

---

## 🧠 Types of Encoding

### 🔹 One-Hot Encoding
Creates separate column for each category  
Use when categories are unordered (city, color, gender)

### 🔹 Label Encoding
Converts categories to 0,1,2...  
Use only when order does **not** matter OR tree models (Decision Trees, RandomForest)

### 🔹 Ordinal Encoding
You define the order  
Use when categories have ranking (small < medium < large)

### 🔹 Target Encoding (Advanced)
Replaces category with mean of target  
Use for high-cardinality features (many categories)

---

## 🛠️ Libraries
- pandas.get_dummies  
- sklearn.preprocessing.OneHotEncoder  
- sklearn.preprocessing.LabelEncoder  
- category_encoders (for Target Encoding)  

---

## 🧩 Code Examples

### One-Hot Encoding
```python
df = pd.get_dummies(df, columns=['city'], drop_first=True)
```

### Label Encoding
```python
from sklearn.preprocessing import LabelEncoder

le = LabelEncoder()
df['gender'] = le.fit_transform(df['gender'])
```

### Ordinal Encoding
```python
from sklearn.preprocessing import OrdinalEncoder

encoder = OrdinalEncoder(categories=[['Small','Medium','Large']])
df['size'] = encoder.fit_transform(df[['size']])
```

---

## 📌 Best Practices
- Use **one-hot** for unordered categories  
- Use **label encoding** for tree-based models  
- Use **ordinal** only when categories have true order  
---

# 🧩 3. Normalization (Values → 0–1 Range)

Normalization rescales values to a 0–1 range.  
Important when direction matters more than magnitude.

---

## ✅ When to Use
Use normalization when:
- Data has huge ranges  
- Distance-based models like KNN, K-Means  
- Neural networks (sigmoid/tanh assume 0–1 input range)

---

## 🎯 Why It Matters
- Keeps values consistent  
- Prevents gradients from exploding  
- Improves neural network convergence  

---

## 🛠️ Libraries
- sklearn.preprocessing.Normalizer  

---

## 🧩 Code Example

```python
from sklearn.preprocessing import Normalizer

norm = Normalizer()
df[['col1','col2','col3']] = norm.fit_transform(df[['col1','col2','col3']])
```

---

## 📌 Best Practices
- Use Normalizer mainly for models relying on vector direction  
- Not the same as MinMaxScaler  
---

# 🧩 4. Binning (Discretization)

Binning means converting continuous values into bins or ranges.

---

## ✅ When to Use
Use binning when:
- Data is noisy  
- You want to convert numbers into groups  
- Model needs stability  
- Useful for tree-based models & EDA  

---

## 🎯 Why It Matters
- Reduces impact of small variations  
- Simplifies patterns  
- Good for capturing non-linear relationships  

---

## 🧠 Types of Binning

### 🔹 Equal Width Binning
Same width for each bin  
Example: 0–20, 20–40, 40–60

### 🔹 Equal Frequency Binning
Each bin has same number of values  

---

## 🛠️ Libraries
- pandas.cut  
- pandas.qcut  

---

## 🧩 Code Examples

### Equal Width Bins
```python
df['age_bin'] = pd.cut(df['age'], bins=4)
```

### Equal Frequency Bins
```python
df['age_bin'] = pd.qcut(df['age'], q=4)
```

---

## 📌 Best Practices
- Use qcut when distribution is skewed  
- Avoid too many bins → model becomes noisy  
- Use binning carefully for continuous ML features  

---

