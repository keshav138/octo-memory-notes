# Backtracking

Backtracking = DFS over a **decision tree** with undo. Universally:

```
choose → explore → unchoose
```

Template:

```python
def backtrack(state):
    if complete(state):
        record(state); return
    for choice in candidates(state):
        if valid(choice):
            apply(state, choice)
            backtrack(state)
            undo(state, choice)
```

Key pruning tricks: sort input to skip duplicates, use `start` index to avoid permutations of
the same set, use visited sets for graph/board problems.

---

## 1. Subsets (all subsets of distinct nums)
**Pattern:** Include/exclude decision tree (or index-based build)

**Approach:**
1. `backtrack(start, path)`: add a copy of `path` to results.
2. For each `i` from `start`: `path.append(nums[i]); backtrack(i+1, path); path.pop()`.

**Complexity:** O(n·2^n) time, O(n) recursion depth.

---

## 2. Subsets II (with duplicates)
**Pattern:** Sort + skip same-level duplicates

**Approach:** Sort; in the loop, `if i > start and nums[i] == nums[i-1]: continue`.

**Complexity:** O(n·2^n) time.

---

## 3. Permutations
**Pattern:** Swap-based or used-array backtracking

**Approach:**
1. `used[]` boolean; at each depth pick any unused element.
2. Or swap-based: `for i in range(start, n): swap(start, i); backtrack(start+1); swap back`.

**Complexity:** O(n·n!) time, O(n) space.

---

## 4. Permutations II (with duplicates)
**Pattern:** Sort + skip duplicates at same depth

**Approach:** `if used[i] or (i > 0 and nums[i] == nums[i-1] and not used[i-1]): continue`.

**Complexity:** O(n·n!) time.

---

## 5. Combination Sum (unlimited use, unique combos)
**Pattern:** Index-based loop with reuse (`start` not advanced)

**Approach:** `backtrack(start, remaining)`; loop `i` from `start`: push `nums[i]`, recurse `(i, remaining - nums[i])`, pop.

**Complexity:** O(n^(T/min)) time, T = target.

---

## 6. Combination Sum II (each number once, no dup combos)
**Pattern:** Sort + `start+1` + same-level dedup

**Approach:** Recurse `(i+1, ...)`; skip `nums[i] == nums[i-1]` at same level.

**Complexity:** O(n·2^n) worst.

---

## 7. Combination Sum III (k numbers from 1..9 summing to n)
**Pattern:** Fixed-count combination

**Approach:** Loop `i` from `start` to 9; recurse with `k-1`, `remaining - i`; record when both hit 0.

**Complexity:** O(C(9,k)) time.

---

## 8. Letter Combinations of a Phone Number
**Pattern:** Cartesian product DFS over digit map

**Approach:** `digits → "abc"` map; for each digit, loop letters; recurse on next digit index.

**Complexity:** O(4^n) time (n digits).

---

## 9. Generate Parentheses
**Pattern:** Constrained choice — open count < n, close count < open

**Approach:**
```
if open < n: add '('
if close < open: add ')'
```
Record when `len == 2n`.

**Complexity:** O(Catalan(n)) = O(4^n / n^1.5) time.

---

## 10. Palindrome Partitioning
**Pattern:** Cut-point DFS + palindrome check

**Approach:** At each position, try every end `j`; if `s[i:j+1]` is palindrome, recurse on `j+1`. Memoize palindrome checks.

**Complexity:** O(n·2^n) time.

---

## 11. Word Search (grid word exists?)
**Pattern:** DFS on grid with visited marking (backtrack)

**Approach:**
1. For each cell matching first char: DFS 4 directions.
2. Mark visited (or mutate cell temporarily), recurse with `idx+1`, unmark.

**Complexity:** O(m·n·4^L) time, L = word length.

---

## 12. Word Search II (multiple words)
**Pattern:** Trie + grid DFS — `#trie`

**Approach:** Build trie of words; DFS grid following trie nodes; collect words at terminal nodes. Prune by removing found words.

**Complexity:** O(m·n·4^L) worst, heavily pruned in practice.

---

## 13. N-Queens
**Pattern:** Row-by-row placement + conflict sets

**Approach:**
1. Place one queen per row; columns/queens marked in 3 sets: `cols`, `diag1 = r+c`, `diag2 = r-c`.
2. Valid if none of the three occupied. Backtrack per row.

