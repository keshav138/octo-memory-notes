
## PyTorch cheatsheet — transformer / YOLO style

---

### Section 1: Tensor operations

|Operation|What it does|Example|
|---|---|---|
|`torch.tensor()`|Create tensor from data|`torch.tensor([1.0, 2.0])`|
|`torch.zeros(shape)`|All-zero tensor|`torch.zeros(3, 4)`|
|`torch.ones(shape)`|All-one tensor|`torch.ones(3, 4)`|
|`torch.rand(shape)`|Uniform random [0,1]|`torch.rand(8, 512)`|
|`torch.randn(shape)`|Standard normal random|`torch.randn(8, 512)`|
|`x.shape`|Tuple of dimensions|`x.shape → (8, 64, 512)`|
|`x.dtype`|Data type of tensor|`x.dtype → torch.float32`|
|`x.to(device)`|Move tensor to CPU/GPU|`x.to("cuda")`|
|`x.item()`|Extract scalar as Python number|`loss.item()`|

**Math**

|Operation|What it does|Example|
|---|---|---|
|`x + y`, `x * y`|Element-wise add/multiply|`x + y` — shapes must match|
|`x @ y`|Matrix multiply|`Q @ K.transpose(-2,-1)`|
|`torch.matmul(x, y)`|Same as `@`, more explicit|`torch.matmul(Q, K)`|
|`x / scalar`|Element-wise divide|`scores / math.sqrt(d_k)`|
|`torch.softmax(x, dim)`|Softmax along a dimension|`torch.softmax(scores, dim=-1)`|
|`torch.sum(x, dim)`|Sum along dimension|`torch.sum(x, dim=-1)`|
|`torch.mean(x, dim)`|Mean along dimension|`torch.mean(x, dim=1)`|
|`torch.sqrt(x)`|Element-wise square root|`torch.sqrt(tensor([4.0]))`|

**Shape manipulation**

|Operation|What it does|Example|
|---|---|---|
|`x.reshape(shape)`|Reshape, returns new view if possible|`x.reshape(8, 64, 512)`|
|`x.view(shape)`|Reshape, must be contiguous in memory|`x.view(batch, -1, heads, d_k)`|
|`x.contiguous()`|Forces contiguous memory layout (needed before `.view()` after transpose)|`x.transpose(1,2).contiguous().view(...)`|
|`x.transpose(dim1, dim2)`|Swap two dimensions|`x.transpose(1, 2)`|
|`x.permute(dims)`|Reorder all dimensions at once|`x.permute(0, 2, 1, 3)`|
|`x.unsqueeze(dim)`|Insert a size-1 dimension|`x.unsqueeze(0) → (1, seq, d)`|
|`x.squeeze(dim)`|Remove a size-1 dimension|`x.squeeze(0) → (seq, d)`|
|`torch.cat([x,y], dim)`|Concatenate tensors along dim|`torch.cat([x, y], dim=-1)`|
|`torch.stack([x,y], dim)`|Stack tensors along new dim|`torch.stack([x, y], dim=0)`|

> `view` and `reshape` are nearly identical — the difference only matters after operations like `transpose` that make memory non-contiguous. When in doubt, call `.contiguous()` before `.view()`, or just use `.reshape()` which handles it automatically.

**Indexing and masking**

|Operation|What it does|Example|
|---|---|---|
|`x[0]`|First element along dim 0|`x[0] → (seq, d_model)`|
|`x[:, 1:5, :]`|Slice along dim 1|Standard NumPy-style slicing|
|`x[mask]`|Boolean index — select where mask is True|`x[x > 0]`|
|`x.masked_fill(mask, val)`|Fill positions where mask is True with val|`scores.masked_fill(mask==0, float('-inf'))`|
|`torch.triu(x, diagonal=1)`|Upper triangle of matrix (used for causal mask)|`torch.triu(torch.ones(5,5), diagonal=1)`|

**Gradient related**

