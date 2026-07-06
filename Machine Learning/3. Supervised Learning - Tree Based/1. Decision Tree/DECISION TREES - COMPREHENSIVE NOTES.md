## DECISION TREES

https://www.youtube.com/watch?v=coOTEc-0OGw&list=PL4gu8xQu0_5K858LBik5BQfDVutvawEFU&index=1

**Definition:** A supervised learning algorithm that creates a tree-like model of decisions and their possible consequences. It splits the data into subsets based on feature values, creating a hierarchical structure of if-then-else decision rules. Each internal node represents a test on a feature, each branch represents the outcome of that test, and each leaf node represents a class label (classification) or continuous value (regression).

**Used For:**

- Classification problems (categorical output)
- Regression problems (continuous output)
- Feature importance analysis
- Rule extraction and interpretation
- Data exploration and understanding
- Creating ensemble models (Random Forests, Gradient Boosting)

**Cases of Application:**

- Medical diagnosis (disease classification based on symptoms)
- Credit scoring and loan approval
- Customer churn prediction
- Fraud detection
- Product recommendation
- Manufacturing quality control
- Species classification in biology
- Email spam filtering
- Employee attrition prediction
- Risk assessment in insurance

**Prerequisites:**

- Labeled training data
- Features can be categorical or numerical
- Handle missing values before training (or use algorithm that handles them)
- No feature scaling required (scale-invariant)
- Consider pruning for better generalization
- Sufficient data to avoid overfitting
- Balance between tree depth and performance

**Performance Measures:**

- **Classification:** Accuracy, Precision, Recall, F1-Score, Confusion Matrix, ROC-AUC, Log Loss
- **Regression:** MAE, MSE, RMSE, R² Score
- **Tree-specific:** Tree depth, number of leaves, number of nodes
- Cross-validation scores
- Feature importance scores
- Training vs test performance (detect overfitting)

---

## HOW DECISION TREES WORK

**Algorithm Overview:**

**Training Phase (Building the Tree):**

1. Start with all training data at the root node
2. Select the best feature to split on (using splitting criterion)
3. Split the data into subsets based on feature values
4. Recursively repeat steps 2-3 for each subset (child node)
5. Stop when stopping criterion is met (leaf node)
6. Assign class label (classification) or value (regression) to leaf nodes

**Prediction Phase:**

1. Start at root node with new instance
2. Follow decision path based on feature values
3. Navigate through branches until reaching a leaf node
4. Return the prediction stored at that leaf

**Key Concept:** Decision trees partition the feature space into rectangular regions, where each region corresponds to a leaf node.

---

## TREE STRUCTURE COMPONENTS

### **1. Root Node**

- The topmost node in the tree
- Contains all training data initially
- First split is made here
- Most important feature typically selected

### **2. Internal Nodes (Decision Nodes)**

- Nodes that have children
- Represent a test on a feature
- Split data into subsets
- Each internal node asks a question

### **3. Branches (Edges)**

- Connect nodes
- Represent the outcome of a test
- Data flows down branches based on feature values

### **4. Leaf Nodes (Terminal Nodes)**

- Nodes with no children
- Contain final predictions
- Classification: class label (majority class)
- Regression: numerical value (mean of samples)

### **5. Depth**

- Number of edges from root to leaf
- Deeper trees: more complex, risk overfitting
- Shallow trees: simpler, risk underfitting

### **6. Subtree**

- Any node and all its descendants
- Can be pruned to simplify tree

---

## SPLITTING CRITERIA (IMPURITY MEASURES)

Decision trees need to decide which feature to split on at each node. This is done by measuring **impurity** or **disorder**.

### **FOR CLASSIFICATION:**

#### **1. GINI IMPURITY (GINI INDEX)**

**Definition:** Measures the probability of incorrectly classifying a randomly chosen element if it were randomly labeled according to the distribution of labels in the subset.

**Formula:**

```
Gini = 1 - Σ(pᵢ²)

Where:
- pᵢ = probability of class i
- Sum over all classes
```

**Range:** [0, 0.5] for binary classification, [0, 1-1/k] for k classes

- 0 = perfectly pure (all same class)
- Higher values = more impurity

