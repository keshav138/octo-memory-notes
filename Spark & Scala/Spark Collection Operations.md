Yep. Since this is a **Scala + Spark introductory unit**, I'd focus on the operations you're most likely to be asked about in theory, MCQs, and basic coding questions.

One important distinction first:

> `map`, `filter`, `reduce`, etc. are **collection operations**. They can work across many Scala collections, not just `List`.

I'll organize this as a **Scala collection cheat sheet**.

---

# 1. Core Collection Operations

These are the most important ones to know because they apply to `List`, `Vector`, `LazyList`, and many other collections.

Suppose:

```scala
val nums = List(1, 2, 3, 4, 5)
```

---

## `map`

Transforms **every element**.

```scala
nums.map(x => x * 2)
```

Result:

```text
List(2, 4, 6, 8, 10)
```

Think:

```text
1 → 2
2 → 4
3 → 6
4 → 8
5 → 10
```

### Exam definition

> `map` applies a function to every element and returns a new collection.

---

# 2. `filter`

Keeps elements satisfying a condition.

```scala
nums.filter(x => x > 2)
```

Result:

```text
List(3, 4, 5)
```

Shorter syntax:

```scala
nums.filter(_ > 2)
```

Think:

```text
1 ✗
2 ✗
3 ✓
4 ✓
5 ✓
```

---

# 3. `filterNot`

Opposite of `filter`.

```scala
nums.filterNot(_ > 2)
```

Result:

```text
List(1, 2)
```

---

# 4. `foreach`

Performs an operation on each element.

```scala
nums.foreach(x => println(x))
```

Output:

```text
1
2
3
4
5
```

Unlike `map`, `foreach` is generally used for **side effects** and returns `Unit`.

### Remember

```text
map     → creates transformed collection
foreach → performs something with each element
```

---

# 5. `flatMap`

This one is **very important**.

`flatMap` = `map` + flatten.

Example:

```scala
val nums = List(1, 2, 3)

nums.flatMap(x => List(x, x * 10))
```

First `map` would conceptually produce:

```text
List(
    List(1, 10),
    List(2, 20),
    List(3, 30)
)
```

`flatMap` flattens it:

```text
List(1, 10, 2, 20, 3, 30)
```

---

# 6. `flatten`

Flattens nested collections.

```scala
val nested = List(
    List(1, 2),
    List(3, 4),
    List(5)
)

nested.flatten
```

Result:

```text
List(1, 2, 3, 4, 5)
```

---

# 7. `reduce`

Combines all elements into a single value.

```scala
nums.reduce((a, b) => a + b)
```

Conceptually:

```text
1 + 2 = 3
3 + 3 = 6
6 + 4 = 10
10 + 5 = 15
```

Result:

```text
15
```

Shorter:

```scala
nums.reduce(_ + _)
```

### Another example

```scala
nums.reduce(_ * _)
```

Result:

```text
120
```

---

# 8. `reduceLeft`

Reduces from the left.

```scala
nums.reduceLeft(_ - _)
```

Conceptually:

```text
(((1 - 2) - 3) - 4) - 5
```

Result:

```text
-13
```

---

# 9. `reduceRight`

Reduces from the right.

```scala
nums.reduceRight(_ - _)
```

Conceptually:

```text
1 - (2 - (3 - (4 - 5)))
```

Result:

```text
3
```

This is a common **MCQ trap**.

`reduceLeft` and `reduceRight` can give different results for non-associative operations like subtraction.

---

# 10. `fold`

`fold` is like reduce but starts with an **initial value**.

```scala
nums.fold(10)(_ + _)
```

Result:

```text
25
```

Because:

```text
10 + 1 + 2 + 3 + 4 + 5
```

---

# 11. `foldLeft`

Very common.

```scala
nums.foldLeft(0)(_ + _)
```

Result:

```text
15
```

Example:

```scala
nums.foldLeft(1)(_ * _)
```

Result:

```text
120
```

---

# 12. `foldRight`

Works from the right.

```scala
nums.foldRight(0)(_ + _)
```

Result:

```text
15
```

