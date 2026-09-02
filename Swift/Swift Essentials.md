# iPhone & iOS with Swift — Implementation-Focused Notes

For a **test/exam**, focus less on theory and more on being able to **write, complete, debug, and predict Swift code**.

---

# 1. Introduction to iPhone & iOS Platform with Swift

### iOS

- **iOS** is Apple's mobile operating system for iPhone.
    
- Apps are primarily developed using **Swift** and Apple's frameworks.
    
- Development is generally done using **Xcode**.
    
- Swift is:
    
    - Statically typed
        
    - Object-oriented
        
    - Protocol-oriented
        
    - Type-safe
        
    - Supports functional programming concepts such as closures and higher-order functions.
        

### Basic Swift program

```swift
import Foundation

print("Hello, iOS!")
```

A typical iOS application uses frameworks such as:

```swift
import UIKit
```

or

```swift
import SwiftUI
```

For implementation questions, know the basic idea:

```text
Swift → Programming language
Xcode → IDE
iOS → Operating system
UIKit / SwiftUI → UI frameworks
```

---

# 2. Object-Oriented Programming

Swift supports the major OOP concepts:

### Main concepts

1. **Class**
    
2. **Object**
    
3. **Encapsulation**
    
4. **Inheritance**
    
5. **Polymorphism**
    
6. **Abstraction**
    

---

## Class and Object

A **class** is a blueprint.

An **object** is an instance of a class.

```swift
class Student {
    var name = ""
    var age = 0
}

let s1 = Student()
s1.name = "Keshav"
s1.age = 20
```

Here:

```text
Student → class
s1      → object
name    → property
age     → property
```

---

# 3. Declaring & Defining Classes

### Basic syntax

```swift
class ClassName {
    // properties
    // methods
}
```

Example:

```swift
class Car {
    var brand = ""
    var speed = 0

    func drive() {
        print("Car is driving")
    }
}
```

Creating an object:

```swift
let car1 = Car()

car1.brand = "Toyota"
car1.speed = 100

car1.drive()
```

Output:

```text
Car is driving
```

---

## Initializers

An initializer is used to initialize an object.

```swift
class Student {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
```

Creating object:

```swift
let s = Student(name: "Keshav", age: 20)

print(s.name)
print(s.age)
```

### `self`

`self` refers to the **current object**.

```swift
self.name = name
```

Left:

```text
property of object
```

Right:

```text
parameter
```

---

# 4. Variables

Swift variables are declared using:

```swift
var
```

Constants use:

```swift
let
```

### Variable

```swift
var age = 20
age = 21
```

### Constant

```swift
let age = 20
// age = 21   // ERROR
```

---

## Explicit Type

```swift
var age: Int = 20
var name: String = "Keshav"
var price: Double = 99.5
var passed: Bool = true
```

Swift can infer the type:

```swift
var age = 20
```

Swift knows:

```text
age → Int
```

---

## Common Swift types

```swift
Int
Double
Float
String
Character
Bool
```

Example:

```swift
var x: Int = 10
var y: Double = 10.5
var name: String = "John"
var grade: Character = "A"
var valid: Bool = true
```

---

# 5. Arrays

An array stores **multiple values of the same type**.

### Declaration

```swift
var numbers = [10, 20, 30, 40]
```

or:

```swift
var numbers: [Int] = [10, 20, 30]
```

---

## Accessing elements

Array indexing starts from **0**.

```swift
let numbers = [10, 20, 30, 40]

print(numbers[0])
print(numbers[2])
```

Output:

```text
10
30
```

---

## Add elements

```swift
var numbers = [10, 20, 30]

numbers.append(40)
```

Result:

```text
[10, 20, 30, 40]
```

Add multiple:

```swift
numbers.append(contentsOf: [50, 60])
```

---

## Insert

```swift
numbers.insert(15, at: 1)
```

---

## Remove

```swift
numbers.remove(at: 1)
```

Remove last:

```swift
numbers.removeLast()
```

Remove all:

```swift
numbers.removeAll()
```

---

## Count

```swift
print(numbers.count)
```

---

## Check empty

```swift
if numbers.isEmpty {
    print("Empty")
}
```

---

## Loop through array

```swift
for number in numbers {
    print(number)
}
```

