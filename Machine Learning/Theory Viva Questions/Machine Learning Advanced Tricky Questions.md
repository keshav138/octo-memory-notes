
**Q61: Why is the cost function for linear regression MSE but for logistic regression it's log loss? What happens if you use MSE for logistic regression?** If we use MSE with logistic regression's sigmoid function, the cost function becomes non-convex with many local minima. This makes gradient descent unreliable as it might get stuck in local minima instead of finding the global minimum. Log loss creates a convex cost function for logistic regression, guaranteeing convergence to the global minimum. The derivative of log loss with sigmoid also has a clean mathematical form that cancels out nicely during gradient descent.

**Q62: In KNN, what happens when k=n (total number of training samples)? What about k=1?**

- **k=n**: The algorithm always predicts the majority class in the entire dataset, regardless of the query point. This is maximum underfitting - the model completely ignores local patterns.
- **k=1**: The model has zero training error (each point is its own nearest neighbor) but likely high test error due to overfitting. It creates a very complex, jagged decision boundary that fits noise in the training data.

**Q63: Why doesn't linear regression need feature scaling but logistic regression benefits from it?** Linear regression coefficients automatically adjust to feature scales - a feature with larger scale gets a proportionally smaller coefficient. The predictions remain unchanged. However, logistic regression uses gradient descent for optimization. Without feature scaling, features on larger scales have larger gradients, causing the optimization to take longer and potentially overshoot. Additionally, regularization in logistic regression penalizes all coefficients equally, so unscaled features would be penalized unfairly.

**Q64: Can R² be negative? When and why does this happen?** Yes, R² can be negative when the model performs worse than a horizontal line (mean baseline). This happens when:

- The model is extremely poor or inappropriate for the data
- Testing on out-of-sample data where the model generalizes badly
- Using a model without an intercept term Negative R² means SS_residual > SS_total, indicating your predictions are worse than simply predicting the mean every time.

**Q65: What's the difference between L1 and L2 regularization in terms of their geometric interpretation?**

- **L1 (Lasso)**: The constraint region is diamond-shaped (|β₁| + |β₂| ≤ t). The cost function contours are likely to intersect at the corners (axes), driving some coefficients exactly to zero. This creates sparse models with automatic feature selection.
- **L2 (Ridge)**: The constraint region is circular (β₁² + β₂² ≤ t). Intersections rarely occur exactly on axes, so coefficients shrink toward zero but rarely become exactly zero. All features remain in the model with reduced weights.

**Q66: Why is accuracy not a good metric for imbalanced datasets? Give a concrete example.** Consider a cancer detection dataset with 99% negative (no cancer) and 1% positive (cancer) cases. A naive model that always predicts "no cancer" achieves 99% accuracy but is medically useless - it misses all cancer cases. The model fails its primary purpose despite high accuracy. Better metrics: Precision, Recall, F1-score, or AUC-ROC that account for class imbalance and the cost of different error types.

**Q67: In polynomial regression, why can't you just keep increasing the degree to improve training accuracy?** While higher degree polynomials can achieve near-perfect training accuracy (even 100% with degree ≥ n-1 for n points), this leads to severe overfitting. The model memorizes training data including noise, creating wild oscillations between data points. The model loses generalization ability - it will perform terribly on new data. This is captured by the bias-variance tradeoff: reducing bias (training error) too much increases variance (sensitivity to training data fluctuations).

**Q68: What is the interpretability difference between linear regression and KNN?**

- **Linear Regression**: Highly interpretable. Each coefficient shows the exact relationship between a feature and target. You can explain predictions as "a unit increase in X leads to β increase in Y." The model is a clear mathematical equation.
- **KNN**: Black box for interpretation. You can't extract feature importance directly. Predictions depend on k nearest neighbors' values, which changes for every query point. You can't provide a simple explanation like "feature X affects prediction by this amount."

**Q69: Why is standardization preferred over normalization for algorithms using gradient descent?** Standardization (zero mean, unit variance) works better because:

