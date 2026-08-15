# Sliding Window

Two families:
- **Fixed size** — window of length `k`, slide and update incrementally.
- **Variable size** — expand `r`, shrink `l` while a condition is violated.

Template (variable):

```python
l = 0
for r in range(n):
    add(nums[r])                       # expand
    while not valid():                 # shrink while invalid
        remove(nums[l]); l += 1
    update_answer(l, r)
```

---

## 1. Maximum Sum Subarray of Size K
**Pattern:** Fixed window, running sum

**Approach:** Sum of first `k`; slide: `sum += a[r] - a[l]`; track max.

**Complexity:** O(n) time, O(1) space.

---

## 2. Longest Substring Without Repeating Characters
**Pattern:** Variable window, last-seen map

**Approach:** On repeat char with `last >= l`: jump `l = last + 1`. Answer = `r - l + 1`.

**Complexity:** O(n) time, O(A) space.

---

## 3. Longest Repeating Character Replacement
**Pattern:** Variable window with "replaceable count" condition

**Approach:**
1. Track `maxFreq` among chars in window.
2. Invalid when `window_len - maxFreq > k` → shrink `l`.
3. `ans = max(ans, r - l + 1)`.

```
valid ⇔ (r - l + 1) - count(most frequent char) <= k
```

**Complexity:** O(n) time, O(1) space.

---

## 4. Minimum Window Substring
**Pattern:** Variable window with deficit counter

**Approach:**
1. `need = Counter(t)`, `have = 0` (number of satisfied chars).
2. Expand `r`; when adding `s[r]` makes its count hit need → `have++`.
3. While `have == len(need)`: update min window, shrink `l` (decrement counts, adjust `have`).

**Complexity:** O(n) time, O(A) space.

---

## 5. Permutation in String
**Pattern:** Fixed window + exact frequency match

**Approach:** Window of `len(s1)`; maintain 26-char counts of window vs `s1`; compare each slide (or maintain `matches` counter).

**Complexity:** O(n) time, O(1) space.

---

## 6. Find All Anagrams in a String
**Pattern:** Same as Permutation in String, collect all valid starts

**Approach:** Slide fixed window; record `l` whenever counts match.

**Complexity:** O(n) time, O(1) space.

---

## 7. Longest Subarray with Sum ≤ K (positive numbers)
**Pattern:** Variable window (shrink while sum exceeds k)

**Approach:** Expand `r`, add; while `sum > k`, subtract `a[l++]`; answer = `r - l + 1`.

**Complexity:** O(n) time, O(1) space.

---

## 8. Minimum Size Subarray Sum (sum ≥ target)
**Pattern:** Variable window (shrink while still valid)

**Approach:** Expand `r`; while `sum >= target`, update min length, `sum -= a[l++]`.

**Complexity:** O(n) time, O(1) space.

---

## 9. Subarrays with Product Less Than K
**Pattern:** Variable window with product

**Approach:** Expand `r`; while `prod >= k`, divide out `a[l++]`. **Every valid window adds `r - l + 1` new subarrays** (all ending at `r`).

```
count += r - l + 1    # subarrays ending at r with product < k
```

**Complexity:** O(n) time, O(1) space.

---

## 10. Maximum Consecutive Ones III (flip at most k zeros)
**Pattern:** Variable window counting zeros

**Approach:** Expand `r`; count zeros; while `zeros > k`, shrink `l` (decrement when `a[l]` was 0). Answer = `r - l + 1`.

**Complexity:** O(n) time, O(1) space.

---

## 11. Fruit Into Baskets (longest subarray with ≤ 2 distinct values)
**Pattern:** Variable window with frequency map

**Approach:** Expand `r`, `freq[a[r]]++`; while `len(freq) > 2`, drop `a[l]` (delete zero-count keys). Answer = window size.

**Complexity:** O(n) time, O(1) space (map has ≤ 3 keys).

---

## 12. Longest Substring with At Most K Distinct Characters
**Pattern:** Generalization of Fruit Into Baskets

**Approach:** Same window, condition `len(freq) > k`.

**Complexity:** O(n) time, O(k) space.

---

## 13. Sliding Window Maximum
**Pattern:** Monotonic **deque** of indices — `#deque`

**Approach:**
1. Maintain deque of indices whose values are decreasing.
2. Before push: pop from back while `a[back] <= a[i]` (they can never be the max).
3. Pop front if index outside window. Front is the max.

```python
dq = collections.deque()
for i, x in enumerate(nums):
    while dq and nums[dq[-1]] <= x: dq.pop()
    dq.append(i)
    if dq[0] <= i - k: dq.popleft()
    if i >= k - 1: res.append(nums[dq[0]])
```

**Complexity:** O(n) time, O(k) space.

---

## 14. Substring with Concatenation of All Words (all words same length)
**Pattern:** Sliding window over word-length chunks

**Approach:** Window of `len(words) * w`; step `w` chars at a time; count word occurrences; slide by one word. (Try all `w` starting offsets.)

**Complexity:** O(n · w) time, O(m) space (m = word count).

---

## 15. Count of Nice Subarrays (exactly k odd numbers)
**Pattern:** Exactly-k via prefix count of odds: `atMost(k) - atMost(k-1)`

**Approach:** Variable window counting odds, implement `atMost(k)`; answer = difference.

```
exactly(k) = atMost(k) - atMost(k-1)
```

**Complexity:** O(n) time, O(1) space.

---

## 16. Binary Subarrays With Sum (exactly goal)
**Pattern:** Same exactly-k trick with prefix sums of 1s

**Approach:** `atMost(goal) - atMost(goal-1)` on the window sum.

**Complexity:** O(n) time, O(1) space.

---

## 17. Maximum Points You Can Obtain from Cards (pick k from ends)
**Pattern:** Sliding window over the **middle** (n−k cards left unpicked)

**Approach:** Total − min sum of any contiguous `n-k` window.

**Complexity:** O(n) time, O(1) space.

---

## 18. Longest Turbulent Subarray (alternating > <)
**Pattern:** Two-state sliding window / DP on sign changes

**Approach:** Track current length; if sign alternates, extend; else reset to 2 (if unequal) or 1.

**Complexity:** O(n) time, O(1) space.

---

## 19. Repeated DNA Sequences (fixed 10-char window)
**Pattern:** Fixed window + rolling hash

**Approach:** Rolling hash over 4-letter alphabet; duplicates → answer.

**Complexity:** O(n) time, O(n) space.

---

## 20. Sliding Window Max Consecutive Answers (T/F string, flip at most k)

**Pattern:** Variable window counting minority char

**Approach:** Window valid while `min(countT, countF) <= k`; shrink when violated; answer = max window.

**Complexity:** O(n) time, O(1) space.

---

## 21. Grumpy Bookstore Owner (max satisfied with X-minute secret technique)
**Pattern:** Fixed window over "gain" array

**Approach:** Build `gain[i] = customers[i] if grumpy[i] else 0`; max sum of a fixed `X`-window of `gain` added to base satisfaction.

**Complexity:** O(n) time, O(1) space.

---

## 22. Maximum Average Subarray I
**Pattern:** Fixed window sum / k

**Approach:** Running window sum; track max; divide by `k`.

**Complexity:** O(n) time, O(1) space.