With index:

```swift
for (index, value) in numbers.enumerated() {
    print(index, value)
}
```

---

## Common array operations — exam important

```swift
numbers.append(5)
numbers.insert(5, at: 0)
numbers.remove(at: 2)
numbers.removeLast()
numbers.count
numbers.isEmpty
numbers.contains(10)
numbers.sorted()
numbers.reversed()
```

### Example

```swift
var nums = [5, 2, 8, 1]

print(nums.sorted())
```

Output:

```text
[1, 2, 5, 8]
```

---

# 6. Methods

A method is a function defined inside a class/struct.

```swift
class Calculator {

    func add(a: Int, b: Int) -> Int {
        return a + b
    }
}
```

Usage:

```swift
let calc = Calculator()

let result = calc.add(a: 10, b: 20)

print(result)
```

Output:

```text
30
```

---

## Method without return

```swift
func greet() {
    print("Hello")
}
```

---

## Method with parameters

```swift
func greet(name: String) {
    print("Hello \(name)")
}
```

Call:

```swift
greet(name: "Keshav")
```

---

## Method returning a value

```swift
func square(_ x: Int) -> Int {
    return x * x
}

The underscore (_) omits the argument label when calling the function, allowing you to pass the argument directly without naming it.
In Swift, function parameters have both an argument label (used when calling the function) and a parameter name (used inside the function body). By default, the parameter name serves as both.
Without the underscore:
func square(x: Int) -> Int {
    return x * x
}

let result = square(x: 5) // You must write "x:"

With the underscore:
func square(_ x: Int) -> Int {
    return x * x
}

let result = square(5) // No label needed

Swift convention uses _ when the function's purpose or mathematical nature makes an argument label redundant, keeping calls like square(5) or abs(-3) clean and natural to read.


```

Call:

```swift
print(square(5))
```

Output:

```text
25
```

---

# 7. Methods & Messages

In OOP, **message passing** means an object is asked to perform some operation by calling one of its methods.

```swift
class Dog {
    func bark() {
        print("Woof")
    }
}

let dog = Dog()

dog.bark()
```

Conceptually:

```text
dog → bark()
```

The object `dog` receives the request/message to execute `bark()`.

For exams, if asked about **method invocation/message passing**, think:

```swift
object.method()
```

---

# 8. Closures

This is **very important for implementation questions**.

A closure is essentially a **self-contained block of functionality that can be stored and passed around**.

Basic closure:

```swift
let greet = {
    print("Hello")
}

greet()
```

---

## Closure with parameters

```swift
let add = { (a: Int, b: Int) -> Int in
    return a + b
}

print(add(10, 20))
```

Output:

```text
30
```

Syntax:

```swift
{ (parameters) -> ReturnType in
    statements
}
```

---

## Closure as a variable

```swift
let square: (Int) -> Int = { x in
    return x * x
}

print(square(5))
```

---

## Short syntax

Swift can infer the types:

```swift
let square = { (x: Int) in
    x * x
}
```

Even shorter in some contexts:

```swift
let nums = [1, 2, 3, 4]

let result = nums.map { $0 * $0 }

print(result)
```

`$0` means:

> first parameter passed to the closure.

For two parameters:

```swift
let result = nums.reduce(0) { $0 + $1 }
```

---

# 9. Closures with Arrays

This is highly testable.

### `map`

Transforms every element.

```swift
let numbers = [1, 2, 3, 4]

let squares = numbers.map {
    $0 * $0
}

print(squares)
```

Result:

```text
[1, 4, 9, 16]
```

---

### `filter`

Keeps elements satisfying a condition.

```swift
let numbers = [1, 2, 3, 4, 5, 6]

let even = numbers.filter {
    $0 % 2 == 0
}

print(even)
```

Result:

```text
[2, 4, 6]
```

---

### `reduce`

Combines all elements into one value.

```swift
let numbers = [1, 2, 3, 4]

let sum = numbers.reduce(0) {
    $0 + $1
}

print(sum)
```

Result:

```text
10
```

Remember:

```text
map    → transform
filter → select
reduce → combine
```

---

# 10. Dictionary

A dictionary stores data as:

```text
key : value
```

Example:

```swift
var student = [
    "name": "Keshav",
    "city": "Ludhiana"
]
```