1. It doesn't bound the data to a fixed range, preserving outliers that might be meaningful
2. Features roughly follow similar distributions, making gradient descent converge faster and more uniformly
3. Normalization to [0,1] can compress most values into a small range if outliers exist, losing information
4. Standardized features have better numerical stability in optimization

**Q70: What's the problem with using accuracy as an optimization metric during training?** Accuracy is non-differentiable (discontinuous) - small changes in model parameters cause discrete jumps in accuracy rather than smooth gradients. Gradient descent requires smooth, differentiable loss functions. That's why we optimize MSE, log loss, or cross-entropy (all differentiable) during training, even if we evaluate using accuracy. The loss function guides smooth parameter updates toward better accuracy.

**Q71: Why does logistic regression use Maximum Likelihood Estimation while linear regression uses Ordinary Least Squares? Aren't they solving the same type of problem?** They're fundamentally different:

- **Linear regression**: Assumes errors are normally distributed. Maximizing likelihood under Gaussian noise assumption is mathematically equivalent to minimizing squared errors (OLS).
- **Logistic regression**: Models probability using Bernoulli distribution. MLE finds parameters that maximize probability of observing the actual class labels. This naturally leads to log loss, not MSE. The connection: OLS is actually a special case of MLE under Gaussian assumptions.

**Q72: In KNN, why does the curse of dimensionality become a problem?** As dimensions increase:

1. **Distance becomes meaningless**: In high dimensions, the ratio of nearest to farthest neighbor approaches 1. All points become roughly equidistant, making "nearest" neighbors not actually close.
2. **Data sparsity**: Volume of space grows exponentially. Same number of data points become increasingly sparse, with vast empty regions.
3. **Computational cost**: Need more samples (exponentially) to maintain same density. Example: In 2D, 100 points might be adequate. In 10D, you'd need 100^5 = 10 billion points to maintain same density!

**Q73: What's the difference between Adjusted R² and R² in practical model selection?**

- **R²** always increases (never decreases) when you add more features, even irrelevant ones. This makes it unreliable for comparing models with different numbers of predictors.
- **Adjusted R²** penalizes adding features: Adj R² = 1 - [(1-R²)(n-1)/(n-k-1)], where n=samples, k=features. It can decrease if added features don't improve the model enough to justify their inclusion. Use Adjusted R² when comparing models with different feature counts to avoid being misled by spurious complexity.

**Q74: Why can't you use the same data for both training and hyperparameter tuning (like choosing k in KNN)?** This causes **data leakage** and overfitting to your validation set. The process:

1. Training data: Fit model parameters
2. Validation data: Tune hyperparameters (k, learning rate, regularization)
3. Test data: Final evaluation (never touched during development)

If you tune hyperparameters on test data, you're indirectly overfitting to it through trial and error. Your reported performance will be optimistically biased. The test set must remain completely untouched until final evaluation.

**Q75: In logistic regression, what does the magnitude of coefficients tell you, and how does regularization affect interpretation?**

- **Unregularized**: Larger |β| means stronger influence on log-odds. If β=2, a one-unit increase in that feature multiplies the odds by e² ≈ 7.4.
- **With regularization**: Coefficient magnitude no longer directly indicates importance because regularization shrinks coefficients, especially in L2. Features with larger natural scales get penalized more. You must standardize features before regularization to fairly compare coefficient magnitudes as measures of feature importance.

**Q76: Why is the decision boundary in logistic regression linear, but the predicted probabilities form an S-curve?** The decision boundary exists where P(y=1) = 0.5, which occurs when β₀ + β₁x₁ + ... + βₙxₙ = 0 (linear equation). However, the probability output is transformed through the sigmoid function, creating the S-shaped probability curve. The sigmoid is non-linear, but the threshold where it crosses 0.5 forms a linear boundary in feature space. For 2D: the boundary is a line; for 3D: a plane; for higher dimensions: a hyperplane.

**Q77: What happens to KNN's performance when irrelevant features are added?** Performance degrades significantly because:

1. Irrelevant features add noise to distance calculations
2. In distance metrics, all features contribute equally (if not scaled)
3. Random variations in irrelevant features can make dissimilar points appear close
4. Curse of dimensionality worsens **Solution**: Feature selection or weighted distance metrics that give more importance to relevant features.

