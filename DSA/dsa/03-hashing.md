# Hashing (Hash Map / Hash Set)

The hash map is the single most-used tool in interviews. It buys O(1) lookup to convert
O(n²) pair checks into O(n) passes. Key ideas: **complement lookup**, **prefix-sum frequency**,
**canonical keys**, **value→index mapping**.

---

## 1. Two Sum
**Given:** an array of integers and an integer target
**Expects:** return the two indices whose values sum to target
**Pattern:** Complement lookup

**Approach:** One pass. Check `target - x` in map; else store `x → i`.

**Complexity:** O(n) time, O(n) space.

---

## 2. Contains Duplicate
**Given:** an array of integers
**Expects:** return true if any value appears more than once
**Pattern:** Set membership

**Approach:** Insert into set; duplicate on failed insert.

**Complexity:** O(n) time, O(n) space.

---

## 3. Longest Consecutive Sequence
**Given:** an unsorted array of integers
**Expects:** return the length of the longest run of consecutive integers, in O(n)
**Pattern:** Set of sequence heads

**Approach:**
1. Load all numbers into a set.
2. Only start counting at `x` when `x-1 ∉ set` (guarantees each chain counted once).
3. Extend while `x+1 ∈ set`.

**Complexity:** O(n) time, O(n) space.

---

## 4. Group Anagrams
**Given:** a list of strings
**Expects:** group strings that are anagrams of each other
**Pattern:** Canonical key

**Approach:** Key = sorted chars (or 26-char count tuple); `map[key].append(word)`.

**Complexity:** O(n·k log k) sorted-key / O(n·k) count-key.

---

## 5. Subarray Sum Equals K
**Given:** an array and a target k
**Expects:** return the count of contiguous subarrays whose sum equals k
**Pattern:** Prefix-sum frequency map

**Approach:**
1. `count[0] = 1` (empty prefix).
2. Iterate: `ans += count[prefix - k]; count[prefix]++`.

```
prefix[j] - prefix[i-1] = k  ⇒  look up how many prefixes equal prefix[j] - k
```

**Complexity:** O(n) time, O(n) space.

---

## 6. Continuous Subarray Sum (multiple of k, length ≥ 2)
**Given:** an array and an integer k
**Expects:** return true if some subarray of length ≥ 2 has a sum that is a multiple of k
**Pattern:** Prefix mod + first-seen index

**Approach:**
1. `mod = prefix % k`; store first index where each mod appeared.
2. If same mod seen before at index `i` with `j - i >= 2` → valid.

**Complexity:** O(n) time, O(min(n, k)) space.

---

## 7. Top K Frequent Elements
**Given:** an array and an integer k
**Expects:** return the k most frequent values
**Pattern:** Frequency map + bucket sort / heap

**Approach:**
1. Count frequencies.
2. **Bucket sort:** `bucket[freq].append(x)`, collect from highest freq down — O(n).
3. Alternative: min-heap of size `k` on `(freq, x)` — O(n log k).

**Complexity:** O(n) with bucket sort; O(n log k) with heap.

---

## 8. Valid Anagram
**Given:** two strings
**Expects:** return true if one is a permutation of the other's characters
**Pattern:** Frequency table

**Approach:** Increment for `s`, decrement for `t`, all zeros at the end.

**Complexity:** O(n) time, O(1) space (26 slots).

---

## 9. Word Pattern (bijection between pattern chars and words)
**Given:** a pattern string and a space-separated word string
**Expects:** return true if the words follow the pattern as a bijection
**Pattern:** Two-way mapping

**Approach:** `char→word` and `word→char` maps; both must agree at every position. Split `s` on spaces first, and check `len(pattern) == len(words)`.

**Complexity:** O(n) time, O(n) space.

---

## 10. Isomorphic Strings
**Given:** two strings
**Expects:** return true if their characters map one-to-one preserving positions
**Pattern:** Two-way char mapping

**Approach:** Same bijection check as Word Pattern, on characters.

**Complexity:** O(n) time, O(A) space.

---

## 11. Intersection of Two Arrays (unique elements)
**Given:** two arrays
**Expects:** return their unique common elements
**Pattern:** Set intersection

```python
set(nums1) & set(nums2)
```

**Complexity:** O(n+m) time, O(n+m) space.

---

## 12. 4Sum II (four arrays, count tuples summing to 0)
**Given:** four arrays
**Expects:** return the count of index tuples (one per array) that sum to zero
**Pattern:** Meet-in-the-middle hash map

