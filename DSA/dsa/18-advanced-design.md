# Advanced Design Patterns

The "seen in interviews but doesn't fit a basic category" file: **Union-Find**, **Segment
Tree / Fenwick**, **LFU/LRU caches**, **iterators**, **ordered maps**, and **design-heavy
problems**.

---

## 1. Union-Find (Disjoint Set Union) — template
**Given:** nothing
**Expects:** implement union-find with find/union in O(α(n)) amortized

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
**Given:** an adjacency matrix of cities
**Expects:** return the number of provinces (connected components)
**Pattern:** DSU counting

**Approach:** Union all edges; answer = number of distinct roots.

**Complexity:** O(n²·α) time.

---

## 3. Redundant Connection
**Given:** edges of a tree plus one extra edge
**Expects:** return the extra edge that creates the cycle
**Pattern:** DSU — first edge whose endpoints are already united

**Approach:** Process edges in order; return the edge where `find(u) == find(v)`.

**Complexity:** O(E·α) time.

---

## 4. Accounts Merge (merge accounts by shared emails)
**Given:** accounts with names and email lists
**Expects:** return accounts merged by shared emails
**Pattern:** DSU on emails

**Approach:** Union emails sharing an account; group emails by root; build name + sorted emails per root.

**Complexity:** O(n·k·α + total log total) time.

---

## 5. Number of Islands II (dynamic land additions)
**Given:** a stream of land positions on a grid
**Expects:** return the island count after each addition
**Pattern:** DSU with grid index `r * cols + c`

**Approach:** On each `addLand`: create node; union with existing land neighbors; track component count delta.

**Complexity:** O(k·α) time, k = positions added.

---

## 6. Smallest String With Swaps
**Given:** a string and allowed swap pairs
**Expects:** return the lexicographically smallest reachable string
**Pattern:** DSU to group swappable indices + sort within groups

**Approach:** Union all pairs; group indices per root; sort chars within each group; rebuild string.

**Complexity:** O(n log n) time.

---

## 7. Longest Consecutive Sequence — DSU variant (see [03-hashing.md](03-hashing.md) for the set approach)
**Given:** an unsorted array
**Expects:** return the longest consecutive run using union-find on values

**Approach:** Union `x` with `x+1` if both present; answer = max component size.

**Complexity:** O(n·α) time.

---

## 8. Evaluate Division (a/b = x equations, queries)
**Given:** equations a/b = x and division queries
**Expects:** return the answers to the queries, or -1.0 when inconsistent
**Pattern:** DSU with edge weights (or graph DFS)

**Approach:** Union with weight: `a / b = w` → `parent[a] = b`, `weight[a] = w`; find compresses path multiplying weights; query via `weight[a] / weight[b]` if same root.

```
find(x): if parent[x] != x: root = find(parent[x]); weight[x] *= weight[parent[x]]
```

**Complexity:** O((E + Q)·α) time.

---

## 9. Segment Tree — range sum/min with point update
**Given:** an array
**Expects:** implement range queries and point updates in O(log n) (segment tree)

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
**Given:** an array
**Expects:** implement prefix sums and point updates in O(log n) (Fenwick)

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
**Given:** an array and range queries
**Expects:** return sums over queried ranges (O(1) immutable / O(log n) mutable)
**Pattern:** Fenwick for mutable; prefix array for immutable

**Approach:** Immutable → `prefix[r+1] - prefix[l]`. Mutable → Fenwick.

**Complexity:** O(1) immutable, O(log n) mutable.

---

## 12. Count of Smaller Numbers After Self
**Given:** an array
**Expects:** return for each element the count of smaller elements to its right
**Pattern:** Fenwick over value ranks, right-to-left

**Approach:** Coordinate-compress values; scan right-to-left; `count = prefix(rank-1)`; then `add(rank, 1)`.

**Complexity:** O(n log n) time.

---

## 13. Longest Increasing Subsequence — Fenwick variant
**Given:** an array
**Expects:** return the LIS length in O(n log n) via Fenwick of max
**Pattern:** Fenwick of max over ranks

**Approach:** For each x in order: `best = 1 + max_query(rank-1)`; `update(rank, best)`.

**Complexity:** O(n log n) time.

---

## 14. LRU Cache — see [08-linked-list.md](08-linked-list.md) — hash map + doubly linked list
**Given:** a fixed capacity
**Expects:** implement get/put in O(1), evicting the least recently used key when full

