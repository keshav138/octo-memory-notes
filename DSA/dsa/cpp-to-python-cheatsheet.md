# C++ → Python DSA Cheatsheet

For developers who know DSA in C++ and need to express the same ideas in Python.
Idiomatic Python throughout: list comprehensions, slicing, built-ins, `enumerate`/`zip`.
Follows the topic order of this repo's files 01–18.

---

## 0. Mental Model Shift

| C++ habit | Python reality |
|---|---|
| Manage memory, pointers, references | Everything is a reference; garbage collected |
| Compile-time type checking | Runtime; `1/2 == 0.5` (float), `1//2 == 0` (floor) |
| `int` overflows / use `long long` | `int` is arbitrary precision — never overflows |
| Pass by value vs reference | Objects passed by reference; reassignment is local; mutation is shared |
| `a < b < c` invalid | `a < b < c` is valid chained comparison |
| Index-based loops everywhere | Iterate values directly; index only when needed (`enumerate`) |
| `#include` everything | `import` as needed; no headers, no `main()` needed for scripts |

---

## 1. Core Language

### 1.1 Variables & arithmetic

```cpp
// C++
int a = 5;
long long b = 1e18;
float f = 1.5;
bool ok = true;
char c = 'x';
string s = "abc";
```
```python
# Python — no type keywords needed
a = 5
b = 10**18              # arbitrary precision
f = 1.5
ok = True               # note capital True/False
c = 'x'                 # str, no char type
s = "abc"               # '...' and "..." are identical
```

Arithmetic differences:

```cpp
// C++
int q = 7 / 2;      // 3
int r = 7 % 2;      // 1
int p = 2 / 5;      // 0
(-7) % 3;           // -1
```
```python
# Python
7 / 2       # 3.5   — true division, always float
7 // 2      # 3     — integer division is //
7 % 2       # 1
2 // 5      # 0     — floor, same as C++ for positives
-7 % 3      # 2     — Python modulo always non-negative! (C++ gives -1)
-7 // 3     # -3    — floor, not truncation (C++ gives -2)
```

**Gotcha:** for negative values, `%` and `//` differ from C++. Use `abs()` or shift values if you need C++ semantics.

Swap without temp:

```python
a, b = b, a                    # tuple swap, no temp needed
x, y = y, x + y                # RHS evaluated fully first (Fibonacci trick)
```

### 1.2 Booleans, None, and comparison

```python
None        # nullptr / NULL equivalent
True, False

# Chained comparison (invalid in C++, natural in Python)
if lo <= mid <= hi: ...        # same as lo <= mid and mid <= hi
```

Truthiness: `0`, `0.0`, `""`, `[]`, `{}`, `set()`, `None` are falsy; everything else is truthy.
So `if stack:` means "stack is not empty" — unlike C++ where you test `!stack.empty()`.

### 1.3 Loops

```cpp
// C++
for (int i = 0; i < n; i++) { ... }
for (int i = n - 1; i >= 0; i--) { ... }
for (int i = 0; i < n; i += 2) { ... }
for (int x : arr) { ... }
```
```python
# Python
for i in range(n): ...                     # 0..n-1
for i in range(n - 1, -1, -1): ...         # reverse
for i in range(0, n, 2): ...               # step
for x in arr: ...                          # value iteration — prefer this

# With index when needed:
for i, x in enumerate(arr): ...            # i = index, x = value
for i, (a, b) in enumerate(zip(A, B)): ... # parallel iteration with index
```

**`range` never includes the stop value.** `range(5)` → 0,1,2,3,4.

`while` is the same as C++.

### 1.4 Conditionals

```python
if x > 0:
    ...
elif x == 0:          # NOT "else if"
    ...
else:
    ...
```

No `switch`/`case` — use `if/elif` or a dict of lambdas.

**Indentation is syntax.** No braces, no semicolons. 4 spaces per level.

### 1.5 Functions

```cpp
// C++
int f(int a, int b) {
    return a + b;
}
// pass by reference to mutate:
void modify(vector<int>& v) { v[0] = 9; }
```
```python
# Python
def f(a, b):
    return a + b

# Mutable objects are already passed by reference:
def modify(v):
    v[0] = 9            # mutates the caller's list

# Careful: reassigning the name doesn't affect the caller
def bad(v):
    v = [1, 2, 3]       # local rebind, caller unchanged
```

Key points:
- No type declarations. Optional type hints exist but LeetCode doesn't need them.
- Multiple return values via tuple: `return x, y` → unpack with `a, b = f()`.
- Default args: `def f(a, b=10):`.

### 1.6 Lambdas and sorting

