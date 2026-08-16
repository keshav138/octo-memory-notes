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
**Given:** an array and a window size k
**Expects:** return the maximum sum of any contiguous k-length subarray
**Pattern:** Fixed window, running sum

**Approach:** Sum of first `k`; slide: `sum += a[r] - a[l]`; track max.

**Complexity:** O(n) time, O(1) space.

---

## 2. Longest Substring Without Repeating Characters
**Given:** a string
**Expects:** return the length of the longest substring with all unique characters
**Pattern:** Variable window, last-seen map

**Approach:** On repeat char with `last >= l`: jump `l = last + 1`. Answer = `r - l + 1`.

**Complexity:** O(n) time, O(A) space.

---

## 3. Longest Repeating Character Replacement
**Given:** a string s and a max replacement count k
**Expects:** return the longest substring obtainable after replacing at most k characters
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
**Given:** strings s and t
**Expects:** return the smallest substring of s containing all characters of t
**Pattern:** Variable window with deficit counter

**Approach:**
1. `need = Counter(t)`, `have = 0` (number of satisfied chars).
2. Expand `r`; when adding `s[r]` makes its count hit need → `have++`.
3. While `have == len(need)`: update min window, shrink `l` (decrement counts, adjust `have`).

**Complexity:** O(n) time, O(A) space.

---

## 5. Permutation in String
**Given:** strings s1 and s2
**Expects:** return true if s2 contains any permutation of s1 as a substring
**Pattern:** Fixed window + exact frequency match

**Approach:** Window of `len(s1)`; maintain 26-char counts of window vs `s1`; compare each slide (or maintain `matches` counter).

**Complexity:** O(n) time, O(1) space.

---

## 6. Find All Anagrams in a String
**Given:** strings s and p
**Expects:** return all start indices in s where a permutation of p begins
**Pattern:** Same as Permutation in String, collect all valid starts

**Approach:** Slide fixed window; record `l` whenever counts match.

**Complexity:** O(n) time, O(1) space.

---

## 7. Longest Subarray with Sum ≤ K (positive numbers)
**Given:** an array of positive numbers and a bound k
**Expects:** return the longest subarray with sum ≤ k
**Pattern:** Variable window (shrink while sum exceeds k)

**Approach:** Expand `r`, add; while `sum > k`, subtract `a[l++]`; answer = `r - l + 1`.

**Complexity:** O(n) time, O(1) space.

---

## 8. Minimum Size Subarray Sum (sum ≥ target)
**Given:** an array of positive numbers and a target
**Expects:** return the smallest subarray with sum ≥ target
**Pattern:** Variable window (shrink while still valid)

**Approach:** Expand `r`; while `sum >= target`, update min length, `sum -= a[l++]`.

**Complexity:** O(n) time, O(1) space.

---

## 9. Subarrays with Product Less Than K
**Given:** an array of positive numbers and a bound k
**Expects:** return the count of subarrays with product < k
**Pattern:** Variable window with product

**Approach:** Expand `r`; while `prod >= k`, divide out `a[l++]`. **Every valid window adds `r - l + 1` new subarrays** (all ending at `r`).

```
count += r - l + 1    # subarrays ending at r with product < k
```

**Complexity:** O(n) time, O(1) space.

---

## 10. Maximum Consecutive Ones III (flip at most k zeros)
**Given:** a binary array and a flip budget k
**Expects:** return the longest run of 1s after flipping at most k zeros
**Pattern:** Variable window counting zeros

**Approach:** Expand `r`; count zeros; while `zeros > k`, shrink `l` (decrement when `a[l]` was 0). Answer = `r - l + 1`.

**Complexity:** O(n) time, O(1) space.

---

## 11. Fruit Into Baskets (longest subarray with ≤ 2 distinct values)
**Given:** an array of fruit types
**Expects:** return the longest subarray with at most 2 distinct types
**Pattern:** Variable window with frequency map

**Approach:** Expand `r`, `freq[a[r]]++`; while `len(freq) > 2`, drop `a[l]` (delete zero-count keys). Answer = window size.

