

## Data Preprocessing

**Q1: What is data preprocessing and why is it important?** Data preprocessing is the process of transforming raw data into a clean, usable format for machine learning models. It's important because real-world data often contains inconsistencies, missing values, outliers, and noise that can negatively impact model performance. Proper preprocessing improves model accuracy and reliability.

**Q2: What are the main steps in data preprocessing?**

- Data cleaning (handling missing values, removing duplicates)
- Data transformation (normalization, standardization)
- Data reduction (dimensionality reduction, feature selection)
- Data integration (combining data from multiple sources)
- Handling outliers
- Encoding categorical variables

**Q3: What is the difference between normalization and standardization?**

- **Normalization** (Min-Max Scaling): Scales data to a fixed range, typically [0,1]. Formula: (x - min)/(max - min). Used when you need bounded values and when distribution is not Gaussian.
- **Standardization** (Z-score normalization): Transforms data to have mean=0 and standard deviation=1. Formula: (x - μ)/σ. Preferred when data follows Gaussian distribution and for algorithms sensitive to scale like SVM, KNN.

**Q4: How do you handle missing values?**

- **Deletion**: Remove rows/columns with missing values (when data is sufficient)
- **Imputation**: Fill with mean, median, mode, or forward/backward fill
- **Prediction**: Use algorithms to predict missing values
- **Indicator variable**: Create a binary column indicating missingness Choice depends on the amount and pattern of missing data.

**Q5: What is feature scaling and when is it required?** Feature scaling ensures all features contribute equally to the model by bringing them to a similar scale. Required for distance-based algorithms (KNN, K-Means, SVM), gradient descent optimization, and regularized models. Not required for tree-based algorithms.

**Q6: What are outliers and how do you detect them?** Outliers are data points significantly different from other observations. Detection methods:

- Statistical methods (Z-score, IQR method)
- Visualization (box plots, scatter plots)
- Distance-based methods (DBSCAN)
- Isolation Forest algorithm

**Q7: What is encoding and what types exist?** Encoding converts categorical variables to numerical format:

- **Label Encoding**: Assigns unique integers (0,1,2...) - for ordinal data
- **One-Hot Encoding**: Creates binary columns for each category - for nominal data
- **Target Encoding**: Replaces categories with target mean
- **Ordinal Encoding**: Similar to label but preserves order

**Q8: What is the curse of dimensionality?** As the number of features increases, the volume of the feature space grows exponentially, making data sparse. This leads to overfitting, increased computational cost, and difficulty in finding meaningful patterns. Solutions include feature selection, dimensionality reduction (PCA), and regularization.

---

## Regression (Umbrella Category)

**Q9: What is regression analysis?** Regression is a supervised learning technique used to predict continuous numerical values. It models the relationship between dependent variable(s) and independent variable(s) by finding the best-fitting line or curve through the data points.

**Q10: What are the types of regression?**

- Linear Regression (simple and multiple)
- Polynomial Regression
- Ridge Regression (L2 regularization)
- Lasso Regression (L1 regularization)
- Elastic Net (L1 + L2)
- Logistic Regression (for classification)
- Support Vector Regression

**Q11: What are the assumptions of linear regression?**

- **Linearity**: Linear relationship between features and target
- **Independence**: Observations are independent
- **Homoscedasticity**: Constant variance of residuals
- **Normality**: Residuals are normally distributed
- **No multicollinearity**: Independent variables are not highly correlated

**Q12: What is the difference between correlation and regression?**

- **Correlation**: Measures strength and direction of relationship between two variables (-1 to +1). Symmetric relationship.
- **Regression**: Predicts one variable from another(s). Asymmetric - distinguishes between dependent and independent variables.

---

## Linear Regression

**Q13: What is Simple Linear Regression?** Simple Linear Regression models the relationship between two variables using equation: y = β₀ + β₁x + ε, where y is dependent variable, x is independent variable, β₀ is intercept, β₁ is slope, and ε is error term.

**Q14: How do you calculate the coefficients in linear regression?** Using Ordinary Least Squares (OLS) method, which minimizes the sum of squared residuals:

- β₁ = Σ((xi - x̄)(yi - ȳ)) / Σ(xi - x̄)²
- β₀ = ȳ - β₁x̄

Or using Normal Equation: β = (X^T X)^(-1) X^T y

**Q15: What is the cost function in linear regression?** Mean Squared Error (MSE): J(θ) = (1/2m) Σ(hθ(xi) - yi)², where m is number of samples, hθ(xi) is predicted value, and yi is actual value. The goal is to minimize this function.

**Q16: What is gradient descent in linear regression?** An iterative optimization algorithm to find the minimum of the cost function by updating parameters in the direction of steepest descent: θj = θj - α ∂J(θ)/∂θj, where α is learning rate.

---

## Multiple Linear Regression

**Q17: What is Multiple Linear Regression?** Extension of simple linear regression with multiple independent variables: y = β₀ + β₁x₁ + β₂x₂ + ... + βₙxₙ + ε. Used when multiple features influence the target variable.

**Q18: What is multicollinearity and how do you detect it?** Multicollinearity occurs when independent variables are highly correlated, making it difficult to determine individual effects. Detection:

- Variance Inflation Factor (VIF > 10 indicates problem)
- Correlation matrix (high correlation between predictors)
- Condition number Solutions: Remove correlated features, use PCA, or apply regularization.

**Q19: What is R-squared and Adjusted R-squared?**

- **R²**: Proportion of variance in dependent variable explained by independent variables (0 to 1). Formula: 1 - (SS_res/SS_tot)
- **Adjusted R²**: Modified R² that penalizes adding irrelevant features. Better for comparing models with different numbers of predictors.

---

## Polynomial Regression

**Q20: What is Polynomial Regression?** A form of regression where the relationship between x and y is modeled as an nth degree polynomial: y = β₀ + β₁x + β₂x² + β₃x³ + ... + βₙxⁿ. Used when data shows non-linear patterns.

**Q21: How is polynomial regression different from linear regression?** Polynomial regression is still linear regression but with polynomial features created from the original features. It's linear in coefficients but can model non-linear relationships.

**Q22: What is the risk of using high-degree polynomials?** Overfitting - the model fits training data too closely, including noise, resulting in poor generalization to new data. The model becomes too complex and wiggly, passing through all training points.

**Q23: How do you choose the degree of polynomial?**

- Plot learning curves
- Use cross-validation to test different degrees
- Check validation error - select degree with lowest validation error
- Consider domain knowledge
- Use regularization to control complexity

---

## Classification (Umbrella Category)

**Q24: What is classification?** Classification is supervised learning where the target variable is categorical. The goal is to predict the class label of new instances based on training data. Examples: spam detection, disease diagnosis, image recognition.

**Q25: What are types of classification?**

- **Binary Classification**: Two classes (yes/no, spam/not spam)
- **Multi-class Classification**: More than two classes (digit recognition 0-9)
- **Multi-label Classification**: Multiple labels per instance
- **Imbalanced Classification**: Unequal class distribution

**Q26: What is the difference between regression and classification?**

- **Regression**: Predicts continuous values (price, temperature)
- **Classification**: Predicts discrete class labels (category, type)
- Regression uses MSE, MAE; Classification uses accuracy, precision, recall
- Output interpretation differs fundamentally

---

## Logistic Regression

**Q27: What is Logistic Regression?** Despite its name, logistic regression is a classification algorithm that predicts probability of binary outcomes using sigmoid function: P(y=1|x) = 1/(1 + e^(-z)), where z = β₀ + β₁x₁ + ... + βₙxₙ. Output ranges from 0 to 1.

**Q28: Why can't we use linear regression for classification?** Linear regression can predict values outside [0,1], doesn't represent probabilities well, is sensitive to outliers, and assumes linear relationship with continuous output. Classification requires bounded probabilities and decision boundaries.

**Q29: What is the sigmoid/logistic function?** σ(z) = 1/(1 + e^(-z)). It maps any real-valued number to range (0,1), making it suitable for probability estimation. It's S-shaped, differentiable, and outputs approach 0 or 1 for extreme inputs.

