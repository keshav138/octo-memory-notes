# Strings

Most string problems reduce to arrays + one extra idea: hashing, two pointers, sliding window,
or palindrome structure. Language differences (immutable strings in Python) matter for in-place ops.

---

## 1. Valid Palindrome (with non-alphanumeric ignored)
**Pattern:** Two pointers + char filtering

**Approach:**
1. `l=0, r=n-1`; skip non-alphanumeric via `isalnum()` / `isalnum()` equivalent.
2. Compare lowercased chars; mismatch → false.

```cpp
// C++
isalnum(c) && tolower(c)
```
```python
# Python
ch.isalnum()  and  ch.lower()
```

**Complexity:** O(n) time, O(1) space.

---

## 2. Valid Anagram
**Pattern:** Frequency count

**Approach:** Count chars in `s`, decrement for `t`; all counts must end at zero.
(For Unicode or large alphabets, use a hash map; for ASCII, `int[26]`.)

**Complexity:** O(n) time, O(1) space (fixed 26-size table).

---

## 3. Group Anagrams
**Pattern:** Canonical key + hash map — `#hashing`

**Approach:**
1. Key = sorted string, or a 26-length frequency tuple.
2. `groups[key].append(word)`.

```python
key = tuple(sorted(w))        # simple
key = tuple(counter(w)[c] for c in "abcdefghijklmnopqrstuvwxyz")   # O(n·k) vs O(n·k log k)
```

**Complexity:** O(n·k log k) with sorted keys, O(n·k) with count keys; `n` words, `k` avg length.

---

## 4. Longest Substring Without Repeating Characters
**Pattern:** Sliding window + last-seen index map — `#sliding-window`

**Approach:**
1. Expand `r`; maintain `l` and map `char → last index`.
2. If char seen at index `>= l`: `l = idx + 1`.
3. `ans = max(ans, r - l + 1)`.

**Complexity:** O(n) time, O(min(n, A)) space.

---

## 5. Longest Palindromic Substring
**Pattern:** Expand around centers

**Approach:**
1. For each center `i` (and each gap `i, i+1` for even length), expand while `s[l]==s[r]`.
2. Track best `(l, r)` window.

```
centers: 2n - 1   (n odd + n-1 even)
```

**Complexity:** O(n²) time, O(1) space.

---

## 6. Palindromic Substrings (count)
**Pattern:** Same center expansion, count each palindrome found

**Approach:** For each of the `2n-1` centers, expand and `count++` for each valid palindrome.

**Complexity:** O(n²) time, O(1) space.

---

## 7. Longest Common Prefix
**Pattern:** Vertical scan (or sort + compare first/last)

**Approach:**
1. Vertical scan: compare `strs[0][i]` with every string's `i`-th char; stop at first mismatch.
2. Alternative: sort array; LCP of first and last string is the answer.

**Complexity:** O(S) time (S = total chars), O(1) space.

---

## 8. Reverse Words in a String (trim, single spaces)
**Pattern:** In-place two-pass reversal (C++) / split+join (Python)

```cpp
// C++ — in-place: reverse whole string, then reverse each word
reverse(s.begin(), s.end());
// then two-pointer word extraction into the same buffer
```
```python
# Python — idiomatic one-liner
" ".join(s.split()[::-1])       # split() collapses whitespace and drops empties
```

**Complexity:** O(n) time; O(1) space in C++, O(n) in Python.

---

## 9. String to Integer (atoi)
**Pattern:** DFA / step-by-step parsing

**Approach (states):** skip whitespace → optional sign → digits (clamp on overflow) → stop.
Overflow check before multiply:

```
if res > (INT_MAX - digit) / 10: return INT_MAX (or INT_MIN for negative)
```

**Complexity:** O(n) time, O(1) space.

---

## 10. Implement `strStr` / Find Needle in Haystack
**Pattern:** KMP (optimal) or rolling hash (Rabin-Karp)

**KMP approach:**
1. Build LPS array of needle: longest proper prefix that is also a suffix.
2. Scan haystack; on mismatch jump `j = lps[j-1]` instead of restarting.

```python
# LPS building core
while j > 0 and needle[i] != needle[j]:
    j = lps[j - 1]
if needle[i] == needle[j]: j += 1
lps[i] = j
```

**Complexity:** O(n + m) time, O(m) space for LPS.

---

## 11. Repeated Substring Pattern
**Pattern:** String doubling trick or LPS

**Approach:**
1. `t = s + s`, drop first and last char.
2. `s` repeats iff `s in t`.

**Complexity:** O(n) with a linear substring search (KMP), O(n²) naive.

---

## 12. Basic Calculator II (+, -, *, /, no parens)
**Pattern:** Stack with sign-delayed evaluation

