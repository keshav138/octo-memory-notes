# Two Pointers

Two pointers shine on **sorted arrays** (converge from ends) and **in-place rewriting**
(read/write pointers). If a problem asks for pairs with a sum property, think here first.

---

## 1. Two Sum II — Sorted Input
**Given:** a 1-indexed sorted array and a target
**Expects:** return the two indices whose values sum to target
**Pattern:** Opposite-end pointers on sorted array

**Approach:**
1. `l=0, r=n-1`.
2. `s = a[l] + a[r]`; if `s == target` return; `s < target → l++`; `s > target → r--`.

**Complexity:** O(n) time, O(1) space.

---

## 2. 3Sum
**Given:** an unsorted array
**Expects:** return all unique triplets that sum to zero
**Pattern:** Sort + fix one element + two-pointer pair search

**Approach:**
1. Sort. For each `i`, skip duplicate `i` values.
2. Two-pointer on `[i+1, n-1]` for `-(nums[i])`.
3. On match: add triplet, then skip duplicates for both `l` and `r`.

**Complexity:** O(n²) time, O(1) space (excluding output).

---

## 3. 3Sum Closest
**Given:** an array and a target
**Expects:** return the triplet sum closest to the target
**Pattern:** Same as 3Sum but track minimum absolute difference

**Approach:** Maintain `best`; update when `|sum - target|` improves; move pointers by sum comparison.

**Complexity:** O(n²) time, O(1) space.

---

## 4. 4Sum
**Given:** an array and a target
**Expects:** return all unique quadruplets that sum to target
**Pattern:** Sort + fix two + two-pointer (or generalize k-Sum recursively)

**Approach:** For each pair `(i, j)`, two-pointer `[j+1, n-1]` for the remainder. Skip duplicates at all levels.

**Complexity:** O(n³) time, O(1) space.

---

## 5. Container With Most Water
**Given:** an array of line heights
**Expects:** return the maximum water area between any two lines
**Pattern:** Greedy opposite-end pointers

**Approach:**
1. `area = min(h[l], h[r]) * (r - l)`; track max.
2. Move the pointer with the **shorter** height inward.

**Why it works:** the shorter side caps the area, so it can't improve unless it changes.

**Complexity:** O(n) time, O(1) space.

---

## 6. Trapping Rain Water
**Given:** an array of bar heights
**Expects:** return the total units of water trapped between bars
**Pattern:** Two pointers with running left/right max

**Approach:**
1. If `h[l] < h[r]`: water at `l` is determined by `leftMax` → `ans += leftMax - h[l]`, `l++`.
2. Else symmetric for `r`.

```
water[i] = min(max_left_of_i, max_right_of_i) - h[i]
```

**Complexity:** O(n) time, O(1) space.

---

## 7. Sort Colors (Dutch National Flag)
**Given:** an array containing only 0s, 1s and 2s
**Expects:** sort it in one pass with O(1) space
**Pattern:** Three pointers: `lo` (0s), `mid` (scan), `hi` (2s)

