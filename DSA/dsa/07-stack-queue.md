# Stack & Queue

Stacks handle **matching/reversal/recent-undo** problems. Queues handle **ordering/FIFO**.
The most important advanced pattern here is the **monotonic stack** — next greater/smaller in O(n).

---

## 1. Valid Parentheses
**Given:** a string of brackets () [] {}
**Expects:** return true if they are properly matched and nested
**Pattern:** Matching stack

**Approach:** Push opens; on close check match with top; empty at end ⇒ valid.

**Complexity:** O(n) time, O(n) space.

---

## 2. Min Stack
**Given:** nothing
**Expects:** implement a stack with push, pop, top and getMin, all O(1)
**Pattern:** Pair stack or two-stack (values + running min)

**Approach:** Push `(x, min(x, top_min))`. Or keep second stack that pushes when `x <= min` and pops together on equal.

**Complexity:** O(1) per operation.

---

## 3. Evaluate Reverse Polish Notation
**Given:** tokens in postfix (RPN) notation
**Expects:** return the evaluated value
**Pattern:** Operand stack

**Approach:** Number → push; operator → pop two, apply, push. Note order: `b = pop(), a = pop(); push(a op b)`.

**Complexity:** O(n) time, O(n) space.

---

## 4. Daily Temperatures (days until warmer)
**Given:** an array of daily temperatures
**Expects:** return for each day how many days until a warmer temperature
**Pattern:** Monotonic **decreasing** stack of indices

**Approach:**
1. While stack non-empty and `t[top] < t[i]`: `ans[top] = i - top`, pop.
2. Push `i`.

**Why decreasing:** warmer day pops everything cooler — each element pushed/popped once.

**Complexity:** O(n) time, O(n) space.

---

## 5. Next Greater Element I
**Given:** two arrays nums1 and nums2
**Expects:** return the next greater element in nums2 for each element of nums1
**Pattern:** Monotonic decreasing stack + map

**Approach:** Scan nums2, maintain decreasing stack; when `x > top`, `map[top] = x` and pop. Query nums1 against the map.

**Complexity:** O(n + m) time, O(n) space.

---

## 6. Next Greater Element II (circular)
**Given:** a circular array
**Expects:** return the next greater element for each position, wrapping around
**Pattern:** Same, scan twice (2n iterations, index mod n)

**Approach:** Loop `i` in `[0, 2n)`, use `i % n`; standard monotonic stack.

**Complexity:** O(n) time, O(n) space.

---

## 7. Largest Rectangle in Histogram
**Given:** an array of bar heights
**Expects:** return the area of the largest rectangle in the histogram
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
**Given:** a binary matrix
**Expects:** return the area of the largest rectangle of 1s
**Pattern:** Histogram per row

**Approach:**
1. Row `r`: `heights[j] = heights[j] + 1 if matrix[r][j] == '1' else 0`.
2. Run Largest Rectangle in Histogram on each row's heights.

**Complexity:** O(m·n) time, O(n) space.

---

## 9. Trapping Rain Water
**Given:** an array of bar heights
**Expects:** return the total units of water trapped between bars
**Pattern:** Monotonic decreasing stack (basin method)

**Approach:** When `h[i] > h[top]`: pop `top`; water above popped bar = `(min(h[i], h[new_top]) - h[popped]) * (i - new_top - 1)`.

**Complexity:** O(n) time, O(n) space.

---

## 10. Remove K Digits (smallest number after removing k digits)
**Given:** a number string and a removal count k
**Expects:** return the smallest possible number after removing k digits
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
**Given:** an expression with +, - and parentheses
**Expects:** return the evaluated result
**Pattern:** Stack for sign + running result

**Approach:** On `(` push `(result, sign)` and reset; on `)` compute inner result, pop, merge. Track current `num` and `sign` between operators.

**Complexity:** O(n) time, O(n) space.

---

## 12. Basic Calculator II (+, -, *, /, no parens)
**Given:** an expression with +, -, *, / and no parentheses
**Expects:** return the evaluated result honoring precedence
**Pattern:** Stack with delayed sign

