# Greedy

Greedy = make the locally optimal choice and never look back. It works when a problem has
**optimal substructure + a matroid-like property** (interval scheduling, Huffman, MST, coin
systems with canonical denominations). Prove via exchange argument in interviews.

---

## 1. Jump Game (can you reach the end?)
**Given:** an array of max jump lengths per position
**Expects:** return true if the last index is reachable
**Pattern:** Running farthest reach

**Approach:** `reach = max(reach, i + nums[i])`; fail if `i > reach`; success if `reach >= n-1`.

**Complexity:** O(n) time, O(1) space.

---

## 2. Jump Game II (minimum jumps)
**Given:** an array of max jump lengths per position
**Expects:** return the minimum jumps to reach the last index
**Pattern:** BFS-in-array: level = jumps, level boundary = current reach

**Approach:**
1. Track `cur_end` (end of current jump level) and `farthest`.
2. When `i == cur_end`: `jumps++; cur_end = farthest`.

```
jumps, cur_end, farthest = 0, 0, 0
for i in range(n - 1):
    farthest = max(farthest, i + nums[i])
    if i == cur_end:
        jumps += 1; cur_end = farthest
```

**Complexity:** O(n) time, O(1) space.

---

## 3. Gas Station
**Given:** gas and cost arrays for a circular route
**Expects:** return the starting index where a full trip is possible, or -1
**Pattern:** Total surplus feasibility + running surplus reset

**Approach:** If `sum(gas) < sum(cost)` → -1. Track running surplus; when negative, reset start to `i+1`.

**Complexity:** O(n) time, O(1) space.

---

## 4. Interval Scheduling (maximum number of non-overlapping intervals)
**Given:** a list of intervals
**Expects:** return the maximum count of non-overlapping intervals
**Pattern:** Sort by **end** time, take earliest finishing

**Approach:** Sort by end; greedily pick interval if `start >= last_end`.

**Complexity:** O(n log n) time.

---

## 5. Merge Intervals
**Given:** a list of intervals
**Expects:** return the merged list of all overlapping intervals
**Pattern:** Sort by start + sweep — `#intervals`

**Approach:** Extend last interval while overlapping; else start new.

**Complexity:** O(n log n) time.

---

## 6. Non-overlapping Intervals (min removals to make non-overlapping)
**Given:** a list of intervals
**Expects:** return the minimum removals needed to make them non-overlapping
**Pattern:** Same as interval scheduling — count kept

**Approach:** Sort by end; keep max non-overlapping set; answer = `n - kept`.

**Complexity:** O(n log n) time.

---

## 7. Insert Interval
**Given:** a sorted list of intervals and one new interval
**Expects:** return the list with the new interval merged in
**Pattern:** Three-phase merge (before / overlap / after)

**Approach:** Append non-overlapping lefts; merge all overlapping into one; append rights.

**Complexity:** O(n) time.

---

## 8. Minimum Number of Arrows to Burst Balloons
**Given:** balloon horizontal ranges
**Expects:** return the minimum arrows to burst all balloons
**Pattern:** Sort by end; one arrow per cluster

**Approach:** Sort by end; if `start > arrow_pos`, new arrow at this end.

**Complexity:** O(n log n) time.

---

## 9. Assign Cookies (satisfy most children)
**Given:** child greed factors and cookie sizes
**Expects:** return the maximum number of satisfied children
**Pattern:** Sort both, smallest cookie to smallest greed

**Approach:** Two pointers; give cookie if `cookie >= greed`.

**Complexity:** O(n log n + m log m) time.

---

## 10. Candy (min candies, higher rating neighbor gets more)
**Given:** a ratings array
**Expects:** return the minimum candies such that higher-rated neighbors get more
**Pattern:** Two passes (left-to-right, right-to-left)

**Approach:**
1. Init all 1. Left pass: if `r[i] > r[i-1]`, `c[i] = c[i-1] + 1`.
2. Right pass: if `r[i] > r[i+1]`, `c[i] = max(c[i], c[i+1] + 1)`.

**Complexity:** O(n) time, O(n) space.

---

## 11. Best Time to Buy and Sell Stock II (unlimited transactions)
**Given:** daily prices
**Expects:** return the max profit with unlimited buy/sell transactions
**Pattern:** Sum all positive daily deltas

**Approach:** `profit += max(0, price[i] - price[i-1])`.

**Complexity:** O(n) time, O(1) space.

---

## 12. Partition Labels (max partitions so each letter in exactly one part)
**Given:** a string
**Expects:** return the lengths of maximum partitions keeping each letter in one part
**Pattern:** Last-occurrence map + running window

**Approach:** Track `end = max(end, last[c])`; when `i == end`, cut a partition.

**Complexity:** O(n) time, O(1) space.

---

## 13. Task Scheduler
**Given:** task labels and a cooldown n
**Expects:** return the minimum intervals to finish all tasks
**Pattern:** Greedy formula or max-heap simulation — `#heap`

