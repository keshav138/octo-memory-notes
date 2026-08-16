# Python One-Liners — Map, Lambda, Zip & Beyond

A reference of one-line Python operations for DSA and everyday work.
Written for C++ programmers: where a C++ habit hides behind a Python idiom, the
C++ equivalent is shown in a comment.

Conventions: `arr = [3, 1, 4, 1, 5, 9]`, `s = "hello world"`, `words = ["apple", "banana", "kiwi"]`.

---

## 1. Lambda — anonymous function

```python
f = lambda x: x * 2             # like an inline C++ lambda: [](int x){ return x*2; }
lambda x, y: x + y              # multiple args
lambda: 42                      # no args
lambda x: x if x > 0 else -x    # body must be a single expression (no statements)
```

Lambda is just a normal function; give it a name only when you must.
Prefer `def` for anything multi-line.

---

## 2. map — apply a function to every element

```cpp
// C++: std::transform(arr.begin(), arr.end(), out.begin(), [](int x){ return x*x; });
```

```python
list(map(str, arr))                       # int -> str: ['3', '1', ...]
list(map(abs, [-2, -3, 4]))               # built-ins work directly
list(map(lambda x: x * x, arr))           # with lambda
list(map(int, "1 2 3".split()))           # parse input (the DSA classic)
list(map(int, input().split()))           # read a line of ints
list(map(sum, grid))                      # row sums of a matrix
a, b = map(int, input().split())          # unpack two numbers
```

List comprehension is usually clearer; use `map` when the function is named
(`int`, `str`, `sum`) or for fast input parsing.

```python
[x * x for x in arr]                      # == list(map(lambda x: x*x, arr))
```

---

## 3. filter — keep elements that satisfy a predicate

```cpp
// C++: std::copy_if(arr.begin(), arr.end(), out.begin(), [](int x){ return x % 2 == 0; });
```

```python
list(filter(lambda x: x % 2 == 0, arr))         # evens
list(filter(None, [0, 1, "", "a", [], [1]]))    # None -> keep truthy values
list(filter(str.isdigit, "a1b2"))               # ['1', '2']
[x for x in arr if x % 2 == 0]                  # comprehension version
```

---

## 4. zip — pair up sequences

```python
list(zip("abc", [1, 2, 3]))             # [('a',1), ('b',2), ('c',3)]
list(zip("abc", [1, 2]))                # stops at the shortest: [('a',1), ('b',2)]
```

DSA applications:

```python
list(zip(*grid))              # transpose a matrix (returns tuples)
for a, b in zip(nums, nums[1:]): ...     # adjacent pairs
for a, b in zip(nums, nums[::-1]): ...   # mirror pairs (two-pointer check)
d = dict(zip(keys, values))   # build a dict from two lists
list(zip(*(nums[i:] for i in range(k)))) # groups of k at offset i
```

For adjacent pairs on any iterable, `itertools.pairwise` does `zip(x, x[1:])`.

---

## 5. sorted / min / max with key

```cpp
// C++: sort(v.begin(), v.end(), [](auto& a, auto& b){ return a.second > b.second; });
```

```python
sorted(arr)                              # ascending copy
sorted(arr, reverse=True)                # descending
arr.sort()                               # in-place
sorted(words, key=len)                   # sort by length
sorted(words, key=lambda w: (len(w), w)) # tuple key: length, then lexicographic
sorted(arr, key=lambda x: -x)            # descending without reverse=True
sorted(pairs, key=lambda p: (p[0], -p[1]))  # asc by first, desc by second
sorted(arr, key=lambda x: (x % 2, x))    # evens first, then ascending
max(arr)                                 # O(n) max
max(words, key=len)                      # longest word
max(pairs, key=lambda p: p[1])           # max by second element
min(arr, key=lambda x: abs(x - target))  # closest value to target
nth = sorted(arr)[k - 1]                 # kth smallest (O(n log n); use heaps for k large)
```