For addition, direction doesn't matter.

For subtraction:

```scala
nums.foldLeft(0)(_ - _)
```

and

```scala
nums.foldRight(0)(_ - _)
```

give different results.

---

# 13. `sum`

```scala
nums.sum
```

Result:

```text
15
```

---

# 14. `product`

```scala
nums.product
```

Result:

```text
120
```

---

# 15. `min`

```scala
nums.min
```

Result:

```text
1
```

---

# 16. `max`

```scala
nums.max
```

Result:

```text
5
```

---

# 17. `size`

```scala
nums.size
```

Result:

```text
5
```

---

# 18. `length`

```scala
nums.length
```

Result:

```text
5
```

For most basic collections, `size` and `length` give the number of elements.

---

# 19. `isEmpty`

```scala
nums.isEmpty
```

Result:

```text
false
```

---

# 20. `nonEmpty`

```scala
nums.nonEmpty
```

Result:

```text
true
```

---

# 21. `contains`

```scala
nums.contains(3)
```

Result:

```text
true
```

---

# 22. `exists`

Checks whether **at least one** element satisfies a condition.

```scala
nums.exists(_ > 4)
```

Result:

```text
true
```

Think:

> "Does **ANY** element satisfy this?"

---

# 23. `forall`

Checks whether **every** element satisfies a condition.

```scala
nums.forall(_ > 0)
```

Result:

```text
true
```

Think:

> "Do **ALL** elements satisfy this?"

### Easy MCQ distinction

```text
exists → ANY
forall → ALL
```

---

# 24. `count`

Counts elements satisfying a condition.

```scala
nums.count(_ % 2 == 0)
```

Result:

```text
2
```

Because:

```text
2, 4
```

---

# 25. `find`

Returns the **first element** satisfying a condition.

```scala
nums.find(_ > 3)
```

Result:

```text
Some(4)
```

If nothing matches:

```text
None
```

This is an `Option`.

---

# 26. `head`

Returns the first element.

```scala
nums.head
```

Result:

```text
1
```

**Warning:** Empty collection → exception.

---

# 27. `headOption`

Safer version of `head`.

```scala
nums.headOption
```

Result:

```text
Some(1)
```

Empty list:

```text
None
```

---

# 28. `tail`

Returns everything except the first element.

```scala
nums.tail
```

Result:

```text
List(2, 3, 4, 5)
```

---

# 29. `last`

Returns the last element.

```scala
nums.last
```

Result:

```text
5
```

---

# 30. `lastOption`

Safer version.

```scala
nums.lastOption
```

Result:

```text
Some(5)
```

---

# 31. `take`

Takes the first `n` elements.

```scala
nums.take(3)
```

Result:

```text
List(1, 2, 3)
```

---

# 32. `drop`

Removes the first `n` elements.

```scala
nums.drop(3)
```

Result:

```text
List(4, 5)
```

---

# 33. `takeWhile`

Takes elements **while** a condition remains true.

```scala
List(1, 2, 3, 6, 4).takeWhile(_ < 5)
```

Result:

```text
List(1, 2, 3)
```

It stops when it reaches `6`.

It does **not** continue looking for later values.

---

# 34. `dropWhile`

Opposite of `takeWhile`.

```scala
List(1, 2, 3, 6, 4).dropWhile(_ < 5)
```

Result:

```text
List(6, 4)
```

---

# 35. `slice`

Gets a portion of a collection.

```scala
nums.slice(1, 4)
```

Result:

```text
List(2, 3, 4)
```

Important:

```text
slice(from, until)
```

The ending index is **exclusive**.

---

# 36. `splitAt`

Splits a collection at a particular index.

```scala
nums.splitAt(3)
```

Result:

```text
(List(1, 2, 3), List(4, 5))
```

---

# 37. `takeRight`

```scala
nums.takeRight(2)
```

Result:

```text
List(4, 5)
```

---

# 38. `dropRight`

```scala
nums.dropRight(2)
```

Result:

```text
List(1, 2, 3)
```

---

# 39. `reverse`

```scala
nums.reverse
```