**Approach:** `get` moves node to head; `put` evicts tail node on overflow.

**Complexity:** O(1) per operation.

---

## 15. LFU Cache
**Given:** a fixed capacity
**Expects:** implement a cache evicting the least frequently used (LRU on ties)
**Pattern:** Map key→(value, freq) + freq→ordered dict of keys

**Approach:**
1. `keyMap`: key → (value, freq).
2. `freqMap`: freq → insertion-ordered dict of keys (Python `OrderedDict`; C++ `map<int, list>` + iterator map).
3. `get`: increment freq (move key to freq+1 bucket).
4. `put` over capacity: evict least-frequent, least-recently-used (front of min-freq bucket).

**Complexity:** O(1) per operation.

---

## 16. Design Twitter (news feed)
**Given:** users, tweets and follows
**Expects:** return each user's 10 most recent feed tweets
**Pattern:** User → set of followees + list of tweets; k-way merge of latest tweets

**Approach:**
1. `tweets`: user → list of (timestamp, tweetId), plus a global time counter.
2. `follows`: user → set of followees.
3. `getNewsFeed`: collect last 10 tweets of user + followees, k-way merge via max-heap (newest first).

**Complexity:** O(k log k) per feed, O(1) per post/follow.

---

## 17. Design Hit Counter (hits in last 300s)
**Given:** hits with timestamps
**Expects:** return the number of hits in the last 300 seconds
**Pattern:** Circular buffer or deque of (timestamp, count)

**Approach:** Queue of `(ts, count)`; on `getHits(ts)`: drop entries with `ts - 300 >= timestamp`; sum counts.

**Complexity:** O(1) amortized.

---

## 18. Design Snake Game
**Given:** a grid and food positions
**Expects:** simulate the snake game and return the score
**Pattern:** Deque of body + set of occupied cells

**Approach:** Deque stores body (head at front); on move: compute new head; if food → don't pop tail, score++; else pop tail (free cell). Lose if head hits wall or body.

**Complexity:** O(1) per move.

---

## 19. Design File System (create path, get value)
**Given:** path/value operations
**Expects:** implement createPath and get on a virtual file system
**Pattern:** Trie or nested hash map

**Approach:** `createPath`: walk parents; all must exist; create leaf with value. `get`: walk to leaf.

**Complexity:** O(L) per operation.

---

## 20. Serialize and Deserialize N-ary Tree
**Given:** an N-ary tree
**Expects:** return its string encoding and rebuild from it
**Pattern:** Preorder with children-count marker

**Approach:** Serialize: `val, childCount, [children...]`. Deserialize: recursive consume.

**Complexity:** O(n) time and space.

---

## 21. Flatten Nested List Iterator
**Given:** a nested list of integers
**Expects:** implement an iterator flattening it
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
**Given:** an iterator
**Expects:** wrap it with a peek() that returns the next element without advancing
**Pattern:** Cache next element

**Approach:** Store `self.peeked`; `peek()` returns cache or pulls from underlying iterator; `next()` returns cache if set else underlying next.

**Complexity:** O(1) per operation.

---

## 23. Zigzag Iterator (k lists)
**Given:** k lists
**Expects:** implement an iterator yielding elements round-robin (zigzag)
**Pattern:** Queue of (iterator, listIndex)

**Approach:** Rotate: pop iterator from front, yield its next, push back if not exhausted.

**Complexity:** O(1) per next.

---

## 24. Implement Trie / Word Dictionary — see [14-tries.md](14-tries.md)
**Given:** words to insert
**Expects:** implement insert, search and startsWith in O(word length)

---

## 25. Design a Stack With Increment Operation
**Given:** a stack
**Expects:** add an increment(k, val) operation for the bottom k elements, all O(1)
**Pattern:** Lazy increment array

**Approach:** `inc[i]` stores pending increment for bottom i elements; on `pop`, apply `inc[size-1]` to popped value and propagate `inc[size-2] += inc[size-1]`.

**Complexity:** O(1) per operation.

---

## 26. Design Browser History
**Given:** browser visits
**Expects:** implement visit/back/forward history navigation
**Pattern:** Array + current pointer (truncate on new visit)

**Approach:** Keep list and `cur`; `visit` truncates forward history; `back/forward` clamp pointer.

**Complexity:** O(1) per operation.

---