Common keys: `key=len`, `key=str.lower`, `key=abs`, `key=lambda x: x[1]`,
`key=Counter` (sort by frequency), `key=lambda s: (len(s), s)`.

---

## 6. Comprehensions — one-line loops

### List

```python
[x * 2 for x in arr]                     # map
[x for x in arr if x % 2 == 0]           # filter
[x if x > 0 else 0 for x in arr]         # ternary inside
[f(x) for x in arr if cond(x)]           # map + filter
[(i, x) for i, x in enumerate(arr)]      # index + value
[x for row in grid for x in row]         # flatten 2D (row-major, like C++)
[[0] * n for _ in range(m)]              # m x n zero matrix (NEVER [[0]*n]*m)
```

### Dict

```python
{x: x * x for x in range(5)}             # {0:0, 1:1, ...}
{ch: s.count(ch) for ch in set(s)}       # frequency map (Counter is better)
{w: len(w) for w in words}               # map word -> length
d2 = {v: k for k, v in d.items()}        # invert dict (watch duplicate values)
```

### Set

```python
{x % 3 for x in arr}                     # unique remainders
{w[0] for w in words}                    # set of first letters
set(arr)                                 # dedupe a list
list(dict.fromkeys(arr))                 # dedupe, preserving order
```

### Generator (lazy — no list allocated)

```python
sum(x * x for x in range(10**6))         # no intermediate list
all(x > 0 for x in arr)
```

---

## 7. functools — the functional toolkit

```python
from functools import reduce, cache, cmp_to_key
from operator import mul, add

reduce(add, arr)                         # sum, via C++ std::accumulate
reduce(mul, arr, 1)                      # product
reduce(lambda a, b: a * b, range(1, n + 1))  # factorial
reduce(lambda a, b: (a * 10 + b) % k, digits)  # big number mod k (divisibility tricks)
reduce(max, arr)                         # works, but max(arr) is simpler

@cache                                   # auto-memoization for recursion (DP!)
def fib(n): return n if n < 2 else fib(n - 1) + fib(n - 2)

# cmp_to_key: C++-style comparator (bool: a before b) for custom sorts
sorted(arr, key=cmp_to_key(lambda a, b: a[1] - b[1]))
```

`functools.lru_cache(maxsize=None)` is the older alias of `cache`.
`@cache` on every DP recursion turns an exponential solution into O(n).

---

## 8. itertools — the lazy power tools

```python
from itertools import accumulate, combinations, permutations, product, \
                       groupby, chain, pairwise, count, cycle, repeat, \
                       islice, compress, starmap

list(accumulate(arr))                    # prefix sums [3,4,8,9,14,23]
list(accumulate(arr, max))               # prefix max
list(accumulate([1,2,3,4], mul))         # prefix product

list(combinations(arr, 2))               # C(n,2) pairs, no order
list(permutations("abc"))                # 3! = 6 orderings
list(product("ab", "12"))                # [('a','1'), ('a','2'), ('b','1'), ('b','2')]
list(product(arr, repeat=2))             # pairs incl. (x,x) — like two nested loops
list(product(range(3), range(2)))        # index loops of a 3x2 grid

list(groupby(sorted(words), key=len))    # group consecutive runs (SORT FIRST!)
for k, g in groupby("aabbca"): print(k, list(g))   # groups consecutive chars (RLE)

list(chain(*grid))                       # flatten one level
list(chain.from_iterable(grid))          # same, iterator-friendly
list(pairwise(arr))                      # [(3,1),(1,4),...] adjacent pairs

count(10, 2)                             # infinite: 10, 12, 14, ...
cycle("ab")                              # infinite: a, b, a, b, ...
repeat(0, 5)                             # 0, 0, 0, 0, 0
islice(it, 5)                            # take first 5 of an infinite iterator
compress(data, selectors)                # keep data[i] where selectors[i] is truthy
starmap(pow, [(2, 10), (3, 3)])          # map with unpacked args: pow(2,10), pow(3,3)
```

Backtracking one-liners (generate all, then filter — fine for small n):

