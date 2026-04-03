# REGRESSION CODE SNIPPETS WITH EXAMPLES

## 1. SIMPLE LINEAR REGRESSION

```python
# Import necessary libraries
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import matplotlib.pyplot as plt

# Load dataset (assuming CSV file)
df = pd.read_csv('salary_data.csv')

# Display first few rows
print(df.head())
print(df.info())

# Assume dataset has columns: 'YearsExperience' and 'Salary'
# Define features and target
X = df[['YearsExperience']]  # Feature (must be 2D for sklearn)
y = df['Salary']              # Target

# Split data into training and testing sets (80-20 split)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Create and train the model
model = LinearRegression()
model.fit(X_train, y_train)

# Make predictions
y_pred_train = model.predict(X_train)
y_pred_test = model.predict(X_test)

# Model parameters
print(f"Intercept (β₀): {model.intercept_}")
print(f"Coefficient (β₁): {model.coef_[0]}")
print(f"Equation: Salary = {model.intercept_:.2f} + {model.coef_[0]:.2f} * YearsExperience")

# Evaluate model performance
print("\n--- Training Set Performance ---")
print(f"MAE: {mean_absolute_error(y_train, y_pred_train):.2f}")
print(f"MSE: {mean_squared_error(y_train, y_pred_train):.2f}")
print(f"RMSE: {np.sqrt(mean_squared_error(y_train, y_pred_train)):.2f}")
print(f"R² Score: {r2_score(y_train, y_pred_train):.4f}")

print("\n--- Test Set Performance ---")
print(f"MAE: {mean_absolute_error(y_test, y_pred_test):.2f}")
print(f"MSE: {mean_squared_error(y_test, y_pred_test):.2f}")
print(f"RMSE: {np.sqrt(mean_squared_error(y_test, y_pred_test)):.2f}")
print(f"R² Score: {r2_score(y_test, y_pred_test):.4f}")

# Visualize results
plt.figure(figsize=(10, 6))
plt.scatter(X_train, y_train, color='blue', alpha=0.5, label='Training Data')
plt.scatter(X_test, y_test, color='green', alpha=0.5, label='Test Data')
plt.plot(X_train, y_pred_train, color='red', linewidth=2, label='Regression Line')
plt.xlabel('Years of Experience')
plt.ylabel('Salary')
plt.title('Simple Linear Regression: Salary vs Experience')
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()

# Residual plot
residuals = y_test - y_pred_test
plt.figure(figsize=(10, 6))
plt.scatter(y_pred_test, residuals, alpha=0.5)
plt.axhline(y=0, color='red', linestyle='--')
plt.xlabel('Predicted Values')
plt.ylabel('Residuals')
plt.title('Residual Plot')
plt.grid(True, alpha=0.3)
plt.show()

# Make prediction for new data
new_experience = np.array([[5.5]])  # 5.5 years of experience
predicted_salary = model.predict(new_experience)
print(f"\nPredicted salary for 5.5 years experience: ${predicted_salary[0]:,.2f}")
```

---

## 2. MULTIPLE LINEAR REGRESSION

