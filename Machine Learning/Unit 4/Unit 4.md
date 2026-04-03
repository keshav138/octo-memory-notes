# Unsupervised Learning - Comprehensive Notes

## 1. K-Means Clustering

### Intuition

K-Means is a partitioning algorithm that divides data into K distinct, non-overlapping clusters. Think of it as organizing a messy room by grouping similar items together into K piles. Each data point belongs to the cluster with the nearest center (centroid). The algorithm iteratively refines cluster assignments and centroids until convergence.

**Real-world analogy**: Imagine you're a city planner dividing a city into K postal zones. You want each address assigned to the nearest post office, and you want to place post offices optimally to minimize average distance.

### Key Concepts

- **Centroid**: The mean position of all points in a cluster
- **Assignment step**: Assign each point to nearest centroid
- **Update step**: Recalculate centroids based on current assignments
- **Convergence**: Algorithm stops when assignments no longer change
- **Distance metric**: Typically Euclidean distance

### Algorithm Steps

1. **Initialize**: Randomly select K points as initial centroids
2. **Assignment**: Assign each data point to the nearest centroid
3. **Update**: Calculate new centroids as the mean of all points in each cluster
4. **Repeat**: Steps 2-3 until convergence (centroids stop moving)

### Math Outline

**Objective Function** (minimize within-cluster sum of squares):

- J = Σᵏ Σₓ∈Cₖ ||x - μₖ||²

Where:

- K = number of clusters
- Cₖ = set of points in cluster k
- μₖ = centroid of cluster k
- ||x - μₖ|| = Euclidean distance

**Distance Calculation**:

- d(x, μ) = √(Σⁿᵢ₌₁(xᵢ - μᵢ)²)

**Centroid Update**:

- μₖ = (1/|Cₖ|) × Σₓ∈Cₖ x

### Advantages & Disadvantages

**Pros**:

- Simple and easy to implement
- Fast and efficient (linear in number of data points)
- Scales well to large datasets
- Guaranteed to converge

**Cons**:

- Requires K to be specified beforehand
- Sensitive to initial centroid positions
- Assumes spherical clusters of similar size
- Sensitive to outliers
- Only finds local optima

---

## 2. K-Means Random Initialization Trap

### The Problem

K-Means is sensitive to initial centroid placement. Poor initialization can lead to:

- **Local optima**: Algorithm converges to suboptimal clustering
- **Different results**: Running algorithm multiple times gives different clusters
- **Poor quality**: High within-cluster variance, low separation between clusters

### Intuition

Imagine organizing books into 3 piles. If you start by randomly grabbing 3 books that are all from the same genre, your initial "pile centers" are biased. You might end up with one huge pile and two tiny ones, rather than three balanced piles organized by genre.

### Solutions

#### 1. K-Means++ Initialization

**Smart initialization** that spreads initial centroids far apart:

1. Choose first centroid randomly from data points
2. For each subsequent centroid:
    - Calculate distance of each point to nearest existing centroid
    - Choose next centroid with probability proportional to distance²
3. Repeat until K centroids selected

**Why it works**: Ensures initial centroids are well-separated, reducing chance of poor local optima.

#### 2. Multiple Random Initializations

- Run K-Means multiple times (e.g., 10-50 runs) with different random initializations
- Keep the result with lowest within-cluster sum of squares
- Most implementations (scikit-learn) do this automatically

### Math Behind K-Means++

**Probability of selecting point x as next centroid**:

- P(x) = D(x)² / Σᵢ D(xᵢ)²

Where:

- D(x) = distance from x to nearest existing centroid
- Squaring ensures points far from centroids are much more likely to be selected

---

## 3. Selecting the Number of Clusters (K)

### The Challenge

Unlike supervised learning, there's no single "correct" K. The optimal number depends on:

- Data structure and natural groupings
- Business objectives or domain knowledge
- Desired granularity of clustering

### Methods for Determining K

#### 1. Elbow Method

**Intuition**: Plot within-cluster sum of squares (WCSS) vs. number of clusters. Look for the "elbow" where adding more clusters gives diminishing returns.

**Process**:

1. Run K-Means for K = 1, 2, 3, ..., N
2. Calculate WCSS (inertia) for each K
3. Plot K vs. WCSS
4. Find the "elbow" - point where curve bends sharply

**Math**:

- WCSS = Σᵏ Σₓ∈Cₖ ||x - μₖ||²

