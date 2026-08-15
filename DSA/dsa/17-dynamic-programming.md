# Dynamic Programming

**Convention in this file: memoization (top-down) is the default.** Tabulation is shown only
where it is clearly better (space optimization, iterative order matters, or recursion depth
is a problem).

Solving any DP problem:

1. Define state: `dp(i, ...)` = answer for a subproblem.
2. Define transition: how the answer combines smaller answers.
3. Identify base cases.
4. Memoize (or build table bottom-up).

**Memoization templates:**

```cpp
// C++
int solve(int i, vector<int>& memo) {
    if (i >= n) return 0;                    // base case
    if (memo[i] != -1) return memo[i];       // cache hit
    return memo[i] = max(solve(i+1, memo), solve(i+2, memo) + a[i]);
}
```
```python
# Python
from functools import lru_cache

@lru_cache(None)
def solve(i):
    if i >= n: return 0                      # base case
    return max(solve(i+1), solve(i+2) + a[i])  # transition
```

---

## 1. Climbing Stairs (ways to reach step n with 1/2 steps)
**Pattern:** Fibonacci-like 1D DP

**Approach:** `dp[i] = dp[i-1] + dp[i-2]`; base `dp[0] = dp[1] = 1`.

**Complexity:** O(n) time, O(1) space (two variables).

---

## 2. House Robber (max loot, no two adjacent)
**Pattern:** Take/skip with constraint

**Approach:** `dp(i) = max(dp(i-1), dp(i-2) + nums[i])`. Tabulate with two variables.

**Complexity:** O(n) time, O(1) space.

---

## 3. House Robber II (circular)
**Pattern:** Run House Robber on `nums[0..n-2]` and `nums[1..n-1]`, take max

**Approach:** The circular constraint means house 0 and n-1 can't both be taken; the two runs cover all cases.

**Complexity:** O(n) time, O(1) space.

---

## 4. Fibonacci Number
**Pattern:** 1D DP

**Approach:** `fib(n) = fib(n-1) + fib(n-2)`; memoize or two-variable iteration.

**Complexity:** O(n) time, O(1) space (iterative).

---

## 5. Min Cost Climbing Stairs (pay cost[i], can start at 0 or 1)
**Pattern:** 1D DP with two starting points

**Approach:** `dp[i] = cost[i] + min(dp[i-1], dp[i-2])`; answer `min(dp[n-1], dp[n-2])`.

**Complexity:** O(n) time, O(1) space.

---

## 6. Coin Change (min coins for amount)
**Pattern:** Unbounded knapsack / min-count DP

**Approach (memo):**
```python
@lru_cache(None)
def dp(amount):
    if amount == 0: return 0
    best = inf
    for c in coins:
        if c <= amount: best = min(best, 1 + dp(amount - c))
    return best
```
**Approach (tabulation):** `dp[a] = min(dp[a], dp[a - c] + 1)` for each coin — better iteration order here.

**Complexity:** O(n·amount) time, O(amount) space.

---

## 7. Coin Change II (number of combinations)
**Pattern:** Unbounded knapsack counting — tabulation is the clean choice

**Approach (tabulation):**
```python
dp = [0] * (amount + 1)
dp[0] = 1
for c in coins:                        # coin outer loop → combinations (order-insensitive)
    for a in range(c, amount + 1):
        dp[a] += dp[a - c]
```

**Complexity:** O(n·amount) time, O(amount) space.

---

## 8. Longest Increasing Subsequence
**Pattern:** 1D DP over ending index (or patience sorting for O(n log n))

**Approach (memo):** `dp(i) = 1 + max(dp(j) for j > i if nums[j] > nums[i])`.

**Approach (optimal):** patience sorting with `bisect_left` on a tails array.

```python
tails = []
for x in nums:
    i = bisect_left(tails, x)
    if i == len(tails): tails.append(x)
    else: tails[i] = x
return len(tails)
```

**Complexity:** O(n²) DP, O(n log n) patience sorting.

---

## 9. Longest Common Subsequence
**Pattern:** 2D string DP

**Approach:** `dp(i, j)`: if `s1[i] == s2[j]` → `1 + dp(i+1, j+1)`; else `max(dp(i+1, j), dp(i, j+1))`.

**Complexity:** O(n·m) time and space (memo: O(n·m) states).

---

## 10. Edit Distance (insert/delete/replace)
**Pattern:** 2D string DP with three transitions

**Approach:**
```
if a[i] == b[j]: dp(i+1, j+1)
else: 1 + min( dp(i+1, j),     # delete from a
               dp(i, j+1),     # insert into a
               dp(i+1, j+1) )  # replace
```

