Since you're learning transformers, `torch.nn` is probably the most important PyTorch module you'll use. It contains almost everything needed to build neural networks, including the components that make up a transformer (embeddings, linear layers, layer normalization, dropout, etc.).

Think of `torch.nn` as a collection of **ready-made neural network building blocks**.

---

# What is torch.nn?

Instead of manually writing the mathematics for every forward and backward pass, PyTorch provides these layers.

For example, instead of writing

[  
Y = XW + b  
]

yourself, you simply do

```python
linear = nn.Linear(512, 1024)
```

and PyTorch automatically

- initializes the weights
    
- stores them
    
- computes the forward pass
    
- computes gradients during backprop
    

---

# The most important parts of torch.nn

There are several categories.

```
torch.nn
│
├── Layers
├── Activation functions
├── Loss functions
├── Containers
├── Normalization
├── Dropout
├── Embeddings
├── Attention
└── Utility modules
```

Let's go through each.

---

# 1. Layers

These perform transformations on data.

## Linear Layer

Probably the most common.

```python
nn.Linear(in_features, out_features)
```

Example

```python
linear = nn.Linear(4, 3)
```

Input

```
[batch, 4]
```

Output

```
[batch, 3]
```

Internally

[  
Y = XW + b  
]

Every transformer contains dozens of Linear layers.

For example

```
Embedding

↓

Linear

↓

Linear

↓

Linear
```

---

## Conv2D

Mostly used for images.

```python
nn.Conv2d()
```

Not used in standard transformers.

---

## RNN/LSTM/GRU

Older sequence models.

```python
nn.LSTM()
```

Transformers largely replaced these.

---

# 2. Activation Functions

Without activations, multiple Linear layers collapse into one Linear layer.

Common activations:

```
ReLU
Sigmoid
Tanh
GELU
SiLU
```

Example

```python
relu = nn.ReLU()
```

Usage

```python
x = relu(x)
```

---

### GELU

Transformers usually use

```python
nn.GELU()
```

instead of ReLU.

You'll see

```
Linear

↓

GELU

↓

Linear
```

inside every transformer feed-forward network.

---

# 3. Loss Functions

Used only during training.

Examples

Classification

```python
nn.CrossEntropyLoss()
```

Binary classification

```python
nn.BCELoss()
```

Regression

```python
nn.MSELoss()
```

Language models almost always use

```python
CrossEntropyLoss
```

because they predict the next token.

---

# 4. Containers

These help organize layers.

## nn.Sequential
[[nn.Sequential]]

Instead of

```python
x = layer1(x)
x = layer2(x)
x = layer3(x)
```

you can write

```python
model = nn.Sequential(
    nn.Linear(10,20),
    nn.ReLU(),
    nn.Linear(20,5)
)
```

Now

```python
output = model(x)
```

runs every layer.

Useful for simple networks.

Not used much in transformers because they have branching logic (attention, residual connections, etc.).

---

## nn.ModuleList

Just stores layers.

Example

```python
self.layers = nn.ModuleList([
    nn.Linear(512,512)
    for _ in range(12)
])
```

Now you can iterate.

```python
for layer in self.layers:
    x = layer(x)
```

Transformer encoders are often built this way.

---

# 5. Normalization

Makes training stable.

Most famous:

```python
nn.LayerNorm()
```

Transformers use this everywhere.

Example

```
Attention

↓

Add

↓

LayerNorm

↓

Feed Forward

↓

Add

↓

LayerNorm
```

---

BatchNorm exists too.

```python
nn.BatchNorm1d()
```

Mostly used in CNNs.

---

# 6. Dropout

Randomly removes neurons during training.

```python
nn.Dropout(0.1)
```

Meaning

10% of values become zero.

Purpose

Prevent overfitting.

Transformers often use

```python
Dropout(0.1)
```

after attention and feed-forward layers.

---

# 7. Embeddings

Very important.

```python
nn.Embedding(vocab_size, embedding_dim)
```