## 27. Find Median from Data Stream — see [10-heaps.md](10-heaps.md) — two heaps
**Given:** a stream of numbers
**Expects:** return the median after each insertion (two heaps)

**Approach:** max-heap (lower half) + min-heap (upper half), balanced sizes.

---

## 28. Moving Average from Data Stream
**Given:** a stream of numbers and a window size
**Expects:** return the moving average after each next()
**Pattern:** Fixed window queue + running sum

**Approach:** Deque of size k; `sum / len`.

**Complexity:** O(1) per next.

---

## 29. Design Circular Deque
**Given:** a capacity k
**Expects:** implement a circular deque with O(1) front/back operations
**Pattern:** Array + head/tail pointers with modular arithmetic

**Approach:** Insert front: `head = (head - 1) % cap`; insert back: `tail = (tail + 1) % cap`; track size for full/empty.

**Complexity:** O(1) per operation.

---

## 30. Time-Based Key-Value Store — see [03-hashing.md](03-hashing.md) — map + binary search
**Given:** set(key, timestamp, value) and get(key, timestamp)
**Expects:** return the value stored at the latest timestamp ≤ the query timestamp

---

## 31. All O(1) Data Structure (inc/dec/getMaxKey/getMinKey)
**Given:** nothing
**Expects:** implement inc/dec/getMaxKey/getMinKey all in O(1)
**Pattern:** Key → count, count → doubly linked list of key sets

**Approach:** Hash maps + linked count buckets; inc/dec move keys between buckets; max/min key from head/tail bucket.

**Complexity:** O(1) per operation.

---

## 32. Design In-Memory File System (ls/mkdir/addContent/readContent)
**Given:** ls/mkdir/addContent/readContent commands
**Expects:** implement an in-memory file system
**Pattern:** Trie of path nodes (dirs and files)

**Approach:** Node = dict of children + optional content string; split paths on `/`.

**Complexity:** O(path length) per operation.

---

## 33. Rate Limiter (token bucket / fixed window)
**Given:** requests per client with a limit
**Expects:** implement a rate limiter (token bucket / fixed window)
**Pattern:** Queue of timestamps per client

**Approach:** On request, drop expired timestamps; if len < limit → allow and append.

**Complexity:** O(1) amortized per request.

---

## 34. Implement RandomizedSet — see [03-hashing.md](03-hashing.md) — map + array swap-remove
**Given:** nothing
**Expects:** implement a set with insert, remove and getRandom in average O(1)

---

## 35. Data Stream as Disjoint Intervals — see [15-intervals.md](15-intervals.md) — sorted set + merge neighbors
**Given:** a stream of numbers
**Expects:** return the disjoint intervals covering all seen numbers

---

## 36. Design Search Autocomplete — see [14-tries.md](14-tries.md) — trie with cached top-k
**Given:** historical sentences with frequencies
**Expects:** return the top-3 suggestions for each typed prefix

---

## 37. Design an Expression Tree With Evaluate Function
**Given:** postfix tokens
**Expects:** build an expression tree and return its evaluated value
**Pattern:** Postfix construction (stack) + polymorphic evaluate

**Approach:** Build tree from postfix tokens (operands push, operators pop two children); `evaluate()` recurses: `left.evaluate() op right.evaluate()`.

**Complexity:** O(n) build, O(n) evaluate.

---

## 38. Design Underground System (check-in/check-out + average time)
**Given:** check-in/check-out events
**Expects:** return the average time between two stations
**Pattern:** Two maps: id → (station, t); (start, end) → (total, count)

**Approach:** Check-out computes trip time, updates aggregate; average = total/count.

**Complexity:** O(1) per operation.

---

## 39. Design Parking System
**Given:** slots per car type
**Expects:** implement addCar returning true while slots remain
**Pattern:** Counter array per car type

**Approach:** Decrement count on addCar if > 0.

**Complexity:** O(1).

---

## 40. K-th Ancestor of a Tree Node
**Given:** a rooted tree and ancestor queries
**Expects:** return the k-th ancestor of a node in O(log n)
**Pattern:** Binary lifting

**Approach:** `up[k][v]` = 2^k-th ancestor of v; `up[0][v] = parent[v]`; `up[k][v] = up[k-1][up[k-1][v]]`. Query: jump k in binary.

```
up[k][v] = up[k-1][ up[k-1][v] ]
```

**Complexity:** O(n log n) preprocess, O(log n) per query.