**Complexity:** O(n·m) time and space.

---

## 11. 0/1 Knapsack (max value with weight limit)
**Pattern:** Item/subset DP — tabulation standard, memo fine

**Approach (memo):**
```python
@lru_cache(None)
def dp(i, cap):
    if i == n or cap == 0: return 0
    if wt[i] > cap: return dp(i+1, cap)
    return max(dp(i+1, cap), val[i] + dp(i+1, cap - wt[i]))
```

**Complexity:** O(n·W) time, O(n·W) space (memo) / O(W) space (1D tabulation).

---

## 12. Target Sum (assign +/− to hit target)
**Pattern:** Knapsack on sum offset (or 2D DP over index and running sum)

**Approach:** Count ways: `dp(i, s) = dp(i+1, s - x) + dp(i+1, s + x)`; shift sums by total to index memo. Equivalent subset-sum formulation: `(total + target) / 2`.

**Complexity:** O(n·sum) time and space.

---

## 13. Partition Equal Subset Sum
**Pattern:** Subset sum = total/2

**Approach:** `dp[i]` boolean over sums up to total/2; iterate items descending.

```python
dp = [True] + [False] * (target)
for x in nums:
    for s in range(target, x - 1, -1):
        dp[s] |= dp[s - x]
```

**Complexity:** O(n·target) time, O(target) space.

---

## 14. Word Break
**Pattern:** DP over string positions + set lookup

**Approach:** `dp(i)` = can segment `s[i:]`; try every word matching prefix.

**Complexity:** O(n²) time, O(n) space.

---

## 15. Decode Ways (digits → letter codes 1..26)
**Pattern:** 1D DP with 1-digit and 2-digit lookback

**Approach:**
```
dp[i] = (s[i] != '0') * dp[i+1] + (10 <= int(s[i:i+2]) <= 26) * dp[i+2]
```

**Complexity:** O(n) time, O(1) space.

---

## 16. Unique Paths (grid top-left → bottom-right)
**Pattern:** Grid path DP

**Approach:** `dp[i][j] = dp[i-1][j] + dp[i][j-1]`. Formula shortcut: `C(m+n-2, m-1)`.

**Complexity:** O(m·n) time, O(n) space (1D).

---

## 17. Unique Paths II (with obstacles)
**Pattern:** Same with obstacle zeroing

**Approach:** If `grid[i][j] == 1` → `dp[i][j] = 0`, else sum of top + left.

**Complexity:** O(m·n) time, O(n) space.

---

## 18. Minimum Path Sum
**Pattern:** Grid min-cost DP

**Approach:** `dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1])`.

**Complexity:** O(m·n) time, O(n) space.

---

## 19. Maximum Product Subarray
**Pattern:** Two-state DP (max & min product so far)

**Approach:**
```
curMax = max(x, curMax * x, curMin * x)
curMin = min(x, curMax * x, curMin * x)
```
Careful: compute both from previous values before overwriting.

**Complexity:** O(n) time, O(1) space.

---

## 20. Longest Palindromic Substring
**Pattern:** Center expansion (not really DP) or 2D interval DP

**Approach (DP):** `dp[i][j]` = s[i..j] palindrome iff `s[i]==s[j] and dp[i+1][j-1]`; fill by increasing length.

**Approach (optimal):** expand around 2n-1 centers — O(n²) time, O(1) space.

---

## 21. Palindromic Substrings (count)
**Pattern:** Center expansion count (or interval DP)

**Approach:** Count every valid expansion.

**Complexity:** O(n²) time, O(1) space.

---

## 22. Best Time to Buy and Sell Stock (one transaction)
**Pattern:** Running min — O(n), O(1). (Not really DP but included for the family.)

**Approach:** `profit = max(profit, price - min_so_far)`.

---

## 23. Best Time to Buy and Sell Stock II (unlimited)
**Pattern:** Sum positive deltas (greedy) or two-state DP

**Approach:** `profit += max(0, p[i] - p[i-1])`.

---

## 24. Best Time to Buy and Sell Stock III (at most 2 transactions)
**Pattern:** State machine DP over 4 states

**Approach:** States: `buy1, sell1, buy2, sell2`. Transitions:
```
buy1 = max(buy1, -price)
sell1 = max(sell1, buy1 + price)
buy2 = max(buy2, sell1 - price)
sell2 = max(sell2, buy2 + price)
```

**Complexity:** O(n) time, O(1) space.

---

