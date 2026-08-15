# Arrays

The foundation of every other topic. Patterns here recur everywhere: prefix sums, in-place
rewriting, cycle detection, matrix traversal, index arithmetic.

---

## 1. Two Sum
**Pattern:** Hash map (complement lookup) — `#hashing`

**Approach:**
1. Single pass: for each `x` at index `i`, check if `target - x` exists in map.
2. Return `[map[target - x], i]` if found, else store `map[x] = i`.

```cpp
// C++
unordered_map<int,int> m;                          // value -> index
if (m.count(target - x)) return {m[target-x], i};
```
```python
# Python
seen = {}                                          # value -> index
if target - x in seen: return [seen[target - x], i]
```

**Complexity:** O(n) time, O(n) space.

---

## 2. Best Time to Buy and Sell Stock (single transaction)
**Pattern:** Kadane-style running min/max diff

**Approach:**
1. Track `min_price` seen so far.
2. `max_profit = max(max_profit, price - min_price)` each day.

`profit = max(profit, price - min_so_far)`

**Complexity:** O(n) time, O(1) space.

---

## 3. Product of Array Except Self
**Pattern:** Two-pass prefix/suffix products, no division

**Approach:**
1. Pass 1: `ans[i]` = product of all elements to the **left** of `i`.
2. Pass 2 (right to left): multiply by running product of all elements to the **right**.

```python
res = [1]*n
for i in range(1, n):  res[i] = res[i-1] * nums[i-1]   # left products
for i in range(n-2, -1, -1):  res[i] *= suffix        # suffix *= nums[i+1]
```

**Complexity:** O(n) time, O(1) extra space (output array excluded).

---

## 4. Maximum Subarray (Kadane's Algorithm)
**Pattern:** Dynamic programming, running sum reset

**Approach:**
1. `cur = max(x, cur + x)` — restart the subarray when the running sum becomes a liability.
2. `best = max(best, cur)`.

**Complexity:** O(n) time, O(1) space.

---

## 5. Merge Sorted Arrays (in-place, nums1 has trailing buffer)
**Pattern:** Three pointers, fill from the back

**Approach:**
1. Pointer `p = m+n-1` (write position), `i = m-1`, `j = n-1`.
2. Write the larger of `nums1[i]` and `nums2[j]` at `p`, move the corresponding pointer left.
3. Copy remaining `nums2` elements if any (`i` exhaustion is already in place).

**Why from the back:** avoids shifting elements when overwriting `nums1`.

**Complexity:** O(m+n) time, O(1) space.

---

## 6. Rotate Array (by k steps)
**Pattern:** Three reversals

**Approach:**
1. `k %= n`
2. Reverse whole array → reverse first `k` → reverse last `n-k`.

```python
def rev(l, r):                      # inclusive reverse
    while l < r: nums[l], nums[r] = nums[r], nums[l]; l += 1; r -= 1
rev(0, n-1); rev(0, k-1); rev(k, n-1)
```

**Complexity:** O(n) time, O(1) space.

---

## 7. Contains Duplicate
**Pattern:** Hash set

**Approach:** Add each element to a set; a failed insertion means duplicate.

**Complexity:** O(n) time, O(n) space.

---

## 8. Find Missing Number (0..n)
**Pattern:** XOR or sum formula

**Approach:** `missing = sum(0..n) - sum(array)` — or XOR all indices and values, the survivor is the missing number.

```
sum(0..n) = n*(n+1)/2
```

**Complexity:** O(n) time, O(1) space.

---

## 9. Find All Duplicates in Array (values in [1, n])
**Pattern:** Index marking (negation) — cycle-sort trick

**Approach:**
1. For each `x`, `idx = abs(x) - 1`.
2. If `nums[idx] < 0` → `x` is a duplicate. Else negate `nums[idx]`.

**Complexity:** O(n) time, O(1) space, no array mutation beyond sign flips.

---

## 10. First Missing Positive
**Pattern:** Cycle sort / in-place bucket placement

**Approach:**
1. Place each value `v` in `[1, n]` at index `v-1` by swapping (ignore `v<=0` and `v>n`).
2. Scan: first `i` where `nums[i] != i+1` → answer `i+1`; else `n+1`.

**Complexity:** O(n) time, O(1) space.

---

## 11. Majority Element (appears > n/2)
**Pattern:** Boyer-Moore voting

**Approach:**
1. `count=0`. If `count==0`, set `candidate=x`.
2. `count += 1 if x == candidate else -1`.
3. (Second pass to verify if majority is not guaranteed.)

