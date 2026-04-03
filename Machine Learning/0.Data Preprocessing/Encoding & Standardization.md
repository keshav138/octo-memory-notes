## STANDARDIZATION (FEATURE SCALING)

`Definition:` The process of transforming features to a similar scale to ensure that no single feature dominates the model due to its magnitude. Makes features comparable and improves algorithm performance.

`Used For:`

- Preprocessing data before machine learning
- Improving convergence speed of gradient-based algorithms
- Ensuring fair feature importance in distance-based algorithms
- Meeting algorithm assumptions

`Cases of Application:`

- Before using algorithms sensitive to feature scale: neural networks, SVM, KNN, K-means clustering
- When features have different units (age in years, salary in dollars)
- Before applying regularization (L1/L2)
- Principal Component Analysis (PCA)
- Gradient descent optimization

`Prerequisites:`

- Numerical features (continuous or discrete)
- Understanding of data distribution
- Fit scaler on training data only, then transform both train and test
- Handle missing values before scaling

`Performance Measures:`

- Verify mean and standard deviation after transformation
- Check for data leakage (scaler fitted only on training data)
- Compare model performance before/after scaling
- Visual inspection of distributions

---

## STANDARD SCALER (Z-SCORE NORMALIZATION)

`Definition:` Transforms features to have mean = 0 and standard deviation = 1 using the formula: X_scaled = (X - μ) / σ, where μ is the mean and σ is the standard deviation.

`Used For:`

- When features follow approximately normal (Gaussian) distribution
- When you want to preserve the shape of the distribution
- When outliers should maintain relative positions
- Most general-purpose standardization method

`Cases of Application:`

- Neural networks and deep learning
- Support Vector Machines (SVM)
- Logistic regression with regularization
- Linear regression with regularization (Ridge, Lasso)
- Principal Component Analysis (PCA)
- K-Nearest Neighbors (KNN)

`Prerequisites:`

- Numerical continuous features
- Data should ideally be normally distributed (though not strictly required)
- No extreme outliers (can skew mean and std)
- Features should not be bounded (if bounded, consider MinMaxScaler)
- Fit only on training data to prevent data leakage

`Performance Measures:`

- After transformation: mean ≈ 0, std = 1
- Check for outliers affecting transformation
- Verify no data leakage occurred
- Compare model convergence speed and accuracy
- Range: typically [-3, 3] for normal data, but unbounded

`Mathematical Properties:`

- Preserves the shape of original distribution
- Outliers remain outliers (not compressed)
- Negative values preserved
- Not bounded to specific range

`Example:`

```
Original data: [10, 20, 30, 40, 50]
Mean (μ) = 30, Std (σ) = 14.14
Scaled: [-1.41, -0.71, 0, 0.71, 1.41]
```

---

## MIN-MAX SCALER (NORMALIZATION)

`Definition:` Transforms features to a fixed range, typically [0, 1], using the formula: X_scaled = (X - X_min) / (X_max - X_min). Alternative range [a, b]: X_scaled = a + (X - X_min)(b - a) / (X_max - X_min).

`Used For:`

- When you need features in a specific bounded range
- When data doesn't follow normal distribution
- When zero means something important in your context
- Image processing (pixel values)
- Neural networks with bounded activation functions

`Cases of Application:`

- Neural networks (especially with sigmoid/tanh activation)
- Image processing and computer vision
- Algorithms requiring features in [0, 1] range
- When interpreting feature importance by magnitude
- K-Nearest Neighbors
- Gradient descent optimization

`Prerequisites:`

- Numerical features
- Known or stable min and max values
- Sensitive to outliers (outliers become 0 or 1)
- Fit only on training data
- Consider outlier handling before scaling

`Performance Measures:`

- After transformation: values in [0, 1] or specified range
- Verify min = 0, max = 1 (or chosen bounds)
- Check if outliers compressed the main distribution
- Assess impact on model performance
- Monitor for data leakage

`Mathematical Properties:`

- Bounded to specific range [0, 1]
- Very sensitive to outliers
- Preserves zero values when min = 0
- Distribution shape changes if outliers present
- All values positive (in [0, 1] range)

`Example:`

```
Original data: [10, 20, 30, 40, 50]
Min = 10, Max = 50
Scaled: [0, 0.25, 0.5, 0.75, 1.0]
```

