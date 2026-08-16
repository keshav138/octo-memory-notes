# Heaps / Priority Queues

Any problem with "k-th", "top-k", "k-way", "median stream", or "always process smallest"
is a heap problem. Default rule: **min-heap of size k** for top-k largest; **max-heap** for
top-k smallest (or negate values into a min-heap).

---

## 1. Kth Largest Element in an Array
**Given:** an array and an integer k
**Expects:** return the k-th largest element
**Pattern:** Min-heap of size k

**Approach:**
1. Push first k elements into a min-heap.
2. For each remaining `x`: if `x > heap[0]` → pop and push `x`.
3. Answer = `heap[0]`.

```python
import heapq
heap = nums[:k]
heapq.heapify(heap)
for x in nums[k:]:
    if x > heap[0]:
        heapq.heapreplace(heap, x)      # pop smallest + push x in one op
return heap[0]
```

**Complexity:** O(n log k) time, O(k) space.

---

## 2. Kth Smallest Element
**Given:** an array and an integer k
**Expects:** return the k-th smallest element
**Pattern:** Max-heap of size k (or negate into min-heap)

```cpp
// C++
priority_queue<int> pq;                 // max-heap, size k
```
```python
# Python — negate values
heapq.heappush(heap, -x)
if len(heap) > k: heapq.heappop(heap)
return -heap[0]
```

**Complexity:** O(n log k) time, O(k) space.

---

## 3. Top K Frequent Elements
**Given:** an array and an integer k
**Expects:** return the k most frequent values
**Pattern:** Frequency map + min-heap of size k on `(freq, val)`

**Approach:** Count frequencies; heap keyed by `(freq, val)`; keep size k; result = heap values.

**Complexity:** O(n log k) time, O(n) space (bucket sort gives O(n)).

---

## 4. Merge K Sorted Lists
**Given:** k sorted linked lists
**Expects:** return them merged into one sorted list
**Pattern:** Min-heap of list heads

**Approach:** Push `(head.val, idx, head)` for each non-null list; repeatedly pop min, append, push its `next`.

**Complexity:** O(N log k) time, `N` = total nodes.

---

## 5. K Closest Points to Origin
**Given:** points and an integer k
**Expects:** return the k points closest to the origin
**Pattern:** Max-heap of size k keyed by distance

**Approach:** `dist = x² + y²` (skip sqrt — monotone); max-heap (or negated min-heap) of size k; pop farthest when full.

**Complexity:** O(n log k) time, O(k) space.

---

## 6. Find Median from Data Stream
**Given:** a stream of numbers
**Expects:** return the median after each insertion
**Pattern:** Two heaps — max-heap of lower half, min-heap of upper half

**Approach:**
1. `lo` (max-heap) holds smaller half, `hi` (min-heap) holds larger half.
2. Insert: push to `lo`, rebalance — move top of `lo` to `hi` when `len(lo) > len(hi) + 1`; move top of `hi` to `lo` when `hi` larger.
3. Median = `lo.top()` if odd total, else `(lo.top() + hi.top()) / 2`.

```python
# Python — negate for max-heap
heappush(lo, -x)
if lo and hi and -lo[0] > hi[0]: heappush(hi, -heappop(lo))
if len(lo) > len(hi) + 1: heappush(hi, -heappop(lo))
if len(hi) > len(lo): heappush(lo, -heappop(hi))
```

**Complexity:** O(log n) per insertion, O(1) median.

---

## 7. Task Scheduler (minimum intervals with cooldown n)
**Given:** task labels and a cooldown n
**Expects:** return the minimum intervals to finish all tasks
**Pattern:** Max-heap of frequencies + idle simulation (or greedy formula)

**Approach:**
1. Max-heap of task counts; process each cooldown cycle of `n+1` slots.
2. Pop most frequent task (deduct 1); after cycle, push back still-positive counts.
3. Add actual slots used (partial last cycle adds only tasks run, not full n+1).

```
min time = max( (maxFreq - 1) * (n + 1) + countOfMaxFreq, len(tasks) )   // formula variant
```

**Complexity:** O(t · n) simulation, O(A) space (formula variant is O(n)).

---

## 8. K-th Largest Element in a Stream
**Given:** a stream of numbers and an integer k
**Expects:** return the k-th largest after each add
**Pattern:** Persistent min-heap of size k

**Approach:** `add(x)`: push; if size > k, pop. Top = k-th largest.

**Complexity:** O(log k) per add.

---

## 9. Last Stone Weight
**Given:** stone weights
**Expects:** return the last remaining weight after repeated smash rules
**Pattern:** Max-heap simulation

**Approach:** Negate into heap; pop two heaviest; if unequal push back difference.

**Complexity:** O(n log n) time.

---

## 10. Reorganize String (no two adjacent same chars)
**Given:** a string
**Expects:** return a rearrangement with no two adjacent equal characters, or ""
**Pattern:** Max-heap by frequency, alternate with cooldown

**Approach:** Pop most frequent char, append; hold it out for one round (cooldown queue/slot); repeat. Fail if heap empties with a held char remaining.

