# DSA MCQ Prep — Theory, Algorithms & Complexities

MCQ-style theory across all 18 topics of this repo. Each line is a **canonical
statement** — the exact kind of sentence that becomes an MCQ stem, with the
answer already embedded. Cover the answers and self-test.

---

## 1. Complexity & Asymptotic Analysis

| Statement (with answer)                                                                                |
| ------------------------------------------------------------------------------------------------------ |
| Tightest bound for `n/2 + 100·log n`: **O(n)** — constants dropped.                                    |
| An algorithm that is O(n) is **also** O(n²), Ω(1), Θ? → O is an *upper* bound, not exact.              |
| If f(n) = O(g(n)) and g(n) = O(f(n)) then f and g are **Θ of each other**.                             |
| `3n² + 10n` is **Θ(n²)**, not Θ(n) — keep the dominant term, drop the constant 3.                      |
| Θ(1) means **constant** time — not "one operation".                                                    |
| Worst-case time of an algorithm = complexity of the **input that makes it slowest**.                   |
| Best-case of insertion sort: **O(n)** (already sorted); worst: **O(n²)** (reverse sorted).             |
| Binary search is **Θ(log n)** in the worst case — every case is log n.                                 |
| Linear search best case **O(1)**, worst case **O(n)**, average **O(n)**.                               |
| Average case = expected over all inputs **with a probability distribution**; usually assumed uniform.  |
| `log_a n = log_b n / log_b a` → base of log **does not matter** in Big-O: all bases Θ of each other.   |
| `log(n!)` = **Θ(n log n)** (Stirling).                                                                 |
| Sum `1 + 2 + ... + n` = **n(n+1)/2 = Θ(n²)**.                                                          |
| Sum `1 + 1/2 + 1/4 + ...` (geometric) = **Θ(1)**.                                                      |
| Master theorem case 2 (a = b^d): T(n) = aT(n/b) + Θ(n^d) → **Θ(n^d log n)**.                           |
| T(n) = 2T(n/2) + O(n) → **Θ(n log n)** (merge sort recurrence).                                        |
| T(n) = 2T(n/2) + O(1) → **Θ(n)** (tree traversal recurrence).                                          |
| T(n) = T(n-1) + O(1) → **Θ(n)** (linear recurrence).                                                   |
| T(n) = T(n-1) + O(n) → **Θ(n²)** (selection sort recurrence).                                          |
| T(n) = T(n/2) + O(1) → **Θ(log n)** (binary search recurrence).                                        |
| Recursion that splits into **2 branches each of size n-1** → **Θ(2ⁿ)** (naive Fibonacci).              |
| Naive Fibonacci without memoization: **O(2ⁿ)** time — tree of repeated subproblems.                    |
| Memoized Fibonacci: **O(n)** time — each of n subproblems solved once.                                 |
| Space of memoized Fibonacci: **O(n)** table + O(n) stack.                                              |
| Amortized O(1) means **n operations cost O(n) total**, even if some cost more.                         |
| `vector.push_back` is **amortized O(1)** (geometric doubling); a single call may be O(n).              |
| Big-O ignores **constants, lower-order terms, and base of logarithms**.                                |
| Ω = **lower** bound, O = **upper** bound, Θ = **tight** (both).                                        |
| "At least" / "best possible" statements use **Ω**, not O.                                              |
| O(n + m) for graph = linear in **both** vertices and edges.                                            |
| A correct but slow algorithm is still correct — complexity measures **efficiency**, not correctness.   |
| Two nested loops i<n, j<i: **O(n²)** — total iterations n(n-1)/2.                                      |
| Two nested loops i=1,2,4,...n, j<n: **O(n log n)** — outer doubles.                                    |
| Loop with i *= 2: **Θ(log n)** iterations.                                                             |
| Loop with i /= 2 starting at n: **Θ(log n)** iterations.                                               |
| Loop `while (i*i < n)` → **O(√n)** iterations.                                                         |
| Checking if n is prime by trial division: **O(√n)**.                                                   |
| Sorting a fixed number of passes (radix, counting): **O(n·k)** or **O(n + k)** — NOT comparison-bound. |
| **Any comparison-based sort needs Ω(n log n)** comparisons in the worst case — decision-tree argument. |
| Counting/radix/bucket sort beat n log n because they **don't compare** — they index by digits/keys.    |
| Log of n with 1e9 elements ≈ **30** — useful for MCQ mental math.                                      |
| Exponential 2ⁿ becomes impractical around n ≈ **30–40** on modern CPUs.                                |
| O(n!) — n = 12 ≈ 479M operations; enumeration of all **permutations**.                                 |
| Space complexity counts **extra** memory, not the input — e.g., in-place heap sort is O(1) extra.      |
| Recursive depth d → stack space **O(d)**; balanced recursion O(log n), skewed O(n).                    |
| Iterative binary search space: **O(1)**; recursive version: **O(log n)** stack.                        |
| Master theorem case 1 (a > b^d): **Θ(n^log_b a)** — e.g., Strassen Θ(n^2.81).                          |
| Master theorem case 3 (a < b^d, regularity holds): **Θ(n^d)**.                                         |
| Strassen matrix multiplication: **Θ(n^2.807)** vs naive Θ(n³).                                         |
| Fibonacci via matrix exponentiation / fast doubling: **O(log n)**.                                     |
| Power a^n by exponentiation by squaring: **O(log n)** multiplications.                                 |
| GCD via Euclid: **O(log min(a,b))** divisions.                                                         |
| Sieve of Eratosthenes: **O(n log log n)** time, O(n) space.                                            |
| Factorial recursion depth: **O(n)** stack; iterative: **O(1)** stack.                                  |
| `std::sort` worst case: **O(n log n)** (introsort); `stable_sort`: O(n log n) with extra O(n).         |
| Quick sort **worst** case O(n²) — sorted input with bad pivot; **average** O(n log n).                 |
| Merge sort is **O(n log n) in all cases** and **stable**.                                              |
| Heap sort is **O(n log n) worst case**, **in-place**, **not stable**.                                  |
| Insertion sort is **stable, in-place, O(n²)**; good for small/almost-sorted arrays.                    |
| Selection sort does **Θ(n²)** comparisons and **O(n)** swaps — best for minimizing writes.             |
| Bubble sort best case with swap-flag: **O(n)**; otherwise **O(n²)**; stable, in-place.                 |
| Linear-time median (median of medians) exists: **O(n) worst case** — sorting is not needed.            |
| Quickselect average: **O(n)**; worst: **O(n²)** with bad pivot.                                        |
| Hashing average **O(1)** lookups; **worst O(n)** with bad hash/collisions.                             |
| "Exponential time" means **O(cⁿ)** — typically via branching, e.g., subset enumeration.                |
| 2ⁿ vs n·2ⁿ: enumerating all subsets = O(2ⁿ); subsets with O(n) work each = **O(n·2ⁿ)**.                |
| Polynomial time = **O(n^k)** for constant k; n log n is polynomial.                                    |
| NP-complete means: in NP + every NP problem reduces to it — **no known polynomial solution** for all.  |

---

## 2. Arrays

