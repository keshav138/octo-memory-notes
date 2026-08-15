# Advanced Design Patterns

The "seen in interviews but doesn't fit a basic category" file: **Union-Find**, **Segment
Tree / Fenwick**, **LFU/LRU caches**, **iterators**, **ordered maps**, and **design-heavy
problems**.

---

## 1. Union-Find (Disjoint Set Union) — template

```cpp
// C++
vector<int> parent, rank;
int find(int x) {
    return parent[x] == x ? x : parent[x] = find(parent[x]);   // path compression
}
void unite(int a, int b) {
    int ra = find(a), rb = find(b);
    if (ra == rb) return;
    if (rank[ra] < rank[rb]) swap(ra, rb);                     // union by rank
    parent[rb] = ra;
    if (rank[ra] == rank[rb]) rank[ra]++;
}
```
```python
# Python
parent = list(range(n))
rank = [0] * n

def find(x):
    while parent[x] != x:
        parent[x] = parent[parent[x]]      # path halving
        x = parent[x]
    return x

def union(a, b):
    ra, rb = find(a), find(b)
    if ra == rb: return
    if rank[ra] < rank[rb]: ra, rb = rb, ra
    parent[rb] = ra
    if rank[ra] == rank[rb]: rank[ra] += 1
```

**Complexity:** O(α(n)) amortized per operation.

---

## 2. Number of Provinces / Connected Components
**Pattern:** DSU counting

**Approach:** Union all edges; answer = number of distinct roots.

**Complexity:** O(n²·α) time.

---

## 3. Redundant Connection
**Pattern:** DSU — first edge whose endpoints are already united

**Approach:** Process edges in order; return the edge where `find(u) == find(v)`.

**Complexity:** O(E·α) time.

---

## 4. Accounts Merge (merge accounts by shared emails)
**Pattern:** DSU on emails

**Approach:** Union emails sharing an account; group emails by root; build name + sorted emails per root.

**Complexity:** O(n·k·α + total log total) time.

---

## 5. Number of Islands II (dynamic land additions)
**Pattern:** DSU with grid index `r * cols + c`

**Approach:** On each `addLand`: create node; union with existing land neighbors; track component count delta.

**Complexity:** O(k·α) time, k = positions added.

---

## 6. Smallest String With Swaps
**Pattern:** DSU to group swappable indices + sort within groups

**Approach:** Union all pairs; group indices per root; sort chars within each group; rebuild string.

**Complexity:** O(n log n) time.

---

## 7. Longest Consecutive Sequence — DSU variant (see [03-hashing.md](03-hashing.md) for the set approach)

**Approach:** Union `x` with `x+1` if both present; answer = max component size.

**Complexity:** O(n·α) time.

---

## 8. Evaluate Division (a/b = x equations, queries)
**Pattern:** DSU with edge weights (or graph DFS)

**Approach:** Union with weight: `a / b = w` → `parent[a] = b`, `weight[a] = w`; find compresses path multiplying weights; query via `weight[a] / weight[b]` if same root.

```
find(x): if parent[x] != x: root = find(parent[x]); weight[x] *= weight[parent[x]]
```

**Complexity:** O((E + Q)·α) time.

---

## 9. Segment Tree — range sum/min with point update

```cpp
// C++ — iterative (AtCoder style) or recursive
// Recursive build: tree[node] = tree[2*node] + tree[2*node+1]
// Update: descend to leaf, recompute upward
// Query: collect partial segments [l, r]
```
```python
# Python — recursive
def build(node, l, r):
    if l == r: tree[node] = a[l]; return
    m = (l + r) // 2
    build(2*node, l, m); build(2*node+1, m+1, r)
    tree[node] = tree[2*node] + tree[2*node+1]

def query(node, l, r, ql, qr):
    if ql <= l and r <= qr: return tree[node]        # full cover
    if qr < l or r < ql: return 0                     # no overlap
    m = (l + r) // 2
    return query(2*node, l, m, ql, qr) + query(2*node+1, m+1, r, ql, qr)
```

**Complexity:** O(log n) per update/query, O(n) build.

---

## 10. Fenwick Tree (BIT) — prefix sums with point update