**Example (Binary):**

```
Dataset: 10 samples, 7 Yes, 3 No

p(Yes) = 7/10 = 0.7
p(No) = 3/10 = 0.3

Gini = 1 - (0.7² + 0.3²)
     = 1 - (0.49 + 0.09)
     = 1 - 0.58
     = 0.42
```

**Pure node examples:**

```
All Yes: Gini = 1 - 1² = 0 (pure)
All No:  Gini = 1 - 1² = 0 (pure)
50-50:   Gini = 1 - (0.5² + 0.5²) = 0.5 (maximum impurity)
```

**Properties:**

- Computationally efficient (no logarithms)
- Default in scikit-learn for classification
- Favors larger partitions
- Tends to find pure classes in specific branches

---

#### **2. ENTROPY (INFORMATION GAIN)**

**Definition:** Measures the amount of information or uncertainty in the data. Based on information theory.

**Formula:**

```
Entropy = -Σ(pᵢ × log₂(pᵢ))

Where:
- pᵢ = probability of class i
- log₂ = logarithm base 2
```

**Range:** [0, log₂(k)] where k = number of classes

- 0 = perfectly pure
- Higher values = more uncertainty/impurity

**Example (Binary):**

```
Dataset: 10 samples, 7 Yes, 3 No

p(Yes) = 0.7
p(No) = 0.3

Entropy = -(0.7 × log₂(0.7) + 0.3 × log₂(0.3))
        = -(0.7 × (-0.515) + 0.3 × (-1.737))
        = -(-0.361 - 0.521)
        = 0.881
```

**Pure node examples:**

```
All Yes: Entropy = -(1 × log₂(1)) = 0 (pure)
50-50:   Entropy = -(0.5 × log₂(0.5) + 0.5 × log₂(0.5)) = 1 (maximum)
```

**Information Gain:**

```
Information Gain = Entropy(parent) - Weighted_Average_Entropy(children)

Higher Information Gain = Better split
```

**Properties:**

- Theoretically better founded (information theory)
- More computationally expensive (logarithms)
- Used in ID3, C4.5, C5.0 algorithms
- Tends to prefer balanced splits

---

#### **3. CLASSIFICATION ERROR**

**Definition:** Simple measure based on misclassification rate.

**Formula:**

```
Error = 1 - max(pᵢ)

Where max(pᵢ) = probability of most common class
```

**Range:** [0, 1-1/k]

**Example:**

```
Dataset: 10 samples, 7 Yes, 3 No
Error = 1 - 0.7 = 0.3
```

**Properties:**

- Simplest measure
- Less sensitive to changes in node probabilities
- Rarely used in practice
- Not as good as Gini or Entropy

---

### **GINI VS ENTROPY COMPARISON:**

|Aspect|Gini Impurity|Entropy|
|---|---|---|
|**Computation**|Faster (no log)|Slower (uses log)|
|**Range (binary)**|[0, 0.5]|[0, 1]|
|**Theoretical Basis**|Probabilistic|Information Theory|
|**Default in sklearn**|Yes|No|
|**Practical Difference**|Very small|Very small|
|**Preference**|Larger partitions|Balanced splits|

**In Practice:** Both produce similar trees. Gini is default because it's faster.

---

### **FOR REGRESSION:**

#### **1. MEAN SQUARED ERROR (MSE)**

**Definition:** Average squared difference between actual values and the mean of the node.

**Formula:**

```
MSE = (1/n) × Σ(yᵢ - ȳ)²

Where:
- yᵢ = actual value
- ȳ = mean of all values in node
- n = number of samples
```

**Properties:**

- Default for regression in scikit-learn
- Sensitive to outliers (due to squaring)
- Penalizes large errors heavily

**Example:**

```
Node values: [10, 20, 30]
Mean = 20

MSE = (1/3) × [(10-20)² + (20-20)² + (30-20)²]
    = (1/3) × [100 + 0 + 100]
    = (1/3) × 200
    = 66.67
```

---

#### **2. MEAN ABSOLUTE ERROR (MAE)**

**Definition:** Average absolute difference between actual values and the median of the node.

**Formula:**

```
MAE = (1/n) × Σ|yᵢ - ȳ|
```