```python
subsets = [c for r in range(n + 1) for c in combinations(arr, r)]
```

---

## 9. Collections — dict/set power-ups

```python
from collections import Counter, defaultdict, deque

# Counter
freq = Counter(arr)                      # frequency map in one line
freq.most_common(k)                      # top-k frequent: [(val, count), ...]
Counter("mississippi")                   # counts chars
sum(freq.values())                       # total elements

# defaultdict — no missing-key checks (C++ map's operator[])
d = defaultdict(int)                     # d[x] += 1 never KeyErrors
d = defaultdict(list)                    # adjacency list: d[u].append(v)
adj = defaultdict(set)                   # adjacency set

# deque — O(1) both ends (C++ std::deque)
q = deque(arr)                           # q.append, q.appendleft, q.pop, q.popleft
q.appendleft(x)                          # stack = list with append/pop is fine too
```

---

## 10. Strings — one-line operations

```python
s.split()                                # split on whitespace
s.split(",")                             # split on char
",".join(words)                          # join list into string
s.strip() / s.lstrip() / s.rstrip()      # trim
s.lower() / s.upper() / s.title()
s[::-1]                                  # reverse string
s == s[::-1]                             # palindrome check
"".join(sorted(s))                       # sort chars (anagram check)
sorted(s) == sorted(t)                   # anagram test
Counter(s) == Counter(t)                 # anagram test, O(n)
s.find("sub")                            # -1 if not found
s.startswith(p) / s.endswith(p)
s.count("a")                             # count substring (non-overlapping)
s.replace("a", "b")                      # replace all
s.replace("a", "b", 1)                   # replace first only
s.index("a")                             # like find but raises
" ".join(s.split())                      # collapse all whitespace to single spaces
s.translate(str.maketrans("aeiou", "AEIOU"))  # char map (like C++ transform)
"yes" if cond else "no"                  # ternary
str(num)                                 # int -> str
int("101", 2) / int("ff", 16)            # parse base 2 / 16
bin(x)[2:] / hex(x)[2:]                  # int -> binary/hex string
s.zfill(5)                               # pad left with zeros
"42".rjust(5, "0")                       # general right-justify padding
",".join(map(str, arr))                  # print list as "3,1,4,..."
```

---

## 11. Common DSA one-liners

```python
# Transpose a matrix
transposed = list(zip(*grid))

# Rotate 90 degrees clockwise
rotated = list(zip(*grid[::-1]))

# Flatten
flat = sum(grid, [])                     # O(n^2), only for tiny grids
flat = [x for row in grid for x in row]  # correct way

# Check sorted
arr == sorted(arr)

# All unique
len(set(arr)) == len(arr)

# Two-sum (value -> index lookup)
d = {v: i for i, v in enumerate(nums)}

# Left and right views of an array (one pass)
left, right = arr[:k], arr[k:]

# Binary search on a sorted list
import bisect
i = bisect.bisect_left(arr, x)           # first index where arr[i] >= x
i = bisect.bisect_right(arr, x)          # first index where arr[i] > x
bisect.insort(arr, x)                    # insert keeping sorted

# Heap shortcuts
import heapq
heapq.heapify(arr)                       # in-place O(n) min-heap
top3 = heapq.nlargest(3, arr)            # largest k
bot3 = heapq.nsmallest(3, arr)           # smallest k

# Digits of a number
digits = list(map(int, str(12345)))      # [1, 2, 3, 4, 5]
num = int("".join(map(str, digits)))     # back to int

# Char <-> ascii
ord("a"), chr(97)

# Range with step
range(0, n, 2)                           # evens: 0, 2, 4, ...
range(n - 1, -1, -1)                     # n-1 down to 0

# Swap (no temp needed — tuple unpacking)
a, b = b, a
```

---

## 12. Truth-testing & aggregation one-liners