|Operation|What it does|Example|
|---|---|---|
|`x.requires_grad_(True)`|Enable gradient tracking on tensor|`w.requires_grad_(True)`|
|`loss.backward()`|Compute gradients for all tracked tensors|Called once per training step|
|`x.grad`|Gradient stored on tensor after backward|`w.grad`|
|`x.detach()`|Detach tensor from computation graph|`x.detach()` — use when you want the value but not the gradient|
|`torch.no_grad()`|Context manager — disable gradient tracking|Used during inference/validation|

---

### Section 2: `nn` library

**Base building blocks**

|Component|What it does|Example|
|---|---|---|
|`nn.Module`|Base class for every model component|`class MyLayer(nn.Module)`|
|`nn.Parameter`|A tensor that's registered as a learnable weight|`nn.Parameter(torch.randn(d_model))`|
|`nn.ModuleList`|List of modules PyTorch can track|`nn.ModuleList([EncoderBlock(...) for _ in range(N)])`|
|`nn.Sequential`|Ordered container, runs modules in sequence|`nn.Sequential(nn.Linear(512,2048), nn.ReLU())`|

> Always use `nn.ModuleList` instead of a plain Python list when storing submodules — plain lists are invisible to PyTorch and their weights won't be tracked or updated.

**Layers**

|Layer|What it does|Example|
|---|---|---|
|`nn.Linear(in, out)`|Fully connected layer — learned weight matrix + bias|`nn.Linear(512, 512)` — your Q/K/V projections|
|`nn.Embedding(vocab, d_model)`|Lookup table mapping token ids → vectors|`nn.Embedding(30000, 512)`|
|`nn.LayerNorm(d_model)`|Normalizes across feature dimension per token|`nn.LayerNorm(512)`|
|`nn.Dropout(p)`|Randomly zeros out p fraction of values during training|`nn.Dropout(0.1)`|
|`nn.MultiheadAttention(d_model, heads)`|Built-in MHA (you won't use this when building from scratch, but good to know it exists)|`nn.MultiheadAttention(512, 8)`|

**Activation functions**

|Activation|What it does|Example|
|---|---|---|
|`nn.ReLU()`|Zeros out negatives|Used in feedforward block|
|`nn.GELU()`|Smoother ReLU variant — used in most modern transformers (BERT, GPT)|`nn.GELU()`|
|`nn.Softmax(dim)`|Softmax along dim — usually use `torch.softmax` directly instead|`nn.Softmax(dim=-1)`|

**Loss functions**

|Loss|What it does|Example|
|---|---|---|
|`nn.CrossEntropyLoss()`|Classification loss — combines log softmax + NLL|Used for language model token prediction|
|`nn.MSELoss()`|Mean squared error|Used in YOLO's coordinate/confidence loss|
|`nn.BCEWithLogitsLoss()`|Binary cross entropy with sigmoid built in — used in YOLO v3+ per-class loss|`nn.BCEWithLogitsLoss()`|

**Optimizers** (in `torch.optim`)

|Optimizer|What it does|Example|
|---|---|---|
|`optim.Adam(params, lr)`|Adaptive learning rate — default choice for transformers|`optim.Adam(model.parameters(), lr=1e-4)`|
|`optim.SGD(params, lr)`|Basic gradient descent — more common in YOLO training|`optim.SGD(model.parameters(), lr=1e-3)`|
|`optimizer.zero_grad()`|Clears gradients from previous step — must call before every backward|`optimizer.zero_grad()`|
|`optimizer.step()`|Updates weights using stored gradients|`optimizer.step()`|

> Forgetting `optimizer.zero_grad()` is one of the most common PyTorch bugs — gradients accumulate across steps rather than being replaced, causing the model to diverge.

---

### How a training step uses all of this together

```python
# one training step
optimizer.zero_grad()           # clear old gradients
output = model(x)               # forward pass — builds computation graph
loss = loss_fn(output, target)  # compute scalar loss
loss.backward()                 # autograd walks graph, fills .grad on every weight
optimizer.step()                # nudge every weight by its gradient
```

That five-line loop is the heartbeat of every PyTorch training run — transformer, YOLO, anything.

---

Want to move into the `nn.Module` pattern more deeply now (how `__init__` vs `forward` split responsibilities, how nested modules share weights, how `model.parameters()` collects everything), or does this reference feel solid enough to jump into writing the transformer skeleton?