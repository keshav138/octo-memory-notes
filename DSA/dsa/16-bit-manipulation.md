# Bit Manipulation

Core toolbox:

```
x & (x - 1)        → clears lowest set bit          (power of two, count bits)
x & (-x)           → isolates lowest set bit        (Fenwick, single number III)
x ^ x = 0, x ^ 0 = x                               (cancellation)
x ^= y; y ^= x; x ^= y                             (swap without temp)
n & 1              → parity test
x >> i & 1         → i-th bit
x | (1 << i)       → set i-th bit
~x                 → flip all (careful: Python has no fixed width, use masks)
```

---

## 1. Single Number (every element twice except one)
**Given:** an array where every element appears twice except one
**Expects:** return the single element
**Pattern:** XOR cancellation

**Approach:** `res ^= x` for all — pairs cancel, survivor remains.

**Complexity:** O(n) time, O(1) space.

---

## 2. Single Number II (every element three times except one)
**Given:** an array where every element appears three times except one
**Expects:** return the single element
**Pattern:** Bit counting mod 3 (or two-state automaton)

**Approach:** For each bit position, count set bits across all numbers; `count % 3` is that bit of the answer.

**Complexity:** O(n·32) time, O(1) space.

---

## 3. Single Number III (two elements appear once)
**Given:** an array where exactly two elements appear once, the rest twice
**Expects:** return the two single elements
**Pattern:** XOR all → diff bit → partition

**Approach:**
1. `xorAll = a ^ b` (all others cancel).
2. `diff = xorAll & (-xorAll)` — isolate one differing bit.
3. Partition numbers by `x & diff`; XOR each group; results are `a` and `b`.

**Complexity:** O(n) time, O(1) space.

---

## 4. Missing Number (0..n)
**Given:** an array containing 0..n except one missing number
**Expects:** return the missing number
**Pattern:** XOR indices with values (or sum formula)

**Approach:** `missing = n; for i, x: missing ^= i ^ x`.

**Complexity:** O(n) time, O(1) space.

---

## 5. Number of 1 Bits (popcount)
**Given:** an integer
**Expects:** return the number of set bits in it
**Pattern:** Clear lowest set bit loop, or builtin

```cpp
// C++
__builtin_popcount(x)
```
```python
# Python
x.bit_count()
```

**Approach (manual):** `while x: x &= x - 1; count += 1`.

**Complexity:** O(number of set bits) time.

---

## 6. Counting Bits (popcount for 0..n)
**Given:** an integer n
**Expects:** return the popcounts of all numbers 0..n
**Pattern:** DP recurrence on bit structure

**Approach:** `dp[i] = dp[i >> 1] + (i & 1)` (or `dp[i] = dp[i & (i-1)] + 1`).

**Complexity:** O(n) time.

---

## 7. Power of Two
**Given:** an integer
**Expects:** return true if it is a power of two
**Pattern:** `x > 0 and x & (x-1) == 0`

**Approach:** A power of two has exactly one set bit.

**Complexity:** O(1) time.

---

## 8. Power of Four
**Given:** an integer
**Expects:** return true if it is a power of four
**Pattern:** Power of two + set bit at even position

**Approach:** `x > 0 and (x & (x-1)) == 0 and (x & 0x55555555) != 0` — the `0x55..` mask has bits at even positions.

**Complexity:** O(1) time.

---

## 9. Reverse Bits
**Given:** a 32-bit integer
**Expects:** return the integer formed by reversing its bits
**Pattern:** Shift-and-assemble

**Approach:** 32 iterations: `res = (res << 1) | (n & 1); n >>= 1`.

**Complexity:** O(32) time.

---

## 10. Sum of Two Integers (no + or -)
**Given:** two integers a and b
**Expects:** return their sum without using + or -
**Pattern:** XOR for add-without-carry + AND-shift for carry

**Approach:**
```python
while b:
    carry = (a & b) << 1
    a = a ^ b
    b = carry
return a
```
Python needs a 32-bit mask for negatives: `mask = 0xFFFFFFFF`.

**Complexity:** O(32) iterations.

---

## 11. Hamming Distance
**Given:** two integers
**Expects:** return the number of positions where their bits differ
**Pattern:** XOR + popcount

**Approach:** `(x ^ y).bit_count()`.

**Complexity:** O(1) time.

---

