The choice between **Mean Absolute Error (MAE)**, **Mean Squared Error (MSE)**, and **Root Mean Squared Error (RMSE)** depends heavily on your modeling goal and how you want to penalize errors, particularly large ones. All three are measures of prediction accuracy for **regression models**, where lower values indicate a better fit.1

---

## 1. Mean Absolute Error (MAE)

MAE is the average of the absolute differences between the predicted values and the actual values.2

$$MAE = \frac{1}{n}\sum_{i=1}^{n} |y_i - \hat{y}_i|$$

- $y_i$ is the actual value, 3$\hat{y}_i$ is the predicted value, and 4$n$ is the number of data points.5
    

### 🎯 When MAE Matters (Use MAE when...)

- **You need high interpretability:** MAE is in the **same unit as the original target variable**, making it the most intuitive.6 An MAE of 5 means your predictions are off by 5 units _on average_.7
    
- **You want to treat all errors equally:** MAE is a **linear** score.8 An error of 10 is considered exactly twice as bad as an error of 5.
    
- **Your dataset has significant outliers:** MAE is **more robust to outliers** because it uses the absolute value, not the square.9 Outliers do not disproportionately influence the final score as much as they do with MSE/RMSE.10
    
- **You are aiming for the conditional median:** Mathematically, minimizing MAE leads to the model predicting the **median** of the data.
    

---

## 2. Mean Squared Error (MSE)

MSE is the average of the squared differences between the predicted and actual values.11

$$MSE = \frac{1}{n}\sum_{i=1}^{n} (y_i - \hat{y}_i)^2$$

### 🎯 When MSE Matters (Use MSE when...)

- **You want to heavily penalize large errors:** The squaring of the errors means that **larger deviations are penalized much more** than smaller ones.12 For example, an error of 10 is penalized 100 ($10^2$) times, while an error of 5 is penalized 25 ($5^2$) times. This is useful when large errors are especially detrimental.13
    
- **You are using it as a loss function for training:** MSE is **differentiable** everywhere and has a smoother gradient, which makes it mathematically convenient and preferable for optimization techniques like **Gradient Descent** (a common method for training machine learning models).14
    
- **You are aiming for the conditional mean:** Mathematically, minimizing MSE leads to the model predicting the **mean** (expected value) of the data.
    

---

## 3. Root Mean Squared Error (RMSE)

RMSE is the square root of the MSE.15

$$RMSE = \sqrt{\frac{1}{n}\sum_{i=1}^{n} (y_i - \hat{y}_i)^2}$$

### 🎯 When RMSE Matters (Use RMSE when...)

- **You want to penalize large errors but keep the units interpretable:** RMSE retains the **outlier-sensitivity** of MSE (penalizing large errors more) but, by taking the square root, it brings the metric back into the **original units of the target variable**, similar to MAE.16
    
- **It's the industry standard:** RMSE is one of the most common metrics reported in many fields, such as climate science, engineering, and predictive modeling, as it offers a good compromise.17
    

---

## ⚖️ Comparison Summary

The core difference is their sensitivity to large errors:

|**Metric**|**Calculation (Core Operation)**|**Outlier Sensitivity**|**Unit Interpretability**|**Optimized for**|
|---|---|---|---|---|
|**MAE**|Absolute Value|**Low** (More Robust)|**High** (Same unit)|Conditional **Median**|
|**MSE**|Squaring|**High** (Heavy Penalty)|**Low** (Squared unit)|Conditional **Mean**|
|**RMSE**|Square Root of Squared Error|**High** (Heavy Penalty)|**High** (Same unit)|Conditional **Mean**|

Would you like to see a numerical example comparing the MAE, MSE, and RMSE for a small dataset to better illustrate the effect of outliers?