**Limitation**: Elbow not always clear; subjective interpretation

#### 2. Silhouette Score

**Intuition**: Measures how similar a point is to its own cluster compared to other clusters. Ranges from -1 (wrong cluster) to +1 (perfect cluster).

**For each point i**:

- a(i) = average distance to points in same cluster (cohesion)
- b(i) = average distance to points in nearest other cluster (separation)

**Silhouette coefficient**:

- s(i) = (b(i) - a(i)) / max(a(i), b(i))

**Average silhouette score**:

- S = (1/N) × Σⁿᵢ₌₁ s(i)

**Interpretation**:

- +1: Point well matched to cluster
- 0: Point on border between clusters
- -1: Point probably in wrong cluster

**Process**: Calculate average silhouette for different K values; choose K with highest score.

#### 3. Gap Statistic

Compares WCSS with expected WCSS from random uniform distribution.

**Formula**:

- Gap(K) = E[log(WCSSᵣₐₙdₒₘ)] - log(WCSS)

Choose K where Gap(K) is largest.

#### 4. Domain Knowledge

Often the best approach - use understanding of the problem:

- Customer segmentation: How many segments can marketing handle?
- Image compression: What quality/size tradeoff is acceptable?
- Document clustering: Natural categories in the domain

---

## 4. Hierarchical Clustering

### Intuition

Instead of partitioning data into K clusters directly, hierarchical clustering builds a tree-like structure (dendrogram) showing relationships at all levels. Like a family tree or organizational chart, it shows how data points group together at different scales.

**Two approaches**:

- **Agglomerative (Bottom-up)**: Start with each point as its own cluster, merge closest pairs iteratively
- **Divisive (Top-down)**: Start with all points in one cluster, split recursively

### Agglomerative Clustering (More Common)

**Algorithm**:

1. Start: Each data point is its own cluster (N clusters)
2. Repeat:
    - Find the two closest clusters
    - Merge them into one cluster
3. Until: Only one cluster remains (or desired number reached)

**Advantages**:

- No need to specify K beforehand
- Creates interpretable dendrogram
- Can cut dendrogram at any height for different K
- More deterministic than K-Means (no random initialization)

### Divisive Clustering (Less Common)

**Algorithm**:

1. Start: All data points in one cluster
2. Repeat:
    - Select a cluster to split
    - Divide it into two sub-clusters (often using K-Means with K=2)
3. Until: Each point is its own cluster (or desired number reached)

**Advantages**:

- Better for finding large, primary divisions
- Can be more accurate for well-separated data

**Disadvantages**:

- More computationally expensive
- Less commonly implemented

### Comparison

|Aspect|Agglomerative|Divisive|
|---|---|---|
|Direction|Bottom-up|Top-down|
|Starting point|N clusters|1 cluster|
|Computational cost|O(N²) to O(N³)|Higher|
|Common usage|Very common|Rare|
|Best for|Small to medium datasets|Finding major divisions|

### Dendrogram

A tree diagram showing the hierarchical relationship between clusters:

- **Y-axis**: Distance (or dissimilarity) between merged clusters
- **X-axis**: Individual data points or clusters
- **Branches**: Show which clusters were merged at what distance
- **Cutting height**: Horizontal line determines number of final clusters

**Reading dendrograms**:

- Longer vertical lines = more distinct clusters
- Short vertical lines = similar clusters merged
- Cut at different heights for different granularities

---

## 5. Types of Linkages (Distance Metrics Between Clusters)

Linkage determines how we measure distance between two clusters. Critical for hierarchical clustering performance.

### 1. Single Linkage (Minimum Linkage)

**Definition**: Distance between two clusters = minimum distance between any two points (one from each cluster).

**Math**:

- d(A, B) = min{d(a, b) : a ∈ A, b ∈ B}

**Intuition**: "Closest neighbors" approach - clusters are close if their nearest points are close.

**Characteristics**:

- Creates long, chain-like clusters
- Sensitive to noise and outliers
- Good for elongated, non-spherical clusters
- Suffers from "chaining effect"

**Best for**: Detecting elongated structures, pathways

### 2. Complete Linkage (Maximum Linkage)

**Definition**: Distance between two clusters = maximum distance between any two points (one from each cluster).

**Math**:

- d(A, B) = max{d(a, b) : a ∈ A, b ∈ B}

**Intuition**: "Furthest neighbors" approach - ensures all points in merged cluster are relatively close.