```python
# Import necessary libraries
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.preprocessing import StandardScaler
import seaborn as sns
import matplotlib.pyplot as plt

# Load dataset
df = pd.read_csv('house_prices.csv')

# Assume dataset has columns: 'Size', 'Bedrooms', 'Age', 'Location_Score', 'Price'
print(df.head())
print(df.describe())
print(df.info())

# Check for missing values
print("\nMissing values:")
print(df.isnull().sum())

# Check correlations
print("\nCorrelation Matrix:")
correlation_matrix = df.corr()
print(correlation_matrix['Price'].sort_values(ascending=False))

# Visualize correlation heatmap
plt.figure(figsize=(10, 8))
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', center=0)
plt.title('Correlation Heatmap')
plt.show()

# Define features and target
X = df[['Size', 'Bedrooms', 'Age', 'Location_Score']]
y = df['Price']

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Optional: Standardize features (recommended for better interpretation)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Create and train model (with scaled data)
model = LinearRegression()
model.fit(X_train_scaled, y_train)

# Make predictions
y_pred_train = model.predict(X_train_scaled)
y_pred_test = model.predict(X_test_scaled)

# Model parameters
print(f"\nIntercept (β₀): {model.intercept_:.2f}")
print("\nCoefficients:")
for feature, coef in zip(X.columns, model.coef_):
    print(f"{feature}: {coef:.2f}")

# Feature importance (absolute coefficient values)
feature_importance = pd.DataFrame({
    'Feature': X.columns,
    'Coefficient': model.coef_,
    'Abs_Coefficient': np.abs(model.coef_)
}).sort_values('Abs_Coefficient', ascending=False)
print("\nFeature Importance (by absolute coefficient):")
print(feature_importance)

# Evaluate model
print("\n--- Training Set Performance ---")
print(f"MAE: {mean_absolute_error(y_train, y_pred_train):,.2f}")
print(f"MSE: {mean_squared_error(y_train, y_pred_train):,.2f}")
print(f"RMSE: {np.sqrt(mean_squared_error(y_train, y_pred_train)):,.2f}")
print(f"R² Score: {r2_score(y_train, y_pred_train):.4f}")

print("\n--- Test Set Performance ---")
print(f"MAE: {mean_absolute_error(y_test, y_pred_test):,.2f}")
print(f"MSE: {mean_squared_error(y_test, y_pred_test):,.2f}")
print(f"RMSE: {np.sqrt(mean_squared_error(y_test, y_pred_test)):,.2f}")
print(f"R² Score: {r2_score(y_test, y_pred_test):.4f}")

# Calculate Adjusted R²
n = len(y_test)  # number of observations
p = X_test.shape[1]  # number of predictors
r2 = r2_score(y_test, y_pred_test)
adjusted_r2 = 1 - (1 - r2) * (n - 1) / (n - p - 1)
print(f"Adjusted R² Score: {adjusted_r2:.4f}")

# Check for multicollinearity using VIF (Variance Inflation Factor)
from statsmodels.stats.outliers_influence import variance_inflation_factor

vif_data = pd.DataFrame()
vif_data["Feature"] = X.columns
vif_data["VIF"] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]
print("\nVariance Inflation Factor (VIF):")
print(vif_data)
print("Note: VIF > 10 indicates high multicollinearity")

# Visualize: Actual vs Predicted
plt.figure(figsize=(10, 6))
plt.scatter(y_test, y_pred_test, alpha=0.5)
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 
         'r--', lw=2, label='Perfect Prediction')
plt.xlabel('Actual Price')
plt.ylabel('Predicted Price')
plt.title('Actual vs Predicted Prices')
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()

# Residual plot
residuals = y_test - y_pred_test
plt.figure(figsize=(10, 6))
plt.scatter(y_pred_test, residuals, alpha=0.5)
plt.axhline(y=0, color='red', linestyle='--')
plt.xlabel('Predicted Values')
plt.ylabel('Residuals')
plt.title('Residual Plot')
plt.grid(True, alpha=0.3)
plt.show()

# Distribution of residuals
plt.figure(figsize=(10, 6))
plt.hist(residuals, bins=30, edgecolor='black')
plt.xlabel('Residuals')
plt.ylabel('Frequency')
plt.title('Distribution of Residuals')
plt.grid(True, alpha=0.3)
plt.show()

# Predict for new house
new_house = np.array([[2500, 3, 10, 8.5]])  # Size, Bedrooms, Age, Location_Score
new_house_scaled = scaler.transform(new_house)
predicted_price = model.predict(new_house_scaled)
print(f"\nPredicted price for new house: ${predicted_price[0]:,.2f}")

# Using statsmodels for detailed statistics (p-values, confidence intervals)
import statsmodels.api as sm

X_train_sm = sm.add_constant(X_train_scaled)  # Add intercept
model_sm = sm.OLS(y_train, X_train_sm).fit()
print("\n--- Detailed Statistical Summary ---")
print(model_sm.summary())
```

---

## 3. POLYNOMIAL REGRESSION

