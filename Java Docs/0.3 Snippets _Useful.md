Absolutely! Here are some **concise and powerful Java snippets** using **modern Java features (Java 8-21)** like **enhanced `switch`, lambda expressions, and streams**.

---

## **1️⃣ Enhanced `switch` for Days of the Week**

```java
int day = 3;
String dayType = switch (day) {
    case 1, 7 -> "Weekend";
    case 2, 3, 4, 5, 6 -> "Weekday";
    default -> "Invalid";
};
System.out.println(dayType); // Output: "Weekday"
```

✅ **Used for:** Concise switch-case expressions (**Java 14+**).

---

## **2️⃣ Ternary Operator for Even/Odd Check**

```java
int num = 10;
String result = (num % 2 == 0) ? "Even" : "Odd";
System.out.println(result); // "Even"
```

✅ **Used for:** Short if-else replacements.

---

## **3️⃣ Find Maximum Using `Math.max()`**

```java
int a = 10, b = 20, c = 5;
int max = Math.max(a, Math.max(b, c));
System.out.println(max); // 20
```

✅ **Used for:** Finding the max of multiple values quickly.

---

## **4️⃣ One-Liner Sum Using `Arrays.stream()`**

```java
int[] nums = {1, 2, 3, 4, 5};
int sum = Arrays.stream(nums).sum();
System.out.println(sum); // 15
```

✅ **Used for:** **Summing arrays** efficiently.

---

## **5️⃣ Generate Random Number Between 1-100**

```java
int random = (int) (Math.random() * 100) + 1;
System.out.println(random);
```

✅ **Used for:** **Random number generation** without imports.

---

## **6️⃣ Enhanced `switch` for Grading System**

```java
int score = 85;
String grade = switch (score / 10) {
    case 10, 9 -> "A";
    case 8 -> "B";
    case 7 -> "C";
    case 6 -> "D";
    default -> "F";
};
System.out.println(grade); // "B"
```

✅ **Used for:** Clean grading logic using **division grouping**.

---

## **7️⃣ Convert List to Comma-Separated String**

```java
List<String> fruits = List.of("Apple", "Banana", "Cherry");
String result = String.join(", ", fruits);
System.out.println(result); // "Apple, Banana, Cherry"
```

✅ **Used for:** Converting **lists to formatted strings**.

---

## **8️⃣ Using `Optional` to Avoid `NullPointerException`**

```java
Optional<String> name = Optional.ofNullable(null);
System.out.println(name.orElse("Unknown")); // "Unknown"
```

✅ **Used for:** Handling **nullable values safely**.

---

## **9️⃣ One-Liner Factorial Using Streams**

```java
int n = 5;
int factorial = IntStream.rangeClosed(1, n).reduce(1, (x, y) -> x * y);
System.out.println(factorial); // 120
```

✅ **Used for:** **Functional-style factorial calculation**.

---

## **🔟 Swap Two Variables Without Temp Variable**

```java
int x = 10, y = 20;
x = x + y - (y = x);
System.out.println(x + " " + y); // "20 10"
```

✅ **Used for:** **Swapping values efficiently**.
### **Why Does This Work Like Swapping?**

- `y = x` **first** stores the old value of `x` in `y`.
- The expression `x = x + y - y` **recomputes `x` using old values**.
- **No temporary variable needed!**

---

## **1️⃣1️⃣ Reverse a String Using `StringBuilder`**

```java
String reversed = new StringBuilder("Java").reverse().toString();
System.out.println(reversed); // "avaJ"
```

✅ **Used for:** **Quick string reversal**.

---

## **1️⃣2️⃣ Remove Duplicates from a List**

```java
List<Integer> numbers = List.of(1, 2, 2, 3, 4, 4);
List<Integer> unique = numbers.stream().distinct().toList();
System.out.println(unique); // [1, 2, 3, 4]
```

✅ **Used for:** **Removing duplicates in one line**.

---

## **1️⃣3️⃣ Count Words in a String**

```java
long count = "Hello world, welcome to Java".split(" ").length;
System.out.println(count); // 5
```

✅ **Used for:** **Quick word counting**.

---

## **1️⃣4️⃣ One-Liner Palindrome Check**

```java
boolean isPalindrome = new StringBuilder("racecar").reverse().toString().equals("racecar");
System.out.println(isPalindrome); // true
```

✅ **Used for:** **Checking palindromes easily**.

---

## **1️⃣5️⃣ Print Fibonacci Series (Java 8+)**

```java
IntStream.iterate(new int[]{0, 1}, f -> new int[]{f[1], f[0] + f[1]})
         .limit(10)
         .map(f -> f[0])
         .forEach(System.out::print);
```

### **Output:**

```
0112358132134
```

✅ **Used for:** **Generating Fibonacci numbers functionally**.

---

## **1️⃣6️⃣ Reverse an Integer**

```java
int num = 12345;
int reversed = Integer.parseInt(new StringBuilder(String.valueOf(num)).reverse().toString());
System.out.println(reversed); // 54321
```

✅ **Used for:** **Reversing an integer without loops**.

---

## **1️⃣7️⃣ Convert `Map` to JSON-like String**

```java
Map<String, Integer> map = Map.of("A", 1, "B", 2);
String json = map.entrySet().stream()
                .map(e -> "\"" + e.getKey() + "\":" + e.getValue())
                .collect(Collectors.joining(", ", "{", "}"));
System.out.println(json); // {"A":1, "B":2}
```

✅ **Used for:** **Converting Maps to JSON format** (without libraries).

---

## **1️⃣8️⃣ Measure Execution Time**

```java
long start = System.nanoTime();
// Code block
long end = System.nanoTime();
System.out.println("Execution Time: " + (end - start) + " ns");
```

✅ **Used for:** **Performance benchmarking**.

---

## **1️⃣9️⃣ Print `n` Multiples of a Number**

```java
IntStream.rangeClosed(1, 10).map(i -> i * 5).forEach(System.out::println);
```

✅ **Used for:** **Printing multiplication tables in one line**.

---

## **2️⃣0️⃣ Find First Non-Repeating Character**

```java
String str = "swiss";
char firstUnique = str.chars().filter(c -> str.indexOf(c) == str.lastIndexOf(c)).findFirst().orElse('-');
System.out.println(firstUnique); // 'w'
```

✅ **Used for:** **Detecting first non-repeating character efficiently.**

---

### 🔥 **Final Thoughts**

These are **compact, highly reusable, and efficient Java snippets**. They cover **core concepts, functional programming, data processing, and performance optimizations**.

Let me know if you need more! 🚀🔥