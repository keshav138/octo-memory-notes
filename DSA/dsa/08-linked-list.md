# Linked List

Core techniques: **dummy head**, **fast/slow pointers**, **in-place reversal**, **two-chain splice**.
Most pointer bugs come from not tracking the node *before* the one you modify — use a dummy.

---

## 1. Reverse Linked List
**Pattern:** Three-pointer in-place reversal

**Approach:**
```python
prev, cur = None, head
while cur:
    nxt = cur.next
    cur.next = prev
    prev, cur = cur, nxt
return prev
```

**Complexity:** O(n) time, O(1) space.

---

## 2. Reverse Linked List II (positions l..r)
**Pattern:** Dummy + splice reversal of sublist

**Approach:** Walk to node before `l`; reverse `r-l+1` nodes in place; reconnect `prev` and tail.

**Complexity:** O(n) time, O(1) space.

---

## 3. Middle of Linked List
**Pattern:** Slow/fast

**Approach:** `slow` moves 1, `fast` moves 2. When `fast` is null (or `fast.next` null), `slow` is middle (second middle for even).

**Complexity:** O(n) time, O(1) space.

---

## 4. Linked List Cycle
**Pattern:** Floyd slow/fast

**Approach:** Fast catches slow inside the loop ⇒ cycle exists. `fast` reaches null ⇒ no cycle.

**Complexity:** O(n) time, O(1) space.

---

## 5. Linked List Cycle II (find entry)
**Pattern:** Floyd + reset

**Approach:** After first meet, reset `slow = head`; step both by one; next meeting is the entry.

**Complexity:** O(n) time, O(1) space.

---

## 6. Merge Two Sorted Lists
**Pattern:** Dummy head + compare-and-append

**Approach:** Dummy node; append smaller head; advance; attach remaining list.

**Complexity:** O(n+m) time, O(1) space.

---

## 7. Merge K Sorted Lists
**Pattern:** Min-heap of list heads (or divide & conquer merging)

```cpp
// C++ — heap of (val, list_index) 
priority_queue<pair<int,int>, vector<pair<int,int>>, greater<>> pq;
```
```python
# Python
import heapq
heap = [(node.val, i, node) for i, node in enumerate(lists) if node]
heapq.heapify(heap)
```

**Approach:** Pop smallest head, append, push its `next`. (Add index `i` as tiebreaker in Python to avoid comparing nodes.)

**Complexity:** O(N log k) time, `N` = total nodes.

---

## 8. Remove Nth Node From End
**Pattern:** Gap pointers + dummy

**Approach:** `fast` advances `n` steps; then both advance; `slow` lands before target; unlink.

**Complexity:** O(n) time, O(1) space.

---

## 9. Remove Duplicates from Sorted List
**Pattern:** Single pointer + skip equal values

**Approach:** While `cur.next and cur.next.val == cur.val`: `cur.next = cur.next.next`.

**Complexity:** O(n) time, O(1) space.

---

## 10. Remove Duplicates from Sorted List II (drop ALL duplicates)
**Pattern:** Dummy + look-ahead window

**Approach:** If `cur.next` and `cur.next.next` have equal values, skip the entire run; else advance.

**Complexity:** O(n) time, O(1) space.

---

## 11. Palindrome Linked List
**Pattern:** Middle + reverse second half + compare

**Approach:** Find middle; reverse second half; compare two halves; (optionally restore).

**Complexity:** O(n) time, O(1) space.

---

## 12. Intersection of Two Linked Lists
**Pattern:** Length alignment (or two-pointer A→B→A)

**Approach:** Walk both pointers; when one hits null, jump to the other list's head. They meet at the intersection (or both null).

```python
pa, pb = headA, headB
while pa != pb:
    pa = pa.next if pa else headB
    pb = pb.next if pb else headA
return pa
```

**Complexity:** O(n+m) time, O(1) space.

---

## 13. Reorder List (1→n→2→n-1→…)
**Pattern:** Middle + reverse second half + interleave

**Approach:** Split at middle, reverse second half, merge alternately.

**Complexity:** O(n) time, O(1) space.

---

## 14. Add Two Numbers (digits reversed)
**Pattern:** Sentinel + carry loop

**Approach:** While either list or carry: sum digits + carry; `carry = s // 10`; append `s % 10`.

**Complexity:** O(max(n,m)) time, O(1) space (excluding output).

---

## 15. Copy List with Random Pointer
**Pattern:** Interleaving trick (O(1) space) or hash map (O(n) space)

**Approach (interleave):**
1. Insert clone after each original: `A→A'→B→B'`.
2. Set `clone.random = original.random.next`.
3. Split the two lists.

**Complexity:** O(n) time, O(1) space (map version: O(n) space).

---

## 16. Swap Nodes in Pairs
**Pattern:** Dummy + local pointer rewiring

**Approach:** With `prev` before the pair: `prev.next = second; first.next = second.next; second.next = first; prev = first`.

**Complexity:** O(n) time, O(1) space.

---

## 17. Rotate List (rotate right by k)
**Pattern:** Circle + cut

**Approach:** Count length, `k %= len`; connect tail to head (circle); walk `len - k` steps from head; cut.

**Complexity:** O(n) time, O(1) space.

---

## 18. Odd Even Linked List (group by index parity)
**Pattern:** Two-chain splice

**Approach:** Maintain `odd` and `even` chains; walk two at a time; `odd.next = evenHead` at the end.

**Complexity:** O(n) time, O(1) space.

---

## 19. Partition List
**Pattern:** Two dummy chains (less / greater-equal)

**Approach:** Route nodes into two chains; splice.

**Complexity:** O(n) time, O(1) space.

---

## 20. Flatten a Multilevel Doubly Linked List
**Pattern:** DFS with child pointer (or stack)

**Approach:** Iterate; when node has `child`: push `next` onto stack, link `node ↔ child`, clear child. On list end, pop stack and link.

**Complexity:** O(n) time, O(n) space (stack) / O(1) with recursion+tail re-link.

---

## 21. LRU Cache
**Pattern:** Hash map + doubly linked list — `#design`

**Approach:** Map `key → node`; DLL ordered by recency. `get` → move to head; `put` → insert head, evict tail if over capacity.

**Complexity:** O(1) per operation.

---

## 22. Sort List
**Pattern:** Merge sort (bottom-up or recursive split via slow/fast)

**Approach:** Split at middle (slow/fast), recursively sort halves, merge sorted lists.

**Complexity:** O(n log n) time, O(log n) stack space.

---

## 23. Insert into a Sorted Circular Linked List
**Pattern:** Circular traversal with case handling

**Approach:** Cases: empty list; insert between two nodes; insert at min/max boundary (where `prev > cur`). Use `while cur != head` loop carefully.

**Complexity:** O(n) time, O(1) space.