```python
# Import necessary libraries
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures, StandardScaler
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.model_selection import cross_val_score
import matplotlib.pyplot as plt

# Load dataset
df = pd.read_csv('position_salaries.csv')

# Assume dataset has columns: 'Level' (1-10) and 'Salary'
print(df.head())

# Define features and target
X = df[['Level']]
y = df['Salary']

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Try different polynomial degrees
degrees = [1, 2, 3, 4, 5]
results = []

plt.figure(figsize=(15, 10))

for i, degree in enumerate(degrees, 1):
    # Create polynomial features
    poly_features = PolynomialFeatures(degree=degree, include_bias=False)
    X_train_poly = poly_features.fit_transform(X_train)
    X_test_poly = poly_features.transform(X_test)
    
    # Optional: Scale features (recommended for higher degrees)
    scaler = StandardScaler()
    X_train_poly_scaled = scaler.fit_transform(X_train_poly)
    X_test_poly_scaled = scaler.transform(X_test_poly)
    
    # Train model
    model = LinearRegression()
    model.fit(X_train_poly_scaled, y_train)
    
    # Predictions
    y_pred_train = model.predict(X_train_poly_scaled)
    y_pred_test = model.predict(X_test_poly_scaled)
    
    # Evaluate
    train_r2 = r2_score(y_train, y_pred_train)
    test_r2 = r2_score(y_test, y_pred_test)
    test_rmse = np.sqrt(mean_squared_error(y_test, y_pred_test))
    
    # Cross-validation score (on training data)
    cv_scores = cross_val_score(model, X_train_poly_scaled, y_train, 
                                cv=5, scoring='r2')
    cv_mean = cv_scores.mean()
    
    results.append({
        'Degree': degree,
        'Train_R2': train_r2,
        'Test_R2': test_r2,
        'Test_RMSE': test_rmse,
        'CV_R2_Mean': cv_mean
    })
    
    print(f"\n--- Polynomial Degree {degree} ---")
    print(f"Training R²: {train_r2:.4f}")
    print(f"Test R²: {test_r2:.4f}")
    print(f"Test RMSE: {test_rmse:,.2f}")
    print(f"Cross-Validation R² (mean): {cv_mean:.4f}")
    print(f"Number of features: {X_train_poly.shape[1]}")
    
    # Visualize
    plt.subplot(2, 3, i)
    
    # Create smooth curve for visualization
    X_range = np.linspace(X.min(), X.max(), 300).reshape(-1, 1)
    X_range_poly = poly_features.transform(X_range)
    X_range_poly_scaled = scaler.transform(X_range_poly)
    y_range_pred = model.predict(X_range_poly_scaled)
    
    plt.scatter(X_train, y_train, color='blue', alpha=0.5, label='Train')
    plt.scatter(X_test, y_test, color='green', alpha=0.5, label='Test')
    plt.plot(X_range, y_range_pred, color='red', linewidth=2, 
             label=f'Degree {degree}')
    plt.xlabel('Level')
    plt.ylabel('Salary')
    plt.title(f'Polynomial Degree {degree}\nTest R²: {test_r2:.4f}')
    plt.legend()
    plt.grid(True, alpha=0.3)

plt.tight_layout()
plt.show()

# Compare all degrees
results_df = pd.DataFrame(results)
print("\n--- Comparison of All Polynomial Degrees ---")
print(results_df)

# Plot comparison
fig, axes = plt.subplots(1, 2, figsize=(15, 5))

# R² comparison
axes[0].plot(results_df['Degree'], results_df['Train_R2'], 
             marker='o', label='Training R²', linewidth=2)
axes[0].plot(results_df['Degree'], results_df['Test_R2'], 
             marker='s', label='Test R²', linewidth=2)
axes[0].plot(results_df['Degree'], results_df['CV_R2_Mean'], 
             marker='^', label='CV R² Mean', linewidth=2)
axes[0].set_xlabel('Polynomial Degree')
axes[0].set_ylabel('R² Score')
axes[0].set_title('R² Score vs Polynomial Degree')
axes[0].legend()
axes[0].grid(True, alpha=0.3)

# RMSE comparison
axes[1].plot(results_df['Degree'], results_df['Test_RMSE'], 
             marker='o', color='red', linewidth=2)
axes[1].set_xlabel('Polynomial Degree')
axes[1].set_ylabel('RMSE')
axes[1].set_title('Test RMSE vs Polynomial Degree')
axes[1].grid(True, alpha=0.3)

plt.tight_layout()
plt.show()

# Select best degree (based on test R² or cross-validation)
best_degree = results_df.loc[results_df['Test_R2'].idxmax(), 'Degree']
print(f"\nBest polynomial degree (by Test R²): {int(best_degree)}")

# Train final model with best degree
poly_features_final = PolynomialFeatures(degree=int(best_degree), include_bias=False)
X_train_poly_final = poly_features_final.fit_transform(X_train)
X_test_poly_final = poly_features_final.transform(X_test)

scaler_final = StandardScaler()
X_train_poly_final_scaled = scaler_final.fit_transform(X_train_poly_final)
X_test_poly_final_scaled = scaler_final.transform(X_test_poly_final)

final_model = LinearRegression()
final_model.fit(X_train_poly_final_scaled, y_train)

# Final evaluation
y_pred_final = final_model.predict(X_test_poly_final_scaled)

print(f"\n--- Final Model (Degree {int(best_degree)}) Performance ---")
print(f"MAE: {mean_absolute_error(y_test, y_pred_final):,.2f}")
print(f"MSE: {mean_squared_error(y_test, y_pred_final):,.2f}")
print(f"RMSE: {np.sqrt(mean_squared_error(y_test, y_pred_final)):,.2f}")
print(f"R² Score: {r2_score(y_test, y_pred_final):.4f}")

# Print polynomial equation
print(f"\nPolynomial coefficients:")
print(f"Intercept: {final_model.intercept_:.2f}")
for i, coef in enumerate(final_model.coef_, 1):
    print(f"x^{i}: {coef:.2f}")

# Predict for new value
new_level = np.array([[6.5]])
new_level_poly = poly_features_final.transform(new_level)
new_level_poly_scaled = scaler_final.transform(new_level_poly)
predicted_salary = final_model.predict(new_level_poly_scaled)
print(f"\nPredicted salary for level 6.5: ${predicted_salary[0]:,.2f}")
```

---

## 4. LOGISTIC REGRESSION