**Properties:**

- More robust to outliers than MSE
- Uses median instead of mean for prediction
- Less commonly used

---

#### **3. FRIEDMAN MSE**

**Definition:** Improvement over standard MSE, used in gradient boosting.

**Properties:**

- Better for gradient boosting trees
- Considers improvement in potential reduction of MSE

---

### **VARIANCE REDUCTION (FOR REGRESSION):**

```
Variance Reduction = Variance(parent) - Weighted_Average_Variance(children)

Higher variance reduction = Better split
```

---

## SPLITTING PROCESS

### **For Categorical Features:**

**Binary Split:**

- Choose one category vs. all others
- Example: Color = Red vs. Color ≠ Red

**Multi-way Split:**

- Create one branch per category
- Example: Color → [Red, Blue, Green] (3 branches)

**Ordered Categories:**

- Treat as ordinal (e.g., Low < Medium < High)
- Can use numerical splitting approach

---

### **For Numerical Features:**

**Binary Split (most common):**

- Choose a threshold value
- Example: Age ≤ 30 vs. Age > 30
- Algorithm tests many thresholds to find best

**Process:**

1. Sort feature values
2. Consider midpoints between consecutive values as potential thresholds
3. Calculate impurity for each potential split
4. Choose threshold with best impurity reduction

**Example:**

```
Ages: [18, 22, 25, 30, 35, 40, 45]

Potential thresholds:
- 20 (between 18 and 22)
- 23.5 (between 22 and 25)
- 27.5 (between 25 and 30)
- 32.5 (between 30 and 35)
- 37.5 (between 35 and 40)
- 42.5 (between 40 and 45)

Test each and choose best
```

---

## KEY HYPERPARAMETERS

### **1. max_depth**

**Definition:** Maximum depth of the tree (number of edges from root to deepest leaf).

**Default:** None (nodes expanded until pure or min_samples_split reached)

**Values:**

- None: Unlimited depth (risk of overfitting)
- Small (3-5): Shallow tree, risk of underfitting
- Medium (6-10): Balanced
- Large (>15): Deep tree, likely overfitting

**Impact:**

- **Small max_depth:** Simple model, high bias, low variance, faster training, less overfitting
- **Large max_depth:** Complex model, low bias, high variance, slower training, more overfitting

**Use When:**

- Limited depth to prevent overfitting
- Control model complexity
- Improve interpretability

**Typical Values:** 3-10 for most problems

---

### **2. min_samples_split**

**Definition:** Minimum number of samples required to split an internal node.

**Default:** 2

**Values:**

- 2: Split as much as possible (default)
- 10-20: Moderate constraint
- 100+: Strong constraint (shallow tree)
- Can be float (fraction of total samples)

**Impact:**

- **Small values (2-5):** More splits, deeper tree, overfitting risk
- **Large values (50+):** Fewer splits, shallower tree, underfitting risk

**Use When:**

- Prevent splits on very small subsets
- Control tree complexity
- Reduce overfitting

---

### **3. min_samples_leaf**

**Definition:** Minimum number of samples required to be at a leaf node.

**Default:** 1

**Values:**

- 1: Any number allowed (default)
- 5-10: Reasonable constraint
- 20+: Strong constraint
- Can be float (fraction of total samples)

**Impact:**

- **Small values (1-2):** Leaves can have few samples, detailed splits, overfitting
- **Large values (20+):** Leaves must have many samples, simpler tree, smoother predictions

**Use When:**

- Ensure statistical significance of leaf predictions
- Prevent overfitting on noisy data
- Make tree more robust

**Relationship:** min_samples_leaf ≤ min_samples_split/2

---

### **4. max_features**

**Definition:** Number of features to consider when looking for the best split.

**Default:**

- Classification: sqrt(n_features)
- Regression: n_features (all features)

**Values:**

- None or 'auto': All features
- 'sqrt': √(n_features)
- 'log2': log₂(n_features)
- int: Specific number
- float: Fraction of features

**Impact:**

- **All features:** Best splits locally, but higher correlation between trees in ensembles
- **Subset of features:** More randomness, better for ensembles (Random Forest), faster training

**Use When:**

