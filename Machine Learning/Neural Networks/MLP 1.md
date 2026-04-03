## MULTI-LAYER PERCEPTRON (MLP) / NEURAL NETWORKS

**Definition:** A supervised learning algorithm that learns a function by training on a dataset, consisting of multiple layers of nodes (neurons) where each layer is fully connected to the next. Also called Feed-Forward Neural Network or Deep Neural Network (when many layers). Uses backpropagation and gradient descent to learn weights that minimize prediction error.

**Used For:**

- Classification (binary and multi-class)
- Regression
- Pattern recognition
- Function approximation
- Time series prediction
- Image recognition
- Natural language processing
- Speech recognition
- Recommendation systems
- Anomaly detection

**Cases of Application:**

- Computer vision (image classification, object detection)
- Natural Language Processing (sentiment analysis, translation)
- Speech recognition
- Medical diagnosis
- Financial forecasting
- Fraud detection
- Customer churn prediction
- Recommendation engines (Netflix, Amazon)
- Autonomous vehicles
- Game playing (AlphaGo)
- Handwriting recognition
- Face recognition
- Weather prediction
- Drug discovery

**Prerequisites:**

- Labeled training data
- **Features MUST be numerical**
- **Feature scaling CRITICAL** (StandardScaler or MinMaxScaler)
- Handle missing values before training
- Sufficient data (more data = better performance)
- Computational resources (GPU recommended for large networks)
- Patience (longer training than traditional ML)
- Understanding of overfitting/underfitting
- Willingness to tune many hyperparameters

**Performance Measures:**

- **Classification:** Accuracy, Precision, Recall, F1-Score, Confusion Matrix, ROC-AUC, Log Loss, Cross-Entropy
- **Regression:** MAE, MSE, RMSE, R² Score, MAPE
- **Training-specific:**
    - Training loss vs validation loss curves
    - Learning curves
    - Convergence speed
    - Number of iterations to converge
    - Gradient norms
- Early stopping patience
- Cross-validation scores

---

## HOW MLP WORKS

### **Core Concept:**

Multiple layers of interconnected neurons transform input features through weighted connections and activation functions to produce predictions. The network "learns" by adjusting weights to minimize error through backpropagation.

**Visual Intuition:**

```
INPUT LAYER → HIDDEN LAYERS → OUTPUT LAYER

Example: 3-layer MLP (1 hidden layer)

Input Layer    Hidden Layer    Output Layer
   (4)            (5)              (3)

   x₁ ────────→  h₁  ────────→  y₁ (Class A)
        ↘     ↗  h₂  ↗     ↘
   x₂ ─────────→  h₃  ────────→  y₂ (Class B)
        ↗     ↘  h₄  ↘     ↗
   x₃ ────────→  h₅  ────────→  y₃ (Class C)
        ↘     ↗
   x₄ ─────────→
   
Each arrow = weight
Each node = activation function

Information flows LEFT → RIGHT (feed-forward)
Learning flows RIGHT → LEFT (backpropagation)
```

### **Key Ideas:**

1. **Layers:**
    
    - **Input Layer:** Raw features (not counted as "layer")
    - **Hidden Layers:** Extract features, transform data
    - **Output Layer:** Final predictions
2. **Neurons/Nodes:**
    
    - Compute weighted sum of inputs
    - Apply activation function
    - Pass result to next layer
3. **Weights (Parameters):**
    
    - Each connection has a weight
    - Learned during training
    - Determine importance of connections
4. **Biases:**
    
    - One per neuron
    - Allows shifting activation function
    - Like intercept in linear regression
5. **Activation Functions:**
    
    - Non-linear transformations
    - Enable learning complex patterns
    - Applied after weighted sum
6. **Forward Propagation:**
    
    - Input → Hidden → Output
    - Compute predictions
7. **Backpropagation:**
    
    - Calculate gradient of loss
    - Propagate error backwards
    - Update weights to reduce error

---

## MATHEMATICAL FOUNDATION

### **Single Neuron (Perceptron)**

**Basic Unit:**

```
Input: x = [x₁, x₂, ..., xₙ]
Weights: w = [w₁, w₂, ..., wₙ]
Bias: b

Weighted Sum (z):
z = w₁x₁ + w₂x₂ + ... + wₙxₙ + b
z = wᵀx + b

Activation (a):
a = f(z)

Where f = activation function (sigmoid, ReLU, etc.)
```

**Example:**

