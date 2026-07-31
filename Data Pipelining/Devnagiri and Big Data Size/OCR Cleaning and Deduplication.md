# Nepali Corpus Cleaning Pipeline — Docs

Two-phase pipeline for OCR cleaning and deduplication of the extracted, normalized `chunk_XXXX.txt` files.

- **Phase 1 (`ocr_clean.py`)** — parallelizable, run per-teammate on a file range.
- **Phase 2 (`dedup_global.py`)** — must run once, sequentially, over all Phase 1 output.

Run order: everyone finishes Phase 1 first → then one person runs Phase 2 once.

---

## `ocr_clean.py` — Phase 1: OCR cleaning

### What it does

Reads each input line and either keeps a cleaned version or drops it, based on:

|Check|Rule|
|---|---|
|Character filter|Keeps only Devanagari characters (`U+0900`–`U+097F`), the punctuation set `। ॥ , -`, and spaces. Everything else (Latin letters, symbols, stray marks) is stripped from the line, not the whole line dropped.|
|Min length|Drop if fewer than 3 characters remain after filtering.|
|Dominant character|Drop if any single character makes up more than **60%** of the line (e.g. a line of repeated OCR noise like `--------`).|
|Long digit run|Drop if there's a run of **6+** consecutive Devanagari digits (`०-९`) — usually a scan artifact, not real text.|
|Devanagari ratio|Of the remaining "meaningful" characters (excluding spaces, punctuation, and digits), at least **80%** must be Devanagari letters, or the line is dropped.|
|Final tidy|Collapses `।।` → `।`, `॥` → `।`, trims stray leading/trailing punctuation/spaces.|

Unicode NFC normalization is applied before filtering.

### Key config (top of file)

```python
DEVANAGARI_THRESHOLD = 0.80      # min fraction of Devanagari letters required
SINGLE_CHAR_DOMINANCE = 0.60     # drop line if one char exceeds this fraction
```

### CLI usage

```bash
python ocr_clean.py --input_dir <dir> --output_dir <dir> --start <int> --end <int>
```

|Arg|Meaning|
|---|---|
|`--input_dir`|Folder containing `chunk_XXXX.txt` files (default: `chunks`)|
|`--output_dir`|Where cleaned files are written (default: `chunks_cleaned`)|
|`--start`|Start index into the **sorted file list** (0-indexed, inclusive)|
|`--end`|End index into the sorted file list (exclusive)|

Note: `--start`/`--end` are positions in the sorted file list, **not** the number in the filename. With 200 files named `chunk_0000.txt` … `chunk_0199.txt`, index `0` = `chunk_0000.txt`, index `1` = `chunk_0001.txt`, etc. — they happen to line up here because the files are sequentially numbered, but the flags themselves don't parse the filename.

Output filenames: `chunk_XXXX.txt` → `chunk_XXXX_cleaned.txt`, same directory structure.

### Example: splitting 200 files across 5 teammates

```bash
# person 1
python ocr_clean.py --start 0   --end 40
# person 2
python ocr_clean.py --start 40  --end 80
# person 3
python ocr_clean.py --start 80  --end 120
# person 4
python ocr_clean.py --start 120 --end 160
# person 5
python ocr_clean.py --start 160 --end 200
```

Each range is fully independent — no shared state, safe to run in parallel on separate machines/Colab sessions.

### Per-file console output

```
[i/N] chunk_0000.txt: kept 812,340 / dropped 285,844 of 1,098,184
```

---

## `dedup_global.py` — Phase 2: global deduplication

### Why this can't be split by file range

A duplicate line can land in two different teammates' file ranges (e.g. the same page OCR'd twice, or repeated boilerplate across source documents). Deduplicating each range independently would miss cross-range duplicates. This script must run as a **single sequential pass** over every cleaned file, after all Phase 1 ranges are finished.

### Why a Bloom filter instead of an exact hash set

At ~220M total lines, an exact set of MD5 hashes would need roughly 25–30GB of RAM — too much for Colab free tier. A Bloom filter trades a small, tunable false-positive rate for a much smaller memory footprint: at `fp_rate=0.01` (1%) and 220M expected items, the filter needs only ~250–300MB.

**Trade-off to be aware of**: a false positive means a genuinely unique line gets wrongly treated as a duplicate and dropped. There are no false negatives — a real duplicate is never missed. At 1% FP rate this means roughly 1 in 100 unique lines could be lost; for training-corpus-scale data this is generally an acceptable cost for fitting in memory.

### How the Bloom filter works (`BloomFilter` class)

- Bit array sized automatically from `n_items` and `fp_rate` (standard Bloom filter formulas).
- Uses **double hashing** (MD5 + SHA1, combined) to derive `k` hash positions per item from just two underlying hashes — avoids needing `k` separate hash functions.
- `add_and_check(item)` — adds the item to the filter and returns `True` if it was already (probably) present. One call does both the check and the insert.

### Key config

```python
expected_lines = 220_000_000   # rough total line count across all cleaned files
fp_rate = 0.01                 # 1% false positive rate
```

Overestimating `expected_lines` is safe (filter just gets a bit larger). Underestimating raises the real false-positive rate above the target.

### Usage

Edit the call at the bottom of the file (or import and call directly):

```python
dedup_all(
    cleaned_dir='chunks_cleaned',   # Phase 1 output, from ALL teammates combined
    output_dir='chunks_deduped',    # final deduplicated corpus
    expected_lines=220_000_000,
    fp_rate=0.01,
)
```

Then run once:

```bash
python dedup_global.py
```

### What it matches as a "duplicate"

Exact line match only (after Phase 1 cleaning, on the full line string). It will **not** catch near-duplicates that differ by a stray character — that's a fuzzier/more expensive problem and isn't handled here.

### Console output

```
[i/N] chunk_0000_cleaned.txt done (running totals - kept: 812,340, duplicates: 1,204)
...
Final: total lines 162,483,910, kept 158,220,115, duplicates removed 4,263,795
```

---

## Recommended full workflow

1. All 5 teammates run `ocr_clean.py` on their assigned `--start`/`--end` range, writing into the same shared `chunks_cleaned/` folder (e.g. on a shared Drive mount).
2. Confirm all 200 files have a corresponding `_cleaned.txt` output.
3. One person runs `dedup_global.py` once over the full `chunks_cleaned/` folder, producing `chunks_deduped/` — the final corpus.