```cpp
// C++
sort(v.begin(), v.end());                              // ascending
sort(v.begin(), v.end(), greater<int>());              // descending
sort(v.begin(), v.end(), [](auto& a, auto& b) {
    return a.second > b.second;                        // by value desc
});
```
```python
# Python
v.sort()                                   # in-place, ascending
v.sort(reverse=True)                       # descending
v.sort(key=lambda x: -x)                   # descending (negation)
v.sort(key=lambda x: x[1], reverse=True)   # by element[1] desc

# sorted() returns a NEW list (works on any iterable):
s = sorted(v, key=lambda x: x[0])

# C++ pair sort (first asc, second asc) is default in Python too.
# For first asc, second DESC (classic trick):
pairs.sort(key=lambda x: (x[0], -x[1]))

# Multi-key sort: key can be any tuple
arr.sort(key=lambda x: (x[0], x[1], x[2]))

# Sorting strings: lexicographic by default (like C++).
# IMPORTANT: sorting numbers requires a key — sorting strings of digits
# compares lexicographically: ["10", "2"] stays ["10", "2"].
```

**Common `sort` key patterns:**

| C++ | Python |
|---|---|
| Sort by second | `.sort(key=lambda x: x[1])` |
| Sort desc | `.sort(reverse=True)` |
| Sort by length then lex | `.sort(key=lambda s: (len(s), s))` |
| Custom comparator `a < b` | `functools.cmp_to_key(cmp)` — rare, avoid |
| Stable sort | `sorted(..., )` / `list.sort()` are stable |

### 1.7 Ternary and comprehensions

```cpp
// C++
int x = (cond) ? a : b;
```
```python
# Python
x = a if cond else b

# List comprehension — replaces loops that build lists
sq = [x * x for x in range(10)]                    # [0,1,4,...,81]
evens = [x for x in nums if x % 2 == 0]            # with filter
pairs = [(a, b) for a in A for b in B]             # nested loops

# Dict comprehension
d = {x: x * x for x in range(5)}                   # {0:0, 1:1, ...}

# Set comprehension
s = {x for x in nums}                              # dedupe

# Generator expression — lazy, no list built
total = sum(x * x for x in nums)
```

### 1.8 Strings: slicing and indexing

```cpp
// C++
string s = "abcdef";
string sub = s.substr(2, 3);          // "cde"  (pos, len)
s[i];                                 // char at i
reverse(s.begin(), s.end());
```
```python
# Python
s = "abcdef"
sub = s[2:5]         # "cde" — s[start:stop], stop EXCLUSIVE
s[:3]                # "abc" — prefix
s[3:]                # "def" — suffix
s[-1]                # 'f' — negative index from end
s[::-1]              # "fedcba" — reverse
s[i]                 # character at i (a str of length 1)

# Strings are IMMUTABLE (like C++ std::string? No — C++ strings are mutable!)
# To modify, convert to list:
chars = list(s)
chars[i] = 'X'
s = ''.join(chars)                 # join list back to string

# Build strings with a list + join (fast), not += in a loop
parts = []
for c in s:
    parts.append(c)
result = ''.join(parts)
```

### 1.9 I/O (for local practice, not LeetCode)

```cpp
// C++
int n; cin >> n;
vector<int> v(n);
for (int& x : v) cin >> x;
cout << ans << '\n';
```
```python
# Python
n = int(input())
v = list(map(int, input().split()))    # read whole line of ints
print(ans)                             # print with newline

# Fast input for large files:
import sys
data = sys.stdin.buffer.read().split()  # all tokens, bytes
n = int(data[0])
nums = list(map(int, data[1:1+n]))
sys.stdout.write(str(ans) + '\n')
```

`print(x, y, z)` prints space-separated. `print(*arr)` unpacks a list.

---

## 2. Data Structures

### 2.1 List ↔ vector

| C++ | Python | Notes |
|---|---|---|
| `vector<int> v(n, 0)` | `[0] * n` | careful with nested lists |
| `vector<int> v = {1,2,3}` | `[1, 2, 3]` | |
| `v.push_back(x)` | `v.append(x)` | amortized O(1) |
| `v.pop_back()` | `v.pop()` | O(1), returns the value too |
| `v[i]` | `v[i]` | O(1), supports negative index |
| `v.size()` | `len(v)` | |
| `v.empty()` | `not v` | |
| `v.front()` / `v.back()` | `v[0]` / `v[-1]` | |
| `v.insert(it, x)` | `v.insert(i, x)` | O(n) |
| `v.erase(it)` | `del v[i]` / `v.remove(x)` | O(n) |
| `reverse(v.begin(), v.end())` | `v.reverse()` or `v[::-1]` | |
| `find(v.begin(), v.end(), x)` | `v.index(x)` | raises ValueError if absent |
| `v1 == v2` | `v1 == v2` | element-wise — Python wins here |
| `min_element / max_element` | `min(v)` / `max(v)` | |
| — | `v.count(x)` | count occurrences |
| — | `sum(v)` | sum of elements |

**1D vs 2D initialization — the classic trap:**

```cpp
// C++
vector<vector<int>> grid(m, vector<int>(n, 0));
```
```python
# Python — WRONG (all rows alias the same inner list!):
grid = [[0] * n] * m

# Python — RIGHT:
grid = [[0] * n for _ in range(m)]
```

### 2.2 Dict ↔ unordered_map