```
Inputs: x₁=2, x₂=3, x₃=1
Weights: w₁=0.5, w₂=-0.3, w₃=0.8
Bias: b=0.1

z = (0.5)(2) + (-0.3)(3) + (0.8)(1) + 0.1
z = 1.0 - 0.9 + 0.8 + 0.1 = 1.0

If using ReLU: a = max(0, 1.0) = 1.0
If using sigmoid: a = 1/(1+e⁻¹·⁰) ≈ 0.731
```

---

### **Multi-Layer Network**

**Layer-by-Layer Computation:**

```
Input Layer: x ∈ ℝⁿ

Hidden Layer 1:
z⁽¹⁾ = W⁽¹⁾x + b⁽¹⁾
a⁽¹⁾ = f(z⁽¹⁾)

Hidden Layer 2:
z⁽²⁾ = W⁽²⁾a⁽¹⁾ + b⁽²⁾
a⁽²⁾ = f(z⁽²⁾)

Output Layer:
z⁽³⁾ = W⁽³⁾a⁽²⁾ + b⁽³⁾
ŷ = f(z⁽³⁾)

Where:
- W⁽ⁱ⁾ = weight matrix for layer i
- b⁽ⁱ⁾ = bias vector for layer i
- f = activation function
- a⁽ⁱ⁾ = activation (output) of layer i
```

**Matrix Dimensions:**

```
Example: 4 inputs → 5 hidden → 3 outputs

W⁽¹⁾: (5 × 4) matrix - connects 4 inputs to 5 hidden neurons
b⁽¹⁾: (5 × 1) vector - bias for 5 hidden neurons
a⁽¹⁾: (5 × 1) vector - output of hidden layer

W⁽²⁾: (3 × 5) matrix - connects 5 hidden to 3 outputs
b⁽²⁾: (3 × 1) vector - bias for 3 output neurons
ŷ: (3 × 1) vector - final predictions

Total parameters: (5×4 + 5) + (3×5 + 3) = 43 parameters
```

---

### **Loss Functions**

**Classification (Cross-Entropy):**

**Binary Classification:**

```
Loss = -[y log(ŷ) + (1-y) log(1-ŷ)]

Where:
- y = true label (0 or 1)
- ŷ = predicted probability

Example:
True: y=1, Predicted: ŷ=0.8
Loss = -[1×log(0.8) + 0×log(0.2)]
     = -log(0.8) ≈ 0.223

True: y=1, Predicted: ŷ=0.2
Loss = -log(0.2) ≈ 1.609 (high penalty!)
```

**Multi-class Classification:**

```
Loss = -Σ yₖ log(ŷₖ)

Where k = number of classes

Example (3 classes):
True: [1, 0, 0] (Class A)
Predicted: [0.7, 0.2, 0.1]
Loss = -(1×log(0.7) + 0×log(0.2) + 0×log(0.1))
     = -log(0.7) ≈ 0.357
```

**Regression (Mean Squared Error):**

```
Loss = (1/2)(y - ŷ)²

Example:
True: y=10
Predicted: ŷ=8
Loss = (1/2)(10-8)² = 2

True: y=10
Predicted: ŷ=15
Loss = (1/2)(10-15)² = 12.5 (bigger error!)
```

---

### **Backpropagation**

**Core Idea:** Calculate gradient of loss with respect to each weight, then update weights in direction that reduces loss.

**Chain Rule:**

```
For weight connecting neuron j to neuron i:

∂Loss/∂wᵢⱼ = ∂Loss/∂aᵢ × ∂aᵢ/∂zᵢ × ∂zᵢ/∂wᵢⱼ

Where:
- aᵢ = activation of neuron i
- zᵢ = weighted sum input to neuron i
- wᵢⱼ = weight from j to i

Step 1: Compute error at output (∂Loss/∂aᵢ)
Step 2: Multiply by derivative of activation (∂aᵢ/∂zᵢ)
Step 3: Multiply by input from previous layer (∂zᵢ/∂wᵢⱼ)
Step 4: Propagate error backwards to previous layers
```

**Gradient Descent Update:**

```
wᵢⱼ_new = wᵢⱼ_old - α × ∂Loss/∂wᵢⱼ

Where α = learning rate

Example:
wᵢⱼ = 0.5
∂Loss/∂wᵢⱼ = 0.3 (positive gradient = increase loss)
α = 0.1

wᵢⱼ_new = 0.5 - 0.1 × 0.3 = 0.47

Weight decreased → loss should decrease
```

