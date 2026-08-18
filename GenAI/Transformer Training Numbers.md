I pulled up the actual `opus_books` en-it dataset. It's commonly cited at **~32,332 sentence pairs** — I'd recommend confirming the exact figure yourself with `print(len(ds_raw))` right after `load_dataset()` runs, since HF dataset snapshots occasionally drift by version. I'll use 32,332 below as the real working number.

## The split

```
ds_raw total          = 32,332 pairs
train_size (90%)       = int(0.9 * 32332) = 29,098
val_size   (remainder) = 32332 - 29098    = 3,234
```

`random_split` shuffles once and locks that split — so `train_ds` and `val_ds` are fixed for the whole run (not re-shuffled per epoch).

## Batches per epoch

**Training** (`batch_size=8`, `shuffle=True`, `DataLoader` default `drop_last=False`):

```
29,098 / 8 = 3,637.25 → 3,638 batches per epoch
```

The last batch of each epoch only has `29098 - (3637*8) = 2` sentences in it instead of 8 — a smaller, ragged final batch. This is what `batch_iterator` iterates over — 3,638 steps of the inner `for batch in batch_iterator` loop, per epoch.

**Validation** (`batch_size=1`, forced by that assert on line 285):

```
3,234 batches — one sentence pair per batch, no batching at all.
```

## `global_step` over the whole run

`global_step` increments once per **training** batch, across all epochs:

```
3,638 batches/epoch × 20 epochs = 72,760 total training steps
```

That's the x-axis range you'll see on the TensorBoard train-loss curve. Validation metrics (CER/WER/BLEU), by contrast, only get logged 20 times total — once at the end of each epoch, at whatever `global_step` that epoch happened to end on (e.g. after epoch 0 → step 3638, after epoch 1 → step 7276, etc.).

## What one training iteration actually holds

One batch = 8 sentence pairs, each forced to `seq_len=350` via padding/truncation. So every tensor in that batch has a fixed shape regardless of how long the real sentences were:

```
encoder_input   : (8, 350)
decoder_input   : (8, 350)
label           : (8, 350)
encoder_mask    : (8, 1, 1, 350)
decoder_mask    : (8, 1, 350, 350)
```

Inside the model: `encoder_output` → `(8, 350, 512)` (with `d_model=512`, the value used in the version of this tutorial code this is based on — your `model.py` will confirm the actual number). `proj_output` → `(8, 350, vocab_tgt_size)`. For loss, that gets flattened:

```
proj_output.view(-1, vocab_size) → (2800, vocab_size)   # 8 × 350 = 2800
label.view(-1)                    → (2800,)
```

So cross-entropy scores 2,800 token-predictions per batch, 8 of which are the first real prediction of a new sentence and the rest are a mix of real continuation-tokens and ignored `[PAD]` positions.

> **Practical dimension worth internalizing:** literary sentences in `opus_books` are typically ~15–40 tokens long once tokenized. Against `seq_len=350`, that means for a huge fraction of each `(350,)` row, **80–90%+ is `[PAD]`**. You're paying full compute for 350 positions per sentence to carry maybe 30 real tokens. This is exactly why the WandB reference I found (same tutorial lineage) reports **dynamic padding cutting epoch time in half** — padding to the batch's longest sentence instead of a fixed 350 is the single biggest free efficiency win available in this file.

## One inference (greedy decode) pass, in numbers

Unlike training, this is per-sentence, not per-batch (`run_validation` forces `batch_size=1`):

```
decoder_input starts at (1, 1)        → just [SOS]
grows to      (1, 2), (1, 3), ...     → one token added per loop iteration
stops at      (1, k) where k = position of [EOS], or (1, 350) if it never emits EOS
```

Each step re-runs the full decoder over the _entire_ current length — so step _k_ does `O(k)` work, and generating a 25-token translation costs roughly `1+2+...+25 ≈ 325` decoder-position-evaluations rather than 25. That's the KV-cache inefficiency I flagged earlier, now in concrete terms.

