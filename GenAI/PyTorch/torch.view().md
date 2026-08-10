`view()` is one of the most commonly used PyTorch functions. Its job is very simple:

> **`view()` changes the shape of a tensor without changing its data.**

Think of it like rearranging books on a shelf—you don't change the books, you only arrange them differently.

---

# Example 1: A 1D tensor

```python
import torch

x = torch.tensor([1, 2, 3, 4, 5, 6])

print(x.shape)
```

Output

```text
torch.Size([6])
```

Visual:

```text
[1 2 3 4 5 6]
```

Now reshape it:

```python
y = x.view(2, 3)
```

Output

```text
[[1 2 3]
 [4 5 6]]
```

Shape

```text
(2,3)
```

Notice

The numbers **didn't change**.

Only their arrangement did.

---

# Example 2

Same data

```text
1 2 3 4 5 6
```

Now

```python
y = x.view(3,2)
```

Result

```text
[[1 2]
 [3 4]
 [5 6]]
```

Shape

```text
(3,2)
```

Again,

Same numbers.

Different shape.

---

# Total number of elements must stay the same

Original tensor

```text
6 elements
```

You can reshape it into

```text
(2,3)

2×3 = 6
```

or

```text
(3,2)

3×2 = 6
```

or

```text
(1,6)

1×6 = 6
```

But **not**

```python
x.view(4,2)
```

because

```text
4×2 = 8
```

PyTorch will throw an error:

```text
RuntimeError:
shape '[4,2]' is invalid for input of size 6
```

---

# Using `-1`

A very convenient feature is

```python
x.view(-1, 3)
```

PyTorch automatically calculates the missing dimension.

Original tensor

```text
6 elements
```

You asked for

```text
(?,3)
```

PyTorch computes

```text
6 / 3 = 2
```

Result

```text
(2,3)
```

Similarly

```python
x.view(3,-1)
```

becomes

```text
(3,2)
```

---

# Why is `view()` used so much in Deep Learning?

Neural networks often expect specific input shapes.

Suppose you have a grayscale image.

Shape

```text
(28,28)
```

That's

```text
784 pixels
```

A fully connected (`nn.Linear`) layer expects a vector.

So before passing the image to the network:

```python
image = image.view(784)
```

Now

```text
(784,)
```

instead of

```text
(28,28)
```

---

# Another common example

Suppose you have

```text
Batch of 32 images

Shape

(32,1,28,28)
```

Here

- 32 = batch size
    
- 1 = grayscale channel
    
- 28×28 = image
    

Before feeding into a Linear layer:

```python
images = images.view(32, 784)
```

Now

```text
(32,784)
```

Each image becomes one long vector.

---

# Why is `view()` important in Transformers?

Transformers frequently reshape tensors before and after attention.

For example

Suppose

```text
(batch_size,
 seq_len,
 d_model)

=

(32,20,512)
```

You want

```text
8 attention heads
```

Each head gets

```text
512 / 8 = 64
```

dimensions.

So you'll often see

```python
x = x.view(batch_size,
           seq_len,
           num_heads,
           head_dim)
```

Result

```text
(32,20,8,64)
```

Nothing changed about the data.

The same 512 values are simply grouped into **8 chunks of 64**.

Visual:

```text
Before

Token

[512 values]

↓

After

Head1

[64]

Head2

[64]

...

Head8

[64]
```

This reshape is essential because each attention head processes its own slice of the embedding independently.

---

# `view()` vs `reshape()`

You'll also see

```python
x.reshape(...)
```

The difference is:

- `view()` only works if the tensor's data is stored **contiguously** in memory.
    
- `reshape()` tries to return a view if possible, but if not, it silently creates a copy.
    

Because tensors are often rearranged (for example, using `transpose()` or `permute()`) in transformers, it's common to see:

```python
x = x.transpose(1, 2).contiguous().view(...)
```

The `.contiguous()` call ensures the tensor's memory layout is suitable for `view()`. If you omit it after certain operations, `view()` may raise an error even though the requested shape has the correct number of elements.