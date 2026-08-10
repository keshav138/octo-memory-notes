
**1. Bias-variance tradeoff** Bias = error from wrong assumptions (underfitting, model too simple). Variance = error from sensitivity to training data fluctuations (overfitting, model too complex). Total error = Bias² + Variance + Irreducible noise. Diagnosis: plot learning curves (train vs val error vs training size/epochs).

- High bias: train error high, val error close to train error, both plateau high.
- High variance: train error low, val error much higher, big gap between them. Also check: if adding more data helps → variance problem; if it doesn't → bias problem.

**2. Overfitting vs underfitting** Overfitting: model fits noise, low train error, high val error. Underfitting: model too simple, high error on both.

_Fix overfitting:_ regularization (L1/L2), dropout, early stopping, more training data, reduce model complexity/pruning. _Fix underfitting:_ increase model complexity, add features/feature engineering, reduce regularization, train longer, use a better architecture/algorithm.

**3. Why L1 induces sparsity, L2 doesn't** L1 penalty (|w|) has a constant gradient magnitude regardless of weight size, so it can push small weights exactly to zero. L2 penalty (w²) has gradient proportional to w — as w approaches zero, the pushing force shrinks too, so it asymptotically approaches but never hits zero. Geometrically (see Q4), L1's constraint region has corners on the axes where the optimum often lands, giving exact zeros.
**L1 and L2 Regularization — the basics first**

Both are penalty terms added to the loss function to discourage large weights and prevent overfitting.

- **L2 (Ridge)**: adds λ·Σw² to the loss. Penalizes the _squared_ magnitude of weights.
- **L1 (Lasso)**: adds λ·Σ|w| to the loss. Penalizes the _absolute_ magnitude of weights.

λ (lambda) controls the strength — higher λ means more shrinkage. Both fight overfitting by keeping weights small, but they shrink weights differently, which is where Q3/Q4 come in.

Total loss = Original Loss (e.g., MSE) + λ × penalty

---

**3. Why L1 induces sparsity, L2 doesn't — broken down**

Think about what happens during gradient descent, looking at the _gradient of the penalty term itself_ (i.e., how much it pushes a weight toward zero at each step):

- **L2 gradient**: d(w²)/dw = 2w. The push toward zero is _proportional to the weight's current value_. So as w gets smaller, the push gets weaker too. It's like friction that scales down with speed — you get diminishing returns, and w approaches zero asymptotically but technically never lands exactly on it (in continuous math). Result: weights shrink, but stay small and nonzero.
    
- **L1 gradient**: d|w|/dw = sign(w), i.e., either +1 or -1 (constant magnitude regardless of how small w is). The push toward zero is _constant_, no matter how close w already is to zero. So if the gradient from the loss term for a weight is smaller than this constant pull from the penalty, L1 will drag that weight all the way to exactly zero and hold it there. Result: some weights become exactly zero → sparse solution.
    

**Intuition in one line:** L2 penalizes big weights harshly but small weights very gently (quadratic curve is flat near 0) — so it never fully kills them. L1 penalizes every nonzero weight at the same constant rate — so weak/unimportant weights get fully eliminated.

---

**4. L1 vs L2 — geometric (norm ball) intuition, broken down**

Regularized regression can be reframed as a constrained optimization problem:

> Minimize loss, subject to the constraint that the weight vector lies within a "norm ball" of some size.

- **L2 constraint**: |w₁|² + |w₂|² ≤ t → this defines a **circle** (2D) or sphere/hypersphere (higher D). Smooth boundary, no corners.
- **L1 constraint**: |w₁| + |w₂| ≤ t → this defines a **diamond** (rotated square in 2D), or in higher dimensions, a cross-polytope. This shape has sharp **corners** sitting exactly on the axes (where one coordinate = 0).

Now overlay the loss function's contours — for something like least-squares, these are **concentric ellipses** centered at the unconstrained optimum (the OLS solution).

- The regularized solution is the point where the smallest loss-contour ellipse first **touches** the constraint region.
- With the **circular (L2)** region: since the boundary is smooth everywhere, the ellipse can touch it at literally any point on the circle — generically this point has both w₁ and w₂ nonzero. No special pull toward the axes.
- With the **diamond (L1)** region: because the corners stick out and are "pointy," it's geometrically much more likely that the ellipse first touches the diamond exactly at a corner — and corners are the points where one coordinate is exactly zero. So the optimal solution lands on an axis → sparsity.

**One-sentence summary:** L2's constraint region is round → no bias toward any specific axis → shrinks all weights smoothly. L1's constraint region has sharp corners on the axes → optimizer gets "trapped" at corners → some weights become exactly zero.

---

**5. Curse of dimensionality — broken down**