`run_validation` only pulls `num_examples=2` sentences from the 3,234 validation pairs per epoch (it breaks the loop at `i == num_examples`) — but it still _computes_ CER/WER/BLEU only over those same 2-3 examples, not the full validation set. So your validation metrics on TensorBoard are a very small, noisy sample, not a real validation-set average — worth knowing if the numbers look jumpy epoch to epoch.

# validation bamboozle
A few corrections and then the real answer:
```
The run_validation is still a bit vague, it runs at the end of all epoch runs on a batch, also, we dont really send it any thing to check on, it directly starts on validation dataset, so is it technically checking the decoder weights that we're tuning? also the tut I followed used 2 examples which didnt make sense to me. What are we doing there
```
## "End of all epoch runs" — actually end of _each_ epoch

Look at where the call sits:

```python
for epoch in range(initial_epoch, config['num_epochs']):
    model.train()
    for batch in batch_iterator:
        ... training step ...
    run_validation(...)   # ← inside the epoch loop, but after the batch loop
    torch.save(...)
```

`run_validation` is indented at the _epoch_ level, not the _batch_ level. So it runs **20 times total** — once after each epoch finishes all 3,638 of its training batches — not once at the very end of training. Same for the checkpoint save right after it.

## "We don't send it anything to check on" — it does, via `val_dataloader`

`run_validation(model, val_dataloader, ...)` — the second argument _is_ the validation data (your 3,234 held-out pairs, never seen during training). Inside, `for i, batch in enumerate(val_dataloader)` pulls real sentences from it. What's misleading is that it only pulls the **first 2-3** before breaking (`if i == num_examples: break`, with `num_examples=2` → runs `i=0,1,2`, so 3 sentences actually, then stops). So yes — it _is_ validation data, just a tiny slice of it per epoch.

## Is it checking the decoder weights?

It's checking **all** the trained weights — encoder, decoder, and the final projection layer together, as one system. Here's why: `greedy_decode` calls `model.encode()` (uses encoder weights) then repeatedly calls `model.decode()` and `model.project()` (decoder + output layer weights) — and `model` here is the _same object_ that just got updated by `optimizer.step()` 3,638 times in the epoch above it. `model.eval()` doesn't freeze or reset anything — it just flips dropout/batchnorm-style layers into inference behavior. The weights themselves are whatever gradient descent left them at.

So concretely: this is asking "if I hand this model a source sentence it has _never seen_ (validation set) and let it generate a translation completely on its own, token by token, using only what it's learned so far — how close does it get?" That's a fundamentally different test than training loss, which only measures "how well does the model predict the _next_ token when I already hand it the correct previous tokens" (teacher forcing). Validation with greedy decode is the closest thing in this file to actually simulating real inference conditions.

## Why only 2 (well, 3) examples — what's actually going on

This is the part that felt arbitrary, and it kind of is — but the intent is: **this isn't the evaluation, it's a sanity check.** It exists so that while training runs for hours, you (a human watching `tqdm.write()` output scroll past) can eyeball a `SOURCE / TARGET / PREDICTED` triplet every epoch and get a gut sense of "is this gibberish, or is it starting to look like Italian?" That's it. It's not meant to be statistically meaningful.

The reason it's cheap on purpose: `greedy_decode` runs sequentially, one token at a time, one sentence at a time (`batch_size=1`, no batching, no KV-cache — as we discussed, each sentence costs `O(k²)`-ish decoder calls). Running that over all 3,234 validation pairs every single epoch would be brutally slow — you'd spend more wall-clock time validating than training. So the tutorial trades rigor for speed: peek at a couple of examples, log a metric anyway (CER/WER/BLEU) almost as a formality, and move on.

The consequence you should actually care about: the `'validation cer/wer/BLEU'` numbers on your TensorBoard graph are computed over those same 2–3 sentences every epoch — so if epoch 4's two random-ish validation sentences happen to be short and easy, and epoch 5's happen to be long and hard, your BLEU curve will look like it got _worse_ even if the model strictly improved. It's not a bug, but it's not a real benchmark either — if you want a trustworthy validation number, you'd increase `num_examples` (e.g. to 50–100) at the cost of epoch time, or run a separate full-validation pass every few epochs instead of every epoch.