```python
all(x > 0 for x in arr)                  # every element positive
any(x > 10 for x in arr)                 # at least one > 10
sum(1 for x in arr if cond(x))           # count matches (like std::count_if)
sum(arr) / len(arr)                      # mean
len(arr) - sum(map(bool, arr))           # count of falsy values

# max with index
i, v = max(enumerate(arr), key=lambda p: p[1])

# Unpacking (C++ structured bindings)
first, *rest, last = arr
a, *mid, b = "abcde"                     # a='a', mid=['b','c','d'], b='e'

# Walrus := (assign inside an expression) — Python 3.8+
if (n := len(arr)) > 5: print(n)
total = 0
[total := total + x for x in arr]        # reduce via walrus (trick, not idiom)

# Chained comparison
if 0 <= i < n: ...                       # C++ needs &&: 0 <= i && i < n

# Division pick-your-flavor
7 / 2        # 3.5  true division
7 // 2       # 3    floor
7 % 2        # 1
-7 // 2      # -4   (floor, NOT truncation like C++!)
divmod(7, 2) # (3, 1)  quotient and remainder at once
pow(2, 10, 1000)  # (2**10) % 1000 = 24 — fast modular exponentiation
```

---

## 13. Input/output one-liners

```python
# Fast DSA input
import sys
data = sys.stdin.buffer.read().split()           # all tokens as bytes
n = int(data[0]); arr = list(map(int, data[1:])) # typical first-line-n pattern
ints = iter(map(int, sys.stdin.buffer.read().split()))  # token stream
next(ints)                                        # pull one int at a time

# Reading lines
lines = sys.stdin.read().splitlines()
grid = [list(input().strip()) for _ in range(n)] # char grid

# Output
print(*arr)                    # space-separated: 3 1 4 1 5 9
print(*arr, sep=",")           # 3,1,4,1,5,9
print(" ".join(map(str, arr))) # same as print(*arr)
print(f"{x=}")                 # debug: x=5
```

---

## 14. Quick reference — which tool when

| Task | Tool |
|---|---|
| Apply function to each element | `map(f, it)` or `[f(x) for x in it]` |
| Keep elements by condition | `filter(pred, it)` or `[x for x in it if pred(x)]` |
| Pair up two sequences | `zip(a, b)` |
| Transpose / group by index | `zip(*grid)` |
| Custom sort order | `sorted(..., key=lambda ...)` |
| Fold / accumulate | `reduce(f, it)` |
| Prefix sums | `itertools.accumulate(it)` |
| Adjacent pairs | `itertools.pairwise(it)` |
| Combinations / permutations | `itertools.combinations` / `permutations` |
| Cartesian product | `itertools.product` |
| Memoize recursion | `functools.cache` on the function |
| Frequency counting | `collections.Counter` |
| Top-k frequent | `Counter.most_common(k)` |
| Missing-key dict | `collections.defaultdict(list/int)` |
| Sorted insert / search | `bisect.insort` / `bisect_left` |
| k largest / smallest | `heapq.nlargest` / `nsmallest` |
| Parse a line of ints | `list(map(int, input().split()))` |
| Dedupe preserving order | `list(dict.fromkeys(arr))` |

---

## 15. Pitfalls (C++ habits that bite)

| C++ habit | Python trap |
|---|---|
| `map<int,int>` auto-inserts | `d[k]` raises `KeyError` — use `defaultdict` or `d.get(k, 0)` |
| `[[0]*n]*m` copies rows | rows share identity! Use `[[0]*n for _ in range(m)]` |
| `-7/2 == -3` (truncation) | `-7//2 == -4` (floor). Use `int(a/b)` for C++ semantics |
| `for(int i=0; i<n; i++)` | prefer `for x in arr`; use `enumerate` when index needed |
| `std::sort` mutates, returns void | `sorted()` returns new list; `list.sort()` mutates in place |
| `str[i]` mutable | strings immutable — build lists, then `"".join(...)` |
| `map` gives a list | `map`/`filter`/`zip` are lazy iterators — wrap with `list()` |
| Modify list while iterating | iterate over a copy: `for x in arr[:]:` |
| `(n // 2)` int division fine | `1/2` is `0.5` — use `//` for integer division |