**Q78: Why might a model with lower training error have higher test error?** **Overfitting**: The model has learned the training data too well, including:

- Random noise present only in training data
- Specific peculiarities of the training sample
- Patterns that don't generalize to the broader population

The model has high variance - it's too sensitive to the specific training data. This is especially common with high-capacity models (high-degree polynomials, k=1 in KNN, deep trees) and insufficient training data.

**Q79: In multiple regression, why might removing a feature improve model performance?** Several reasons:

1. **Multicollinearity**: The feature is highly correlated with others, causing unstable coefficient estimates
2. **Overfitting**: Irrelevant feature adds noise and complexity
3. **Curse of dimensionality**: Extra dimension without adding useful information
4. **Noise**: The feature contains more noise than signal
5. **Computational efficiency**: Simpler model generalizes better (Occam's Razor) This is why feature selection methods (forward/backward selection, Lasso) can improve performance.

**Q80: What's the fundamental difference between parametric (linear/logistic regression) and non-parametric (KNN) models?**

- **Parametric**: Make assumptions about data distribution, learn fixed number of parameters (β coefficients) during training, discard training data after learning. Fast prediction, interpretable, but assumptions may be wrong. Model complexity doesn't grow with data size.
- **Non-parametric**: Make fewer assumptions, store all training data, learn from data directly at prediction time. Slow prediction, flexible, but require lots of memory and computation. Model complexity grows with data size.

**Q81: Why is cross-validation better than a single train-test split?** Single split problems:

- Results depend heavily on which samples ended up in which set (high variance)
- May get lucky/unlucky with a particularly easy/hard test set
- Wastes data (test set isn't used for training)

Cross-validation:

- Every sample is used for both training and testing
- Averages results across multiple splits, reducing variance in performance estimate
- More reliable estimate of generalization performance
- Especially important with small datasets

**Q82: In polynomial regression, why must you fit the polynomial on training data and apply the same transformation to test data?** **Data leakage prevention**: If you fit the polynomial (or any transformation) on test data, you're using information from the test set during model preparation. The test set statistics (min, max, mean) leak into your model. This gives an optimistically biased performance estimate.

Correct process:

1. Fit transformation parameters on training data only
2. Apply those exact parameters to transform test data
3. This simulates real-world scenario where future data is truly unseen

**Q83: Why does Lasso (L1) perform feature selection but Ridge (L2) doesn't?** **Mathematical reason**: During optimization, the gradient of L1 regularization is constant (±λ), pushing coefficients toward exactly zero. The gradient of L2 is proportional to the coefficient value (2λβ), which decreases as β approaches zero, never quite reaching it.

**Geometric reason**: L1's diamond-shaped constraint region has corners on axes where some coefficients are exactly zero. L2's circular constraint has no such corners. The optimal solution for L1 often occurs at these corners (sparse solution), while L2's solution typically has all small non-zero coefficients.

**Q84: What are some signs that your model is underfitting vs overfitting based on learning curves?** **Underfitting**:

- Both training and validation error are high
- Errors converge to a high value
- Adding more data doesn't help
- Gap between errors is small **Solution**: More complex model, more features, less regularization

**Overfitting**:

- Training error is low, validation error is high
- Large gap between training and validation error
- Training error keeps decreasing while validation error plateaus or increases
- Adding more data helps reduce the gap **Solution**: Simpler model, regularization, more training data, feature selection

**Q85: Why is feature scaling not required for decision trees but required for KNN and linear regression with regularization?** **Decision trees**: Use splits based on feature values ("is feature X > threshold?"). The actual scale doesn't matter - whether you use meters or millimeters, the same threshold (adjusted for scale) produces the same split. Trees are scale-invariant.

**KNN**: Uses distance metrics. Unscaled features with larger ranges dominate the distance calculation, making smaller-scale features irrelevant.

**Regularization**: Penalizes all coefficients equally. A feature with larger scale has smaller coefficients, so it gets penalized less unfairly. Scaling ensures equal penalization.

**Plain linear regression**: Doesn't need scaling because coefficients adjust to feature scales automatically.