`tiktoken` converts text into numerical token IDs ==by using a Byte Pair Encoding (BPE) algorithm==. Instead of splitting by whole words, it breaks text into frequent sub-word chunks and raw bytes, assigning a unique integer ID to each chunk based on a pre-trained vocabulary. [1, 2, 3]

## How the Encoding Process Works

1. Byte Translation: First, the text is broken down into its raw byte representations. This ensures the tokenizer can handle any language, emoji, or special character without breaking. 
2. Merging Chunks: The BPE algorithm scans for frequently occurring pairs of bytes/sub-words and merges them into a single token. It repeats this merging process recursively following its predefined vocabulary rules. 
3. Integer Mapping: Each resulting sub-word or character grouping is looked up in the model's vocabulary list and converted into a specific, static integer ID. 

## Popular Encoding Models

Depending on the AI model you are interacting with, `tiktoken` uses different vocabularies to give you these encodings: 

- `cl100k_base`: Used by GPT-4, GPT-4o, and GPT-3.5-Turbo. It has a vocabulary size of roughly 100,000 tokens.
- `o200k_base`: Used by newer models like GPT-4o, featuring an expansive vocabulary of around 200,000 tokens.
- `p50k_base`: Used by older models like Codex and text-davinci-002/003.
- `gpt2`: The legacy standard encoding used for the original GPT-2. 

## Basic Example in Python

You can use the `tiktoken` library directly to generate these encodings without needing an API key. [1]

```python
import tiktoken

# 1. Load the appropriate encoding for your model
encoding = tiktoken.get_encoding("cl100k_base")

# 2. Convert text to a list of integer token IDs
token_ids = encoding.encode("tiktoken is great!")
print(token_ids)
# Output: [83, 8251, 2488, 382, 2212, 0]

# 3. Convert integer tokens back into readable text
text = encoding.decode(token_ids)
print(text)
# Output: 'tiktoken is great!'
```
