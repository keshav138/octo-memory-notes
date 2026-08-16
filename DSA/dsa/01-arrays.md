# Arrays

The foundation of every other topic. Patterns here recur everywhere: prefix sums, in-place
rewriting, cycle detection, matrix traversal, index arithmetic.

---

## 1. Two Sum
**Given:** an array of integers and an integer target
**Expects:** return the two indices whose values sum to target
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
**Given:** an array of daily stock prices
**Expects:** return the max profit from a single buy-then-sell
**Pattern:** Kadane-style running min/max diff

**Approach:**
1. Track `min_price` seen so far.
2. `max_profit = max(max_profit, price - min_price)` each day.

`profit = max(profit, price - min_so_far)`

**Complexity:** O(n) time, O(1) space.

---

## 3. Product of Array Except Self
**Given:** an array of integers (zeros and negatives allowed)
**Expects:** return an array where each element is the product of every element except itself, without division
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
**Given:** an array of integers (possibly all negative)
**Expects:** return the maximum sum of any contiguous subarray
**Pattern:** Dynamic programming, running sum reset

**Approach:**
1. `cur = max(x, cur + x)` — restart the subarray when the running sum becomes a liability.
2. `best = max(best, cur)`.

**Complexity:** O(n) time, O(1) space.

---

## 5. Merge Sorted Arrays (in-place, nums1 has trailing buffer)
**Given:** two sorted arrays; the first has a trailing zero-buffer sized for the second
**Expects:** merge them into the first array, sorted, in-place
**Pattern:** Three pointers, fill from the back

**Approach:**
1. Pointer `p = m+n-1` (write position), `i = m-1`, `j = n-1`.
2. Write the larger of `nums1[i]` and `nums2[j]` at `p`, move the corresponding pointer left.
3. Copy remaining `nums2` elements if any (`i` exhaustion is already in place).

**Why from the back:** avoids shifting elements when overwriting `nums1`.

**Complexity:** O(m+n) time, O(1) space.

---

## 6. Rotate Array (by k steps)
**Given:** an array and a rotation count k
**Expects:** rotate the array right by k positions in-place
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
**Given:** an array of integers
**Expects:** return true if any value appears more than once
**Pattern:** Hash set

**Approach:** Add each element to a set; a failed insertion means duplicate.

**Complexity:** O(n) time, O(n) space.

---

## 8. Find Missing Number (0..n)
**Given:** an array containing 0..n except one missing number
**Expects:** return the missing number
**Pattern:** XOR or sum formula

**Approach:** `missing = sum(0..n) - sum(array)` — or XOR all indices and values, the survivor is the missing number.

```
sum(0..n) = n*(n+1)/2
```

**Complexity:** O(n) time, O(1) space.

---

## 9. Find All Duplicates in Array (values in [1, n])
**Given:** an array of length n with values in [1, n], some appearing twice
**Expects:** return all values appearing twice in O(n) time, O(1) space
**Pattern:** Index marking (negation) — cycle-sort trick

**Approach:**
1. For each `x`, `idx = abs(x) - 1`.
2. If `nums[idx] < 0` → `x` is a duplicate. Else negate `nums[idx]`.

**Complexity:** O(n) time, O(1) space, no array mutation beyond sign flips.

---

## 10. First Missing Positive
**Given:** an unsorted integer array (negatives and zeros allowed)
**Expects:** return the smallest positive integer not present
**Pattern:** Cycle sort / in-place bucket placement

**Approach:**
1. Place each value `v` in `[1, n]` at index `v-1` by swapping (ignore `v<=0` and `v>n`).
2. Scan: first `i` where `nums[i] != i+1` → answer `i+1`; else `n+1`.

**Complexity:** O(n) time, O(1) space.

---

## 11. Majority Element (appears > n/2)
**Given:** an array where one element appears more than n/2 times
**Expects:** return that majority element in O(n) time, O(1) space
**Pattern:** Boyer-Moore voting

**Approach:**
1. `count=0`. If `count==0`, set `candidate=x`.
2. `count += 1 if x == candidate else -1`.
3. (Second pass to verify if majority is not guaranteed.)

**Complexity:** O(n) time, O(1) space.

---

## 12. Next Permutation
**Given:** an array of numbers
**Expects:** rearrange it in-place into the lexicographically next greater permutation (or smallest if none exists)
**Pattern:** Lexicographic successor

**Approach:**
1. Find pivot `i` from right where `a[i] < a[i+1]`.
2. Find smallest `j > i` with `a[j] > a[i]`, swap `a[i]`, `a[j]`.
3. Reverse `a[i+1:]`.

**Complexity:** O(n) time, O(1) space.

---

## 13. Spiral Matrix
**Given:** an m×n matrix
**Expects:** return the elements in clockwise spiral order
**Pattern:** Four boundary pointers