Result:

```text
List(5, 4, 3, 2, 1)
```

---

# 40. `reverseIterator`

Gives an iterator over elements in reverse order.

Useful when you don't need to construct another collection immediately.

---

# 41. `sorted`

Sorts the collection.

```scala
List(5, 2, 4, 1, 3).sorted
```

Result:

```text
List(1, 2, 3, 4, 5)
```

---

# 42. `sortWith`

Allows you to define your own sorting condition.

```scala
nums.sortWith(_ > _)
```

Result:

```text
List(5, 4, 3, 2, 1)
```

---

# 43. `sortBy`

Sort based on a property.

Example:

```scala
val people = List(
    ("Alice", 25),
    ("Bob", 20),
    ("Charlie", 30)
)

people.sortBy(_._2)
```

Result:

```text
Alice? 
```

More precisely:

```text
List(
    ("Bob", 20),
    ("Alice", 25),
    ("Charlie", 30)
)
```

---

# 44. `distinct`

Removes duplicates.

```scala
List(1, 2, 2, 3, 3, 3).distinct
```

Result:

```text
List(1, 2, 3)
```

---

# 45. `distinctBy`

Remove duplicates based on a property.

Useful in newer Scala versions.

---

# 46. `zip`

Combines two collections element by element.

```scala
val a = List(1, 2, 3)
val b = List("A", "B", "C")

a.zip(b)
```

Result:

```text
List(
    (1, "A"),
    (2, "B"),
    (3, "C")
)
```

---

# 47. `zipWithIndex`

Adds an index.

```scala
List("A", "B", "C").zipWithIndex
```

Result:

```text
List(
    ("A", 0),
    ("B", 1),
    ("C", 2)
)
```

---

# 48. `unzip`

Opposite of `zip`.

```scala
val pairs = List(
    (1, "A"),
    (2, "B"),
    (3, "C")
)

pairs.unzip
```

Produces:

```text
(List(1,2,3), List("A","B","C"))
```

---

# 49. `groupBy`

Groups elements according to a function.

```scala
val nums = List(1, 2, 3, 4, 5, 6)

nums.groupBy(_ % 2)
```

Result conceptually:

```text
0 → List(2,4,6)
1 → List(1,3,5)
```

Returns a `Map`.

This is **very important for Spark**, because grouping data is a common operation.

---

# 50. `partition`

Splits into two collections based on a condition.

```scala
nums.partition(_ % 2 == 0)
```

Result:

```text
(
    List(2,4,6),
    List(1,3,5)
)
```

First = elements satisfying condition.

Second = elements not satisfying condition.

---

# 51. `span`

Like `takeWhile` + `dropWhile`.

```scala
List(1,2,3,6,7).span(_ < 5)
```

Result:

```text
(
    List(1,2,3),
    List(6,7)
)
```

---

# 52. `mkString`

Converts a collection to a string.

```scala
List(1,2,3).mkString(", ")
```

Result:

```text
"1, 2, 3"
```

You can also:

```scala
nums.mkString("[", ", ", "]")
```

Result:

```text
"[1, 2, 3, 4, 5]"
```

---

# 53. `:+` and `+:`

These are very important because they look similar.

### Append

```scala
nums :+ 6
```

Result:

```text
List(1,2,3,4,5,6)
```

### Prepend

```scala
6 +: nums
```

Result:

```text
List(6,1,2,3,4,5)
```

Remember:

```text
:+ → add to RIGHT
+: → add to LEFT
```

---

# 54. `++`

Concatenates collections.

```scala
List(1,2) ++ List(3,4)
```

Result:

```text
List(1,2,3,4)
```

---

# 55. `concat`

Another way to concatenate collections.

---

# 56. `updated`

Creates a new collection with an updated element.

```scala
val nums = List(1,2,3)

nums.updated(1, 99)
```

Result:

```text
List(1,99,3)
```

The original remains unchanged because `List` is immutable.

---

# 57. LIST-SPECIFIC OPERATIONS

A `List` is an **immutable, ordered, linear collection**.

```scala
val nums = List(1,2,3)
```

