# Graphs

Default toolbox: **BFS** (shortest path in unweighted), **DFS** (cycles, topo, components),
**Dijkstra** (weighted shortest path), **Union-Find** (dynamic connectivity, cycle detection in
undirected graphs), **Topological sort** (DAG ordering).

Representation: adjacency list is default; matrix only for dense or grid problems.

---

## 1. Number of Islands
**Given:** a 2D grid of '1's and '0's
**Expects:** return the number of land islands
**Pattern:** Grid DFS/BFS flood fill

**Approach:** For each `'1'` cell not visited: BFS/DFS marking all connected land; `count++`.

**Complexity:** O(m·n) time, O(m·n) space.

---

## 2. Max Area of Island
**Given:** a 2D grid of '1's and '0's
**Expects:** return the area of the largest island
**Pattern:** Flood fill returning size

**Approach:** DFS returns `1 + Σ dfs(neighbors)`; track max.

**Complexity:** O(m·n) time, O(m·n) space.

---

## 3. Clone Graph
**Given:** a graph node
**Expects:** return a deep copy of the graph
**Pattern:** DFS/BFS with old→new map

**Approach:** If node in map, return clone; else create clone, map it, recurse neighbors.

**Complexity:** O(V + E) time, O(V) space.

---

## 4. Course Schedule (can finish all? — cycle in directed graph)
**Given:** n courses and prerequisite pairs
**Expects:** return true if all courses can be finished
**Pattern:** Topological sort (Kahn's BFS) or DFS cycle detection

**Approach (Kahn):**
1. Build adjacency + indegree.
2. Queue all indegree-0 nodes; process, decrement neighbors, enqueue new zeros.
3. If processed count == numCourses → possible.

**Complexity:** O(V + E) time, O(V + E) space.

---

## 5. Course Schedule II (return the order)
**Given:** n courses and prerequisite pairs
**Expects:** return one valid course order, or [] if impossible
**Pattern:** Topological sort returning order

**Approach:** Same Kahn's algorithm; the dequeue order is one valid topo order.

**Complexity:** O(V + E) time.

---

## 6. Alien Dictionary (order of letters from sorted words)
**Given:** a sorted list of words in an alien language
**Expects:** return the letter order, or "" if invalid
**Pattern:** Build graph from adjacent word pairs + topo sort

**Approach:**
1. For each adjacent pair `w1, w2`: first differing char `c1 ≠ c2` → edge `c1 → c2`; break.
   (If `w2` is prefix of `w1`, invalid.)
2. Kahn's topo sort; if cycle → invalid (return "").

**Complexity:** O(total chars) time, O(A) space (A = 26).

---

## 7. Rotting Oranges (minutes until all rot)
**Given:** a grid of fresh/rotten oranges
**Expects:** return minutes until all rot, or -1 if impossible
**Pattern:** Multi-source BFS

**Approach:** Queue all initially rotten; BFS levels = minutes; count fresh remaining.

**Complexity:** O(m·n) time, O(m·n) space.

---

## 8. Walls and Gates (distance to nearest gate)
**Given:** a grid of rooms, gates and walls
**Expects:** fill each room with its distance to the nearest gate
**Pattern:** Multi-source BFS from gates

**Approach:** Seed queue with all gates (distance 0); BFS outward updating `INF` cells.

**Complexity:** O(m·n) time, O(m·n) space.

---

## 9. Pacific Atlantic Water Flow
**Given:** a height grid
**Expects:** return cells from which water can flow to both oceans
**Pattern:** Reverse BFS/DFS from both oceans

**Approach:** DFS from all Pacific-border cells (mark reachable), same for Atlantic; answer = cells in both sets. Reverse condition: water flows uphill in reverse (neighbor height >= current).

**Complexity:** O(m·n) time, O(m·n) space.

---

## 10. Surrounded Regions (flip O's not connected to border)
**Given:** an X/O board
**Expects:** flip all O regions fully surrounded by X to X
**Pattern:** Border DFS + mark

**Approach:** DFS from border `O`s (mark safe); flip all unmarked `O`s to `X`.

**Complexity:** O(m·n) time, O(m·n) space.

---

## 11. Number of Connected Components (undirected)
**Given:** n nodes and an edge list
**Expects:** return the number of connected components
**Pattern:** Union-Find or DFS counting

**Approach (DSU):** Union every edge; answer = count of distinct roots. (DFS counting works too.)

**Complexity:** O(V + E·α(V)) with DSU, O(V + E) with DFS.

---

## 12. Graph Valid Tree (n-1 edges + connected)
**Given:** n nodes and an edge list
**Expects:** return true if the graph is a valid tree
**Pattern:** Union-Find cycle check or DFS

**Approach:** A graph is a tree iff `edges == n-1` and no cycle (union finds both ends in same set) — or DFS from 0 visits all nodes with no back edge.

**Complexity:** O(V + E) time.

---

## 13. Redundant Connection (find edge that creates cycle)
**Given:** edges of a tree plus one extra edge
**Expects:** return the extra edge that creates the cycle
**Pattern:** Union-Find, first edge with both ends already connected

**Approach:** Union edges in order; return the first edge whose endpoints share a root.

**Complexity:** O(E·α(V)) time.

---

## 14. Network Delay Time (time for signal to reach all nodes)
**Given:** directed weighted edges and a source node
**Expects:** return the time for a signal to reach all nodes, or -1
**Pattern:** Dijkstra

**Approach:** Dijkstra from source; answer = max(dist) (or -1 if any node unreachable).

**Complexity:** O(E log V) time.

---

## 15. Cheapest Flights Within K Stops
**Given:** flights (u, v, price), src, dst and max stops k
**Expects:** return the cheapest price with at most k stops, or -1
**Pattern:** Bellman-Ford with exactly k+1 relaxations (or BFS levels)

**Approach:**
1. `dist[src] = 0`; repeat `k+1` times: relax all edges from a **copy** of dist (prevents using multiple edges in one pass).
2. Answer = `dist[dst]` or -1.

```
for _ in range(k + 1):
    temp = dist[:]
    for u, v, w in flights:
        if dist[u] != inf: temp[v] = min(temp[v], dist[u] + w)
    dist = temp
```

**Complexity:** O(k·E) time, O(V) space.

---

## 16. Dijkstra Template (weighted shortest path)
**Given:** a weighted graph and a source
**Expects:** return shortest distances to all nodes (Dijkstra template)

```cpp
// C++
priority_queue<pair<int,int>, vector<pair<int,int>>, greater<>> pq; // (dist, node)
```
```python
# Python
heap = [(0, src)]                     # (dist, node)
dist = {src: 0}
while heap:
    d, u = heapq.heappop(heap)
    if d > dist[u]: continue          # stale entry
    for v, w in adj[u]:
        if d + w < dist.get(v, inf):
            dist[v] = d + w
            heapq.heappush(heap, (d + w, v))
```

**Complexity:** O((V + E) log V) time.

---

## 17. Word Ladder (shortest transformation chain)
**Given:** beginWord, endWord and a word list
**Expects:** return the length of the shortest transformation chain
**Pattern:** BFS on wildcard patterns

**Approach:** Preprocess `h*t → [hot, hit, ...]` pattern map; BFS from beginWord; answer = levels.

**Complexity:** O(n·L²) time (or O(n·L·A) for the brute-force neighbor scan).

---

## 18. Word Ladder II (all shortest paths)
**Given:** beginWord, endWord and a word list
**Expects:** return all shortest transformation sequences
**Pattern:** BFS to build DAG of shortest paths + DFS to reconstruct

**Approach:** BFS level-by-level recording parents; then backtrack from endWord to beginWord collecting paths.

**Complexity:** O(n·L² + paths) time.

---

## 19. Minimum Spanning Tree (MST) — via Kruskal
**Given:** weighted edges of a connected graph
**Expects:** return the minimum spanning tree cost (Kruskal)
**Pattern:** Sort edges + Union-Find

**Approach:** Sort edges by weight; add edge if endpoints in different components; stop at `V-1` edges.

**Complexity:** O(E log E) time.

---

## 20. Shortest Path in Binary Matrix (8-directional grid)
**Given:** a 0/1 grid with 8-direction movement
**Expects:** return the shortest path length from top-left to bottom-right
**Pattern:** BFS on grid

**Approach:** Standard BFS with 8 neighbors; level = distance.

**Complexity:** O(m·n) time.

---

## 21. Number of Provinces
**Given:** an adjacency matrix of cities
**Expects:** return the number of provinces (connected components)
**Pattern:** DSU or DFS over adjacency matrix

**Approach:** Union connected cities; count distinct roots.

**Complexity:** O(n²) time.

---

## 22. Reconstruct Itinerary (Eulerian path, lexicographically smallest)
**Given:** airline tickets [from, to]
**Expects:** return the lexicographically smallest valid itinerary
**Pattern:** Hierholzer's algorithm (DFS + reverse post-order)

**Approach:**
1. Build adjacency sorted reverse (or min-heap per airport).
2. DFS: while `adj[u]` non-empty, pop smallest next airport and recurse.
3. Append node post-visit; answer = reversed list.

**Complexity:** O(E log E) time.

---

## 23. Is Graph Bipartite?
**Given:** a graph
**Expects:** return true if it can be 2-colored (bipartite)
**Pattern:** BFS/DFS 2-coloring

**Approach:** Color each node 0/1; neighbors must get opposite color; conflict → not bipartite.

**Complexity:** O(V + E) time.

---

## 24. Snakes and Ladders
**Given:** a snakes-and-ladders board
**Expects:** return the minimum moves to reach the last square
**Pattern:** BFS with board coordinate mapping

**Approach:** Convert 1D label to `(r, c)` via boustrophedon formula; BFS from 1 to n².

```
row = (n-1) - (pos-1)//n
col = ((pos-1)//n) % 2 == 0 ? (pos-1)%n : n-1-(pos-1)%n
```

**Complexity:** O(n²) time.

---

## 25. Minimum Height Trees
**Given:** tree edges
**Expects:** return the roots that minimize the tree's height
**Pattern:** Topological peeling of leaves

**Approach:** Repeatedly remove leaves (degree-1 nodes) until ≤ 2 nodes remain; those are the roots with minimum height.

**Complexity:** O(V + E) time.

---

## 26. Detect Cycle in Directed Graph
**Given:** a directed graph
**Expects:** return true if it contains a cycle
**Pattern:** DFS 3-color (white/gray/black) or Kahn's

**Approach (3-color):** Gray = in current recursion stack; hitting a gray node → cycle. Black = fully processed (skip).

**Complexity:** O(V + E) time.

---

## 27. Detect Cycle in Undirected Graph
**Given:** an undirected graph
**Expects:** return true if it contains a cycle
**Pattern:** DFS with parent tracking (or DSU)

**Approach:** DFS; if neighbor visited and `neighbor != parent` → cycle.

**Complexity:** O(V + E) time.

---

## 28. Number of Distinct Islands
**Given:** a 2D island grid
**Expects:** return the number of distinct island shapes
**Pattern:** Flood fill + canonical path signature

**Approach:** During DFS record **relative direction path** (U/D/L/R from start); hash the path; count unique signatures.

**Complexity:** O(m·n) time, O(m·n) space.

---

## 29. Dijkstra on Grid (Path With Minimum Effort)
**Given:** a heights grid
**Expects:** return the minimum max-difference along any path (Dijkstra on grid)
**Pattern:** Weighted BFS = Dijkstra with `max` edge relaxation

**Approach:** `dist` = min max-diff on path; relax neighbor with `max(cur, |h1 - h2|)`; push smaller.

**Complexity:** O(m·n log(mn)) time.

---

## 30. Topological Sort via DFS (alternative to Kahn)
**Given:** a DAG
**Expects:** return a topological ordering via DFS finishing times
**Pattern:** DFS post-order + reverse

**Approach:** DFS fully processes a node (marks black), push to stack; final order = stack reversed (or collect in list and reverse).

**Complexity:** O(V + E) time.
