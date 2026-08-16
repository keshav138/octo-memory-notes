# Intervals

The universal first step: **sort by start (or by end, depending on the goal)**.
- By **start** → merging, insertion, coverage.
- By **end** → scheduling/maximum non-overlapping count.

Sweep-line with a heap handles overlap-depth problems (meeting rooms II, skyline).

---

## 1. Merge Intervals
**Given:** a list of intervals
**Expects:** return the merged list of all overlapping intervals
**Pattern:** Sort by start + sweep

**Approach:**
```python
intervals.sort()
res = []
for s, e in intervals:
    if res and s <= res[-1][1]:
        res[-1][1] = max(res[-1][1], e)
    else:
        res.append([s, e])
```

**Complexity:** O(n log n) time.

---

## 2. Insert Interval
**Given:** a sorted list of intervals and one new interval
**Expects:** return the list with the new interval merged in
**Pattern:** Three phases — before / merge / after

**Approach:** Append all intervals ending before `new.start`; merge overlapping; append the rest.

**Complexity:** O(n) time.

---

## 3. Non-overlapping Intervals (min removals)
**Given:** a list of intervals
**Expects:** return the minimum removals needed to make them non-overlapping
**Pattern:** Sort by **end**, keep max compatible set

**Approach:** Greedy: keep interval if `start >= last_end`; answer = `n - kept`.

**Complexity:** O(n log n) time.

---

## 4. Meeting Rooms (can one person attend all?)
**Given:** meeting intervals
**Expects:** return true if one person can attend all without overlap
**Pattern:** Sort by start, check overlap

**Approach:** Sort; if any `cur.start < prev.end` → false.

**Complexity:** O(n log n) time.

---

## 5. Meeting Rooms II (minimum rooms)
**Given:** meeting intervals
**Expects:** return the minimum rooms needed
**Pattern:** Sort by start + min-heap of end times

**Approach:**
1. Sort by start.
2. Min-heap of end times; for each meeting, if `start >= heap[0]` → `heapreplace`, else push.
3. Answer = max heap size (or len at end).

```python
intervals.sort()
heap = []
for s, e in intervals:
    if heap and s >= heap[0]:
        heapq.heapreplace(heap, e)     # reuse room
    else:
        heapq.heappush(heap, e)        # new room
return len(heap)
```

**Complexity:** O(n log n) time, O(n) space.

---

## 6. Minimum Number of Arrows to Burst Balloons
**Given:** balloon horizontal ranges
**Expects:** return the minimum arrows to burst all balloons
**Pattern:** Sort by **end**, cluster overlapping

**Approach:** Sort by end; new arrow when `start > current_arrow_pos` (set to this end).

**Complexity:** O(n log n) time.

---

## 7. Interval List Intersections (two sorted lists)
**Given:** two sorted lists of intervals
**Expects:** return the intersections of all overlapping pairs
**Pattern:** Two pointers, intersect = overlap region

**Approach:**
```python
lo = max(A[i].start, B[j].start)
hi = min(A[i].end, B[j].end)
if lo <= hi: res.append([lo, hi])
# advance the list whose interval ends first
if A[i].end < B[j].end: i += 1 else: j += 1
```

**Complexity:** O(n + m) time.

---

## 8. Employee Free Time (common free slots)
**Given:** each employee's busy intervals
**Expects:** return the common free intervals across all employees
**Pattern:** Flatten + merge + gaps (or sweep with heap)

**Approach:** Collect all intervals, merge; free time = gaps between merged intervals.

**Complexity:** O(n log n) time.

---

## 9. Max Number of Events That Can Be Attended (one per day)
**Given:** events with [start, end] days
**Expects:** return the maximum events attendable, one per day
**Pattern:** Sort by start + min-heap by end (day-by-day sweep)

**Approach:**
1. Sort events by start. For each day `d`: push all events starting at `d` (heap by end).
2. Pop events whose end < d; attend one event (pop) if any.

**Complexity:** O(n log n) time.

---

## 10. Minimum Interval to Include Each Query
**Given:** intervals and a list of queries
**Expects:** return for each query the size of the smallest interval containing it
**Pattern:** Sort queries + min-heap of (length, end)

**Approach:**
1. Sort intervals by start; sort queries.
2. For each query: push all intervals with `start <= query`; pop those with `end < query`.
3. Heap top = smallest length covering this query; else -1.

**Complexity:** O((n + q) log n) time.

---

## 11. The Skyline Problem
**Given:** building rectangles
**Expects:** return the skyline outline points
**Pattern:** Sweep line with events + max-heap — `#heap`

**Approach:**
1. Events `(x, -h, start)` and `(x, h, end)`, sorted.
2. Maintain max-heap of active heights (lazy deletion on ends).
3. Record `(x, top)` whenever the max height changes.