**Approach:**
- `a[mid] == 0` → swap `(lo, mid)`, `lo++, mid++`
- `a[mid] == 1` → `mid++`
- `a[mid] == 2` → swap `(mid, hi)`, `hi--` (don't advance `mid` — new element unchecked)

**Complexity:** O(n) time, single pass, O(1) space.

---

## 8. Remove Duplicates from Sorted Array (in-place)
**Given:** a sorted array with duplicates
**Expects:** deduplicate it in-place and return the new length
**Pattern:** Fast/slow read-write pointers

**Approach:** `slow` = write position; `fast` scans. If `a[fast] != a[slow-1]`, write and advance.

```python
slow = 1
for fast in range(1, n):
    if nums[fast] != nums[slow - 1]:
        nums[slow] = nums[fast]; slow += 1
```

**Complexity:** O(n) time, O(1) space.

---

## 9. Remove Element (in-place, remove all == val)
**Given:** an array and a value
**Expects:** remove all occurrences in-place and return the new length
**Pattern:** Write-pointer filter

**Approach:** `slow` writes only `nums[fast] != val`.

**Complexity:** O(n) time, O(1) space.

---

## 10. Move Zeroes (to end, preserving order)
**Given:** an array
**Expects:** move all zeros to the end preserving relative order of the rest
**Pattern:** Write-pointer + fill zeros

**Approach:** `slow` writes all non-zeros in order; then fill `[slow, n)` with zeros.

**Complexity:** O(n) time, O(1) space.

---

## 11. Valid Palindrome
**Given:** a string with non-alphanumeric characters and mixed case
**Expects:** return true if it is a palindrome ignoring non-alphanumerics and case
**Pattern:** Opposite-end pointers with char filtering

**Approach:** Skip non-alphanumeric; compare lowercased; mismatch → false.

**Complexity:** O(n) time, O(1) space.

---

## 12. Merge Sorted Arrays (two sorted inputs → one)
**Given:** two sorted arrays
**Expects:** merge them into one sorted result (in-place into the first if it has a buffer)
**Pattern:** Two read pointers + one write pointer

**Approach:** Compare heads, append smaller. For the in-place variant (nums1 has buffer), fill **from the back** to avoid shifting.

**Complexity:** O(n+m) time, O(1) extra space.

---

## 13. Intersection of Two Sorted Arrays
**Given:** two sorted arrays
**Expects:** return their intersection
**Pattern:** Advance the smaller pointer

**Approach:** Two pointers; on match record and advance both; else advance the smaller.

**Complexity:** O(n+m) time, O(1) space.

---

## 14. Squares of a Sorted Array
**Given:** a sorted array that may contain negatives
**Expects:** return a sorted array of its squares
**Pattern:** Opposite-end pointers (largest squares are at the ends)

**Approach:** Compare `|a[l]|` vs `|a[r]|`; place the larger square at the **end** of result; move inward.

**Complexity:** O(n) time, O(n) space.

---

## 15. Longest Palindromic Substring
**Given:** a string
**Expects:** return the longest substring that reads the same both ways
**Pattern:** Expand-around-center (two pointers per center)

**Approach:** For each of `2n-1` centers, expand `l--, r++` while `s[l]==s[r]`; track best.

**Complexity:** O(n²) time, O(1) space.

---

## 16. Find the Duplicate Number
**Given:** an array of n+1 values in [1, n] with exactly one repeat
**Expects:** return the duplicate in O(n) time, O(1) space
**Pattern:** Floyd slow/fast cycle detection (pointer-as-graph-edge)

**Approach:** `slow = nums[slow]`, `fast = nums[nums[fast]]`; after meeting, reset `slow=0` and step both by one — meeting point is the duplicate.

**Complexity:** O(n) time, O(1) space.

---

## 17. Linked List Cycle / Cycle Entry
**Given:** a linked list
**Expects:** detect whether it has a cycle and return the entry node if it does
**Pattern:** Floyd's tortoise and hare

**Approach:**
1. Detect: `slow = slow->next`, `fast = fast->next->next`; meet ⇒ cycle.
2. Entry: reset `slow = head`; move both one step; next meeting is the cycle start.

**Complexity:** O(n) time, O(1) space.

---

## 18. Middle of Linked List
**Given:** a linked list
**Expects:** return the middle node
**Pattern:** Slow/fast — fast moves twice as fast

**Approach:** `while fast and fast.next: slow = slow.next; fast = fast.next.next`. Return `slow`.

**Complexity:** O(n) time, O(1) space.

---

## 19. Remove Nth Node From End of List
**Given:** a linked list head and an integer n
**Expects:** return the list with the n-th node from the end removed
**Pattern:** Two pointers with fixed gap

**Approach:** Advance `fast` by `n`; then move `slow` and `fast` together until `fast` hits the end; `slow` sits just before the target. Delete `slow.next`.

**Complexity:** O(n) time, O(1) space.

---

## 20. Partition List (x) — nodes < x before nodes ≥ x
**Given:** a linked list and a value x
**Expects:** reorder so nodes < x come before nodes ≥ x, preserving relative order
**Pattern:** Two-chain technique

**Approach:** Build two lists (`less`, `greater`) by moving nodes; splice them together.

**Complexity:** O(n) time, O(1) space.

---

## 21. Happy Number
**Given:** an integer
**Expects:** return true if repeatedly summing squared digits reaches 1
**Pattern:** Slow/fast on digit-square-sum sequence

**Approach:** Compute `f(n) = sum of squares of digits`; run slow/fast until they meet; happy iff they meet at 1.

**Complexity:** O(log n) per step, few steps in practice.

---

## 22. Compare Version Numbers
**Given:** two version strings
**Expects:** return -1, 0 or 1 comparing them, ignoring leading zeros
**Pattern:** Two pointers over dot-separated segments

**Approach:** Parse both versions segment by segment, pad missing segments with 0, compare.

**Complexity:** O(n+m) time, O(1) space.