**Approach:** Apply previous sign when hitting next operator; `*`/`/` pop-and-apply immediately, `+/-` push.

**Complexity:** O(n) time, O(n) space.

---

## 13. Decode String
**Given:** an encoded string like "3[a2[c]]"
**Expects:** return the fully decoded string
**Pattern:** Stack of (string, count)

**Approach:** Digits → count; `[` → push `(cur, k)`, reset; `]` → `cur = prev + cur * k`.

**Complexity:** O(n) time, O(n) space.

---

## 14. Asteroid Collision
**Given:** an array of asteroid sizes (sign = direction)
**Expects:** return the state of asteroids after all collisions resolve
**Pattern:** Stack simulating collisions

**Approach:** Push right-moving (positive). For negative asteroid: while top is positive and smaller, pop; if equal, both explode; if top bigger, negative destroyed.

**Complexity:** O(n) time, O(n) space.

---

## 15. Simplify Path
**Given:** a unix path with '.', '..' and duplicate slashes
**Expects:** return the canonical simplified path
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
**Given:** nothing
**Expects:** implement a FIFO queue using only stacks
**Pattern:** Two stacks — input & output

**Approach:** `push` → input stack. `pop/peek` → if output empty, dump input into output (reverses order); then output.top().

**Complexity:** Amortized O(1) per operation.

---

## 17. Implement Stack using Queues
**Given:** nothing
**Expects:** implement a LIFO stack using only queues
**Pattern:** Rotate on push (or pop)

**Approach (push O(n)):** push to q1; rotate all previous elements behind it: `q1.push(q1.pop())` `size-1` times.

**Complexity:** O(n) push, O(1) pop.

---

## 18. Sliding Window Maximum
**Given:** an array and a window size k
**Expects:** return the maximum of every k-sized window
**Pattern:** Monotonic decreasing deque of indices

**Approach:** Pop back while `a[back] <= a[i]`; push `i`; pop front if outside window; front = max.

**Complexity:** O(n) time, O(k) space.

---

## 19. Circular Queue (design)
**Given:** a capacity k
**Expects:** implement a circular queue with O(1) operations
**Pattern:** Array + head/tail pointers with mod arithmetic

**Approach:** Track `head`, `tail`, `size`. Enqueue at `tail`, advance `tail = (tail+1) % cap`. One spare slot (or a size counter) to distinguish full vs empty.

**Complexity:** O(1) per operation.

---

## 20. Score of Parentheses
**Given:** a balanced parentheses string
**Expects:** return its score per the nesting rules
**Pattern:** Stack of scores / depth tracking

**Approach:** Stack-based: `(` pushes 0; `)` pops and pushes `max(2 * inner, 1)` merged with top.

```
score("()") = 1;  score("(A)") = 2 * score(A);  score("AB") = score(A) + score(B)
```

**Complexity:** O(n) time, O(n) space.

---

## 21. Longest Valid Parentheses
**Given:** a string of parentheses
**Expects:** return the length of the longest valid (well-formed) substring
**Pattern:** Stack of indices (or two-pass counter)

**Approach:**
1. Stack holds `-1` sentinel. For `(` push index. For `)`: pop; if empty push current index (new base); else `ans = max(ans, i - stack.top())`.

**Complexity:** O(n) time, O(n) space.

---

## 22. Car Fleet (target position, speeds)
**Given:** car positions and speeds, and a target position
**Expects:** return the number of car fleets that arrive
**Pattern:** Sort + monotonic stack of arrival times

**Approach:**
1. Sort cars by position descending; compute `time = (target - pos) / speed`.
2. If `time > stack.top()` → new fleet (push); else it merges into the top fleet.

**Complexity:** O(n log n) time, O(n) space.

---

## 23. Sum of Subarray Minimums
**Given:** an array
**Expects:** return the sum of the minimum of every subarray
**Pattern:** Monotonic increasing stack + contribution counting

**Approach:** For each element as minimum, count subarrays where it's the min via previous-less and next-less boundaries:

```
count = (i - prev_less) * (next_less - i)
ans += a[i] * count
```

**Complexity:** O(n) time, O(n) space.
