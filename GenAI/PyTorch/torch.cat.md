## `torch.cat` and the `dim` Parameter

`torch.cat` concatenates (joins) a sequence of tensors along an **existing** dimension. Think of it as "gluing" tensors together.

### The `dim` Parameter

`dim` specifies **which dimension** you're joining along. All other dimensions must match exactly.

```python
import torch

# Shape: (2, 3)
a = torch.tensor([[1, 2, 3],
                  [4, 5, 6]])

b = torch.tensor([[7, 8, 9],
                  [10, 11, 12]])
```

### `dim=0` (along rows)
```python
torch.cat((a, b), dim=0)  # Shape: (4, 3)
# [[1, 2, 3],
#  [4, 5, 6],
#  [7, 8, 9],
#  [10, 11, 12]]
```
You're stacking **vertically** (more rows).

### `dim=1` (along columns)
```python
torch.cat((a, b), dim=1)  # Shape: (2, 6)
# [[1, 2, 3, 7, 8, 9],
#  [4, 5, 6, 10, 11, 12]]
```
You're stacking **horizontally** (more columns).

---

### With 3D tensors (e.g., batches of images)
- `dim=0`: Add more images to the batch
- `dim=1`: Stack channels (e.g., RGB + depth)
- `dim=2`: Concatenate along height
- `dim=3`: Concatenate along width

```python
# Batch of 10 RGB images: (10, 3, 224, 224)
images1 = torch.randn(10, 3, 224, 224)
images2 = torch.randn(5, 3, 224, 224)

# dim=0 -> (15, 3, 224, 224) - combine batches
combined = torch.cat([images1, images2], dim=0)

# dim=1 -> (10, 6, 224, 224) - stack channel-wise
# (e.g., concatenating RGB + infrared)
```

### Important Notes

1. **All dimensions EXCEPT the one you're concatenating along must match**:
   ```python
   # Valid: both are (2, 3)
   torch.cat((a, b), dim=0)  # ✓
   
   # Invalid: (2, 3) and (2, 4) → shape mismatch!
   c = torch.randn(2, 4)
   torch.cat((a, c), dim=1)  # ✗ Error!
   ```

2. **Negative indexing** works too:
   - `dim=-1` = last dimension
   - `dim=-2` = second-to-last

3. **`dim` must be within range**: `-rank ≤ dim < rank`

4. **`torch.cat` vs `torch.stack`**:
   - `cat` joins along an **existing** dimension (no new dimension)
   - `stack` creates a **new** dimension (e.g., stacking 3 separate (2,3) tensors → (3,2,3))

### Visual Summary

```
dim=0 → concatenates vertically   (increases rows)
dim=1 → concatenates horizontally (increases columns)
dim=N → concatenates along the Nth axis
```

**Think of `dim` as**: "Which axis should I glue these tensors together on?"