## 12. Hamming Weight / Total Hamming Distance (all pairs)
**Given:** an array
**Expects:** return the sum of pairwise Hamming distances
**Pattern:** Bit-position contribution counting

**Approach:** For each bit position: `contribution = ones * zeros`; sum over 32 bits.

**Complexity:** O(n·32) time.

---

## 13. Subsets via Bitmask (generate all subsets)
**Given:** a set of n elements
**Expects:** generate all 2^n subsets via bitmasks
**Pattern:** Iterate masks 0..2^n - 1

**Approach:**
```python
for mask in range(1 << n):
    subset = [nums[i] for i in range(n) if mask >> i & 1]
```

**Complexity:** O(n·2^n) time.

---

## 14. Gray Code
**Given:** an integer n
**Expects:** return an n-bit Gray code sequence
**Pattern:** `gray(i) = i ^ (i >> 1)`

**Approach:** Generate sequence directly with the formula.

**Complexity:** O(2^n) time.

---

## 15. Find the Difference (extra char in t)
**Given:** two strings where t has one extra character
**Expects:** return the extra character
**Pattern:** XOR both strings

**Approach:** `res ^= ch` over `s + t`; survivor is the extra char.

**Complexity:** O(n) time, O(1) space.

---

## 16. UTF-8 Validation
**Given:** a byte array
**Expects:** return true if it is a valid UTF-8 encoding
**Pattern:** Bit-prefix pattern matching

**Approach:** Check leading byte patterns: `0xxxxxxx`, `110xxxxx`, `1110xxxx`, `11110xxx`; continuation bytes must be `10xxxxxx`.

**Complexity:** O(n) time.

---

## 17. Bitwise AND of Numbers Range [m, n]
**Given:** integers m and n
**Expects:** return the bitwise AND of all numbers in [m, n]
**Pattern:** Common prefix of m and n

**Approach:** Shift both right until equal (dropping differing suffix bits), then shift back.

```python
shift = 0
while m != n:
    m >>= 1; n >>= 1; shift += 1
return m << shift
```

**Complexity:** O(32) time.

---

## 18. Maximum XOR of Two Numbers — see [14-tries.md](14-tries.md) (bitwise trie)
**Given:** an array of numbers
**Expects:** return the maximum XOR of any two numbers (via bitwise trie)

**Pattern:** Bitwise trie with opposite-bit descent.

**Complexity:** O(n·32) time.

---

## 19. XOR Queries on Subarray
**Given:** an array and subarray queries
**Expects:** return the XOR of each queried subarray
**Pattern:** Prefix XOR

**Approach:** `prefix[i+1] = prefix[i] ^ arr[i]`; query `[l, r]` = `prefix[r+1] ^ prefix[l]`.

```
x ^ x = 0 → subarray XOR via prefix XOR cancellation
```

**Complexity:** O(n + q) time.

---

## 20. Counting Subsets / DP over Bitmask — Minimum XOR Sum (assignment problem)
**Given:** two arrays of size n
**Expects:** return the minimum XOR sum over all permutations
**Pattern:** Bitmask DP

**Approach:** `dp[mask]` = min cost to assign first `popcount(mask)` elements of one array to positions in mask; transition: add next element against each unused bit.

```
dp[mask] = min(dp[mask], dp[mask ^ (1<<j)] + cost[popcount(mask)-1][j])
```

**Complexity:** O(n²·2^n) time.

---

## 21. Divide Two Integers (without *, /, %)
**Given:** a dividend and a divisor
**Expects:** return the quotient without using *, / or %
**Pattern:** Bit-shift subtraction (binary long division)

**Approach:** Repeatedly subtract the largest `divisor << k` that fits into remaining dividend, accumulate `1 << k`. Handle sign and INT_MIN/INT_MAX overflow.

**Complexity:** O(32) or O(log²) time.

---

## 22. Swap Two Numbers Without Temp
**Given:** two variables a and b
**Expects:** swap their values without a temporary variable
**Pattern:** XOR swap

```python
a ^= b; b ^= a; a ^= b
```

**Complexity:** O(1).

---

## 23. Check if a Number is a Sum of Powers of Three (or similar — base-k uniqueness)
**Given:** an integer n
**Expects:** return true if n is a sum of distinct powers of three
**Pattern:** Greedy digit decomposition

**Approach:** Repeatedly take `n % 3`; if any remainder is 2 → impossible; `n //= 3`.

**Complexity:** O(log₃ n) time.
