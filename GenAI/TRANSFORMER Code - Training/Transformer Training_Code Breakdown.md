```
your_project_root/
│
├── runs/                           <-- TensorBoard experiment logging directory
│   └── tmodel/                     <-- Value from config['experiment_name']
│       └── events.out.tfevents...  <-- Created automatically when training begins
│
├── weights/                        <-- Model checkpoints folder from config['model_folder']
│   ├── tmodel_0.pt                 <-- Epoch 0 model weights
│   ├── tmodel_1.pt                 <-- Epoch 1 model weights
│   ├── tmodel_2.pt                 <-- Epoch 2 model weights
│   ├── ...
│   └── tmodel_19.pt                <-- Epoch 19 model weights (up to num_epoch - 1)
│
├── tokenizer_en.json               <-- Source tokenizer file (formatted with lang_src)
├── tokenizer_it.json               <-- Target tokenizer file (formatted with lang_tgt)
│
└── your_script.py                  <-- Your python script
```






## 1. `get_config()`

```python
def get_config():
    return {
        "batch_size": 8,
        "num_epochs": 20,
        "lr": 1e-4,
        "seq_len": 350,
        "d_model": 512,
        "lang_src": "en",
        "lang_tgt": "fr",
        "model_folder": "weights",
        "model_basename": "tmodel_",
        "preload": None,
        "tokenizer_file": "tokenizer_{0}.json",
    }
```

Just a dictionary of every knob the rest of the file needs, kept in one place so you're not hunting through the code to change a hyperparameter. Nothing computational happens here.

- `batch_size`, `num_epochs`, `lr` — standard training knobs.
- `seq_len` — the max sentence length, used for **both** `src_seq_len` and `tgt_seq_len` when we call `build_transformer` later (this file uses one shared value for simplicity; nothing stops you from giving English and French different lengths, like we discussed earlier).
- `lang_src` / `lang_tgt` — which two keys to pull out of each `opus_books` example (`item["translation"]["en"]`, `item["translation"]["fr"]`).
- `model_folder`, `model_basename` — where checkpoints get saved, e.g. `weights/tmodel_3.pt` for epoch 3.
- `preload` — set to an epoch number (as a string, e.g. `"3"`) to resume from that checkpoint instead of starting fresh. `None` means train from scratch.
- `tokenizer_file` — a filename template; `.format(lang)` fills in `"en"` or `"fr"` to get `tokenizer_en.json` / `tokenizer_fr.json`.

Nothing to trace here in terms of flow — it's just called once at the very bottom (`train_model(get_config())`) and the resulting dict gets passed into every other function.

## 2. Tokenizers — `get_all_sentences()` and `get_or_build_tokenizer()`

```python
def get_all_sentences(ds, lang):
    for item in ds:
        yield item["translation"][lang]
```

A generator — walks the raw HuggingFace dataset and yields just the text for one language at a time. This exists purely to feed the tokenizer trainer in the next function without loading everything into a list in memory at once.

```python
def get_or_build_tokenizer(config, ds, lang):
    tokenizer_path = Path(config["tokenizer_file"].format(lang))
    if not tokenizer_path.exists():
        tokenizer = Tokenizer(WordLevel(unk_token="[UNK]"))
        tokenizer.pre_tokenizer = Whitespace()
        trainer = WordLevelTrainer(
            special_tokens=["[UNK]", "[PAD]", "[SOS]", "[EOS]"], min_frequency=2
        )
        tokenizer.train_from_iterator(get_all_sentences(ds, lang), trainer=trainer)
        tokenizer.save(str(tokenizer_path))
    else:
        tokenizer = Tokenizer.from_file(str(tokenizer_path))
    return tokenizer
```

This is where "raw text" first becomes something a model can consume. Step by step:

- **Check if a tokenizer already exists on disk** (`tokenizer_en.json`). If yes, just load it — you don't want to rebuild the vocabulary every run.
- **If not, build one:** `WordLevel` means each distinct whitespace-separated word becomes one token (this is the simplest possible tokenizer — real systems use subword tokenizers like BPE, which is likely closer to what you're using for your Nepali corpus, since whole-word tokenization struggles with morphologically rich languages and produces huge vocabularies).
- `Whitespace()` pre-tokenizer — splits text on whitespace/punctuation before the word-level vocabulary building happens.
- Four **special tokens** get reserved ids: `[UNK]` (unknown word), `[PAD]` (padding), `[SOS]`/`[EOS]` (start/end of sentence) — these are the same tokens you'll see wired into `BilingualDataset` next.
- `min_frequency=2` — a word has to appear at least twice in the corpus to earn its own token id; rarer words collapse into `[UNK]`.
- `train_from_iterator(...)` — this is the actual vocabulary-building step: walks every sentence via `get_all_sentences`, assigns each distinct word an integer id.
- `tokenizer.save(...)` — persists the vocabulary to disk as JSON, so next run just loads it back with `Tokenizer.from_file(...)`.

**Where this plugs into the rest of the file:** `get_ds()` (section 5) calls this twice — once for English, once for French — producing `tokenizer_src` and `tokenizer_tgt`. Their vocabulary sizes (`tokenizer.get_vocab_size()`) are exactly the `src_vocab_size`/`tgt_vocab_size` arguments `build_transformer` needs.

## 3. `causal_mask()`

```python
def causal_mask(size):
    mask = torch.triu(torch.ones(1, size, size), diagonal=1).type(torch.int)
    return mask == 0
```

This builds the "no peeking at future tokens" mask we've talked about a few times now — here's exactly how it's constructed.

- `torch.ones(1, size, size)` — start with a `(1, size, size)` matrix of all 1s. The leading `1` is a batch-broadcast dimension, same trick as the positional encoding's `pe`.
- `torch.triu(..., diagonal=1)` — `triu` keeps only the **upper triangle** of the matrix, zeroing out everything on and below the main diagonal. `diagonal=1` means "start one step above the main diagonal" — so even the diagonal itself becomes 0, not just the row.
- `mask == 0` — flips it: now `True` marks positions that were zeroed out by `triu` (i.e. the lower triangle + diagonal), `False` marks the upper triangle.

Concretely, for `size=4`:

```
triu(diagonal=1):        after == 0 (True = allowed):
0 1 1 1                  T F F F
0 0 1 1                  T T F F
0 0 0 1                  T T T F
0 0 0 0                  T T T T
```

Row `i` = "what can position `i` attend to." Row 0 can only see column 0 (itself). Row 2 can see columns 0, 1, 2 — but not 3, which is a future token. That's the whole mechanism: a triangular pattern where each position is only allowed to look at itself and everything before it.

This function gets called in two places later in the file: once inside `BilingualDataset.__getitem__` (to build `decoder_mask` for training), and once inside `greedy_decode` (to build a fresh mask at each generation step, since `decoder_input` keeps growing during inference).

## 4. `BilingualDataset`

This is the class that turns one raw sentence pair into everything the model needs. Let's take it piece by piece.

### `__init__`

```python
def __init__(self, ds, tokenizer_src, tokenizer_tgt, lang_src, lang_tgt, seq_len):
    self.ds = ds
    self.tokenizer_src = tokenizer_src
    self.tokenizer_tgt = tokenizer_tgt
    self.lang_src = lang_src
    self.lang_tgt = lang_tgt
    self.seq_len = seq_len

    self.sos_token = torch.tensor([tokenizer_tgt.token_to_id("[SOS]")], dtype=torch.int64)
    self.eos_token = torch.tensor([tokenizer_tgt.token_to_id("[EOS]")], dtype=torch.int64)
    self.pad_token = torch.tensor([tokenizer_tgt.token_to_id("[PAD]")], dtype=torch.int64)
```

Just stores references — the raw dataset, both tokenizers, and the three special-token ids as single-element tensors (kept as tensors rather than plain ints so they concatenate cleanly with `torch.cat` later, no manual wrapping needed each time). Note it pulls these ids from `tokenizer_tgt` — that's fine since `[SOS]`/`[EOS]`/`[PAD]` were added as special tokens to _both_ tokenizers during training, so they share the same string labels even if their integer ids happen to differ between languages.

`__len__` is trivial — just `len(self.ds)`, so `DataLoader` knows how many examples exist.

### `__getitem__` — the real work, in three parts

**Part A — tokenize the raw text:**

```python
pair = self.ds[idx]["translation"]
src_text = pair[self.lang_src]
tgt_text = pair[self.lang_tgt]

enc_input_tokens = self.tokenizer_src.encode(src_text).ids
dec_input_tokens = self.tokenizer_tgt.encode(tgt_text).ids
```

Pulls one English/French pair out of the dataset, runs each through its own tokenizer, gets back plain lists of integers — no special tokens or padding yet, just the raw token ids for the words in that sentence.

**Part B — figure out how much padding is needed:**

```python
enc_num_padding = self.seq_len - len(enc_input_tokens) - 2
dec_num_padding = self.seq_len - len(dec_input_tokens) - 1
```

Every sequence in the batch must end up exactly `seq_len` long, so shorter sentences get padded out. The `-2` and `-1` account for the special tokens added in Part C: the encoder sequence gets both `[SOS]` and `[EOS]` (2 extra), the decoder input only gets `[SOS]` (1 extra — its `[EOS]` lives in `label` instead, which we'll get to). If a sentence is too long to fit even after this, it raises an error rather than silently truncating.

**Part C — assemble the three sequences:**

```python
encoder_input = torch.cat([self.sos_token, tokens, self.eos_token, pad * n])
decoder_input = torch.cat([self.sos_token, tokens, pad * n])
label          = torch.cat([tokens, self.eos_token, pad * n])
```

This is the piece worth sitting with, since it's the concrete version of "teacher forcing" and the shift-by-one we've discussed conceptually a few times now. Same underlying tokens (`dec_input_tokens`), arranged three different ways:

```
decoder_input:  [SOS]  je   vais  bien  [PAD] [PAD]   <- what the model SEES
label:           je    vais bien [EOS] [PAD] [PAD]    <- what the model must PREDICT
```

Position 0 sees `[SOS]`, must predict `je`. Position 1 sees `[SOS], je`, must predict `vais`. And so on — `label` is just `decoder_input` shifted left by one, with `[EOS]` appended at the end instead of a new `[SOS]` at the start. `encoder_input` is separate and unrelated to this shift — it's the full English sentence, `[SOS]`-and-`[EOS]`-wrapped, since the encoder isn't predicting anything, just building a representation.

Three `assert` lines just double-check all three ended up exactly `seq_len` long — a safety net in case the padding math above has an off-by-one somewhere.

**Part D — build the masks and return everything:**

```python
return {
    "encoder_input": encoder_input,
    "decoder_input": decoder_input,
    "encoder_mask": (encoder_input != self.pad_token).unsqueeze(0).unsqueeze(0).int(),
    "decoder_mask": (decoder_input != self.pad_token).unsqueeze(0).int() & causal_mask(decoder_input.size(0)),
    "label": label,
    "src_text": src_text,
    "tgt_text": tgt_text,
}
```

- `encoder_mask`: `True`/`1` wherever the token isn't `[PAD]`. Two `unsqueeze(0)` calls turn a `(seq_len,)` vector into `(1, 1, seq_len)`, shaped so it broadcasts correctly across attention heads and query positions inside `MultiHeadAttention.attention`.
- `decoder_mask`: same padding check, `&`-combined with `causal_mask` from section 3 — so a position is only attendable if it's _both_ a real (non-pad) token _and_ not in the future. This is the mask that gets passed as `tgt_mask` all the way down into each `DecoderBlock`'s self-attention.
- `src_text`/`tgt_text` are just the original strings, kept around for `run_validation` to print human-readable output later, not used in any tensor math.

That's the whole dataset class — every batch coming out of the `DataLoader` is a dict shaped exactly like this, one per sentence pair, stacked into batches automatically by PyTorch.

## 5. `get_ds()` and `get_model()`

These two functions exist to wire together everything built in sections 2–4 and hand back objects ready for the training loop.

### `get_ds()`

```python
def get_ds(config):
    ds_raw = load_dataset("opus_books", f"{config['lang_src']}-{config['lang_tgt']}", split="train")

    tokenizer_src = get_or_build_tokenizer(config, ds_raw, config["lang_src"])
    tokenizer_tgt = get_or_build_tokenizer(config, ds_raw, config["lang_tgt"])

    train_size = int(0.9 * len(ds_raw))
    val_size = len(ds_raw) - train_size
    train_ds_raw, val_ds_raw = random_split(ds_raw, [train_size, val_size])

    train_ds = BilingualDataset(train_ds_raw, tokenizer_src, tokenizer_tgt,
                                 config["lang_src"], config["lang_tgt"], config["seq_len"])
    val_ds = BilingualDataset(val_ds_raw, tokenizer_src, tokenizer_tgt,
                               config["lang_src"], config["lang_tgt"], config["seq_len"])

    train_dataloader = DataLoader(train_ds, batch_size=config["batch_size"], shuffle=True)
    val_dataloader = DataLoader(val_ds, batch_size=1, shuffle=True)

    return train_dataloader, val_dataloader, tokenizer_src, tokenizer_tgt
```

Step by step:

- `load_dataset("opus_books", "en-fr", split="train")` — pulls the raw English-French sentence pairs from HuggingFace's dataset hub. This is `ds_raw`, the object `get_all_sentences` and `BilingualDataset` both index into with `item["translation"][lang]`.
- Build both tokenizers by calling section 2's function twice — once per language. This is the only place `get_or_build_tokenizer` gets called.
- **Train/validation split:** `random_split` carves the raw dataset 90/10. This is a completely different split from the encoder/decoder split we've discussed elsewhere — this one is about _which sentences_ the model trains on vs. which it's tested on, nothing to do with source/target language.
- Wrap each split in a `BilingualDataset` (section 4) — this is where the raw sentence pairs actually become the padded-tensor-plus-mask dicts.
- Wrap each `BilingualDataset` in a `DataLoader` — this is what handles batching, shuffling, and iteration (`for batch in train_dataloader` in the training loop pulls from here). Note `val_dataloader` uses `batch_size=1` — deliberate, since `run_validation` prints one sentence's source/target/prediction at a time and it's easier to inspect unbatched.
- Returns four things the rest of the file needs: both dataloaders, both tokenizers.

### `get_model()`

```python
def get_model(config, vocab_src_len, vocab_tgt_len):
    return build_transformer(
        vocab_src_len, vocab_tgt_len,
        config["seq_len"], config["seq_len"],
        d_model=config["d_model"],
    )
```

Short by design — this is just a thin call into the `build_transformer` function from `model.py` that we mapped out in detail earlier in this conversation. `vocab_src_len`/`vocab_tgt_len` come from `tokenizer.get_vocab_size()` (called in `train_model`, section 6, right before this function is invoked) — the tokenizer vocabulary sizes become `src_vocab_size`/`tgt_vocab_size`. Both `src_seq_len` and `tgt_seq_len` get the same `config["seq_len"]` value here, since this file uses one shared max length for both languages (as flagged back in section 1).

This is the literal handoff point between everything we discussed in the earlier flow-map conversation (construction-time wiring of `Transformer`, `Encoder`, `Decoder`, all the blocks) and this training-loop conversation — `get_model()` is where that entire construction sequence actually gets triggered, once, at the start of `train_model`.

## `train_model(config)` — full breakdown

```python
def train_model(config):
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    Path(config["model_folder"]).mkdir(parents=True, exist_ok=True)
```

- `device` — a single object telling PyTorch where tensors/weights should physically live: GPU (`"cuda"`) if one's available, otherwise CPU. Every tensor and the model itself get `.to(device)`'d later — mismatched devices (some tensors on GPU, some on CPU) is one of the most common PyTorch errors, so this is set once up front and reused everywhere.
- `Path(...).mkdir(...)` — makes sure the `weights/` folder actually exists on disk before we try to save checkpoints into it later. `parents=True` creates intermediate folders if needed, `exist_ok=True` means don't error if it's already there.

```python
    train_dataloader, val_dataloader, tokenizer_src, tokenizer_tgt = get_ds(config)
    model = get_model(config, tokenizer_src.get_vocab_size(), tokenizer_tgt.get_vocab_size()).to(device)
```

- Unpacks the four things `get_ds` returns (traced in detail last message).
- `get_model(...)` builds the untrained `Transformer` — note `tokenizer_src.get_vocab_size()` and `tokenizer_tgt.get_vocab_size()` are called _here_, on the tokenizer objects `get_ds` handed back — this is where the vocabulary sizes actually become `src_vocab_size`/`tgt_vocab_size` for `build_transformer`.
- `.to(device)` moves every weight in the freshly-constructed model onto GPU/CPU.

```python
    optimizer = torch.optim.Adam(model.parameters(), lr=config["lr"], eps=1e-9)
```

- `optimizer` — the object that actually updates the model's weights based on gradients. `Adam` is a specific update algorithm (adaptive learning rates per-parameter, generally the default choice for transformers).
- `model.parameters()` — hands the optimizer every learnable weight in the entire nested model (every `nn.Linear`, every `nn.Embedding`, everything) — this is the same call used for Xavier init back in `build_transformer`, just now used to tell the optimizer what it's allowed to touch.
- `eps=1e-9` — a tiny constant added inside Adam's math to avoid division by zero; standard boilerplate value, not something you'll usually need to tune.

```python
    initial_epoch = 0
    global_step = 0
    if config["preload"]:
        model_filename = f"{config['model_folder']}/{config['model_basename']}{config['preload']}.pt"
        state = torch.load(model_filename)
        model.load_state_dict(state["model_state_dict"])
        optimizer.load_state_dict(state["optimizer_state_dict"])
        initial_epoch = state["epoch"] + 1
        global_step = state["global_step"]
```

- `initial_epoch` — which epoch number the loop below should _start_ counting from. Defaults to 0 (fresh start).
- `global_step` — a running counter of how many batches total have been processed across all epochs so far (not reset each epoch) — used purely for the `if global_step % 50 == 0: print(...)` logging later, so print frequency stays consistent regardless of epoch boundaries.
- If `config["preload"]` is set (e.g. `"3"`), this whole block loads a saved checkpoint file back in: `state` is the dict that was `torch.save`'d at the end of some previous epoch (see the very bottom of this function). `model.load_state_dict(...)` restores every weight to exactly what it was; `optimizer.load_state_dict(...)` restores Adam's internal momentum/variance buffers too (important — resuming without this would restart Adam's adaptive behavior from scratch, hurting convergence). `initial_epoch = state["epoch"] + 1` — resume from the epoch _after_ the one that was saved, so you don't redo work.

```python
    loss_fn = nn.CrossEntropyLoss(
        ignore_index=tokenizer_tgt.token_to_id("[PAD]"), label_smoothing=0.1
    ).to(device)
```

- `loss_fn` — the function that turns `(model's predictions, correct answer)` into a single number measuring how wrong the model was.
- `ignore_index=...` — tells it "don't count `[PAD]` positions toward the loss at all." Without this, the model would be graded on predicting padding correctly, which is meaningless and would dilute the real signal.
- `label_smoothing=0.1` — instead of training the model to output 100% confidence on the correct token and 0% everywhere else, it softens the target slightly (e.g. 90% on the correct token, the remaining 10% spread across the rest of the vocabulary) — reduces overconfidence, a technique used in the original Transformer paper.

```python
    for epoch in range(initial_epoch, config["num_epochs"]):
        model.train()
        for batch in train_dataloader:
```

- Outer loop: runs from `initial_epoch` up to `config["num_epochs"]` (20 by default) — this range is why `initial_epoch` matters for resuming, you skip epochs already done.
- `model.train()` — switches the model into training mode. This matters specifically because of `nn.Dropout` inside your `FeedForwardBlock`/`MultiHeadAttention`/`PositionalEmbedding` — in train mode, dropout actually randomly zeroes neurons; in eval mode (used later in `run_validation`), dropout is disabled entirely. Same model object, different behavior depending on this flag.

`Theres no model.train() function in model.py, what are we calling?`
Exactly right — `.train()` isn't something defined anywhere in your `model.py`. It's inherited from `nn.Module`, which every one of your classes (`Transformer`, `Encoder`, `EncoderBlock`, `MultiHeadAttention`, everything) subclasses via `class Transformer(nn.Module)`.

**What `nn.Module` actually does with `.train()`:**

`nn.Module` maintains a simple internal flag, `self.training`, defaulting to `True`. Calling `.train()` sets it to `True`; calling `.eval()` sets it to `False`. That's the entire mechanism at the top level — a boolean switch.

**Why calling it on the outer `Transformer` object affects `nn.Dropout` layers buried deep inside `EncoderBlock`s and `PositionalEmbedding`:**

`nn.Module.train()` doesn't just flip its own flag — it **recursively walks every submodule** and flips theirs too. Your `Transformer` holds an `Encoder`, which holds a `ModuleList` of `EncoderBlock`s, each of which holds a `MultiHeadAttention` and `FeedForwardBlock`, each of which holds an `nn.Dropout`. When you call `model.train()` on the outermost `Transformer`, it cascades that same flag-set down through every one of those nested objects, because `nn.ModuleList` and every submodule assigned as `self.something = SomeModule(...)` gets automatically registered as a child — this is the same mechanism that let `transformer.parameters()` find every single weight for Xavier init and for the optimizer earlier, just applied to a boolean flag instead of parameter tensors.

**Where the actual dropout behavior lives:** inside `nn.Dropout.forward`, PyTorch's built-in implementation checks `self.training` — if `True`, it randomly zeroes elements (per the dropout probability you passed at construction) and rescales the rest; if `False`, it's a no-op, `x` passes through unchanged. Your `nn.Dropout` layers never had to be told directly — they inherited the same `self.training` flag-check mechanism from `nn.Module`, and it got set by that same recursive cascade from the top.

Same idea applies to `LayerNormalization` in your case too, though it doesn't currently branch on `self.training` (some normalization layers, like `BatchNorm`, behave differently between train/eval — yours doesn't since it's LayerNorm computed fresh per-sample regardless of mode). So in your specific model, `.train()`/`.eval()` really only visibly matters for the `nn.Dropout` calls scattered through `PositionalEmbedding`, `MultiHeadAttention`, and `FeedForwardBlock` — but the mechanism itself (recursive flag propagation via `nn.Module`) applies to the whole tree regardless of whether every submodule cares about it.

- Inner loop: pulls one batch at a time from `train_dataloader` — this is what triggers `BilingualDataset.__getitem__` repeatedly, as traced last message.

```python
            encoder_input = batch["encoder_input"].to(device)
            decoder_input = batch["decoder_input"].to(device)
            encoder_mask = batch["encoder_mask"].to(device)
            decoder_mask = batch["decoder_mask"].to(device)
```

- `batch` is a dict of already-batched tensors (`DataLoader` automatically stacks 8 individual dataset items into shape `(8, seq_len)` etc.). Each `.to(device)` moves that particular tensor onto GPU/CPU — has to be done per-tensor since `batch` itself is just a Python dict, not a tensor, so it has no single `.to()` call.

```python
            encoder_output = model.encode(encoder_input, encoder_mask)
            decoder_output = model.decode(encoder_output, encoder_mask, decoder_input, decoder_mask)
            proj_output = model.project(decoder_output)
```

- The three-method forward pass, exactly as traced in the flow map — this is the only place in the whole file these three get called together for _training_.

```python
            label = batch["label"].to(device)
            loss = loss_fn(proj_output.view(-1, tokenizer_tgt.get_vocab_size()), label.view(-1))
```
Here is the breakdown of how the dimension changes from `d_model` to `vocab_size` and what is conceptually happening inside the model.

  

### 1. The "How" (The Mechanics)

The `model.project` step is almost always a single standard **Linear layer** (also called a Fully Connected or Dense layer) in PyTorch: `nn.Linear(d_model, vocab_size)`.

  

When you pass the `decoder_output` through this layer, under the hood, PyTorch performs a matrix multiplication:

  

- **Input:** `(Batch, seq_len, d_model)`
    
      
    
- **Weights of Projection Layer:** `(d_model, vocab_size)`
    
      
    
- **Math:** `[Batch × seq_len × d_model] @ [d_model × vocab_size] + bias`
    
      
    
- **Output:** `(Batch, seq_len, vocab_size)`
    
      
    

The Linear layer operates on the very last dimension independently. It looks at each word's `d_model` vector one by one and multiplies it by its internal weights to output a `vocab_size` vector.

  

### 2. The "What" (The Conceptual Meaning)

To understand what this represents for a single word in your batch, let's look at the "before" and "after" of the projection layer.

  

#### Before Projection: `d_model` (The "Concept")

By the time a word reaches the end of the decoder, it is represented by a dense vector of size `d_model` (for example, 512 numbers).

  

You can think of this 512-dimensional vector as the model's **abstract thought** or **concept** for what the next word should be, based on all the context it has seen so far.

  

- It isn't English, Spanish, or any specific word yet.
    
      
    
- It's a mathematical representation that says: _"The next word should be a noun, related to animals, specifically a furry pet, and it should be singular."_
    
      
    

#### After Projection: `vocab_size` (The "Dictionary Scores")

The model needs to translate its "abstract thought" into an actual word from its dictionary (vocabulary).

  

The Projection Layer takes that `d_model` concept vector and compares it against every single word the model knows. If your `vocab_size` is 30,000, the layer outputs an array of 30,000 numbers.

  

These 30,000 numbers are called **Logits** (raw, unnormalized prediction scores).

  

- Each index in this array corresponds to a specific word in your tokenizer's dictionary.
    
      
    
- A **high positive number** at a specific index means the `d_model` concept strongly matches that specific word.
    
      
    
- A **large negative number** means it's a terrible match.
    
      
    

### A Concrete Example

Imagine you are looking at exactly **one word position** in one sequence in your batch.

  

1. **The Decoder Output:** `[0.12, -0.55, 0.89, ...]` _(512 numbers long)_.
    
      
    - _Meaning:_ The model's internal understanding of the next word.
        
          
        
2. **The Projection Layer:** Multiplies those 512 numbers by its learned weights to generate 30,000 new numbers.
    
      
    
3. **The Proj Output:** `[-12.4, 2.1, 8.9, -5.5, ...]` _(30,000 numbers long)_.
    
      
    - Index 0 (`-12.4`): The word "apple". (Bad match)
        
          
        
    - Index 1 (`2.1`): The word "the". (Okay match)
        
          
        
    - Index 2 (`8.9`): The word "cat". (Excellent match!)
        
          
        

When you finally pass this to the `CrossEntropyLoss` function (like in your code), PyTorch will internally convert those 30,000 raw scores into percentages (probabilities) using Softmax, and penalize the model if the highest percentage isn't the correct label.


- `label` — the ground-truth next-tokens for this batch, pulled out of `batch` (built back in `BilingualDataset`).
- `.view(-1, vocab_size)` — `proj_output` is shaped `(batch, seq_len, vocab_size)`; `CrossEntropyLoss` expects predictions shaped `(N, vocab_size)` where `N` is just "how many individual predictions." `.view(-1, vocab_size)` flattens the batch and seq_len dimensions together into one long list of per-token predictions — e.g. `(8, 350, vocab_size)` becomes `(2800, vocab_size)`.
- `label.view(-1)` — same flattening, `(8, 350)` becomes `(2800,)`, so each of the 2800 predictions lines up with exactly one correct-answer id.

```python
            loss.backward()
            optimizer.step()
            optimizer.zero_grad()
```

- `loss.backward()` — this is where autograd walks backward through every operation that produced `loss` (all the way back through `project`, `decode`'s N blocks, `encode`'s N blocks) and computes a `.grad` value for every weight involved.
- `optimizer.step()` — reads each weight's `.grad` and nudges the weight in the direction that reduces loss, scaled by `lr`.
- `optimizer.zero_grad()` — clears out `.grad` on every parameter. **Necessary because gradients accumulate by default in PyTorch** — without this, next batch's `.backward()` would _add_ to this batch's gradients instead of replacing them, silently corrupting training. (Order-wise, some codebases call this _before_ `backward()` instead of after — both work, as long as it happens once per batch before the next `backward()`.)

```python
            if global_step % 50 == 0:
                print(f"epoch {epoch} | step {global_step} | loss {loss.item():.3f}")
            global_step += 1
```

- Just console logging every 50 batches. `loss.item()` pulls the scalar loss out of its tensor wrapper as a plain Python float (needed since `loss` itself is a tensor, and f-strings/formatting want a plain number).

```python
        run_validation(model, val_dataloader, tokenizer_tgt, config["seq_len"], device)
```

- Runs once per epoch, _after_ the inner batch loop finishes (note the indentation — one level back out from `for batch`) — this is the "let's actually check translations, not just watch the loss number" step traced last message.

```python
        model_filename = f"{config['model_folder']}/{config['model_basename']}{epoch}.pt"
        torch.save({
            "epoch": epoch,
            "model_state_dict": model.state_dict(),
            "optimizer_state_dict": optimizer.state_dict(),
            "global_step": global_step,
        }, model_filename)
```

- Also once per epoch. `model.state_dict()` / `optimizer.state_dict()` — dictionaries containing every weight/buffer and every optimizer internal value, respectively — this is exactly what `preload` reads back in at the top of the function. Filename includes the epoch number, so `weights/tmodel_0.pt`, `weights/tmodel_1.pt`, etc. accumulate — each epoch gets its own checkpoint rather than overwriting one file.

That's the entire function — one config-driven setup block, then a two-level loop (epoch → batch) whose body is always the same five-step rhythm: **forward pass → loss → backward → step → zero_grad**, with validation and checkpointing bolted on at the epoch boundary, not the batch boundary.

## `run_validation()` and `greedy_decode()`

These two exist because validation is a fundamentally different situation from training: there's no `label` to compare against in the normal sense, and the model has to actually generate a sentence one token at a time rather than seeing the whole target at once. `run_validation` is the outer wrapper (loops over examples, prints results); `greedy_decode` is where the actual token-by-token generation happens. Let's go through `greedy_decode` first since `run_validation` calls it.

## `greedy_decode(model, source, source_mask, tokenizer_tgt, max_len, device)`

```python
def greedy_decode(model, source, source_mask, tokenizer_tgt, max_len, device):
    sos_idx = tokenizer_tgt.token_to_id("[SOS]")
    eos_idx = tokenizer_tgt.token_to_id("[EOS]")
```

- `source` — one tokenized, padded English sentence, shape `(1, seq_len)` — note it's already been through tokenization and padding by the time it gets here (that happened in `BilingualDataset`, before `run_validation` even calls this function).
- `sos_idx`, `eos_idx` — the integer ids for `[SOS]`/`[EOS]` in the _target_ (French) vocabulary, looked up once so we don't repeatedly call `token_to_id` inside the loop below.

```python
    encoder_output = model.encode(source, source_mask)
```

- This is the one piece of work that only needs doing **once**. The English sentence never changes during generation — only the French side grows token by token — so the encoder's output is computed a single time here and reused for every generation step below, rather than recomputed each iteration.

```python
    decoder_input = torch.empty(1, 1).fill_(sos_idx).type_as(source).to(device)
```

- `decoder_input` — this is the sequence that's going to _grow_ over the course of the function: starts as just `[[SOS]]`, shape `(1, 1)`. `.type_as(source)` makes sure it's the same dtype as `source` (long/int64, needed since these are token ids, not floats). This is the variable that plays the same role `decoder_input` played in training — except in training it was fixed-length and handed over all at once (teacher forcing); here it starts at length 1 and is rebuilt from scratch, longer, on every iteration.

```python
    while True:
        if decoder_input.size(1) == max_len:
            break
```

- The generation loop. `decoder_input.size(1)` checks the current length of the growing sequence (dimension 1, since shape is `(1, current_length)`) — if it's hit `max_len` (`config["seq_len"]`) without ever producing `[EOS]`, force-stop so this doesn't loop forever on a sentence the model never finishes properly.

```python
        mask = causal_mask(decoder_input.size(1)).type_as(source_mask).to(device)
```

- A **fresh** causal mask, rebuilt every single loop iteration, sized to match `decoder_input`'s current length. This is different from training, where `decoder_mask` was built once per batch at a fixed `seq_len`. Here, since `decoder_input` is 1 token long on the first iteration, 2 tokens on the second, 3 on the third, etc., the mask has to regrow with it each time — `causal_mask(1)` is trivially just `[[True]]`, `causal_mask(2)` allows position 1 to see positions 0-1, and so on.

```python
        out = model.decode(encoder_output, source_mask, decoder_input, mask)
```

- Runs the **entire decoder stack again**, from scratch, over the current (growing) `decoder_input` — this is the inefficiency mentioned earlier (no KV caching here): each iteration recomputes self-attention over the whole sequence so far, even though most of it was already computed last iteration. `encoder_output` is reused unchanged, but `decode` itself is not cached.
- `out` — shape `(1, current_length, d_model)`, the decoder's contextual representation for every position generated so far.

```python
        prob = model.project(out[:, -1])
```

- `out[:, -1]` — slices out just the **last position** (`d_model`-sized vector for whatever the newest token is). We only care about predicting the _next_ token, so there's no reason to re-project every earlier position again — those predictions were already used and discarded in previous iterations.
- `model.project(...)` → shape `(1, tgt_vocab_size)` — log-probabilities over the vocabulary for "what comes after everything generated so far."

```python
        _, next_word = torch.max(prob, dim=1)
```

- `torch.max(prob, dim=1)` returns two things: the max value itself (discarded here via `_`) and its **index** along the vocabulary dimension — that index _is_ the predicted token id. This is the "greedy" part of greedy decode: always take the single highest-probability token, no sampling, no alternatives considered.

```python
        decoder_input = torch.cat(
            [decoder_input, torch.empty(1, 1).type_as(source).fill_(next_word.item()).to(device)], dim=1
        )
```

- Appends the newly predicted token onto `decoder_input`, growing it from length `n` to `n+1`. `next_word.item()` pulls the plain Python int out of the tensor so it can be wrapped in a new `(1,1)` tensor and concatenated along `dim=1` (the sequence dimension). This updated `decoder_input` is what gets fed back into `model.decode` on the _next_ iteration — this line is the literal embodiment of "autoregressive": the output of this step becomes part of the input to the next step.

```python
        if next_word.item() == eos_idx:
            break

    return decoder_input.squeeze(0)
```

- Stop condition: if the model itself predicted `[EOS]`, generation is done — the model decided the sentence is finished.
- `decoder_input.squeeze(0)` — removes the leading batch dimension of size 1 (shape `(1, n)` → `(n,)`), since this function only ever processes one sentence at a time. Returns the full generated sequence of token ids, including the leading `[SOS]` and trailing `[EOS]`.

## `run_validation(model, val_dataloader, tokenizer_tgt, max_len, device, num_examples=2)`

```python
def run_validation(model, val_dataloader, tokenizer_tgt, max_len, device, num_examples=2):
    model.eval()
```

- `model.eval()` — the counterpart to `model.train()` from last message: flips `self.training` to `False` across every nested submodule, so `nn.Dropout` layers become no-ops. This matters here specifically because you want to see the model's _actual, deterministic_ best guess — dropout randomly killing neurons during evaluation would make the same input produce different, noisier output every time you validate, which defeats the point of checking quality.

```python
    with torch.no_grad():
```

- Disables gradient tracking for everything inside this block. During training, PyTorch builds up a computation graph behind every tensor operation so `.backward()` can later compute gradients — that bookkeeping costs memory and compute. Validation never calls `.backward()`, so `torch.no_grad()` tells PyTorch not to bother building that graph at all, making this faster and lighter on memory.

```python
        for i, batch in enumerate(val_dataloader):
            if i >= num_examples:
                break
```

- `val_dataloader` has `batch_size=1` (set back in `get_ds`), so each `batch` here is exactly one sentence pair. `enumerate` gives us `i` just to count how many we've done; once `num_examples` (default 2) sentences have been checked, stop — no need to validate on the entire validation set every single epoch, that would be slow and this is just a spot-check.

```python
            encoder_input = batch["encoder_input"].to(device)
            encoder_mask = batch["encoder_mask"].to(device)

            model_out = greedy_decode(model, encoder_input, encoder_mask, tokenizer_tgt, max_len, device)
```

- Pulls just the source-side tensors out of the batch dict — notice **no `decoder_input` or `label` are used at all here**, unlike the training loop. That's the core structural difference between training and validation you asked about earlier: training hands over the ground-truth target and computes a loss against it; validation only gives the model the English sentence and lets `greedy_decode` generate the French from nothing.
- `model_out` — the raw token-id tensor `greedy_decode` returned.

```python
            model_out_text = tokenizer_tgt.decode(model_out.detach().cpu().numpy())
```

- `.detach()` — strips any lingering autograd tracking (redundant here since we're already inside `no_grad()`, but harmless/defensive).
- `.cpu()` — moves the tensor off GPU if it was there, since numpy doesn't understand GPU tensors.
- `.numpy()` — converts to a numpy array, which is the format `tokenizer.decode()` expects.
- `tokenizer_tgt.decode(...)` — the reverse of `.encode()`: takes the list of predicted token ids and maps each back to its word string, joining them into readable French text. This is the detokenization step mentioned all the way back when you first asked whether `src` was text or ids.

```python
            print(f"SOURCE:    {batch['src_text'][0]}")
            print(f"TARGET:    {batch['tgt_text'][0]}")
            print(f"PREDICTED: {model_out_text}")
```

- `batch['src_text']`/`batch['tgt_text']` — the original, untokenized strings that `BilingualDataset` kept around specifically for this purpose (mentioned when we covered that class — this is the payoff). Indexed with `[0]` because even with `batch_size=1`, `DataLoader` still wraps things in a list/batch structure.
- Prints all three side by side — English input, the actual correct French translation, and what the model guessed — so you can eyeball whether the model is learning something sensible, independent of what the loss number says.

```python
    model.train()
```

- Switches back to train mode before returning, since `run_validation` is called _in the middle_ of the epoch loop in `train_model` — without this, the very next batch of actual training would run with dropout disabled, silently changing training behavior for the rest of that epoch.

**The one-sentence version of why these two functions look so different from `train_model`:** training has the answer key and grades all positions in one shot; validation has no answer key and must generate the sentence position-by-position, re-running the decoder from scratch each time a new token is appended — that's the entire reason `greedy_decode`'s `while True` loop exists where training just has a single forward pass.