Access:

```swift
print(student["name"])
```

The result is an **optional** value:

```swift
Optional("Keshav")
```

---

## Explicit dictionary type

```swift
var marks: [String: Int] = [
    "Math": 90,
    "Science": 85,
    "English": 88
]
```

Access:

```swift
print(marks["Math"])
```

---

## Add/update

```swift
marks["Math"] = 95
```

Add new:

```swift
marks["Computer"] = 100
```

---

## Remove

```swift
marks.removeValue(forKey: "Math")
```

---

## Check

```swift
if marks["Math"] != nil {
    print("Math exists")
}
```

---

## Iterate

```swift
for (subject, mark) in marks {
    print(subject, mark)
}
```

---

## Important Dictionary operations

```swift
dictionary[key]
dictionary[key] = value
dictionary.removeValue(forKey: key)
dictionary.count
dictionary.isEmpty
dictionary.keys
dictionary.values
```

---

# 11. Struct

A `struct` is a **value type**.

Example:

```swift
struct Student {
    var name: String
    var age: Int
}
```

Create:

```swift
let s = Student(name: "Keshav", age: 20)
```

Access:

```swift
print(s.name)
```

---

## Struct can contain methods

```swift
struct Rectangle {
    var length: Double
    var width: Double

    func area() -> Double {
        return length * width
    }
}
```

Usage:

```swift
let r = Rectangle(length: 10, width: 5)

print(r.area())
```

Output:

```text
50.0
```

---

# 12. Class vs Struct

This is a **very likely theory + code-output question**.

|Class|Struct|
|---|---|
|Reference type|Value type|
|Supports inheritance|Does not support class inheritance|
|Objects share references|Values are copied|
|Uses `init` commonly|Gets memberwise initializer automatically|
|Can use `deinit`|Cannot use `deinit`|
|Generally used for identity|Generally used for data/value|

### Important difference

Struct:

```swift
struct Student {
    var name: String
}

var s1 = Student(name: "A")
var s2 = s1

s2.name = "B"

print(s1.name)
```

Output:

```text
A
```

Because `s2` gets its **own copy**.

Class:

```swift
class Student {
    var name: String

    init(name: String) {
        self.name = name
    }
}

var s1 = Student(name: "A")
var s2 = s1

s2.name = "B"

print(s1.name)
```

Output:

```text
B
```

Because both variables refer to the **same object**.

This distinction is extremely important.

---

# 13. Enum

An enumeration defines a set of related values.

```swift
enum Direction {
    case north
    case south
    case east
    case west
}
```

Usage:

```swift
var direction = Direction.north
```

Can switch:

```swift
switch direction {
case .north:
    print("Going north")

case .south:
    print("Going south")

case .east:
    print("Going east")

case .west:
    print("Going west")
}
```

---

## Enum with associated values

Very important concept.

```swift
enum Result {
    case success(String)
    case failure(Int)
}
```

Usage:

```swift
let result = Result.success("Downloaded")
```

Handling:

```swift
switch result {
case .success(let message):
    print(message)

case .failure(let code):
    print(code)
}
```

---

## Enum with raw values

```swift
enum Grade: String {
    case A = "Excellent"
    case B = "Good"
    case C = "Average"
}
```

Usage:

```swift
print(Grade.A.rawValue)
```

Output:

```text
Excellent
```

---

# 14. `guard`

`guard` is used to make sure a condition is satisfied before continuing.

It is especially useful for **early exits**.

Syntax:

```swift
guard condition else {
    // must exit
}
```

Example:

```swift
func checkAge(age: Int) {

    guard age >= 18 else {
        print("Not eligible")
        return
    }

    print("Eligible")
}
```

---

## Why use `guard`?

Compare:

### Nested `if`

```swift
func login(username: String, password: String) {

    if username != "" {
        if password != "" {
            print("Login successful")
        }
    }
}
```

Using `guard`:

```swift
func login(username: String, password: String) {

    guard username != "" else {
        print("Username required")
        return
    }

    guard password != "" else {
        print("Password required")
        return
    }

    print("Login successful")
}
```

The second version keeps the **main execution path clear**.

---

# 15. `guard` with Optional Values

This is particularly important in Swift.