**Approach:**
1. Precompute all `a+b` sums into a frequency map — O(n²).
2. For each `c+d`, add `count[-(c+d)]`.

**Complexity:** O(n²) time, O(n²) space.

---

## 13. Copy List with Random Pointer
**Given:** a linked list with next and random pointers
**Expects:** return a deep copy of the list
**Pattern:** Map old node → new node

**Approach:**
1. Pass 1: create clones, store `old → clone` in a hash map.
2. Pass 2: wire `clone.next` and `clone.random` via the map.

**Complexity:** O(n) time, O(n) space.

---

## 14. Clone Graph
**Given:** a graph node
**Expects:** return a deep copy of the graph
**Pattern:** DFS/BFS with visited map (original → clone)

**Approach:** Recursively clone: if node already in map, return its clone; else create clone, map it, clone neighbors.

**Complexity:** O(V + E) time, O(V) space.

---

## 15. LRU Cache
**Given:** a fixed capacity
**Expects:** implement get/put in O(1), evicting the least recently used key when full
**Pattern:** Hash map + doubly linked list

**Approach:**
1. Map `key → node` for O(1) lookup.
2. Doubly linked list keeps recency order; `get` moves node to head, `put` evicts tail.
3. (C++ `list` + `unordered_map`, Python `OrderedDict`.)

**Complexity:** O(1) per operation.

---

## 16. Longest Substring Without Repeating Characters
**Given:** a string
**Expects:** return the length of the longest substring with all unique characters
**Pattern:** Map of last-seen index (with sliding window)

**Approach:** `l = max(l, seen[c] + 1)` on repeat; update `seen[c] = r`.

**Complexity:** O(n) time, O(A) space.

---

## 17. Fraction to Recurring Decimal
**Given:** a numerator and a denominator
**Expects:** return the fraction string with any repeating part wrapped in parentheses
**Pattern:** Remainder → position map

**Approach:**
1. Integer part via `num // den`, sign handling.
2. For fraction: repeatedly `rem *= 10; digit = rem // den; rem %= den`.
3. If a remainder repeats (seen in map), wrap repeating part in `()` from its first position.

**Complexity:** O(len of repeating cycle) time and space.

---

## 18. Random Pick with Weight
**Given:** an array of positive weights
**Expects:** implement pickIndex() returning indices with probability proportional to weight
**Pattern:** Prefix sums + binary search

**Approach:**
1. Build prefix sums `w[i] += w[i-1]`.
2. Pick `r = rand(1, total)`; `bisect_left(prefix, r)` gives the index.

```python
idx = bisect.bisect_left(prefix, random.randint(1, total))
```

**Complexity:** O(n) preprocessing, O(log n) per pick.

---

## 19. Insert Delete GetRandom O(1)
**Given:** nothing
**Expects:** implement a set with insert, remove and getRandom all in average O(1)
**Pattern:** Hash map (value → index) + array, swap-with-last removal

**Approach:**
1. `val → idx` map + dynamic array.
2. **Insert:** append, map it. **Delete:** swap target with last, pop, update moved element's index.
3. **GetRandom:** `arr[rand() % len(arr)]`.

**Complexity:** O(1) average per operation.

---

## 20. Find All Anagrams in a String
**Given:** strings s and p
**Expects:** return all start indices in s where a permutation of p begins
**Pattern:** Sliding window + frequency map (or 26-count array)

**Approach:** Window of `len(p)` slides over `s`; compare counts each step (incrementally: add `s[r]`, drop `s[l]`).

**Complexity:** O(n) time, O(1) space.

---

## 21. Time-Based Key-Value Store
**Given:** set(key, timestamp, value) and get(key, timestamp) operations
**Expects:** return the value stored at the latest timestamp ≤ the query timestamp
**Pattern:** Map key → sorted list of (timestamp, value); binary search

**Approach:**
1. `map[key].append((timestamp, value))` — appends are naturally time-sorted.
2. `get(key, t)`: `bisect_right` on timestamps, take previous entry.

**Complexity:** O(log n) per query, O(1) amortized set.

---

## 22. Encode and Decode TinyURL
**Given:** long URLs
**Expects:** implement a bijective encode/decode pair shortening and restoring them
**Pattern:** Counter-based mapping

**Approach:** Incrementing id → base-62 encoding; two maps: `long→short` and `short→long`.

**Complexity:** O(1) per operation, O(n) space.