`Outlier Impact Example:`

```
Original data: [10, 20, 30, 40, 500]  # 500 is outlier
Scaled: [0, 0.02, 0.04, 0.06, 1.0]    # Main data compressed
```

---

## STANDARD SCALER vs MIN-MAX SCALER COMPARISON

|Aspect|Standard Scaler|Min-Max Scaler|
|---|---|---|
|`Range`|Unbounded (typically -3 to 3)|Bounded [0, 1] or custom|
|`Outlier Sensitivity`|Less sensitive|Highly sensitive|
|`Distribution`|Preserves shape|Can distort if outliers present|
|`Use When`|Normal distribution, outliers present|Need bounded range, no outliers|
|`Mean/Median`|Centers at 0|Not centered|
|`Best For`|Linear models, SVM, PCA|Neural nets, image data, KNN|

`Decision Guide:`

- Use `Standard Scaler` when: features are normally distributed, outliers exist, unbounded range acceptable
- Use `Min-Max Scaler` when: need specific range [0,1], no outliers, working with bounded data like images

---

## ENCODING CATEGORICAL VARIABLES

`Definition:` The process of converting categorical (non-numerical) data into numerical format that machine learning algorithms can process. Required because most ML algorithms only accept numerical input.

`Used For:`

- Preprocessing categorical features
- Preparing text labels for models
- Converting qualitative data to quantitative

`Cases of Application:`

- Any dataset with categorical features (gender, country, color, category)
- Text classification (sentiment labels: positive/negative)
- Customer segmentation (income bracket, education level)
- Product categorization

`Prerequisites:`

- Identified categorical variables
- Understanding of relationship between categories
- Decision on encoding method based on:
    - Ordinal vs nominal data
    - Number of unique categories
    - Model requirements

`Performance Measures:`

- Verify no information loss
- Check dimensionality (One-Hot increases features)
- Monitor model performance
- Validate no unintended ordering introduced

---

## ONE-HOT ENCODING

`Definition:` Creates binary (0/1) columns for each unique category. Each observation has 1 in the column of its category and 0 in all others. Creates k columns for k categories (or k-1 to avoid multicollinearity).

`Used For:`

- Nominal categorical variables (no inherent order)
- When categories are independent and equal
- Tree-based algorithms (handle it well)
- Neural networks

`Cases of Application:`

- Color: [Red, Blue, Green] → 3 binary columns
- Country: [USA, India, Germany, France]
- Product category: [Electronics, Clothing, Food]
- Payment method: [Credit Card, Debit Card, PayPal, Cash]
- Day of week: [Monday, Tuesday, ..., Sunday]

`Prerequisites:`

- Nominal categorical variable (no ordering)
- Manageable number of categories (avoid high cardinality)
- Sufficient data for each category
- Consider dropping one column to avoid dummy variable trap in linear models

`Performance Measures:`

- Number of new features = k or k-1 categories
- Check for sparse matrix (many zeros)
- Verify each row has exactly one '1' across category columns
- Monitor dimensionality increase
- Assess impact on model interpretability

`Mathematical Properties:`

- Creates orthogonal features (no correlation between encoding columns)
- No ordinal relationship implied
- Increases feature space significantly
- Can cause curse of dimensionality with high cardinality

`Example:`

```
Original:     Color
              Red
              Blue
              Green
              Red

One-Hot:      Color_Red  Color_Blue  Color_Green
              1          0           0
              0          1           0
              0          0           1
              1          0           0

Or (k-1):     Color_Blue  Color_Green
              0           0
              1           0
              0           1
              0           0
```

`Advantages:`

- No assumption of order
- Works with any ML algorithm
- Preserves all category information
- Interpretable results

`Disadvantages:`

- High dimensionality with many categories
- Sparse matrices (memory intensive)
- Dummy variable trap in linear models (need to drop one)
- Not suitable for high cardinality features (1000+ categories)

---

## LABEL ENCODING

`Definition:` Assigns a unique integer to each category. Converts categorical values to numerical labels: 0, 1, 2, 3, ..., k-1 for k categories. Simple integer mapping.

`Used For:`

- Ordinal categorical variables (natural order exists)
- Target variable encoding in classification
- Tree-based algorithms (can handle it well)
- Reducing dimensionality compared to one-hot