Suppose:

```swift
var name: String? = "Keshav"
```

We can safely unwrap it:

```swift
guard let name = name else {
    return
}

print(name)
```

After the `guard`, `name` is treated as a normal non-optional `String`.

---

## `if let` vs `guard let`

### `if let`

```swift
if let name = name {
    print(name)
}
```

The unwrapped variable is mainly available **inside the if block**.

### `guard let`

```swift
guard let name = name else {
    return
}

print(name)
```

The unwrapped variable remains available **after the guard**.

Think:

```text
if let    → do something if value exists
guard let → value MUST exist; otherwise exit
```

---

# 16. Important Combined Example

Exam questions may combine several concepts.

```swift
struct Student {
    var name: String
    var marks: [Int]

    func average() -> Double {
        guard !marks.isEmpty else {
            return 0
        }

        let total = marks.reduce(0) {
            $0 + $1
        }

        return Double(total) / Double(marks.count)
    }
}
```

Create:

```swift
let student = Student(
    name: "Keshav",
    marks: [80, 90, 70]
)

print(student.average())
```

### Concepts used

```text
struct       → Student
properties   → name, marks
method       → average()
guard        → prevents empty-array problem
array        → marks
closure      → reduce
```

---

# 17. Another Important Implementation Pattern

Dictionary + array + closure:

```swift
let students = [
    ["name": "A", "marks": "80"],
    ["name": "B", "marks": "90"],
    ["name": "C", "marks": "60"]
]
```

Filter students with marks > 70:

```swift
let result = students.filter {
    Int($0["marks"]!)! > 70
}
```

Result:

```text
A
B
```

But force-unwrapping (`!`) can crash if the key/value isn't present, so a safer implementation is:

```swift
let result = students.filter { student in
    guard let marks = student["marks"],
          let value = Int(marks) else {
        return false
    }

    return value > 70
}
```

---

# 18. Quick Syntax Sheet

### Variables

```swift
var x = 10
let y = 20
var name: String = "John"
```

### Array

```swift
var a = [1, 2, 3]

a.append(4)
a.remove(at: 0)
a.count
a[0]
```

### Dictionary

```swift
var d = ["A": 10, "B": 20]

d["A"]
d["C"] = 30
d.removeValue(forKey: "A")
```

### Class

```swift
class Person {
    var name: String

    init(name: String) {
        self.name = name
    }

    func greet() {
        print("Hello")
    }
}
```

### Struct

```swift
struct Person {
    var name: String
}
```

### Enum

```swift
enum Direction {
    case north, south, east, west
}
```

### Closure

```swift
let add = { (a: Int, b: Int) -> Int in
    return a + b
}
```

### Map

```swift
let result = numbers.map { $0 * 2 }
```

### Filter

```swift
let result = numbers.filter { $0 > 5 }
```

### Reduce

```swift
let result = numbers.reduce(0) { $0 + $1 }
```

### Guard

```swift
guard condition else {
    return
}
```

### Optional unwrapping

```swift
guard let value = optionalValue else {
    return
}
```

---

# 19. What to Focus on for the Test

I'd prioritize these in this order:

### **Very high priority**

1. **Classes + objects**
    
2. **Variables and data types**
    
3. **Arrays and their operations**
    
4. **Methods + parameters + return values**
    
5. **Closures**
    
6. **`map`, `filter`, `reduce`**
    
7. **Dictionary operations**
    
8. **Struct vs Class**
    
9. **Enums + switch**
    
10. **`guard` + optional unwrapping**
    

### Typical implementation questions

Be ready to write code for:

```text
✓ Create a class with properties and methods
✓ Create objects and call methods
✓ Write an initializer
✓ Manipulate an array
✓ Search/filter an array
✓ Sort an array
✓ Use map/filter/reduce
✓ Create and modify dictionaries
✓ Create a struct with methods
✓ Explain/output class vs struct behavior
✓ Create an enum and use switch
✓ Use associated values in enum
✓ Use guard for validation
✓ Use guard let to unwrap optionals
✓ Predict output of short Swift programs
```

**The biggest things to drill are `closures + map/filter/reduce`, `class vs struct`, and `guard/optionals`** — these are where implementation questions tend to become less obvious than basic syntax.