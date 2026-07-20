PyTorch
TensorFlow
RAG
Lang Chain/Lang Graph
Agentic AI APP
Foundation Model


LLM
ViT
LORA | PF
Claude
Agentic AI
AI Agents

---

A few clarifying points before I list options — this affects what I recommend:

- Do you want these to be **from-scratch implementations** (train small versions yourself, more interview-defensible) or **applied projects using pretrained models** (faster to build, more "product"-like for resume)?
- Any preference on domain overlap with your existing work — e.g., another F1/finance project, or something completely different to show range?

If you don't want to answer and just want a starting list, here's one from-scratch-leaning and one applied option per category, since that mix usually reads best on a resume:

**Text (Transformer encoder/decoder)**

1. _From scratch_: Build a small encoder-decoder transformer for a narrow task (e.g., English→Hinglish translation, or SQL generation from natural language) — trained on a small dataset, with attention visualization. Strong because you already did the full numeric transformer walkthrough; this converts that theory into a working artifact.
2. _Applied_: Fine-tune a decoder-only model (GPT-2 small / LLaMA via LoRA) for a domain task — e.g., F1 race summary generation from lap data. Ties into your existing F1 project and shows LoRA skills you were already studying.

**Image (YOLO)**

1. _From scratch-ish_: Implement YOLOv1 loss function + inference pipeline yourself (you already did the numeric walkthrough) on a small custom dataset — e.g., F1 car/helmet livery detection from race footage frames.
2. _Applied_: Fine-tune YOLOv8 for a real-world detection task (e.g., defect detection, traffic/pedestrian detection) with a deployed inference API (FastAPI, reusing your existing deployment stack — Docker/Prometheus/Grafana).

**Multimodal (CLIP)**

1. _Applied, resume-strong_: CLIP-based visual search engine — text query → retrieves matching images (e.g., "F1 car with red livery on wet track" over a scraped F1 image dataset). Pairs naturally with your RAG/vector-DB experience (ChromaDB) since it's basically image retrieval with CLIP embeddings instead of text embeddings.
2. _Deeper_: Zero-shot classifier + fine-tuned CLIP (contrastive fine-tuning on a niche dataset) with an evaluation write-up comparing zero-shot vs fine-tuned accuracy.

If you tell me which pairing (from-scratch vs applied) and whether you want F1-themed or fresh domain, I'll help scope one of these into a concrete build plan (architecture, dataset, timeline, CV bullet).