**Q30: What is the cost function for logistic regression?** Log Loss (Binary Cross-Entropy): J(θ) = -(1/m) Σ[yi log(hθ(xi)) + (1-yi)log(1-hθ(xi))]. This is convex, ensuring global minimum, unlike MSE which would be non-convex for logistic regression.

**Q31: What is the decision boundary in logistic regression?** The threshold (usually 0.5) that separates classes. If P(y=1|x) ≥ 0.5, predict class 1; otherwise class 0. The boundary is linear in feature space: β₀ + β₁x₁ + ... + βₙxₙ = 0.

**Q32: What is multinomial logistic regression?** Extension for multi-class classification (>2 classes) using softmax function. Each class gets a probability, and they sum to 1. Also called Softmax Regression.

---

## K-Nearest Neighbors (KNN)

**Q33: What is the KNN algorithm?** A non-parametric, lazy learning algorithm that classifies data points based on the majority class of k nearest neighbors in feature space. It stores all training data and makes predictions at query time.

**Q34: Why is KNN called a lazy learner?** KNN doesn't learn a model during training - it simply stores the training data. All computation happens during prediction phase when it searches for nearest neighbors. No explicit training phase exists.

**Q35: How does KNN work?**

1. Choose number k
2. Calculate distance between query point and all training points
3. Sort distances and select k nearest neighbors
4. For classification: take majority vote; for regression: take average
5. Return predicted class/value

**Q36: What distance metrics are used in KNN?**

- **Euclidean Distance**: √(Σ(xi - yi)²) - most common
- **Manhattan Distance**: Σ|xi - yi| - for grid-like paths
- **Minkowski Distance**: Generalization of above
- **Hamming Distance**: For categorical variables
- **Cosine Similarity**: For text/document similarity

**Q37: How do you choose the value of k?**

- Small k: More complex boundary, sensitive to noise, overfitting
- Large k: Smoother boundary, may underfit
- Typically use odd numbers to avoid ties in binary classification
- Use cross-validation to find optimal k
- Rule of thumb: k = √n (where n is number of samples)

**Q38: What are advantages and disadvantages of KNN?** **Advantages:**

- Simple to implement and understand
- No training phase
- Naturally handles multi-class
- Works well with large training sets

**Disadvantages:**

- Computationally expensive at prediction (O(n) for each prediction)
- Sensitive to feature scaling
- Curse of dimensionality
- Requires large memory to store data
- Sensitive to irrelevant features and noisy data

**Q39: Why is feature scaling important for KNN?** KNN uses distance calculations. Features with larger scales dominate the distance metric, making features with smaller scales irrelevant. Normalization/standardization ensures all features contribute equally.

---

## Regression Metrics

**Q40: What is Mean Absolute Error (MAE)?** Average of absolute differences between predicted and actual values: MAE = (1/n)Σ|yi - ŷi|. Easy to interpret (same units as target), less sensitive to outliers than MSE, but not differentiable at zero.

**Q41: What is Mean Squared Error (MSE)?** Average of squared differences: MSE = (1/n)Σ(yi - ŷi)². Penalizes large errors more heavily, differentiable everywhere, commonly used in optimization. RMSE = √MSE gives same units as target.

**Q42: What is R-squared (Coefficient of Determination)?** R² = 1 - (SS_res/SS_tot), where SS_res = Σ(yi - ŷi)² and SS_tot = Σ(yi - ȳ)². Represents proportion of variance explained by model. Range: (-∞, 1], where 1 is perfect fit. Can be negative for poor models.

**Q43: What is the difference between MAE and RMSE?**

- **MAE**: Linear penalty, robust to outliers, same scale as data
- **RMSE**: Quadratic penalty, sensitive to outliers, penalizes large errors more
- Use MAE when outliers should be treated equally; RMSE when large errors are particularly undesirable

**Q44: What is Mean Absolute Percentage Error (MAPE)?** MAPE = (100/n)Σ|(yi - ŷi)/yi|. Expresses error as percentage, scale-independent, easy to interpret. Problem: undefined when actual value is zero, biased toward predictions lower than actual.

---

## Classification Metrics

**Q45: What is a Confusion Matrix?** A table showing actual vs predicted classifications:

