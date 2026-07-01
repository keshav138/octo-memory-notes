Good — NumPy comfort means I can map directly across: a PyTorch tensor is essentially a NumPy array that can live on a GPU and has autograd (automatic gradient tracking) baked in. That's the core difference, everything else is just API.

---

## Tensors

### What a tensor is

A tensor is just an n-dimensional array of numbers. Same shape intuition as NumPy:

- 0D → scalar: `tensor(3.14)`
- 1D → vector: `tensor([1, 2, 3])`
- 2D → matrix: `tensor([[1,2],[3,4]])`
- 3D+ → what you'll actually use: an image is `(C, H, W)`, a batch of images is `(N, C, H, W)`

### Creating tensors

```python
import torch

# From data directly (like np.array)
x = torch.tensor([1.0, 2.0, 3.0])

# Like np.zeros, np.ones, np.rand
torch.zeros(3, 4)
torch.ones(3, 4)
torch.rand(3, 4)        # uniform [0,1]
torch.randn(3, 4)       # standard normal

# From a numpy array (shares memory, no copy)
import numpy as np
arr = np.array([1.0, 2.0])
x = torch.from_numpy(arr)

# Back to numpy
arr = x.numpy()
```

### The two things tensors add over NumPy

**1. Device (CPU vs GPU)**

```python
x = torch.rand(3, 4)
x = x.to("cuda")       # move to GPU
x = x.to("cpu")        # move back

# Common pattern — write device-agnostic code
device = "cuda" if torch.cuda.is_available() else "cpu"
x = x.to(device)
```

**2. Autograd — gradient tracking**

```python
x = torch.tensor([2.0], requires_grad=True)
y = x ** 2              # y = x²
y.backward()            # compute dy/dx
print(x.grad)           # tensor([4.]) — correct, dy/dx = 2x = 4
```

During training you won't call `.backward()` manually on individual tensors — PyTorch does it across the whole network when you call `loss.backward()`. But this is the mechanism underneath all of it. Every operation on a `requires_grad=True` tensor gets tracked, building a computation graph that `.backward()` walks to compute gradients automatically.

For inference (no training), wrap in `torch.no_grad()` to skip tracking and save memory:

```python
with torch.no_grad():
    output = model(x)
```

### Shape manipulation you'll use constantly

```python
x = torch.rand(4, 28, 28)       # 4 grayscale images

x.shape                          # torch.Size([4, 28, 28])
x.reshape(4, 784)                # flatten spatial dims
x.permute(0, 2, 1)              # reorder dims — key for attention
x.unsqueeze(0)                   # add dim at pos 0 → (1, 4, 28, 28)
x.squeeze(0)                     # remove dim of size 1
x[0]                             # first image → (28, 28)
x[:, :14, :]                     # top half of all images
```

These are things you'll use in every forward pass, especially `permute` and `unsqueeze`.

---

## Dataset and DataLoader

### Why these exist

Training a model means feeding it thousands of images in batches, shuffled, possibly augmented, while loading from disk efficiently without becoming the bottleneck. `Dataset` and `DataLoader` split this cleanly into two responsibilities:

- `Dataset` — knows _what_ your data is and how to load one sample
- `DataLoader` — knows _how_ to serve that data during training (batching, shuffling, parallel loading)

### Dataset

You subclass `torch.utils.data.Dataset` and implement exactly three methods:

```python
from torch.utils.data import Dataset
from PIL import Image
import os

class YOLODataset(Dataset):
    def __init__(self, image_dir, label_dir, transform=None):
        self.image_dir = image_dir
        self.label_dir = label_dir
        self.transform = transform
        self.images = os.listdir(image_dir)   # list of filenames

    def __len__(self):
        # total number of samples in your dataset
        return len(self.images)

    def __getitem__(self, idx):
        # load ONE sample given an index
        img_path = os.path.join(self.image_dir, self.images[idx])
        image = Image.open(img_path).convert("RGB")

        # load corresponding label
        label_path = os.path.join(
            self.label_dir,
            self.images[idx].replace(".jpg", ".txt")
        )
        boxes = []
        with open(label_path) as f:
            for line in f:
                cls, x, y, w, h = map(float, line.strip().split())
                boxes.append([cls, x, y, w, h])

        boxes = torch.tensor(boxes)           # (num_boxes, 5)

        if self.transform:
            image = self.transform(image)

        return image, boxes                   # one sample
```

`__len__` and `__getitem__` are the only contract `DataLoader` needs from you — once these two are defined, DataLoader knows how to work with your data.

### DataLoader

```python
from torch.utils.data import DataLoader
import torchvision.transforms as T

transform = T.Compose([
    T.Resize((448, 448)),   # YOLO input size
    T.ToTensor(),           # PIL image → tensor, scales [0,255] to [0,1]
])

dataset = YOLODataset(
    image_dir="data/images",
    label_dir="data/labels",
    transform=transform
)

loader = DataLoader(
    dataset,
    batch_size=16,
    shuffle=True,           # shuffles every epoch
    num_workers=4,          # parallel loading on CPU cores
    pin_memory=True         # faster CPU→GPU transfer
)
```

### Using it in a training loop

```python
for epoch in range(num_epochs):
    for images, labels in loader:
        images = images.to(device)    # (16, 3, 448, 448)
        labels = labels.to(device)

        predictions = model(images)
        loss = loss_fn(predictions, labels)

        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
```

Each iteration of the inner loop, `loader` automatically calls `__getitem__` 16 times (your batch size), stacks the results into a single `(16, 3, 448, 448)` tensor, and hands it to you. The `num_workers=4` means 4 CPU processes are loading the next batch in parallel while your GPU is busy training on the current one — so the GPU is never sitting idle waiting for data.

---

## The mental model in one line

`Dataset` is a smart list that knows how to load one sample. `DataLoader` is a factory that wraps that list, calls it in parallel, and hands you ready-to-use batches during training. Tensors are what everything inside those batches actually _is_ — NumPy arrays with GPU support and gradient tracking bolted on.

Want to go deeper on transforms/augmentations for YOLO specifically (where bounding boxes have to transform along with the image), or is this enough to move forward?