Example

```python
embedding = nn.Embedding(50000,768)
```

Suppose token IDs are

```
[21, 45, 8]
```

Output becomes

```
[
 vector21,
 vector45,
 vector8
]
```

Shape

```
(3,768)
```

Every language model starts with an Embedding layer.

---

# 8. Attention

PyTorch even provides attention.

```python
nn.MultiheadAttention()
```

Example

```python
attention = nn.MultiheadAttention(
    embed_dim=768,
    num_heads=12
)
```

Internally it computes

```
Q

↓

K

↓

V

↓

Softmax

↓

Weighted Sum
```

Exactly the attention you've been studying.

---

# 9. Utility Modules

Examples

Identity

```python
nn.Identity()
```

Flatten

```python
nn.Flatten()
```

Upsampling

```python
nn.Upsample()
```

Adaptive pooling

```python
nn.AdaptiveAvgPool2d()
```

Not especially important for transformers.

---

# The most important class: `nn.Module`

Every neural network you write inherits from this class.

Example

```python
import torch
import torch.nn as nn

class MyModel(nn.Module):
    def __init__(self):
        super().__init__()

        self.linear = nn.Linear(10, 20)
        self.relu = nn.ReLU()

    def forward(self, x):
        x = self.linear(x)
        x = self.relu(x)
        return x
```

Here:

- `nn.Module` provides the infrastructure for parameters, training/evaluation modes, and saving/loading.
    
- `__init__()` defines the layers.
    
- `forward()` defines how data flows through those layers.
    

Then you use it like this:

```python
model = MyModel()

x = torch.randn(5, 10)

output = model(x)
```

Calling `model(x)` automatically invokes the `forward()` method.

---

# How a Transformer is built using `torch.nn`

A simplified transformer block looks like this:

```python
class TransformerBlock(nn.Module):
    def __init__(self):
        super().__init__()

        self.attn = nn.MultiheadAttention(768, 12)
        self.norm1 = nn.LayerNorm(768)

        self.ffn = nn.Sequential(
            nn.Linear(768, 3072),
            nn.GELU(),
            nn.Linear(3072, 768)
        )

        self.norm2 = nn.LayerNorm(768)
        self.dropout = nn.Dropout(0.1)

    def forward(self, x):
        attn_out, _ = self.attn(x, x, x)
        x = self.norm1(x + self.dropout(attn_out))

        ffn_out = self.ffn(x)
        x = self.norm2(x + self.dropout(ffn_out))

        return x
```

Notice how it's assembled almost entirely from `torch.nn` components.

---

## The 20% of `torch.nn` you'll use for transformers 80% of the time

|Component|Purpose|
|---|---|
|`nn.Module`|Base class for every model|
|`nn.Linear`|Feed-forward layers and Q/K/V projections|
|`nn.Embedding`|Convert token IDs to vectors|
|`nn.LayerNorm`|Normalize activations for stable training|
|`nn.Dropout`|Regularization during training|
|`nn.GELU`|Activation in feed-forward networks|
|`nn.MultiheadAttention`|Self-attention mechanism (mainly for learning or custom models)|
|`nn.Sequential`|Stack simple layers together|
|`nn.ModuleList`|Store repeated layers, such as multiple transformer blocks|
|`nn.CrossEntropyLoss`|Training objective for next-token prediction|

As you progress to implementing transformer architectures from scratch, you'll find that many educational implementations don't use `nn.MultiheadAttention`. Instead, they build attention manually using `nn.Linear` layers to create the query (Q), key (K), and value (V) projections, followed by explicit matrix multiplications and softmax. This exposes the underlying mechanics while still relying on `torch.nn` for the learnable components.Since you're learning transformers, `torch.nn` is probably the most important PyTorch module you'll use. It contains almost everything needed to build neural networks, including the components that make up a transformer (embeddings, linear layers, layer normalization, dropout, etc.).

Think of `torch.nn` as a collection of **ready-made neural network building blocks**.

---