- Building Random Forests (use 'sqrt' or 'log2')
- High-dimensional data
- Want faster training

---

### **5. max_leaf_nodes**

**Definition:** Maximum number of leaf nodes in the tree.

**Default:** None (unlimited)

**Values:**

- None: No limit
- Small (10-20): Very simple tree
- Medium (50-100): Moderate complexity
- Large (500+): Complex tree

**Impact:**

- Controls complexity directly
- Alternative to max_depth
- Can produce more balanced trees

**Use When:**

- Want explicit control over tree size
- Prefer balanced tree structure

---

### **6. min_impurity_decrease**

**Definition:** Minimum impurity decrease required for a split to occur.

**Default:** 0.0

**Values:**

- 0.0: No constraint (default)
- Small (0.001-0.01): Slight constraint
- Large (0.1+): Strong constraint

**Impact:**

- Only split if impurity decreases by at least this amount
- Helps prevent useless splits
- More effective pruning

**Use When:**

- Want to prune very small improvements
- Prevent overfitting
- Speed up training

---

### **7. criterion**

**Definition:** Function to measure split quality.

**Values:**

- Classification: 'gini' (default), 'entropy', 'log_loss'
- Regression: 'squared_error' (MSE, default), 'absolute_error' (MAE), 'friedman_mse', 'poisson'

**Impact:**

- Usually makes little practical difference
- Gini faster than entropy
- MSE more common than MAE

---

### **8. splitter**

**Definition:** Strategy for splitting at each node.

**Default:** 'best'

**Values:**

- 'best': Choose best split (deterministic)
- 'random': Choose best random split (stochastic)

**Impact:**

- 'best': Better trees, slower
- 'random': Faster, more diversity (useful for ensembles)

---

### **9. class_weight**

**Definition:** Weights associated with classes (classification only).

**Default:** None (all classes equal weight)

**Values:**

- None: No weighting
- 'balanced': Automatically adjust weights inversely proportional to class frequencies
- dict: Custom weights {class: weight}

**Use When:**

- Imbalanced datasets
- Certain misclassifications more costly

---

### **10. random_state**

**Definition:** Seed for random number generator.

**Impact:**

- Controls randomness in feature selection (when max_features < n_features)
- Ensures reproducibility

---

## HYPERPARAMETER TUNING STRATEGY

**Start with:**

```python
# Default-ish baseline
max_depth=5
min_samples_split=20
min_samples_leaf=10
```

**If Underfitting (High Training Error):**

- Increase max_depth
- Decrease min_samples_split
- Decrease min_samples_leaf
- Decrease min_impurity_decrease

**If Overfitting (Low Training Error, High Test Error):**

- Decrease max_depth
- Increase min_samples_split
- Increase min_samples_leaf
- Increase min_impurity_decrease
- Use pruning

---

## ADVANTAGES OF DECISION TREES

1. **Easy to understand and interpret** - Visual tree structure, clear decision rules
2. **No feature scaling required** - Works with different scales without normalization
3. **Handles both numerical and categorical data** - No encoding needed
4. **Non-parametric** - No assumptions about data distribution
5. **Captures non-linear relationships** - Can model complex decision boundaries
6. **Automatic feature selection** - Uses most important features
7. **Handles missing values** (with some implementations)
8. **Fast prediction** - O(log n) time for prediction
9. **White box model** - Decisions can be traced and explained
10. **Can extract decision rules** - Convert to if-then rules
11. **Feature importance** - Provides ranking of feature importance
12. **Works well with ensembles** - Foundation for Random Forests, Gradient Boosting

---

## DISADVANTAGES OF DECISION TREES

1. **Prone to overfitting** - Can create overly complex trees that memorize training data
2. **Unstable** - Small changes in data can result in completely different tree
3. **Biased toward features with more levels** - Categorical features with many categories favored
4. **Greedy algorithm** - Locally optimal decisions may not be globally optimal
5. **Cannot guarantee global optimum** - Splitting decisions are made greedily
6. **Difficulty with linear relationships** - Need many splits for simple linear patterns
7. **Can create biased trees with imbalanced data** - Dominated by majority class
8. **High variance** - Different training sets produce very different trees
9. **Can be computationally expensive** - For large datasets with many features
10. **Diagonal decision boundaries** - Cannot create smooth diagonal boundaries easily