Core idea: as the number of dimensions (features) grows, the volume of the space grows exponentially, but your data doesn't — so data points become extremely sparse, and the notion of "distance" degrades.

Break it into 3 concrete effects:

1. **Distance concentration**: In high dimensions, for most distributions, the ratio (distance to nearest point) / (distance to farthest point) → 1 as dimensions → ∞. Everything is roughly the same distance from everything else. This is mathematically provable for random uniform data.
    
2. **Sparsity of data**: To maintain the same data density you had in low dimensions, the amount of data needed grows exponentially with the number of dimensions. E.g., 100 points may densely cover a 1D line, but the same 100 points are hopelessly sparse in a 20D cube.
    
3. **Volume concentrates near the boundary**: In high-dim hypercubes/hyperspheres, most of the volume is near the "surface/corners," not the center — so most randomly sampled points end up far from the center, near edges.
    

**Effect on KNN specifically:** KNN relies on the assumption that "nearby points are similar" (small Euclidean/Manhattan distance = similar label). Once distances concentrate (point 1 above), the K nearest neighbors are barely closer than the rest of the dataset — so the neighbors picked are essentially arbitrary, and KNN's predictions become no better than random. Also, with sparse data (point 2), the "neighborhood" you're forced to search becomes huge, meaning the neighbors aren't even locally representative anymore.

**Mitigation:** dimensionality reduction (PCA, t-SNE for viz, feature selection), and using algorithms less sensitive to distance in high-D (tree-based models).

---

## PCA
Uses linear algebra to transform data into principle components, does this by calculating the eigen vectors (direction) and eigen values (importance) from the covariance matrix. PCA chooses components with the highest eigen values. Prioritizes where variance is high, since high variance means more information.

---

**6. Generative vs discriminative — broken down**

Broken into: what they model, how they use it, and pros/cons.

**What they model:**

- **Generative**: learns the **joint distribution** P(X, Y) — i.e., how the data and labels are jointly generated. Internally this usually means learning P(X|Y) (what does data look like for each class) and P(Y) (class prior), then using Bayes' theorem to get P(Y|X) = P(X|Y)·P(Y) / P(X) at prediction time.
- **Discriminative**: learns **P(Y|X) directly** (or an even more direct decision boundary without probabilities at all), skipping any attempt to model how X itself is distributed.

**Examples:**

- Generative: Naive Bayes, Gaussian Mixture Models, Hidden Markov Models, GANs, VAEs, LDA (Linear Discriminant Analysis, despite the name, is generative).
- Discriminative: Logistic Regression, SVM, standard feedforward Neural Nets, Random Forests, CRFs.

**Why it matters (practical differences):**