## 25. Best Time to Buy and Sell Stock IV (at most k transactions)
**Pattern:** 2D DP (day × transactions) or state arrays

**Approach:** `dp[t][d]`; `buy[t] = max(buy[t], sell[t-1] - price)`; `sell[t] = max(sell[t], buy[t] + price)`.

**Complexity:** O(n·k) time, O(k) space.

---

## 26. Best Time to Buy and Sell Stock with Cooldown
**Pattern:** 3-state machine: `held, sold, rest`

**Approach:**
```
held = max(held, rest - price)
rest = max(rest, sold)
sold = held + price
```

**Complexity:** O(n) time, O(1) space.

---

## 27. Best Time to Buy and Sell Stock with Transaction Fee
**Pattern:** 2-state: `hold / not hold`

**Approach:** `hold = max(hold, cash - price)`; `cash = max(cash, hold + price - fee)`.

**Complexity:** O(n) time, O(1) space.

---

## 28. Burst Balloons (max coins, neighbors multiply)
**Pattern:** Interval DP over "last balloon popped"

**Approach:** `dp(i, j)` = max coins from open interval (i, j); for each `k` in (i, j) popped **last**: `nums[i]*nums[k]*nums[j] + dp(i,k) + dp(k,j)`. Pad array with 1s.

**Complexity:** O(n³) time, O(n²) space. Tabulation by increasing length is the clean way here.

---

## 29. Stone Game / Predict the Winner (optimal play)
**Pattern:** Minimax interval DP — memoization with turn difference

**Approach:** `dp(i, j)` = max net score current player can get: `max(nums[i] - dp(i+1, j), nums[j] - dp(i, j-1))`.

**Complexity:** O(n²) time and space.

---

## 30. Minimum Insertion Steps to Make a String Palindrome
**Pattern:** LCS with reverse, or interval DP

**Approach:** `n - LCS(s, reversed(s))` (insert the missing mirror chars). Interval DP alternative: `dp(i,j)` = insertions needed for s[i..j].

**Complexity:** O(n²) time and space.

---

## 31. Longest Palindromic Subsequence
**Pattern:** Interval DP (or LCS of s and reverse(s))

**Approach:** `dp(i, j)`: if `s[i]==s[j]` → `2 + dp(i+1, j-1)`; else `max(dp(i+1, j), dp(i, j-1))`.

**Complexity:** O(n²) time and space.

---

## 32. Interleaving String (s3 is interleaving of s1, s2)
**Pattern:** 2D DP over two string pointers

**Approach:** `dp(i, j)` = can form `s3[i+j:]` from `s1[i:]` and `s2[j:]`: match `s1[i]` or `s2[j]` against `s3[i+j]`.

**Complexity:** O(n·m) time and space.

---

## 33. Regular Expression Matching (`.` and `*`)
**Pattern:** 2D DP over pattern positions

**Approach:** `dp(i, j)` matching `s[i:]` with `p[j:]`:
- `p[j+1] == '*'` → skip `(j+2)` or (if char matches) consume `(i+1)`.
- else match char and advance both.

**Complexity:** O(n·m) time and space.

---

## 34. Wildcard Matching (`?` and `*`)
**Pattern:** 2D DP (or greedy two-pointer for O(n))

**Approach:** `dp(i, j)`; `*` can match empty (`j+1`) or one char (`i+1`).

**Complexity:** O(n·m) DP; O(n+m) greedy with backtrack pointers.

---

## 35. Distinct Subsequences (ways to form t from s)
**Pattern:** 2D DP on character matching

**Approach:** `dp(i, j)`: if `s[i]==t[j]` → `dp(i+1, j+1) + dp(i+1, j)` (use or skip); else `dp(i+1, j)`.

**Complexity:** O(n·m) time, O(m) space (1D tabulation).

---

## 36. Minimum ASCII Delete Sum for Two Strings (make equal)
**Pattern:** LCS variant with cost weights

**Approach:** `dp(i, j)` = min cost: if equal chars → `dp(i+1, j+1)`; else `min(ord(s1[i]) + dp(i+1, j), ord(s2[j]) + dp(i, j+1))`.

**Complexity:** O(n·m) time and space.

---

## 37. Longest String Chain (word is predecessor by one char)
**Pattern:** Sort by length + LIS-style DP

**Approach:** Sort by length; `dp[w] = 1 + max(dp[pred])` for each predecessor (remove one char) present in map.

**Complexity:** O(n·L²) time.

---

## 38. Russian Doll Envelopes (max envelopes that nest)
**Pattern:** Sort (width asc, height desc) + LIS on heights

