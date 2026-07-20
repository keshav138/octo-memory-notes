`unsqueeze()` adds a new dimension of size **1** to a tensor at the specified position. It **doesn't change the data**, only the tensor's shape.

### Example 1: Add a batch dimension

```python
import torch

x = torch.tensor([1, 2, 3])
print(x.shape)
# torch.Size([3])

x = x.unsqueeze(0)
print(x.shape)
# torch.Size([1, 3])
```

Before:

```text
[1, 2, 3]
```

After:

```text
[
  [1, 2, 3]
]
```

This is often used to turn a single sample into a batch of one.

---

### Example 2: Add a feature dimension

```python
x = torch.tensor([1, 2, 3])
x = x.unsqueeze(1)

print(x.shape)
# torch.Size([3, 1])
```

Now the tensor looks like:

```text
[
 [1],
 [2],
 [3]
]
```

---

### General rule

If a tensor has shape

```text
(A, B, C)
```

then:

- `unsqueeze(0)` → `(1, A, B, C)`
    
- `unsqueeze(1)` → `(A, 1, B, C)`
    
- `unsqueeze(2)` → `(A, B, 1, C)`
    
- `unsqueeze(3)` → `(A, B, C, 1)`
    

---

### Why is it useful?

Many PyTorch operations expect tensors to have specific dimensions.

For example, transformers often expect input of shape:

```text
(batch_size, sequence_length)
```

If you have just one sentence:

```python
tokens = torch.tensor([101, 2054, 2003, 102])   # shape: (4,)
```

you can make it a batch of one:

```python
tokens = tokens.unsqueeze(0)  # shape: (1, 4)
```

Now it can be passed to the model.

**In one sentence:** `unsqueeze(dim)` inserts a new dimension of size `1` at the specified position without changing the underlying values.