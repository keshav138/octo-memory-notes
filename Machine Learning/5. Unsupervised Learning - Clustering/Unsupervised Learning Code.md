```python

"""
Unsupervised Learning: Clustering and Association Rules
Complete implementation with visualizations using scikit-learn
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import make_blobs, load_iris, load_wine
from sklearn.cluster import KMeans, AgglomerativeClustering
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import silhouette_score, silhouette_samples
from scipy.cluster.hierarchy import dendrogram, linkage
from scipy.spatial.distance import cdist
from itertools import combinations
import warnings
warnings.filterwarnings('ignore')

# Set random seed and style
np.random.seed(42)
sns.set_style("whitegrid")

print("="*80)
print("UNSUPERVISED LEARNING: CLUSTERING & ASSOCIATION RULES")
print("="*80)

# ============================================================================
# 1. K-MEANS CLUSTERING - BASIC IMPLEMENTATION
# ============================================================================
print("\n" + "="*80)
print("1. K-MEANS CLUSTERING - BASIC IMPLEMENTATION")
print("="*80)

# Generate synthetic data
X_synthetic, y_true = make_blobs(n_samples=300, centers=4, n_features=2, 
                                  cluster_std=0.6, random_state=42)

print(f"Generated synthetic data: {X_synthetic.shape[0]} samples, {X_synthetic.shape[1]} features")

# Apply K-Means
kmeans = KMeans(n_clusters=4, random_state=42, n_init=10)
y_kmeans = kmeans.fit_predict(X_synthetic)

print(f"\nCluster Centers:")
for i, center in enumerate(kmeans.cluster_centers_):
    print(f"  Cluster {i}: [{center[0]:.3f}, {center[1]:.3f}]")

print(f"\nCluster Sizes:")
unique, counts = np.unique(y_kmeans, return_counts=True)
for cluster, count in zip(unique, counts):
    print(f"  Cluster {cluster}: {count} points")

print(f"\nInertia (WCSS): {kmeans.inertia_:.3f}")
print(f"Number of iterations: {kmeans.n_iter_}")

# ============================================================================
# 2. K-MEANS RANDOM INITIALIZATION TRAP
# ============================================================================
print("\n" + "="*80)
print("2. K-MEANS RANDOM INITIALIZATION TRAP")
print("="*80)

# Run K-Means with different random initializations
n_runs = 10
inertias = []
print(f"Running K-Means {n_runs} times with different random initializations:")

for i in range(n_runs):
    kmeans_run = KMeans(n_clusters=4, random_state=i, n_init=1)
    kmeans_run.fit(X_synthetic)
    inertias.append(kmeans_run.inertia_)
    print(f"  Run {i+1}: Inertia = {kmeans_run.inertia_:.3f}")

print(f"\nInertia Statistics:")
print(f"  Best (lowest): {np.min(inertias):.3f}")
print(f"  Worst (highest): {np.max(inertias):.3f}")
print(f"  Mean: {np.mean(inertias):.3f}")
print(f"  Std Dev: {np.std(inertias):.3f}")
print(f"  Difference: {np.max(inertias) - np.min(inertias):.3f}")

# Compare random init vs K-Means++
kmeans_random = KMeans(n_clusters=4, init='random', n_init=1, random_state=42)
kmeans_plus = KMeans(n_clusters=4, init='k-means++', n_init=1, random_state=42)

kmeans_random.fit(X_synthetic)
kmeans_plus.fit(X_synthetic)

print(f"\nComparison:")
print(f"  Random initialization: Inertia = {kmeans_random.inertia_:.3f}")
print(f"  K-Means++ initialization: Inertia = {kmeans_plus.inertia_:.3f}")
print(f"  Improvement: {((kmeans_random.inertia_ - kmeans_plus.inertia_) / kmeans_random.inertia_ * 100):.2f}%")

# ============================================================================
# 3. SELECTING NUMBER OF CLUSTERS - ELBOW METHOD
# ============================================================================
print("\n" + "="*80)
print("3. SELECTING NUMBER OF CLUSTERS - ELBOW METHOD")
print("="*80)

# Load Iris dataset for realistic clustering
iris = load_iris()
X_iris = iris.data
X_iris_scaled = StandardScaler().fit_transform(X_iris)

# Elbow Method: Calculate inertia for different K values
K_range = range(1, 11)
inertias_elbow = []
silhouette_scores = []

print("Computing metrics for K = 1 to 10:")
for k in K_range:
    kmeans_k = KMeans(n_clusters=k, random_state=42, n_init=10)
    kmeans_k.fit(X_iris_scaled)
    inertias_elbow.append(kmeans_k.inertia_)
    
    if k > 1:  # Silhouette score requires at least 2 clusters
        silhouette_avg = silhouette_score(X_iris_scaled, kmeans_k.labels_)
        silhouette_scores.append(silhouette_avg)
        print(f"  K={k}: Inertia={kmeans_k.inertia_:.3f}, Silhouette={silhouette_avg:.3f}")
    else:
        silhouette_scores.append(0)
        print(f"  K={k}: Inertia={kmeans_k.inertia_:.3f}")

# Find optimal K using silhouette score
optimal_k = np.argmax(silhouette_scores[1:]) + 2  # +2 because we start from K=2
print(f"\nOptimal K based on Silhouette Score: {optimal_k}")
print(f"  Silhouette Score: {silhouette_scores[optimal_k-1]:.3f}")

# ============================================================================
# 4. SILHOUETTE ANALYSIS
# ============================================================================
print("\n" + "="*80)
print("4. DETAILED SILHOUETTE ANALYSIS")
print("="*80)

# Perform detailed silhouette analysis for K=2,3,4
for k in [2, 3, 4]:
    kmeans_sil = KMeans(n_clusters=k, random_state=42, n_init=10)
    cluster_labels = kmeans_sil.fit_predict(X_iris_scaled)
    
    silhouette_avg = silhouette_score(X_iris_scaled, cluster_labels)
    sample_silhouette_values = silhouette_samples(X_iris_scaled, cluster_labels)
    
    print(f"\nK = {k}:")
    print(f"  Average Silhouette Score: {silhouette_avg:.3f}")
    
    for i in range(k):
        cluster_silhouette_values = sample_silhouette_values[cluster_labels == i]
        print(f"  Cluster {i}: Mean={cluster_silhouette_values.mean():.3f}, "
              f"Size={len(cluster_silhouette_values)}")

# ============================================================================
# 5. HIERARCHICAL CLUSTERING - AGGLOMERATIVE
# ============================================================================
print("\n" + "="*80)
print("5. HIERARCHICAL CLUSTERING - AGGLOMERATIVE")
print("="*80)

# Use smaller subset for visualization
X_small = X_iris_scaled[:50]
y_small = iris.target[:50]

# Test different linkages
linkages = ['single', 'complete', 'average', 'ward']
print("Testing different linkage methods:")

for linkage_method in linkages:
    agg_clustering = AgglomerativeClustering(n_clusters=3, linkage=linkage_method)
    labels = agg_clustering.fit_predict(X_small)
    
    # Calculate silhouette score
    sil_score = silhouette_score(X_small, labels)
    print(f"  {linkage_method.capitalize():10s} Linkage: Silhouette Score = {sil_score:.3f}")

# Detailed analysis with Ward linkage (best performer)
print("\n" + "-"*80)
print("WARD LINKAGE DETAILED ANALYSIS")
print("-"*80)

agg_ward = AgglomerativeClustering(n_clusters=3, linkage='ward')
labels_ward = agg_ward.fit_predict(X_iris_scaled)

print(f"Number of clusters: {len(np.unique(labels_ward))}")
print(f"Cluster distribution:")
unique, counts = np.unique(labels_ward, return_counts=True)
for cluster, count in zip(unique, counts):
    print(f"  Cluster {cluster}: {count} samples")

# ============================================================================
# 6. HIERARCHICAL CLUSTERING - DIVISIVE (CONCEPTUAL)
# ============================================================================
print("\n" + "="*80)
print("6. HIERARCHICAL CLUSTERING - DIVISIVE (CONCEPTUAL)")
print("="*80)

print("Divisive clustering starts with all points in one cluster and")
print("recursively splits into smaller clusters. Less common in practice.")
print("\nSimulating divisive approach using recursive K-Means (K=2):")

def divisive_clustering(X, max_clusters=4, current_depth=0):
    """Simulate divisive clustering using K-Means with K=2"""
    if len(X) < 10 or current_depth >= max_clusters - 1:
        return [X]
    
    # Split into 2 clusters
    kmeans_2 = KMeans(n_clusters=2, random_state=42, n_init=10)
    labels = kmeans_2.fit_predict(X)
    
    clusters = []
    for i in range(2):
        cluster_points = X[labels == i]
        print(f"  {'  ' * current_depth}Split: {len(cluster_points)} points")
        # Recursively split each cluster
        sub_clusters = divisive_clustering(cluster_points, max_clusters, current_depth + 1)
        clusters.extend(sub_clusters)
    
    return clusters

print(f"Starting with {len(X_small)} points")
divisive_clusters = divisive_clustering(X_small, max_clusters=3)
print(f"Final number of leaf clusters: {len(divisive_clusters)}")

# ============================================================================
# 7. COMPARING LINKAGE TYPES
# ============================================================================
print("\n" + "="*80)
print("7. COMPARING DIFFERENT LINKAGE TYPES")
print("="*80)

# Create dataset with different cluster shapes
X_varied, _ = make_blobs(n_samples=200, centers=3, n_features=2, 
                         cluster_std=[0.5, 1.0, 0.3], random_state=42)

linkage_results = {}
print("Applying different linkages to dataset with varied cluster shapes:")

for linkage_method in linkages:
    agg = AgglomerativeClustering(n_clusters=3, linkage=linkage_method)
    labels = agg.fit_predict(X_varied)
    sil_score = silhouette_score(X_varied, labels)
    linkage_results[linkage_method] = {
        'labels': labels,
        'silhouette': sil_score
    }
    print(f"  {linkage_method.capitalize():10s}: Silhouette = {sil_score:.3f}")

# ============================================================================
# 8. ASSOCIATION RULES - MARKET BASKET ANALYSIS
# ============================================================================
print("\n" + "="*80)
print("8. ASSOCIATION RULES - MARKET BASKET ANALYSIS")
print("="*80)

# Create synthetic transaction data
np.random.seed(42)
transactions = []
items = ['Milk', 'Bread', 'Butter', 'Beer', 'Diapers', 'Eggs', 'Cheese', 'Yogurt']

# Generate 1000 transactions with some patterns
for _ in range(1000):
    transaction = []
    
    # Bread and Butter often together
    if np.random.random() < 0.3:
        transaction.extend(['Bread', 'Butter'])
    elif np.random.random() < 0.2:
        transaction.append('Bread')
    
    # Beer and Diapers correlation
    if np.random.random() < 0.15:
        transaction.extend(['Beer', 'Diapers'])
    
    # Milk is common
    if np.random.random() < 0.4:
        transaction.append('Milk')
    
    # Eggs common
    if np.random.random() < 0.25:
        transaction.append('Eggs')
    
    # Cheese and Yogurt
    if np.random.random() < 0.2:
        transaction.extend(['Cheese', 'Yogurt'])
    
    # Random items
    if np.random.random() < 0.1:
        transaction.append(np.random.choice(items))
    
    transactions.append(list(set(transaction)))  # Remove duplicates

print(f"Generated {len(transactions)} transactions")
print(f"Sample transactions:")
for i in range(5):
    print(f"  Transaction {i+1}: {transactions[i]}")

# ============================================================================
# APRIORI ALGORITHM IMPLEMENTATION (SIMPLIFIED)
# ============================================================================
print("\n" + "-"*80)
print("IMPLEMENTING APRIORI ALGORITHM")
print("-"*80)

def calculate_support(transactions, itemset):
    """Calculate support for an itemset"""
    count = sum(1 for transaction in transactions if itemset.issubset(set(transaction)))
    return count / len(transactions)

def get_frequent_itemsets(transactions, min_support=0.05):
    """Find frequent itemsets using Apriori algorithm"""
    
    # Get all unique items
    all_items = set()
    for transaction in transactions:
        all_items.update(transaction)
    
    # Find frequent 1-itemsets
    frequent_itemsets = {}
    for item in all_items:
        support = calculate_support(transactions, {item})
        if support >= min_support:
            frequent_itemsets[frozenset([item])] = support
    
    print(f"Found {len(frequent_itemsets)} frequent 1-itemsets")
    
    # Find frequent 2-itemsets
    frequent_2itemsets = {}
    items_list = list(frequent_itemsets.keys())
    
    for i in range(len(items_list)):
        for j in range(i+1, len(items_list)):
            itemset = items_list[i] | items_list[j]
            support = calculate_support(transactions, itemset)
            if support >= min_support:
                frequent_2itemsets[itemset] = support
    
    print(f"Found {len(frequent_2itemsets)} frequent 2-itemsets")
    
    frequent_itemsets.update(frequent_2itemsets)
    return frequent_itemsets

def generate_rules(frequent_itemsets, min_confidence=0.5):
    """Generate association rules from frequent itemsets"""
    rules = []
    
    # Only consider 2-itemsets for rules
    for itemset, support in frequent_itemsets.items():
        if len(itemset) == 2:
            items = list(itemset)
            
            # Rule: items[0] -> items[1]
            antecedent = frozenset([items[0]])
            consequent = frozenset([items[1]])
            
            if antecedent in frequent_itemsets:
                confidence = support / frequent_itemsets[antecedent]
                lift = confidence / frequent_itemsets[consequent]
                
                if confidence >= min_confidence:
                    rules.append({
                        'antecedent': list(antecedent),
                        'consequent': list(consequent),
                        'support': support,
                        'confidence': confidence,
                        'lift': lift
                    })
            
            # Rule: items[1] -> items[0]
            antecedent = frozenset([items[1]])
            consequent = frozenset([items[0]])
            
            if antecedent in frequent_itemsets:
                confidence = support / frequent_itemsets[antecedent]
                lift = confidence / frequent_itemsets[consequent]
                
                if confidence >= min_confidence:
                    rules.append({
                        'antecedent': list(antecedent),
                        'consequent': list(consequent),
                        'support': support,
                        'confidence': confidence,
                        'lift': lift
                    })
    
    return rules

# Apply Apriori
min_support = 0.1
min_confidence = 0.4

print(f"\nApriori Parameters:")
print(f"  Minimum Support: {min_support*100:.0f}%")
print(f"  Minimum Confidence: {min_confidence*100:.0f}%")

frequent_itemsets = get_frequent_itemsets(transactions, min_support)

print(f"\nFrequent Itemsets (Support >= {min_support*100:.0f}%):")
sorted_itemsets = sorted(frequent_itemsets.items(), key=lambda x: x[1], reverse=True)
for itemset, support in sorted_itemsets[:10]:
    print(f"  {set(itemset)}: {support:.3f}")

# Generate rules
rules = generate_rules(frequent_itemsets, min_confidence)
print(f"\nGenerated {len(rules)} association rules")

# Sort rules by lift
rules_sorted = sorted(rules, key=lambda x: x['lift'], reverse=True)

print(f"\nTop 10 Association Rules (by Lift):")
print(f"{'Rule':<30} {'Support':>8} {'Conf':>8} {'Lift':>8}")
print("-"*60)
for rule in rules_sorted[:10]:
    rule_str = f"{rule['antecedent'][0]} → {rule['consequent'][0]}"
    print(f"{rule_str:<30} {rule['support']:>8.3f} {rule['confidence']:>8.3f} {rule['lift']:>8.3f}")

# ============================================================================
# MARKET BASKET INSIGHTS
# ============================================================================
print("\n" + "-"*80)
print("MARKET BASKET ANALYSIS - BUSINESS INSIGHTS")
print("-"*80)

print("\nActionable Rules (Lift > 1.2, Confidence > 50%):")
actionable_rules = [r for r in rules_sorted if r['lift'] > 1.2 and r['confidence'] > 0.5]

for i, rule in enumerate(actionable_rules[:5], 1):
    print(f"\n{i}. {rule['antecedent'][0]} → {rule['consequent'][0]}")
    print(f"   Support: {rule['support']*100:.1f}% of transactions")
    print(f"   Confidence: {rule['confidence']*100:.1f}% likelihood")
    print(f"   Lift: {rule['lift']:.2f}x more likely than random")
    
    # Business recommendation
    if rule['lift'] > 2.0:
        print(f"   ★ STRONG association - Consider bundling these items")
    elif rule['lift'] > 1.5:
        print(f"   ★ MODERATE association - Consider cross-promotion")
    else:
        print(f"   ★ WEAK association - Monitor for seasonal patterns")

# ============================================================================
# VISUALIZATIONS
# ============================================================================
print("\n" + "="*80)
print("GENERATING VISUALIZATIONS")
print("="*80)

fig = plt.figure(figsize=(18, 12))

# 1. K-Means Basic Clustering
ax1 = plt.subplot(3, 4, 1)
scatter = ax1.scatter(X_synthetic[:, 0], X_synthetic[:, 1], c=y_kmeans, 
                      cmap='viridis', alpha=0.6, s=50)
ax1.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1],
            marker='X', s=300, c='red', edgecolors='black', linewidths=2,
            label='Centroids')
ax1.set_title('K-Means Clustering (K=4)')
ax1.set_xlabel('Feature 1')
ax1.set_ylabel('Feature 2')
ax1.legend()
plt.colorbar(scatter, ax=ax1)

# 2. Random Initialization Comparison
ax2 = plt.subplot(3, 4, 2)
ax2.bar(range(1, n_runs+1), inertias, alpha=0.7, color='steelblue')
ax2.axhline(y=np.min(inertias), color='green', linestyle='--', 
            label='Best', linewidth=2)
ax2.axhline(y=np.max(inertias), color='red', linestyle='--', 
            label='Worst', linewidth=2)
ax2.set_xlabel('Run Number')
ax2.set_ylabel('Inertia')
ax2.set_title('Random Init Trap: Inertia Variation')
ax2.legend()
ax2.grid(True, alpha=0.3)

# 3. Elbow Method
ax3 = plt.subplot(3, 4, 3)
ax3.plot(K_range, inertias_elbow, marker='o', linewidth=2, markersize=8)
ax3.set_xlabel('Number of Clusters (K)')
ax3.set_ylabel('Inertia (WCSS)')
ax3.set_title('Elbow Method')
ax3.grid(True, alpha=0.3)
ax3.axvline(x=3, color='red', linestyle='--', alpha=0.5, label='Elbow at K=3')
ax3.legend()

# 4. Silhouette Score
ax4 = plt.subplot(3, 4, 4)
ax4.plot(range(2, 11), silhouette_scores[1:], marker='o', 
         linewidth=2, markersize=8, color='green')
ax4.axvline(x=optimal_k, color='red', linestyle='--', alpha=0.5,
            label=f'Optimal K={optimal_k}')
ax4.set_xlabel('Number of Clusters (K)')
ax4.set_ylabel('Silhouette Score')
ax4.set_title('Silhouette Score vs K')
ax4.grid(True, alpha=0.3)
ax4.legend()

# 5. Silhouette Plot for K=3
ax5 = plt.subplot(3, 4, 5)
kmeans_3 = KMeans(n_clusters=3, random_state=42, n_init=10)
labels_3 = kmeans_3.fit_predict(X_iris_scaled)
silhouette_vals = silhouette_samples(X_iris_scaled, labels_3)

y_lower = 10
for i in range(3):
    cluster_silhouette_vals = silhouette_vals[labels_3 == i]
    cluster_silhouette_vals.sort()
    
    size_cluster_i = cluster_silhouette_vals.shape[0]
    y_upper = y_lower + size_cluster_i
    
    ax5.fill_betweenx(np.arange(y_lower, y_upper), 0, cluster_silhouette_vals,
                      alpha=0.7, label=f'Cluster {i}')
    y_lower = y_upper + 10

silhouette_avg = silhouette_score(X_iris_scaled, labels_3)
ax5.axvline(x=silhouette_avg, color='red', linestyle='--', 
            label=f'Avg: {silhouette_avg:.3f}', linewidth=2)
ax5.set_xlabel('Silhouette Coefficient')
ax5.set_ylabel('Cluster Label')
ax5.set_title('Silhouette Plot (K=3)')
ax5.legend(loc='best', fontsize=8)

# 6. Hierarchical Clustering - Ward Linkage
ax6 = plt.subplot(3, 4, 6)
Z = linkage(X_small, method='ward')
dendrogram(Z, ax=ax6, truncate_mode='lastp', p=10)
ax6.set_title('Dendrogram (Ward Linkage)')
ax6.set_xlabel('Sample Index or (Cluster Size)')
ax6.set_ylabel('Distance')

# 7. Comparison of Linkage Methods
ax7 = plt.subplot(3, 4, 7)
linkage_names = [l.capitalize() for l in linkages]
linkage_scores = [linkage_results[l]['silhouette'] for l in linkages]
bars = ax7.bar(linkage_names, linkage_scores, alpha=0.7, 
               color=['#3498db', '#e74c3c', '#2ecc71', '#f39c12'])
ax7.set_ylabel('Silhouette Score')
ax7.set_title('Linkage Method Comparison')
ax7.set_ylim([0, max(linkage_scores) * 1.2])
for bar in bars:
    height = bar.get_height()
    ax7.text(bar.get_x() + bar.get_width()/2., height,
             f'{height:.3f}', ha='center', va='bottom', fontsize=9)

# 8. Single Linkage Result
ax8 = plt.subplot(3, 4, 8)
labels_single = linkage_results['single']['labels']
ax8.scatter(X_varied[:, 0], X_varied[:, 1], c=labels_single, 
           cmap='viridis', alpha=0.6, s=50)
ax8.set_title('Single Linkage (Chain Effect)')
ax8.set_xlabel('Feature 1')
ax8.set_ylabel('Feature 2')

# 9. Complete Linkage Result
ax9 = plt.subplot(3, 4, 9)
labels_complete = linkage_results['complete']['labels']
ax9.scatter(X_varied[:, 0], X_varied[:, 1], c=labels_complete, 
           cmap='viridis', alpha=0.6, s=50)
ax9.set_title('Complete Linkage (Compact)')
ax9.set_xlabel('Feature 1')
ax9.set_ylabel('Feature 2')

# 10. Average Linkage Result
ax10 = plt.subplot(3, 4, 10)
labels_average = linkage_results['average']['labels']
ax10.scatter(X_varied[:, 0], X_varied[:, 1], c=labels_average, 
            cmap='viridis', alpha=0.6, s=50)
ax10.set_title('Average Linkage (Balanced)')
ax10.set_xlabel('Feature 1')
ax10.set_ylabel('Feature 2')

# 11. Ward Linkage Result
ax11 = plt.subplot(3, 4, 11)
labels_ward_varied = linkage_results['ward']['labels']
ax11.scatter(X_varied[:, 0], X_varied[:, 1], c=labels_ward_varied, 
            cmap='viridis', alpha=0.6, s=50)
ax11.set_title('Ward Linkage (Variance-based)')
ax11.set_xlabel('Feature 1')
ax11.set_ylabel('Feature 2')

# 12. Association Rules Visualization
ax12 = plt.subplot(3, 4, 12)
if len(actionable_rules) > 0:
    top_rules = actionable_rules[:8]
    rule_names = [f"{r['antecedent'][0][:4]}→{r['consequent'][0][:4]}" 
                  for r in top_rules]
    lifts = [r['lift'] for r in top_rules]
    confidences = [r['confidence'] * 100 for r in top_rules]
    
    x_pos = np.arange(len(rule_names))
    ax12_twin = ax12.twinx()
    
    bars1 = ax12.bar(x_pos - 0.2, lifts, 0.4, label='Lift', alpha=0.7, color='steelblue')
    bars2 = ax12_twin.bar(x_pos + 0.2, confidences, 0.4, label='Confidence %', 
                          alpha=0.7, color='coral')
    
    ax12.set_xlabel('Association Rule')
    ax12.set_ylabel('Lift', color='steelblue')
    ax12_twin.set_ylabel('Confidence (%)', color='coral')
    ax12.set_title('Top Association Rules')
    ax12.set_xticks(x_pos)
    ax12.set_xticklabels(rule_names, rotation=45, ha='right', fontsize=8)
    ax12.tick_params(axis='y', labelcolor='steelblue')
    ax12_twin.tick_params(axis='y', labelcolor='coral')
    ax12.axhline(y=1, color='gray', linestyle='--', alpha=0.3)
    ax12.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('unsupervised_learning_comprehensive.png', dpi=150, bbox_inches='tight')
print("Visualization saved as 'unsupervised_learning_comprehensive.png'")

# ============================================================================
# SUMMARY TABLE
# ============================================================================
print("\n" + "="*80)
print("SUMMARY: CLUSTERING METHODS COMPARISON")
print("="*80)
print(f"{'Method':<20} {'Best K':<10} {'Silhouette':<12} {'Time Complexity'}")
print("-"*80)
print(f"{'K-Means':<20} {'3':<10} {silhouette_scores[2]:.4f}      O(n*k*i)")
print(f"{'Hierarchical-Ward':<20} {'3':<10} {linkage_results['ward']['silhouette']:.4f}      O(n²log n)")
print(f"{'Hierarchical-Average':<20} {'3':<10} {linkage_results['average']['silhouette']:.4f}      O(n²log n)")
print(f"{'Hierarchical-Complete':<20} {'3':<10} {linkage_results['complete']['silhouette']:.4f}      O(n²log n)")
print(f"{'Hierarchical-Single':<20} {'3':<10} {linkage_results['single']['silhouette']:.4f}      O(n²log n)")

print("\n" + "="*80)
print("EXECUTION COMPLETE")
print("="*80)
```