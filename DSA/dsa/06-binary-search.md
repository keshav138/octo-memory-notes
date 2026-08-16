# Binary Search

Two families:
- **Index search** — find an element in a (partially) sorted structure.
- **Answer-space search** — binary search the answer itself when a monotone `check(x)` predicate exists.

Golden rules:
- Use `lo = 0, hi = n` (half-open) or `lo, hi = l, r` per variant — stay consistent.
- Integer mid: `mid = lo + (hi - lo) / 2` (C++) or `(lo + hi) // 2` (Python).
- If `check(mid)` is true, move `lo = mid + 1` (or `hi = mid`); pick the variant that avoids infinite loops.

---

## 1. Binary Search (classic)
**Given:** a sorted array and a target
**Expects:** return the target's index, or -1
**Pattern:** Index search in sorted array

**Approach:** Standard `while lo <= hi`; `mid = lo + (hi-lo)/2`; compare; move.

**Complexity:** O(log n) time, O(1) space.

---

## 2. First / Last Position of Target in Sorted Array (lower_bound / upper_bound)
**Given:** a sorted array with duplicates and a target
**Expects:** return [first, last] index of the target, or [-1, -1]
**Pattern:** Boundary search variants

```cpp
// C++ — use the library
lower_bound(v.begin(), v.end(), x)     // first index >= x
upper_bound(v.begin(), v.end(), x)     // first index > x
```
```python
# Python — bisect
bisect_left(a, x)     # first index >= x  (insertion point)
bisect_right(a, x)    # first index > x
```

**Approach (manual lower_bound):**
```python
lo, hi = 0, n
while lo < hi:
    mid = (lo + hi) // 2
    if a[mid] < x: lo = mid + 1
    else: hi = mid          # keep mid in range; converges to first >= x
return lo
```

**Complexity:** O(log n) time, O(1) space.

---

## 3. Search in Rotated Sorted Array
**Given:** a sorted array rotated at an unknown pivot, and a target
**Expects:** return the target's index in O(log n), or -1
**Pattern:** Check which half is sorted

**Approach:**
1. `mid`; one of `[lo, mid]` / `[mid, hi]` is sorted.
2. If target lies in sorted half → search it; else search the other half.

```python
if nums[lo] <= nums[mid]:                      # left half sorted
    if nums[lo] <= target < nums[mid]: hi = mid - 1
    else: lo = mid + 1
else:                                          # right half sorted
    if nums[mid] < target <= nums[hi]: lo = mid + 1
    else: hi = mid - 1
```

**Complexity:** O(log n) time, O(1) space.

---

## 4. Search in Rotated Sorted Array II (with duplicates)
**Given:** same rotated array but with duplicates, and a target
**Expects:** return true if the target exists
**Pattern:** Same, but skip duplicates when `lo`, `mid`, `hi` equal

**Approach:** When `a[lo] == a[mid] == a[hi]`, `lo++, hi--`; else proceed as above.

**Complexity:** O(log n) average, O(n) worst.

---

## 5. Find Minimum in Rotated Sorted Array
**Given:** a rotated sorted array with distinct values
**Expects:** return the minimum element
**Pattern:** Compare mid with right end

**Approach:** If `a[mid] > a[hi]` → min is in right half (`lo = mid + 1`); else `hi = mid`.

**Complexity:** O(log n) time, O(1) space.

---

## 6. Search a 2D Matrix (rows sorted, first of row > last of previous)
**Given:** an m×n matrix sorted row-major, and a target
**Expects:** return true if the target exists, in O(log mn)
**Pattern:** Flatten to 1D index

**Approach:** Treat as sorted array of `m*n`: `row = idx // n`, `col = idx % n`.

**Complexity:** O(log(mn)) time, O(1) space.

---

## 7. Search a 2D Matrix II (rows and cols sorted, not strictly serialized)
**Given:** a matrix with sorted rows and sorted columns, and a target
**Expects:** return true if the target exists, in O(m + n)
**Pattern:** Start from top-right corner — elimination

**Approach:**
1. Start `(0, n-1)`.
2. `a[r][c] > target → c--` (exclude column); `< target → r++` (exclude row); equal → found.

**Complexity:** O(m + n) time, O(1) space.

---

## 8. Find Peak Element
**Given:** an array in arbitrary order
**Expects:** return the index of any peak (element greater than both neighbors)
**Pattern:** Binary search on slope direction

**Approach:**
1. If `a[mid] < a[mid+1]` → a peak exists on the right (`lo = mid + 1`).
2. Else → peak on the left or at mid (`hi = mid`).

**Why it works:** climbing the steeper neighbor always terminates at a peak; no need to check both sides.

**Complexity:** O(log n) time, O(1) space.

---

## 9. Koko Eating Bananas (minimum rate)
**Given:** banana pile sizes and an hour limit h
**Expects:** return the minimum eating speed that finishes all piles in h hours
**Pattern:** Answer-space binary search with monotone predicate

**Approach:**
1. Search `speed` in `[1, max(piles)]`.
2. `check(k) = sum(ceil(p / k) for p in piles) <= h` — monotone (larger speed always feasible).

```
ceil(p / k) = (p + k - 1) // k
```

**Complexity:** O(n log max) time, O(1) space.

---

