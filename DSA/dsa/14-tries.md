# Tries

A trie is a prefix tree. Use it when the problem is about **prefix matching**, **dictionary
searches in a grid**, **autocomplete**, or **lexicographic comparisons**.

Node shape:

```python
class TrieNode:
    def __init__(self):
        self.children = {}          # or [None]*26 for lowercase
        self.is_end = False         # word boundary
        # extra payloads: count, refs (for deletion), word
```

---

## 1. Implement Trie (insert, search, startsWith)
**Given:** words to insert
**Expects:** implement insert, search and startsWith in O(word length)
**Pattern:** Standard trie ops

**Approach:**
- **insert:** walk/create child per char; mark `is_end` at last char.
- **search:** walk all chars; success iff final node `is_end`.
- **startsWith:** walk all chars; success if walk completes.

**Complexity:** O(L) per operation, L = word length.

---

## 2. Word Search II
**Given:** a character grid and a list of words
**Expects:** return all words found in the grid using a trie to prune
**Pattern:** Trie + grid DFS (prunes massively vs naive DFS per word)

**Approach:**
1. Build trie of all words.
2. DFS grid following trie children (mark cells visited).
3. On `is_end` node, add word; (optional: delete found words from trie to prune).

**Complexity:** O(m·n·4^L) worst case, ~O(m·n·4·L) typical with pruning.

---

## 3. Implement Magic Dictionary (search with exactly one char change)
**Given:** a dictionary
**Expects:** implement search that accepts exactly one character change
**Pattern:** Trie + DFS with one-mismatch budget

**Approach:** DFS with `changed` flag; on mismatch consume the budget; must end on a valid word with `changed == True`.

**Complexity:** O(26^L) worst per query, pruned by trie branches.

---

## 4. Design Add and Search Words Data Structure (wildcard `.`)
**Given:** words
**Expects:** implement search supporting '.' as a wildcard for one character
**Pattern:** Trie + recursive wildcard DFS

**Approach:** On `.`, recurse into **all** children; else follow the specific child. End must be `is_end`.

**Complexity:** O(26^L) worst for all-dots, O(L) typical.

---

## 5. Longest Word in Dictionary (built one char at a time)
**Given:** a dictionary
**Expects:** return the longest word that can be built one character at a time from other words
**Pattern:** Trie or sort+set with prefix check

**Approach:** Trie: BFS/DFS tracking words whose every prefix is a word; keep longest (lex smallest on tie). Set alternative: sort words, keep valid set.

**Complexity:** O(total chars) time.

---

## 6. Replace Words (shortest root prefix replacement)
**Given:** root words and a sentence
**Expects:** replace each word with the shortest root that is its prefix
**Pattern:** Trie with earliest-terminal matching

**Approach:** Build trie of roots; for each sentence word, walk until `is_end` → replace with root, else keep word.

**Complexity:** O(total chars) time.

---

## 7. Implement Prefix Tree with word count (Word Frequency)
**Given:** words
**Expects:** implement a prefix tree returning how many words start with a prefix
**Pattern:** Trie nodes carrying count + prefix count

**Approach:** Increment `count` on each node during insert; `startsWith` returns node's count.

**Complexity:** O(L) per operation.

---

## 8. Maximum XOR of Two Numbers in an Array
**Given:** an array of numbers
**Expects:** return the maximum XOR of any two numbers
**Pattern:** Bitwise trie (31 bits), greedy opposite-bit descent

**Approach:**
1. Insert numbers' bits (MSB → LSB) into binary trie.
2. For each number, descend preferring the **opposite bit**; result = max XOR found.

**Complexity:** O(n·32) time, O(n·32) space.

---

## 9. Count Pairs With XOR in a Range (or count pairs XOR ≤ limit)
**Given:** an array and a range [low, high]
**Expects:** return the count of pairs whose XOR lies in the range
**Pattern:** Bitwise trie + digit DP on bits

**Approach:** For each number, count partners whose XOR with it ≤ limit by trie descent with a digit-DP style branch (compare bit of limit).

**Complexity:** O(n·32) time.

---