| C++ | Python | Notes |
|---|---|---|
| `unordered_map<K,V> m` | `d = {}` | |
| `m[k] = v` | `d[k] = v` | insert or overwrite |
| `m[k]` (default 0) | `d[k]` | **KeyError if missing!** |
| `m.count(k)` | `k in d` | idiomatic check |
| `m.erase(k)` | `del d[k]` / `d.pop(k, None)` | |
| `m.size()` | `len(d)` | |
| `for (auto& [k,v] : m)` | `for k, v in d.items():` | |
| `m.find(k)` | `d.get(k, default)` | returns default if absent |
| — | `d.setdefault(k, 0)` | get or insert default |
| `map` (ordered) | — | dict preserves insertion order (3.7+) |

**The default-value patterns (you'll use these constantly):**

```cpp
// C++
freq[x]++;                                  // works, defaults to 0
count[sum - k]                              // returns 0 if absent
```
```python
# Python
freq[x] = freq.get(x, 0) + 1                # get with default

# Even better — collections.Counter:
from collections import Counter
freq = Counter(nums)                        # counts of everything
freq[x] += 1                                # works! Counter defaults to 0

# Group-by-key pattern:
groups = {}
for k, v in items:
    groups.setdefault(k, []).append(v)

# Or:
from collections import defaultdict
groups = defaultdict(list)                  # default value = []
groups[k].append(v)                         # no KeyError ever

# defaultdict(int) behaves exactly like C++ unordered_map with operator[]
count = defaultdict(int)
count[sum - k]                              # returns 0 if absent — safe!
```

**Gotcha — iterating a dict while mutating it** raises `RuntimeError`. Iterate over `list(d.keys())` or collect changes first.

### 2.3 Set ↔ unordered_set

| C++ | Python | Notes |
|---|---|---|
| `unordered_set<int> s` | `s = set()` | |
| `s.insert(x)` | `s.add(x)` | **`add`, not `insert`** |
| `s.erase(x)` | `s.discard(x)` (safe) / `s.remove(x)` (raises) | |
| `s.count(x)` | `x in s` | O(1) average |
| `s.size()` | `len(s)` | |
| `for (int x : s)` | `for x in s:` | arbitrary order |

```python
s = set(nums)                          # build from any iterable, dedupes
a & b                                  # intersection
a | b                                  # union
a - b                                  # difference
a ^ b                                  # symmetric difference
```

**Frozenset** = immutable set, usable as dict key (C++ has no direct equivalent).

### 2.4 Stack & Queue

**Use `list` for stack, `collections.deque` for queue/deque:**

```cpp
// C++ stack
stack<int> st;
st.push(x); x = st.top(); st.pop(); st.empty();
```
```python
# Python stack — just a list
st = []
st.append(x)          # push
x = st[-1]            # top (peek)
st.pop()              # pop (returns the value)
if st:                # empty check (st.empty())
```

```cpp
// C++ queue
queue<int> q;
q.push(x); x = q.front(); q.pop();
```
```python
# Python queue — deque
from collections import deque
q = deque()
q.append(x)           # push to back (enqueue)
x = q[0]              # front
q.popleft()           # dequeue — O(1) (list.pop(0) is O(n)!)

# Deque supports both ends in O(1):
q.appendleft(x)       # push front
q.pop()               # pop back
q.popleft()           # pop front
```

`deque` also supports `rotate(k)` (circular shift, useful for rotation problems).

### 2.5 Heap ↔ priority_queue

```cpp
// C++
priority_queue<int> pq;                       // MAX-heap (largest on top)
priority_queue<int, vector<int>, greater<int>> minpq;  // min-heap
priority_queue<pair<int,int>, vector<pair<int,int>>, greater<>> minPairs;
```
```python
# Python — heapq is a MIN-heap only. Negate for max.
import heapq

h = []
heapq.heappush(h, x)              # push
x = h[0]                          # peek min (NOT heapq.min — index 0)
x = heapq.heappop(h)              # pop min

# MAX-heap: store negatives
heapq.heappush(h, -x)
x = -heapq.heappop(h)

# Pair heap: heapq compares element-wise (first, then second)
heapq.heappush(h, (dist, node))   # sorted by dist, then node

# Heapify existing list in place: O(n)
heapq.heapify(nums)
```

**Gotcha — `heapq` functions are free functions**, not methods on the list. You must pass `h` every time, and `h` must already be a valid heap for `heappop`/`heappush` to maintain it.

| C++ | Python |
|---|---|
| `pq.top()` | `h[0]` |
| `pq.push(x)` | `heapq.heappush(h, x)` |
| `pq.pop()` | `heapq.heappop(h)` |
| `pq.empty()` | `not h` |
| `pq.size()` | `len(h)` |

### 2.6 Pairs and Tuples

```cpp
// C++
pair<int, int> p = {1, 2};
p.first; p.second;
make_pair(a, b);
```
```python
# Python
p = (1, 2)
x, y = p                # unpacking — everywhere in Python
a, b = b, a             # swap
for k, v in d.items():  # unpacking in loops

# Tuples are immutable. Use lists if you need to mutate elements.
# Tuples are hashable (can be dict keys / set elements); lists are not.
```

---

## 3. Pattern-by-Pattern (topics 01–18)

### 3.1 Arrays (01)

```cpp
// C++
vector<int> res(n);
for (int i = 0; i < n; i++) res[i] = a[i] * 2;
reverse(a.begin(), a.end());
```
```python
# Python
res = [x * 2 for x in a]            # map
res = a[::-1]                       # reverse copy
a.reverse()                         # in-place reverse

# Prefix sum — itertools.accumulate
from itertools import accumulate
prefix = list(accumulate(nums))             # [0] + ... prepend manually
prefix = [0] + list(accumulate(nums))       # 1-indexed prefix, like C++

# Slicing beats index loops:
a[i], a[j] = a[j], a[i]             # swap in place
arr[:k], arr[k:] = arr[n-k:], arr[:n-k]     # rotate by k (slice assign)

# Matrix (2D list):
grid = [[0] * n for _ in range(m)]          # m rows, n cols
rows, cols = len(grid), len(grid[0])
grid[i][j]
transposed = list(zip(*grid))               # transpose — returns tuples
```

### 3.2 Strings (02)

```cpp
// C++
string s = "abc";
char c = s[i];
s += "xy";
s[i] = 'z';                        // C++ strings ARE mutable
```
```python
# Python — strings are IMMUTABLE
s = "abc"
c = s[i]                           # still a str of length 1
s += "xy"                          # works but O(n) — creates new string
# s[i] = 'z'                       # TypeError! Use list for mutation:
t = list(s); t[i] = 'z'; s = ''.join(t)

# Building strings in a loop — join beats +=
parts = []
for x in values:
    parts.append(str(x))
result = ''.join(parts)

# Char checks — str methods, not <cctype>
ch.isalpha(); ch.isdigit(); ch.isalnum()
ch.isupper(); ch.islower()
ch.upper(); ch.lower()
s.split(); ' '.join(words)          # split/join instead of stringstream
s.count('a'); s.find('x'); s.startswith('ab'); s.endswith('cd')
s.replace('a', 'b')                 # replaces ALL occurrences
ord(ch)                             # char → int
chr(97)                             # int → char
'5' - '0'                           # TypeError — must use int('5')
```

**Gotcha — `split()` on empty string** gives `[]`, and `' '.join([])` gives `''`. Watch out for trailing delimiters: `"a b ".split()` → `['a', 'b']` (trailing empty removed), while `split(' ')` keeps empties.

### 3.3 Hashing (03)

```cpp
// C++
unordered_map<int,int> m;
m[x]++;
if (m.count(key)) ...
```
```python
# Python
from collections import Counter, defaultdict

count = Counter(nums)                       # frequency map in one line
count.most_common(2)                        # top-2 by frequency

group = defaultdict(list)                   # group anagrams pattern
for word in words:
    key = ''.join(sorted(word))
    group[key].append(word)

seen = set()
if x in seen: ...                           # O(1) membership

# Two-sum: dict lookup pattern
idx = {}
for i, x in enumerate(nums):
    if target - x in idx:
        return [idx[target - x], i]
    idx[x] = i
```

### 3.4 Two Pointers (04)

```cpp
// C++
int l = 0, r = n - 1;
while (l < r) {
    if (cond) l++;
    else r--;
}
```
```python
# Python — identical logic, idiomatic touches
l, r = 0, len(nums) - 1
while l < r:
    total = nums[l] + nums[r]
    if total == target:
        return [l, r]          # return from inside loop
    elif total < target:
        l += 1
    else:
        r -= 1

# In-place dedup — note Python slice-assign for compaction:
# nums[:k] = unique_prefix   (LeetCode uses this to check your answer)
```

### 3.5 Sliding Window (05)

```cpp
// C++
unordered_map<char,int> window;
for (int r = 0; r < n; r++) {
    window[s[r]]++;
    while (invalid) { window[s[l]]--; l++; }
    ans = max(ans, r - l + 1);
}
```
```python
# Python — Counter + while shrink
from collections import Counter

window = Counter()
l = 0
for r, ch in enumerate(s):
    window[ch] += 1
    while window[ch] > 1:                 # invalid condition
        window[s[l]] -= 1
        l += 1
    ans = max(ans, r - l + 1)

# Fixed-size window sum:
# window_sum = sum(nums[:k])
# slide: window_sum += nums[r] - nums[r - k]
```

### 3.6 Binary Search (06)

```cpp
// C++
int lo = 0, hi = n - 1;
while (lo <= hi) {
    int mid = lo + (hi - lo) / 2;
    if (a[mid] == target) return mid;
    if (a[mid] < target) lo = mid + 1;
    else hi = mid - 1;
}
```
```python
# Python — identical loop works; bisect is the built-in
import bisect

i = bisect.bisect_left(nums, target)     # first index >= target (lower_bound)
i = bisect.bisect_right(nums, target)    # first index > target (upper_bound)
bisect.insort(nums, x)                   # insert maintaining order

# Answer-space binary search:
lo, hi = 0, max(possible)
while lo < hi:
    mid = (lo + hi) // 2                 # or (lo + hi + 1) // 2 — pick correctly!
    if feasible(mid):
        hi = mid
    else:
        lo = mid + 1
```

### 3.7 Stack / Monotonic Stack (07)

```cpp
// C++ — next greater element
stack<int> st;
for (int i = n - 1; i >= 0; i--) {
    while (!st.empty() && st.top() <= a[i]) st.pop();
    ans[i] = st.empty() ? -1 : st.top();
    st.push(a[i]);
}
```
```python
# Python — list as stack
st = []
ans = [-1] * n
for i in range(n - 1, -1, -1):
    while st and st[-1] <= a[i]:       # st non-empty and top too small
        st.pop()
    ans[i] = st[-1] if st else -1
    st.append(a[i])

# Monotonic queue (sliding window max) — use deque, same as C++:
q = deque()                             # stores indices, front = max
```

### 3.8 Linked List (08)

C++ uses pointers; Python uses objects. Same operations, no `->`:

```cpp
// C++
ListNode* p = head;
while (p) { p = p->next; }
```
```python
# Python
p = head
while p:                      # None is falsy — no nullptr
    p = p.next

# Classic fast/slow:
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next

# Reverse a list — Python's tuple unpacking makes it beautiful:
prev, cur = None, head
while cur:
    cur.next, prev, cur = prev, cur, cur.next    # all at once!
return prev

# Dummy node (like new ListNode(0) in C++):
dummy = ListNode(0)
dummy.next = head
```

**Gotcha — Python has no pointers, so "swapping nodes" means swapping `.next` links or `.val`s**, exactly as in C++. Node identity works with `is`: `if node1 is node2`.

### 3.9 Trees & BST (09)

```cpp
// C++ preorder
void dfs(TreeNode* root) {
    if (!root) return;
    ...
    dfs(root->left);
    dfs(root->right);
}
```
```python
# Python
def dfs(root):
    if not root:                 # None is falsy
        return
    ...
    dfs(root.left)
    dfs(root.right)

# Iterative stack — list as stack, tuple for (node, state)
stack = [(root, False)]          # False = not visited yet
while stack:
    node, visited = stack.pop()
    if node:
        if visited:
            result.append(node.val)
        else:
            stack.append((node.right, False))
            stack.append((node, True))
            stack.append((node.left, False))

# BFS / level order — deque
q = deque([root])
while q:
    level_size = len(q)          # process one level
    for _ in range(level_size):
        node = q.popleft()
        if node.left: q.append(node.left)
        if node.right: q.append(node.right)
```

**BST successor / in-order tricks:**
```python
# In-order traversal with stack (no recursion):
cur = root
while st or cur:
    while cur:
        st.append(cur)
        cur = cur.left
    cur = st.pop()
    # visit cur
    cur = cur.right
```

### 3.10 Heaps / Top-K (10)

```cpp
// C++
priority_queue<pair<int,int>, vector<pair<int,int>>, greater<>> pq;
for (auto& [num, freq] : count) {
    pq.push({freq, num});
    if (pq.size() > k) pq.pop();
}
```
```python
# Python
import heapq
h = []
for num, freq in count.items():
    heapq.heappush(h, (freq, num))       # min-heap by freq
    if len(h) > k:
        heapq.heappop(h)

# n-largest / n-smallest one-liners:
heapq.nlargest(k, nums)                  # O(n log k)
heapq.nsmallest(k, nums)

# Two heaps (median stream) — max-heap via negation:
lo, hi = [], []                          # lo = max-heap (negated), hi = min-heap
heapq.heappush(lo, -x)
heapq.heappush(hi, -heapq.heappop(lo))
```

### 3.11 Graphs (11)

```cpp
// C++ — adjacency list
vector<vector<int>> adj(n);
adj[u].push_back(v);
```
```python
# Python
adj = [[] for _ in range(n)]              # NOT [[]] * n (aliasing!)
adj[u].append(v)

# BFS
from collections import deque
def bfs(start):
    dist = [-1] * n
    q = deque([start])
    dist[start] = 0
    while q:
        u = q.popleft()
        for v in adj[u]:
            if dist[v] == -1:
                dist[v] = dist[u] + 1
                q.append(v)
    return dist

# DFS (recursive with visited set)
def dfs(u):
    visited.add(u)
    for v in adj[u]:
        if v not in visited:
            dfs(v)

# Topological sort — Kahn's algorithm with deque
indeg = [0] * n
for u in range(n):
    for v in adj[u]:
        indeg[v] += 1
q = deque(u for u in range(n) if indeg[u] == 0)
while q:
    u = q.popleft()
    for v in adj[u]:
        indeg[v] -= 1
        if indeg[v] == 0:
            q.append(v)

# Dijkstra — heapq min-heap
import heapq
dist = [float('inf')] * n
dist[src] = 0
h = [(0, src)]
while h:
    d, u = heapq.heappop(h)
    if d > dist[u]: continue              # stale entry
    for v, w in adj[u]:
        if d + w < dist[v]:
            dist[v] = d + w
            heapq.heappush(h, (dist[v], v))

# Grid graph — directions array (same as C++)
dirs = [(0, 1), (1, 0), (0, -1), (-1, 0)]
for dr, dc in dirs:
    nr, nc = r + dr, c + dc
    if 0 <= nr < rows and 0 <= nc < cols:   # chained comparison
        ...
```

**Union-Find (DSU):**

```cpp
// C++ — vector parent with path compression
```
```python
# Python — parent list + find with path compression
parent = list(range(n))
rank = [0] * n

def find(x):
    while parent[x] != x:
        parent[x] = parent[parent[x]]     # path halving
        x = parent[x]
    return x

def union(a, b):
    ra, rb = find(a), find(b)
    if ra == rb: return
    if rank[ra] < rank[rb]: ra, rb = rb, ra
    parent[rb] = ra
    if rank[ra] == rank[rb]: rank[ra] += 1
```

### 3.12 Backtracking (12)

```cpp
// C++
void dfs(vector<int>& path, int start) {
    if (goal) { res.push_back(path); return; }
    for (int i = start; i < n; i++) {
        path.push_back(x);
        dfs(path, i + 1);
        path.pop_back();
    }
}
```
```python
# Python — same shape; slices avoid manual copy
def dfs(path, start):
    if goal:
        res.append(path[:])         # COPY the list! (list is mutable)
        return
    for i in range(start, n):
        path.append(x)
        dfs(path, i + 1)
        path.pop()                  # backtrack

# itertools shortcuts for the classic problems:
from itertools import combinations, permutations, product
list(combinations(nums, k))          # all k-subsets
list(permutations(nums))             # all orderings
list(product(nums, repeat=2))        # Cartesian product
```

**Gotcha — `res.append(path[:])` not `res.append(path)`**: the list is mutated later by backtracking, so append a copy.

### 3.13 Greedy (13)

No structural differences — greedy is just logic. The Python conveniences:
- `sorted()` with `key=` replaces comparator functions
- `heapq` for "always take the smallest/largest next" problems
- `max(iterable, key=...)` / `min(...)` find argmax in one call:
```python
best = max(candidates, key=lambda x: x[1])    # max by second element
```

### 3.14 Tries (14)

```cpp
// C++ — array of children pointers
struct TrieNode {
    TrieNode* child[26] = {};
    bool isEnd = false;
};
```
```python
# Python
class TrieNode:
    def __init__(self):
        self.children = {}              # dict char → node (sparse)
        self.is_end = False

class Trie:
    def __init__(self):
        self.root = TrieNode()

    def insert(self, word):
        node = self.root
        for ch in word:
            node = node.children.setdefault(ch, TrieNode())
        node.is_end = True

    def search(self, word):
        node = self.root
        for ch in word:
            if ch not in node.children:
                return False
            node = node.children[ch]
        return node.is_end
```

**Gotcha — mutable defaults shared across instances:** never write `class TrieNode: children = {}` at class level — every instance would share the same dict. Always initialize `self.children = {}` inside `__init__` (as above).

### 3.15 Intervals (15)

```cpp
// C++
sort(intervals.begin(), intervals.end());
vector<vector<int>> res;
for (auto& iv : intervals) {
    if (res.empty() || iv[0] > res.back()[1]) res.push_back(iv);
    else res.back()[1] = max(res.back()[1], iv[1]);
}
```
```python
# Python — cleaner because tuples compare lexicographically
intervals.sort()                       # sorts by (start, end) — same as C++ pair
res = []
for s, e in intervals:
    if not res or s > res[-1][1]:
        res.append([s, e])
    else:
        res[-1][1] = max(res[-1][1], e)
```

### 3.16 Bit Manipulation (16)

Identical operators. Differences:

```cpp
// C++
x & y;  x | y;  x ^ y;  ~x;  x << 1;  x >> 1;
__builtin_popcount(x);
```
```python
# Python — same operators
x & y;  x | y;  x ^ y;  ~x;  x << 1;  x >> 1

# ~x in Python = -(x+1) — same as C++ two's complement
# BUT: Python ints are infinite-precision, so ~0 == -1, ~5 == -6
# To get a fixed-width complement, mask it: ~x & 0xFFFFFFFF

x.bit_count()               # popcount (Python 3.8+: bin(x).count('1'))
bin(x)                      # '0b101'
int('101', 2)               # 5 — parse binary string
```

Mask for 32-bit problems: `x & 0xFFFFFFFF`, `x & 0x7FFFFFFF` for abs.

### 3.17 Dynamic Programming (17)

**Memoization — the `@lru_cache` decorator replaces hand-written memo arrays:**

```cpp
// C++
vector<int> memo(n + 1, -1);
int solve(int i) {
    if (i >= n) return 0;
    if (memo[i] != -1) return memo[i];
    return memo[i] = max(solve(i+1), solve(i+2) + a[i]);
}
```
```python
# Python
from functools import lru_cache

@lru_cache(None)                        # cache ALL arguments (None = no limit)
def solve(i):
    if i >= n: return 0                 # base case
    return max(solve(i+1), solve(i+2) + a[i])   # no manual memo writes

# or with an explicit dict (when you need to inspect/modify the cache):
memo = {}
def solve(i):
    if i in memo: return memo[i]
    if i >= n: return 0
    memo[i] = max(solve(i+1), solve(i+2) + a[i])
    return memo[i]
```

**`@lru_cache` rules:**
- All arguments must be hashable (ints, strings, tuples — not lists). Pass tuples or use indices.
- For problems where you need to inspect the cache, use a dict — `lru_cache` hides it.

**Tabulation — 1D and 2D tables:**

```cpp
// C++
vector<int> dp(n + 1);
vector<vector<int>> t(m, vector<int>(n));
```
```python
# Python
dp = [0] * (n + 1)                      # 1D
t = [[0] * n for _ in range(m)]         # 2D — comprehension, NOT multiplication!

# Filling 2D with inf:
INF = float('inf')                      # like INT_MAX
dp = [[INF] * n for _ in range(m)]

# Common DP iteration orders:
for i in range(1, n):                   # forward
    dp[i] = dp[i-1] + dp[i-2]
for i in range(n - 1, -1, -1):          # backward
    dp[i] = max(dp[i], dp[i+1])
for length in range(2, n + 1):          # interval DP by length
    for i in range(n - length + 1):
        j = i + length - 1
```

**Pattern templates:**

```python
# 0/1 knapsack
@lru_cache(None)
def dp(i, cap):
    if i == n or cap == 0: return 0
    if wt[i] > cap: return dp(i + 1, cap)
    return max(dp(i + 1, cap), val[i] + dp(i + 1, cap - wt[i]))

# Unbounded knapsack / coin change
@lru_cache(None)
def dp(amount):
    if amount == 0: return 0
    best = INF
    for c in coins:
        if c <= amount:
            best = min(best, 1 + dp(amount - c))
    return best

# LCS-style two-string DP
@lru_cache(None)
def dp(i, j):
    if i == len(a) or j == len(b): return 0
    if a[i] == b[j]: return 1 + dp(i + 1, j + 1)
    return max(dp(i + 1, j), dp(i, j + 1))

# Interval DP (burst balloons etc.)
@lru_cache(None)
def dp(i, j):                           # open interval (i, j)
    best = 0
    for k in range(i + 1, j):
        best = max(best, a[i]*a[k]*a[j] + dp(i, k) + dp(k, j))
    return best

# Bitmask DP — mask as int, same as C++
@lru_cache(None)
def dp(node, mask):
    if mask == FULL: return 0
    return min(dp(nxt, mask | (1 << nxt)) + w for nxt in adj[node])
```

**Hashable-argument gotcha:** if state involves a list, convert to `tuple` before memoizing: `dp(i, tuple(remaining))`.

### 3.18 Advanced Design (18)

```cpp
// C++ — LRU: list + unordered_map of iterators
```
```python
# Python — LRU cache in ~6 lines with OrderedDict
from collections import OrderedDict

class LRUCache:
    def __init__(self, capacity):
        self.cap = capacity
        self.cache = OrderedDict()

    def get(self, key):
        if key not in self.cache:
            return -1
        self.cache.move_to_end(key)          # mark as most recent
        return self.cache[key]

    def put(self, key, value):
        self.cache[key] = value
        self.cache.move_to_end(key)
        if len(self.cache) > self.cap:
            self.cache.popitem(last=False)   # evict LRU

# LFU — OrderedDict per frequency, or just dict + Counter of uses
```

**LeetCode already provides:**
- `from functools import lru_cache` for memoization
- `OrderedDict` for LRU
- Custom `ListNode` / `TreeNode` classes — use their constructors, no `struct` needed

---

## 4. Performance & TLE Pitfalls

**These are the Python-specific traps that cause Time Limit Exceeded:**

| Pitfall | Fix |
|---|---|
| `list.pop(0)` / `list.insert(0, x)` are O(n) | Use `collections.deque` with `popleft()` / `appendleft()` |
| String `+=` in a loop is O(n²) | Collect in a list, `''.join(parts)` |
| Recursion depth > 1000 crashes (`RecursionError`) | `sys.setrecursionlimit(10**6)` — but deep recursion is still slow; prefer iterative for DFS on big graphs |
| `in` on a list is O(n); `in` on a set/dict is O(1) | Use sets for membership tests in loops |
| Reading input with `input()` line by line (slow for 10⁵+ lines) | `sys.stdin.buffer.read().split()` |
| Building huge nested loops in pure Python | Vectorize with comprehensions, `zip`, built-ins like `sum`, `max`, `min` |
| `max(dict.values())` every iteration | Cache values if they don't change |
| Modulo arithmetic: `% MOD` is fine, but Python's `pow(x, y, MOD)` is built-in fast pow | Use it for big exponents |
| Comparing strings char-by-char in a loop | Use slicing/`==` which is C-speed |
| Unnecessary copies (slicing in a hot loop) | Pass indices instead of slices |

```python
# Always add to competitive/coding templates:
import sys
sys.setrecursionlimit(10**6)

# Fast reading template:
import sys
def ints(): return list(map(int, sys.stdin.buffer.read().split()))
```

**About Python speed:** Python is ~20–100× slower than C++ in tight loops. For problems with 10⁶+ operations, prefer built-ins (C-speed) over Python loops. The good news: interview constraints are usually lenient enough, and `lru_cache` + `heapq` + `Counter` cover most patterns.

---

## 5. Common Errors When Shifting from C++

1. **`freq[x]++` on a plain dict** → KeyError. Use `Counter`, `defaultdict(int)`, or `freq[x] = freq.get(x, 0) + 1`.
2. **`[[0]*n]*m`** → all rows alias each other. Use `[[0]*n for _ in range(m)]`.
3. **`//` vs `/`** → `/` gives float. Integer division is `//`, but remember it floors (C++ truncates).
4. **`%` with negatives** → Python result takes the sign of the divisor: `-7 % 3 == 2` (C++: `-1`).
5. **`and`/`or`/`not`** — Python doesn't use `&&`, `||`, `!`.
6. **`elif`, not `else if`.** Also `True`/`False` capitalized, `None` not `null`/`NULL`.
7. **Appending mutable objects to results** — `res.append(path[:])` in backtracking, not `res.append(path)`.
8. **Forgetting `self`** as the first parameter of every method — `def insert(self, word):`.
9. **Indentation errors** — mixing tabs and spaces, or wrong nesting after edits.
10. **`range(n-1, -1, -1)`** — reverse loops need all three arguments (start, stop, step). `range(n-1, 0)` gives empty.
11. **`enumerate`/`zip` are lazy** — wrap in `list()` if you need to index the result twice.
12. **Loop variable leaks** — after a loop, the loop variable persists (unlike C++ scoped for). Avoid reusing `i`, `x`, `n` in ways that surprise you.
13. **`heapq` needs the list** — `heapq.heappop(h)`, not `h.heappop()`. And index `h[0]` to peek, there's no `top()`.
14. **`0 <= r < rows`** — chained comparison is valid; don't write `0 <= r && r < rows`.

---

## 6. Quick Reference Tables

### 6.1 Types

| C++ | Python |
|---|---|
| `int` / `long long` | `int` (arbitrary precision) |
| `float` / `double` | `float` |
| `char` | `str` (length 1) |
| `bool` | `bool` |
| `string` | `str` (immutable) |
| `vector<T>` | `list` |
| `array<T, N>` | `tuple` (or list) |
| `pair<A, B>` | `tuple` |
| `unordered_map` | `dict` |
| `map` | `dict` (insertion-ordered) |
| `unordered_set` | `set` |
| `set` (RB-tree) | — no stdlib sorted set; sort a list, or `bisect` |
| `priority_queue` | `heapq` (min-heap only) |
| `queue` | `collections.deque` |
| `stack` | `list` |
| `deque` | `collections.deque` |
| `INT_MAX` | `float('inf')` |
| `INT_MIN` | `float('-inf')` |

### 6.2 Operations

| C++ | Python |
|---|---|
| `v.size()` | `len(v)` |
| `v.empty()` | `not v` |
| `x == NULL` | `x is None` |
| `!x` | `not x` |
| `a && b` | `a and b` |
| `a \|\| b` | `a or b` |
| `x++` | `x += 1` |
| `swap(a, b)` | `a, b = b, a` |
| `max(a, b)` | `max(a, b)` |
| `min(a, b)` | `min(a, b)` |
| `abs(x)` | `abs(x)` |
| `sort(v.begin(), v.end())` | `v.sort()` |
| `reverse(...)` | `v.reverse()` / `v[::-1]` |
| `accumulate` | `sum(iterable, start)` |
| `for (int i = 0; i < n; i++)` | `for i in range(n):` |
| `for (auto x : v)` | `for x in v:` |

### 6.3 Import block for interviews

```python
from collections import defaultdict, deque, Counter, OrderedDict
from functools import lru_cache, cmp_to_key
from itertools import accumulate, combinations, permutations, product
import heapq
import bisect
import sys
sys.setrecursionlimit(10**6)
```

---

## 7. Worked Example — Same Solution, Both Languages

**Two Sum** (pattern: hash map)

```cpp
// C++
vector<int> twoSum(vector<int>& nums, int target) {
    unordered_map<int, int> idx;
    for (int i = 0; i < nums.size(); i++) {
        int need = target - nums[i];
        if (idx.count(need))
            return {idx[need], i};
        idx[nums[i]] = i;
    }
    return {};
}
```
```python
# Python
def twoSum(nums, target):
    idx = {}
    for i, x in enumerate(nums):
        need = target - x
        if need in idx:
            return [idx[need], i]
        idx[x] = i
```

**Sliding Window Maximum** (pattern: monotonic deque)

```cpp
// C++
vector<int> maxSlidingWindow(vector<int>& nums, int k) {
    deque<int> dq;
    vector<int> res;
    for (int i = 0; i < nums.size(); i++) {
        while (!dq.empty() && nums[dq.back()] < nums[i]) dq.pop_back();
        dq.push_back(i);
        if (dq.front() <= i - k) dq.pop_front();
        if (i >= k - 1) res.push_back(nums[dq.front()]);
    }
    return res;
}
```
```python
# Python
from collections import deque

def maxSlidingWindow(nums, k):
    dq = deque()
    res = []
    for i, x in enumerate(nums):
        while dq and nums[dq[-1]] < x:
            dq.pop()
        dq.append(i)
        if dq[0] <= i - k:
            dq.popleft()
        if i >= k - 1:
            res.append(nums[dq[0]])
    return res
```
