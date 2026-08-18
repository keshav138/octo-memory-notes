Let's go through the "bookkeeping" layer — the stuff that isn't the transformer itself, but lets you _see_ and _resume_ what happened.

## `SummaryWriter` (TensorBoard)

`writer = SummaryWriter(config['experiment_name'])` opens a logging session pointed at `runs/tmodel/`. Every time you call `writer.add_scalar(tag, value, step)`, it appends one data point to a file in that folder — a binary log called `events.out.tfevents.<timestamp>.<hostname>`. This isn't human-readable; it's meant to be read by the TensorBoard tool (`tensorboard --logdir runs/tmodel`), which turns it into live line graphs in your browser.

In your script, three things get logged:

- `'train loss'` — every single batch, inside the training loop. This is your main "is it learning" signal — with `global_step` on the x-axis, you'll see it as one continuous descending line across the whole run (not per-epoch, per-batch).
- `'validation cer'`, `'validation wer'`, `'validation BLEU'` — once per epoch, at whatever `global_step` validation happened to run at, so on the graph they show up as sparse points rather than a dense line.

`writer.flush()` forces the buffered log data to actually be written to disk immediately, rather than waiting for TensorBoard's internal buffer to fill up. Practically: without `flush()`, if you tail the logs while training is running, you might not see recent points for a while. With batch-level flushing (as you're doing), it costs a tiny bit of I/O overhead per batch but guarantees the graph is always current if you're watching live.

> _Pointer:_ you're calling `.flush()` after every single `add_scalar` — for training loss that's once per batch, which is more I/O than necessary. Flushing once per epoch (or letting it auto-buffer) is the more common pattern; only matters if you're logging thousands of batches and want to shave a bit of wall-clock time.

## `batch_iterator.write(msg)`

`batch_iterator = tqdm(train_dataloader, ...)` is the progress bar object. `tqdm` objects have a `.write()` method specifically because `print()` would break the progress bar's rendering — it would print a new line and mess up the bar's in-place updates (the bar redraws itself on the same terminal line using carriage returns; a raw `print()` collides with that).

So in `run_validation`, `print_msg` is passed in as `lambda msg: batch_iterator.write(msg)` — meaning "when validation wants to print SOURCE/TARGET/PREDICTED, route it through tqdm's safe-write instead of `print()`" so your progress bar for the _next_ epoch doesn't get visually corrupted by validation output from the epoch that just ended.

## The files being created, end to end

Given your `get_config()` layout, after training you'd have:

```
project_root/
├── tokenizer_en.json          ← built once, on the very first run (get_or_build_tokenizer)
├── tokenizer_it.json          ← same, for the target language
├── runs/tmodel/
│   └── events.out.tfevents.*  ← TensorBoard log, grows continuously during training
└── weights/
    ├── tmodel_00.pt           ← full checkpoint after epoch 0
    ├── tmodel_01.pt           ← full checkpoint after epoch 1
    ├── ...
    └── tmodel_19.pt           ← after the final epoch (num_epochs=20)
```

The two tokenizer JSONs are vocabulary files — they don't change once built (unless you delete them), and every run after the first just loads them instead of retraining.

The `weights/tmodel_NN.pt` files are the actual model checkpoints, one per epoch, and each one bundles four things together (from your `torch.save` dict): `model_state_dict` (the weights), `optimizer_state_dict` (Adam's momentum/variance buffers — needed so resuming training doesn't reset the optimizer's memory), `epoch`, and `global_step`. That's what makes `config['preload']` work: point it at, say, `tmodel_05.pt`, and training resumes exactly from epoch 6 with the optimizer in the same state it was in, rather than restarting cold.

> _Pointer:_ since you save every epoch with no cleanup, 20 epochs = 20 full checkpoints on disk. For a transformer of any real size that adds up fast (weights + optimizer state is roughly 2-3x the raw model size per file) — worth knowing if disk space is a concern, and something you'd eventually want to change to "save best only" or "save last N."