**Complexity:** O(n log A) time.

---

## 11. Smallest Range Covering Elements from K Lists
**Given:** k sorted lists
**Expects:** return the smallest range that includes at least one number from each list
**Pattern:** Min-heap + running max (sliding k-window across lists)

**Approach:** Push first element of each list (with list index); track `maxVal`; repeatedly pop min, update range `[minVal, maxVal]`, push next element from that list.

**Complexity:** O(N log k) time.

---

## 12. Meeting Rooms II (min rooms) — also see [15-intervals.md](15-intervals.md)
**Given:** meeting intervals
**Expects:** return the minimum rooms needed
**Pattern:** Sort by start + min-heap of end times

**Approach:** Sort intervals by start; min-heap of ongoing meetings' end times; if `start >= heap[0]` → pop (reuse room); push end. Answer = max heap size.

**Complexity:** O(n log n) time, O(n) space.

---

## 13. Top K Frequent Words
**Given:** words and an integer k
**Expects:** return the k most frequent words, ties broken lexicographically
**Pattern:** Frequency map + heap with custom comparator (freq desc, lex asc)

```cpp
// C++ — custom comparator on (freq, word)
auto cmp = [](auto& a, auto& b){ return a.first == b.first ? a.second > b.second : a.first < b.first; };
```
```python
# Python — use counter + heapq with (-freq, word)
heapq.nlargest(k, count.keys(), key=lambda w: (-count[w], w))
```

**Complexity:** O(n log k) time.

---

## 14. Kth Smallest Sum in a Matrix (sorted rows)
**Given:** an m×n matrix with sorted rows, and k
**Expects:** return the k-th smallest sum picking one element per row

**Pattern:** BFS on sum space with min-heap

**Approach:** Start with all-zeros index tuple; repeatedly pop smallest sum, push its neighbors (increment one index at a time). k-th pop = answer.

**Complexity:** O(k·m log k) time.

---

## 15. Find K Pairs with Smallest Sums
**Given:** two sorted arrays and k
**Expects:** return the k pairs with the smallest sums
**Pattern:** Min-heap BFS over pair grid

**Approach:** Push `(a0+b0, 0, 0)`; repeatedly pop, record pair, push `(i+1, j)` and `(i, j+1)` (with visited set to dedupe).

**Complexity:** O(k log k) time.

---

## 16. Minimize Max Distance to Gas Station (k extra stations)
**Given:** existing gas stations and k new ones
**Expects:** return the minimized maximum distance between adjacent stations
**Pattern:** Max-heap of segment gains (or answer-space binary search)

**Approach (heap):** For each segment, heap key = `len / parts` (next reduction). Pop max-gain segment, add a station (`parts++`), push back.

**Complexity:** O(k log n) time.

---

## 17. IPO (maximize capital with at most k projects)
**Given:** projects with (capital, profit) and a limit k
**Expects:** return the maximum final capital after at most k projects
**Pattern:** Two heaps — min-heap by capital + max-heap by profit

**Approach:** Sort projects by capital (min-heap); at each step, move all affordable into a max-profit heap; pick best, add profit to capital; repeat k times.

**Complexity:** O(n log n) time.

---

## 18. Sort a Nearly Sorted Array (each element at most k from sorted position)
**Given:** an array where each element is at most k positions from sorted
**Expects:** return the fully sorted array
**Pattern:** Min-heap window of size k+1

**Approach:** Heap of first k+1; repeatedly pop min to output, push next element.

**Complexity:** O(n log k) time.

---

## 19. Sliding Window Median
**Given:** an array and a window size k
**Expects:** return the median of every k-sized window
**Pattern:** Two-heap median + lazy deletion

**Approach:** Two heaps (like Find Median from Data Stream) over window; on slide, mark removed elements with a counter and pop lazily when they reach heap top.

**Complexity:** O(n log n) time.

---

## 20. The Skyline Problem
**Given:** building rectangles
**Expects:** return the skyline outline points
**Pattern:** Sweep line + max-heap of heights

**Approach:**
1. Events: `(x, -h, enter)` / `(x, h, exit)` sorted.
2. Max-heap of active heights; on enter push, on exit mark for lazy delete.
3. Output `(x, current_max)` whenever the max height changes.

**Complexity:** O(n log n) time.

---

## 21. Swim in Rising Water
**Given:** an n×n elevation grid
**Expects:** return the minimum time to swim from (0,0) to (n-1,n-1)
**Pattern:** Min-heap Dijkstra/BFS variant on grid

**Approach:** Start `(0,0)`; pop cell with smallest elevation; expand neighbors; track max elevation on path; answer = max at `(n-1, n-1)`.

**Complexity:** O(n² log n) time.

---

## 22. Furthest Building You Can Reach
**Given:** building heights, bricks and ladders
**Expects:** return the furthest reachable building index
**Pattern:** Max-heap of largest gaps (bricks) / min-heap of smallest gaps (ladders)

**Approach:** For each climb `d`: push into min-heap (use ladder). If heap size > ladders: pop smallest, spend bricks on it. Stop when bricks < 0.

**Complexity:** O(n log L) time.