```python
# Import necessary libraries
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import (accuracy_score, precision_score, recall_score, 
                            f1_score, confusion_matrix, classification_report,
                            roc_curve, roc_auc_score, log_loss)
import matplotlib.pyplot as plt
import seaborn as sns

# Load dataset
df = pd.read_csv('customer_churn.csv')

# Assume dataset has columns: 'Age', 'Income', 'Tenure', 'Monthly_Charges', 'Churn' (0/1)
print(df.head())
print(df.info())
print("\nClass distribution:")
print(df['Churn'].value_counts())
print(df['Churn'].value_counts(normalize=True))

# Check for missing values
print("\nMissing values:")
print(df.isnull().sum())

# Define features and target
X = df[['Age', 'Income', 'Tenure', 'Monthly_Charges']]
y = df['Churn']  # Binary: 0 = Not Churned, 1 = Churned

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y  # stratify maintains class balance
)

print(f"\nTraining set size: {len(X_train)}")
print(f"Test set size: {len(X_test)}")
print(f"Training set class distribution:\n{y_train.value_counts(normalize=True)}")

# Standardize features (important for logistic regression)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Create and train logistic regression model
model = LogisticRegression(
    random_state=42,
    max_iter=1000,  # Maximum iterations for convergence
    solver='lbfgs'  # Solver algorithm
)
model.fit(X_train_scaled, y_train)

# Make predictions
y_pred_train = model.predict(X_train_scaled)
y_pred_test = model.predict(X_test_scaled)

# Get prediction probabilities
y_pred_proba_train = model.predict_proba(X_train_scaled)[:, 1]  # Probability of class 1
y_pred_proba_test = model.predict_proba(X_test_scaled)[:, 1]

# Model parameters
print(f"\n--- Model Parameters ---")
print(f"Intercept: {model.intercept_[0]:.4f}")
print("\nCoefficients (log-odds):")
for feature, coef in zip(X.columns, model.coef_[0]):
    print(f"{feature}: {coef:.4f}")

# Feature importance (absolute coefficient values)
feature_importance = pd.DataFrame({
    'Feature': X.columns,
    'Coefficient': model.coef_[0],
    'Abs_Coefficient': np.abs(model.coef_[0]),
    'Odds_Ratio': np.exp(model.coef_[0])  # Exponential gives odds ratio
}).sort_values('Abs_Coefficient', ascending=False)
print("\nFeature Importance:")
print(feature_importance)

# EVALUATION METRICS

# Training Set
print("\n=== TRAINING SET PERFORMANCE ===")
print(f"Accuracy: {accuracy_score(y_train, y_pred_train):.4f}")
print(f"Precision: {precision_score(y_train, y_pred_train):.4f}")
print(f"Recall: {recall_score(y_train, y_pred_train):.4f}")
print(f"F1-Score: {f1_score(y_train, y_pred_train):.4f}")
print(f"ROC-AUC: {roc_auc_score(y_train, y_pred_proba_train):.4f}")
print(f"Log Loss: {log_loss(y_train, y_pred_proba_train):.4f}")

# Test Set
print("\n=== TEST SET PERFORMANCE ===")
print(f"Accuracy: {accuracy_score(y_test, y_pred_test):.4f}")
print(f"Precision: {precision_score(y_test, y_pred_test):.4f}")
print(f"Recall: {recall_score(y_test, y_pred_test):.4f}")
print(f"F1-Score: {f1_score(y_test, y_pred_test):.4f}")
print(f"ROC-AUC: {roc_auc_score(y_test, y_pred_proba_test):.4f}")
print(f"Log Loss: {log_loss(y_test, y_pred_proba_test):.4f}")

# Detailed Classification Report
print("\n=== CLASSIFICATION REPORT (Test Set) ===")
print(classification_report(y_test, y_pred_test, 
                          target_names=['Not Churned', 'Churned']))

# CONFUSION MATRIX
cm = confusion_matrix(y_test, y_pred_test)
print("\n=== CONFUSION MATRIX ===")
print(cm)
print(f"\nTrue Negatives: {cm[0,0]}")
print(f"False Positives: {cm[0,1]}")
print(f"False Negatives: {cm[1,0]}")
print(f"True Positives: {cm[1,1]}")

# Visualize Confusion Matrix
plt.figure(figsize=(8, 6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', 
            xticklabels=['Not Churned', 'Churned'],
            yticklabels=['Not Churned', 'Churned'])
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix')
plt.show()

# ROC Curve
fpr, tpr, thresholds = roc_curve(y_test, y_pred_proba_test)
roc_auc = roc_auc_score(y_test, y_pred_proba_test)

plt.figure(figsize=(10, 6))
plt.plot(fpr, tpr, color='darkorange', lw=2, 
         label=f'ROC Curve (AUC = {roc_auc:.4f})')
plt.plot([0, 1], [0, 1], color='navy', lw=2, linestyle='--', 
         label='Random Classifier')
plt.xlim([0.0, 1.0])
plt.ylim([0.0, 1.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver Operating Characteristic (ROC) Curve')
plt.legend(loc="lower right")
plt.grid(True, alpha=0.3)
plt.show()

# Precision-Recall Curve
from sklearn.metrics import precision_recall_curve, average_precision_score

precision_vals, recall_vals, _ = precision_recall_curve(y_test, y_pred_proba_test)
avg_precision = average_precision_score(y_test, y_pred_proba_test)

plt.figure(figsize=(10, 6))
plt.plot(recall_vals, precision_vals, color='blue', lw=2,
         label=f'Precision-Recall Curve (AP = {avg_precision:.4f})')
plt.xlabel('Recall')
plt.ylabel('Precision')
plt.title('Precision-Recall Curve')
plt.legend(loc="lower left")
plt.grid(True, alpha=0.3)
plt.show()

# Probability Distribution
plt.figure(figsize=(10, 6))
plt.hist(y_pred_proba_test[y_test == 0], bins=30, alpha=0.5, 
         label='Not Churned (Class 0)', color='blue')
plt.hist(y_pred_proba_test[y_test == 1], bins=30, alpha=0.5, 
         label='Churned (Class 1)', color='red')
plt.axvline(x=0.5, color='green', linestyle='--', linewidth=2, 
            label='Decision Threshold (0.5)')
plt.xlabel('Predicted Probability of Churn')
plt.ylabel('Frequency')
plt.title('Distribution of Predicted Probabilities')
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()

# Adjust decision threshold (optional)
# Default threshold is 0.5, but you can optimize it
threshold = 0.6  # Example: stricter threshold
y_pred_custom = (y_pred_proba_test >= threshold).astype(int)

print(f"\n=== PERFORMANCE WITH THRESHOLD = {threshold} ===")
print(f"Accuracy: {accuracy_score(y_test, y_pred_custom):.4f}")
print(f"Precision: {precision_score(y_test, y_pred_custom):.4f}")
print(f"Recall: {recall_score(y_test, y_pred_custom):.4f}")
print(f"F1-Score: {f1_score(y_test, y_pred_custom):.4f}")

# Find optimal threshold based on F1-score
from sklearn.metrics import f1_score

thresholds_range = np.arange(0.1, 0.9, 0.05)
f1_scores = []

for thresh in thresholds_range:
    y_pred_thresh = (y_pred_proba_test >= thresh).astype(int)
    f1 = f1_score(y_test, y_pred_thresh)
    f1_scores.append(f1)

optimal_threshold = thresholds_range[np.argmax(f1_scores)]
print(f"\nOptimal threshold (by F1-score): {optimal_threshold:.2f}")

plt.figure(figsize=(10, 6))
plt.plot(thresholds_range, f1_scores, marker='o', linewidth=2)
plt.axvline(x=optimal_threshold, color='red', linestyle='--', 
            label=f'Optimal Threshold: {optimal_threshold:.2f}')
plt.xlabel('Threshold')
plt.ylabel('F1-Score')
plt.title('F1-Score vs Classification Threshold')
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()

# Predict for new customer
new_customer = np.array([[35, 50000, 24, 75]])  # Age, Income, Tenure, Monthly_Charges
new_customer_scaled = scaler.transform(new_customer)
churn_probability = model.predict_proba(new_customer_scaled)[0, 1]
churn_prediction = model.predict(new_customer_scaled)[0]

print(f"\n=== NEW CUSTOMER PREDICTION ===")
print(f"Churn Probability: {churn_probability:.4f} ({churn_probability*100:.2f}%)")
print(f"Prediction: {'Will Churn' if churn_prediction == 1 else 'Will Not Churn'}")

# Cross-validation
from sklearn.model_selection import cross_val_score

cv_scores = cross_val_score(model, X_train_scaled, y_train, cv=5, scoring='accuracy')
print(f"\n=== CROSS-VALIDATION (5-fold) ===")
print(f"Accuracy scores: {cv_scores}")
print(f"Mean Accuracy: {cv_scores.mean():.4f} (+/- {cv_scores.std() * 2:.4f})")
```