**Complexity:** O(n log n) time.

---

## 12. Car Pooling
**Given:** trips (from, to, capacity)
**Expects:** return true if all trips are possible within capacity
**Pattern:** Difference array (or sweep events)

**Approach:** `diff[from] += cap; diff[to] -= cap`; prefix sum must never exceed capacity.

**Complexity:** O(n + maxTrip) time, O(maxTrip) space.

---

## 13. Find Right Interval (next interval with start >= my end)
**Given:** intervals
**Expects:** return for each interval the index of the interval with the smallest start ≥ its end
**Pattern:** Sort starts + binary search per interval

**Approach:** Map start → index; sorted starts; `bisect_left(starts, end)` gives the right interval.

**Complexity:** O(n log n) time.

---

## 14. Merge Intervals with Gaps / Add Bold Tag in String
**Given:** a string and a word list
**Expects:** return the string with <b> tags around all covered match regions
**Pattern:** Merge + mask marking (interval concepts on string)

**Approach:** Find all match intervals, merge them, mark mask positions, wrap `<b>` tags around mask segments.

**Complexity:** O(n·m) or O(n + m) with KMP per word.

---

## 15. Minimum Number of Platforms (train variant of Meeting Rooms II)
**Given:** train arrival and departure times
**Expects:** return the minimum platforms needed
**Pattern:** Sort all events (arrival +1, departure -1) or two sorted arrays + two pointers

**Approach:** Two pointers over sorted arrivals and departures; `platforms++` on arrival before next departure, `--` otherwise; track max.

**Complexity:** O(n log n) time.

---

## 16. Remove Covered Intervals (interval fully inside another)
**Given:** intervals
**Expects:** return the count of intervals not fully covered by another
**Pattern:** Sort by start asc, end desc; keep track of max end

**Approach:** For each interval (in order): if `end <= max_end` → covered, skip; else keep and update `max_end`.

**Complexity:** O(n log n) time.

---

## 17. Partition Array into Non-overlapping Intervals / Video Stitching
**Given:** video clips and a target time T
**Expects:** return the minimum clips to cover [0, T], or -1
**Pattern:** Convert to intervals + greedy coverage (jump game)

**Approach:** Build `maxReach[clipStart] = max clipEnd`; greedily extend coverage from 0 to T counting jumps.

**Complexity:** O(n + T) time.

---

## 18. My Calendar I (book if no overlap)
**Given:** booking requests
**Expects:** implement a calendar accepting only non-overlapping bookings
**Pattern:** Sorted list + binary search (or BST)

**Approach:** Find neighbors via `bisect` on starts; check `prev.end <= start` and `end <= next.start`.

**Complexity:** O(log n) per booking with sorted container, O(n) with list insertion.

---

## 19. My Calendar II (allow double, reject triple booking)
**Given:** booking requests
**Expects:** implement a calendar allowing double but rejecting triple booking
**Pattern:** Track double-booked intervals separately

**Approach:** Bookings list + overlaps list. For new event: if it overlaps any interval in `overlaps` → reject; else add its overlaps with `bookings` into `overlaps`, then add to `bookings`.

**Complexity:** O(n) per booking, O(n) space.

---

## 20. My Calendar III (max k-booking at any time)
**Given:** booking requests
**Expects:** return the maximum concurrent bookings at any time
**Pattern:** Difference array on boundaries

**Approach:** `diff[start]++; diff[end]--`; max prefix sum = k.

**Complexity:** O(n²) naive, O(n log n) with sorted map.

---

## 21. Range Module (add/remove/query ranges)
**Given:** range add/remove/query operations
**Expects:** implement a module tracking covered ranges
**Pattern:** Sorted disjoint interval set (treemap)

**Approach:** Use an ordered map (`std::map` / sorted list) of disjoint intervals; addRange merges overlapping, removeRange splits/truncates, queryRange checks containment.

**Complexity:** O(n) per operation with sorted list, O(log n) with balanced BST.

---

## 22. Data Stream as Disjoint Intervals
**Given:** a stream of numbers
**Expects:** return the disjoint intervals covering all seen numbers
**Pattern:** Sorted set + merge neighbors on add

**Approach:** On `addNum(v)`: if `v-1` and `v+1` both exist → merge three; one exists → extend; none → new interval.

**Complexity:** O(log n) per add with ordered set.

---

## 23. Course Schedule via Interval Count (busiest time) — see also [11-graphs.md](11-graphs.md)
**Given:** course intervals
**Expects:** return the maximum overlap count (rooms needed)
**Pattern:** Sweep line

**Approach:** Events at start (+1) / end (-1); sort; max running sum = min rooms needed (equivalent to topo/cycle check for schedule feasibility).

**Complexity:** O(n log n) time.
