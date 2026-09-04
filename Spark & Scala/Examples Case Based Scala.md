# Q1 — Student Marks Analyzer

```scala
val marks = List(78, 45, 92, 67, 88, 34, 95, 56)
```

### a) Students who scored 60 or above

```scala
val passed60 = marks.filter(mark => mark >= 60)

println(passed60)
```

Output:

```text
List(78, 92, 67, 88, 95)
```

### b) Square every mark

```scala
val squared = marks.map(mark => mark * mark)

println(squared)
```

Output:

```text
List(6084, 2025, 8464, 4489, 7744, 1156, 9025, 3136)
```

### c) Find total marks

```scala
val total = marks.reduce((a, b) => a + b)

println(total)
```

Output:

```text
555
```

Can also be written:

```scala
val total = marks.reduce(_ + _)
```

### d) Find highest mark

```scala
val highest = marks.reduce((a, b) => if (a > b) a else b)

println(highest)
```

Output:

```text
95
```

Or simply:

```scala
val highest = marks.max
```

### e) Create and use `isPassed`

```scala
def isPassed(mark: Int): Boolean = {
  mark >= 40
}

val result = marks.filter(isPassed)

println(result)
```

Output:

```text
List(78, 45, 92, 67, 88, 95, 56)
```

---

# Q2 — Online Shopping Cart

```scala
val prices = List(250, 1200, 450, 800, 1500, 300)
```

### a) Items costing more than ₹500

```scala
val expensive = prices.filter(price => price > 500)

println(expensive)
```

Output:

```text
List(1200, 800, 1500)
```

### b) Apply 10% discount to every item

```scala
val discounted = prices.map(price => price * 0.9)

println(discounted)
```

Output:

```text
List(225.0, 1080.0, 405.0, 720.0, 1350.0, 270.0)
```

### c) Calculate total price

```scala
val total = prices.reduce(_ + _)

println(total)
```

Output:

```text
4500
```

### d) Create `applyDiscount`

```scala
def applyDiscount(price: Double): Double = {
  price * 0.9
}
```

Use it:

```scala
val discounted = prices.map(price => applyDiscount(price))

println(discounted)
```

### e) Total cost of items above ₹500

```scala
val total = prices
  .filter(price => price > 500)
  .reduce(_ + _)

println(total)
```

Output:

```text
3500
```

The important thing here is that collection operations can be **chained**:

```scala
prices.filter(...).map(...).reduce(...)
```

---

# Q3 — Employee Salary Processing

```scala
val employees = Map(
  "Amit" -> 35000,
  "Priya" -> 48000,
  "Rahul" -> 28000,
  "Neha" -> 55000,
  "Karan" -> 42000
)
```

### a) Find Priya's salary

```scala
val salary = employees("Priya")

println(salary)
```

Output:

```text
48000
```

A safer approach is:

```scala
val salary = employees.get("Priya")

println(salary)
```

which gives:

```text
Some(48000)
```

### b) Employees earning more than ₹40,000

```scala
val highEarners = employees.filter {
  case (name, salary) => salary > 40000
}

println(highEarners)
```

Output:

```text
Map(Priya -> 48000, Neha -> 55000, Karan -> 42000)
```

### c) Get only their salaries

```scala
val salaries = employees
  .filter { case (_, salary) => salary > 40000 }
  .values

println(salaries)
```

Conceptually:

```text
48000, 55000, 42000
```

### d) Total salary of employees earning more than ₹40,000

```scala
val total = employees
  .filter { case (_, salary) => salary > 40000 }
  .values
  .reduce(_ + _)

println(total)
```

Output:

```text
145000
```

### e) Create and use `eligibleForBonus`

```scala
def eligibleForBonus(salary: Int): Boolean = {
  salary > 40000
}

val eligible = employees.filter {
  case (_, salary) => eligibleForBonus(salary)
}

println(eligible)
```

Output:

```text
Map(Priya -> 48000, Neha -> 55000, Karan -> 42000)
```

---

# Q4 — Food Delivery Orders

```scala
val orders = List(150, 450, 800, 250, 1200, 600, 100)
```

### a) Orders above ₹500

```scala
val largeOrders = orders.filter(amount => amount > 500)

println(largeOrders)
```

Output:

```text
List(800, 1200, 600)
```

### b) Add ₹50 delivery charge

```scala
val withDelivery = orders.map(amount => amount + 50)

println(withDelivery)
```

Output:

```text
List(200, 500, 850, 300, 1250, 650, 150)
```

### c) Total order value

```scala
val total = orders.reduce(_ + _)

println(total)
```

Output:

```text
3550
```

### d) Average order value

A simple implementation:

```scala
val average = orders.sum.toDouble / orders.size

println(average)
```

Output:

```text
507.14285714285717
```

You could also use:

```scala
val average = orders.reduce(_ + _).toDouble / orders.size
```

### e) Create the `category` function

```scala
def category(amount: Int): String = {
  if (amount < 300)
    "Small"
  else if (amount < 700)
    "Medium"
  else
    "Large"
}
```

Apply it:

```scala
val categories = orders.map(category)

println(categories)
```

Output:

```text
List(Small, Medium, Large, Small, Large, Medium, Small)
```

This is a nice question because `map` is being given a **function** directly:

```scala
orders.map(category)
```

rather than:

```scala
orders.map(amount => category(amount))
```

Both work.

---

# Q5 — Lazy Number Generator

### a) Infinite natural number sequence

```scala
val numbers = LazyList.from(1)
```

This doesn't try to create an infinite `List`. The values are generated lazily as they're requested.

### b) First 10 numbers

```scala
val first10 = numbers.take(10)

println(first10.toList)
```

Output:

```text
List(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
```

### c) First 10 even numbers

```scala
val evenNumbers = numbers
  .filter(x => x % 2 == 0)
  .take(10)

println(evenNumbers.toList)
```

Output:

```text
List(2, 4, 6, 8, 10, 12, 14, 16, 18, 20)
```

### d) First 10 numbers divisible by 3

```scala
val divisibleBy3 = numbers
  .filter(x => x % 3 == 0)
  .take(10)

println(divisibleBy3.toList)
```

Output:

```text
List(3, 6, 9, 12, 15, 18, 21, 24, 27, 30)
```

### e) Square the first 10 even numbers

```scala
val squaredEven = numbers
  .filter(x => x % 2 == 0)
  .take(10)
  .map(x => x * x)

println(squaredEven.toList)
```

Output:

```text
List(4, 16, 36, 64, 100, 144, 196, 256, 324, 400)
```

---

## The patterns I'd memorize for the test

Most of these questions boil down to these patterns:

### `map` → change every element

```scala
list.map(x => x * 2)
```

### `filter` → keep elements satisfying a condition

```scala
list.filter(x => x > 10)
```

### `reduce` → combine all elements into one value

```scala
list.reduce(_ + _)
```

### Chain them

```scala
list
  .filter(x => x % 2 == 0)
  .map(x => x * x)
  .reduce(_ + _)
```

### Function as an argument

```scala
def isEven(x: Int): Boolean = x % 2 == 0

list.filter(isEven)
```

### Map key/value processing

```scala
map.filter {
  case (key, value) => value > 40
}
```

### Lazy sequence

```scala
val nums = LazyList.from(1)

nums
  .filter(_ % 2 == 0)
  .map(_ * 2)
  .take(10)
  .toList
```

If you're studying specifically for an implementation test, **being comfortable chaining `filter → map → reduce`, passing functions into collection methods, and knowing the difference between `List`, mutable collections, and `LazyList` will cover a lot of what can be asked from these units.**