**Approach:**
1. Scan; accumulate current number.
2. On operator (or end): apply the **previous** sign to `stack`:
   - `+/-` → push `±num`; `*`/`/` → push `stack.pop() * num` / integer-divide.
3. Answer = sum(stack).

**Complexity:** O(n) time, O(n) space.

---

## 13. Decode String (`3[a2[c]]` → `accaccacc`)
**Pattern:** Stack of (string, repeat-count) pairs

**Approach:**
1. Digit → build count. `[` → push `(cur_string, count)`, reset both.
2. `]` → pop `(prev, k)`; `cur = prev + cur * k`.

**Complexity:** O(n) time, O(n) space.

---

## 14. Valid Parentheses
**Pattern:** Stack matching — `#stack`

**Approach:**
1. Push opening brackets; on closing bracket check `stack.top()` matches.
2. Stack must be empty at end.

**Complexity:** O(n) time, O(n) space.

---

## 15. Minimum Window Substring
**Pattern:** Sliding window with frequency deficit — `#sliding-window`

**Approach:**
1. `need = Counter(t)`, `have = 0`; expand `r`, update window counts.
2. When `have == len(need)`, shrink `l` while still valid; track min window.

**Complexity:** O(n) time, O(A) space.

---

## 16. Permutation in String (s2 contains a permutation of s1)
**Pattern:** Fixed-size sliding window + frequency match — `#sliding-window`

**Approach:**
1. Counts of `s1`; slide a window of `len(s1)` over `s2`.
2. Match if all 26 counts equal (or maintain a `matches` counter of matched chars).

**Complexity:** O(n) time, O(1) space.

---

## 17. Count and Say
**Pattern:** Run-length encoding iteration

**Approach:** For `n` rounds, read current string as runs: `count + digit` concatenated.

**Complexity:** O(n · 2^n) worst-case output size.

---

## 18. Longest Repeating Character Replacement
**Pattern:** Sliding window where `window_len - max_freq <= k` — `#sliding-window`

**Approach:**
1. Expand `r`, track max frequency char in window.
2. If `r - l + 1 - maxFreq > k`: shrink `l` (decrement its char count).
3. `ans = max(ans, window_len)`.

```
valid window ⇔ len(window) - count(most frequent char) <= k
```

**Complexity:** O(n) time, O(1) space.

---

## 19. Largest Number (arrange array of ints into max string)
**Pattern:** Custom comparator on string concatenation

**Approach:** Sort with comparator:

```cpp
// C++
sort(v.begin(), v.end(), [](string& a, string& b){ return a + b > b + a; });
```
```python
# Python
from functools import cmp_to_key
nums.sort(key=cmp_to_key(lambda a, b: -1 if a + b > b + a else 1))
```

Edge: strip leading zeros in the result.

**Complexity:** O(n log n · k), `k` = digit length.

---

## 20. Integer to Roman / Roman to Integer
**Pattern:** Greedy value table / right-to-left scan

**Approach (int→roman):** iterate value-symbol table from largest; subtract while it fits.
**Approach (roman→int):** if current symbol value < next symbol value → subtract, else add.

```
table = [(1000,'M'),(900,'CM'),(500,'D'),(400,'CD'),(100,'C'),(90,'XC'),(50,'L'),(40,'XL'),(10,'X'),(9,'IX'),(5,'V'),(4,'IV'),(1,'I')]
```

**Complexity:** O(1) time (bounded input), O(1) space.

---

## 21. Multiply Strings
**Pattern:** Schoolbook digit multiplication into a result array

**Approach:**
1. `res[i+j+1] += d1 * d2` (accumulate, then carry from right to left).
2. Trim leading zeros.

**Complexity:** O(n·m) time, O(n+m) space.

---

## 22. Isomorphic Strings
**Pattern:** Bijection check — two maps (char → char)

**Approach:** `map_s[t_char]` and `map_t[s_char]` must both stay consistent; fail on conflict.

**Complexity:** O(n) time, O(A) space.

---

## 23. Word Break
**Pattern:** DP with hash set of dictionary — `#dp`

**Approach:**
1. `dp[i]` = can segment `s[0:i]`.
2. `dp[i] = any(dp[j] and s[j:i] in wordSet for j < i)`.

**Complexity:** O(n²) time, O(n) space (plus O(n) for set).

---

## 24. Rabin-Karp / Repeated DNA Sequences (10-char substrings)
**Pattern:** Rolling hash with fixed window

**Approach:**
1. Hash of first 10 chars: `h = h*4 + digit(c)` (encode A/C/G/T as 0/1/2/3).
2. Slide: `h = (h - old*4^9) * 4 + new`; store hashes in a set; repeat → answer.

**Complexity:** O(n) time, O(n) space.
