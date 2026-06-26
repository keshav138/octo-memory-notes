Got it — here's the plan: we go through **YOLOv1's architecture mechanistically but at conceptual+equation depth** (not full backprop-level math like the transformer walkthrough, but every structural piece explained with its governing equations), and as we hit each component I'll drop a quick "in later versions, this became X" note without derailing into a full v2/v3/etc. breakdown. We'll do those properly when we get there.

Let's start with the foundation.

## YOLO: The Core Idea

Before YOLO (2015), object detection worked like this: take a classifier, slide it over thousands of region proposals (R-CNN, Fast R-CNN), and classify each region. This is accurate but slow — you're running the network thousands of times per image.

YOLO's pitch: **You Only Look Once.** One forward pass through one network, and you get all bounding boxes + classes simultaneously. It reframes detection as a single regression problem: image in → tensor of (box coordinates, confidence, class probabilities) out.

This is the same kind of shift transformers made for sequences — instead of processing things step-by-step (RNN-style, or region-by-region here), do it all at once in parallel.

---

## Step 1: The Grid

YOLOv1 divides the input image (448×448) into an **S×S grid** (S=7, so 7×7 = 49 cells).

**The rule that defines everything:** if the center of an object's ground-truth bounding box falls inside a grid cell, that cell is "responsible" for detecting that object.

So each cell isn't looking at just its own small patch visually (the CNN features are global by the time we reach this grid), but each cell is _assigned responsibility_ based on where object centers land.

---

## Step 2: What Each Cell Predicts

Each grid cell predicts:

- **B bounding boxes** (B=2 in YOLOv1), each with 5 values: `(x, y, w, h, confidence)`
- **C class probabilities** (C=20 for PASCAL VOC), shared across the boxes in that cell — not per-box

So each cell outputs: `B × 5 + C` values. With S=7, B=2, C=20: each cell → 30 values → total output tensor: **7×7×30**.

### Decoding the 5 box values

- `x, y` — center of the predicted box, but **relative to the grid cell**, normalized to [0,1]. So x=0.5 means dead center of that cell, not the image.
- `w, h` — width/height, normalized by the **full image** dimensions, in [0,1].
- `confidence` — this is the key trick. It's not "probability there's an object." It's defined as:

$$\text{Confidence} = P(\text{Object}) \times \text{IOU}_{\text{pred}}^{\text{truth}}$$

So confidence is trained to equal the IOU (Intersection over Union) between the predicted box and the ground truth, _if_ an object exists in that cell, and 0 otherwise. The network is essentially being asked to self-report how good its own box is.

**Why 2 boxes per cell (B=2)?** Each cell can only specialize toward one class distribution, but it can hedge with 2 different box shapes — e.g., one box predictor tends to learn "wide boxes," another "tall boxes." This is a primitive precursor to anchor boxes (more on that below).

---

## Step 3: Class Probabilities

Each cell also predicts $C$ values: $P(\text{Class}_i \mid \text{Object})$ — conditional class probability, assuming an object is present.

At inference time, to get the actual confidence that "this box contains a dog," you multiply:

$$P(\text{Class}_i \mid \text{Object}) \times P(\text{Object}) \times \text{IOU} = P(\text{Class}_i) \times \text{IOU}$$

This single number is the **class-specific confidence score** for each box — how confident the network is that this exact box correctly localizes this exact class.

---

## Step 4: The Network Backbone

YOLOv1 uses a custom CNN inspired by GoogLeNet: 24 convolutional layers + 2 fully connected layers. Roughly:

- Conv layers progressively downsample the 448×448 image down to a 7×7 feature map (matching the grid!) — this isn't a coincidence, the spatial resolution of the final feature map _is_ literally the grid.
- 1×1 convolutions are used to reduce channel depth cheaply (a trick borrowed from Inception/GoogLeNet) before 3×3 convs do the spatial work.
- The final two layers are **fully connected**, flattening spatial structure and outputting the 7×7×30 tensor reshaped from a flat vector.

> **Later-version flag:** That fully-connected output head is one of YOLOv1's biggest weaknesses — it destroys spatial generalization (forces a fixed input size, loses per-location precision). YOLOv2 onward replaces this entirely with a **fully convolutional** head, predicting the grid directly from feature map channels. Keep this in mind, it's a big architectural fork point.

---

## Step 5: The Loss Function

This is the part worth sitting with — YOLO's loss is a **multi-part sum of squared errors**, weighted differently per component, because not all errors matter equally.