## 10. Word Search (single word, trie of 1 word) — also see [12-backtracking.md](12-backtracking.md)
**Given:** a character grid and a word
**Expects:** return true if the word exists in the grid
**Pattern:** DFS grid (trie unnecessary for a single word)

**Approach:** 4-direction DFS with visited marking, matching chars one by one.

**Complexity:** O(m·n·4^L) time.

---

## 11. Design Search Autocomplete System
**Given:** historical sentences with frequencies
**Expects:** return the top-3 suggestions for each typed prefix
**Pattern:** Trie with per-node top-k suggestions

**Approach:** Each node caches top-3 sentences by frequency; queries walk the trie and append to the cached list.

**Complexity:** O(L) per query + O(1) per typed char after warm-up.

---

## 12. Concatenated Words (words formed by other words)
**Given:** a word list
**Expects:** return all words formed by concatenating two or more other words
**Pattern:** Trie (or word set) + DFS word-break per word

**Approach:** Sort by length; for each word, DFS check if it can be segmented into ≥ 2 previously seen words (trie/set membership).

**Complexity:** O(N·L³) worst with set, pruned with trie.

---

## 13. Palindrome Pairs
**Given:** a word list
**Expects:** return all index pairs (i, j) where words[i] + words[j] is a palindrome
**Pattern:** Trie of reversed words + palindrome-suffix checks (or hash map)

**Approach (map):** For each split `i`, check:
- `word[i:]` is palindrome and `word[:i]` reversed in map → pair.
- `word[:i]` is palindrome and `word[i:]` reversed in map → pair.

**Complexity:** O(N·L²) time.

---

## 14. Prefix and Suffix Search (WordFilter)
**Given:** words
**Expects:** implement query(prefix, suffix) returning the max index matching both
**Pattern:** Trie of `suffix + '#' + word` (paired insert)

**Approach:** For each word, insert all `suffix#word` variants into a trie storing max index; query `suf#pre`.

**Complexity:** O(N·L²) space/preprocess, O(L) per query.

---

## 15. Map Sum Pairs
**Given:** key-value inserts
**Expects:** return the sum of all values whose key starts with a prefix
**Pattern:** Trie with per-node sum (or hash map)

**Approach:** Trie nodes store running sum of all inserted values passing through; `sum(prefix)` walks to node and returns its sum.

**Complexity:** O(L) per operation.

---

## 16. Short Encoding of Words (indices of word suffixes)
**Given:** a word list
**Expects:** return the minimum length of an encoding string covering all words
**Pattern:** Trie of reversed words — count leaf depths

**Approach:** Insert reversed words; answer = Σ(depth + 1) over all leaf nodes (each leaf = one reference word).

**Complexity:** O(total chars) time.

---

## 17. Stream of Characters (query if any suffix matches a word)
**Given:** a word list
**Expects:** implement query(c) returning true if any word is a suffix of the stream so far
**Pattern:** Reversed trie + sliding query buffer

**Approach:** Insert reversed words; on query, append char to buffer and walk from the buffer's end backwards through the trie; hit `is_end` → true.

**Complexity:** O(L) per query, L = longest word.

---

## 18. Longest Common Prefix
**Given:** a list of strings
**Expects:** return the longest prefix shared by all of them
**Pattern:** Vertical scan (or trie, if many strings + queries)

**Approach (trie):** Walk the trie while exactly one child exists and no word ends.

**Complexity:** O(S) time, S = total chars.

---

## 19. Find All Words That Share a Common Prefix (auto-suggest core)
**Given:** words and a prefix
**Expects:** return all words sharing that prefix (auto-suggest core)
**Pattern:** Trie walk + DFS collect

**Approach:** Walk to prefix node; DFS from there collecting all words.

**Complexity:** O(L + words found) time.

---

## 20. Minimum Unique Word Abbreviation — trie-assisted pruning variant
**Given:** a target word and a dictionary
**Expects:** return the shortest abbreviation that is not ambiguous with dictionary words
**Pattern:** Trie of conflicting words + DFS

**Approach:** Build trie of words with same length; DFS abbreviations; skip branches matching any conflict word.

**Complexity:** O(2^L) worst, pruned.