**Complexity:** O(n) time, O(1) space (map has ≤ 3 keys).

---

## 12. Longest Substring with At Most K Distinct Characters
**Given:** a string and an integer k
**Expects:** return the longest substring with at most k distinct characters
**Pattern:** Generalization of Fruit Into Baskets

**Approach:** Same window, condition `len(freq) > k`.

**Complexity:** O(n) time, O(k) space.

---

## 13. Sliding Window Maximum
**Given:** an array and a window size k
**Expects:** return the maximum of every k-sized window
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
**Given:** a string s and a list of equal-length words
**Expects:** return all start indices where the words concatenate as a substring (any order)
**Pattern:** Sliding window over word-length chunks

**Approach:** Window of `len(words) * w`; step `w` chars at a time; count word occurrences; slide by one word. (Try all `w` starting offsets.)

**Complexity:** O(n · w) time, O(m) space (m = word count).

---

## 15. Count of Nice Subarrays (exactly k odd numbers)
**Given:** an array and an integer k
**Expects:** return the count of subarrays with exactly k odd numbers
**Pattern:** Exactly-k via prefix count of odds: `atMost(k) - atMost(k-1)`

**Approach:** Variable window counting odds, implement `atMost(k)`; answer = difference.

```
exactly(k) = atMost(k) - atMost(k-1)
```

**Complexity:** O(n) time, O(1) space.

---

## 16. Binary Subarrays With Sum (exactly goal)
**Given:** a binary array and a goal sum
**Expects:** return the count of subarrays whose sum equals the goal
**Pattern:** Same exactly-k trick with prefix sums of 1s

**Approach:** `atMost(goal) - atMost(goal-1)` on the window sum.

**Complexity:** O(n) time, O(1) space.

---

## 17. Maximum Points You Can Obtain from Cards (pick k from ends)
**Given:** an array of card points and a pick count k
**Expects:** return the max score picking k cards from the ends
**Pattern:** Sliding window over the **middle** (n−k cards left unpicked)

**Approach:** Total − min sum of any contiguous `n-k` window.

**Complexity:** O(n) time, O(1) space.

---

## 18. Longest Turbulent Subarray (alternating > <)
**Given:** an array
**Expects:** return the longest subarray whose comparisons alternate > < > < ...
**Pattern:** Two-state sliding window / DP on sign changes

**Approach:** Track current length; if sign alternates, extend; else reset to 2 (if unequal) or 1.

**Complexity:** O(n) time, O(1) space.

---

## 19. Repeated DNA Sequences (fixed 10-char window)
**Given:** a DNA string over A/C/G/T
**Expects:** return all 10-character substrings that appear more than once
**Pattern:** Fixed window + rolling hash

**Approach:** Rolling hash over 4-letter alphabet; duplicates → answer.

**Complexity:** O(n) time, O(n) space.

---

## 20. Sliding Window Max Consecutive Answers (T/F string, flip at most k)
**Given:** a string of T/F answers and a flip budget k
**Expects:** return the longest run of identical answers after at most k flips

**Pattern:** Variable window counting minority char

**Approach:** Window valid while `min(countT, countF) <= k`; shrink when violated; answer = max window.

**Complexity:** O(n) time, O(1) space.

---

## 21. Grumpy Bookstore Owner (max satisfied with X-minute secret technique)
**Given:** customer counts, a grumpy flag per minute, and a window X
**Expects:** return the max satisfied customers using the X-minute non-grumpy trick
**Pattern:** Fixed window over "gain" array

**Approach:** Build `gain[i] = customers[i] if grumpy[i] else 0`; max sum of a fixed `X`-window of `gain` added to base satisfaction.

**Complexity:** O(n) time, O(1) space.

---

## 22. Maximum Average Subarray I
**Given:** an array and a window size k
**Expects:** return the maximum average of any k-length subarray
**Pattern:** Fixed window sum / k

**Approach:** Running window sum; track max; divide by `k`.

**Complexity:** O(n) time, O(1) space.
