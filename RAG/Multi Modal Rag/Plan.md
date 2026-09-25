Here's a strict build order — each step should be functionally verified before moving to the next, so you're never debugging fusion on top of broken ingestion.

**Phase 1 — Data acquisition**

1. Download 15–20 manufacturer manuals (Carrier/Trane/Goodman PDFs) — pick ones that actually contain wiring diagrams + pressure/charge tables, not just text
2. Crop/extract ~100–150 component images from those manual diagrams and appendices (this doubles as your "failed part" photo stand-in)
3. Write 15 LLM-generated support-call transcripts, each grounded in a specific fact from one of the manuals (so you know the exact ground-truth answer per call)
4. Run those transcripts through TTS (Piper/Coqui, local and free) to get audio files

**Phase 2 — Single-modality pipelines (build and verify independently)**  
5. Text: parse PDFs → chunk → embed with a text embedder (reuse your Financial RAG API embedding setup) → store in pgvector with `modality='text'`  
6. Images: embed cropped images with SigLIP/CLIP → store in pgvector with `modality='image'`  
7. Audio: transcribe with Whisper → embed the transcript text → store with `modality='audio'`  
8. At this point, test each modality's search in isolation — query the text index, query the image index, query the audio index separately. Confirm each returns sane top-k before touching fusion.

**Phase 3 — Fusion + reranking**  
9. Build the parallel-search layer: one query fans out to all three modality indexes simultaneously  
10. Merge candidates into one set, then rerank with a cross-encoder (this is the step most likely to eat debugging time — budget for it)  
11. Return top-N post-rerank with modality tag + source reference intact

**Phase 4 — Serving + citation**  
12. FastAPI endpoint: query → fused retrieval → final synthesis via a vision-capable model → response with citation (manual page number, cropped image, or audio snippet reference)  
13. Wire in return-the-source-image behavior so answers are independently verifiable, not just asserted

**Phase 5 — Eval + ship gate**  
14. Build the 40-question eval set, with 15 questions that are only answerable via image or audio (not text alone)  
15. Build a caption-only baseline (caption every image, embed the caption, retrieve as text) to compare against — this is literally the anti-pattern the brief warns about, so you want it as your weak baseline, not your real system  
16. Score your fused system vs. the baseline on those 15 questions, get a measurable margin  
17. Check p95 latency at k=20, target under 6 seconds — tune batch sizes / index params here if you're over

**Phase 6 — Deploy**  
18. Dockerize, deploy on AWS via Terraform (same pattern as Financial RAG API), add basic monitoring if you want to reuse your Prometheus/Grafana setup

Want me to start on step 1 (sourcing/downloading the manuals) or step 3 (drafting the synthetic call transcripts) first, or do you want to handle data collection yourself and have me focus on the pipeline code once you have files in hand?