---

## OVERFITTING IN DECISION TREES

**Why Decision Trees Overfit:**

**Problem:** Trees can grow until each leaf has exactly one training sample.

- Memorizes training data perfectly
- Doesn't generalize to new data
- High variance, low bias

**Symptoms:**

```
Training Accuracy: 100%
Test Accuracy: 60%

This is severe overfitting!
```

**Visual Example:**

```
Overfit Tree (depth=10):
├─ Is Age > 25.3?
│  ├─ Is Income > 45231.7?
│  │  ├─ Is Credit > 678.2?
│  │  │  ├─ Is Age > 25.8?  ← Way too specific!
│  │  │  │  ├─ Yes
│  │  │  │  └─ No

Simple Tree (depth=3):
├─ Is Income > 50000?
│  ├─ Is Age > 30?
│  │  ├─ Yes
│  │  └─ No
```

---

## PRUNING (REDUCING OVERFITTING)

**Definition:** Removing parts of the tree that don't provide significant predictive power.

### **Pre-Pruning (Early Stopping)**

**Definition:** Stop growing the tree before it's fully grown.

**Methods:**

- Set max_depth
- Set min_samples_split
- Set min_samples_leaf
- Set max_leaf_nodes
- Set min_impurity_decrease

**Advantages:**

- Prevents overfitting during training
- Faster training
- Simpler approach

**Disadvantages:**

- Might stop too early
- Miss useful deeper patterns

---

### **Post-Pruning (Cost Complexity Pruning)**

**Definition:** Grow full tree, then remove branches that don't improve performance.

**Method:**

- Grow full tree
- Remove subtrees that don't significantly reduce error on validation set
- Use cost complexity parameter (ccp_alpha)

**Cost Complexity Criterion:**

```
Cost = Error + ccp_alpha × |T|

Where:
- Error = misclassification error
- |T| = number of leaf nodes
- ccp_alpha = complexity parameter
```

**Process:**

1. Grow full tree
2. For each subtree, calculate cost-complexity measure
3. Prune subtree with smallest cost-complexity increase
4. Repeat until only root remains
5. Use cross-validation to select best pruned tree

**Advantages:**

- Often better than pre-pruning
- Can find optimal complexity
- More theoretically sound

**Disadvantages:**

- More computationally expensive
- Two-step process

**In sklearn:**

```python
# Get pruning path
path = tree.cost_complexity_pruning_path(X_train, y_train)
ccp_alphas = path.ccp_alphas

# Try different alphas
for ccp_alpha in ccp_alphas:
    clf = DecisionTreeClassifier(ccp_alpha=ccp_alpha)
    clf.fit(X_train, y_train)
```

---

## FEATURE IMPORTANCE

**Definition:** Measures how much each feature contributes to reducing impurity across all splits in the tree.

**Calculation:**

```
Importance(feature) = Σ (samples at node / total samples) × impurity decrease

Sum over all nodes where feature is used for splitting
Normalized so all importances sum to 1
```

**Interpretation:**

- Higher value = more important feature
- Sum of all importances = 1.0
- 0 = feature not used at all

**Example:**

```
Feature Importances:
Income:     0.45  (45% of total importance)
Age:        0.30  (30%)
Education:  0.20  (20%)
Gender:     0.05  (5%)

Income is most important feature
```

**Use Cases:**

- Feature selection
- Understanding model
- Domain insights
- Remove irrelevant features

**Caution:**

- Biased toward high-cardinality features
- Correlated features split importance
- Not same as causation

---

## BIAS-VARIANCE TRADEOFF IN DECISION TREES

**Shallow Trees (High Bias, Low Variance):**

```
max_depth=2
- Underfits data
- High training error
- Similar errors across different training sets
- Too simple to capture patterns
```

**Deep Trees (Low Bias, High Variance):**

```
max_depth=None
- Overfits data
- Low training error, high test error
- Very different trees from different training sets
- Too complex, captures noise
```

**Optimal Tree (Balanced):**

```
max_depth=5-7
- Captures main patterns
- Doesn't memorize noise
- Generalizes to new data
- Use cross-validation to find
```