$$ \mathcal{L} = \lambda_{coord}\sum_{i=0}^{S^2}\sum_{j=0}^{B} \mathbb{1}_{ij}^{obj}\left[(x_i - \hat{x}_i)^2 + (y_i - \hat{y}_i)^2\right] $$ $$
\lambda_{coord}\sum_{i=0}^{S^2}\sum_{j=0}^{B} \mathbb{1}_{ij}^{obj}\left[(\sqrt{w_i} - \sqrt{\hat{w}_i})^2 + (\sqrt{h_i} - \sqrt{\hat{h}_i})^2\right] 
$$ $$
\sum_{i=0}^{S^2}\sum_{j=0}^{B} \mathbb{1}_{ij}^{obj}(C_i - \hat{C}_i)^2 + \lambda_{noobj}\sum_{i=0}^{S^2}\sum_{j=0}^{B} \mathbb{1}_{ij}^{noobj}(C_i - \hat{C}_i)^2 
$$ $$
\sum_{i=0}^{S^2} \mathbb{1}_{i}^{obj}\sum_{c \in classes}(p_i(c) - \hat{p}_i(c))^2 $$

Let's break this into pieces because each one is solving a specific problem:

**1. Coordinate loss (x, y):** Standard squared error on box center, but only counted for the box **responsible** for the object ($\mathbb{1}_{ij}^{obj}$ — the indicator that cell $i$, box $j$ is the one assigned).

**2. Width/height loss — note the square roots.** Why $\sqrt{w}$ instead of $w$? Because squared error penalizes a 10-pixel error on a small box the same as a 10-pixel error on a huge box — but a 10px error matters way more proportionally for a small box. Taking the square root compresses the scale for large values, so errors on large boxes are naturally down-weighted relative to small boxes. It's a cheap fix for scale-sensitivity without doing anything fancier.

**3. Confidence loss — split into obj and no-obj.** Remember confidence target = IOU. This term is computed for _every_ box, not just responsible ones — because the network also needs to learn "there's nothing here" for boxes with no object. But here's the imbalance problem: most grid cells in most images contain **no object**. If you weight obj and no-obj equally, the loss is dominated by background cells pushing all confidences to 0, and the model gets lazy about detecting actual objects (gradient signal drowned out).

Fix: $\lambda_{coord} = 5$, $\lambda_{noobj} = 0.5$. Localization errors are amplified 5x, no-object confidence errors are dampened to half. This rebalances the gradient so the rare "there's an object here, get the box right" signal isn't swamped by the common "there's nothing here" signal.

**4. Classification loss:** Squared error on class probabilities, only for cells that actually contain an object's center ($\mathbb{1}_i^{obj}$, indexed just by cell, not by box — recall class probs are per-cell, not per-box).

> **Later-version flag:** Using sum-squared-error for classification (instead of cross-entropy) is unusual and considered a weakness — squared error doesn't push probabilities as aggressively toward 0/1 as cross-entropy does. v2/v3 onward move toward more standard classification losses, and v3 specifically moves to independent logistic classifiers + binary cross-entropy per class (to support multi-label and avoid forcing mutual exclusivity via softmax).

---

## Step 6: Non-Max Suppression (NMS) — at Inference

The raw output gives 7×7×2 = 98 candidate boxes per image. Many overlap massively for the same object (multiple cells near an object's edge will all claim some responsibility, or both B boxes in a cell fire).

**NMS algorithm:**

1. Discard boxes below a confidence threshold.
2. Pick the box with the highest class-confidence score.
3. Remove all other boxes that have IOU > threshold (e.g. 0.5) with that box **and the same class**.
4. Repeat with the next-highest remaining box.

This is a _post-processing_ step, not learned — it's a fixed greedy algorithm applied after the network's forward pass.

> **Later-version flag:** NMS itself stays conceptually similar through most YOLO versions, but it's a known bottleneck (it's sequential, not parallelizable, and is a separate non-differentiable step glued onto an otherwise end-to-end network). This is actually one of the headline changes in YOLOv10 — "NMS-free" training using dual assignment, removing this whole step from inference.

---

## Why This Architecture Has Structural Weaknesses (sets up v2/v3 motivation)

Worth naming explicitly, since every later version is a response to these:

1. **Each cell predicts only one set of class probabilities**, shared across both its boxes → if two different-class objects have centers in the _same_ cell, YOLOv1 cannot detect both. This is brutal for small/clustered objects (e.g., a flock of birds).
2. **Strong spatial constraints from the grid + fully-connected head** → struggles with unusual aspect ratios, since it hasn't been told what shapes to expect (no priors on box shape).
3. **Coarse grid (7×7) → poor localization for small objects.** A small object's signal gets diluted across a large receptive field by the time you're down to a 7×7 map.

---

That's the full YOLOv1 architecture — grid, predictions, backbone, loss function rationale, and NMS. Want to move into **YOLOv2 (YOLO9000)** next, where the anchor-box mechanism, batch norm, and the multi-scale training trick get introduced? Or do you want to sit with v1's loss function / backbone a bit more first (e.g. walk through a worked numeric example of the loss on a toy grid)?