### Construction

```scala
val nums = List(1,2,3)
```

Using `::`:

```scala
val nums = 1 :: 2 :: 3 :: Nil
```

Result:

```text
List(1,2,3)
```

### Important List methods

```text
head
tail
init
last
isEmpty
:: 
:::
:+
```

### `init`

Everything except the last element.

```scala
List(1,2,3,4).init
```

Result:

```text
List(1,2,3)
```

---

# 58. VECTOR

A `Vector` is an **immutable indexed sequence**.

```scala
val nums = Vector(1,2,3,4,5)
```

It supports most of the same operations:

```scala
nums.map(_ * 2)

nums.filter(_ > 2)

nums.take(3)

nums.drop(2)

nums.reverse

nums.sorted

nums.sum
```

### Why use Vector instead of List?

The key difference is access.

```text
List:
head → very fast
index access → relatively slower

Vector:
index access → efficient
```

Example:

```scala
nums(3)
```

returns:

```text
4
```

### Exam distinction

||List|Vector|
|---|---|---|
|Immutable|Yes|Yes|
|Ordered|Yes|Yes|
|Indexed access|Slower|Efficient|
|Structure|Linked/linear|Tree-based indexed sequence|
|Best for|Sequential operations|Random/indexed access|

---

# 59. STRING OPERATIONS

A `String` is not technically a Scala collection in exactly the same sense as `List`, but it has many sequence-like operations.

```scala
val s = "Hello"
```

---

## `length`

```scala
s.length
```

```text
5
```

---

## `charAt`

```scala
s.charAt(1)
```

Result:

```text
'e'
```

---

## Index access

```scala
s(1)
```

Result:

```text
'e'
```

---

## `toUpperCase`

```scala
s.toUpperCase
```

Result:

```text
HELLO
```

---

## `toLowerCase`

```scala
s.toLowerCase
```

Result:

```text
hello
```

---

## `contains`

```scala
s.contains("ell")
```

Result:

```text
true
```

---

## `startsWith`

```scala
s.startsWith("He")
```

---

## `endsWith`

```scala
s.endsWith("lo")
```

---

## `substring`

```scala
s.substring(1,4)
```

Result:

```text
ell
```

Again, ending index is exclusive.

---

## `split`

```scala
val s = "apple,banana,orange"

s.split(",")
```

Result conceptually:

```text
Array("apple", "banana", "orange")
```

---

## `trim`

```scala
"  hello  ".trim
```

Result:

```text
"hello"
```

---

## `replace`

```scala
"hello".replace("l", "x")
```

Result:

```text
"hexxo"
```

---

## `reverse`

```scala
"hello".reverse
```

Result:

```text
"olleh"
```

---

## `map` on String

Because String can be treated as a sequence of characters:

```scala
"abc".map(c => c.toUpper)
```

Result:

```text
"ABC"
```

---

## `filter` on String

```scala
"hello123".filter(_.isDigit)
```

Result:

```text
"123"
```

This is a nice example of how **collection operations can apply to strings**.

---

# 60. MAP — Key-Value Collections

Now we get to `Map`.

```scala
val ages = Map(
    "Alice" -> 20,
    "Bob" -> 25,
    "Charlie" -> 30
)
```

---

## Access

```scala
ages("Alice")
```

Result:

```text
20
```

---

## `get`

```scala
ages.get("Alice")
```

Result:

```text
Some(20)
```

If missing:

```scala
ages.get("David")
```

Result:

```text
None
```

---

## `contains`

```scala
ages.contains("Alice")
```

---

## `keys`

```scala
ages.keys
```

Gives the keys.

---

## `values`

```scala
ages.values
```

Gives the values.

---

## `map` on Map

This is slightly different because each element is a key-value pair.

```scala
ages.map {
    case (name, age) => (name, age + 1)
}
```

Result:

```text
Alice → 21
Bob → 26
Charlie → 31
```

---

## `filter`

```scala
ages.filter {
    case (name, age) => age >= 25
}
```

Result:

```text
Bob → 25
Charlie → 30
```