**Approach:** The height-descending tiebreak prevents same-width nesting; then patience-sort LIS.

**Complexity:** O(n log n) time.

---

## 39. Maximum Length of Pair Chain
**Pattern:** Interval scheduling (sort by end + greedy) — DP equivalent

**Approach:** Sort by end; keep count while `start > last_end`. (DP `dp[i] = 1 + max(dp[j])` also works, O(n²).)

**Complexity:** O(n log n) greedy.

---

## 40. Knight Probability in Chessboard
**Pattern:** Probabilistic DP over moves

**Approach:** `dp[k][r][c]` = probability knight is at (r,c) after k moves: `sum(dp[k-1][nr][nc] / 8)`. Memoize or iterate.

**Complexity:** O(k·n²) time, O(n²) space.

---

## 41. Dungeon Game (min HP to survive grid)
**Pattern:** Reverse grid DP (from princess to knight)

**Approach:** `dp[i][j] = max(1, min(dp[i+1][j], dp[i][j+1]) - dungeon[i][j])` — start from bottom-right with `dp[m-1][n-1] = max(1, 1 - d)`.

**Complexity:** O(m·n) time, O(n) space.

---

## 42. Cherry Pickup (two robots collecting cherries)
**Pattern:** 3D DP (two simultaneous paths, same row)

**Approach:** `dp(r, c1, c2)` = max cherries with both at row r; 9 transitions to next row; sum cells (dedupe when c1 == c2).

**Complexity:** O(n³) time and space.

---

## 43. Paint House (min cost, no two adjacent same color)
**Pattern:** 1D DP over last color

**Approach:** `dp[i][c] = cost[i][c] + min(dp[i-1][other colors])`.

**Complexity:** O(n) time, O(1) space.

---

## 44. Paint Fence (n posts, k colors, ≤2 adjacent same)
**Pattern:** Two-state DP: same-as-previous vs different

**Approach:** `same = diff_prev; diff = (same_prev + diff_prev) * (k - 1)`.

**Complexity:** O(n) time, O(1) space.

---

## 45. Ugly Number II (n-th ugly number)
**Pattern:** DP with three pointers

**Approach:** `dp[i] = min(2*dp[p2], 3*dp[p3], 5*dp[p5])`; advance pointers whose product equals dp[i].

**Complexity:** O(n) time, O(n) space.

---

## 46. Perfect Squares (min squares summing to n)
**Pattern:** Coin-change style unbounded DP

**Approach:** `dp[i] = 1 + min(dp[i - k²])` for all `k² <= i`.

**Complexity:** O(n·√n) time, O(n) space.

---

## 47. Integer Break (max product of parts summing to n)
**Pattern:** 1D DP (or math: maximize 3s)

**Approach:** `dp[i] = max(j * (i-j), j * dp[i-j])` for `1 <= j < i`.

**Complexity:** O(n²) time, O(n) space.

---

## 48. Arithmetic Slices (subarrays forming arithmetic sequences)
**Pattern:** Running-length DP

**Approach:** `dp[i] = dp[i-1] + 1 if nums[i] - nums[i-1] == nums[i-1] - nums[i-2] else 0`; sum all `dp[i]`.

**Complexity:** O(n) time, O(1) space.

---

## 49. Count Number of Teams (i < j < k increasing/decreasing)
**Pattern:** Two-sided counting (or O(n²) DP)

**Approach:** For each middle `j`, count smaller-left × larger-right + larger-left × smaller-right.

**Complexity:** O(n²) time, O(1) space.

---

## 50. Longest Arithmetic Subsequence
**Pattern:** 2D DP keyed by difference

**Approach:** `dp[i][diff] = dp[j][diff] + 1` for each `j < i`; answer max. (Use dict per index.)

**Complexity:** O(n²) time and space.

---

## 51. Longest Common Substring (contiguous)
**Pattern:** 2D DP with reset on mismatch

**Approach:** `dp[i][j] = dp[i-1][j-1] + 1 if a[i]==b[j] else 0`; track max.

**Complexity:** O(n·m) time, O(m) space.

---

## 52. Delete Operation for Two Strings (min deletions to make equal)
**Pattern:** `n + m - 2 * LCS`

**Approach:** Compute LCS; answer = lengths sum minus twice LCS.

**Complexity:** O(n·m) time.

---

## 53. Triangle (min path sum top to bottom)
**Pattern:** Bottom-up grid DP

**Approach:** Start from bottom row; `dp[j] = tri[i][j] + min(dp[j], dp[j+1])` scanning upward.

