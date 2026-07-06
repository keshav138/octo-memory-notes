```python
"""
Supervised Learning: Classification Algorithms
Complete implementation with evaluation metrics using scikit-learn
"""

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import load_iris, load_breast_cancer
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.tree import DecisionTreeClassifier, plot_tree
from sklearn.svm import SVC
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    confusion_matrix, log_loss, roc_curve, roc_auc_score,
    classification_report
)
import warnings
warnings.filterwarnings('ignore')

# Set random seed for reproducibility
np.random.seed(42)

print("="*80)
print("SUPERVISED LEARNING: CLASSIFICATION ALGORITHMS")
print("="*80)

# ============================================================================
# LOAD AND PREPARE DATA
# ============================================================================
print("\n" + "="*80)
print("LOADING DATASETS")
print("="*80)

# Load Iris dataset (multiclass classification)
iris = load_iris()
X_iris, y_iris = iris.data, iris.target
print(f"\nIris Dataset: {X_iris.shape[0]} samples, {X_iris.shape[1]} features, {len(np.unique(y_iris))} classes")

# Load Breast Cancer dataset (binary classification)
cancer = load_breast_cancer()
X_cancer, y_cancer = cancer.data, cancer.target
print(f"Breast Cancer Dataset: {X_cancer.shape[0]} samples, {X_cancer.shape[1]} features, {len(np.unique(y_cancer))} classes")

# We'll use Iris for most examples and Cancer for binary metrics
X_train, X_test, y_train, y_test = train_test_split(
    X_iris, y_iris, test_size=0.3, random_state=42, stratify=y_iris
)

# For binary classification metrics
X_train_bc, X_test_bc, y_train_bc, y_test_bc = train_test_split(
    X_cancer, y_cancer, test_size=0.3, random_state=42, stratify=y_cancer
)

# Feature scaling (important for KNN and SVM)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

X_train_bc_scaled = scaler.fit_transform(X_train_bc)
X_test_bc_scaled = scaler.transform(X_test_bc)

# ============================================================================
# 1. K-NEAREST NEIGHBORS (KNN)
# ============================================================================
print("\n" + "="*80)
print("1. K-NEAREST NEIGHBORS (KNN) - LAZY LEARNING")
print("="*80)

# Train KNN with different K values
k_values = [1, 3, 5, 7, 9]
knn_accuracies = []

for k in k_values:
    knn = KNeighborsClassifier(n_neighbors=k)
    knn.fit(X_train_scaled, y_train)
    acc = knn.score(X_test_scaled, y_test)
    knn_accuracies.append(acc)
    print(f"K={k}: Accuracy = {acc:.4f}")

# Use optimal K=3 for detailed evaluation
knn_optimal = KNeighborsClassifier(n_neighbors=3)
knn_optimal.fit(X_train_scaled, y_train)
y_pred_knn = knn_optimal.predict(X_test_scaled)

print(f"\nOptimal KNN (K=3) Performance:")
print(f"Accuracy: {accuracy_score(y_test, y_pred_knn):.4f}")
print(f"\nClassification Report:")
print(classification_report(y_test, y_pred_knn, target_names=iris.target_names))

# ============================================================================
# 2. NAÏVE BAYES
# ============================================================================
print("\n" + "="*80)
print("2. NAÏVE BAYES CLASSIFIER")
print("="*80)

# Train Gaussian Naïve Bayes
nb = GaussianNB()
nb.fit(X_train, y_train)
y_pred_nb = nb.predict(X_test)
y_proba_nb = nb.predict_proba(X_test)

print(f"Naïve Bayes Performance:")
print(f"Accuracy: {accuracy_score(y_test, y_pred_nb):.4f}")
print(f"\nClass Prior Probabilities:")
for i, prior in enumerate(nb.class_prior_):
    print(f"  {iris.target_names[i]}: {prior:.4f}")
print(f"\nClassification Report:")
print(classification_report(y_test, y_pred_nb, target_names=iris.target_names))

# ============================================================================
# 3. DECISION TREE
# ============================================================================
print("\n" + "="*80)
print("3. DECISION TREE - DIVIDE AND CONQUER")
print("="*80)

# Train Decision Tree with different max depths
depths = [2, 3, 5, None]
dt_accuracies = []

for depth in depths:
    dt = DecisionTreeClassifier(max_depth=depth, random_state=42)
    dt.fit(X_train, y_train)
    acc = dt.score(X_test, y_test)
    dt_accuracies.append(acc)
    depth_str = str(depth) if depth else "Unlimited"
    print(f"Max Depth={depth_str}: Accuracy = {acc:.4f}")

# Use optimal depth for detailed evaluation
dt_optimal = DecisionTreeClassifier(max_depth=3, random_state=42)
dt_optimal.fit(X_train, y_train)
y_pred_dt = dt_optimal.predict(X_test)

print(f"\nOptimal Decision Tree (depth=3) Performance:")
print(f"Accuracy: {accuracy_score(y_test, y_pred_dt):.4f}")
print(f"Number of leaves: {dt_optimal.get_n_leaves()}")
print(f"Tree depth: {dt_optimal.get_depth()}")
print(f"\nFeature Importances:")
for i, importance in enumerate(dt_optimal.feature_importances_):
    print(f"  {iris.feature_names[i]}: {importance:.4f}")

# ============================================================================
# 4. SUPPORT VECTOR MACHINE (SVM)
# ============================================================================
print("\n" + "="*80)
print("4. SUPPORT VECTOR MACHINE (SVM)")
print("="*80)

# Train SVM with different kernels
kernels = ['linear', 'rbf', 'poly']
svm_accuracies = []

for kernel in kernels:
    svm = SVC(kernel=kernel, random_state=42)
    svm.fit(X_train_scaled, y_train)
    acc = svm.score(X_test_scaled, y_test)
    svm_accuracies.append(acc)
    print(f"Kernel={kernel}: Accuracy = {acc:.4f}")

# Use RBF kernel for detailed evaluation
svm_optimal = SVC(kernel='rbf', probability=True, random_state=42)
svm_optimal.fit(X_train_scaled, y_train)
y_pred_svm = svm_optimal.predict(X_test_scaled)

print(f"\nOptimal SVM (RBF kernel) Performance:")
print(f"Accuracy: {accuracy_score(y_test, y_pred_svm):.4f}")
print(f"Number of support vectors: {svm_optimal.n_support_}")
print(f"Support vectors per class: {svm_optimal.n_support_}")

# ============================================================================
# 5. MODEL PERFORMANCE EVALUATION
# ============================================================================
print("\n" + "="*80)
print("5. MODEL PERFORMANCE EVALUATION METRICS")
print("="*80)

# For detailed metrics, use binary classification (Breast Cancer dataset)
print("\nUsing Breast Cancer dataset for binary classification metrics...")

# Train models on binary dataset
models_binary = {
    'KNN': KNeighborsClassifier(n_neighbors=5),
    'Naive Bayes': GaussianNB(),
    'Decision Tree': DecisionTreeClassifier(max_depth=5, random_state=42),
    'SVM': SVC(kernel='rbf', probability=True, random_state=42)
}

results = {}
for name, model in models_binary.items():
    if name in ['KNN', 'SVM']:
        model.fit(X_train_bc_scaled, y_train_bc)
        y_pred = model.predict(X_test_bc_scaled)
        y_proba = model.predict_proba(X_test_bc_scaled)[:, 1]
    else:
        model.fit(X_train_bc, y_train_bc)
        y_pred = model.predict(X_test_bc)
        y_proba = model.predict_proba(X_test_bc)[:, 1]
    
    results[name] = {
        'y_pred': y_pred,
        'y_proba': y_proba
    }

# ============================================================================
# ACCURACY
# ============================================================================
print("\n" + "-"*80)
print("ACCURACY: (TP + TN) / Total")
print("-"*80)
for name in models_binary.keys():
    y_pred = results[name]['y_pred']
    acc = accuracy_score(y_test_bc, y_pred)
    print(f"{name:15s}: {acc:.4f}")

# ============================================================================
# CONFUSION MATRIX
# ============================================================================
print("\n" + "-"*80)
print("CONFUSION MATRIX")
print("-"*80)
for name in models_binary.keys():
    y_pred = results[name]['y_pred']
    cm = confusion_matrix(y_test_bc, y_pred)
    print(f"\n{name}:")
    print(f"              Predicted")
    print(f"            Neg    Pos")
    print(f"Actual Neg  {cm[0,0]:3d}    {cm[0,1]:3d}  (TN={cm[0,0]}, FP={cm[0,1]})")
    print(f"       Pos  {cm[1,0]:3d}    {cm[1,1]:3d}  (FN={cm[1,0]}, TP={cm[1,1]})")

# ============================================================================
# PRECISION, RECALL, F1 SCORE
# ============================================================================
print("\n" + "-"*80)
print("PRECISION, RECALL, F1 SCORE")
print("-"*80)
print(f"{'Model':<15} {'Precision':>10} {'Recall':>10} {'F1 Score':>10}")
print("-"*50)
for name in models_binary.keys():
    y_pred = results[name]['y_pred']
    prec = precision_score(y_test_bc, y_pred)
    rec = recall_score(y_test_bc, y_pred)
    f1 = f1_score(y_test_bc, y_pred)
    print(f"{name:<15} {prec:>10.4f} {rec:>10.4f} {f1:>10.4f}")

print("\nInterpretation:")
print("- Precision: Of predicted positive, how many were actually positive")
print("- Recall: Of actual positive, how many did we identify")
print("- F1 Score: Harmonic mean of precision and recall")

# ============================================================================
# LOGARITHMIC LOSS
# ============================================================================
print("\n" + "-"*80)
print("LOGARITHMIC LOSS (Log Loss) - Lower is Better")
print("-"*80)
for name in models_binary.keys():
    y_proba = results[name]['y_proba']
    logloss = log_loss(y_test_bc, y_proba)
    print(f"{name:15s}: {logloss:.4f}")

print("\nInterpretation:")
print("- Measures uncertainty of predictions")
print("- Penalizes confident wrong predictions heavily")
print("- Range: 0 (perfect) to infinity (worst)")

# ============================================================================
# AUC-ROC
# ============================================================================
print("\n" + "-"*80)
print("AREA UNDER ROC CURVE (AUC-ROC)")
print("-"*80)
for name in models_binary.keys():
    y_proba = results[name]['y_proba']
    auc = roc_auc_score(y_test_bc, y_proba)
    print(f"{name:15s}: {auc:.4f}")

print("\nInterpretation:")
print("- 1.0: Perfect classifier")
print("- 0.5: Random classifier")
print("- Threshold-independent metric")

# ============================================================================
# VISUALIZATIONS
# ============================================================================
print("\n" + "="*80)
print("GENERATING VISUALIZATIONS")
print("="*80)

fig = plt.figure(figsize=(16, 12))

# 1. KNN - Effect of K
plt.subplot(3, 3, 1)
plt.plot(k_values, knn_accuracies, marker='o', linewidth=2, markersize=8)
plt.xlabel('Number of Neighbors (K)')
plt.ylabel('Accuracy')
plt.title('KNN: Effect of K on Accuracy')
plt.grid(True, alpha=0.3)

# 2. Decision Tree Visualization
plt.subplot(3, 3, 2)
plot_tree(dt_optimal, feature_names=iris.feature_names, 
          class_names=iris.target_names, filled=True, fontsize=8)
plt.title('Decision Tree Structure (depth=3)')

# 3. Feature Importances (Decision Tree)
plt.subplot(3, 3, 3)
importances = dt_optimal.feature_importances_
indices = np.argsort(importances)[::-1]
plt.bar(range(len(importances)), importances[indices])
plt.xticks(range(len(importances)), [iris.feature_names[i] for i in indices], rotation=45, ha='right')
plt.ylabel('Importance')
plt.title('Feature Importances (Decision Tree)')
plt.tight_layout()

# 4. Algorithm Comparison (Accuracy)
plt.subplot(3, 3, 4)
model_names = ['KNN', 'Naive Bayes', 'Decision Tree', 'SVM']
accuracies_comparison = [
    accuracy_score(y_test, y_pred_knn),
    accuracy_score(y_test, y_pred_nb),
    accuracy_score(y_test, y_pred_dt),
    accuracy_score(y_test, y_pred_svm)
]
colors = ['#3498db', '#e74c3c', '#2ecc71', '#f39c12']
bars = plt.bar(model_names, accuracies_comparison, color=colors, alpha=0.8)
plt.ylabel('Accuracy')
plt.title('Algorithm Comparison (Iris Dataset)')
plt.ylim([0.8, 1.0])
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{height:.3f}', ha='center', va='bottom')
plt.xticks(rotation=45, ha='right')

# 5. Confusion Matrix Heatmap (KNN on binary)
plt.subplot(3, 3, 5)
cm_knn_bc = confusion_matrix(y_test_bc, results['KNN']['y_pred'])
sns.heatmap(cm_knn_bc, annot=True, fmt='d', cmap='Blues', 
            xticklabels=['Malignant', 'Benign'],
            yticklabels=['Malignant', 'Benign'])
plt.title('Confusion Matrix - KNN')
plt.ylabel('Actual')
plt.xlabel('Predicted')

# 6. Precision, Recall, F1 Comparison
plt.subplot(3, 3, 6)
metrics_data = []
for name in models_binary.keys():
    y_pred = results[name]['y_pred']
    metrics_data.append([
        precision_score(y_test_bc, y_pred),
        recall_score(y_test_bc, y_pred),
        f1_score(y_test_bc, y_pred)
    ])
metrics_data = np.array(metrics_data)
x = np.arange(len(models_binary))
width = 0.25
plt.bar(x - width, metrics_data[:, 0], width, label='Precision', alpha=0.8)
plt.bar(x, metrics_data[:, 1], width, label='Recall', alpha=0.8)
plt.bar(x + width, metrics_data[:, 2], width, label='F1 Score', alpha=0.8)
plt.xlabel('Model')
plt.ylabel('Score')
plt.title('Precision, Recall, F1 Comparison')
plt.xticks(x, models_binary.keys(), rotation=45, ha='right')
plt.legend()
plt.ylim([0.8, 1.0])

# 7. ROC Curves
plt.subplot(3, 3, 7)
for name in models_binary.keys():
    y_proba = results[name]['y_proba']
    fpr, tpr, _ = roc_curve(y_test_bc, y_proba)
    auc = roc_auc_score(y_test_bc, y_proba)
    plt.plot(fpr, tpr, label=f'{name} (AUC={auc:.3f})', linewidth=2)
plt.plot([0, 1], [0, 1], 'k--', label='Random (AUC=0.5)', linewidth=1)
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('ROC Curves')
plt.legend(loc='lower right')
plt.grid(True, alpha=0.3)

# 8. Log Loss Comparison
plt.subplot(3, 3, 8)
log_losses = [log_loss(y_test_bc, results[name]['y_proba']) 
              for name in models_binary.keys()]
bars = plt.bar(models_binary.keys(), log_losses, alpha=0.8, color=colors)
plt.ylabel('Log Loss (lower is better)')
plt.title('Log Loss Comparison')
plt.xticks(rotation=45, ha='right')
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{height:.3f}', ha='center', va='bottom')

# 9. AUC Comparison
plt.subplot(3, 3, 9)
aucs = [roc_auc_score(y_test_bc, results[name]['y_proba']) 
        for name in models_binary.keys()]
bars = plt.bar(models_binary.keys(), aucs, alpha=0.8, color=colors)
plt.ylabel('AUC Score')
plt.title('AUC-ROC Comparison')
plt.ylim([0.9, 1.0])
plt.xticks(rotation=45, ha='right')
for bar in bars:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{height:.3f}', ha='center', va='bottom')

plt.tight_layout()
plt.savefig('classification_algorithms_comprehensive.png', dpi=150, bbox_inches='tight')
print("Visualization saved as 'classification_algorithms_comprehensive.png'")

# ============================================================================
# SUMMARY TABLE
# ============================================================================
print("\n" + "="*80)
print("FINAL SUMMARY TABLE (Binary Classification - Breast Cancer Dataset)")
print("="*80)
print(f"{'Model':<15} {'Accuracy':>9} {'Precision':>10} {'Recall':>9} {'F1':>7} {'Log Loss':>9} {'AUC':>7}")
print("-"*80)
for name in models_binary.keys():
    y_pred = results[name]['y_pred']
    y_proba = results[name]['y_proba']
    acc = accuracy_score(y_test_bc, y_pred)
    prec = precision_score(y_test_bc, y_pred)
    rec = recall_score(y_test_bc, y_pred)
    f1 = f1_score(y_test_bc, y_pred)
    ll = log_loss(y_test_bc, y_proba)
    auc = roc_auc_score(y_test_bc, y_proba)
    print(f"{name:<15} {acc:>9.4f} {prec:>10.4f} {rec:>9.4f} {f1:>7.4f} {ll:>9.4f} {auc:>7.4f}")

print("\n" + "="*80)
print("EXECUTION COMPLETE")
print("="*80)

```