---

## `filterKeys`

You may encounter this in older Scala material:

```scala
ages.filterKeys(_ != "Alice")
```

But in modern Scala, prefer:

```scala
ages.filter { case (k, v) => k != "Alice" }
```

---

## Add element

For immutable Map:

```scala
val newAges = ages + ("David" -> 22)
```

---

## Remove element

```scala
val newAges = ages - "Alice"
```

Original `ages` remains unchanged.

---

## Merge Maps

```scala
val a = Map("A" -> 1)
val b = Map("B" -> 2)

a ++ b
```

Result:

```text
Map("A" -> 1, "B" -> 2)
```

If keys overlap, the later map's value wins in the usual immutable-map merge:

```scala
Map("A" -> 1) ++ Map("A" -> 99)
```

→

```text
Map("A" -> 99)
```

---

# 61. LAZYLIST OPERATIONS

`LazyList` supports many of the same operations:

```scala
val nums = LazyList.from(1)
```

The important ones are:

```text
map
filter
take
drop
takeWhile
dropWhile
flatMap
foreach
find
exists
forall
```

But the important distinction is **evaluation**.

Example:

```scala
val nums = LazyList.from(1)

val squares = nums.map(x => x * x)
```

At this point, you can think of the computation as being **lazy**.

Then:

```scala
squares.take(5).toList
```

forces the required values:

```text
1, 4, 9, 16, 25
```

---

# 62. LazyList + Filter

This is a particularly good example.

```scala
val nums = LazyList.from(1)

val result = nums
    .filter(_ % 2 == 0)
    .take(5)
    .toList
```

Result:

```text
List(2, 4, 6, 8, 10)
```

It doesn't need to generate an infinite list of integers first.

It evaluates enough values to find the first five even numbers.

---

# 63. LazyList + Map

```scala
val squares =
    LazyList.from(1)
        .map(x => x * x)

squares.take(5).toList
```

Result:

```text
List(1,4,9,16,25)
```

---

# 64. LazyList + `takeWhile`

```scala
LazyList.from(1)
    .map(x => x * x)
    .takeWhile(_ < 50)
    .toList
```

Result:

```text
List(1,4,9,16,25,36,49)
```

This is a classic example of **lazy evaluation + infinite sequence**.

---

# 65. OTHER COLLECTIONS YOU SHOULD KNOW

Your syllabus may also consider these.

## Set

A `Set` contains **unique elements**.

```scala
val nums = Set(1,2,2,3,3)
```

Result:

```text
Set(1,2,3)
```

Important operations:

```scala
nums.contains(2)

nums + 4

nums - 2

nums.union(other)

nums.intersect(other)

nums.diff(other)

nums.filter(_ > 1)

nums.map(_ * 2)
```

### Set operations

Suppose:

```text
A = {1,2,3}
B = {3,4,5}
```

Union:

```text
A ∪ B = {1,2,3,4,5}
```

Intersection:

```text
A ∩ B = {3}
```

Difference:

```text
A - B = {1,2}
```

---

# 66. Range

`Range` generates sequences of numbers.

```scala
1 to 5
```

means:

```text
1, 2, 3, 4, 5
```

Whereas:

```scala
1 until 5
```

means:

```text
1, 2, 3, 4
```

### Very important:

```text
to    → includes end
until → excludes end
```

---

## Range with step

```scala
1 to 10 by 2
```

Result:

```text
1,3,5,7,9
```

Descending:

```scala
10 to 1 by -1
```

---

# 67. Array

You may encounter `Array` as well.

```scala
val nums = Array(1,2,3,4)
```

Access:

```scala
nums(0)
```

→

```text
1
```

Unlike immutable `List`/`Vector`, arrays are **mutable**:

```scala
nums(0) = 99
```

Now:

```text
99,2,3,4
```

Arrays also support many collection operations:

```scala
nums.map(_ * 2)

nums.filter(_ > 2)

nums.sum

nums.max

nums.min

nums.reverse
```

---

# 68. Iterator

An `Iterator` lets you traverse elements without necessarily holding another collection containing all transformed results.

