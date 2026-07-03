
# Imports & Multi Head Attention
```python
import torch
from torch import nn as nn
from torch import optim as optim
import torch.utils.data as data
import math
import copy

class MultiHeadAttention(nn.Module):
    def __init__(self, d_model, num_heads):
        super(MultiHeadAttention, self).__init__()
        assert d_model % num_heads == 0, "d_model must be divisible by num_heads"
        self.d_model = d_model
        self.num_heads = num_heads
        self.d_k = d_model // num_heads
        self.W_q = nn.Linear(d_model, d_model)
        self.W_k = nn.Linear(d_model, d_model)
        self.W_v = nn.Linear(d_model, d_model)
        self.W_o = nn.Linear(d_model, d_model)
    
    def scaled_dot_product_attention(self, Q, K, V, mask = None):
        attn_scores = torch.matmul(Q, K.transpose(-2, -1) / math.sqrt(self.d_k)) 
        if mask is not None:
            attn_scores = attn_scores.masked_fill(mask == 0, -1e9)        
        attn_probs = torch.softmax(attn_scores, dim=-1)
        output = torch.matmul(attn_probs, V)
        return output

    def split_heads(self, x):
        '''
        batch_size -> Number of sentences
        seq_length -> No. of tokens in that one sequence
        d_model -> embedding size per token
        
        we return batch_size, seq_length, no of parallel heads, embeddings per head in a
        4d tensor.
        '''
        
        batch_size, seq_length, d_model = x.size()
        return x.view(batch_size, seq_length, self.num_heads, self.d_k).transpose(1,2)
    
    def combine_heads(self, x):
        batch_size, _, seq_length, d_k = x.size()
        return x.transpose(1, 2).contigious().view(batch_size,seq_length, self.d_model)
    
    def forward(self, Q, K, V, mask=None):
        Q = self.spilt_heads(self.W_q(Q))
        K = self.spilt_heads(self.W_k(K))
        V = self.spilt_heads(self.W_v(V))
        attn_output = self.scaled_dot_product_attention(Q, K, V, mask)
        output = self.W_o(self.combine_heads(attn_output))
        return output
```

# Feed Forward Networks
```python
class PositionWiseFeedForward(nn.Module):
    def __init__(self, d_model, d_ff):
        super(PositionWiseFeedForward, self).__init__()
        self.fc1 = nn.Linear(d_model, d_ff)
        self.fc2 = nn.Linear(d_ff, d_model)
        self.relu = nn.ReLU()

    def forward(self, x):
        return self.fc2(self.relu(self.fc1(x)))
```