**Approach:**
1. Maintain `top, bottom, left, right`.
2. Traverse top row → right col → bottom row (reversed) → left col (reversed).
3. Shrink boundaries after each pass; stop when `top > bottom` or `left > right`.

**Complexity:** O(m·n) time, O(1) space (excluding output).

---

## 14. Rotate Image (90° clockwise, in-place)
**Given:** an n×n matrix
**Expects:** rotate it 90 degrees clockwise in-place
**Pattern:** Transpose + reverse rows

**Approach:**
1. Transpose: swap `m[i][j]` with `m[j][i]` for `j > i`.
2. Reverse each row.

**Complexity:** O(n²) time, O(1) space.

---

## 15. Set Matrix Zeroes
**Given:** an m×n matrix containing zeros
**Expects:** set every cell in a zero's row or column to zero, in-place
**Pattern:** In-place flags in first row/col

**Approach:**
1. Use `m[0][j]` / `m[i][0]` as markers (plus one extra flag for first row or column overlap).
2. Pass 1: mark first cell of any row/col containing a zero.
3. Pass 2: zero out rows/cols based on markers. Handle first row/col last.

**Complexity:** O(m·n) time, O(1) space.

---

## 16. Subarray Sum Equals K
**Given:** an array and a target k (values may be negative)
**Expects:** return the count of contiguous subarrays whose sum equals k
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
**Given:** an array containing only 0s, 1s and 2s
**Expects:** sort it in one pass with O(1) space
**Pattern:** Three-way partition — `#two-pointers`

**Approach:**
1. `lo` (next 0 slot), `mid` (scanner), `hi` (next 2 slot).
2. `0 → swap(lo, mid), lo++, mid++`; `1 → mid++`; `2 → swap(mid, hi), hi--`.

**Complexity:** O(n) time, O(1) space, single pass.

---

## 18. Trapping Rain Water
**Given:** an array of bar heights
**Expects:** return the total units of water trapped between bars
**Pattern:** Two-pointer bounded by min of max heights

**Approach:**
1. `l=0, r=n-1, leftMax=0, rightMax=0`.
2. If `height[l] < height[r]`: `leftMax = max(leftMax, height[l]); ans += leftMax - height[l]; l++` — mirror for right.

`water at i = min(max_left, max_right) - height[i]`

**Complexity:** O(n) time, O(1) space.

---

## 19. Gas Station (circular route)
**Given:** gas and cost arrays for a circular route
**Expects:** return the starting index where a full trip is possible, or -1
**Pattern:** Greedy — total surplus feasibility + running surplus restart

**Approach:**
1. If `sum(gas) < sum(cost)` → impossible.
2. Track running `surplus = gas[i] - cost[i]`; when it goes negative, reset start to `i+1` and surplus to 0.

**Complexity:** O(n) time, O(1) space.

---

## 20. Merge Intervals
**Given:** a list of intervals
**Expects:** return the merged list of all overlapping intervals
**Pattern:** Sort by start + sweep — `#intervals`

**Approach:**
1. Sort by start.
2. If `cur.start <= last.end` → `last.end = max(last.end, cur.end)`, else append.

**Complexity:** O(n log n) time, O(n) space for output.

---

## 21. Search in Rotated Sorted Array
**Given:** a sorted array rotated at an unknown pivot, and a target
**Expects:** return the target's index in O(log n), or -1
**Pattern:** Modified binary search — `#binary-search`

**Approach:**
1. `mid`; at least one of `[lo, mid]` / `[mid, hi]` is sorted.
2. If target in sorted half → search it; else search the other half.

**Complexity:** O(log n) time, O(1) space.

---

## 22. Longest Consecutive Sequence
**Given:** an unsorted array of integers
**Expects:** return the length of the longest run of consecutive integers, in O(n)
**Pattern:** Hash set of sequence starts

**Approach:**
1. Put all numbers in a set.
2. Only start counting from `x` if `x-1` **not** in set (i.e., `x` is a sequence head).
3. `while x+1 in set: count++`.

**Complexity:** O(n) time, O(n) space (each element visited once).

---

## 23. Find Duplicate Number (array with values in [1, n], exactly one repeat)
**Given:** an array of n+1 values in [1, n] with exactly one repeated value
**Expects:** return the duplicate in O(n) time, O(1) space, without mutating the array
**Pattern:** Floyd's cycle detection on index graph

**Approach:**
1. Treat `nums[i]` as "next node" from `i` — duplicate creates a cycle entry.
2. `slow = nums[slow]; fast = nums[nums[fast]]` until they meet.
3. Reset `slow = 0`; move both one step at a time; meeting point is the duplicate.

**Complexity:** O(n) time, O(1) space.