- **Generation**: Generative models can generate new synthetic samples (that's literally what GANs/VAEs do) because they know P(X|Y). Discriminative models cannot — they only know how to separate classes, not how the data looks.
- **Missing data / partial inputs**: Generative models can handle missing features more gracefully since they model the full data distribution.
- **Performance with enough data**: Discriminative models typically achieve better accuracy on pure classification because they focus modeling capacity directly on the decision boundary, not wasting effort modeling P(X) which isn't needed for classification.
- **Data efficiency**: Generative models sometimes work better with very little data since strong distributional assumptions (like Gaussian) act as useful inductive bias/regularization.

**One-line contrast:** Generative asks "how would this class produce this data?" — Discriminative asks "what's the boundary that separates the classes?"

**7. Parametric vs non-parametric** Parametric: fixed number of parameters regardless of dataset size (e.g., Linear Regression, Logistic Regression, Naive Bayes). Faster, less data-hungry, but limited flexibility (assumes a functional form). Non-parametric: number of "parameters" grows with data (e.g., KNN, Decision Trees, Kernel SVM, Random Forest). More flexible, can fit complex patterns, but needs more data and is prone to overfitting/slower at inference.

**8. No Free Lunch theorem** States that averaged over all possible problems, no single algorithm outperforms all others — an algorithm that's good on one class of problems will be bad on another. Practical implication: there's no universally "best" algorithm; performance is always tied to the structure/assumptions matching the specific problem. This justifies trying multiple algorithms, using domain knowledge to pick inductive biases, and being skeptical of claims like "X is always the best model."

**9. Data leakage** Information from outside the training set (often from the target or test set) leaks into training, giving unrealistically good metrics that don't hold in production. Three subtle examples:

1. **Scaling/normalizing before splitting** — fitting a StandardScaler on the whole dataset (including test set) leaks test statistics into training.
2. **Target leakage via proxy features** — e.g., predicting "will patient be readmitted" using a feature like "discharge disposition = transferred to another hospital," which is only known after the outcome is determined.
3. **Time-based leakage** — using future data to predict the past in time-series (e.g., random k-fold split on time-series data instead of time-based split), or computing aggregate features (like "average purchase amount") using the full dataset including future transactions.

**10. Train/val/test split philosophy** Train: fit model parameters. Validation: tune hyperparameters and make model-selection decisions. Test: final, unbiased estimate of generalization performance — touched only once, at the end. You can't tune hyperparameters on the test set because doing so means you're indirectly "fitting" to the test set over multiple iterations — the test error stops being an unbiased estimate of real-world performance; it becomes optimistic, since you're selecting the hyperparameters that happen to work best on that specific test set (overfitting to the test set).
[[Validation Set]]

**11. K-fold cross-validation** Split data into k folds; train on k-1, validate on the remaining fold, rotate k times, average the results. This cycle repeats K times so every part gets used as a test set. Gives a more robust performance estimate than a single train/val split, especially useful with limited data. Stratified k-fold preserves the class distribution in each fold — critical for imbalanced classification (e.g., 5% positive class), so you don't end up with folds that have very few or zero positive samples, which would give noisy/misleading validation metrics.

**12. Covariance vs correlation** Covariance measures the direction of the linear relationship between two variables but its magnitude is unbounded and scale-dependent (units matter). Correlation is covariance normalized by the product of standard deviations, bounding it to [-1, 1] and making it scale-invariant — so it's interpretable and comparable across variable pairs regardless of units.

**13. Multicollinearity** Occurs when two or more predictors are highly linearly correlated, making coefficient estimates unstable and hard to interpret (though prediction accuracy may be unaffected). Detection:

- **VIF (Variance Inflation Factor)**: VIF = 1/(1-R²) for each feature regressed on the others; VIF > 5-10 signals a problem.
- **Condition number**: ratio of largest to smallest eigenvalue of the feature matrix; >30 suggests significant multicollinearity.
- Correlation matrix / heatmap for a quick pairwise check. Handling: drop/combine correlated features, use PCA, apply L2 regularization (Ridge), or increase sample size.

**14. MLE vs MAP** MLE: find parameters θ that maximize P(Data|θ) — purely data-driven, no prior belief about θ. MAP: find θ that maximizes P(θ|Data) ∝ P(Data|θ) · P(θ) — incorporates a prior distribution over θ. MAP = MLE + regularization, essentially (e.g., a Gaussian prior on weights in MAP is equivalent to L2 regularization; a Laplace prior gives L1). MAP is more robust with small data since the prior constrains the solution.

**15. Loss vs cost vs objective function**

- Loss function: error for a **single** training example. (MSE, MAE Cross Entropy)
- Cost function: the loss **aggregated** (usually averaged) over the entire training set.
- Objective function: the most general term — what you're actually optimizing, which may be the cost function plus additional terms like a regularization penalty. (Cost function is a special case of objective function.)

	`ObjectiveFunction : Loss/Cost Function + Regularization Term`

**16. Exploration-exploitation tradeoff** In RL: balancing trying new actions (exploration, to discover potentially better rewards) vs choosing the currently known best action (exploitation, to maximize immediate reward). Too much exploration wastes resources on bad options; too much exploitation risks getting stuck in a local optimum. Outside RL: A/B testing and multi-armed bandits (ad placement, recommendation systems), hyperparameter search (Bayesian optimization), job search/career decisions, even business strategy (exploit existing product line vs explore new markets).

**17. Feature scaling** Rescales features to a comparable range (standardization or min-max normalization). _Genuinely need it:_ distance-based algorithms (KNN, K-Means), gradient-descent-based models (Linear/Logistic Regression, Neural Networks — for faster/stable convergence), PCA and SVD (variance-based), regularized models (Ridge/Lasso, since penalty is applied uniformly across coefficients), and SVM (kernel-based, distance-sensitive). _Don't need it:_ tree-based models (Decision Trees, Random Forest, Gradient Boosted Trees) — splits are based on feature thresholds, not distances/magnitudes, so scale is irrelevant. Naive Bayes also doesn't require it.

**18. Bagging vs boosting**

- **Bagging** (Bootstrap Aggregating): trains multiple models **independently and in parallel** on random bootstrap samples of the data, then averages/votes the predictions. Primarily reduces **variance** (e.g., Random Forest). Base learners are typically high-variance, low-bias (deep trees).
- **Boosting**: trains models **sequentially**, where each new model focuses on correcting the errors of the previous ones (via reweighting misclassified samples or fitting residuals). Primarily reduces **bias** (e.g., AdaBoost, Gradient Boosting, XGBoost). Base learners are typically weak (shallow trees), and boosting can overfit if not regularized (learning rate, tree depth, early stopping).