**Complexity:** O(n) time, O(1) space.

---

## 12. Next Permutation
**Pattern:** Lexicographic successor

**Approach:**
1. Find pivot `i` from right where `a[i] < a[i+1]`.
2. Find smallest `j > i` with `a[j] > a[i]`, swap `a[i]`, `a[j]`.
3. Reverse `a[i+1:]`.

**Complexity:** O(n) time, O(1) space.

---

## 13. Spiral Matrix
**Pattern:** Four boundary pointers

**Approach:**
1. Maintain `top, bottom, left, right`.
2. Traverse top row → right col → bottom row (reversed) → left col (reversed).
3. Shrink boundaries after each pass; stop when `top > bottom` or `left > right`.

**Complexity:** O(m·n) time, O(1) space (excluding output).

---

## 14. Rotate Image (90° clockwise, in-place)
**Pattern:** Transpose + reverse rows

**Approach:**
1. Transpose: swap `m[i][j]` with `m[j][i]` for `j > i`.
2. Reverse each row.

**Complexity:** O(n²) time, O(1) space.

---

## 15. Set Matrix Zeroes
**Pattern:** In-place flags in first row/col

**Approach:**
1. Use `m[0][j]` / `m[i][0]` as markers (plus one extra flag for first row or column overlap).
2. Pass 1: mark first cell of any row/col containing a zero.
3. Pass 2: zero out rows/cols based on markers. Handle first row/col last.

**Complexity:** O(m·n) time, O(1) space.

---

## 16. Subarray Sum Equals K
**Pattern:** Prefix sum + hash map of counts

**Approach:**
1. Running `sum`; map stores `count` of each prefix sum seen.
2. At each step, `ans += count[sum - k]`, then `count[sum]++`.

```
prefix[i] = sum(nums[0..i])
subarray(i, j] sums to k  ⇔  prefix[j] - prefix[i-1] = k
```

**Complexity:** O(n) time, O(n) space.

---

## 17. Sort Colors (Dutch National Flag)
**Pattern:** Three-way partition — `#two-pointers`

**Approach:**
1. `lo` (next 0 slot), `mid` (scanner), `hi` (next 2 slot).
2. `0 → swap(lo, mid), lo++, mid++`; `1 → mid++`; `2 → swap(mid, hi), hi--`.

**Complexity:** O(n) time, O(1) space, single pass.

---

## 18. Trapping Rain Water
**Pattern:** Two-pointer bounded by min of max heights

**Approach:**
1. `l=0, r=n-1, leftMax=0, rightMax=0`.
2. If `height[l] < height[r]`: `leftMax = max(leftMax, height[l]); ans += leftMax - height[l]; l++` — mirror for right.

`water at i = min(max_left, max_right) - height[i]`

**Complexity:** O(n) time, O(1) space.

---

## 19. Gas Station (circular route)
**Pattern:** Greedy — total surplus feasibility + running surplus restart

**Approach:**
1. If `sum(gas) < sum(cost)` → impossible.
2. Track running `surplus = gas[i] - cost[i]`; when it goes negative, reset start to `i+1` and surplus to 0.

**Complexity:** O(n) time, O(1) space.

---

## 20. Merge Intervals
**Pattern:** Sort by start + sweep — `#intervals`

**Approach:**
1. Sort by start.
2. If `cur.start <= last.end` → `last.end = max(last.end, cur.end)`, else append.

**Complexity:** O(n log n) time, O(n) space for output.

---

## 21. Search in Rotated Sorted Array
**Pattern:** Modified binary search — `#binary-search`

**Approach:**
1. `mid`; at least one of `[lo, mid]` / `[mid, hi]` is sorted.
2. If target in sorted half → search it; else search the other half.

**Complexity:** O(log n) time, O(1) space.

---

## 22. Longest Consecutive Sequence
**Pattern:** Hash set of sequence starts

**Approach:**
1. Put all numbers in a set.
2. Only start counting from `x` if `x-1` **not** in set (i.e., `x` is a sequence head).
3. `while x+1 in set: count++`.

**Complexity:** O(n) time, O(n) space (each element visited once).

---

## 23. Find Duplicate Number (array with values in [1, n], exactly one repeat)
**Pattern:** Floyd's cycle detection on index graph

**Approach:**
1. Treat `nums[i]` as "next node" from `i` — duplicate creates a cycle entry.
2. `slow = nums[slow]; fast = nums[nums[fast]]` until they meet.
3. Reset `slow = 0`; move both one step at a time; meeting point is the duplicate.

**Complexity:** O(n) time, O(1) space.