**Characteristics**:

- Creates compact, spherical clusters
- More robust to outliers than single linkage
- Tends to break large clusters
- Avoids chaining effect

**Best for**: When you want tight, well-separated clusters

### 3. Average Linkage

**Definition**: Distance between two clusters = average distance between all pairs of points (one from each cluster).

**Math**:

- d(A, B) = (1/(|A|×|B|)) × ΣₐΣᵦ d(a, b)

**Intuition**: Balanced approach considering all points in both clusters.

**Characteristics**:

- Compromise between single and complete linkage
- Less sensitive to outliers than single linkage
- More balanced clusters than complete linkage
- Most commonly used in practice

**Best for**: General-purpose clustering, balanced results

### 4. Centroid Linkage

**Definition**: Distance between two clusters = distance between their centroids.

**Math**:

- d(A, B) = ||μₐ - μᵦ||

Where:

- μₐ = mean of all points in cluster A
- μᵦ = mean of all points in cluster B

**Intuition**: Treats each cluster as represented by its center point.

**Characteristics**:

- Computationally efficient
- Can produce inversions in dendrogram (child closer than parent)
- Similar to K-Means philosophy
- Less commonly used

**Best for**: Large datasets where average linkage is too expensive

### 5. Ward's Linkage (Bonus - Most Powerful)

**Definition**: Merge clusters that minimize increase in within-cluster variance.

**Math**:

- Minimize: Δ = ||μₐᵦ - μₐ||² + ||μₐᵦ - μᵦ||²

**Intuition**: Similar to K-Means objective - minimize within-cluster variance.

**Characteristics**:

- Produces very balanced, compact clusters
- Tends to create clusters of similar size
- Generally performs best in practice
- Default in many implementations

**Best for**: Most applications, especially when clusters are roughly equal size

### Comparison Summary

|Linkage|Distance Measure|Cluster Shape|Outlier Sensitivity|Best Use Case|
|---|---|---|---|---|
|Single|Minimum|Elongated|High|Non-spherical clusters|
|Complete|Maximum|Compact|Medium|Well-separated spheres|
|Average|Mean|Balanced|Low|General purpose|
|Centroid|Centroid distance|Balanced|Medium|Large datasets|
|Ward|Variance increase|Compact, equal size|Low|Most applications|

---

## 6. Association Rules Mining

### Intuition

Association rule mining discovers interesting relationships, patterns, or co-occurrences in large datasets. The classic example: "Customers who buy beer also tend to buy diapers."

**Goal**: Find rules of the form {X} → {Y}, meaning "if X occurs, then Y is likely to occur."

**Real-world applications**:

- Market basket analysis (retail)
- Web usage mining (clickstream)
- Medical diagnosis (symptom combinations)
- Bioinformatics (gene expression)

### Key Concepts

#### Itemset

A collection of items. Example: {Milk, Bread}

#### Transaction

A set of items purchased/occurring together. Example: Customer bought {Milk, Bread, Eggs}

#### Support

**Definition**: Frequency of an itemset appearing in dataset.

**Math**:

- Support(X) = (Transactions containing X) / (Total transactions)
- Support({Milk}) = 0.4 means 40% of transactions contain milk

**Interpretation**: How popular/frequent is this combination?

#### Confidence

**Definition**: Likelihood of Y given X has occurred.

**Math**:

- Confidence(X → Y) = Support(X ∪ Y) / Support(X)
- Confidence({Milk} → {Bread}) = 0.7 means 70% of people who buy milk also buy bread

**Interpretation**: How reliable is the rule?

#### Lift

**Definition**: How much more likely is Y when X occurs, compared to Y occurring independently.

**Math**:

- Lift(X → Y) = Support(X ∪ Y) / (Support(X) × Support(Y))
- Lift(X → Y) = Confidence(X → Y) / Support(Y)

**Interpretation**:

- Lift = 1: X and Y are independent (no relationship)
- Lift > 1: Positive correlation (X increases likelihood of Y)
- Lift < 1: Negative correlation (X decreases likelihood of Y)

**Example**:

- Support({Beer}) = 0.4, Support({Diapers}) = 0.3
- Support({Beer, Diapers}) = 0.24
- Confidence({Beer} → {Diapers}) = 0.24/0.4 = 0.6 (60%)
- Lift({Beer} → {Diapers}) = 0.24/(0.4×0.3) = 2.0
- **Interpretation**: Beer buyers are 2× more likely to buy diapers than average

