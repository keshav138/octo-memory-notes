The easiest way to think about **`map` vs `reduce`** is:

- **`map` → transforms every element → returns a collection**
    
- **`reduce` → combines all elements → returns one final value**
    

Using your `nums`:

```swift
var nums = [1, 2, 3, 4, 5, 6, 7]
```

### `map`

Suppose you want to multiply every number by 2:

```swift
let result = nums.map {
    $0 * 2
}

print(result)
```

Result:

```text
[2, 4, 6, 8, 10, 12, 14]
```

`map` essentially does:

```text
1 → 2
2 → 4
3 → 6
4 → 8
...
```

It **keeps the number of elements the same**.

---

### `reduce`

Suppose you want the **sum** of all numbers:

```swift
let result = nums.reduce(0) {
    $0 + $1
}

print(result)
```

Result:

```text
28
```

Here `$0` and `$1` have a **different meaning** than with `map`.

For `reduce`:

```swift
$0 = accumulator
$1 = current element
```

So conceptually:

```text
initial = 0

0 + 1 = 1
1 + 2 = 3
3 + 3 = 6
6 + 4 = 10
10 + 5 = 15
15 + 6 = 21
21 + 7 = 28
```

So:

```swift
nums.reduce(0) {
    $0 + $1
}
```

means:

> Start with `0`, then keep combining the result with each element.

---

### This is the key difference

||`map`|`reduce`|
|---|---|---|
|Purpose|Transform elements|Combine elements|
|Closure parameters|`$0` = current element|`$0` = accumulator, `$1` = current element|
|Output|Collection|Usually one value|
|Number of elements|Same as input|Usually one|
|Example|`[1,2,3] → [2,4,6]`|`[1,2,3] → 6`|

### Your original `$0 * $1`

This is why your original code is interesting.

With `map`:

```swift
nums.map {
    $0 * $1    // ❌
}
```

There is no `$1`.

But with `reduce`:

```swift
nums.reduce(1) {
    $0 * $1
}
```

this is perfectly valid.

It calculates:

```text
1 × 1 × 2 × 3 × 4 × 5 × 6 × 7
```

giving:

```text
5040
```

So a useful exam rule is:

> **`map` works on each element individually; `reduce` carries a running result from one element to the next.**