`Cases of Application:`

- Ordinal: Education level [High School=0, Bachelor=1, Master=2, PhD=3]
- Ordinal: Size [Small=0, Medium=1, Large=2]
- Ordinal: Rating [Poor=0, Fair=1, Good=2, Excellent=3]
- Target variable: [Cat=0, Dog=1, Bird=2]
- Tree-based models: any categorical feature

`Prerequisites:`

- Understand whether ordering matters
- For ordinal data: ensure encoding reflects natural order
- For nominal data: only use with tree-based algorithms
- Consistent encoding across train and test sets
- Handle unseen categories in test data

`Performance Measures:`

- Verify correct mapping (especially for ordinal)
- Check for unintended ordinal relationships
- Ensure no missing categories
- Monitor model interpretation
- Values range: [0, k-1] for k categories

`Mathematical Properties:`

- Creates single numerical column
- Implies ordinal relationship (potential issue)
- Compact representation
- Sequential integers

`Example:`

```
Ordinal (Education):
Original:         Encoded:
High School       0
Bachelor's        1
Master's          2
PhD               3

Nominal (Color) - PROBLEMATIC:
Original:         Encoded:
Red               0
Blue              1
Green             2
# Implies Red < Blue < Green (incorrect!)
```

`Advantages:`

- Memory efficient (single column)
- Simple and fast
- Works well for ordinal data
- Required for target variables
- Tree-based algorithms handle well

`Disadvantages:`

- Introduces artificial ordering for nominal data
- Linear models misinterpret as continuous
- Magnitude differences have no meaning for nominal data
- Can hurt model performance if used incorrectly

---

## ONE-HOT vs LABEL ENCODING COMPARISON

| Aspect                  | One-Hot Encoding           | Label Encoding              |
| ----------------------- | -------------------------- | --------------------------- |
| `Output`                | k binary columns           | 1 integer column            |
| `Best For`              | Nominal categories         | Ordinal categories, targets |
| `Dimensionality`        | High (k columns)           | Low (1 column)              |
| `Ordering Implied`      | No                         | Yes                         |
| `Algorithm Suitability` | Linear models, neural nets | Tree-based, targets         |
| `Memory Usage`          | High                       | Low                         |
| `Cardinality Limit`     | Low-medium (<50)           | High (1000+)                |

`Decision Guide:`

- Use `One-Hot Encoding` for:
    
    - Nominal categories (no order)
    - Linear models, SVM, neural networks
    - Low to medium cardinality (<50 categories)
    - When you want to avoid artificial ordering
- Use `Label Encoding` for:
    
    - Ordinal categories (natural order)
    - Tree-based models (Random Forest, XGBoost)
    - Target variables
    - High cardinality features (efficiency needed)
    - When dimensionality is a concern

---

## ADVANCED ENCODING TECHNIQUES (Brief Overview)

`Ordinal Encoding:`

- Similar to label encoding but explicitly maintains order
- Used for ordinal data with custom mapping
- Example: {Small: 1, Medium: 2, Large: 3}

`Target/Mean Encoding:`

- Replaces category with target variable mean for that category
- Risk of data leakage and overfitting
- Used in competitive machine learning

`Binary Encoding:`

- Converts categories to binary code
- More compact than one-hot, less than label
- Useful for high cardinality

`Frequency Encoding:`

- Replaces category with its frequency/count
- Simple but can lose category information

`Hash Encoding:`

- Uses hash function to map categories to fixed number of columns
- Handles high cardinality and unseen categories

---

## PRACTICAL WORKFLOW

`Standardization Process:`

```
1. Split data (train/test)
2. Fit scaler on training data ONLY
3. Transform training data
4. Transform test data using same scaler
5. Train model
6. Never fit scaler on test data (causes leakage)
```

`Encoding Process:`

```
1. Identify categorical variables
2. Determine if ordinal or nominal
3. Choose encoding method:
   - Nominal → One-Hot
   - Ordinal → Label/Ordinal
   - Target → Label
4. Handle unseen categories in test set
5. Apply consistently across train/test
```

`Common Pitfalls:`

- Fitting scaler on test data (data leakage)
- Using label encoding for nominal data with linear models
- Not handling unseen categories in test set
- Creating dummy variable trap in linear regression
- Forgetting to scale test data