```
                Predicted
              Positive  Negative
Actual Pos      TP        FN
       Neg      FP        TN
```

Where TP = True Positive, TN = True Negative, FP = False Positive, FN = False Negative.

**Q46: What is Accuracy?** Accuracy = (TP + TN)/(TP + TN + FP + FN). Proportion of correct predictions. Misleading for imbalanced datasets where high accuracy can be achieved by predicting majority class.

**Q47: What is Precision?** Precision = TP/(TP + FP). Of all positive predictions, how many are actually positive? Important when false positives are costly (e.g., spam detection - legitimate emails marked as spam).

**Q48: What is Recall (Sensitivity)?** Recall = TP/(TP + FN). Of all actual positives, how many did we correctly identify? Important when false negatives are costly (e.g., disease diagnosis - missing actual cases).

**Q49: What is the F1-Score?** Harmonic mean of precision and recall: F1 = 2 × (Precision × Recall)/(Precision + Recall). Provides balanced measure, useful for imbalanced datasets. Range: [0,1], where 1 is perfect.

**Q50: What is the difference between Precision and Recall?**

- **Precision**: Focus on positive predictions - "How accurate are our positive predictions?"
- **Recall**: Focus on actual positives - "How many actual positives did we catch?"
- Trade-off exists: increasing one often decreases the other

**Q51: What is Specificity?** Specificity = TN/(TN + FP). Of all actual negatives, how many did we correctly identify? Also called True Negative Rate. Complement of False Positive Rate.

**Q52: What is the ROC curve?** Receiver Operating Characteristic curve plots True Positive Rate (Recall) vs False Positive Rate at various threshold settings. Shows trade-off between sensitivity and specificity. Diagonal line represents random classifier.

**Q53: What is AUC (Area Under Curve)?** Area under ROC curve. Measures model's ability to distinguish between classes. Range: [0,1], where:

- 0.5 = Random classifier
- 0.7-0.8 = Acceptable
- 0.8-0.9 = Excellent
- > 0.9 = Outstanding Independent of classification threshold.
    

**Q54: What is Log Loss (Binary Cross-Entropy)?** Log Loss = -(1/n)Σ[yi log(pi) + (1-yi)log(1-pi)], where pi is predicted probability. Penalizes confident wrong predictions heavily. Lower is better, range: [0, ∞). Considers prediction probability, not just class label.

**Q55: When would you use Precision vs Recall?**

- **High Precision**: When false positives are costly (email spam, content moderation, product recommendations)
- **High Recall**: When false negatives are costly (disease screening, fraud detection, security threat detection)
- **Balanced (F1)**: When both matter equally

**Q56: What is a classification threshold and how do you choose it?** The probability cutoff for assigning classes (default 0.5). Adjust based on:

- Business requirements
- Cost of false positives vs false negatives
- ROC curve analysis
- Precision-Recall tradeoff Lower threshold increases recall but decreases precision, and vice versa.

---

## General ML Concepts

**Q57: What is overfitting and underfitting?**

- **Overfitting**: Model learns training data too well, including noise. High training accuracy, low test accuracy. Solutions: regularization, more data, simpler model.
- **Underfitting**: Model too simple to capture patterns. Low training and test accuracy. Solutions: more features, complex model, reduce regularization.

**Q58: What is bias-variance tradeoff?**

- **Bias**: Error from wrong assumptions, leads to underfitting
- **Variance**: Error from sensitivity to training data fluctuations, leads to overfitting
- **Tradeoff**: Decreasing bias increases variance and vice versa
- Goal: Find balance that minimizes total error

**Q59: What is cross-validation?** Technique to assess model generalization by splitting data into folds, training on k-1 folds and testing on remaining fold, rotating through all folds. K-fold CV (typically k=5 or 10) provides more reliable performance estimate than single train-test split.

**Q60: What is regularization?** Technique to prevent overfitting by adding penalty term to cost function:

- **L1 (Lasso)**: Adds Σ|βi|, produces sparse models (feature selection)
- **L2 (Ridge)**: Adds Σβi², shrinks coefficients, handles multicollinearity
- **Elastic Net**: Combines L1 and L2 Parameter λ controls regularization strength.

---