### Apriori Algorithm

**Purpose**: Efficiently find frequent itemsets without checking every possible combination.

**Key Principle (Apriori Property)**:

- If an itemset is frequent, all its subsets must also be frequent
- If an itemset is infrequent, all its supersets must be infrequent

**Algorithm Steps**:

1. Find all frequent 1-itemsets (items appearing ≥ min_support)
2. Generate candidate 2-itemsets from frequent 1-itemsets
3. Count support of candidates, keep only frequent ones
4. Repeat: Generate k-itemsets from (k-1)-itemsets
5. Stop when no more frequent itemsets can be generated
6. Generate rules from frequent itemsets

**Why it's efficient**: Drastically reduces combinations to check using the Apriori property.

---

## 7. Market Basket Analysis

### Intuition

Market Basket Analysis uses association rules to understand purchasing patterns. The "basket" is what a customer buys in a single transaction.

**Business Goals**:

- **Cross-selling**: Recommend products based on current cart
- **Store layout**: Place related items nearby
- **Promotions**: Bundle frequently co-purchased items
- **Inventory**: Stock items that are bought together

### Process

1. **Data Collection**: Gather transaction data
    
    - Transaction ID
    - Items purchased
    - Timestamp (optional)
    - Customer ID (optional)
2. **Data Preparation**:
    
    - Convert to binary matrix (item present/absent)
    - Clean data (remove rare items if needed)
3. **Apply Apriori Algorithm**:
    
    - Set minimum support (e.g., 1% of transactions)
    - Set minimum confidence (e.g., 50%)
    - Find frequent itemsets and rules
4. **Evaluate Rules**:
    
    - Filter by lift (> 1 for positive associations)
    - Rank by confidence, lift, or support
    - Remove redundant/trivial rules
5. **Actionable Insights**:
    
    - Product recommendations
    - Store layout optimization
    - Promotional strategies
    - Inventory management

### Example Application

**Scenario**: Grocery store with 10,000 transactions

**Settings**:

- Minimum support = 2% (appears in 200+ transactions)
- Minimum confidence = 60%
- Minimum lift = 1.2

**Discovered Rules**:

1. {Bread, Butter} → {Milk}
    
    - Support: 3%, Confidence: 75%, Lift: 1.8
    - **Action**: Place milk near bread/butter section
2. {Coffee, Sugar} → {Cream}
    
    - Support: 2.5%, Confidence: 80%, Lift: 2.1
    - **Action**: Bundle these items in promotion
3. {Pasta, Tomato Sauce} → {Cheese}
    
    - Support: 4%, Confidence: 65%, Lift: 1.5
    - **Action**: Cross-sell cheese when pasta is purchased online

### Interpreting Results

**Good Rules (Actionable)**:

- High support: Affects many customers
- High confidence: Reliable pattern
- High lift: Strong association (not just popular items)

**Poor Rules (Avoid)**:

- Low support: Too rare to act on
- Low confidence: Unreliable
- Lift ≈ 1: No real association
- Trivial rules: {Printer} → {Ink} (obvious)

### Challenges & Considerations

1. **Rare items**: May miss important patterns
2. **Seasonal effects**: Patterns change over time
3. **Minimum thresholds**: Too high misses patterns, too low generates noise
4. **Causation vs correlation**: Rules show association, not causation
5. **Computational cost**: Grows exponentially with unique items

---

## 8. Summary Comparison

### Clustering Methods Comparison

|Aspect|K-Means|Hierarchical|
|---|---|---|
|K specification|Required|Not required|
|Dendrogram|No|Yes|
|Scalability|High (millions)|Low (thousands)|
|Cluster shape|Spherical|Any shape|
|Deterministic|No (random init)|Yes|
|Complexity|O(N×K×I)|O(N²) to O(N³)|
|Best for|Large datasets, spherical clusters|Small datasets, understanding hierarchy|

### When to Use Each Method

**K-Means**:

- Large datasets (>10,000 points)
- Know approximate number of clusters
- Clusters are roughly spherical and equal size
- Speed is important

**Hierarchical**:

- Small to medium datasets (<5,000 points)
- Want to explore different numbers of clusters
- Need to understand hierarchical relationships
- Clusters may be non-spherical

**Association Rules**:

- Transactional data
- Looking for co-occurrence patterns
- Market basket analysis
- Recommendation systems
- Understanding customer behavior