---

## ACTIVATION FUNCTIONS

**Critical component! Enables learning non-linear patterns.**

### **Why Needed:**

```
Without activation:
Layer 1: z₁ = W₁x + b₁
Layer 2: z₂ = W₂z₁ + b₂
        = W₂(W₁x + b₁) + b₂
        = (W₂W₁)x + (W₂b₁ + b₂)
        = Wx + b (still linear!)

Multiple linear layers = single linear layer
Cannot learn XOR, complex patterns

With activation f:
Layer 1: a₁ = f(W₁x + b₁)
Layer 2: a₂ = f(W₂a₁ + b₂)
Now can learn non-linear patterns!
```

---

### **1. ReLU (Rectified Linear Unit)**

**Formula:**

```
f(z) = max(0, z)

      |  z    if z > 0
f(z) =|
      |  0    if z ≤ 0
```

**Derivative:**

```
       |  1    if z > 0
f'(z) =|
       |  0    if z ≤ 0
```

**Graph:**

```
f(z)
  ^
  |      /
  |     /
  |    /
  |   /
  |__/________> z
  |  0
  
Slope = 1 for z > 0
Slope = 0 for z ≤ 0
```

**Properties:**

- **Most popular** in modern deep learning
- Fast computation (simple max operation)
- Helps with vanishing gradient problem
- Sparse activation (many zeros)
- Not centered around zero
- Can cause "dying ReLU" (neurons stuck at 0)

**When to Use:**

- **Default choice** for hidden layers
- Deep networks (many layers)
- Convolutional neural networks
- Most modern architectures

**Avoid When:**

- Output layer (unless specific case)
- Very shallow networks (sigmoid/tanh okay)

**Example:**

```
z = [-2, -1, 0, 1, 2]
f(z) = [0, 0, 0, 1, 2]

50% of neurons activated (sparse)
```

---

### **2. Sigmoid (Logistic)**

**Formula:**

```
f(z) = 1 / (1 + e⁻ᶻ)

Range: (0, 1)
```

**Derivative:**

```
f'(z) = f(z) × (1 - f(z))
```

**Graph:**

```
f(z)
 1 |        ______
   |       /
0.5|______/
   |     /
 0 |____/________> z
      -∞   0   ∞
```

**Properties:**

- Output between 0 and 1 (probability interpretation)
- Smooth, differentiable everywhere
- Suffers from vanishing gradient (for deep networks)
- Computationally expensive (exponential)
- Not zero-centered
- Output saturation (gradient ≈ 0 for |z| > 5)

**When to Use:**

- **Binary classification output layer** (default)
- Need probability estimates
- Shallow networks (1-2 hidden layers)
- Historical/legacy models

**Avoid When:**

- Hidden layers in deep networks (use ReLU)
- Very deep networks (vanishing gradient)

**Example:**

```
z = [-5, -2, 0, 2, 5]
f(z) ≈ [0.007, 0.119, 0.5, 0.881, 0.993]

For z=10: f(z) ≈ 0.9999 (saturated)
For z=-10: f(z) ≈ 0.0001 (saturated)
Gradient ≈ 0 in saturation → learning stops
```

---

### **3. Tanh (Hyperbolic Tangent)**

**Formula:**

```
f(z) = (eᶻ - e⁻ᶻ) / (eᶻ + e⁻ᶻ)

Range: (-1, 1)
```

**Derivative:**

```
f'(z) = 1 - f(z)²
```

**Graph:**

```
f(z)
 1 |        ______
   |       /
 0 |______/
   |     /
-1 |____/________> z
      -∞   0   ∞
```

**Properties:**

- Output between -1 and 1
- Zero-centered (better than sigmoid)
- Still suffers from vanishing gradient
- Computationally expensive
- Smoother gradient than sigmoid

**When to Use:**

- Hidden layers in shallow networks
- Recurrent neural networks (RNN, LSTM)
- When zero-centered output needed
- Better than sigmoid for hidden layers

**Avoid When:**

- Deep networks (use ReLU)
- Output layer (unless specific range needed)

**Example:**

```
z = [-2, -1, 0, 1, 2]
f(z) ≈ [-0.964, -0.762, 0, 0.762, 0.964]

Zero-centered (mean ≈ 0)
```

---

### **4. Leaky ReLU**

**Formula:**