---

## BONUS: COMPLETE PIPELINE WITH PREPROCESSING

```python
# Complete pipeline with encoding and scaling
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix

# Load data with mixed types
df = pd.read_csv('customer_data.csv')
# Columns: 'Age', 'Income', 'Gender', 'Region', 'Education', 'Purchased' (target)

# Separate features and target
X = df.drop('Purchased', axis=1)
y = df['Purchased']

# Identify column types
numeric_features = ['Age', 'Income']
categorical_nominal = ['Gender', 'Region']  # One-Hot Encoding
categorical_ordinal = ['Education']  # Label Encoding

# Handle ordinal encoding
# Handle ordinal encoding manually
from sklearn.preprocessing import OrdinalEncoder

education_order = ['High School', 'Bachelor', 'Master', 'PhD']
ordinal_encoder = OrdinalEncoder(categories=[education_order])
X['Education_Encoded'] = ordinal_encoder.fit_transform(X[['Education']])

# Update feature lists
X = X.drop('Education', axis=1)
numeric_features = ['Age', 'Income', 'Education_Encoded']

# Create preprocessing pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import StandardScaler, OneHotEncoder

preprocessor = ColumnTransformer(
    transformers=[
        ('num', StandardScaler(), numeric_features),
        ('cat', OneHotEncoder(drop='first', sparse_output=False), categorical_nominal)
    ])

# Create full pipeline with model
pipeline = Pipeline([
    ('preprocessor', preprocessor),
    ('classifier', LogisticRegression(random_state=42, max_iter=1000))
])

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Fit pipeline (preprocessing + training in one step)
pipeline.fit(X_train, y_train)

# Predict
y_pred = pipeline.predict(X_test)
y_pred_proba = pipeline.predict_proba(X_test)[:, 1]

# Evaluate
print("=== PIPELINE MODEL PERFORMANCE ===")
print(classification_report(y_test, y_pred))
print("\nConfusion Matrix:")
print(confusion_matrix(y_test, y_pred))

# Get feature names after preprocessing
feature_names = (
    numeric_features + 
    pipeline.named_steps['preprocessor']
    .named_transformers_['cat']
    .get_feature_names_out(categorical_nominal).tolist()
)
print(f"\nFeatures after preprocessing: {feature_names}")

# Access model coefficients
coef = pipeline.named_steps['classifier'].coef_[0]
print("\nModel Coefficients:")
for name, c in zip(feature_names, coef):
    print(f"{name}: {c:.4f}")
```