```scala
val it = Iterator(1,2,3,4,5)
```

Operations include:

```text
map
filter
take
drop
foreach
foldLeft
```

Important difference:

> **An Iterator is consumed as you traverse it.**

For example:

```scala
val it = Iterator(1,2,3)

it.next()
```

returns:

```text
1
```

Next:

```scala
it.next()
```

returns:

```text
2
```

---

# 69. Option

Not technically a collection you need to treat like List/Vector, but **definitely know it** because it appears with `Map.get`, `find`, etc.

It represents:

```text
Some(value)
```

or:

```text
None
```

Example:

```scala
val x = Map("A" -> 10)

x.get("A")
```

→

```text
Some(10)
```

Missing:

```scala
x.get("B")
```

→

```text
None
```

You can use:

```scala
x.get("A").map(_ * 2)
```

→

```text
Some(20)
```

---

# 70. The BIG `map` vs `filter` vs `flatMap` distinction

This is probably the most important thing to get comfortable with.

Given:

```scala
val nums = List(1,2,3,4)
```

### `map`

**One input → one output**

```scala
nums.map(x => x * 2)
```

```text
1 → 2
2 → 4
3 → 6
4 → 8
```

Result:

```text
List(2,4,6,8)
```

---

### `filter`

**One input → either kept or removed**

```scala
nums.filter(_ % 2 == 0)
```

```text
1 → remove
2 → keep
3 → remove
4 → keep
```

Result:

```text
List(2,4)
```

---

### `flatMap`

**One input → potentially multiple outputs**

```scala
nums.flatMap(x => List(x, x))
```

Result:

```text
List(1,1,2,2,3,3,4,4)
```

---

# 71. Operations you should memorize for exams

If your professor gives you a question like:

> "Which Scala collection operation should be used?"

Use this mental table:

|Requirement|Operation|
|---|---|
|Transform every element|`map`|
|Remove elements based on condition|`filter`|
|Opposite of filter|`filterNot`|
|One input → multiple outputs|`flatMap`|
|Flatten nested collection|`flatten`|
|Perform side effect on every element|`foreach`|
|Combine all into one value|`reduce`|
|Combine with starting value|`fold`|
|Check at least one|`exists`|
|Check all|`forall`|
|Count matching elements|`count`|
|Find first matching element|`find`|
|First element|`head`|
|Everything except first|`tail`|
|First N|`take`|
|Remove first N|`drop`|
|Take while condition true|`takeWhile`|
|Drop while condition true|`dropWhile`|
|Sort|`sorted`|
|Custom sort|`sortWith`|
|Remove duplicates|`distinct`|
|Group into categories|`groupBy`|
|Split based on condition|`partition`|
|Combine two collections pairwise|`zip`|
|Add index|`zipWithIndex`|
|Reverse|`reverse`|
|Join into String|`mkString`|
|Concatenate|`++`|
|Add to end|`:+`|
|Add to beginning|`+:`|

---

# 72. One Final Mental Map

For your **two units**, I'd memorize the hierarchy like this:

```text
                    Scala Collections
                          |
       +------------------+------------------+
       |                  |                  |
   Sequences             Sets               Maps
       |                                    Key → Value
   +---+---+---+
   |   |   |   |
 List Vector LazyList Array
       |
       +-----------------------------+
                                     |
                         Common Operations
                                     |
          +----------+----------+----+----+----------+
          |          |          |         |          |
         map       filter     flatMap   reduce     fold
          |          |          |         |          |
      transform   select    expand     combine    combine
```

And then remember the **five highest-priority operations**:

```text
map
 ↓
transform everything

filter
 ↓
keep what satisfies condition

flatMap
 ↓
transform + flatten

reduce
 ↓
many values → one value

fold
 ↓
initial value + many values → one value
```

For a **Spark exam**, I'd put `map`, `filter`, `flatMap`, `reduce`, `fold`, `groupBy`, `foreach`, `take`, `drop`, and **immutable vs mutable collections** at the very top of your revision list. These concepts transfer directly into Spark's collection/data-processing model.