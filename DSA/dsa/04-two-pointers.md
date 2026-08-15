# Two Pointers

Two pointers shine on **sorted arrays** (converge from ends) and **in-place rewriting**
(read/write pointers). If a problem asks for pairs with a sum property, think here first.

---

## 1. Two Sum II — Sorted Input
**Pattern:** Opposite-end pointers on sorted array

**Approach:**
1. `l=0, r=n-1`.
2. `s = a[l] + a[r]`; if `s == target` return; `s < target → l++`; `s > target → r--`.

**Complexity:** O(n) time, O(1) space.

---

## 2. 3Sum
**Pattern:** Sort + fix one element + two-pointer pair search

**Approach:**
1. Sort. For each `i`, skip duplicate `i` values.
2. Two-pointer on `[i+1, n-1]` for `-(nums[i])`.
3. On match: add triplet, then skip duplicates for both `l` and `r`.

**Complexity:** O(n²) time, O(1) space (excluding output).

---

## 3. 3Sum Closest
**Pattern:** Same as 3Sum but track minimum absolute difference

**Approach:** Maintain `best`; update when `|sum - target|` improves; move pointers by sum comparison.

**Complexity:** O(n²) time, O(1) space.

---

## 4. 4Sum
**Pattern:** Sort + fix two + two-pointer (or generalize k-Sum recursively)

**Approach:** For each pair `(i, j)`, two-pointer `[j+1, n-1]` for the remainder. Skip duplicates at all levels.

**Complexity:** O(n³) time, O(1) space.

---

## 5. Container With Most Water
**Pattern:** Greedy opposite-end pointers

**Approach:**
1. `area = min(h[l], h[r]) * (r - l)`; track max.
2. Move the pointer with the **shorter** height inward.

**Why it works:** the shorter side caps the area, so it can't improve unless it changes.

**Complexity:** O(n) time, O(1) space.

---

## 6. Trapping Rain Water
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
**Pattern:** Three pointers: `lo` (0s), `mid` (scan), `hi` (2s)

**Approach:**
- `a[mid] == 0` → swap `(lo, mid)`, `lo++, mid++`
- `a[mid] == 1` → `mid++`
- `a[mid] == 2` → swap `(mid, hi)`, `hi--` (don't advance `mid` — new element unchecked)

**Complexity:** O(n) time, single pass, O(1) space.

---

## 8. Remove Duplicates from Sorted Array (in-place)
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
**Pattern:** Write-pointer filter

**Approach:** `slow` writes only `nums[fast] != val`.

**Complexity:** O(n) time, O(1) space.

---

## 10. Move Zeroes (to end, preserving order)
**Pattern:** Write-pointer + fill zeros

**Approach:** `slow` writes all non-zeros in order; then fill `[slow, n)` with zeros.

**Complexity:** O(n) time, O(1) space.

---

## 11. Valid Palindrome
**Pattern:** Opposite-end pointers with char filtering

**Approach:** Skip non-alphanumeric; compare lowercased; mismatch → false.

**Complexity:** O(n) time, O(1) space.

---

## 12. Merge Sorted Arrays (two sorted inputs → one)
**Pattern:** Two read pointers + one write pointer

**Approach:** Compare heads, append smaller. For the in-place variant (nums1 has buffer), fill **from the back** to avoid shifting.

**Complexity:** O(n+m) time, O(1) extra space.

---

## 13. Intersection of Two Sorted Arrays
**Pattern:** Advance the smaller pointer

**Approach:** Two pointers; on match record and advance both; else advance the smaller.

**Complexity:** O(n+m) time, O(1) space.

---

## 14. Squares of a Sorted Array
**Pattern:** Opposite-end pointers (largest squares are at the ends)

**Approach:** Compare `|a[l]|` vs `|a[r]|`; place the larger square at the **end** of result; move inward.

**Complexity:** O(n) time, O(n) space.

---

## 15. Longest Palindromic Substring
**Pattern:** Expand-around-center (two pointers per center)

**Approach:** For each of `2n-1` centers, expand `l--, r++` while `s[l]==s[r]`; track best.

**Complexity:** O(n²) time, O(1) space.

---

## 16. Find the Duplicate Number
**Pattern:** Floyd slow/fast cycle detection (pointer-as-graph-edge)

**Approach:** `slow = nums[slow]`, `fast = nums[nums[fast]]`; after meeting, reset `slow=0` and step both by one — meeting point is the duplicate.

**Complexity:** O(n) time, O(1) space.

---

## 17. Linked List Cycle / Cycle Entry
**Pattern:** Floyd's tortoise and hare

**Approach:**
1. Detect: `slow = slow->next`, `fast = fast->next->next`; meet ⇒ cycle.
2. Entry: reset `slow = head`; move both one step; next meeting is the cycle start.

**Complexity:** O(n) time, O(1) space.

---

## 18. Middle of Linked List
**Pattern:** Slow/fast — fast moves twice as fast

**Approach:** `while fast and fast.next: slow = slow.next; fast = fast.next.next`. Return `slow`.

**Complexity:** O(n) time, O(1) space.

---

## 19. Remove Nth Node From End of List
**Pattern:** Two pointers with fixed gap

**Approach:** Advance `fast` by `n`; then move `slow` and `fast` together until `fast` hits the end; `slow` sits just before the target. Delete `slow.next`.

**Complexity:** O(n) time, O(1) space.

---

## 20. Partition List (x) — nodes < x before nodes ≥ x
**Pattern:** Two-chain technique

**Approach:** Build two lists (`less`, `greater`) by moving nodes; splice them together.

**Complexity:** O(n) time, O(1) space.

---

## 21. Happy Number
**Pattern:** Slow/fast on digit-square-sum sequence

**Approach:** Compute `f(n) = sum of squares of digits`; run slow/fast until they meet; happy iff they meet at 1.

**Complexity:** O(log n) per step, few steps in practice.

---

## 22. Compare Version Numbers
**Pattern:** Two pointers over dot-separated segments

**Approach:** Parse both versions segment by segment, pad missing segments with 0, compare.

**Complexity:** O(n+m) time, O(1) space.