## 10. Capacity To Ship Packages Within D Days
**Given:** package weights and a day limit D
**Expects:** return the minimum ship capacity that ships everything in D days
**Pattern:** Answer-space binary search

**Approach:**
1. `lo = max(weights)` (must fit the heaviest), `hi = sum(weights)`.
2. `check(cap)`: greedily fill days; count ≤ D.

**Complexity:** O(n log sum) time, O(1) space.

---

## 11. Split Array Largest Sum (minimize max subarray sum with m splits)
**Given:** an array and a split count m
**Expects:** return the minimized largest subarray sum over m contiguous splits
**Pattern:** Answer-space binary search

**Approach:** Same as shipping: `check(maxSum)`: can we split into ≤ m subarrays each with sum ≤ maxSum?

**Complexity:** O(n log sum) time, O(1) space.

---

## 12. Find K-th Smallest Pair Distance
**Given:** an array and an integer k
**Expects:** return the k-th smallest absolute difference among all pairs
**Pattern:** Answer-space BS + counting with two pointers

**Approach:**
1. Sort. Search distance `d` in `[0, max-min]`.
2. `count(d)` = number of pairs with distance ≤ d — O(n) via sliding two pointers.
3. Find smallest `d` with `count(d) >= k`.

**Complexity:** O(n log n + n log maxDist) time.

---

## 13. Median of Two Sorted Arrays
**Given:** two sorted arrays
**Expects:** return the median of their merged content, without merging, in O(log)
**Pattern:** Binary search on the smaller array partition

**Approach:**
1. Partition both arrays such that left half size = right half.
2. Find `i` in smaller array with `leftA_max <= rightB_min` and `leftB_max <= rightA_min`.
3. Median from the boundary elements.

```
partition: i + j = (m + n + 1) // 2
```

**Complexity:** O(log(min(m,n))) time, O(1) space.

---

## 14. Find the Smallest Divisor Given a Threshold
**Given:** an array and a threshold
**Expects:** return the smallest divisor such that the sum of ceilings is ≤ threshold
**Pattern:** Answer-space BS

**Approach:** Search divisor; `sum(ceil(n/d)) <= threshold` is monotone.

**Complexity:** O(n log max) time.

---

## 15. K-th Missing Positive Number
**Given:** a strictly increasing array and an integer k
**Expects:** return the k-th positive integer missing from the array
**Pattern:** BS on index arithmetic

**Approach:** `missing up to arr[i] = arr[i] - (i + 1)`. Find first `i` where this ≥ k; answer = `i + k`.

**Complexity:** O(log n) time, O(1) space.

---

## 16. Find First and Last Position of Element (search range)
**Given:** a sorted array and a target
**Expects:** return [first, last] index via two boundary searches
**Pattern:** Two boundary searches

**Approach:** `lower_bound(x)` for first; `upper_bound(x) - 1` for last.

**Complexity:** O(log n) time.

---

## 17. H-Index II (sorted citations)
**Given:** an already-sorted citations array
**Expects:** return the h-index
**Pattern:** BS on monotone count

**Approach:** Find first `i` where `citations[i] >= n - i`; answer `n - i`.

**Complexity:** O(log n) time.

---

## 18. Sqrt(x) (integer square root)
**Given:** a non-negative integer x
**Expects:** return the integer square root of x (truncated)
**Pattern:** Answer-space BS

**Approach:** Search `mid` in `[0, x]`; `mid*mid <= x` → move right. Use `long long` in C++ to avoid overflow.

**Complexity:** O(log x) time.

---

## 19. Single Element in a Sorted Array (every other appears twice)
**Given:** a sorted array where every element appears twice except one
**Expects:** return the single element in O(log n)
**Pattern:** BS on parity of index

**Approach:** For pairs `(even, odd)`, if `mid` is even and `a[mid] == a[mid+1]`, single is on the right; else left.

```python
if mid % 2 == 1: mid -= 1        # normalize to pair start
if a[mid] == a[mid+1]: lo = mid + 2
else: hi = mid
```

**Complexity:** O(log n) time, O(1) space.

---

## 20. Time-Based Key-Value Store
**Given:** set(key, timestamp, value) and get(key, timestamp)
**Expects:** return the value stored at the latest timestamp ≤ the query timestamp
**Pattern:** BS on sorted timestamps per key

**Approach:** `bisect_right(timestamps, t) - 1` → last value at or before `t`.

**Complexity:** O(log n) per get.

---

## 21. Random Pick with Weight
**Given:** an array of positive weights
**Expects:** implement pickIndex() with probability proportional to weight
**Pattern:** Prefix sums + `bisect_left` on random point

**Approach:** `r = rand(1..total)`; index = `bisect_left(prefix, r)`.

**Complexity:** O(log n) per pick.

---

## 22. Minimum Number of Days to Make m Bouquets
**Given:** a bloom-day array, m bouquets needed, k adjacent flowers each
**Expects:** return the minimum day on which m bouquets can be made
**Pattern:** Answer-space BS

**Approach:** `check(day)`: can we form `m` bouquets of `k` adjacent bloomed flowers by `day`? — greedy scan, monotone in `day`.

**Complexity:** O(n log max) time.

---

## 23. Search Insert Position
**Given:** a sorted array and a target
**Expects:** return the index where the target is or should be inserted
**Pattern:** `lower_bound`

**Approach:** First index with `a[i] >= target`.

**Complexity:** O(log n) time.