```
f(z) = max(αz, z)

      |  z      if z > 0
f(z) =|
      |  αz     if z ≤ 0

Where α = small constant (e.g., 0.01)
```

**Derivative:**

```
       |  1     if z > 0
f'(z) =|
       |  α     if z ≤ 0
```

**Graph:**

```
f(z)
  ^
  |      /
  |     /
  |    /
  |   /
  |__/________> z
  | /  0
  |/
  
Small negative slope for z < 0
```

**Properties:**

- Fixes "dying ReLU" problem
- Allows small negative values
- All benefits of ReLU
- Slightly more computation

**When to Use:**

- When ReLU causes dying neurons
- Deep networks
- Alternative to ReLU

**Example:**

```
α = 0.01
z = [-2, -1, 0, 1, 2]
f(z) = [-0.02, -0.01, 0, 1, 2]

Negative values preserved (scaled)
```

---

### **5. Softmax (Output Layer)**

**Formula:**

```
f(zᵢ) = e^zᵢ / Σⱼ e^zⱼ

Converts scores to probabilities
```

**Properties:**

- **Only for output layer**
- Multi-class classification
- Output sums to 1.0
- Each output is probability
- Always use with categorical cross-entropy

**When to Use:**

- **Multi-class classification output layer** (default)
- Need probability distribution
- Mutually exclusive classes

**Example:**

```
Output layer logits: z = [2.0, 1.0, 0.1]

Softmax:
e^2.0 = 7.39
e^1.0 = 2.72
e^0.1 = 1.11
Sum = 11.22

Probabilities:
f(z₁) = 7.39/11.22 = 0.659 (65.9%)
f(z₂) = 2.72/11.22 = 0.242 (24.2%)
f(z₃) = 1.11/11.22 = 0.099 (9.9%)

Sum = 1.000 ✓

Predict: Class 1 (highest probability)
```

---

### **6. Linear (No Activation)**

**Formula:**

```
f(z) = z

Identity function
```

**When to Use:**

- **Regression output layer** (default)
- Want unrestricted output range

**Example:**

```
Predicting house prices:
Output: $150,000 (no bounds)

Using linear activation at output
```

---

### **Activation Function Comparison:**

|Function|Range|Hidden Layers|Output Layer|Pros|Cons|
|---|---|---|---|---|---|
|**ReLU**|[0, ∞)|**Yes (default)**|No|Fast, sparse, deep|Dying neurons|
|**Leaky ReLU**|(-∞, ∞)|Yes|No|Fixes dying ReLU|Slightly slower|
|**Sigmoid**|(0, 1)|No (shallow only)|**Binary class**|Probabilistic|Vanishing gradient|
|**Tanh**|(-1, 1)|Yes (shallow)|No|Zero-centered|Vanishing gradient|
|**Softmax**|(0, 1)|No|**Multi-class**|Probabilities sum=1|Output only|
|**Linear**|(-∞, ∞)|No|**Regression**|No bounds|No non-linearity|

---

### **Typical Architecture:**

```
Binary Classification:
Input → [ReLU] → [ReLU] → [Sigmoid] → Output (0 or 1)

Multi-class Classification:
Input → [ReLU] → [ReLU] → [Softmax] → Output (probabilities)

Regression:
Input → [ReLU] → [ReLU] → [Linear] → Output (continuous)

Deep Network:
Input → [ReLU]×10 layers → [appropriate output] → Output
```

---

## KEY HYPERPARAMETERS

### **1. hidden_layer_sizes**

**Definition:** Tuple specifying number of neurons in each hidden layer.

**Format:** (layer1_size, layer2_size, ...)

**Default:** (100,) - single hidden layer with 100 neurons

**Examples:**

```python
# Single hidden layer, 50 neurons
hidden_layer_sizes=(50,)

# Two hidden layers: 100 and 50 neurons
hidden_layer_sizes=(100, 50)

# Three hidden layers: 128, 64, 32 neurons
hidden_layer_sizes=(128, 64, 32)

# Deep network: 5 layers
hidden_layer_sizes=(256, 128, 64, 32, 16)
```

**Impact:**

**More layers (depth):**

- Can learn more complex patterns
- Hierarchical feature learning
- Needs more data
- Slower training
- Harder to train (vanishing gradient)
- Overfitting risk if too many

**More neurons (width):**

- More capacity per layer
- Can fit training data better
- Overfitting risk if too many
- Slower training
- More parameters

**Visual:**

