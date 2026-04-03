https://youtu.be/sDv4f4s2SB8?si=iZY9e4AvZnZBt5SK
**Introduction to Gradient Descent**

- **Purpose:** Gradient Descent is a fundamental optimization algorithm used in machine learning and statistics to find optimal parameters (e.g., intercept and slope in linear regression) for a wide variety of models (0:31, 1:01).
- It works by iteratively adjusting parameters to minimize a **Loss Function** (e.g., sum of squared residuals) (1:07, 2:42).
- **Efficiency:** Gradient Descent takes larger steps when far from the optimal solution and smaller "baby steps" when close to it, making it more efficient than brute-force methods (5:15).

**Gradient Descent for a Single Variable (e.g., Intercept)**

1. **Define Loss Function:** Choose a function to evaluate how well the model fits the data (e.g., sum of squared residuals) (2:42, 14:53).
2. **Take Derivative:** Calculate the derivative of the loss function with respect to the parameter(s) you want to optimize. This derivative tells you the slope of the curve at any given parameter value (7:26, 15:02).
3. **Initial Guess:** Pick a random starting value for the parameter (2:22, 15:10).
4. **Calculate Slope:** Plug the current parameter value into the derivative to find the slope of the loss function curve at that point (9:48, 15:17).
5. **Calculate Step Size:** Multiply the slope by a small number called the **learning rate**. This determines how big of a step to take (10:47, 15:23).
    - **Note on Learning Rate:** A learning rate that is too large can prevent convergence to the optimal solution (20:19). In practice, learning rates often start large and decrease over time (20:35).
6. **Calculate New Parameter:** The new parameter value is the old parameter value minus the step size (11:11, 15:28).
7. **Repeat:** Continuously plug the new parameter value back into the derivative and repeat steps 4-6 until the step size is very close to zero, or a maximum number of steps is reached (13:16, 13:47, 15:32).
    - **Stopping Criteria:** Gradient Descent stops when the step size is minimal (e.g., 0.001 or smaller) or when a predefined maximum number of steps (e.g., 1000 or greater) is reached (13:47, 14:27).

**Gradient Descent for Multiple Variables (e.g., Intercept and Slope)**

- When optimizing two or more parameters, you need to calculate the derivative of the loss function with respect to _each_ parameter (15:48, 16:38).
- These multiple derivatives together are called a **gradient** (19:14).
- The process remains the same:
    1. Pick random values for all parameters (19:37).
    2. Calculate the gradient (slopes for each parameter) (20:00).
    3. Calculate a step size for each parameter (20:08).
    4. Update each parameter based on its respective step size (20:55).
    5. Repeat until step sizes are minimal or max steps are reached (21:17).

**Types of Gradient Descent**

- **Stochastic Gradient Descent (SGD):** For very large datasets, SGD uses a randomly selected _subset_ of the data at each step instead of the entire dataset. This significantly reduces computation time (23:06).

**General Algorithm Steps (22:13)**

1. Take the derivative (gradient) of the loss function for each parameter.
2. Pick random values for the parameters.
3. Plug the parameter values into the derivatives (gradient).
4. Calculate the step sizes.
5. Calculate the new parameters.
6. Repeat from step 3 until the step size is very small or the maximum number of steps is reached.