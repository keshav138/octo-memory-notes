# Project Plans — Transformer / LoRA / CLIP

---

## 1. NL → SQL Encoder-Decoder Transformer (from scratch)

**Goal:** Build a working seq2seq transformer (your own encoder-decoder, not a pretrained model) that translates natural language questions into SQL queries, given a table schema.

**Architecture**
- Encoder: N=4-6 layers, d_model=256-512, multi-head attention (as you already worked through), positional encoding, LayerNorm + residual.
- Decoder: same depth, masked self-attention + cross-attention over encoder output.
- Tokenizer: start with a simple word/subword tokenizer (BPE via `tokenizers` lib) — schema + question as input, SQL as target.

**Dataset**
- WikiSQL or Spider (Spider is harder/multi-table, WikiSQL is simpler single-table — start with WikiSQL, extend to Spider if time permits).
- Input format: `[SCHEMA] table(col1, col2, ...) [QUESTION] show me all drivers with points > 50`

**Phases**
1. Data pipeline: load WikiSQL, build vocab, tokenize (question+schema → input, SQL → target).
2. Implement transformer blocks from scratch in PyTorch (reuse your encoder-decoder + MultiHeadAttention code).
3. Training loop: teacher forcing, cross-entropy loss, label smoothing, LR warmup (as in "Attention is All You Need").
4. Inference: greedy decoding first, then beam search.
5. Evaluation: exact-match accuracy + execution accuracy (run generated SQL against DB, compare results).
6. Bonus: attention heatmap visualization (question token → SQL token alignment) — great for a demo GIF/screenshot.

**Stack:** PyTorch, `tokenizers`, SQLite (to execute generated queries for eval), matplotlib for attention viz.

**Resume bullet (draft):** *"Implemented a transformer encoder-decoder from scratch (PyTorch) for natural-language-to-SQL translation on WikiSQL, achieving X% execution accuracy; included custom multi-head attention, beam search decoding, and attention visualization."*

**Rough timeline:** 2-3 weeks (1 week data+model skeleton, 1 week training/debugging, few days eval+polish).

---

## 2. LoRA Fine-tuned Decoder for F1 Race Summary Generation

**Goal:** Fine-tune a small open decoder-only LLM (e.g., LLaMA-3.2-1B/3B or Phi-3-mini) using LoRA to generate natural-language race summaries from structured lap/telemetry data — extends your existing FastF1 pipeline.

**Architecture / Approach**
- Base model: pick something LoRA-friendly and small enough to fine-tune on limited GPU (1B-3B params). Use `peft` library for LoRA adapters.
- Input: structured race data (lap times, positions, pit stops, gaps) serialized as text/JSON.
- Output: human-readable race summary paragraph.

**Dataset**
- Use your existing FastF1 ETL pipeline to pull structured race data for multiple races/seasons.
- Labels: you'll need summary text — either scrape official F1 race reports / motorsport journalism for target summaries, or bootstrap synthetic summaries using a larger model (e.g., generate with GPT-4/Claude, then fine-tune your small model to mimic style) — this is a common, defensible technique, just document it clearly.

**Phases**
1. Data prep: structured race data → text template → (input, target summary) pairs. Aim for 200-500 examples minimum.
2. Set up LoRA fine-tuning with `peft` + `transformers` (target rank r=8-16, target attention/MLP projection layers).
3. Train, monitor loss, checkpoint.
4. Evaluate: ROUGE/BLEU vs reference summaries + qualitative human review (does it hallucinate stats?).
5. Compare base model vs LoRA fine-tuned outputs side by side (good chart for portfolio).
6. Wrap in a small FastAPI endpoint (reuse your deployment pattern) — input race ID → generated summary.

**Stack:** `transformers`, `peft`, `bitsandbytes` (for 4/8-bit if GPU-limited), FastAPI, your existing FastF1 ETL.

**Resume bullet (draft):** *"Fine-tuned a 1-3B parameter open-source LLM using LoRA (peft) to generate race summaries from structured F1 telemetry data; built end-to-end pipeline from FastF1 ETL to FastAPI-served inference, with base vs fine-tuned comparison eval."*

**Rough timeline:** 1.5-2 weeks (data prep is the bottleneck — reuse existing ETL to speed this up).

---

## 3. CLIP-Based Visual Search Engine (F1 images)

**Goal:** Text query → retrieves matching F1 images from a collection, using CLIP embeddings + vector search. Natural extension of your RAG/ChromaDB experience — same retrieval pattern, image embeddings instead of text.

**Architecture**
- Use pretrained CLIP (`openai/clip-vit-base-patch32` via `transformers` or `open_clip`) — no need to train CLIP from scratch, that's not practical at this scale. Focus is the retrieval system + optional fine-tuning/zero-shot eval.
- Embed all images offline → store vectors in ChromaDB (or FAISS) → at query time, embed text query with same CLIP text encoder → cosine similarity search → return top-k images.

**Dataset**
- Scrape/collect F1 images (drivers, cars, liveries, tracks) — a few thousand images ideally, tagged by team/driver/season if possible for eval purposes.
- Be mindful of copyright/usage for anything you'd publicly host — fine for a portfolio demo with attribution, just don't claim ownership of the images.

**Phases**
1. Data collection: scrape/curate F1 image dataset (Wikimedia Commons is a safer copyright source than random web scraping).
2. Embedding pipeline: CLIP image encoder → batch embed → store in ChromaDB with metadata (driver, team, year).
3. Query pipeline: CLIP text encoder → embed query → similarity search → return ranked images.
4. Build a simple FastAPI + minimal frontend (or just API + Streamlit) for demo: type "red car in the rain" → see results.
5. Bonus/deeper version: zero-shot classification eval (does CLIP correctly classify team liveries zero-shot?) and optionally contrastive fine-tune CLIP on your F1 dataset to see if retrieval improves — write up the before/after comparison.

**Stack:** `open_clip` or HF `transformers` CLIP, ChromaDB, FastAPI, Streamlit/simple HTML for demo UI.

**Resume bullet (draft):** *"Built a CLIP-based text-to-image visual search engine over a curated F1 image dataset, using ChromaDB for vector retrieval and FastAPI for serving; evaluated zero-shot classification accuracy and explored contrastive fine-tuning for domain adaptation."*

**Rough timeline:** 1-1.5 weeks (fastest of the three since CLIP is pretrained — most time goes to data curation).

---

## Suggested order
1. **CLIP visual search** first — fastest win, reuses your ChromaDB/FastAPI skills directly, builds momentum.
2. **NL→SQL transformer** next — most technically deep, best interview talking point since it's fully from scratch.
3. **LoRA F1 summaries** last — benefits from having the other two done (you'll be sharper on training loops, and can reuse eval patterns).

Total estimated time: ~5-6 weeks if worked sequentially, less if parallelized.