```python
def add(i, delta):          # 1-indexed
    while i <= n:
        bit[i] += delta
        i += i & -i

def sum(i):                 # prefix sum [1..i]
    s = 0
    while i > 0:
        s += bit[i]
        i -= i & -i
    return s
```

**Use when:** prefix sums with updates, inversion counts, count-of-smaller-after-self.

**Complexity:** O(log n) per operation, less memory than segment tree.

---

## 11. Range Sum Query (mutable / immutable)
**Pattern:** Fenwick for mutable; prefix array for immutable

**Approach:** Immutable → `prefix[r+1] - prefix[l]`. Mutable → Fenwick.

**Complexity:** O(1) immutable, O(log n) mutable.

---

## 12. Count of Smaller Numbers After Self
**Pattern:** Fenwick over value ranks, right-to-left

**Approach:** Coordinate-compress values; scan right-to-left; `count = prefix(rank-1)`; then `add(rank, 1)`.

**Complexity:** O(n log n) time.

---

## 13. Longest Increasing Subsequence — Fenwick variant
**Pattern:** Fenwick of max over ranks

**Approach:** For each x in order: `best = 1 + max_query(rank-1)`; `update(rank, best)`.

**Complexity:** O(n log n) time.

---

## 14. LRU Cache — see [08-linked-list.md](08-linked-list.md) — hash map + doubly linked list

**Approach:** `get` moves node to head; `put` evicts tail node on overflow.

**Complexity:** O(1) per operation.

---

## 15. LFU Cache
**Pattern:** Map key→(value, freq) + freq→ordered dict of keys

**Approach:**
1. `keyMap`: key → (value, freq).
2. `freqMap`: freq → insertion-ordered dict of keys (Python `OrderedDict`; C++ `map<int, list>` + iterator map).
3. `get`: increment freq (move key to freq+1 bucket).
4. `put` over capacity: evict least-frequent, least-recently-used (front of min-freq bucket).

**Complexity:** O(1) per operation.

---

## 16. Design Twitter (news feed)
**Pattern:** User → set of followees + list of tweets; k-way merge of latest tweets

**Approach:**
1. `tweets`: user → list of (timestamp, tweetId), plus a global time counter.
2. `follows`: user → set of followees.
3. `getNewsFeed`: collect last 10 tweets of user + followees, k-way merge via max-heap (newest first).

**Complexity:** O(k log k) per feed, O(1) per post/follow.

---

## 17. Design Hit Counter (hits in last 300s)
**Pattern:** Circular buffer or deque of (timestamp, count)

**Approach:** Queue of `(ts, count)`; on `getHits(ts)`: drop entries with `ts - 300 >= timestamp`; sum counts.

**Complexity:** O(1) amortized.

---

## 18. Design Snake Game
**Pattern:** Deque of body + set of occupied cells

**Approach:** Deque stores body (head at front); on move: compute new head; if food → don't pop tail, score++; else pop tail (free cell). Lose if head hits wall or body.

**Complexity:** O(1) per move.

---

## 19. Design File System (create path, get value)
**Pattern:** Trie or nested hash map

**Approach:** `createPath`: walk parents; all must exist; create leaf with value. `get`: walk to leaf.

**Complexity:** O(L) per operation.

---

## 20. Serialize and Deserialize N-ary Tree
**Pattern:** Preorder with children-count marker

**Approach:** Serialize: `val, childCount, [children...]`. Deserialize: recursive consume.

**Complexity:** O(n) time and space.

---

## 21. Flatten Nested List Iterator
**Pattern:** Stack of iterators

**Approach:** Stack holds iterators; `next()`: pop ints; on nested list push its iterator.

```python
class NestedIterator:
    def __init__(self, nestedList):
        self.stack = [iter(nestedList)]
        self.nxt = None
    def next(self):
        val = self.nxt; self.nxt = None; return val
    def hasNext(self):
        while self.stack:
            try: item = next(self.stack[-1])
            except StopIteration: self.stack.pop(); continue
            if item.isInteger(): self.nxt = item.getInteger(); return True
            self.stack.append(iter(item.getList()))
        return False
```

**Complexity:** O(1) amortized per operation.

---