```
diag1 = r + c       # ↘ diagonals
diag2 = r - c       # ↙ diagonals
```

**Complexity:** O(n!) time, O(n) space.

---

## 14. Sudoku Solver
**Pattern:** Cell-by-cell DFS with row/col/box constraint sets

**Approach:** Find empty cell; try 1-9; check row, col, box `(r//3, c//3)`; recurse; undo on fail. Optimize by picking the cell with fewest options (MRV).

**Complexity:** O(9^(empty cells)) worst, pruned heavily.

---

## 15. Word Break II (all segmentations)
**Pattern:** DFS with memo over string positions

**Approach:** `dfs(i)` returns all sentences for `s[i:]`; for each word in dict matching `s[i:i+len(w)]`, combine.

**Complexity:** O(2^n) worst without memo, O(n·k) states with memo.

---

## 16. Restore IP Addresses
**Pattern:** 4-segment DFS with validation

**Approach:** Place 3 dots; each segment 1-3 digits, no leading zero (unless "0"), ≤ 255.

**Complexity:** O(3^4) = O(1) per call, O(n) for validation.

---

## 17. Matchsticks to Square
**Pattern:** DFS with side sums + pruning

**Approach:** Target = total/4; assign each stick to one of 4 sides (descending sort first, skip equal side targets).

**Complexity:** O(4^n) worst, pruned.

---

## 18. Partition to K Equal Sum Subsets
**Pattern:** DFS with visited mask + memo

**Approach:** `dfs(mask, remaining)`: try adding each unused element to current bucket; memo on mask.

**Complexity:** O(k·2^n) time, O(2^n) space.

---

## 19. Combination / Phone Number style — Generalized Abbreviation
**Pattern:** For each char: abbreviate (count++) or keep (flush count + char)

**Approach:** At each index choose "abbreviate this char" (increment counter) or "keep it" (append counter + char, reset counter).

**Complexity:** O(n·2^n) time.

---

## 20. Letter Case Permutation
**Pattern:** Branch on alpha chars only

**Approach:** For each alpha char, branch upper/lower; digits pass through unchanged.

**Complexity:** O(n·2^k) time, k = alpha chars.

---

## 21. Gray Code (n-bit sequence differing by 1 bit)
**Pattern:** Recursive reflection — or backtracking with visited set

**Approach:** `gray(n) = gray(n-1) + [x + 2^(n-1) for x in reversed(gray(n-1))]`.

**Complexity:** O(2^n) time.

---

## 22. Remove Invalid Parentheses (minimum removals)
**Pattern:** BFS over states (or DFS with left/right removal counts)

**Approach (DFS):** Count excess `(` and `)`; recurse choosing to remove each bracket; validate at leaf; dedupe results.

**Complexity:** O(2^n) worst.

---

## 23. Expression Add Operators (insert +,-,* into digits to hit target)
**Pattern:** DFS with running value + last operand (for * precedence)

**Approach:** Track `total`, `last` (previous operand), `prev` string. For `*`: `newTotal = total - last + last * cur`.

```
for multiplication: total = total - last + last * cur
```

**Complexity:** O(4^n) time.

---

## 24. Combination Iterator (k-length combos of a string, next() API)
**Pattern:** Combinadic / bitmask iteration

**Approach:** Precompute all C(n,k) bitmasks with k bits set (or use `itertools.combinations` in Python); next() steps through.

**Complexity:** O(C(n,k)) precompute or O(k) per next.

---

## 25. Beautiful Arrangement (permutation with i % a[i] or a[i] % i)
**Pattern:** Permutation backtracking with position constraint

**Approach:** At position `pos`, try unused numbers satisfying divisibility; backtrack.

**Complexity:** O(n!) worst, pruned.

---

## 26. Path with Maximum Gold (grid collect, no revisits)
**Pattern:** Grid DFS returning max gold

**Approach:** From each non-zero cell, DFS collecting `gold + max(neighbors)`; temporarily zero the cell, restore after.

**Complexity:** O((m·n)·4^k) time, k = path length.

---

## 27. Knight's Tour / valid move counting — "Robot Room Cleaner" style exploration
**Pattern:** Direction-ordered DFS with backtracking

**Approach:** Try moves in fixed order; recurse; undo. For constrained grids, mark visited and unmark.

**Complexity:** O(8^(n²)) worst-case theoretical, pruned in practice.