## COMPARING ALL REGRESSION TYPES

```python
"""
Complete comparison of different regression types
"""
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.linear_model import LinearRegression, LogisticRegression
from sklearn.preprocessing import PolynomialFeatures, StandardScaler
from sklearn.metrics import (mean_absolute_error, mean_squared_error, 
                            r2_score, accuracy_score, roc_auc_score)
import matplotlib.pyplot as plt

# =====================================================
# 1. SIMPLE LINEAR REGRESSION EXAMPLE
# =====================================================
print("=" * 60)
print("SIMPLE LINEAR REGRESSION")
print("=" * 60)

# Simulate data
np.random.seed(42)
X_simple = np.random.rand(100, 1) * 10
y_simple = 2.5 * X_simple.flatten() + 5 + np.random.randn(100) * 2

X_train_s, X_test_s, y_train_s, y_test_s = train_test_split(
    X_simple, y_simple, test_size=0.2, random_state=42
)

model_simple = LinearRegression()
model_simple.fit(X_train_s, y_train_s)
y_pred_s = model_simple.predict(X_test_s)

print(f"Equation: y = {model_simple.intercept_:.2f} + {model_simple.coef_[0]:.2f}x")
print(f"R² Score: {r2_score(y_test_s, y_pred_s):.4f}")
print(f"RMSE: {np.sqrt(mean_squared_error(y_test_s, y_pred_s)):.2f}")

# =====================================================
# 2. MULTIPLE LINEAR REGRESSION EXAMPLE
# =====================================================
print("\n" + "=" * 60)
print("MULTIPLE LINEAR REGRESSION")
print("=" * 60)

# Simulate data with multiple features
X_multiple = np.random.rand(100, 3) * 10
y_multiple = (2.5 * X_multiple[:, 0] + 
              1.5 * X_multiple[:, 1] - 
              0.5 * X_multiple[:, 2] + 
              10 + np.random.randn(100) * 2)

X_train_m, X_test_m, y_train_m, y_test_m = train_test_split(
    X_multiple, y_multiple, test_size=0.2, random_state=42
)

scaler_m = StandardScaler()
X_train_m_scaled = scaler_m.fit_transform(X_train_m)
X_test_m_scaled = scaler_m.transform(X_test_m)

model_multiple = LinearRegression()
model_multiple.fit(X_train_m_scaled, y_train_m)
y_pred_m = model_multiple.predict(X_test_m_scaled)

print(f"Intercept: {model_multiple.intercept_:.2f}")
print("Coefficients:")
for i, coef in enumerate(model_multiple.coef_):
    print(f"  Feature {i+1}: {coef:.2f}")
print(f"R² Score: {r2_score(y_test_m, y_pred_m):.4f}")
print(f"RMSE: {np.sqrt(mean_squared_error(y_test_m, y_pred_m)):.2f}")

# =====================================================
# 3. POLYNOMIAL REGRESSION EXAMPLE
# =====================================================
print("\n" + "=" * 60)
print("POLYNOMIAL REGRESSION")
print("=" * 60)

# Simulate non-linear data
X_poly = np.random.rand(100, 1) * 10
y_poly = 0.5 * X_poly.flatten()**2 - 3 * X_poly.flatten() + 10 + np.random.randn(100) * 5

X_train_p, X_test_p, y_train_p, y_test_p = train_test_split(
    X_poly, y_poly, test_size=0.2, random_state=42
)

# Try different degrees
for degree in [1, 2, 3]:
    poly = PolynomialFeatures(degree=degree)
    X_train_poly = poly.fit_transform(X_train_p)
    X_test_poly = poly.transform(X_test_p)
    
    model_poly = LinearRegression()
    model_poly.fit(X_train_poly, y_train_p)
    y_pred_p = model_poly.predict(X_test_poly)
    
    print(f"\nDegree {degree}:")
    print(f"  R² Score: {r2_score(y_test_p, y_pred_p):.4f}")
    print(f"  RMSE: {np.sqrt(mean_squared_error(y_test_p, y_pred_p)):.2f}")

# =====================================================
# 4. LOGISTIC REGRESSION EXAMPLE
# =====================================================
print("\n" + "=" * 60)
print("LOGISTIC REGRESSION")
print("=" * 60)

# Simulate binary classification data
from sklearn.datasets import make_classification

X_log, y_log = make_classification(
    n_samples=1000, n_features=4, n_informative=3, 
    n_redundant=1, random_state=42
)

X_train_l, X_test_l, y_train_l, y_test_l = train_test_split(
    X_log, y_log, test_size=0.2, random_state=42, stratify=y_log
)

scaler_l = StandardScaler()
X_train_l_scaled = scaler_l.fit_transform(X_train_l)
X_test_l_scaled = scaler_l.transform(X_test_l)

model_log = LogisticRegression(random_state=42, max_iter=1000)
model_log.fit(X_train_l_scaled, y_train_l)
y_pred_l = model_log.predict(X_test_l_scaled)
y_pred_proba_l = model_log.predict_proba(X_test_l_scaled)[:, 1]

print(f"Accuracy: {accuracy_score(y_test_l, y_pred_l):.4f}")
print(f"ROC-AUC: {roc_auc_score(y_test_l, y_pred_proba_l):.4f}")
print("\nCoefficients:")
for i, coef in enumerate(model_log.coef_[0]):
    print(f"  Feature {i+1}: {coef:.4f}")

# =====================================================
# VISUAL COMPARISON
# =====================================================
fig, axes = plt.subplots(2, 2, figsize=(15, 12))

# Simple Linear
axes[0, 0].scatter(X_test_s, y_test_s, alpha=0.5, label='Actual')
axes[0, 0].scatter(X_test_s, y_pred_s, alpha=0.5, label='Predicted')
X_line = np.linspace(X_test_s.min(), X_test_s.max(), 100).reshape(-1, 1)
y_line = model_simple.predict(X_line)
axes[0, 0].plot(X_line, y_line, 'r-', linewidth=2, label='Regression Line')
axes[0, 0].set_xlabel('X')
axes[0, 0].set_ylabel('y')
axes[0, 0].set_title(f'Simple Linear Regression\nR² = {r2_score(y_test_s, y_pred_s):.4f}')
axes[0, 0].legend()
axes[0, 0].grid(True, alpha=0.3)

# Multiple Linear (showing actual vs predicted)
axes[0, 1].scatter(y_test_m, y_pred_m, alpha=0.5)
axes[0, 1].plot([y_test_m.min(), y_test_m.max()], 
                [y_test_m.min(), y_test_m.max()], 
                'r--', linewidth=2, label='Perfect Prediction')
axes[0, 1].set_xlabel('Actual Values')
axes[0, 1].set_ylabel('Predicted Values')
axes[0, 1].set_title(f'Multiple Linear Regression\nR² = {r2_score(y_test_m, y_pred_m):.4f}')
axes[0, 1].legend()
axes[0, 1].grid(True, alpha=0.3)

# Polynomial
X_range = np.linspace(X_poly.min(), X_poly.max(), 300).reshape(-1, 1)
colors = ['blue', 'green', 'orange']
for degree, color in zip([1, 2, 3], colors):
    poly = PolynomialFeatures(degree=degree)
    X_range_poly = poly.fit_transform(X_range)
    X_train_poly = poly.fit_transform(X_train_p)
    
    model = LinearRegression()
    model.fit(X_train_poly, y_train_p)
    y_range_pred = model.predict(X_range_poly)
    
    axes[1, 0].plot(X_range, y_range_pred, color=color, 
                    linewidth=2, label=f'Degree {degree}')

axes[1, 0].scatter(X_train_p, y_train_p, alpha=0.3, color='black', label='Data')
axes[1, 0].set_xlabel('X')
axes[1, 0].set_ylabel('y')
axes[1, 0].set_title('Polynomial Regression (Different Degrees)')
axes[1, 0].legend()
axes[1, 0].grid(True, alpha=0.3)

# Logistic - Decision Boundary (for 2 features)
from matplotlib.colors import ListedColormap

# Use only first 2 features for visualization
X_train_2d = X_train_l_scaled[:, :2]
X_test_2d = X_test_l_scaled[:, :2]

model_log_2d = LogisticRegression(random_state=42, max_iter=1000)
model_log_2d.fit(X_train_2d, y_train_l)

# Create mesh
h = 0.02
x_min, x_max = X_train_2d[:, 0].min() - 1, X_train_2d[:, 0].max() + 1
y_min, y_max = X_train_2d[:, 1].min() - 1, X_train_2d[:, 1].max() + 1
xx, yy = np.meshgrid(np.arange(x_min, x_max, h),
                     np.arange(y_min, y_max, h))

Z = model_log_2d.predict(np.c_[xx.ravel(), yy.ravel()])
Z = Z.reshape(xx.shape)

axes[1, 1].contourf(xx, yy, Z, alpha=0.3, cmap=ListedColormap(['#FFAAAA', '#AAAAFF']))
axes[1, 1].scatter(X_test_2d[:, 0], X_test_2d[:, 1], 
                   c=y_test_l, cmap=ListedColormap(['#FF0000', '#0000FF']),
                   edgecolor='black', alpha=0.7)
axes[1, 1].set_xlabel('Feature 1')
axes[1, 1].set_ylabel('Feature 2')
axes[1, 1].set_title(f'Logistic Regression Decision Boundary\nAccuracy = {accuracy_score(y_test_l, y_pred_l):.4f}')
axes[1, 1].grid(True, alpha=0.3)

plt.tight_layout()
plt.show()

print("\n" + "=" * 60)
print("COMPARISON COMPLETE")
print("=" * 60)
```