```
Shallow & Wide: (500,)
    Good for: Simple patterns, small datasets
    
Medium: (100, 50)
    Good for: Most tabular data
    
Deep & Narrow: (50, 50, 50, 50)
    Good for: Images, complex patterns
    
Deep & Wide: (512, 256, 128)
    Good for: Large datasets, complex patterns
```

**Choosing Architecture:**

**Start Simple:**

```python
# Baseline: single hidden layer
model = MLPClassifier(hidden_layer_sizes=(100,))
```

**Common Patterns:**

```python
# Small dataset (n < 1000)
hidden_layer_sizes=(50,) or (50, 25)

# Medium dataset (1000 < n < 10000)
hidden_layer_sizes=(100, 50) or (100,)

# Large dataset (n > 10000)
hidden_layer_sizes=(128, 64, 32) or (200, 100)

# Very complex patterns (images, etc.)
hidden_layer_sizes=(512, 256, 128, 64)
```

**Rules of Thumb:**

1. Start with 1-2 hidden layers
2. Neurons between input size and output size
3. Often decreasing: (100, 50, 25)
4. Try powers of 2: (128, 64, 32)
5. More data → can use more neurons/layers
6. Start small, increase if underfitting

**Total Parameters:**

```
Input: 10 features
Hidden: (100, 50)
Output: 3 classes

Layer 1: (10 × 100) + 100 = 1,100
Layer 2: (100 × 50) + 50 = 5,050
Output: (50 × 3) + 3 = 153
Total: 6,303 parameters

More parameters = more capacity but more overfitting risk
```

---

### **2. activation**

**Definition:** Activation function for hidden layers.

**Values:** 'relu' (default), 'tanh', 'logistic' (sigmoid), 'identity'

**Default:** 'relu'

**Impact:**

**'relu' (default):**

- Fast, effective
- Best for most cases
- Deep networks
- Modern standard

**'tanh':**

- Good for shallow networks
- Zero-centered
- Slower than ReLU

**'logistic' (sigmoid):**

- Rarely used for hidden layers
- Only for shallow networks
- Historical

**'identity' (linear):**

- No non-linearity
- Almost never used
- Special cases only

**Example:**

```python
# Default (recommended)
model = MLPClassifier(activation='relu')

# For shallow network
model = MLPClassifier(activation='tanh', hidden_layer_sizes=(50,))
```

**Recommendation:**

- **Always use 'relu'** unless specific reason
- Try 'tanh' if ReLU doesn't work
- Never use 'identity'

---

### **3. solver**

**Definition:** Algorithm for weight optimization.

**Values:** 'adam' (default), 'sgd', 'lbfgs'

**Default:** 'adam'

**Comparison:**

**'adam' (Adaptive Moment Estimation):**

```
Properties:
- Adaptive learning rate per parameter
- Works well with default settings
- Fast convergence
- Best for large datasets
- Most popular choice

Use when:
- Default choice for most problems
- Large datasets (n > 1000)
- Don't want to tune learning rate much
```

**'sgd' (Stochastic Gradient Descent):**

```
Properties:
- Simple, classic algorithm
- Requires careful learning rate tuning
- Supports momentum and nesterov
- Good with proper tuning
- Can escape local minima with momentum

Use when:
- Need fine control
- Using learning_rate_init and momentum
- Small to medium datasets
```

**'lbfgs' (Limited-memory BFGS):**

```
Properties:
- Quasi-Newton method
- Fast for small datasets
- Stores approximation of Hessian
- No mini-batches (uses entire dataset)
- Can converge faster on small data

Use when:
- Small datasets (n < 1000)
- Want fast convergence
- Not using mini-batches
```

**Example:**

```python
# Default (recommended for most)
model = MLPClassifier(solver='adam')

# For small dataset
model = MLPClassifier(solver='lbfgs', max_iter=500)

# For fine-tuned control
model = MLPClassifier(
    solver='sgd',
    learning_rate_init=0.01,
    momentum=0.9,
    nesterovs_momentum=True
)
```

**Recommendation:**

- **Start with 'adam'** (best default)
- Try 'lbfgs' if n < 1000
- Use 'sgd' only if you know what you're doing

---

### **4. alpha (L2 Regularization)**

**Definition:** L2 penalty (regularization) parameter.

**Range:** [0, ∞), typically [0.0001, 1]

**Default:** 0.0001

**Formula:**

```
Loss_total = Loss_data + α × Σ(w²)

Where:
- Loss_data = prediction error
- α = alpha (regularization strength)
- Σ(w²) = sum of squared weights
```