---

## HANDLING MISSING VALUES

**Approaches:**

### **1. Imputation Before Training**

- Fill missing values with mean/median/mode
- Use separate category for missing
- Most common approach

### **2. Surrogate Splits**

- Find alternative features that correlate with primary split
- Used in some implementations (CART, C4.5)
- Not in sklearn

### **3. Missing Value Category**

- Treat missing as separate category
- Let tree learn best path for missing values

**sklearn Approach:**

- Does NOT handle missing values automatically
- Must impute before training
- Use SimpleImputer or similar

---

## HANDLING IMBALANCED DATA

**Problem:** One class has many more samples than others.

**Solutions:**

### **1. Class Weights**

```python
class_weight='balanced'  # Automatically adjust weights
```

- Penalize misclassifying minority class more
- Built into sklearn

### **2. Resampling**

- Oversample minority class (SMOTE)
- Undersample majority class
- Do before training

### **3. Different Metrics**

- Don't use accuracy
- Use Precision, Recall, F1-Score
- ROC-AUC curve

### **4. Adjust Threshold**

- Change probability threshold for classification
- Lower threshold for minority class

---

## CATEGORICAL VS NUMERICAL FEATURES

### **Numerical Features:**

- Ordered, continuous values
- Binary splits: X ≤ threshold vs X > threshold
- Algorithm finds best threshold
- Examples: age, income, temperature

### **Categorical Features:**

- Unordered categories
- Must encode before sklearn (use LabelEncoder or OneHotEncoder)
- Can create imbalance if many categories
- Examples: color, country, product type

**sklearn Handling:**

- Does NOT natively handle categorical features as strings
- Must encode first:
    - LabelEncoder for ordinal (has order)
    - OneHotEncoder for nominal (no order)
- Or use ordinal encoding if there's natural order

**Best Practice:**

- Ordinal (Low < Medium < High): Use LabelEncoder
- Nominal (Red, Blue, Green): Use OneHotEncoder for small cardinality
- High cardinality (100+ categories): Consider target encoding or grouping

---

## DECISION TREES VS OTHER ALGORITHMS

|Aspect|Decision Trees|Logistic Regression|KNN|Naive Bayes|Random Forest|
|---|---|---|---|---|---|
|**Interpretability**|High|High|Low|Medium|Low|
|**Training Speed**|Fast|Fast|Very Fast|Very Fast|Slow|
|**Prediction Speed**|Very Fast|Very Fast|Slow|Very Fast|Fast|
|**Feature Scaling**|Not Required|Required|Required|Usually Not|Not Required|
|**Handles Non-linear**|Yes|No|Yes|No|Yes|
|**Overfitting Risk**|High|Low|Medium|Low|Low|
|**Feature Interactions**|Automatic|Manual|Implicit|No|Automatic|
|**Categorical Features**|Natural|Need encoding|Need encoding|Natural|Natural|
|**Missing Values**|Some handle|No|No|Can handle|Some handle|
|**Variance**|High|Low|Medium|Low|Low|
|**Bias**|Low (deep tree)|High|Low|Medium|Low|

---

## WHEN TO USE DECISION TREES

**Use Decision Trees When:**

- Need interpretable model
- Have mixed feature types (categorical + numerical)
- Want automatic feature selection
- No time for feature scaling
- Want to extract decision rules
- Need fast predictions
- Building ensemble models (Random Forest, XGBoost)
- Exploratory data analysis
- Feature interactions are important

**Avoid Decision Trees When:**

