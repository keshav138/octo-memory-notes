To calculate the theoretical maximum batch size your GPU can handle before running into a `CUDA out of memory` (OOM) error, you need to account for how memory is consumed during training.

  

### The GPU Memory Formula

During a forward and backward pass, GPU VRAM is occupied by four main components:

  

$$\text{Total VRAM Required} = M_{\text{model}} + M_{\text{optimizer}} + M_{\text{gradients}} + M_{\text{activations}}(B)$$

1. **Model Weights ($M_{\text{model}}$):** Static memory needed to store model parameters.
    
      
    
2. **Optimizer States ($M_{\text{optimizer}}$):** Memory needed for Adam optimizer states (Adam stores 2 extra floating-point values per parameter: momentum and variance).
    
      
    
3. **Gradients ($M_{\text{gradients}}$):** Memory stored for parameter gradients during backward pass.
    
      
    
4. **Activations ($M_{\text{activations}}$):** Dynamic memory required to store intermediate outputs at every layer for backpropagation. **This is the only component that scales directly with batch size ($B$).**
    
      
    

### Step-by-Step Calculation

#### 1. Calculate Static Memory ($M_{\text{static}}$)

For 32-bit float (`fp32`, PyTorch default), each parameter uses **4 bytes**.

  

- **Model Parameters:** A standard Transformer in your setup (`d_model=512`, 6 layers) has roughly **$P \approx 65 \text{ million}$** parameters.
    
      
    
    $$M_{\text{model}} = P \times 4 \text{ bytes} \approx 65\text{M} \times 4 \approx 260 \text{ MB}$$
    
- **Gradients:**
    
      
    
    $$M_{\text{gradients}} = P \times 4 \text{ bytes} \approx 260 \text{ MB}$$
    
- **Adam Optimizer States:**
    
      
    
    $$M_{\text{optimizer}} = P \times 8 \text{ bytes} \approx 520 \text{ MB}$$
    

$$\text{Total Static Memory } (M_{\text{static}}) \approx 260 + 260 + 520 \approx \mathbf{1.04 \text{ GB}}$$

#### 2. Calculate Activation Memory Per Batch ($M_{\text{activation}}$)

In Transformer models, activation memory is dominated by **Attention Matrices** and **Feed-Forward Blocks** across all layers ($N=6$).

  

For a batch size $B$ and sequence length $S = 350$:

  

$$\text{Memory per layer} \approx B \times S \times d_{\text{model}} \times \text{bytes\_per\_float}$$

Across 6 Transformer encoder and decoder layers, self-attention matrices $(B \times h \times S \times S)$, feed-forward projections $(B \times S \times 2048)$, and layer norms, 1 batch of sequence length 350 typically consumes roughly **$\sim 120 \text{ MB}$ to $150 \text{ MB}$ of activations per unit of batch size**.

  

Let's estimate $A \approx 140 \text{ MB per batch unit}$.

  

#### 3. Compute Theoretical Upper Limit

Let $V_{\text{usable}}$ be your total available GPU VRAM minus PyTorch overhead ($\sim 1 \text{ GB}$ reserved for PyTorch/CUDA context):

  

$$B_{\text{max}} \approx \frac{V_{\text{usable}} - M_{\text{static}}}{A}$$

For common GPU VRAM capacities:

  

|**GPU VRAM**|**Usable VRAM (Vusable​)**|**Static Memory (Mstatic​)**|**Max Batch Size (Bmax​)**|**Practical Safe Limit**|
|---|---|---|---|---|
|**6 GB**|$\sim 5.0 \text{ GB}$|$\sim 1.0 \text{ GB}$|$\frac{4.0 \text{ GB}}{0.14 \text{ GB}} \approx 28$|**16 – 24**|
|**8 GB**|$\sim 7.0 \text{ GB}$|$\sim 1.0 \text{ GB}$|$\frac{6.0 \text{ GB}}{0.14 \text{ GB}} \approx 42$|**32**|
|**12 GB**|$\sim 11.0 \text{ GB}$|$\sim 1.0 \text{ GB}$|$\frac{10.0 \text{ GB}}{0.14 \text{ GB}} \approx 71$|**64**|
|**16 GB**|$\sim 15.0 \text{ GB}$|$\sim 1.0 \text{ GB}$|$\frac{14.0 \text{ GB}}{0.14 \text{ GB}} \approx 100$|**64 – 80**|

### Empirical Method: Automatic Search Script

Rather than manually computing equations, you can run a quick binary search script in PyTorch to test your exact hardware limits dynamically:

Python

```
import torch
from model import build_transfomer
from config import get_config

def find_max_batch_size():
    config = get_config()
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    
    # 1. Instantiate model & optimizer
    model = build_transfomer(20000, 20000, config['seq_len'], config['seq_len']).to(device)
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-4)
    loss_fn = torch.nn.CrossEntropyLoss()

    batch_size = 2
    
    print("Testing maximum batch size on your GPU...")
    while True:
        try:
            # Allocate dummy tensors for testing memory limit
            src = torch.randint(0, 1000, (batch_size, config['seq_len'])).to(device)
            tgt = torch.randint(0, 1000, (batch_size, config['seq_len'])).to(device)
            src_mask = torch.ones((batch_size, 1, 1, config['seq_len'])).to(device)
            tgt_mask = torch.ones((batch_size, 1, config['seq_len'], config['seq_len'])).to(device)
            label = torch.randint(0, 1000, (batch_size, config['seq_len'])).to(device)

            # Simulate 1 step
            out = model.encode(src, src_mask)
            dec_out = model.decode(out, src_mask, tgt, tgt_mask)
            proj = model.project(dec_out)
            
            loss = loss_fn(proj.view(-1, 20000), label.view(-1))
            loss.backward()
            optimizer.step()
            optimizer.zero_grad()

            print(f"✅ Batch size {batch_size} passed!")
            batch_size *= 2  # Exponentially double batch size

        except RuntimeError as e:
            if "out of memory" in str(e):
                print(f"\n❌ CUDA OOM reached at batch size {batch_size}!")
                print(f"👉 Safe upper limit for training is approximately: {batch_size // 2}")
                break
            else:
                raise e

if __name__ == '__main__':
    find_max_batch_size()
```