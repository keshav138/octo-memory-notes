# Vision Transformer (ViT) Architecture

![[Pasted image 20260807145622.png]]

## Core Idea

ViT treats an image as a sequence of patches (like tokens in NLP) and feeds it through a standard Transformer encoder — no convolutions.

## Architecture Pipeline

1. **Patch extraction** — split image into fixed-size patches
2. **Linear projection** — flatten each patch, project to embedding dimension
3. **Position embeddings** — added since Transformers have no spatial awareness
4. **[CLS] token** — prepended, its final state used for classification
5. **Transformer encoder** — standard multi-head self-attention (MHSA) + MLP blocks, LayerNorm, residual connections
6. **MLP head** — classification from [CLS] token output

## Math of Image Breakdown (Patch Embedding)

Given image **x ∈ ℝ^(H×W×C)** (Height, Width, Channels):

**Step 1 — Patchify** Split into N patches of size P×P:

```
N = (H × W) / P²
```

Each patch: **x_p ∈ ℝ^(P²·C)** (flattened)

Example: 224×224×3 image, P=16 → N = (224×224)/(16×16) = **196 patches**, each flattened to 16×16×3 = **768-dim vector**

**Step 2 — Linear Projection (Patch Embedding)**

```
z_0 = [x_class; x_p¹E; x_p²E; ...; x_p^N E] + E_pos
```

- E ∈ ℝ^((P²·C) × D) — trainable projection matrix (D = model dim, e.g. 768)
- x_class — learnable [CLS] token embedding
- E_pos ∈ ℝ^((N+1) × D) — learnable positional embeddings

Result: a sequence of **(N+1) vectors of dimension D**, exactly like word-embedding sequences in NLP Transformers.

**Step 3 — Transformer Encoder (L layers)**

```
z'_l = MSA(LN(z_(l-1))) + z_(l-1)
z_l  = MLP(LN(z'_l)) + z'_l
```

MSA = Multi-head Self Attention, LN = LayerNorm

**Step 4 — Classification**

```
y = LN(z_L^0)   → MLP head → class prediction
```

(z_L^0 = final [CLS] token state)

---

## ViT vs. NLP Transformers

|Aspect|NLP Transformer|ViT|
|---|---|---|
|Input tokens|Word/subword embeddings|Flattened image patches (linearly projected)|
|Sequence length|Variable|Fixed (H·W/P²)|
|Positional encoding|Sinusoidal or learned|Learned (1D, though 2D-aware)|
|Core mechanism|Self-attention over tokens|Identical — self-attention over patches|
|Architecture|Same encoder block|Same encoder block (ViT reuses BERT-style encoder as-is)|

**Key point:** ViT doesn't modify the Transformer — it modifies the _tokenization_ of the input so the same architecture used for text can consume images.

---

## ViT vs. Traditional Foundational Models (CNNs — ResNet, VGG, etc.)

|Aspect|CNNs|ViT|
|---|---|---|
|Inductive bias|Strong: locality, translation invariance (via convolution + pooling)|Minimal/none — must learn spatial relationships from data|
|Receptive field|Grows gradually, layer by layer|Global from layer 1 (self-attention sees all patches)|
|Data efficiency|Good on small/medium datasets|Needs large-scale pretraining (JFT-300M, ImageNet-21k) to outperform CNNs; underperforms CNNs on small data|
|Feature hierarchy|Explicit hierarchical (edges → textures → parts → objects)|No explicit hierarchy — learned implicitly via attention|
|Compute pattern|Local, weight-shared filters|Global pairwise attention — O(N²) in number of patches|
|Scalability|Diminishing returns at scale|Scales very well with data + model size|

**Bottom line:** CNNs bake in assumptions about images (nearby pixels are related); ViT makes almost no such assumptions and instead _learns_ them from data — which is why it needs much more data/compute to match or beat CNNs, but scales better once you have that data.

Want me to also cover ViT variants (DeiT, Swin, hybrid CNN-ViT) or the attention math (QKV) in the same depth?