# Flow

Here's the flow stripped down to just "what goes in → what comes out" at each step, using concrete shapes so it's easier to track. Say `batch=1, seq_len=4, d_model=512, num_heads=8, d_k=64` for reference.

**1. Start:** `Q, K, V` each shape `(1, 4, 512)` — 4 tokens, each a 512-dim vector.

**2. Project:** `W_q(Q)`, `W_k(K)`, `W_v(V)` → still `(1, 4, 512)`, just each vector rotated/mixed by a learned matrix. Shape unchanged, values changed.

**3. Split into heads:** `(1, 4, 512)` → `(1, 8, 4, 64)`. Same data, sliced into 8 chunks of 64 dims each, one chunk per head. Now think of it as **8 separate mini-attention problems running in parallel**, each with 4 tokens of 64 dims.

**4. Attention per head** (this is the only step with real math):

- Score every token against every other token: `(4,64) @ (64,4)` → `(4,4)` score matrix — "how much token i cares about token j"
- Scale, mask, softmax → still `(4,4)`, now rows sum to 1 (probabilities)
- Mix values using those probabilities: `(4,4) @ (4,64)` → `(4,64)` — each token is now a weighted blend of all tokens' value vectors

Do this independently for all 8 heads → `(1, 8, 4, 64)`.

**5. Combine heads:** stitch the 8×64 chunks back into 512 → `(1, 4, 512)`. Just undoing step 3.

**6. Final projection:** `W_o(...)` → `(1, 4, 512)`. One more mix so heads can share info with each other before leaving the block.

**The one-sentence version:**

> Take each token → project it 3 ways (Q,K,V) → chop into smaller pieces (heads) → have every token "look at" every other token and grab a weighted mix of their values → glue the pieces back together → mix once more.

Shape never really changes end-to-end (`(1,4,512)` in, `(1,4,512)` out) — the whole block just rewrites each token's vector based on relevant context from other tokens. Let me know if any single step still feels murky and I'll zoom into just that one.

# Variables
Here's every variable in the code, what it holds, and its shape.

**Config / scalar variables (set once, never change)**

|Variable|Meaning|Example value|
|---|---|---|
|`d_model`|total embedding size per token|512|
|`num_heads`|how many parallel attention "heads"|8|
|`d_k`|size of each head's slice = `d_model / num_heads`|64|

These three just define the _shape_ of everything else — no data, just dimensions.

**Weight matrices (learned, live in `nn.Linear` layers)**

|Variable|Shape|What it does|
|---|---|---|
|`W_q`|`(512, 512)`|projects raw input into "Query" space|
|`W_k`|`(512, 512)`|projects raw input into "Key" space|
|`W_v`|`(512, 512)`|projects raw input into "Value" space|
|`W_o`|`(512, 512)`|final mixing layer after heads are combined|

These don't hold data either — they hold learnable numbers that get _multiplied_ with your data. Same 4 matrices used for every input you ever pass through this layer.

**Data tensors (change every forward pass, carry actual token info)**

|Variable|Shape (at that point)|What it represents|
|---|---|---|
|`Q, K, V` (input to `forward`)|`(batch, seq_len, 512)`|raw token embeddings, 3 copies (before projection)|
|`Q, K, V` (after `self.W_q(Q)` etc.)|`(batch, seq_len, 512)`|same tokens, now projected into Query/Key/Value spaces|
|`Q, K, V` (after `split_heads`)|`(batch, num_heads, seq_len, d_k)`|same data, sliced into 8 heads of 64-dim each|
|`attn_scores`|`(batch, num_heads, seq_len, seq_len)`|pairwise "how much token i cares about token j" — a square matrix per head|
|`attn_probs`|`(batch, num_heads, seq_len, seq_len)`|same shape, softmax applied → rows sum to 1|
|`output` (inside `scaled_dot_product_attention`)|`(batch, num_heads, seq_len, d_k)`|each token now = weighted blend of value vectors|
|`attn_output` (in `forward`)|`(batch, num_heads, seq_len, d_k)`|same as above, just renamed|
|`output` (in `forward`, after `combine_heads` + `W_o`)|`(batch, seq_len, 512)`|final result, back to original shape|

**Mask**

|Variable|Shape|Meaning|
|---|---|---|
|`mask`|`(batch, 1, seq_len, seq_len)` or broadcastable|binary (0/1) — marks which token-pairs are _not allowed_ to attend (e.g. future tokens, padding)|

**The key thing to hold onto:** `Q`, `K`, `V` are reused as variable names 3 times with 3 different shapes as they pass through the function — that's likely what's confusing you. Same name, evolving shape:

```
(batch, seq_len, 512)              ← raw input
        ↓ projected by W_q/W_k/W_v
(batch, seq_len, 512)              ← same shape, different values
        ↓ split_heads
(batch, num_heads, seq_len, 64)    ← now sliced per head
```

Let me know if you want me to trace one specific variable (like just `Q`) through the entire file with real numbers plugged in.