---

## ADDITIONAL UTILITIES

```python
"""
Utility functions for regression analysis
"""

def evaluate_regression(y_true, y_pred, model_name="Model"):
    """
    Complete evaluation of regression model
    """
    mae = mean_absolute_error(y_true, y_pred)
    mse = mean_squared_error(y_true, y_pred)
    rmse = np.sqrt(mse)
    r2 = r2_score(y_true, y_pred)
    
    # Adjusted R²
    n = len(y_true)
    p = 1  # Adjust based on number of features
    adj_r2 = 1 - (1 - r2) * (n - 1) / (n - p - 1)
    
    print(f"\n{'='*50}")
    print(f"{model_name} Performance Metrics")
    print(f"{'='*50}")
    print(f"MAE:          {mae:,.4f}")
    print(f"MSE:          {mse:,.4f}")
    print(f"RMSE:         {rmse:,.4f}")
    print(f"R² Score:     {r2:.4f}")
    print(f"Adj R² Score: {adj_r2:.4f}")
    print(f"{'='*50}\n")
    
    return {'MAE': mae, 'MSE': mse, 'RMSE': rmse, 'R2': r2, 'Adj_R2': adj_r2}


def plot_residuals(y_true, y_pred, title="Residual Plot"):
    """
    Create residual plots for regression diagnostics
    """
    residuals = y_true - y_pred
    
    fig, axes = plt.subplots(1, 3, figsize=(18, 5))
    
    # Residual plot
    axes[0].scatter(y_pred, residuals, alpha=0.5)
    axes[0].axhline(y=0, color='red', linestyle='--', linewidth=2)
    axes[0].set_xlabel('Predicted Values')
    axes[0].set_ylabel('Residuals')
    axes[0].set_title('Residual Plot')
    axes[0].grid(True, alpha=0.3)
    
    # Histogram of residuals
    axes[1].hist(residuals, bins=30, edgecolor='black')
    axes[1].set_xlabel('Residuals')
    axes[1].set_ylabel('Frequency')
    axes[1].set_title('Distribution of Residuals')
    axes[1].grid(True, alpha=0.3)
    
    # Q-Q plot
    from scipy import stats
    stats.probplot(residuals, dist="norm", plot=axes[2])
    axes[2].set_title('Q-Q Plot')
    axes[2].grid(True, alpha=0.3)
    
    plt.suptitle(title, fontsize=16, y=1.02)
    plt.tight_layout()
    plt.show()


def compare_models(models_dict, X_test, y_test):
    """
    Compare multiple models
    
    models_dict: {'Model Name': trained_model}
    """
    results = []
    
    for name, model in models_dict.items():
        y_pred = model.predict(X_test)
        metrics = evaluate_regression(y_test, y_pred, name)
        metrics['Model'] = name
        results.append(metrics)
    
    results_df = pd.DataFrame(results)
    results_df = results_df[['Model', 'MAE', 'MSE', 'RMSE', 'R2', 'Adj_R2']]
    
    print("\n" + "="*70)
    print("MODEL COMPARISON")
    print("="*70)
    print(results_df.to_string(index=False))
    print("="*70 + "\n")
    
    return results_df


def save_model(model, filename):
    """
    Save trained model to file
    """
    import pickle
    
    with open(filename, 'wb') as file:
        pickle.dump(model, file)
    print(f"Model saved to {filename}")


def load_model(filename):
    """
    Load trained model from file
    """
    import pickle
    
    with open(filename, 'rb') as file:
        model = pickle.load(file)
    print(f"Model loaded from {filename}")
    return model


# Example usage:
"""
# Train multiple models
model1 = LinearRegression()
model1.fit(X_train, y_train)

model2 = LinearRegression()  # with different preprocessing
model2.fit(X_train_scaled, y_train)

# Compare
models = {
    'Simple Linear': model1,
    'Scaled Linear': model2
}
comparison = compare_models(models, X_test, y_test)

# Plot residuals
plot_residuals(y_test, model1.predict(X_test), "Model 1 Residuals")

# Save model
save_model(model1, 'my_model.pkl')
loaded_model = load_model('my_model.pkl')
"""
```

---

## KEY TAKEAWAYS

1. **Always scale features** for algorithms sensitive to feature magnitude (especially logistic regression, polynomial regression)
    
2. **Train-test split** before any preprocessing to avoid data leakage
    
3. **Fit scaler/encoder on training data only**, then transform both train and test
    
4. **Use multiple metrics** - don't rely on just one (e.g., R² alone can be misleading)
    
5. **Visualize results** - residual plots, actual vs predicted, ROC curves help understand model performance
    
6. **Check assumptions** - linearity, normality of residuals, homoscedasticity
    
7. **Cross-validation** gives more robust performance estimates
    
8. **Watch for overfitting** - especially with polynomial regression (high training R², low test R²)
    
9. **Feature engineering matters** - proper encoding and scaling can significantly improve results
    
10. **For logistic regression** - consider adjusting decision threshold based on business requirements