Here's the full picture, no code — just what each piece takes in, what it hands back, and why it needs to exist at all.

**1. `get_config()`**

- In: nothing. Out: a dictionary of hyperparameters/paths.
- Why: one place to hold every tunable number (batch size, learning rate, sequence length, etc.) instead of scattering magic numbers through the file.

**2. `get_all_sentences(ds, lang)`**

- In: the raw dataset, a language code. Out: one sentence's text at a time, streamed.
- Why: a feed for the tokenizer trainer below — it needs to see every sentence in a language to build a vocabulary, but doesn't want the whole dataset loaded into memory as one giant list.

**3. `get_or_build_tokenizer(config, ds, lang)`**

- In: config, raw dataset, a language code. Out: a trained tokenizer object for that language (loaded from disk if it already exists, otherwise built and saved).
- Why: this is the text-to-integer converter. Nothing downstream can turn "je vais bien" into numbers without it. Called once per language.

**4. `causal_mask(size)`**

- In: a sequence length. Out: a triangular True/False grid marking which positions are allowed to attend to which.
- Why: stops the decoder from seeing future tokens during training, where the full target sentence is available all at once.

**5. `BilingualDataset` (class)**

- In (per item): one raw sentence pair, both tokenizers, the max sequence length. Out (per item): a dict — `encoder_input`, `decoder_input`, `label`, `encoder_mask`, `decoder_mask`, plus the original text for later printing.
- Why: this is the actual translator between "raw sentence pair" and "tensors + masks the model can consume." Every other piece exists either to feed this class or to consume what it produces.

**6. `get_ds(config)`**

- In: config. Out: two `DataLoader`s (train, validation) that yield batches of `BilingualDataset` items, plus both tokenizers.
- Why: batching + shuffling handler, and the single place where "raw dataset → tokenizers → split → dataset objects → dataloaders" all get chained together.

**7. `get_model(config, vocab_src_len, vocab_tgt_len)`**

- In: config, vocabulary sizes for both languages. Out: one constructed `Transformer` object (untrained, freshly Xavier-initialized).
- Why: thin wrapper around `build_transformer` from `model.py` — the handoff point between the dataset/tokenizer world and the model-architecture world you already understand well.

**8. `train_model(config)` — the orchestrator**

- In: config. Out: nothing returned — its job is side effects (printed loss, saved checkpoint files on disk).
- Why: this is the actual training loop. It calls `get_ds` and `get_model` once at the start, then repeatedly: pull a batch → run it through the model (`encode`→`decode`→`project`) → compare against `label` → compute loss → backpropagate → update weights. It also calls `run_validation` periodically and saves a checkpoint every epoch.

**9. `greedy_decode(model, source, source_mask, tokenizer_tgt, max_len, device)`**

- In: a trained (or in-progress) model, one tokenized source sentence, its mask, the target tokenizer, a max output length. Out: a generated sequence of token ids (the model's translation).
- Why: at inference time there's no `label` to teacher-force with, so this generates the translation one token at a time, feeding each prediction back in as input for the next step.

**10. `run_validation(model, val_dataloader, tokenizer_tgt, max_len, device, num_examples)`**

- In: model, validation dataloader, tokenizer, how many examples to check. Out: nothing returned — prints source/target/predicted sentences to the console.
- Why: a sanity check during training — "is the model actually learning to translate, or just minimizing a loss number?" Calls `greedy_decode` under the hood for each example.

**How they chain together, top to bottom:**

```
get_config
   → get_ds (which internally uses get_all_sentences, get_or_build_tokenizer,
              BilingualDataset — for both train and val splits)
   → get_model (which calls build_transformer from model.py)
   → train_model's loop body (uses encoder_mask/decoder_mask built by
       BilingualDataset, and causal_mask indirectly through those)
   → periodically: run_validation → greedy_decode (uses causal_mask directly,
       fresh each generation step)
```

Everything above `train_model` exists to _prepare ingredients_; `train_model` is the only function that actually trains anything; everything below it exists to _check the result_ without contaminating the training process with test-time behavior.

Want to go back into `train_model` itself now that you've got the map, or is there a specific piece from this list you'd rather revisit first?