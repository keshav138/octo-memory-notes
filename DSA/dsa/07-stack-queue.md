# Stack & Queue

Stacks handle **matching/reversal/recent-undo** problems. Queues handle **ordering/FIFO**.
The most important advanced pattern here is the **monotonic stack** — next greater/smaller in O(n).

---

## 1. Valid Parentheses
**Pattern:** Matching stack

**Approach:** Push opens; on close check match with top; empty at end ⇒ valid.

**Complexity:** O(n) time, O(n) space.

---

## 2. Min Stack
**Pattern:** Pair stack or two-stack (values + running min)

**Approach:** Push `(x, min(x, top_min))`. Or keep second stack that pushes when `x <= min` and pops together on equal.

**Complexity:** O(1) per operation.

---

## 3. Evaluate Reverse Polish Notation
**Pattern:** Operand stack

**Approach:** Number → push; operator → pop two, apply, push. Note order: `b = pop(), a = pop(); push(a op b)`.

**Complexity:** O(n) time, O(n) space.

---

## 4. Daily Temperatures (days until warmer)
**Pattern:** Monotonic **decreasing** stack of indices

**Approach:**
1. While stack non-empty and `t[top] < t[i]`: `ans[top] = i - top`, pop.
2. Push `i`.

**Why decreasing:** warmer day pops everything cooler — each element pushed/popped once.

**Complexity:** O(n) time, O(n) space.

---

## 5. Next Greater Element I
**Pattern:** Monotonic decreasing stack + map

**Approach:** Scan nums2, maintain decreasing stack; when `x > top`, `map[top] = x` and pop. Query nums1 against the map.

**Complexity:** O(n + m) time, O(n) space.

---

## 6. Next Greater Element II (circular)
**Pattern:** Same, scan twice (2n iterations, index mod n)

**Approach:** Loop `i` in `[0, 2n)`, use `i % n`; standard monotonic stack.

**Complexity:** O(n) time, O(n) space.

---

## 7. Largest Rectangle in Histogram
**Pattern:** Monotonic increasing stack of indices

**Approach:**
1. For each bar, when `h[i] < h[stack.top()]`: pop `h`, rectangle width = `i - stack.top() - 1` (or `i` if empty), area = `h * width`.
2. Sentinel: append a 0-height bar at the end to flush.

```
area = heights[popped] * (i - stack[-1] - 1 if stack else i)
```

**Complexity:** O(n) time, O(n) space.

---

## 8. Maximal Rectangle (matrix of 0/1)
**Pattern:** Histogram per row

**Approach:**
1. Row `r`: `heights[j] = heights[j] + 1 if matrix[r][j] == '1' else 0`.
2. Run Largest Rectangle in Histogram on each row's heights.

**Complexity:** O(m·n) time, O(n) space.

---

## 9. Trapping Rain Water
**Pattern:** Monotonic decreasing stack (basin method)

**Approach:** When `h[i] > h[top]`: pop `top`; water above popped bar = `(min(h[i], h[new_top]) - h[popped]) * (i - new_top - 1)`.

**Complexity:** O(n) time, O(n) space.

---

## 10. Remove K Digits (smallest number after removing k digits)
**Pattern:** Monotonic increasing stack with removal budget

**Approach:**
1. While `k > 0` and stack top > current digit: pop, `k--`.
2. Push current digit. Trim leading zeros; if `k` remains, drop from the end.

```
while k and st and st[-1] > d: st.pop(); k -= 1
```

**Complexity:** O(n) time, O(n) space.

---

## 11. Basic Calculator (with +, -, parentheses)
**Pattern:** Stack for sign + running result

**Approach:** On `(` push `(result, sign)` and reset; on `)` compute inner result, pop, merge. Track current `num` and `sign` between operators.

**Complexity:** O(n) time, O(n) space.

---

## 12. Basic Calculator II (+, -, *, /, no parens)
**Pattern:** Stack with delayed sign

**Approach:** Apply previous sign when hitting next operator; `*`/`/` pop-and-apply immediately, `+/-` push.

**Complexity:** O(n) time, O(n) space.

---

## 13. Decode String
**Pattern:** Stack of (string, count)

**Approach:** Digits → count; `[` → push `(cur, k)`, reset; `]` → `cur = prev + cur * k`.

**Complexity:** O(n) time, O(n) space.

---

## 14. Asteroid Collision
**Pattern:** Stack simulating collisions

**Approach:** Push right-moving (positive). For negative asteroid: while top is positive and smaller, pop; if equal, both explode; if top bigger, negative destroyed.

**Complexity:** O(n) time, O(n) space.

---

## 15. Simplify Path
**Pattern:** Stack of directory names

**Approach:** Split on `/`; `..` pops, `.`/empty ignored, else push. Join with `/`.

```python
parts = [p for p in path.split("/") if p not in ("", ".")]
st = []
for p in parts:
    if p == "..":
        if st: st.pop()
    else: st.append(p)
return "/" + "/".join(st)
```

**Complexity:** O(n) time, O(n) space.

---

## 16. Implement Queue using Stacks
**Pattern:** Two stacks — input & output

**Approach:** `push` → input stack. `pop/peek` → if output empty, dump input into output (reverses order); then output.top().

**Complexity:** Amortized O(1) per operation.

---

## 17. Implement Stack using Queues
**Pattern:** Rotate on push (or pop)

**Approach (push O(n)):** push to q1; rotate all previous elements behind it: `q1.push(q1.pop())` `size-1` times.

**Complexity:** O(n) push, O(1) pop.

---

## 18. Sliding Window Maximum
**Pattern:** Monotonic decreasing deque of indices

**Approach:** Pop back while `a[back] <= a[i]`; push `i`; pop front if outside window; front = max.

**Complexity:** O(n) time, O(k) space.

---

## 19. Circular Queue (design)
**Pattern:** Array + head/tail pointers with mod arithmetic

**Approach:** Track `head`, `tail`, `size`. Enqueue at `tail`, advance `tail = (tail+1) % cap`. One spare slot (or a size counter) to distinguish full vs empty.

**Complexity:** O(1) per operation.

---

## 20. Score of Parentheses
**Pattern:** Stack of scores / depth tracking

**Approach:** Stack-based: `(` pushes 0; `)` pops and pushes `max(2 * inner, 1)` merged with top.

```
score("()") = 1;  score("(A)") = 2 * score(A);  score("AB") = score(A) + score(B)
```

**Complexity:** O(n) time, O(n) space.

---

## 21. Longest Valid Parentheses
**Pattern:** Stack of indices (or two-pass counter)

**Approach:**
1. Stack holds `-1` sentinel. For `(` push index. For `)`: pop; if empty push current index (new base); else `ans = max(ans, i - stack.top())`.

**Complexity:** O(n) time, O(n) space.

---

## 22. Car Fleet (target position, speeds)
**Pattern:** Sort + monotonic stack of arrival times

**Approach:**
1. Sort cars by position descending; compute `time = (target - pos) / speed`.
2. If `time > stack.top()` → new fleet (push); else it merges into the top fleet.

**Complexity:** O(n log n) time, O(n) space.

---

## 23. Sum of Subarray Minimums
**Pattern:** Monotonic increasing stack + contribution counting

**Approach:** For each element as minimum, count subarrays where it's the min via previous-less and next-less boundaries:

```
count = (i - prev_less) * (next_less - i)
ans += a[i] * count
```

**Complexity:** O(n) time, O(n) space.