**Approach (formula):**
```
minTime = max( (maxFreq - 1) * (n + 1) + countOfMaxFreq, len(tasks) )
```

**Complexity:** O(n) time, O(A) space.

---

## 14. Reorganize String
**Given:** a string
**Expects:** return a rearrangement with no two adjacent equal characters, or ""
**Pattern:** Greedy most-frequent-first with cooldown — `#heap`

**Approach:** Max-heap by freq; alternate; hold one char out each round.

**Complexity:** O(n log A) time.

---

## 15. Lemonade Change
**Given:** a queue of $5/$10/$20 bills
**Expects:** return true if exact change can be given to everyone
**Pattern:** Greedy change-making (give largest bills first)

**Approach:** Track 5s and 10s. For $20, prefer `10+5` over `5+5+5`.

**Complexity:** O(n) time, O(1) space.

---

## 16. Minimum Deletions to Make Character Frequencies Unique
**Given:** a string
**Expects:** return the minimum deletions so all character frequencies are unique
**Pattern:** Sort frequencies descending, greedily reduce to unique values

**Approach:** Sort freqs desc; for each, if `freq >= prev`, reduce to `prev - 1` (or 0), add deletions.

**Complexity:** O(n log n) time (or O(n) with bucket counts).

---

## 17. Minimum Number of Taps to Water a Garden
**Given:** tap positions and ranges on a line
**Expects:** return the minimum taps to water the whole garden
**Pattern:** Convert to jump game II on covered ranges

**Approach:** Build `maxReach[i] = max tap reach starting at i`; run Jump Game II over `[0, n]`.

**Complexity:** O(n) time.

---

## 18. Max Units on a Truck (box types with units, capacity)
**Given:** box types with units and a truck capacity
**Expects:** return the maximum total units loaded
**Pattern:** Sort by units-per-box desc, take greedily

**Approach:** Fill truck with highest unit boxes first.

**Complexity:** O(n log n) time.

---

## 19. Minimum Cost to Connect Sticks
**Given:** stick lengths
**Expects:** return the minimum total cost of merging all sticks
**Pattern:** Always merge the two shortest (Huffman) — `#heap`

**Approach:** Min-heap; pop two smallest, `cost += a + b`, push sum; repeat until one stick.

**Complexity:** O(n log n) time.

---

## 20. Reduce Array Size to The Half
**Given:** an array
**Expects:** return the minimum elements to remove so the array shrinks by half
**Pattern:** Frequencies sorted desc, greedy removal

**Approach:** Remove elements starting from highest frequency until removed ≥ n/2.

**Complexity:** O(n log n) time.

---

## 21. Maximum Subarray Sum with One Deletion (variant) — greedy DP hybrid
**Given:** an array
**Expects:** return the max subarray sum allowing one element deletion
**Pattern:** Track two states

**Approach:** `keep[i] = max(keep[i-1] + x, x)`, `del[i] = max(del[i-1] + x, keep[i-1])`.

**Complexity:** O(n) time, O(1) space.

---

## 22. Queue Reconstruction by Height
**Given:** (height, k) pairs describing a queue
**Expects:** return the reconstructed queue order
**Pattern:** Sort by height desc, k asc; insert at position k

**Approach:** Sorting `(-h, k)` then inserting each person at index `k` into the result guarantees correctness.

**Complexity:** O(n²) with list insert (O(n log n) with Fenwick tree).

---

## 23. Minimum Domino Rotations For Equal Row
**Given:** two rows of dice values
**Expects:** return the minimum rotations to make one row uniform, or -1
**Pattern:** Candidate = A[0] or B[0]; count rotations

**Approach:** For each candidate, check it appears in every column; rotations = columns where row lacks it.

**Complexity:** O(n) time, O(1) space.

---

## 24. Bag of Tokens
**Given:** token values and starting power
**Expects:** return the maximum score under the face-up/face-down rules
**Pattern:** Two-pointer on sorted tokens (score power trade)

**Approach:** Sort; gain score with smallest tokens (face-up), regain power with largest (face-down) when stuck; maximize score.

**Complexity:** O(n log n) time.

---

## 25. Two City Scheduling
**Given:** costs for 2n people to two cities
**Expects:** return the minimum total cost sending exactly n to each city
**Pattern:** Sort by cost difference `aCost - bCost`

**Approach:** First n smallest differences go to city A; rest to B.

**Complexity:** O(n log n) time.

---

## 26. Advantage Shuffle (permute A to beat B in max positions)
**Given:** arrays A and B
**Expects:** return a permutation of A maximizing positions where A[i] > B[i]
**Pattern:** Sort both, two-pointer greedy (minimal winning card)

**Approach:** Sort A, sort B with indices; for each B element use smallest A element that beats it; leftovers fill gaps.

**Complexity:** O(n log n) time.
