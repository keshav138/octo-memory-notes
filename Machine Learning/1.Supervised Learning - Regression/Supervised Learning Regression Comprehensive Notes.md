## SUPERVISED LEARNING

`Definition:` A machine learning paradigm where the algorithm learns from labeled training data to make predictions on new, unseen data. The model learns the mapping between input features (X) and known output labels (y).

`Used For:`

- Prediction tasks where historical data with known outcomes exists
- Pattern recognition and classification
- Forecasting future values

`Cases of Application:`

- Predicting house prices, stock prices
- Medical diagnosis
- Spam detection, image classification
- Customer churn prediction

`Prerequisites:`

- Labeled dataset (input-output pairs)
- Quality data (cleaned, preprocessed)
- Sufficient data volume
- Feature selection/engineering
- Train-test split for validation

`Performance Measures:`

- Depends on task: accuracy, precision, recall, F1-score (classification); MAE, MSE, RMSE, R² (regression)

`R^2 SCORE` - a statistical measure that shows the proportion of variance in a dependent variable that is predictable from the independent variable(s)

---

## SIMPLE LINEAR REGRESSION

`Definition:` A regression technique modeling the relationship between one independent variable (X) and one dependent variable (y) using a straight line: y = β₀ + β₁X + ε, where β₀ is the intercept, β₁ is the slope, and ε is the error term.

`Used For:`

- Modeling linear relationships between two continuous variables
- Understanding how one variable affects another
- Making predictions based on a single predictor

`Cases of Application:`

- Predicting salary based on years of experience
- Estimating fuel consumption from vehicle speed
- Forecasting sales based on advertising spend
- Predicting crop yield from rainfall

`Prerequisites:`

- Linearity: relationship between X and y is approximately linear
- Independence: observations are independent
- Homoscedasticity: constant variance of residuals
- Normality: residuals follow normal distribution
- No multicollinearity (not applicable here, only one predictor)
- No outliers significantly affecting the line

`Performance Measures:`

- R² Score (coefficient of determination)
- MAE, MSE, RMSE
- Residual plots for assumption checking
- p-values and confidence intervals for coefficients

---

## MULTIPLE LINEAR REGRESSION

`Definition:` Extension of simple linear regression with multiple independent variables: y = β₀ + β₁X₁ + β₂X₂ + ... + βₙXₙ + ε, where each βᵢ represents the effect of variable Xᵢ on y.

`Used For:`

- Modeling relationships with multiple predictors
- Understanding relative importance of different factors
- Complex prediction scenarios with multiple influencing variables

`Cases of Application:`

- Predicting house prices based on size, location, age, bedrooms
- Estimating insurance premiums from age, gender, health metrics
- Forecasting sales using advertising, seasonality, competition
- Academic performance prediction from study hours, attendance, socioeconomic factors

`Prerequisites:`

- Linearity: linear relationship between predictors and target
- Independence of observations
- Homoscedasticity
- Normality of residuals
- No multicollinearity: predictors should not be highly correlated with each other (check VIF - Variance Inflation Factor)
- Sufficient sample size (rule of thumb: 10-20 observations per predictor)

`Performance Measures:`

- Adjusted R² (better than R² for multiple predictors)
- MAE, MSE, RMSE
- AIC (Akaike Information Criterion) and BIC (Bayesian Information Criterion)
- F-statistic for overall model significance
- VIF for multicollinearity detection

---

## POLYNOMIAL REGRESSION

`Definition:` A form of regression where the relationship between X and y is modeled as an nth-degree polynomial: y = β₀ + β₁X + β₂X² + β₃X³ + ... + βₙXⁿ + ε. Still considered linear regression because it's linear in the coefficients.

`Used For:`

- Capturing non-linear relationships between variables
- Modeling curved patterns in data
- Situations where simple linear regression underfits

`Cases of Application:`