| Statement (with answer) |
|---|
| Arrays give **O(1)** access by index (random access); insertion in the middle is **O(n)**. |
| Static array size is **fixed at compile time**; a dynamic array **doubles** capacity when full. |
| Worst-case insertion in a dynamic array is **O(n)** (realloc+copy); **amortized O(1)**. |
| `a[i]` = `*(a + i)` — indexing is **pointer arithmetic + dereference**. |
| `&a[5] - &a[1]` = **4** (elements, not bytes). |
| Row-major order: `a[i][j]` in an m×n matrix is at offset **i·n + j**. |
| Column-major: offset is **j·m + i** — same element, different location. |
| Rotating an array k steps: reverse whole, reverse first k, reverse rest — **O(n) time, O(1) space**. |
| Missing number 0..n: **XOR all indices and values** → missing one; sum formula alternative. |
| Two missing numbers → XOR gives a^b; **lowest set bit** splits the array into two groups. |
| Majority element (Boyer–Moore): **O(n) time, O(1) space** — candidate survives count cancelling. |
| Kadane's algorithm finds **maximum subarray sum** in O(n) — `max_here = max(x, max_here + x)`. |
| Kadane DP insight: **reset the running sum to x when the running sum becomes negative**. |
| Prefix sums: range sum [l, r] = **prefix[r] − prefix[l−1]** in O(1) after O(n) build. |
| 2D prefix sum: rect sum in **O(1)** after O(mn) build — inclusion-exclusion of 4 corners. |
| Prefix sum for "count of X in range" works when the operator has **an inverse** (sum/xor); max/min does NOT. |
| Difference array: range add [l, r] += v in **O(1)**; recover with one prefix pass O(n). |
| Sorted 2-sum via two pointers: **O(n)**; via binary search: **O(n log n)**; brute: O(n²). |
| Duplicate number (Floyd): treat `nums[i]` as next-pointer — **cycle detection**, O(n)/O(1). |
| Product except self: **two passes** (prefix and suffix products), O(n), no division. |
| In-place array reversal: **two pointers swap** until they meet — O(n)/O(1). |
| In-place duplicate removal from sorted array: **slow write pointer, fast read pointer**. |
| Sparse matrix: store only non-zeros → **space O(nnz)**; dense: O(mn) matrix. |
| Array vs linked list for cache: array **sequential memory** wins for iteration (cache locality). |
| ArrayList (dynamic array) get = **O(1)**; LinkedList get = **O(n)**. |
| ArrayList add at end = **amortized O(1)**; add at front = **O(n)** (shift). |
| Binary search needs a **sorted** array — searching unsorted is **O(n)**. |
| Finding kth smallest in an unsorted array: quickselect **average O(n)**, heap **O(n log k)**, sort **O(n log n)**. |
| Wave sort (a ≥ b ≤ c ...): sort then swap adjacent pairs — **O(n log n)**, or O(n) median trick. |
| Next permutation: find first ascent from right, swap with next greater, **reverse suffix** — O(n). |
| All permutations of an array: **n!** of them; generating all is Θ(n·n!) output. |
| In-place rotate matrix 90°: **transpose then reverse each row** (clockwise) — O(n²)/O(1). |
| Transpose swaps `a[i][j]` with `a[j][i]` — loop **j from i+1** to avoid double-swap. |
| Matrix multiply: **O(n³)** naive; Strassen **O(n^2.81)**; best theoretical ~O(n^2.37). |
| Matrix exponentiation computes `M^n` in **O(k³ log n)** for k×k matrix — powers Fibonacci in O(log n). |
| Two sorted arrays of size n: median by **binary search on the smaller array**, O(log n). |
| One swap to sort an array: find **first and last inversion** positions. |
| An array with elements 1..n but one duplicated and one missing → **sum + sum-of-squares** equations solve both. |
| Array `a[0] = n` trick: cyclic sort puts value v at index v−1 — **O(n), O(1)** for missing/duplicate patterns. |
| Jump game greedy: track `farthest = max(farthest, i + nums[i])` — O(n)/O(1). |
| Maximum circular subarray: **max(kadane, total − min_subarray)** — careful with all-negative case. |
| Count inversions: **merge sort modification**, O(n log n) — count pairs i<j with a[i] > a[j]. |
| Trapping rain water: **two pointers** with left/right max — O(n)/O(1). |
| Trapping rain water via prefix max arrays: O(n)/**O(n)** — two-pointer version is O(1) space. |
| Array dedup unsorted: **hash set** O(n)/O(n), or sort O(n log n)/O(1). |

---

## 3. Strings & Pattern Matching

| Statement (with answer) |
|---|
| String is immutable in **Java and Python**; mutable in **C++ (`std::string`)** and C (char[]). |
| `strlen` scans for the **NUL terminator** — O(n); `sizeof` on a literal counts **bytes incl. '\0'**. |
| Palindrome check: **two pointers** from both ends, O(n)/O(1). |
| Longest palindromic substring: **expand around center**, O(n²)/O(1); Manacher's O(n). |
| Count palindromic substrings: **expand around each of 2n−1 centers**, O(n²). |
| String matching — naive: **O(n·m)** worst case. |
| KMP uses a **failure/prefix function** (LPS array) → O(n + m) — never backtracks the main pointer. |
| KMP's LPS[i] = length of longest **proper prefix that is also suffix** of pattern[0..i]. |
| Rabin–Karp: **rolling hash** — O(n + m) average, O(n·m) worst (hash collisions). |
| Z-function Z[i] = longest prefix of s matching substring starting at i — used for matching in **O(n + m)**. |
| Boyer–Moore string search: matches from the **right**, skips with bad-character/good-suffix heuristics. |
| Longest common prefix of many strings: **trie** or sorting then compare first/last — O(S·log S) or O(S). |
| Anagrams: **same sorted form** or **same frequency map** — O(n log n) vs O(n). |
| Group anagrams: key = **sorted string** or **character-count tuple**. |
| Longest substring without repeating chars: **sliding window + set** — O(n), window shrinks from left. |
| Longest repeating character replacement (k swaps): **window where len − max_freq ≤ k**. |
| `string.find` in C++ is O(n·m) naive in practice; `std::string::npos` = "not found". |
| To check if s2 is a rotation of s1: **check s2 in s1 + s1**. |
| Reverse words: reverse whole string, then **reverse each word** — in-place O(n). |
| Longest common subsequence ≠ longest common substring — substring must be **contiguous**. |
| Longest common substring: DP `dp[i][j] = 1 + dp[i-1][j-1]` if equal else **0** — take global max. |
| Edit distance (Levenshtein) DP: **O(m·n)** time/space; can be O(n) space with rolling rows. |
| Subsequence check: **greedy scan** of the longer string — O(n). |
| Number of distinct subsequences: **DP with last-occurrence subtraction** — O(n). |
| String to integer / integer to string: **O(digits)**; watch overflow before multiplying by 10. |
| Valid parentheses matching with a **stack**; if closing bracket ≠ top → invalid; stack must be empty at end. |
| A string of length n has **n(n+1)/2** substrings and **2ⁿ** subsequences. |
| Substring = contiguous; subsequence = order preserved, gaps allowed; **substring ⊂ subsequence**. |
| Lexicographic comparison is **character by character**, shorter string wins if prefix. |
| `"abc" < "abd"` — compares until first differing char (**'c' vs 'd'**). |
| Suffix array sorts all suffixes in **O(n log n)** (doubling) or O(n) (SA-IS); used for substring queries. |
| LCP array + suffix array finds **longest repeated substring** in O(n). |
| ASCII vs Unicode: ASCII is **7-bit/128 chars**; UTF-8 is variable **1–4 bytes** per char. |
| Base-64 encodes 3 bytes into **4 chars** — 33% expansion. |
| Strings as char arrays in C: mutable; string literals: **read-only** (modifying is UB). |
| Concatenating n strings of length 1: **O(n²)** for naive immutable concat (Java/Python) vs **O(n)** for StringBuilder/join. |
| `+` on Java strings in a loop: **O(n²)** — use StringBuilder (O(n) amortized). |
| Wildcard matching `?`/`*`: DP **O(m·n)**; greedy two-pointer O(n). |
| Regex matching `*` (zero+ of previous): DP **O(m·n)**. |
| Balanced parentheses count for n pairs = **Catalan number** C_n = C(2n,n)/(n+1). |
| Longest palindromic subsequence: DP on **LCS of s and reverse(s)** — O(n²). |
| Isomorphic strings: **two maps** char↔char, consistency check — O(n). |
| Sentence palindrome: skip **non-alphanumerics**, lowercase, two pointers. |

---

## 4. Hashing

| Statement (with answer) |
|---|
| Hash map average operations: **O(1)**; worst case **O(n)** when everything collides. |
| Hash set stores **keys only**; hash map stores **key→value**. |
| A good hash function: **uniform distribution, deterministic, fast**. |
| Load factor = **entries / buckets**; above threshold (0.75 in Java) → rehash (double size). |
| Collision resolution: **chaining** (linked list/bst per bucket) or **open addressing** (probe next slot). |
| Java HashMap uses **chaining + red-black tree** for long chains (8+); Python dict uses **open addressing**. |
| C++ `unordered_map` is **chained**; `map` is a **red-black tree** (sorted). |
| Sorted map (TreeMap / std::map / Python needs `sorted`): ops **O(log n)** vs O(1) hash — but **ordered keys**. |
| Two Sum target-x lookup: **O(n)** with a hash map — the canonical hash pattern. |
| Subarray sum equals k: running sum; count of `sum − k` in map — **O(n)**. |
| Largest subarray with 0 sum: store **first occurrence of each prefix sum** — O(n). |
| Longest subarray with equal 0s and 1s: treat 0 as −1 → **prefix sum 0 problem**. |
| Two-sum in a sorted array can also be **two pointers O(n)** — hash map O(n) works unsorted. |
| Hashing pair (i,j): key = **i·n + j** (flatten index) — deterministic tuple key. |
| Hash of a tuple/list: combine element hashes; must be **consistent with equals**. |
| Equal objects **must** have equal hash codes — unequal objects **may** collide. |
| If you override `equals` in Java without `hashCode`: objects are "equal" but **hash differently** — set/map break. |
| A set of custom objects dedups by **hash then equals**. |
| Counting frequency of n elements: **O(n)** via hash map — vs O(n log n) via sort. |
| First non-repeating character: count all, then **scan in order** — two passes O(n). |
| Character counts: array of **26 (or 256)** is faster than a hash map — fixed alphabet. |
| Anagrams → same **count signature**; that signature can be a hash key. |
| Rabin–Karp uses rolling hash: `h = (h·base + c) % mod`; remove char by **subtracting c·base^len**. |
| Hash of string with base 26/31: **polynomial rolling hash**. |
| Universal hashing: pick a **random** hash function per run — resists adversarial collisions. |
| Collision attack: attacker crafts keys hashing to the **same bucket** — turns O(1) into O(n). |
| HashSet dedup of array: O(n) time, **O(n)** space; sort-dedup: O(n log n) time, O(1) extra. |
| LRU cache: hash map → **doubly linked list node** for O(1) get/put. |
| LFU cache: hash map + **min-heap or frequency buckets**. |
| `unordered_map` iteration order is **unspecified**; `map` iterates **sorted by key**. |
| Rehash invalidates **iterators/references** of unordered containers. |
| Open addressing requires **tombstones** (deleted markers) to keep probe chains intact. |
| Python `dict` preserves **insertion order** (3.7+); Java `LinkedHashMap` preserves insertion order. |
| Hash map for two-sum gives O(n) but **O(n)** space; two-pointer after sort gives O(1) space. |
| Counting sort: **O(n + k)** using a count array — a hash-free counting trick. |
| Bucket sort: distribute into k buckets then sort each — **O(n + k)** average. |
| Hash map vs array indexing: array is **O(1) guaranteed**; hash map is **O(1) expected**. |
| Finding duplicates in O(n) time O(1) space for values in [1, n]: **index-marking** (negation) — no hash needed. |
| Longest consecutive sequence: hash set + check only **sequence starts** (x−1 not in set) — O(n). |
| Perfect hashing: **no collisions** by pre-choosing a collision-free function — O(1) worst. |
| Min-hash/LSH: approximate duplicate detection via **hash signatures**. |

---

## 5. Two Pointers & Sliding Window

| Statement (with answer) |
|---|
| Two pointers on a **sorted** array: move **left** if sum too small, **right** if too big — O(n). |
| Two-sum sorted: **O(n)**; unsorted with hash: **O(n)** — sorted needs no extra space. |
| Three-sum: fix one, then **two-pointer the rest** — O(n²); brute force is O(n³). |
| Four-sum: fix two, two-pointer rest — **O(n³)**. |
| Closest pair sum: track **min |target − sum|** while moving pointers. |
| Container with most water: move the **shorter** line — area = min(h[l], h[r]) × (r − l). |
| Sliding window for max sum of k elements: **O(n)** vs O(n·k) recompute. |
| Window shrink condition generalizes to "while window **invalid**, move left". |
| Longest substring with at most k distinct: **map of counts**, shrink when size > k. |
| Window with exactly k distinct = **atMost(k) − atMost(k−1)** — the standard trick. |
| Maximum in each window of size k: **monotonic deque** — O(n). |
| Minimum window substring: **expand right, shrink left** while valid — O(n). |
| Fixed window formula: `window_sum += a[r] − a[r−k]` — **O(1) update** per slide. |
| Two-pointer in-place dedup: **slow** = next write, **fast** = reader. |
| Dutch flag (sort 0/1/2): **three pointers** low/mid/high, swap mid — O(n) single pass. |
| Move zeros to end: **write pointer** for non-zeros, then fill zeros — O(n). |
| Two pointers from **both ends** on sorted input assumes **order matters** (sum comparisons). |
| Two pointers same direction (fast/slow) find **cycle, middle, or nth-from-end** in lists. |
| Fast = 2×slow: at meet point, **distance from head to cycle start = distance from meet to cycle start**. |
| Middle of linked list: slow/fast — fast moves **2 steps**, slow 1. |
| nth from end: two pointers **n apart**, advance both — O(n) one pass. |
| Palindrome linked list: find middle, **reverse second half**, compare. |
| Remove nth from end: **dummy node** + two pointers n+1 apart. |
| Sliding window over a string of length n has **O(n)** distinct windows with a shrink-left loop. |
| Kadane vs sliding window: Kadane resets to **x** (negative-drop); window shrinks on **constraint**. |
| Subarray product < k (positive array): **two pointers** — product only shrinks by moving left. |
| Two-pointer triplet sum in sorted rotated array: **find rotation, then classic two-sum**. |
| Trapping rain water two-pointer: move side with **smaller max** — water = max_side − height. |
| Squares of sorted array: **two pointers from both ends**, fill result from the back — O(n). |
| Two-pointer with **cycle sort position** (index-value matching): used in find-all-duplicates O(n)/O(1). |
| While window invalid: shrink until valid — **each element enters and leaves at most once** → O(n). |
| Sliding window max with deque: keep **decreasing** deque; pop indices **out of window** from front. |
| K-diff pairs: **sort + two pointers**, skip duplicates. |
| Merge two sorted arrays (in place): fill **from the back** — O(m+n). |
| Merge two sorted arrays into a third: standard **two-pointer merge** — O(m+n). |
| Merge k sorted lists/arrays: **min-heap of k heads** — O(N log k), N = total elements. |
| Partition around pivot (quicksort): Hoare/Lomuto — **two pointers swap**, O(n). |
| All pairs (i,j) O(n²) vs two pointers O(n): two pointers work only when the **function is monotonic** in the pointers. |

---

## 6. Binary Search

| Statement (with answer) |
|---|
| Binary search requires **sorted** (or monotonic predicate) input — O(log n). |
| `mid = l + (r − l) / 2` avoids **integer overflow** of (l + r). |
| The classic lower-bound search: find **first index where a[i] ≥ x**. |
| Upper bound: first index where **a[i] > x** — insert position for duplicates after. |
| Count of x in sorted array = **upperBound − lowerBound**. |
| Binary search on **answer** (minimize/maximize a value): predicate "**is X possible?**" — O(log range × check). |
| Search in rotated sorted array: decide **which half is sorted**, then check if target lies in it. |
| Find min in rotated array: compare `a[mid]` with **a[right]** — O(log n). |
| Rotated array with duplicates: worst case **O(n)** — can't decide halves (a[l]==a[mid]==a[r]). |
| Find peak element: go toward the **rising neighbor** — O(log n), works unsorted! |
| Find kth smallest in a matrix (sorted rows/cols): **binary search on value + counting** — O(n log(max−min)). |
| Median of two sorted arrays: **binary search on the smaller array**'s partition — O(log min(m,n)). |
| Sqrt(x) integer: binary search on **answer [0, x]** — O(log x). |
| First bad version / first true in `[false...false, true...true]`: binary search the **boundary** — O(log n). |
| Binary search on a monotonic boolean array finds **the transition point**. |
| Exponential search for unbounded array: **double the index** then binary search — O(log i) where i is answer. |
| Binary search with floating answers (e.g., root finding): **fixed iterations (~100)**, not while l<r. |
| The classic bug `while (l <= r)` vs `while (l < r)`: with `l < r`, **l lands on the answer**. |
| Ceiling/floor in sorted array: ceiling = lower_bound; floor = **lower_bound then step back** if not equal. |
| Search insert position = **lower bound index**. |
| Single element in a sorted array of pairs: binary search checking **index parity** — O(log n). |
| Find missing in sorted arithmetic progression: binary search on **value − index** mismatch. |
| Binary search comparison count: **≤ ⌈log₂(n+1)⌉** in the worst case. |
| For n = 10⁶, binary search needs ~**20** comparisons. |
| Binary search vs linear: linear O(n) always works (unsorted); binary O(log n) needs **sorted**. |
| Min number of days to make m bouquets (answer BS): check() = **feasible(m, day)** — O(n log range). |
| Split array largest sum (minimize max): **answer BS** + greedy feasibility — O(n log sum). |
| Aggressive cows (maximize min distance): **answer BS** on distance — O(n log range). |
| Capacity to ship in D days: **answer BS** — classic "minimize the max". |
| Median in a row-wise sorted matrix: BS on value + **count ≤ x** in O(rows·log cols). |
| Searching in a bitonic array (increases then decreases): **find peak, then BS both halves**. |
| Ternary search works on **unimodal** functions — O(log₃ n) but **slower than binary** on monotone. |
| The invariant of binary search: **the answer is always in [l, r]**. |
| Binary search template returning **left** after `while (left < right)` gives the first valid position. |
| Off-by-one in BS: wrong mid/update causes **infinite loop** (test with n=2,3). |
| For minimization problems, predicate is "**can we do ≤ X**"; for maximization, "**can we do ≥ X**". |

---

## 7. Stacks & Queues

| Statement (with answer) |
|---|
| Stack: **LIFO**; Queue: **FIFO** — push/pop/peek all **O(1)**. |
| Balanced parentheses: stack — **push opens, pop on matching close**; empty at end = valid. |
| Valid parentheses with `*` wildcard: track **low/high open counts** — greedy O(n). |
| Longest valid parentheses: stack of **indices**, push −1 sentinel. |
| Next greater element: **monotonic decreasing stack** — pop while top < current; each element pushed/popped once → O(n). |
| Next smaller element: **monotonic increasing stack**. |
| Stock span / previous greater: same monotonic stack, **indices** pushed. |
| Largest rectangle in histogram: stack of increasing heights; area = `h[top] × (right − left − 1)` — O(n). |
| Maximal rectangle in binary matrix: **histogram row by row** — O(m·n). |
| Trapping rain water (stack version): water trapped between **bounded pops** — O(n). |
| Min stack: keep a second stack of **min so far** — O(1) getMin. |
| Two stacks → queue: push into s1; on pop, **move all to s2 and pop** — amortized O(1). |
| Two queues → stack: push into q1; on pop, **rotate q2** — O(n) per pop. |
| Queue via array (circular buffer): **(head+1) % capacity** wrapping — O(1), no shifts. |
| Circular queue full condition: **(rear + 1) % size == front** — one slot sacrificed. |
| Deque = double-ended queue: **push/pop both ends O(1)** — sliding window max. |
| Sliding window maximum: **monotonic deque** — front is max, pop expired indices — O(n). |
| Evaluate RPN (postfix): push operands, pop **two** on operator — stack, O(n). |
| Infix → postfix: **shunting-yard** — operators to stack by precedence; higher precedence pops first. |
| Precedence: `* /` above `+ -`; parentheses force **evaluation inside first**. |
| Postfix evaluation never needs **parentheses** — the reason RPN exists. |
| Stack for DFS (iterative): push neighbors; queue for BFS: enqueue neighbors — **LIFO vs FIFO**. |
| Parenthesis matching check is a **context-free language** recognition — stack's canonical use. |
| Celebrity problem: stack-based **elimination** — O(n). |
| Asteroid collision: stack — **explode on collision**, compare sizes — O(n). |
| Remove k digits (smallest number): stack pops while **top > current and k > 0** — O(n). |
| Decode string "3[a2[c]]": stack of **counts and strings** — O(n). |
| Daily temperatures = **next greater element** — stack answer in O(n). |
| Monotonic stack invariant: elements in stack are **increasing or decreasing** — never both. |
| Monotonic stack processes each element **twice at most** (push once, pop once) → O(n). |
| Stack overflow: recursion too deep; **heap** allocated objects avoid it but are slower. |
| Priority queue is NOT a FIFO queue — orders by **priority**, default max-heap/min-heap. |
| Expression tree post-order traversal evaluates the expression — equivalent to **stack evaluation**. |
| Balanced parentheses count with Catalan: number of valid sequences of n pairs = **C(2n,n)/(n+1)**. |
| Stack vs recursion: recursion **is** a stack (call stack) — iterative stack simulates it. |
| Quicksort's explicit stack size: **O(log n)** if smaller partition pushed first. |

---

## 8. Linked Lists

| Statement (with answer) |
|---|
| Singly linked list node: `data + next`; doubly: `prev + data + next` — **O(1)** insert/delete at known node. |
| Accessing the kth element in a linked list: **O(n)** — no random access (vs array O(1)). |
| Inserting at head: **O(1)** — the list's one big win over arrays. |
| Inserting at tail without a tail pointer: **O(n)**; with a tail pointer: **O(1)**. |
| Deleting a node given only its pointer (not head): **copy next's data, skip next** — doesn't work for tail. |
| Reverse a linked list: three pointers — `prev, curr, next` — **O(n), O(1) space**. |
| Reverse a linked list recursively: **O(n) time, O(n) stack** — base case returns new head. |
| Detect cycle: **Floyd's fast/slow** — O(n)/O(1); hash set version O(n)/O(n). |
| In Floyd, when slow meets fast inside the cycle: **head-to-cycle-start distance = meet-point-to-cycle-start distance**. |
| Find middle: slow/fast, fast jumps **2** — slow is at middle (2nd middle for even length). |
| Find nth from end: advance fast **n** first, then move both — O(n) one pass. |
| Remove nth from end: **dummy head** + fast n+1 ahead — handles removing the head. |
| Merge two sorted lists: **dummy node + two-pointer merge** — O(m+n). |
| Merge k sorted lists: **min-heap of k heads** — O(N log k). |
| Merge sort on a linked list: **O(n log n), O(log n) stack** — no array copying needed; split by slow/fast. |
| Intersection of two lists: **two pointers switching heads** — they meet at the intersection in O(m+n). |
| Intersection detection with lengths: advance the longer list by **|m − n|**, then walk together. |
| Palindrome linked list: **find middle, reverse second half, compare** — O(n)/O(1). |
| Remove duplicates from sorted list: **skip while next.val == cur.val** — O(n). |
| Remove duplicates unsorted: **hash set** — O(n)/O(n). |
| Rotate list by k: make it circular, **break at n − k % n** — O(n). |
| Swap nodes in pairs: recursive/iterative with **dummy + link rewiring** — O(n). |
| Odd-even linked list: **separate odd/even indices, link tails** — O(n)/O(1). |
| Copy list with random pointers: interleave clone nodes — **map-free O(n)/O(1)** trick. |
| Reverse nodes in k-groups: reverse each k-block, **re-link previous tail to new head** — O(n). |
| Linked list vs array memory: list has **per-node pointer overhead** (~2× space). |
| Cache behavior: arrays **cache-friendly**; linked lists cause **cache misses** on traversal. |
| Singly vs doubly: doubly supports **O(1) deletion given node** (has prev) — singly needs traversal. |
| Circular linked list: **no NULL**; used for round-robin scheduling, Josephus problem. |
| Josephus problem: circular elimination — O(n) formula: `j = (j + k) % i` recurrence. |
| Adding two numbers (lists): **sum digits with carry**, build result list — O(max(m,n)). |
| Head sentinel/dummy node simplifies **edge cases at the head** — the standard idiom. |
| Deep copy of a list: **O(n)** — copy every node, not the pointers. |
| Floyd's algorithm detects cycle with **O(1) extra space** — the classic space/accuracy tradeoff MCQ. |
| Fast pointer starting at head->next->next vs head: meet point differs but **cycle detection still works**. |
| Sorting a linked list vs array: **no index access** — quicksort is awkward; merge sort preferred. |
| LRU cache uses a **doubly linked list + hash map** — move-to-front O(1). |
| List reversal in groups with a **counter** to stop at k — careful with leftover < k. |
| Intersection of two lists means **shared nodes**, not equal values — identity matters. |
| If a cycle exists, slow and fast **will meet** within O(cycle length) after slow enters the loop. |

---

## 9. Trees & BST

| Statement (with answer) |
|---|
| A tree with n nodes has **n − 1 edges** — always. |
| Binary tree node = **value + left + right**; children ≤ 2. |
| Full binary tree: every node has **0 or 2** children. |
| Complete binary tree: all levels full except possibly the last, filled **left to right**. |
| Perfect binary tree: all levels **completely filled** — has 2^(h+1) − 1 nodes. |
| Degenerate tree = a **linked list** — height n − 1, worst O(n) ops. |
| Height of a balanced tree with n nodes: **O(log n)**. |
| Max nodes at level k = **2^k**; total nodes in perfect tree of height h = **2^(h+1) − 1**. |
| Height of a node = longest path **down to a leaf**; depth = distance **from root**. |
| Height of a single-node tree = **0** (or 1 by some definitions — convention matters). |
| Preorder = **root → left → right** (root first). |
| Inorder = **left → root → right** (sorted order in a BST). |
| Postorder = **left → right → root** (root last). |
| Level order = **BFS with a queue**. |
| Reconstruct a unique binary tree from **inorder + preorder** (or inorder + postorder) — preorder alone is ambiguous. |
| Inorder alone cannot rebuild the tree; **preorder alone also cannot** — need one of each pair. |
| Inorder of a BST is **sorted ascending** — the key BST property. |
| Inorder successor of a node = **leftmost node in right subtree** (or ancestor for no right child). |
| Inorder predecessor = **rightmost node in left subtree**. |
| BST search: compare and go left/right — **O(h)**; O(log n) balanced, O(n) skewed. |
| BST insert: search position, attach leaf — **O(h)**; no rotations needed. |
| BST delete 3 cases: **leaf (just delete), one child (bypass), two children (replace with inorder successor)**. |
| In BST delete with two children, replacing with **inorder successor** preserves the BST invariant. |
| BST vs hash table: BST **ordered** ops O(log n); hash O(1) but unordered. |
| Building a BST from a sorted array: **pick middle as root, recurse** — balanced, O(n). |
| Naively inserting sorted data into a BST makes it **degenerate (O(n) height)** — always pick middle. |
| Count of structurally different BSTs with n keys = **Catalan number C_n**. |
| Validate BST: **inorder must be strictly increasing** (or recursive min/max range). |
| Valid BST requires **all** left subtree values < root < **all** right values — not just children. |
| Kth smallest in BST: **inorder traversal counting** — O(h + k). |
| LCA in BST: first node where **one value is ≤ node ≤ other** — O(h). |
| LCA in a binary tree: recursive — if node is p or q, return it; else if **both sides return non-null**, node is LCA. |
| LCA of two nodes exists iff **both nodes found in the tree**. |
| Binary tree depth (max depth): **1 + max(left, right)** — O(n). |
| Balanced tree check: heights differ ≤ 1 **and both subtrees balanced** — O(n) bottom-up. |
| Diameter = longest path between two nodes — at each node: **left_h + right_h** — O(n). |
| Maximum path sum: Kadane-style on tree — `max(0, left) + max(0, right) + val` — O(n). |
| Same tree: **identical structure and values** — recursive pair comparison. |
| Symmetric (mirror) tree: compare `left.left vs right.right` and `left.right vs right.left`. |
| Invert tree: swap children, recurse — **O(n)**. |
| Serialize/deserialize: **preorder with null markers** — O(n). |
| Binary tree from inorder+preorder: preorder gives **roots**, inorder gives **split**. |
| Flatten tree to list: **reverse-postorder** (right-left-root) — O(n)/O(1) Morris-style. |
| Tree traversals iterative with a stack: preorder easy, inorder needs **go-left-then-process**, postorder trickiest. |
| Morris inorder traversal: **O(n) time, O(1) space** — threads via rightmost predecessor. |
| Count nodes in complete tree: use **left-height vs right-height** — O(log² n). |
| AVL tree: self-balancing BST — **balance factor ≤ 1** — rotations: LL, RR, LR, RL. |
| AVL rotation count on insert: **at most 1**; delete may need **O(log n)** rotations. |
| Red-black tree: nodes **red/black**, root black, no double red — height ≤ **2·log(n+1)**. |
| Red-black vs AVL: AVL is **more strictly balanced** (faster lookups), RB does **fewer rotations** (faster inserts). |
| Treap = BST by key + **heap by priority** — expected O(log n). |
| Splay tree: recently accessed elements **move to root** — amortized O(log n). |
| B-tree: nodes hold **many keys** — used in **databases/file systems** for disk block reads. |
| B+ tree: all data in **leaves linked together** — better range scans than B-tree. |
| Segment tree: range query/update in **O(log n)**, build O(n) — 4n size. |
| Fenwick/BIT: **prefix sum + point update** in O(log n), less space than segment tree. |
| Fenwick supports prefix queries only with **invertible** ops — range sum via prefix(r) − prefix(l−1). |
| Heap is a complete tree stored in an array: parent i → children **2i+1, 2i+2** (0-based). |
| Heap array child formula 1-based: **2i and 2i+1** — index convention matters. |
| Inorder of heap is **not sorted** — only root ≤ children (min-heap), not global ordering. |
| Trie is a tree but **not a binary tree** — up to 26 children per node. |
| Decision tree of a comparison sort: **n! leaves** → Ω(n log n) height. |
| Expression tree: leaves = operands, internal = operators; **postorder evaluates**. |
| Huffman tree: **greedy bottom-up merge** of two smallest frequencies — optimal prefix code. |
| A full binary tree with n leaves has **n − 1 internal nodes**. |
| Number of null pointers in a binary tree of n nodes: **n + 1**. |
| Union-Find is a **forest** of trees — path compression + union by rank → nearly O(1) amortized. |
| Segment tree lazy propagation: **push pending updates down** when children are needed — range updates O(log n). |
| Tree diameter via two BFS/DFS: works for **trees** (one path) — from farthest of farthest. |
| Center of a tree = **middle of the diameter path** — minimum-height tree roots. |
| Burn a binary tree from a target node: **BFS from target via parent map** — O(n). |
| Tree isomorphism: match children **as sets** (unordered children) — hash/DFS canonicalization. |

---

## 10. Heaps & Priority Queues

| Statement (with answer) |
|---|
| Min-heap invariant: **parent ≤ both children** — min is at root; extraction O(log n). |
| Heap is a **complete binary tree** → can be stored in an array without pointers. |
| Children of i (0-based): **2i+1, 2i+2**; parent: **(i−1)/2**. |
| Build a heap from n arbitrary elements: **O(n)** — bottom-up sift-down (not n·log n). |
| Heapify is O(n) because **most nodes are near the leaves** — sum of sift costs is linear. |
| Insert into a heap: **push at end, sift up** — O(log n). |
| Extract min/max: **swap root with last, pop, sift down** — O(log n). |
| Peek (get min/max without removing): **O(1)** — the root. |
| Heap sort: build heap O(n) + n extractions O(n log n) — **O(n log n) overall, in-place, not stable**. |
| Top k largest elements: **min-heap of size k** — O(n log k). |
| Top k with a max-heap of all n: **O(n + k log n)** — worse than O(n log k) when k ≪ n. |
| Kth largest: min-heap size k (**O(n log k)**) or quickselect (**average O(n)**). |
| Merge k sorted lists/arrays: **min-heap of k heads** — O(N log k). |
| Median from a data stream: **two heaps** — max-heap (left half) + min-heap (right half), sizes differ by ≤ 1. |
| Median query from two heaps: **O(1)** (top of the bigger/smaller heap); insert **O(log n)**. |
| Balance two heaps: move top from the larger heap to the smaller when sizes differ by **2**. |
| kth largest in a stream: **min-heap size k** — root is the answer after each insert. |
| Sort a nearly-sorted (k-sorted) array: heap of size **k+1** — O(n log k). |
| Dijkstra with a min-heap: **O((V + E) log V)**. |
| Prim's MST with a min-heap: **O((V + E) log V)**. |
| Heap vs sorted array: heap gives **O(1) min + O(log n) update**; array gives O(1) lookup by index, O(n) insert. |
| Heap vs BST: heap is **faster and simpler** for min/max; BST supports **all ordered ops**. |
| Priority queue in C++: **max-heap by default** (`priority_queue<int>`); min via `greater<int>`. |
| Priority queue in Java: **min-heap by default** (`PriorityQueue<Integer>`); Python `heapq` is **min-heap**. |
| Custom comparator: return **a < b** for min-heap (Java: a − b; C++: greater). |
| Priority queue does **not** support arbitrary element deletion — only the top (lazy deletion trick exists). |
| Decrease-key is **O(log n)** (sift up) — used in Dijkstra/Prim for better constants. |
| Fibonacci heap: decrease-key **O(1) amortized** — better for dense-graph Dijkstra (theoretical). |
| Binomial heap: **merge two heaps in O(log n)** — supports efficient meld. |
| Heaps are the structure behind **scheduling (OS), Dijkstra, Huffman coding, selection algorithms**. |
| Heap sort is **unstable** — equal keys may reorder (vs merge sort stable). |
| Sorting with a heap: repeatedly **extract max** and place at the end — in-place with max-heap. |
| Huffman coding builds a **min-heap of trees** — merge two smallest repeatedly. |
| k-way merge with heap: compare **the k head elements** — heap keeps the min head on top. |
| Maximum of a min-heap: **in the leaves** — O(n) to find (half the elements). |
| Min of a min-heap: **root, O(1)**. |
| Delete an arbitrary element from a heap: **O(log n)** if you know its index (replace with last, sift). |
| Heapify on an empty structure inserting one by one: **O(n log n)**; direct heapify of an array: **O(n)**. |
| Number of levels in a heap of n nodes: **⌊log₂ n⌋ + 1**. |
| Largest element location in a max-heap of distinct keys: **root**. |
| Second largest in a max-heap: **one of the root's children** — compare only 2 elements. |
| Heap is great for **online/streaming** problems — you never need all data at once. |
| Frequency top-k (k most frequent elements): **(count → bucket) bucket sort O(n)** beats heap O(n log k). |
| Using a max-heap of size k for k smallest: **O(n log k)** — keep k smallest seen. |
| "Last stone weight" / "reorganize string": heap of **values/frequencies** — pop two largest. |
| Priority queue comparison must be **strict weak ordering** — inconsistent comparators are UB. |
| Space of heap: **O(n)** array — no pointers, better cache behavior than tree nodes. |

---

## 11. Graphs

| Statement (with answer) |
|---|
| Graph G = (V, E); adjacency list space: **O(V + E)**; adjacency matrix: **O(V²)**. |
| Adjacency list is better for **sparse** graphs; matrix better for **dense** graphs and O(1) edge checks. |
| DFS: **stack** (explicit or recursion); explores a whole **component** before backtracking. |
| BFS: **queue**; explores **level by level** — gives shortest path in **unweighted** graphs. |
| DFS time: **O(V + E)**; BFS time: **O(V + E)** (with adjacency list). |
| BFS from source finds **shortest path in terms of edge count**. |
| BFS layers: all nodes at distance d are visited **before any at distance d+1**. |
| Cycle in undirected graph: DFS/BFS — edge to a **visited non-parent**; or **DSU** on edges. |
| Cycle in directed graph: DFS with **recursion stack** (gray nodes) or Kahn's topo-sort failure. |
| Undirected graph is a tree iff **connected and E = V − 1** (or connected + acyclic). |
| Topological sort exists iff the graph is a **DAG**. |
| Kahn's algorithm: repeatedly remove **in-degree 0** nodes — O(V + E). |
| DFS topo-sort: push node to stack **after** processing all its children — then reverse. |
| Topological order is **not unique** in general. |
| A directed graph with a cycle has **no topological ordering**. |
| Connected components of an undirected graph: **DFS/BFS count** — O(V + E). |
| Strongly connected components: **Kosaraju (2 DFS passes)** or Tarjan — O(V + E). |
| Kosaraju: DFS order, reverse graph, second DFS in **finishing-time order**. |
| Tarjan SCC: **one DFS** with low-link values. |
| Condensing SCCs produces a **DAG** — used for 2-SAT, dependency analysis. |
| Dijkstra: **non-negative weights only** — greedy; O((V + E) log V) with a heap. |
| Dijkstra with negative edge fails — **may give wrong distance** (greedy locks nodes too early). |
| Bellman–Ford: handles **negative edges**, detects negative cycles — **O(V·E)**. |
| Bellman–Ford relaxes all edges **V − 1** times; a Vth relaxation succeeding ⇒ **negative cycle**. |
| Floyd–Warshall: **all-pairs** shortest paths — O(V³), matrix-based, negative edges OK. |
| Floyd–Warshall detects negative cycle: any `dist[i][i] < 0` at the end. |
| SPFA is Bellman-Ford with a queue — **average fast, worst O(VE)**. |
| A* search = Dijkstra + **heuristic h(x)** — admissible (never overestimates) ⇒ optimal. |
| MST exists for **connected undirected** graphs; a graph with n nodes has MST with **n − 1** edges. |
| Kruskal's MST: **sort edges + DSU** (skip cycle edges) — O(E log E). |
| Prim's MST: grow a tree with a **min-heap** — O((V + E) log V). |
| Kruskal picks the **smallest edge that connects two components**; Prim picks the smallest edge **out of the current tree**. |
| MST is **not unique** if equal-weight edges exist — but its **weight is unique**. |
| MST cut property: the **lightest edge crossing any cut** must be in some MST. |
| Cycle property: the **heaviest edge on a cycle** is never in an MST. |
| Bipartite graph: can 2-color without conflict — **BFS/DFS coloring**, O(V + E). |
| A graph is bipartite iff it has **no odd-length cycle**. |
| Maximum bipartite matching: **Hopcroft–Karp O(E√V)**; general matching: Blossom. |
| Maximum flow: **Ford–Fulkerson O(E·maxflow)**; **Edmonds–Karp O(V·E²)** (BFS augmenting paths). |
| Min-cut = **max flow** (Max-Flow Min-Cut theorem). |
| Euler path: visits every **edge** once — exists iff 0 or 2 odd-degree vertices (connected). |
| Euler circuit: starts=ends, exists iff **all degrees even**. |
| Hamiltonian path/cycle: visits every **vertex** once — **NP-complete** (no poly solution known). |
| Euler vs Hamiltonian: edges vs vertices — Euler is **easy** (degree check), Hamiltonian is **hard**. |
| Number of edges in a complete graph K_n: **n(n−1)/2**. |
| Sum of all degrees = **2E** (handshaking lemma). |
| Number of odd-degree vertices is always **even**. |
| Tree with n vertices: **n − 1 edges**, connected, acyclic — any two imply the third. |
| Number of spanning trees of K_n: **n^(n−2)** (Cayley's formula). |
| Count spanning trees: **Kirchhoff's matrix-tree theorem** (cofactor of Laplacian). |
| Articulation point: removing it **disconnects** the graph — Tarjan DFS O(V + E). |
| Bridge: removing the **edge** disconnects — low-link DFS O(V + E). |
| An edge is a bridge iff **low[child] > disc[parent]**. |
| A vertex is an articulation point iff **low[child] ≥ disc[parent]** (with root special case). |
| Number of islands / flood fill: **DFS or BFS** on grid — O(m·n). |
| Grid graph: each cell connects to **4 neighbors** (up/down/left/right); 8 with diagonals. |
| Shortest path in a binary maze: **BFS** — Dijkstra with unit weights = BFS. |
| Shortest path in a grid with obstacles and k eliminations: **BFS on (row, col, k) state** — O(m·n·k). |
| 0-1 BFS (edge weights 0 or 1): **deque** — push front for 0, back for 1 — O(V + E). |
| Multi-source BFS: enqueue **all sources** first — distances from the nearest source. |
| Word ladder: BFS on **word graph** — each edge = one-letter change — O(n·len·26). |
| Course schedule = **topological sort feasibility** — cycle detection. |
| Clone a graph: **DFS/BFS with old→new node map** — O(V + E). |
| Graph coloring (chromatic number) is **NP-complete** in general; bipartite = 2-colorable. |
| Planar graph: drawable without crossing edges — **E ≤ 3V − 6** for V ≥ 3. |
| Dijkstra on dense graphs: O(V²) array version beats heap — **dense favors array**. |
| Transpose of a graph: reverse all edges — used in Kosaraju. |
| Parent array from BFS reconstructs the **shortest path** by backtracking from target. |
| Visited set prevents **infinite loops** on cyclic graphs — always mark on enqueue. |
| Kahn vs DFS topo-sort: Kahn gives **one specific order** and detects cycles by count; DFS by recursion stack. |
| Graph diameter: longest shortest path — **O(V·(V+E))** via BFS from each node (or two BFS on trees). |
| Floyd–Warshall is **dynamic programming** over intermediate vertices k. |
| Dijkstra is **greedy** (local best); Bellman-Ford is **DP/relaxation**; Floyd is **DP**. |
| A DAG's shortest path: **topological order + relax** — O(V + E), handles negative edges! |
| Count paths in a DAG: DP in **topological order** — paths[v] = Σ paths[u] for edges u→v. |
| DSU operations with path compression + union by rank: **α(n) amortized** — effectively O(1). |
| DSU detects cycle in undirected: **union(a,b) returns false if already connected**. |
| Number of connected components via DSU: **track component count on successful unions**. |
| DSU does **not** work for directed graph cycle detection (union is symmetric). |
| Johnson's all-pairs: **Bellman-Ford + Dijkstra per vertex** — O(V² log V + VE) for sparse. |
| Second shortest path: run Dijkstra twice (from s, from t) or track **two best distances per node**. |
| K-core decomposition: iteratively remove vertices with degree < k — **O(V + E)**. |
| A graph with n vertices and n−1 edges but disconnected: a **forest** (multiple trees). |
| In-degree vs out-degree: in = edges entering, out = leaving — equal in **undirected** (just degree). |

---

## 12. Backtracking

| Statement (with answer) |
|---|
| Backtracking = **systematic trial with undo** — build candidate, recurse, **revert state**. |
| Backtracking is a **DFS** over a state/decision tree. |
| Subsets of n elements: **2ⁿ** — bitmask enumeration or backtrack include/exclude. |
| Permutations of n elements: **n!** — swap/backtrack or used[] array. |
| Combinations n choose k: **C(n, k)** — start-index trick to avoid duplicates. |
| Combination sum (reuse allowed): recurse **with the same index**; without reuse: **i + 1**. |
| To avoid duplicate subsets with duplicate elements: **sort + skip equal neighbors** at the same level. |
| Palindrome partitioning: cut at every valid **prefix palindrome** — O(n·2ⁿ). |
| N-Queens: **row by row**, try each column — attack check O(1) with 3 sets (cols, diag1, diag2). |
| N-Queens diagonal index trick: **r + c** for one diagonal, **r − c** for the other. |
| Number of N-Queens solutions grows like **n!** — backtracking prunes, brute force does not. |
| Sudoku: try digits **1–9** in empty cells, validate row/col/box — O(9^empty). |
| Sudoku box index: **(r/3)*3 + c/3**. |
| Word search: DFS on **each cell as start**, mark visited, **unmark on backtrack** — O(mn·4^len). |
| Word search II: **Trie + DFS** — prune paths not in the trie. |
| Generate parentheses: only add `(` if **open < n**, `)` if **close < open** — Catalan count C_n. |
| Letter combinations of a phone number: **cartesian product** of digit letters — O(4ⁿ). |
| Restore IP addresses: 3 cuts, each part **0–255, no leading zeros** — O(3⁴·n). |
| Knight's tour / Hamiltonian path backtracking: **Warnsdorff's rule** (fewest onward moves first) speeds it up. |
| Rat in a maze: DFS with **visited grid**, 4 directions, backtrack — O(4^(mn)) worst. |
| The "undo" step (pop from path, unmark visited) is what distinguishes **backtracking from brute recursion**. |
| Backtracking vs greedy: greedy commits **irreversibly**; backtracking **reconsiders**. |
| Backtracking vs DP: overlapping subproblems → **DP**; many distinct states → **backtracking**. |
| State space of subsets is **2ⁿ**; of permutations **n!**; of grid paths **O(4^cells)**. |
| Pruning order matters: try the **most constrained** choice first (MRV heuristic). |
| Generate all valid parentheses count: **Catalan C_n = C(2n,n)/(n+1)** — check 3 → 5, 4 → 14. |
| Combination sum sorting input: helps **early pruning** when remaining sum < current element. |
| Permutations via swapping is **O(n!)** but no used[] array — swap is the "undo". |
| Permutations with duplicates: **skip swapping with an already-used equal element** at this level. |
| Subsets via bitmask: iterate **0..2ⁿ−1**, include bit i if set — simpler than recursion. |
| Gray code: consecutive numbers differ by **one bit** — backtracking / mirror construction. |
| Partition into k equal-sum subsets: **backtracking with descending sort + used[]** — O(k·2ⁿ). |
| Matchsticks to square = **partition into 4 equal sums** — classic backtracking MCQ. |
| Backtracking terminates because each step **shrinks the remaining state** (depth ≤ input size). |
| Depth of recursion in backtracking = **size of the candidate solution**. |
| Time of generic backtracking = **number of nodes in the search tree** × work per node. |
| Memoizing a backtracking search turns it into **top-down DP** — the boundary between the two. |
| Solve the "Target sum ±" problem: backtracking O(2ⁿ) or **DP** O(n·sum). |
| Word break (segment string into dict words): backtracking O(2ⁿ) or **DP** O(n²). |
| Backtracking is complete and optimal **if it explores everything** — but exponential. |

---

## 13. Greedy

| Statement (with answer) |
|---|
| Greedy: **locally optimal choice at each step** — no backtracking. |
| Greedy works when the problem has **optimal substructure + greedy choice property**. |
| Activity selection: sort by **finish time**, pick earliest finishing compatible — O(n log n). |
| Interval scheduling (max non-overlapping): **earliest finish first** is optimal. |
| Fractional knapsack: take **highest value/weight ratio** first — greedy is optimal. |
| 0/1 knapsack: greedy **fails** — needs DP (O(n·W)). |
| Coin change (canonical coins like 1,5,10,25): greedy **works**; arbitrary coins: greedy **fails**, DP needed. |
| Huffman coding: merge **two smallest frequencies** repeatedly — optimal prefix code. |
| Huffman is optimal: **no other prefix code has smaller expected length**. |
| Huffman code is a **full binary tree**; entropy H ≤ average length < H + 1. |
| MST (Kruskal/Prim) is **greedy** — cut/cycle properties guarantee optimality. |
| Dijkstra is **greedy** — correct only with non-negative weights. |
| Greedy vs DP: greedy **never reconsiders**; DP considers **all choices**. |
| Greedy vs backtracking: greedy is **fast but may be wrong**; backtracking is **exhaustive and correct**. |
| Jump game: farthest reachable greedy — **O(n), O(1)**. |
| Jump game II (min jumps): BFS-level greedy — count **jump endpoints** — O(n). |
| Gas station: if total gas ≥ total cost, a solution exists; start at **first index where cumulative goes negative**. |
| Assign cookies: sort both, give the **smallest cookie that satisfies** — O(n log n). |
| Candy (rating): **two passes** left-to-right and right-to-left — O(n). |
| Minimum platforms (trains): **sort arrival & departure separately** — O(n log n). |
| Minimum arrows to burst balloons: sort by **end**, shoot at end — classic greedy. |
| Merge intervals greedily: sort by **start**, extend end while overlapping. |
| Insert interval: merge the **overlapping middle block** in one shot — O(n). |
| Non-overlapping intervals to remove: same as activity selection — **keep earliest-finishing**. |
| Largest number from array: sort with comparator **a+b > b+a** (concatenation order). |
| Task scheduler (CPU intervals): **most frequent task first, fill gaps** — O(n). |
| Greedy proof structure: **exchange argument** — swap any optimal solution to match greedy without worsening. |
| Greedy choice property: a globally optimal solution **can include the locally optimal choice**. |
| Optimal substructure: optimal solution contains **optimal solutions to subproblems**. |
| Greedy fails on: **0/1 knapsack, arbitrary coin change, longest path** — classic counterexamples. |
| Number of coins greedy example failure: coins {1, 3, 4}, target 6 — greedy gives 4+1+1 = 3 coins, optimal **3+3 = 2 coins**. |
| Fractional knapsack is greedy because you can take **partial items** — divisibility is the key. |
| Egyptian fraction / change-making greedy proofs rely on **coin divisibility** (each coin divides the next). |
| Matroid theory: greedy is optimal exactly on **matroids** (e.g., MST = graphic matroid). |
| Greedy with sorting dominates: most greedy algorithms are **O(n log n)** due to sort. |
| Minimum spanning tree algorithms are greedy; shortest path with negatives is **not** (needs Bellman-Ford). |
| Scheduling to minimize maximum lateness: **earliest deadline first** is optimal. |
| Scheduling to maximize profit (job sequencing with deadlines): **sort by profit desc, assign to latest free slot** — DSU/array O(n²) or O(n log n). |
| Meeting rooms II (min rooms): **min-heap of end times** — O(n log n). |
| Greedy line wrap / text justification: **minimum raggedness** needs DP — greedy "pack as much as fits" is not optimal. |
| Egyptian "largest unit fraction first" greedy always terminates but may not be **optimal** in count. |
| A greedy algorithm that always works has a **matroid or exchange-argument proof**; without proof, suspect it. |

---

## 14. Tries

| Statement (with answer) |
|---|
| Trie = **prefix tree** — each node stores children keyed by **character**; words = root-to-node paths. |
| Search/insert/delete in a trie: **O(L)** where L = word length — independent of n! |
| Trie space: **O(total characters)** (or O(n·L)) — worst case 26× per node (alphabet size). |
| Trie vs hash set: trie supports **prefix queries, ordered iteration, and LCP** — hash is O(1) but no prefixes. |
| Autocomplete: walk to the prefix node, then **DFS/collect all descendants**. |
| Longest common prefix of many strings: trie — **the deepest node through which all n strings pass** (shared path); for two strings it is their LCA node. |
| Trie node needs `is_end` flag — words that are **prefixes of other words** (e.g., "car" vs "cars"). |
| Count words with prefix: store a **subtree word count** at each node. |
| Trie delete: walk down, **remove nodes with no children** bottom-up. |
| Word search II: **build trie of words + DFS the grid** — prunes huge search spaces vs per-word search. |
| Number of distinct substrings: **suffix trie nodes − 1** — O(n²) nodes. |
| Compressed trie (radix tree): merge **single-child chains** — fewer nodes, same prefix queries. |
| Suffix tree: compressed trie of **all suffixes** — O(n) nodes, substring check O(m). |
| Suffix tree construction: **Ukkonen's algorithm O(n)**. |
| Suffix array + LCP: substring search via **binary search on suffixes** — O(m log n). |
| Prefix XOR trick: max XOR pair via trie — insert each prefix XOR, query **greedy opposite bit** — O(n·bits). |
| Maximum XOR of two numbers: trie on **bit strings** — O(n·32). |
| Trie bit usage: 0/1 children — used for **max XOR, min XOR, XOR queries**. |
| IP routing (longest prefix match) uses **tries/radix trees**. |
| T9 predictive text: trie + **DFS restricted by keypad letters**. |
| Replace words (shortest root prefix): trie — stop at **first is_end node** on the path. |
| Design add-and-search with `.` wildcard: **trie + DFS on wildcard** — branch to all children on '.'. |
| Trie iteration order over keys: **lexicographic** (children visited alphabetically). |
| Sparse trie (array of pointers) vs dense: use **hash map children** when alphabet is large. |
| A trie of n strings of avg length L uses **O(n·L)** nodes in the worst case but shares prefixes — less in practice. |
| Trie vs BST for strings: BST compares **whole strings** (O(L log n)); trie compares **char by char** (O(L)). |
| LCP of two strings via trie: **depth of their LCA node**. |
| Suffix trie of "aaaa" has **n+1** nodes — repeated suffixes share heavily; of all-distinct chars, O(n²). |
| Searching a trie for a string that's not present fails at the **first mismatching character** — faster than hash compare. |
| Memory overhead of 26-child array trie: **26 pointers per node** — often waste; compressed/hash-map variants fix it. |
| Top k frequent words with same frequency: trie gives **lexicographic tie-breaking for free**. |

---

## 15. Intervals

| Statement (with answer) |
|---|
| An interval [s, e] overlaps [s', e'] iff **s ≤ e' and s' ≤ e** (not merely endpoint comparison). |
| Merge intervals: **sort by start**, extend current end while next start ≤ end — O(n log n). |
| Merged output count = number of **connected components** of overlapping intervals. |
| Non-overlapping intervals max count: **earliest finish first** — O(n log n) after sorting by end. |
| Min removals to make non-overlapping = **n − max non-overlapping count**. |
| Insert interval: merge the **contiguous overlapping block** — O(n). |
| Meeting rooms needed: **min-heap of end times** — O(n log n). |
| Meeting rooms needed (2-array trick): sort **starts and ends separately**, sweep — O(n log n). |
| Maximum overlap point = **max depth** of the interval nesting — sweep line counter. |
| Employee free time: merge all intervals, find **gaps** — O(n log n). |
| Interval intersection of two sorted lists: **two pointers** on start/end — O(n + m). |
| Union of intervals length: **merged total length**. |
| Cover a target interval with minimum intervals: greedy **farthest reach from current cover** — O(n log n). |
| Greedy coverage choice: among intervals with start ≤ current, pick the one with the **maximum end**. |
| Interval scheduling with weights (weighted): greedy **fails** — DP with binary search prev[i] — O(n log n). |
| Weighted interval DP: `dp[i] = max(dp[i−1], value[i] + dp[prev[i]])` where prev = last non-overlapping. |
| Min arrows to burst balloons = **interval scheduling on ends** — same as max non-overlapping. |
| Non-overlapping interval count is **optimal** by exchange argument — the classic greedy proof. |
| Sort by start vs end: merging needs **start order**; scheduling needs **end order**. |
| Two-pointer overlap check: `max(s1,s2) ≤ min(e1,e2)` gives the **overlap segment**. |
| Intervals on a line: **sweep line** with events (start +1, end −1) solves max overlap — O(n log n). |
| Disjoint intervals from sorted list of points: binary search for **lower_bound of start**. |
| Insert interval into non-overlapping sorted list: skip before, merge middle, append after — **O(n)**. |
| Range queries on intervals (stabbing query: which intervals contain x): **interval tree** — O(log n + k). |
| Data structure for interval union with dynamic inserts: **balanced BST of disjoint intervals** (e.g., TreeMap). |
| Car pooling (capacity on a line): **difference array over stops** — O(n + max_stop). |
| Number of overlapping intervals at a point = **depth**; sweep counter increments on start, decrements on end. |
| Partition labels (merge intervals over letters): **last-occurrence map + greedy extension** — O(n). |
| Intervals are closed [a,b]; if open/half-open, the overlap condition changes at **endpoints**. |
| Merging n intervals requires **Ω(n log n)** in comparison model (sorting lower bound) — unless pre-sorted. |
| If intervals are pre-sorted by start, merge is **O(n)**. |
| Min interval to cover a point (single query): **binary search** on sorted intervals. |

---

## 16. Bit Manipulation

| Statement (with answer) |
|---|
| `n & 1` = least significant bit — **odd/even test**. |
| `n & (n − 1)` clears the **lowest set bit** — popcount loop runs O(#bits set). |
| `n & (n − 1) == 0` iff n is a **power of two**. |
| `n & (−n)` (or n & ~n+1) isolates the **lowest set bit**. |
| `n | (1 << k)` sets bit k; `n & ~(1 << k)` clears bit k; `n ^ (1 << k)` **toggles** bit k. |
| `n >> k & 1` extracts bit k; `1 << k` = **2^k**. |
| `~n` = bitwise NOT = **−n − 1** (two's complement). |
| `−n` in two's complement = **~n + 1**. |
| XOR is its own inverse: **a ^ a = 0, a ^ 0 = a**. |
| XOR of 1..n: n%4==0→n, 1→1, 2→n+1, 3→0 — **O(1) prefix XOR formula**. |
| Single number in array with all others twice: **XOR everything** — O(n)/O(1). |
| Two single numbers: XOR all → `x = a^b`; split by **lowest set bit of x** — two groups. |
| Missing number 0..n: **XOR indices with values**. |
| Left shift `x << k` = **x·2^k**; right shift `x >> k` = **floor(x / 2^k)** (arithmetic for signed). |
| Logical (unsigned) right shift `>>>` (Java): **zero-fills** — -8 >>> 1 = 2147483644. |
| Arithmetic right shift: **sign-extends** — -8 >> 1 = -4. |
| `x * 8` = `x << 3`; `x / 8` = `x >> 3` (for positive). |
| `x & (x − 1)` in a loop counts set bits: **O(k)** for k set bits (Brian Kernighan). |
| `Integer.bitCount(x)` / `__builtin_popcount` / `bin(x).count("1")` — **O(1) popcount**. |
| Gray code of n: **n ^ (n >> 1)**; consecutive Gray codes differ in one bit. |
| Subsets via bits: iterate **mask 0..2ⁿ−1** — include element i if `mask & (1 << i)`. |
| Count of set bits in mask: popcount; **all n-bit masks = 2ⁿ**. |
| `(1 << 31)` is **negative** in signed 32-bit int — the sign bit. |
| Left-shifting into the sign bit is **undefined behavior** in C/C++ (use unsigned). |
| `x ^ y ^ y` = **x** — the swap trick: `a ^= b; b ^= a; a ^= b`. |
| XOR swap fails when **a and b alias the same variable** — result 0. |
| Sum without +: `a + b = (a ^ b) + ((a & b) << 1)` — **recursive carry** trick. |
| Multiply by 3.5: `(x << 2) − (x >> 1)` — shift arithmetic. |
| Check if two ints have opposite signs: **`(a ^ b) < 0`**. |
| Absolute value without branch: `(x ^ (x >> 31)) − (x >> 31)` (32-bit). |
| `n & (−n)` gives the value of the lowest set bit — **Fenwick tree core operation**. |
| Fenwick update: `i += i & (−i)`; query: `i −= i & (−i)` — **lowest-bit jumps**. |
| Bitmask DP: state = **set of used items** — e.g., TSP O(2ⁿ·n²). |
| Bitmask subset iteration: `for (s = mask; s; s = (s−1) & mask)` enumerates **all submasks** — O(3ⁿ) total. |
| Enumerating submasks of all masks: **O(3ⁿ)**, not 4ⁿ. |
| `mask & (mask − 1) == 0` vs `mask == 0` — the power-of-two check **misses 0**; handle separately. |
| Integer overflow in `1 << k` when k ≥ 32 — use `1L << k` or **1ULL**. |
| `x % 2^k` = `x & (2^k − 1)` — mask of k low bits. |
| Round up to power of two: fill all bits below the top one, then +1. |
| Lowest set bit position: `__builtin_ctz(x)` (count trailing zeros) — O(1). |
| Highest set bit: **31 − __builtin_clz(x)** — floor(log₂ x). |
| Reversing bits of a 32-bit int: **divide and conquer swaps** (16, 8, 4, 2, 1) — O(1). |
| `n ^ n = 0` lets you find odd-frequency element in **even-pair arrays** — the "every number appears twice except one" pattern. |
| Counting bits of 1..n: DP — `dp[i] = dp[i >> 1] + (i & 1)` — **O(n)**. |
| Division by powers of 2 with negatives: `-7 >> 1 = -4` (floor), but `-7 / 2 = -3` in C — **shift ≠ C division for negatives** (rounds toward −∞). |
| Bitwise ops on negative numbers follow **two's complement** representation. |
| In Python, `~x = -x - 1` and ints are **unbounded** — `1 << 100` is fine. |
| To test bit from the RIGHT: `n >> k & 1`; from the LEFT (MSB): use **31 − k**. |
| XOR of even count of the same number = **0**; odd count = the number. |
| AND of range [m, n]: find **common prefix** of m and n — shifts until equal, then shift back. |
| `a & b` ≤ min(a, b) ≤ max(a, b) ≤ `a | b` — AND lowers, OR raises. |
| Hamming distance = **popcount(a ^ b)**. |
| Hamming weight of 0 is 0; of 2^k is **1**. |
| A byte (8 bits) stores **0–255**; a nibble (4 bits) stores **0–15** (one hex digit). |
| Hex `0xFF` = 255 = **8 ones** — the byte mask. |
| Little-endian: least significant byte at **lowest address** (x86); big-endian: **highest address** (network order). |
| `htonl`/`ntohl` convert **host ↔ network byte order** — needed for portable socket code. |
| Bit fields in C structs: pack flags tightly but are **implementation-defined** (order/alignment). |
| `1 << 31` as unsigned = 2147483648 — safe; as int, **UB/negative**. |

---

## 17. Dynamic Programming

| Statement (with answer) |
|---|
| DP applies when there is **overlapping subproblems + optimal substructure**. |
| Optimal substructure: optimal solution = optimal solutions **of subproblems** combined. |
| Overlapping subproblems: the **same subproblem is solved repeatedly** — memoization saves it. |
| Divide & conquer vs DP: D&C subproblems are **disjoint** (merge sort); DP subproblems **overlap** (fibonacci). |
| Top-down DP = **recursion + memo**; bottom-up = **iterative table fill**. |
| Top-down computes only **needed states**; bottom-up computes **all states in order**. |
| Top-down space = table + **recursion stack**; can hit stack overflow. |
| Bottom-up order = **reverse topological order** of the dependency graph. |
| 0/1 knapsack: `dp[i][w] = max(dp[i-1][w], val + dp[i-1][w − wt])` — **O(n·W)** pseudo-polynomial. |
| Knapsack is **NP-hard** but pseudo-poly in W — "not polynomial in input size (bits of W)". |
| Knapsack 1-D optimization: iterate **w from W down to wt** — avoids reusing the same item. |
| Unbounded knapsack (reuse allowed): iterate **w from wt up** — reuse is allowed by direction. |
| Coin change min coins: `dp[a] = min(dp[a], 1 + dp[a − c])` — **O(n·amount)**. |
| Coin change count of ways: `dp[a] += dp[a − c]` — order matters for **combinations vs permutations**. |
| Coin-combination loop order: **coins outer, amount inner** = combinations (order-insensitive). |
| Coin-permutation loop order: **amount outer, coins inner** = permutations (order-sensitive). |
| LCS: `dp[i][j] = dp[i−1][j−1] + 1` if equal else **max(dp[i−1][j], dp[i][j−1])** — O(m·n). |
| LCS length vs string: to reconstruct, **backtrack from dp[m][n]**. |
| LCS of two strings of length n can be done in **O(n²)** time, O(min(m,n)) space. |
| Longest increasing subsequence (LIS): DP **O(n²)**; patience sorting + binary search **O(n log n)**. |
| LIS patience: tails array; replace **first element ≥ x** — length = size of tails. |
| LIS reconstruction: keep **predecessor indices**. |
| Edit distance: insert/delete/replace — `dp[i][j]` min of three **+1 cases** (or +0 if equal). |
| Edit distance initialization: **dp[i][0] = i, dp[0][j] = j** (base = insert/delete everything). |
| Matrix chain multiplication: **O(n³)** — split at k: `dp[i][j] = min(dp[i][k] + dp[k+1][j] + cost)`. |
| Number of BSTs with n nodes = **Catalan** — DP recurrence C_n = Σ C_i·C_{n−1−i}. |
| Word break: `dp[i] = OR(dp[j] AND s[j:i] in dict)` — **O(n²)**. |
| Palindrome partitioning min cuts: **O(n²)** with precomputed palindrome table. |
| Longest palindromic subsequence: **LCS(s, reverse(s))** or direct interval DP — O(n²). |
| Interval DP pattern: `dp[l][r]` over **subarrays** — burst balloons, palindrome partitions. |
| Burst balloons: `dp[l][r] = max(dp[l][k−1] + dp[k+1][r] + nums[l−1]·nums[k]·nums[r+1])` — O(n³). |
| Rod cutting: unbounded knapsack with **weights = lengths, values = prices** — O(n²). |
| DP on trees: postorder combine children — **house robber III, diameter, max path sum**. |
| House robber: `dp[i] = max(dp[i−1], nums[i] + dp[i−2])` — **O(n), O(1)** with two vars. |
| House robber II (circular): run twice — **exclude first, exclude last** — take max. |
| Climbing stairs: **Fibonacci** — `dp[i] = dp[i−1] + dp[i−2]`. |
| Unique paths in grid: **C(m+n−2, m−1)** closed form — DP O(m·n) also fine. |
| Unique paths with obstacles: `dp[i][j] = 0` if obstacle else **sum of top and left**. |
| Minimum path sum: `dp[i][j] = grid[i][j] + min(top, left)` — **O(m·n)**. |
| Triangle min path: **bottom-up** — simpler than top-down. |
| Maximum subarray (Kadane): `dp[i] = max(nums[i], dp[i−1] + nums[i])` — **O(n)/O(1)**. |
| Kadane is DP — the state is "max sum **ending here**". |
| Maximum product subarray: track **max and min** (negatives flip) — O(n). |
| Best time to buy/sell (1 trade): **min price so far** — O(n)/O(1). |
| Buy/sell unlimited: **sum positive day-diffs** — greedy O(n). |
| Buy/sell with cooldown: **state machine DP** (held/sold/rest) — O(n). |
| Buy/sell k trades: `dp[t][i] = max(dp[t][i−1], price[i] + max(dp[t−1][j] − price[j]))` — O(k·n). |
| Target sum (± signs): DP over **sums** — O(n·sum); counts states shifted by +sum. |
| Partition equal subset sum: **0/1 knapsack with W = total/2** — O(n·sum). |
| Subset sum exists iff **knapsack dp[sum] reachable**. |
| TSP bitmask DP: `dp[mask][i]` = min cost visiting mask ending at i — **O(2ⁿ·n²)**. |
| Bitmask DP state space **2ⁿ** — only for n ≤ ~20. |
| Edit distance vs LCS relation: **edit_distance(a,b) = |a| + |b| − 2·LCS(a,b)** (insert/delete only). |
| Longest repeating subsequence: **LCS(s, s) with i ≠ j constraint** — O(n²). |
| Count distinct subsequences: `dp[i] = 2·dp[i−1] − dp[last[c] − 1]` — **O(n)** with last-occurrence map. |
| Interleaving string: `dp[i][j]` = can s3[0..i+j] interleave s1[0..i], s2[0..j] — O(m·n). |
| Wildcard matching DP: `*` matches **empty or any** — two transitions. |
| Regex matching DP: `*` applies to **previous char zero+ times** — look-back dp[i][j−2]. |
| Egg drop (min worst-case trials): classic DP **O(n·k²)**; optimal O(n·k) with monotonic split. |
| State reduction: 2D → 1D by **rolling arrays** when dp[i] depends only on dp[i−1]. |
| DP table direction must follow **dependency** — fill values **after** their inputs. |
| DP vs memoized recursion: same complexity; iterative avoids **recursion overhead** and stack limit. |
| Pseudo-polynomial algorithm: polynomial in **numeric value**, not input bits — knapsack O(nW). |
| Strongly NP-hard problems (TSP): **no pseudo-poly algorithm** unless P=NP. |
| DP over bitmasks, over trees, over intervals, over **two sequences (LCS), over sums (knapsack)** — know the five shapes. |
| Catalan DP applications: BSTs, parentheses, triangulations, mountain ranges, Dyck paths. |
| Min cost climbing stairs: `dp[i] = cost[i] + min(dp[i−1], dp[i−2])` — **O(n)**. |
| Decode ways: `dp[i] = dp[i−1] + dp[i−2]` with **validity checks** on 1- and 2-digit codes — O(n). |
| DP recurrence identification: define state, define transition, define **base cases**, choose direction. |
| Number of longest increasing subsequences: track **count[i] alongside len[i]**. |
| Russian doll envelopes: sort by w asc, h **desc**, then **LIS on h** — O(n log n). |
| Weighted interval scheduling (prev pointer + DP): **O(n log n)**. |
| DP with binary search optimization: prev[] via **lower_bound on sorted end times**. |
| Digit DP: count numbers ≤ X with property — states: **pos, tight, started** — O(digits·states). |
| DP with divide & conquer optimization / CHT / monotone queues are **O(n²) → O(n log n) / O(n)** speedups — advanced but MCQ-relevant names. |
| Space for 0/1 knapsack 1-D: **O(W)**; for LCS: **O(min(m,n))**. |
| DP can count, optimize, or decide **feasibility** — three question types. |
| If greedy works, DP also works but slower — DP is the **fallback when greedy fails**. |
| Memoization key = **all parameters that determine the state** — forgetting one breaks correctness. |
| Base cases are the **smallest subproblems** — e.g., dp[0], dp[i][0], empty strings. |
| Counting DP uses **sums**; optimizing DP uses **min/max**; boolean DP uses **OR/AND**. |

---

## 18. Advanced Design

| Statement (with answer) |
|---|
| LRU cache: **doubly linked list + hash map** — get/put **O(1)**. |
| LRU eviction: remove the **least recently used** — list tail after move-to-front on access. |
| LFU cache: track **frequency counts** — evict least frequently used; tie → LRU. |
| LFU implementation: hash map + **min-heap of (freq, time)** or freq-buckets with DLLs — O(log n) or O(1). |
| Union-Find: `find` with path compression + `union` by rank/size — **α(n) amortized ≈ O(1)**. |
| Path compression: every node on the find path **points directly to the root**. |
| Union by rank: attach the **smaller tree under the larger** — keeps height O(log n). |
| DSU find is **O(α(n)) amortized** — not technically O(1), but effectively constant. |
| Segment tree: range min/max/sum queries + point updates in **O(log n)**; build O(n). |
| Segment tree size: **4n** array is the safe bound. |
| Lazy propagation: **defer range updates** until children are actually accessed — O(log n) range update. |
| Fenwick tree (BIT): prefix sums + point updates **O(log n)** with **n+1** space — smaller than segtree. |
| Fenwick supports only **invertible** operations for range queries (sum, xor — not max). |
| Sparse table: **immutable** range min/max queries **O(1)** after O(n log n) build — no updates. |
| Sparse table query: two overlapping blocks of size 2^k — works because min/max are **idempotent** (sum would double-count). |
| LRU vs LFU: LRU uses **recency**; LFU uses **frequency** — different workloads win. |
| Randomized Set O(1) insert/delete/getRandom: **hash map (val→index) + array + swap-with-last delete**. |
| Design a rate limiter (token bucket): refill tokens at a **fixed rate**, capacity cap — O(1) per request. |
| Sliding window rate limiter: **queue of timestamps** — O(1) amortized per request. |
| Median of data stream: **two heaps** (max left + min right) — insert O(log n), median O(1). |
| Design Twitter/news feed: **map user→tweets + merge k lists (heap)** — O(k log k) per feed. |
| Autocomplete system: **trie + top-k lists cached per node** — O(prefix + k). |
| Design a key-value store with TTL: hash map + **min-heap of (expiry, key)** — lazy deletion. |
| Consistent hashing: hash **servers and keys on a ring** — add/remove server moves only ~1/n keys. |
| Consistent hashing solves **rehashing storms** when a server joins/leaves. |
| Bloom filter: **probabilistic set** — false positives possible, **false negatives impossible**. |
| Bloom filter uses **k hash functions** on an m-bit array; space O(m), check O(k). |
| Bloom filter is for "**maybe present / definitely absent**" — great for cache filters, spell-check pre-checks. |
| Count-min sketch: **approximate frequency** with overestimation only — streaming heavy hitters. |
| Skip list: layered linked lists with **random levels** — search/insert/delete O(log n) expected. |
| Skip list vs BST: skip list is **probabilistically balanced** and simpler to implement. |
| Design a stack with increment operation: **lazy increments array** — O(1) per op. |
| Design a queue using stacks: **amortized O(1)** — the two-stack trick. |
| Min/max stack: **auxiliary stack of running min/max** — O(1). |
| Snapshot array (binary search per index over history): **O(log n)** per get. |
| Design browser history (back/forward): **two stacks** — O(1) visits. |
| Circular buffer: fixed-size ring for **streams/producers-consumers** — O(1) enqueue/dequeue. |
| Design HashMap: **array of buckets + chaining**, rehash at load factor 0.75. |
| Design a log/storage system with id: **hash + binary search on timestamps**. |
| LFU tie-breaking by LRU: store buckets keyed by freq, each a **DLL in recency order**. |
| Persistent segment tree: **versioned roots** — O(log n) per version — used for kth smallest in range. |
| Kth smallest in a subarray range: **merge sort tree or persistent segtree** — O(log² n) / O(log n). |
| Design an ordered set: **balanced BST (TreeSet)** — floor/ceil/rank in O(log n). |
| Top k heavy hitters exact: **hash map + min-heap** — O(n log k). |
| Approximate heavy hitters: **count-min sketch or lossy counting** — O(n) with ε-error. |
| Disjoint set with rollback: **persistent DSU** — union with stack of changes. |
| Design a text editor with undo/redo: **two stacks (undo/redo)** or command pattern. |
| Design a file system (trie of paths): **path → node map**, nodes with children map — O(L) per path part. |
| LRU in Java: `LinkedHashMap` with **accessOrder=true** + removeEldestEntry — O(1) built-in. |
| Order statistic tree: BST augmented with **subtree sizes** — kth smallest O(log n). |
| Interval tree / segment tree on **coordinates** handles range overlap queries O(log n + k). |
| Design a parking lot / elevator: **state machines + priority queues (closest request)**. |
| Consistent hashing virtual nodes: **multiple points per server** smooth the distribution. |
| CAP theorem: a distributed system can guarantee only **two of C, A, P** simultaneously. |
| MapReduce: **map (transform) + shuffle (group) + reduce (aggregate)** — batch processing paradigm. |
| External merge sort: sort chunks that fit in **RAM**, then k-way merge from disk — O(N log N) I/O-efficient. |
| B-trees in databases: keep the tree **short and wide** to minimize disk seeks. |
| Write-ahead log (WAL): log **before** applying changes — crash recovery. |
| LSM trees: **append-only memtable + sorted runs + compaction** — write-optimized storage. |
| Read-through/write-through/write-back caches: **consistency vs latency** tradeoffs. |
| Sharding: split data by **key hash** across nodes — scalability; range sharding for scans. |
| Replication (leader-follower): reads scale, writes go to **leader**. |
| Quorum (R + W > N): ensures **read-your-writes** consistency. |
| Vector clock: **causal ordering** of concurrent events in distributed systems. |
| Merkle tree: hash tree for **efficient integrity checking/sync** (git, blockchain). |

---

## 19. Classical Differences & Comparisons

| Question | Answer |
|---|---|
| Array vs Linked List | Array: O(1) random access, O(n) mid insert; List: O(n) access, O(1) head insert. Array cache-friendly, fixed/amortized size. |
| Stack vs Queue | LIFO vs FIFO; stack for backtracking/undo/expression; queue for BFS/scheduling. |
| BFS vs DFS | BFS = shortest path (unweighted), level order, queue, O(V+E); DFS = connectivity/cycle/topo, stack/recursion, O(V+E). |
| BST vs Hash Table | BST ordered ops O(log n), hash O(1) average unordered; use BST for range/rank/successor. |
| Min-heap vs Max-heap | Root = min vs max; choose by what you pop: kth largest → min-heap size k. |
| Dijkstra vs Bellman-Ford | Dijkstra: non-negative only, greedy, O((V+E) log V); BF: negatives OK, detects neg cycles, O(VE). |
| Dijkstra vs Floyd-Warshall | Single-source vs **all-pairs**; heap vs O(V³) matrix DP. |
| Kruskal vs Prim | Both MST O(E log E)-ish; Kruskal = sort + DSU (sparse); Prim = heap (dense). |
| Prim vs Dijkstra | Both greedy + heap — Prim relaxes **edge weight to tree**; Dijkstra relaxes **distance from source**. |
| Quick sort vs Merge sort | Quick: in-place, average O(n log n), worst O(n²), unstable; Merge: O(n log n) always, stable, O(n) extra. |
| Heap sort vs Merge sort | Heap: in-place, unstable; Merge: stable but O(n) space — both O(n log n). |
| Insertion sort vs Selection sort | Insertion: adaptive O(n) best, stable; Selection: Θ(n²) always but **O(n) swaps**. |
| Recursion vs Iteration | Recursion: call-stack overhead, risk of overflow, elegant; iteration: O(1) stack. |
| Top-down DP vs Bottom-up DP | Memo recursion vs table fill; same complexity, bottom-up avoids stack limit. |
| Greedy vs DP | Greedy: one choice, never reconsidered, fast, sometimes wrong; DP: all choices, always right (given correct recurrence), slower. |
| Backtracking vs DP | Backtracking: explore distinct paths (exponential); DP: reuse overlapping results (polynomial). |
| Trie vs Hash set for strings | Trie: prefix/lexicographic queries O(L); hash: O(1) membership, no prefix support. |
| Segment tree vs Fenwick | Segment: any associative op + range updates (lazy), 4n; Fenwick: prefix-only invertible ops, n+1, simpler/faster. |
| Segment tree vs Sparse table | Sparse: O(1) immutable range queries, no updates; segment: O(log n) with updates. |
| AVL vs Red-Black | AVL stricter balance (faster search), more rotations; RB looser (faster insert/delete). |
| BFS shortest path vs Dijkstra | BFS = unweighted (edge count); Dijkstra = weighted non-negative. |
| Floyd's cycle vs Hash set cycle | Floyd O(1) space; hash set O(n) space — same O(n) time. |
| Linear vs Binary search | O(n) unsorted OK vs O(log n) sorted-only. |
| Counting/Radix sort vs Comparison sorts | O(n+k)/O(n·d) vs Ω(n log n) — non-comparison beats the bound by **indexing keys**. |
| Min-heap size k vs Quickselect for kth | Heap O(n log k) deterministic; quickselect average O(n) but worst O(n²). |
| Adjacency list vs matrix | List: O(V+E) space, iterate neighbors fast; matrix: O(V²), O(1) edge check, good dense. |
| Kahn vs DFS topological sort | Kahn: indegree queue, order by construction; DFS: finishing times, recursion stack detects cycles. |
| Dynamic array vs static array | Resizable amortized O(1) push vs fixed size — same O(1) access. |
| LRU vs LFU | Recency vs frequency — LRU better for temporal locality, LFU for popularity skew. |
| HashMap vs TreeMap | O(1) unordered vs O(log n) sorted keys — TreeMap for range/floor/ceiling. |
| ArrayList vs LinkedList (Java) | Random access vs head inserts — ArrayList wins almost always for CPU caches. |
| Bellman-Ford vs SPFA | Same logic; SPFA queues relaxations — faster average, worst still O(VE). |
| Huffman vs Shannon-Fano | Both prefix codes; Huffman is **optimal** — Shannon-Fano is not always. |
| B-tree vs B+ tree | B+: all data in leaves + linked leaves → **range scans**; B: data in internal nodes too. |
| DFS cycle vs DSU cycle (undirected) | Both correct; DFS O(V+E) on the whole graph, DSU incremental **per edge** — DSU for streaming edges. |
| Recursive vs iterative tree traversal | Recursive O(h) implicit stack; iterative explicit stack; Morris O(1). |
| String concatenation `+` vs StringBuilder | O(n²) vs amortized O(n) in loops — immutability copies each time. |
| equals vs == (Java) | Content vs reference identity — pool/caching make == sometimes true. |
| `pass by value` (Java objects) vs C++ references | Java copies the reference; C++ reference is an alias — both mutate shared objects. |
| `int` vs `Integer` | Primitive (no null) vs wrapper object (nullable, cache −128..127, boxing cost). |
| `is` vs `==` (Python) | Identity vs value — small-int/string interning makes is "sometimes" true. |
| `//` vs `/` (Python) | Floor division vs true division — -5//2 = -3, -5/2 = -2.5. |
| Shallow vs deep copy | Shallow shares nested objects; deep copies recursively — `copy.copy` vs `copy.deepcopy`. |
| List vs tuple (Python) | Mutable vs immutable/hashable — tuples can be dict keys. |
| Set vs frozenset | Mutable vs immutable/hashable — frozenset can be a dict key. |
| `sort()` vs `sorted()` | In-place (returns None) vs new list — sorted works on any iterable. |
| Generator vs list comprehension | Lazy one-shot iterator vs eager list — memory O(1) vs O(n). |
| `__str__` vs `__repr__` | Human-readable (print) vs unambiguous (containers, repr()). |
| `staticmethod` vs `classmethod` | No cls vs gets cls (subclass-aware) — classmethod for factories. |
| `nonlocal` vs `global` | Enclosing function scope vs module scope. |
| `stack` vs `heap` memory | Stack: function frames, LIFO, fast, limited; heap: dynamic, malloc/new, manual/GC. |
| `const char*` vs `char* const` | Pointer to const data vs const pointer — read from right to left. |
| `sizeof(arr)` vs `sizeof(ptr)` | Whole array vs 8 bytes pointer — arrays decay in function params. |
| `strlen` vs `sizeof` | Runtime length till NUL vs compile-time byte size. |
| `struct` vs `union` | Fields coexist vs share the same memory — union size = largest member. |
| `#define` vs `const`/`constexpr` | Textual replacement (no type/scope) vs typed scoped constant. |
| `malloc` vs `calloc` | Uninitialized vs zero-initialized — calloc takes count, size. |
| `free` vs `delete` | malloc pairing vs new pairing — mixing is UB. |
| `++i` vs `i++` | Pre-increment returns new value (cheaper for iterators) vs post returns old copy. |
| `x++ + ++x` | **Undefined behavior** — multiple unsequenced writes. |
| `&&` vs `&` | Logical short-circuit vs bitwise — `&` evaluates both sides. |
| `|` vs `||` | Bitwise vs short-circuit OR. |
| Overload vs Override | Compile-time same-name different-params vs runtime virtual dispatch same signature. |
| Static vs dynamic binding | Static: static/private/final methods, resolved by reference type; dynamic: virtual methods by object type. |
| Exception vs Error (Java) | Recoverable vs fatal (OutOfMemory, StackOverflow) — catch Exception, not Error. |
| checked vs unchecked exceptions | Must declare/catch (IOException) vs RuntimeExceptions — compile vs runtime enforcement. |
| `throw` vs `throws` | Throw an exception vs declare it in signature. |
| `final` vs `finally` vs `finalize` | Constant/sealed vs always-run block vs deprecated GC hook. |
| `String` vs `StringBuilder` vs `StringBuffer` | Immutable vs mutable fast vs mutable **thread-safe (synchronized, slower)**. |
| `HashMap` vs `Hashtable` | HashMap: null keys, not synchronized; Hashtable: legacy, synchronized, no nulls. |
| `ArrayList` vs `Vector` | ArrayList not synchronized; Vector legacy synchronized — prefer ArrayList. |
| `TreeSet` vs `HashSet` | Sorted O(log n) vs unsorted O(1). |
| `PriorityQueue` (Java) vs C++ `priority_queue` | Java min-heap default; C++ max-heap default — comparator directions flip. |
| `Comparator` vs `Comparable` | External multiple strategies vs intrinsic natural order. |
| Interface vs abstract class | Multiple inheritance vs single + state; interface = contract, abstract = partial implementation. |
| Composition vs inheritance | Has-a vs is-a — composition more flexible, prefer it. |
| Overload resolution: widening vs boxing | Widening **wins** over boxing; boxing wins over varargs. |
| `synchronized` method vs block | Locks `this`/class for whole method vs smaller critical section — block is finer-grained. |
| `volatile` vs `synchronized` | Visibility only vs visibility + atomicity — volatile doesn't make ++ atomic. |
| Thread vs Runnable | Thread = worker (can't extend other classes); Runnable = task (preferred). |
| `wait` vs `sleep` | Releases the monitor vs holds it — wait is for inter-thread signaling. |
| Callable vs Runnable | Returns a value / throws checked exceptions vs void. |
| `start()` vs `run()` | New thread vs same thread — run() is just a method call. |
| Stack vs Heap (Java) | Primitives + refs on stack; objects on heap — GC manages heap. |
| HashMap vs ConcurrentHashMap | CHM: fine-grained locking, no full-map lock, no null keys/values. |
| `getClass() == X.class` vs `instanceof` | Exact type vs subclass-compatible — instanceof true for subclasses. |
| Primitive vs wrapper array | int[] vs Integer[] — autoboxing converts but costs. |
| Wildcard `? extends` vs `? super` | Read (producer) vs write (consumer) — PECS: Producer Extends, Consumer Super. |
| Type erasure consequence | Generic types vanish at runtime — `List<String>` and `List<Integer>` have the same class. |
| `new String("x")` vs literal | New object on heap vs **string pool** — pool saves memory. |
| `==` on boxed vs primitive | Unboxes for mixed comparison; `==` on two Integers compares **references** — cache makes small values equal. |
| `System.exit(0)` in try | finally **does not run** — JVM halts immediately. |
| `return` in try vs finally | finally's return **overrides** the try's return. |

---

## 20. Recurrences & Complexity Cheat Table

| Algorithm / Operation | Best | Average | Worst | Space |
|---|---|---|---|---|
| Linear search | O(1) | O(n) | O(n) | O(1) |
| Binary search | O(1) | O(log n) | O(log n) | O(1) iter / O(log n) rec |
| Bubble sort | O(n) | O(n²) | O(n²) | O(1) |
| Selection sort | O(n²) | O(n²) | O(n²) | O(1) |
| Insertion sort | O(n) | O(n²) | O(n²) | O(1) |
| Merge sort | O(n log n) | O(n log n) | O(n log n) | O(n) |
| Quick sort | O(n log n) | O(n log n) | O(n²) | O(log n) |
| Heap sort | O(n log n) | O(n log n) | O(n log n) | O(1) |
| Counting sort | — | O(n + k) | O(n + k) | O(k) |
| Radix sort | — | O(d·(n + k)) | O(d·(n + k)) | O(n + k) |
| Bucket sort | — | O(n + k) | O(n²) | O(n + k) |
| Heapify (build) | — | O(n) | O(n) | O(1) |
| Heap insert / extract | — | O(log n) | O(log n) | O(1) |
| BST ops (balanced) | — | O(log n) | O(log n) | O(n) |
| Hash map ops | O(1) | O(1) | O(n) | O(n) |
| Trie ops | — | O(L) | O(L) | O(n·L) |
| BFS / DFS | — | O(V + E) | O(V + E) | O(V) |
| Dijkstra (heap) | — | O((V+E) log V) | O((V+E) log V) | O(V) |
| Bellman-Ford | — | O(V·E) | O(V·E) | O(V) |
| Floyd-Warshall | — | O(V³) | O(V³) | O(V²) |
| Kruskal | — | O(E log E) | O(E log E) | O(V) |
| Prim (heap) | — | O((V+E) log V) | O((V+E) log V) | O(V) |
| Topological sort | — | O(V + E) | O(V + E) | O(V) |
| DSU (α amortized) | — | O(α(n)) | O(α(n)) | O(V) |
| Segment tree build/query/update | — | O(n) / O(log n) / O(log n) | same | O(4n) |
| Fenwick update/query | — | O(log n) | O(log n) | O(n) |
| Sparse table build/query | — | O(n log n) / O(1) | same | O(n log n) |
| KMP | — | O(n + m) | O(n + m) | O(m) |
| Rabin-Karp | — | O(n + m) | O(n·m) | O(1) |
| Quickselect | — | O(n) | O(n²) | O(1)/O(log n) |
| Merge k lists (heap) | — | O(N log k) | O(N log k) | O(k) |
| Top k via heap | — | O(n log k) | O(n log k) | O(k) |
| Two-sum (hash) | — | O(n) | O(n) | O(n) |
| Three-sum (two ptr) | — | O(n²) | O(n²) | O(1) |
| Kadane | — | O(n) | O(n) | O(1) |
| LIS (patience) | — | O(n log n) | O(n log n) | O(n) |
| LCS / Edit distance | — | O(m·n) | O(m·n) | O(min(m,n)) |
| 0/1 knapsack | — | O(n·W) | O(n·W) | O(W) |
| Subsets (enumeration) | — | O(2ⁿ) | O(2ⁿ) | O(n) stack |
| Permutations (enumeration) | — | O(n!) | O(n!) | O(n) stack |
| TSP (bitmask DP) | — | O(2ⁿ·n²) | O(2ⁿ·n²) | O(2ⁿ·n) |
| Naive Fibonacci | — | O(2ⁿ) | O(2ⁿ) | O(n) |
| Memo Fibonacci | — | O(n) | O(n) | O(n) |
| Matrix exponentiation power | — | O(k³ log n) | O(k³ log n) | O(k²) |
| Sieve of Eratosthenes | — | O(n log log n) | O(n log log n) | O(n) |
| GCD (Euclid) | — | O(log min(a,b)) | O(log min(a,b)) | O(1) |
| Matrix multiply naive / Strassen | — | O(n³) / O(n^2.81) | same | O(n²) |
| In-place array reverse | — | O(n) | O(n) | O(1) |
| Binary search on answer | — | O(log range · check) | same | O(1) |
| Two heaps median stream | — | O(log n) insert | O(log n) | O(n) |
| Flood fill / islands | — | O(m·n) | O(m·n) | O(m·n) |
| DSU cycle detection | — | O(E·α) | O(E·α) | O(V) |
| Kosaraju / Tarjan SCC | — | O(V + E) | O(V + E) | O(V) |
| Hopcroft-Karp matching | — | O(E√V) | O(E√V) | O(V) |
| Ford-Fulkerson | — | O(E·f) | O(E·f) | O(V) |
| Edmonds-Karp | — | O(V·E²) | O(V·E²) | O(V²) |