- Need best possible accuracy (use ensembles instead)
- Data has simple linear relationships (use linear models)
- Very high-dimensional sparse data (text)
- Need stable predictions (small data changes shouldn't affect model much)
- Can't afford overfitting (use regularized models)

---

## ENSEMBLE METHODS BASED ON DECISION TREES

### **1. Random Forest**

- Multiple decision trees
- Each tree trained on random subset of data and features
- Predictions averaged (regression) or voted (classification)
- Reduces variance, prevents overfitting
- Usually better than single tree

### **2. Gradient Boosting (XGBoost, LightGBM, CatBoost)**

- Sequential trees
- Each tree corrects errors of previous trees
- Highly accurate
- More prone to overfitting than Random Forest
- Requires careful tuning

### **3. AdaBoost**

- Weighted combination of weak trees
- Focuses on misclassified samples
- Older method, less popular now

**Key Insight:** Single decision trees rarely used in practice. Ensembles (Random Forest, XGBoost) almost always better.

---

## TIME COMPLEXITY

**Training Complexity:**

```
O(n × m × log(n))

Where:
- n = number of samples
- m = number of features
- log(n) = depth of tree

For each level, examine all samples and features
```

**Prediction Complexity:**

```
O(log(n)) = O(depth)

Just follow one path from root to leaf
Very fast!
```

**Space Complexity:**

```
O(number of nodes)

Must store entire tree structure
Proportional to tree size
```

---

## BEST PRACTICES

1. **Start with constraints:**
    
    - max_depth=5-7
    - min_samples_split=20
    - min_samples_leaf=10
2. **Use cross-validation:**
    
    - Don't trust single train-test split
    - Use 5 or 10-fold CV
3. **Visualize the tree:**
    
    - Understand what model learned
    - Check for overfitting signs
4. **Check feature importance:**
    
    - Remove irrelevant features
    - Understand model behavior
5. **Tune hyperparameters:**
    
    - GridSearchCV or RandomizedSearchCV
    - Focus on depth and sample parameters
6. **Consider pruning:**
    
    - Use ccp_alpha for post-pruning
    - Compare pruned vs unpruned
7. **Handle imbalanced data:**
    
    - Use class_weight='balanced'
    - Or resample data
8. **Use ensembles:**
    
    - Random Forest or XGBoost usually better
    - Single trees good for interpretation only
9. **Monitor training vs test performance:**
    
    - Large gap = overfitting
    - Both high error = underfitting
10. **Encode categorical features:**
    
    - LabelEncoder or OneHotEncoder
    - Consider cardinality

---

## COMMON PITFALLS

1. **Growing tree too deep:**
    
    - Results in overfitting
    - Set max_depth limit
2. **No constraints:**
    
    - Default settings often overfit
    - Always set at least max_depth
3. **Ignoring class imbalance:**
    
    - Tree biased to majority class
    - Use class_weight
4. **Not pruning:**
    
    - Trees benefit from pruning
    - Try ccp_alpha
5. **Using single tree in production:**
    
    - Unstable, high variance
    - Use Random Forest instead
6. **Not visualizing:**
    
    - Miss overfitting signs
    - Don't understand model
7. **Treating as black box:**
    
    - Decision trees are interpretable
    - Use this advantage!
8. **Forgetting to encode categoricals:**
    
    - sklearn needs numerical input
    - Must encode strings
9. **Not checking feature importance:**
    
    - Miss irrelevant features
    - Waste computational resources
10. **Comparing across different random_state:**
    
    - Trees unstable
    - Set random_state for reproducibility

---

## SUMMARY TABLE

|**Aspect**|**Details**|
|---|---|
|**Type**|Non-parametric, supervised learning|
|**Use Cases**|Classification, Regression, Feature selection|
|**Key Idea**|Recursive partitioning of feature space|
|**Splitting Criteria**|Gini (default), Entropy, MSE (regression)|
|**Training Complexity**|O(n × m × log n)|
|**Prediction Complexity**|O(log n) - very fast|
|**Feature Scaling**|NOT required|
|**Handles Categorical**|Yes (with encoding)|
|**Handles Missing**|No (sklearn) - must impute|
|**Interpretability**|High - can visualize and extract rules|
|**Overfitting Risk**|High - use constraints or pruning|
|**Variance**|High - unstable to data changes|
|**Bias**|Low (if deep) to High (if shallow)|
|**Key Hyperparameters**|max_depth, min_samples_split, min_samples_leaf|
|**Best For**|Interpretability, mixed features, fast predictions|
|**Avoid For**|Best accuracy (use ensembles), stable predictions|
|**Ensemble Methods**|Random Forest, XGBoost, Gradient Boosting|

---

This covers all essential theoretical concepts for Decision Trees. Would you like me to provide simple intuitive examples with step-by-step calculations next?