**Impact:**

**Large alpha (e.g., 0.1, 1.0):**

- Strong regularization
- Smaller weights
- Simpler model
- **Underfitting risk**
- Better generalization (if not underfit)

**Small alpha (e.g., 0.0001, 0.00001):**

- Weak regularization
- Larger weights
- More complex model
- **Overfitting risk**
- Fits training data better

**Zero alpha:**

- No regularization
- High overfitting risk
- Not recommended

**Example:**

```python
# Weak regularization (default)
model = MLPClassifier(alpha=0.0001)

# Moderate regularization
model = MLPClassifier(alpha=0.01)

# Strong regularization
model = MLPClassifier(alpha=1.0)
```

**Tuning Strategy:**

- Start with default (0.0001)
- Increase if overfitting
- Decrease if underfitting
- Grid search: [0.0001, 0.001, 0.01, 0.1, 1.0]

**Signs of Overfitting:**

```
Train accuracy: 99%
Test accuracy: 70%
→ Increase alpha

Train accuracy: 75%
Test accuracy: 73%
→ Decrease alpha or model okay
```

---

### **5. learning_rate_init**

**Definition:** Initial learning rate for weight updates.

**Range:** (0, 1], typically [0.0001, 0.1]

**Default:** 0.001

**Formula:**

```
w_new = w_old - learning_rate × gradient

Example:
w = 0.5
gradient = 0.3
learning_rate = 0.1

w_new = 0.5 - 0.1 × 0.3 = 0.47
```

**Impact:**

**Large learning rate (e.g., 0.1, 1.0):**

- Big weight updates
- Fast convergence (initially)
- May overshoot minimum
- Unstable training
- May never converge
- Loss oscillates

**Small learning rate (e.g., 0.0001, 0.00001):**

- Small weight updates
- Slow but stable convergence
- May get stuck in local minima
- Very long training time
- Smooth loss curves

**Visual:**

```
Loss
 ^
 |     Large LR: \/\/\/\/  (oscillates, unstable)
 |
 |     Good LR:   \\\\     (smooth descent)
 |
 |     Small LR:   \___    (too slow)
 |________________> Iterations
```

**Example:**

```python
# Conservative (slow but stable)
model = MLPClassifier(learning_rate_init=0.0001)

# Default (good balance)
model = MLPClassifier(learning_rate_init=0.001)

# Aggressive (fast but may be unstable)
model = MLPClassifier(learning_rate_init=0.01)
```

**Tuning Strategy:**

- Start with default (0.001)
- If not converging: decrease
- If too slow: increase
- Watch training loss curve
- Grid search: [0.0001, 0.001, 0.01, 0.1]

**Learning Rate Schedules:**

```python
# Constant (default)
learning_rate='constant'

# Gradually decrease
learning_rate='invscaling'  # lr = learning_rate_init / t^power_t

# Adaptive
learning_rate='adaptive'  # decrease when no improvement
```

---

### **6. max_iter**

**Definition:** Maximum number of iterations/epochs.

**Range:** [1, ∞), typically [100, 1000]

**Default:** 200

**Impact:**

**More iterations:**

- More training time
- Better convergence
- May overfit if too many
- Network has more chances to learn

**Fewer iterations:**

- Faster training
- May not converge
- Underfitting risk

**Example:**

```python
# Quick test
model = MLPClassifier(max_iter=100)

# Default
model = MLPClassifier(max_iter=200)

# Thorough training
model = MLPClassifier(max_iter=1000)

# Until convergence
model = MLPClassifier(max_iter=10000, early_stopping=True)
```

**Tuning Strategy:**

- Start with 200-500
- Increase if not converged (check warnings)
- Use early_stopping=True for automatic stopping
- Monitor validation loss

**Convergence:**

```
Iteration 100: loss = 0.523
Iteration 150: loss = 0.234
Iteration 200: loss = 0.156
Iteration 250: loss = 0.155
Iteration 300: loss = 0.154

Converged! (loss barely changing)
No need for more iterations
```

---

### **7. batch_size**

**Definition:** Number of samples per gradient update.

**Range:** [1, n_samples] or 'auto'

**Default:** 'auto' = min(200, n_samples)

**Impact:**

**Large batch (e.g., 512, 1000):**

- Stable gradient estimates
- Faster per epoch (vectorization)
- Less noise in training
- May converge to