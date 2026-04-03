Based on the curriculum content, here's a comprehensive list of **all models** mentioned with their **valid evaluation metrics**:

## **SUPERVISED LEARNING: REGRESSION MODELS**

### **1. Simple Linear Regression**
**Valid Metrics:**
- Mean Absolute Error (MAE)
- Mean Squared Error (MSE)
- Root Mean Squared Error (RMSE)
- R-squared (R²) Score
- **NOT valid:** Log Loss, ROC-AUC, Accuracy, Precision, Recall, F1 (these are for classification)

### **2. Multiple Linear Regression**
**Valid Metrics:**
- Mean Absolute Error (MAE)
- Mean Squared Error (MSE)
- Root Mean Squared Error (RMSE)
- R-squared (R²) Score

### **3. Polynomial Regression**
**Valid Metrics:**
- Mean Absolute Error (MAE)
- Mean Squared Error (MSE)
- Root Mean Squared Error (RMSE)
- R-squared (R²) Score

### **4. Logistic Regression**
**Valid Metrics:**
- **Classification metrics:**
  - Accuracy
  - Logarithmic Loss (Log Loss)
  - Area Under Curve (ROC-AUC)
  - Precision
  - Recall
  - F1 Score
  - Confusion Matrix
- **Regression metrics:** ❌ NOT valid (it's a classifier)

## **SUPERVISED LEARNING: CLASSIFICATION MODELS**

### **5. K-Nearest Neighbors (KNN)**
**Valid Metrics:**
- Accuracy
- Logarithmic Loss (with probability outputs)
- Area Under Curve (ROC-AUC)
- Precision
- Recall
- F1 Score
- Confusion Matrix

### **6. Naïve Bayes**
**Valid Metrics:**
- Accuracy
- Logarithmic Loss (excellent for this - probabilistic model)
- Area Under Curve (ROC-AUC)
- Precision
- Recall
- F1 Score
- Confusion Matrix

### **7. Decision Trees**
**Valid Metrics:**
- Accuracy
- Logarithmic Loss (with probability outputs)
- Area Under Curve (ROC-AUC)
- Precision
- Recall
- F1 Score
- Confusion Matrix

### **8. Support Vector Machines (SVM)**
**Valid Metrics:**
- Accuracy
- Logarithmic Loss (only with `probability=True`)
- Area Under Curve (ROC-AUC)
- Precision
- Recall
- F1 Score
- Confusion Matrix

## **ENSEMBLE METHODS (from Model Performance section)**

### **9. Random Forests**
**Valid Metrics:**
- **For classification:**
  - Accuracy
  - Logarithmic Loss
  - Area Under Curve (ROC-AUC)
  - Precision
  - Recall
  - F1 Score
  - Confusion Matrix
- **For regression:**
  - Mean Absolute Error (MAE)
  - Mean Squared Error (MSE)
  - Root Mean Squared Error (RMSE)
  - R-squared (R²) Score

### **10. Bagging Methods**
**Valid Metrics:** (Depend on base estimator)
- If classification base: All classification metrics
- If regression base: All regression metrics

### **11. Boosting Methods**
**Valid Metrics:** (Depend on base estimator)
- If classification base: All classification metrics
- If regression base: All regression metrics

## **UNSUPERVISED LEARNING MODELS**

### **12. K-Means Clustering**
**Valid Metrics:**
- **Clustering metrics ONLY:**
  - Silhouette Score
  - Davies-Bouldin Index
  - Calinski-Harabasz Index
  - Inertia (Within-cluster sum of squares)
- **NOT valid:** Any supervised metric (MAE, Accuracy, etc.)

### **13. Hierarchical Clustering**
**Valid Metrics:**
- **Clustering metrics ONLY:**
  - Silhouette Score
  - Davies-Bouldin Index
  - Calinski-Harabasz Index
  - Cophenetic Correlation Coefficient

### **14. Association Rules (Market Basket Analysis)**
**Valid Metrics:**
- Support
- Confidence
- Lift
- Conviction
- **NOT valid:** Standard ML metrics

## **NEURAL NETWORKS**

### **15. Multi-layer Perceptron (MLP)**
**Valid Metrics:**
- **For classification:**
  - Accuracy
  - Logarithmic Loss
  - Area Under Curve (ROC-AUC)
  - Precision
  - Recall
  - F1 Score
  - Confusion Matrix
- **For regression:**
  - Mean Absolute Error (MAE)
  - Mean Squared Error (MSE)
  - Root Mean Squared Error (RMSE)
  - R-squared (R²) Score

### **16. Convolutional Neural Networks (CNN)**
**Valid Metrics:**
- **For classification:**
  - Accuracy
  - Logarithmic Loss
  - Area Under Curve (ROC-AUC)
  - Precision
  - Recall
  - F1 Score
  - Confusion Matrix
- **For regression:**
  - Mean Absolute Error (MAE)
  - Mean Squared Error (MSE)
  - Root Mean Squared Error (RMSE)
  - R-squared (R²) Score

### **17. Recurrent Neural Networks (RNN)**
**Valid Metrics:**
- **For classification:**
  - Accuracy
  - Logarithmic Loss
  - Area Under Curve (ROC-AUC)
  - Precision
  - Recall
  - F1 Score
  - Confusion Matrix
- **For regression:**
  - Mean Absolute Error (MAE)
  - Mean Squared Error (MSE)
  - Root Mean Squared Error (RMSE)
  - R-squared (R²) Score

## **DIMENSIONALITY REDUCTION**

### **18. Principal Component Analysis (PCA)**
**Valid Metrics:**
- Explained Variance Ratio
- Cumulative Explained Variance
- Reconstruction Error
- **NOT valid:** Supervised metrics

## **SUMMARY TABLE BY MODEL TYPE**

| Model | Regression Metrics | Classification Metrics | Special Notes |
|-------|-------------------|-----------------------|---------------|
| **Linear Regression** | MAE, MSE, RMSE, R² | ❌ | Only for regression |
| **Polynomial Regression** | MAE, MSE, RMSE, R² | ❌ | Only for regression |
| **Logistic Regression** | ❌ | All classification metrics | Binary/Multiclass |
| **K-Nearest Neighbors** | MAE, MSE, RMSE, R² | All classification metrics | Can do both |
| **Naïve Bayes** | ❌ | All classification metrics | Probabilistic |
| **Decision Trees** | MAE, MSE, RMSE, R² | All classification metrics | Can do both |
| **SVM** | MAE, MSE, RMSE, R² | All classification metrics | Can do both |
| **Random Forests** | MAE, MSE, RMSE, R² | All classification metrics | Ensemble, can do both |
| **Neural Networks** | MAE, MSE, RMSE, R² | All classification metrics | Can do both |
| **K-Means** | ❌ | ❌ | Unsupervised only |
| **Hierarchical Clustering** | ❌ | ❌ | Unsupervised only |
| **Association Rules** | ❌ | ❌ | Pattern mining metrics |
| **PCA** | ❌ | ❌ | Dimensionality reduction |

## **KEY TAKEAWAYS:**

1. **Regression models** → Use: MAE, MSE, RMSE, R²
2. **Classification models** → Use: Accuracy, Log Loss, AUC, Precision, Recall, F1, Confusion Matrix
3. **Models that can do both** (KNN, Trees, SVM, RF, NN):
   - Choose metrics based on **task type**
   - Some need configuration (SVM needs `probability=True` for Log Loss)
4. **Unsupervised models** → Use **specialized metrics** for clustering/pattern mining
5. **Log Loss and ROC-AUC** require **probability outputs** from models

## **QUICK REFERENCE FOR METRIC SELECTION:**

```python
# For REGRESSION problems:
metrics = ['MAE', 'MSE', 'RMSE', 'R²']

# For CLASSIFICATION problems:
metrics = ['Accuracy', 'Log_Loss', 'ROC_AUC', 'Precision', 'Recall', 'F1', 'Confusion_Matrix']

# For CLUSTERING problems:
metrics = ['Silhouette_Score', 'Davies-Bouldin', 'Inertia']

# For ASSOCIATION RULES:
metrics = ['Support', 'Confidence', 'Lift']
```

**Remember**: Always match the metric to both the **model type** and the **problem type** (regression vs classification vs clustering).