**Complexity:** O(n²) time, O(n) space.

---

## 54. Minimum Falling Path Sum
**Pattern:** Grid DP with three predecessors

**Approach:** `dp[i][j] = a[i][j] + min(dp[i-1][j-1], dp[i-1][j], dp[i-1][j+1])` (with boundary guards).

**Complexity:** O(m·n) time, O(n) space.

---

## 55. House Robber on Tree (House Robber III)
**Pattern:** Tree DP — post-order pair (take, skip)

**Approach:** For each node return `(with_node, without_node)`:
```
with = node.val + L.without + R.without
without = max(L) + max(R)
```

**Complexity:** O(n) time, O(h) space.

---

## 56. Word Break II — see [12-backtracking.md](12-backtracking.md) (DFS + memo)

**Complexity:** O(n² + output) with memo.

---

## 57. Palindrome Partitioning II (min cuts)
**Pattern:** DP over cuts + palindrome precomputation

**Approach:** Precompute `isPal[i][j]` (O(n²)); then `dp[i] = min(dp[j] + 1)` for palindromic `s[j+1..i]`.

**Complexity:** O(n²) time and space.

---

## 58. Maximal Square (largest all-1s square in matrix)
**Pattern:** 2D DP on cell as bottom-right corner

**Approach:** `dp[i][j] = 1 + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])` if `m[i][j]=='1'` else 0; answer = max².

**Complexity:** O(m·n) time, O(n) space.

---

## 59. Coin Path / Jump Game with costs (Min Cost of Jumping)
**Pattern:** 1D DP with reachback window (deque for optimization)

**Approach:** `dp[i] = cost[i] + min(dp[j])` for `j` in `[i-k, i-1]`; monotonic deque keeps min.

**Complexity:** O(n) time with deque, O(n²) naive.

---

## 60. Bitmask DP — Shortest Path Visiting All Nodes
**Pattern:** DP over (node, visited mask) — memoization

**Approach:**
```python
@lru_cache(None)
def dp(node, mask):
    if mask == FULL: return 0
    return min(dp(nxt, mask | (1 << nxt)) + w for nxt ...)
```

**Complexity:** O(V²·2^V) time.

---

## 61. Count Vowels Permutation (rules-based n-length strings)
**Pattern:** State-transition DP over last char

**Approach:** Transitions: `a→e, e→a/i, i→a/e/o/u, o→i/u, u→a`; sum over states each step.

**Complexity:** O(n) time, O(1) space.

---

## 62. Domino and Tromino Tiling
**Pattern:** Two-state recurrence (full row vs gapped row)

**Approach:**
```
full[i] = full[i-1] + full[i-2] + 2 * gapped[i-1]
gapped[i] = gapped[i-1] + full[i-2]
```

**Complexity:** O(n) time, O(1) space.

---

## 63. Dice Roll Simulation (constrained run lengths)
**Pattern:** 3D DP (n, last face, run length) — memoization

**Approach:** `dp(n, face, run)`: try all faces; if same face, run+1 must stay ≤ rollMax[face]; else reset run=1.

**Complexity:** O(n·6·15) time.

---

## 64. Number of Music Playlists
**Pattern:** DP over (songs used, playlist length)

**Approach:** `dp[i][j]`: add new song → `dp[i-1][j-1] * (n - j + 1)`; replay old (non-recent-k) → `dp[i-1][j] * max(0, j - k)`.

**Complexity:** O(n·L) time.

---

## 65. Minimum Cost Tree From Leaf Values
**Pattern:** Interval DP (or greedy stack — optimal here)

**Approach (DP):** `dp(i, j)` = min cost splitting at k: `max(left) * max(right) + dp(i,k) + dp(k+1,j)`.

**Approach (optimal):** monotonic stack merging smallest products — O(n).

---

## 66. Stone Game variants / Partition DP — see #29 for minimax template

---

## 67. Best DP defaults to remember

| Problem family | State | Transition idea |
|---|---|---|
| Take/skip 1D | `dp(i)` | max(dp(i+1), dp(i+2) + v) |
| 0/1 knapsack | `dp(i, cap)` | max(skip, take) |
| Unbounded knapsack | `dp(amount)` | min/max over coins |
| Two strings | `dp(i, j)` | match or advance one |
| Grid | `dp[i][j]` | top + left |
| Interval | `dp(i, j)` | split at k, fill by length |
| Stocks | state machine | hold/cash transitions |
| Tree | post-order pair | (take, skip) |
| Bitmask | `dp(node, mask)` | mask \| (1 << nxt) |
