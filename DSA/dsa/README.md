# DSA Interview Prep — Problems by Data Structure

A compact cheat-sheet collection of unique, high-frequency interview problems organized by topic.
Each problem includes: **pattern tag, approach (no full code), key formulas/lines, complexity**.

Snippet convention: both **C++ and Python** snippets are shown only where the implementation
differs meaningfully between the languages. Otherwise a single language-agnostic line is given.

## Topic Files

| # | File | Topics covered |
|---|------|----------------|
| 1 | [01-arrays.md](01-arrays.md) | Prefix sums, in-place tricks, rotation, matrix, missing/duplicate numbers |
| 2 | [02-strings.md](02-strings.md) | Palindromes, anagrams, parsing, KMP, pattern tricks |
| 3 | [03-hashing.md](03-hashing.md) | Hash maps/sets as index, group anagrams, frequency patterns |
| 4 | [04-two-pointers.md](04-two-pointers.md) | Pair/triplet sums, in-place dedup, Dutch flag, container |
| 5 | [05-sliding-window.md](05-sliding-window.md) | Fixed/variable windows, k-sum, frequency windows |
| 6 | [06-binary-search.md](06-binary-search.md) | Search in rotated/sorted/matrix, answer-space BS, peak |
| 7 | [07-stack-queue.md](07-stack-queue.md) | Monotonic stack, min-stack, parentheses, sliding max |
| 8 | [08-linked-list.md](08-linked-list.md) | Fast/slow, reversal, cycle, LRU/LFU cache |
| 9 | [09-trees-bst.md](09-trees-bst.md) | Traversals, diameter, LCA, serialization, BST ops |
| 10 | [10-heaps.md](10-heaps.md) | Top-k, k-way merge, median stream, scheduler |
| 11 | [11-graphs.md](11-graphs.md) | BFS/DFS, cycle, topo sort, shortest path, DSU, grid |
| 12 | [12-backtracking.md](12-backtracking.md) | Subsets, permutations, combos, N-Queens, sudoku, word search |
| 13 | [13-greedy.md](13-greedy.md) | Intervals, jump game, gas station, merge intervals |
| 14 | [14-tries.md](14-tries.md) | Trie, prefix search, word search II, XOR pairs |
| 15 | [15-intervals.md](15-intervals.md) | Merge, insert, meeting rooms, interval scheduling |
| 16 | [16-bit-manipulation.md](16-bit-manipulation.md) | XOR tricks, bit counts, power of two, subsets via bits |
| 17 | [17-dynamic-programming.md](17-dynamic-programming.md) | Memo-first DP, 0/1 knapsack, LCS, LIS, edit distance, stock, coins |
| 18 | [18-advanced-design.md](18-advanced-design.md) | Union-Find, segment tree, LRU/LFU, iterator, data stream |

## How to use

1. Start with [01-arrays.md](01-arrays.md) — the base of everything.
2. For each problem: read the pattern tag, try the approach steps on paper.
3. DP problems follow **memoization first**, with tabulation only when it is the better choice.
4. Code is intentionally omitted — the formulas and signatures are enough to reconstruct the solution.

## Complexity notation

`n` = input size, `k` = window/subset size, `V/E` = graph vertices/edges, `W` = knapsack capacity, `A` = alphabet size.