## 22. Peeking Iterator
**Pattern:** Cache next element

**Approach:** Store `self.peeked`; `peek()` returns cache or pulls from underlying iterator; `next()` returns cache if set else underlying next.

**Complexity:** O(1) per operation.

---

## 23. Zigzag Iterator (k lists)
**Pattern:** Queue of (iterator, listIndex)

**Approach:** Rotate: pop iterator from front, yield its next, push back if not exhausted.

**Complexity:** O(1) per next.

---

## 24. Implement Trie / Word Dictionary — see [14-tries.md](14-tries.md)

---

## 25. Design a Stack With Increment Operation
**Pattern:** Lazy increment array

**Approach:** `inc[i]` stores pending increment for bottom i elements; on `pop`, apply `inc[size-1]` to popped value and propagate `inc[size-2] += inc[size-1]`.

**Complexity:** O(1) per operation.

---

## 26. Design Browser History
**Pattern:** Array + current pointer (truncate on new visit)

**Approach:** Keep list and `cur`; `visit` truncates forward history; `back/forward` clamp pointer.

**Complexity:** O(1) per operation.

---

## 27. Find Median from Data Stream — see [10-heaps.md](10-heaps.md) — two heaps

**Approach:** max-heap (lower half) + min-heap (upper half), balanced sizes.

---

## 28. Moving Average from Data Stream
**Pattern:** Fixed window queue + running sum

**Approach:** Deque of size k; `sum / len`.

**Complexity:** O(1) per next.

---

## 29. Design Circular Deque
**Pattern:** Array + head/tail pointers with modular arithmetic

**Approach:** Insert front: `head = (head - 1) % cap`; insert back: `tail = (tail + 1) % cap`; track size for full/empty.

**Complexity:** O(1) per operation.

---

## 30. Time-Based Key-Value Store — see [03-hashing.md](03-hashing.md) — map + binary search

---

## 31. All O(1) Data Structure (inc/dec/getMaxKey/getMinKey)
**Pattern:** Key → count, count → doubly linked list of key sets

**Approach:** Hash maps + linked count buckets; inc/dec move keys between buckets; max/min key from head/tail bucket.

**Complexity:** O(1) per operation.

---

## 32. Design In-Memory File System (ls/mkdir/addContent/readContent)
**Pattern:** Trie of path nodes (dirs and files)

**Approach:** Node = dict of children + optional content string; split paths on `/`.

**Complexity:** O(path length) per operation.

---

## 33. Rate Limiter (token bucket / fixed window)
**Pattern:** Queue of timestamps per client

**Approach:** On request, drop expired timestamps; if len < limit → allow and append.

**Complexity:** O(1) amortized per request.

---

## 34. Implement RandomizedSet — see [03-hashing.md](03-hashing.md) — map + array swap-remove

---

## 35. Data Stream as Disjoint Intervals — see [15-intervals.md](15-intervals.md) — sorted set + merge neighbors

---

## 36. Design Search Autocomplete — see [14-tries.md](14-tries.md) — trie with cached top-k

---

## 37. Design an Expression Tree With Evaluate Function
**Pattern:** Postfix construction (stack) + polymorphic evaluate

**Approach:** Build tree from postfix tokens (operands push, operators pop two children); `evaluate()` recurses: `left.evaluate() op right.evaluate()`.

**Complexity:** O(n) build, O(n) evaluate.

---

## 38. Design Underground System (check-in/check-out + average time)
**Pattern:** Two maps: id → (station, t); (start, end) → (total, count)

**Approach:** Check-out computes trip time, updates aggregate; average = total/count.

**Complexity:** O(1) per operation.

---

## 39. Design Parking System
**Pattern:** Counter array per car type

**Approach:** Decrement count on addCar if > 0.

**Complexity:** O(1).

---

## 40. K-th Ancestor of a Tree Node
**Pattern:** Binary lifting

**Approach:** `up[k][v]` = 2^k-th ancestor of v; `up[0][v] = parent[v]`; `up[k][v] = up[k-1][up[k-1][v]]`. Query: jump k in binary.

```
up[k][v] = up[k-1][ up[k-1][v] ]
```

**Complexity:** O(n log n) preprocess, O(log n) per query.
