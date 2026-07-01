## Why tensors matter

Everything in deep learning is numbers. Your image is numbers (pixel values). Your model's weights are numbers. The loss is a number. Tensors are just the container that holds all these numbers in an organized shape.

The reason you can't just use a Python list is that lists are slow — Python loops over them one element at a time. A tensor stores all its numbers in one contiguous block of memory and uses highly optimized low-level code (basically C/CUDA underneath) to do math on the entire block at once. So when you multiply two (448, 448) tensors together, it's not looping 200,000 times in Python — it's one fast memory operation.

NumPy arrays do the same thing, which is why you're already comfortable with the idea. A PyTorch tensor is that same concept, but with two extra capabilities bolted on — GPU support and autograd.

---

## What autograd actually is

During training, you need to answer one question repeatedly: **"if I nudge this weight slightly, does the loss go up or down, and by how much?"** That answer is the gradient — and you need it for every single weight in the network, which could be millions.

Computing that by hand is obviously impossible. Autograd does it automatically.

Here's the core idea: every time you do an operation on a tensor — add, multiply, whatever — PyTorch quietly writes down what you did, building a record of the entire sequence of operations from input to final loss. This record is called the **computation graph**.

When you then call `loss.backward()`, PyTorch walks that record backwards (using the chain rule from calculus) and computes "how much did each weight contribute to this loss?" That contribution is the gradient, and it gets stored directly on each tensor in a `.grad` attribute.

The optimizer then uses those gradients to nudge every weight in the right direction — slightly reducing the loss. Repeat this thousands of times across thousands of batches and the weights gradually get better.

So the flow is:

```
forward pass → loss → .backward() → gradients on every weight → optimizer nudges weights
```

Autograd is what makes the "gradients on every weight" step automatic instead of something you have to derive and code yourself for every architecture.

---

## How it all fits together

Tensors are the data structure. Autograd is the mechanism that makes learning possible. You can't train a network without both — tensors give you fast math, autograd gives you the signal (gradients) that tells the math which direction to go.

When you're actually writing YOLO training code, you won't think about autograd directly most of the time — it just runs silently in the background whenever you call `loss.backward()`. But knowing it exists and what it's doing is important, because a lot of common bugs (like forgetting `optimizer.zero_grad()` and having gradients accumulate across batches) only make sense once you know gradients are sitting on tensors, building up, until you explicitly clear them.

Want to move into a minimal end-to-end PyTorch training loop now, where all of this — tensors, DataLoader, autograd, optimizer — comes together in one place?