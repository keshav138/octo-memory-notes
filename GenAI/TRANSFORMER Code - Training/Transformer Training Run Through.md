Here's the full run-through, held together as one story. I'll walk the **training path** first (since testing depends on artifacts training produces), then the **inference/validation path**. Concrete example throughout: an English→Italian pair, `seq_len=350`.

## Training Path

**1. Config is the contract.** Everything downstream — file paths, batch size, sequence length — reads from this one dict. This is what lets you swap `en-it` for `en-fr` later without touching logic.

**2. Tokenizer = teaching the model what a "word" is.** You load `opus_books`, then for each language build (or load, if cached) a `WordLevel` tokenizer with `[UNK] [PAD] [EOS] [SOS]`. A sentence like `"The cat sat."` becomes a list of integers, e.g. `[45, 302, 891, 12]` — that's it, that's the vocabulary being learned. This runs once and is cached to disk; every future run just loads the JSON.

> _Pointer worth knowing:_ the trainer uses `min_frequency=2`, so any word appearing once in the whole corpus gets mapped to `[UNK]` instead of getting its own id.

**3. `BilingualDataset` turns raw pairs into fixed-length tensors.** This is the heart of "what a training example looks like." Take `src="The cat sat."` (4 tokens after tokenizing) and `tgt="Il gatto si è seduto."` (6 tokens), with `seq_len=350`:

- `encoder_input` = `[SOS] + 4 real tokens + [EOS] + 344 [PAD]` → length 350
- `decoder_input` = `[SOS] + 6 real tokens + 343 [PAD]` → length 350 (this is what's _fed into_ the decoder — teacher forcing, the ground-truth shifted right)
- `label` = `6 real tokens + [EOS] + 343 [PAD]` → length 350 (this is what the model is _scored against_ — same as decoder_input but shifted left by one, so at each position the model predicts the _next_ token)

This SOS/no-SOS, EOS/no-EOS offset between `decoder_input` and `label` is the entire trick that makes autoregressive training work in one forward pass instead of a loop.

**4. Two masks, two different jobs:**

- `encoder_mask`: just says "these are real tokens, these are padding — don't attend to padding." Shape `(1,1,seq_len)`.
- `decoder_mask`: does _that_ AND stops the decoder from peeking at future tokens (the triangular `causal_mask`). This is what makes it a proper autoregressive decoder instead of one that can cheat by seeing the answer.

**5. Model gets built** from vocab sizes + `seq_len` + `d_model` — standard encoder-decoder transformer via `build_transformer`. This file doesn't care about internals, it just wires the object up.

**6. The training loop, per batch:** `encoder_input → model.encode() → encoder_output` (contextualized source representation, computed once per batch) `(encoder_output, decoder_input) → model.decode() → decoder_output` `decoder_output → model.project() → proj_output` (logits over target vocab, shape `(batch, seq_len, vocab_size)`) Then: flatten both `proj_output` and `label` and run cross-entropy (with `ignore_index` on `[PAD]` so padding doesn't pollute the loss, and `label_smoothing=0.1` so the model doesn't get overconfident). Backprop, step, zero grad, repeat. `global_step` just counts batches for TensorBoard logging.

**7. End of each epoch:** run validation, then checkpoint everything needed to resume — weights, optimizer state, epoch, global_step — as one `.pt` file.

## Testing / Inference Path (`greedy_decode` + `run_validation`)

This is a fundamentally different computation from training — no teacher forcing, no labels, the model has to generate one token at a time and feed its own output back in.

**1. Encode once.** Since the source sentence never changes across decoding steps, `encoder_output = model.encode(source, source_mask)` is computed a single time and reused.

**2. Start with just `[SOS]`.** `decoder_input` begins as shape `(1,1)`.

**3. Loop:** build a fresh causal mask (it has to grow as `decoder_input` grows), run `model.decode()`, take only the _last_ position's output (`out[:, -1]`), project it to vocab logits, and greedily pick `argmax` — the single most probable next token, no sampling/beam search. Append it to `decoder_input`. Stop when you hit `[EOS]` or `max_len`.

> _Pointer:_ this re-runs the full decoder stack from scratch every step (re-encoding tokens you've already processed) — that's why real inference systems use KV-caching; this version trades speed for simplicity.

**4. `run_validation` wraps this** over a couple of validation examples (`batch_size=1` is enforced), decodes the token ids back to text, prints source/target/predicted side by side, and — only if a TensorBoard writer exists — computes CER/WER/BLEU against the expected sentences and logs them.

## Three things that will actually break the run

1. **`config` has no `'d_model'` key**, but `get_model()` reads `config['d_model']` → `KeyError` the moment training starts. You need to add it to `get_config()`.
2. **`greedy_decode` line 249**: `torch.empty(1,1).fill(sos_idx)` — should be `.fill_(sos_idx)`. `fill` (no underscore) isn't a real tensor method; this will `AttributeError` the first time validation runs.
3. **Preload block order (lines 343–344)**: it prints `model_filename` _before_ that variable is ever assigned — `NameError` if `config['preload']` is truthy. Just swap the two lines.

Want me to patch these three directly in the file?