- Modeling growth rates that accelerate/decelerate
- Disease progression over time
- Temperature variations throughout the day
- Relationship between fertilizer amount and crop yield (diminishing returns)
- Trajectory prediction in physics

`Prerequisites:`

- Same assumptions as linear regression
- Careful selection of polynomial degree (avoid overfitting)
- Feature scaling often necessary due to large magnitude differences
- Check for multicollinearity between polynomial terms
- Sufficient data points relative to degree

`Performance Measures:`

- R², Adjusted R²
- MAE, MSE, RMSE
- Cross-validation scores to detect overfitting
- Visual inspection of fitted curve
- Residual analysis

---

## LOGISTIC REGRESSION

`Definition:` A classification algorithm (despite the name "regression") that models the probability of a binary outcome using the logistic function: P(y=1|X) = 1 / (1 + e^(-(β₀ + β₁X₁ + ... + βₙXₙ))). Output is between 0 and 1.

`Used For:`

- Binary classification problems
- Estimating probabilities of an event occurring
- Scenarios requiring interpretable classification

`Cases of Application:`

- Disease diagnosis (disease/no disease)
- Spam detection (spam/not spam)
- Customer churn prediction (will churn/won't churn)
- Loan default prediction
- Marketing response prediction (will buy/won't buy)

`Prerequisites:`

- Binary or ordinal dependent variable
- Independence of observations
- Little to no multicollinearity among predictors
- Linearity between continuous predictors and log-odds
- Large sample size (rule of thumb: 10 events per predictor)
- No extreme outliers

`Performance Measures:`

- Accuracy, Precision, Recall, F1-Score
- Confusion Matrix
- ROC Curve and AUC (Area Under Curve)
- Log-loss (Cross-entropy loss)
- Sensitivity and Specificity

---

## ORDINARY LEAST SQUARES (OLS) ESTIMATION

`Definition:` A method for estimating the unknown parameters in a linear regression model by minimizing the sum of squared residuals (differences between observed and predicted values): min Σ(yᵢ - ŷᵢ)².

`Used For:`

- Finding the best-fit line/hyperplane in regression
- Parameter estimation in linear models
- Statistical inference about relationships

`Cases of Application:`

- Core technique behind simple and multiple linear regression
- Econometric modeling
- Time series analysis
- Any scenario requiring linear parameter estimation

`Prerequisites:`

- Linear relationship between variables
- No perfect multicollinearity
- Zero conditional mean: E(ε|X) = 0
- Homoscedasticity
- No autocorrelation (for time series)
- Exogeneity: predictors uncorrelated with error term

`Performance Measures:`

- Standard errors of coefficients
- t-statistics and p-values
- F-statistic for overall model
- R² and Adjusted R²
- Residual standard error
- Confidence intervals for parameters

---

## CORRELATIONS

`Definition:` A statistical measure quantifying the strength and direction of the linear relationship between two variables, typically measured by Pearson correlation coefficient (r) ranging from -1 to +1.

`Used For:`

- Exploring relationships between variables
- Feature selection in machine learning
- Understanding data structure before modeling
- Detecting multicollinearity

`Cases of Application:`

- Identifying which features correlate with target variable
- Detecting redundant features
- Exploratory data analysis
- Verifying economic/scientific theories
- Portfolio diversification analysis

`Prerequisites:`

- Continuous variables (for Pearson correlation)
- Linear relationship (Pearson assumes linearity)
- No extreme outliers
- Approximately normal distribution (for significance testing)
- Alternatives: Spearman (ordinal data), Kendall (non-parametric)

`Performance Measures:`

- Correlation coefficient value (strength)
- p-value (statistical significance)
- Confidence intervals
- Correlation matrix visualization (heatmaps)
- Note: correlation ≠ causation

---

## MEAN ABSOLUTE ERROR (MAE)

`Definition:` The average of absolute differences between predicted and actual values: MAE = (1/n) Σ|yᵢ - ŷᵢ|. Measures average magnitude of errors without considering direction.

`Used For:`

- Evaluating regression model accuracy
- Comparing models (lower MAE = better)
- When all errors have equal weight

`Cases of Application:`

- Forecasting accuracy assessment
- Model comparison and selection
- Performance monitoring
- When outliers shouldn't be heavily penalized

`Prerequisites:`

- Continuous target variable
- Predictions and actual values in same units
- Same scale interpretation across dataset

`Performance Measures:`

- Expressed in same units as target variable
- Range: [0, ∞), where 0 is perfect
- Less sensitive to outliers than MSE
- Easy to interpret
- Not differentiable at zero (minor issue for optimization)

---

## MEAN SQUARED ERROR (MSE)

`Definition:` The average of squared differences between predicted and actual values: MSE = (1/n) Σ(yᵢ - ŷᵢ)². Penalizes larger errors more heavily due to squaring.

`Used For:`

- Regression model evaluation
- Loss function in optimization algorithms
- When large errors are particularly undesirable

`Cases of Application:`

- Training neural networks (optimization objective)
- Model selection
- Scenarios where large errors are costly
- Standard metric in many ML libraries

`Prerequisites:`

- Continuous target variable
- Predictions and actual values available
- Understanding that units are squared

`Performance Measures:`

- Range: [0, ∞), where 0 is perfect
- Units are squared (harder to interpret than MAE)
- More sensitive to outliers than MAE
- Differentiable everywhere (better for gradient-based optimization)
- Commonly used loss function

---

## ROOT MEAN SQUARED ERROR (RMSE)

`Definition:` The square root of MSE: RMSE = √[(1/n) Σ(yᵢ - ŷᵢ)²]. Returns error to original units while maintaining sensitivity to large errors.

`Used For:`

- Regression model evaluation
- When interpretability matters (same units as target)
- When large errors should be penalized more

`Cases of Application:`

- Forecasting accuracy evaluation
- Model comparison
- Real-world predictions where units matter
- Standard reporting metric

`Prerequisites:`

- Continuous target variable
- Non-negative by definition
- Predictions and actual values

`Performance Measures:`

- Range: [0, ∞), where 0 is perfect
- Same units as target variable (more interpretable than MSE)
- More sensitive to outliers than MAE
- Cannot be smaller than MAE for same dataset
- Penalizes large errors quadratically

---

## R-SQUARED (R²) SCORE / COEFFICIENT OF DETERMINATION

`Definition:` Proportion of variance in the dependent variable explained by the independent variables: R² = 1 - (SS_res / SS_tot), where SS_res is sum of squared residuals and SS_tot is total sum of squares. Range: [0, 1] for standard cases, can be negative for poor models.

`Used For:`

- Assessing goodness-of-fit of regression models
- Comparing explanatory power of models
- Understanding how much variance is explained

`Cases of Application:`

- Linear regression evaluation
- Model selection and comparison
- Reporting predictive capability
- Academic and research contexts

`Prerequisites:`

- Regression setting
- Predictions and actual values
- Baseline model for comparison (typically mean)

`Performance Measures:`

- R² = 1: perfect predictions
- R² = 0: model no better than predicting mean
- R² < 0: model worse than baseline
- Higher values indicate better fit
- Can be misleading with multiple predictors (use Adjusted R²)
- Does not indicate whether model assumptions are met
- Doesn't measure prediction accuracy on new data

---

## KEY RELATIONSHIPS AND NOTES

`Choosing between metrics:`

- MAE: When all errors matter equally
- MSE/RMSE: When large errors are especially costly
- R²: When explaining variance is the goal
- Use multiple metrics together for comprehensive evaluation

`Model complexity tradeoff:`

- Simple → Multiple → Polynomial increases complexity
- More complex models risk overfitting
- Always validate on unseen data

`Common pitfall:` High R² doesn't guarantee good predictions on new data—always use cross-validation.