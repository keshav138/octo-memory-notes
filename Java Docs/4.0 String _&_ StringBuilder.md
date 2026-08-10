# **String and StringBuilder Methods in Java**

Java provides two main classes for handling text:

1. **`String`** → **Immutable (unchangeable)** sequence of characters.
2. **`StringBuilder`** → **Mutable (modifiable)** version of `String` (faster for frequent modifications).

---

# **1. Methods of the `String` Class (`java.lang.String`)**

Since `String` is **immutable**, every modification creates a **new String object**.

## **Basic Methods in `String`**

### **1.1 `length()` – Returns the length of the string**

```java
String str = "Hello";
System.out.println(str.length()); // Output: 5
```

### **1.2 `charAt(index)` – Returns the character at a specific index**

```java
System.out.println(str.charAt(1)); // Output: 'e'
```

### **1.3 `substring(start, end)` – Extracts a substring**

```java
System.out.println(str.substring(1, 4)); // Output: "ell"
```

### **1.4 `indexOf()` – Finds the position of a character or substring**

```java
System.out.println(str.indexOf('l'));  // Output: 2
System.out.println(str.indexOf("lo")); // Output: 3
```

### **1.5 `toLowerCase()` / `toUpperCase()`**

```java
System.out.println(str.toUpperCase()); // Output: "HELLO"
System.out.println(str.toLowerCase()); // Output: "hello"
```

### **1.6 `trim()` – Removes leading and trailing spaces**

```java
String text = "  Hello World  ";
System.out.println(text.trim()); // Output: "Hello World"
```

---

## **String Comparison Methods**

### **2.1 `equals()` – Compares two strings (case-sensitive)**

```java
String a = "Java";
String b = "java";
System.out.println(a.equals(b)); // false
```

### **2.2 `equalsIgnoreCase()` – Compares two strings (case-insensitive)**

```java
System.out.println(a.equalsIgnoreCase(b)); // true
```

### **2.3 `compareTo()` – Lexicographical comparison (`0` if equal, negative if less, positive if greater)**

```java
System.out.println("apple".compareTo("banana")); // Negative (-1)
System.out.println("banana".compareTo("apple")); // Positive (1)
System.out.println("apple".compareTo("apple"));  // Zero (0)
```

---

## **String Manipulation Methods**

### **3.1 `concat()` – Joins two strings**

```java
String first = "Hello";
String second = " World";
System.out.println(first.concat(second)); // Output: "Hello World"
```

### **3.2 `replace()` – Replaces characters or substrings**

```java
System.out.println("banana".replace('a', 'o')); // Output: "bonono"
System.out.println("banana".replace("ana", "xyz")); // Output: "bxyzna"
```

### **3.3 `split()` – Splits a string into an array**

```java
String sentence = "Java is fun";
String[] words = sentence.split(" ");
System.out.println(words[0]); // Output: "Java"
```

### **3.4 `startsWith()` / `endsWith()`**

```java
System.out.println("Java".startsWith("Ja")); // true
System.out.println("Java".endsWith("va"));   // true
```

---

## **4. String Searching Methods**

### **4.1 `contains()` – Checks if a string contains another substring**

```java
System.out.println("Hello World".contains("World")); // true
```

### **4.2 `matches(regex)` – Checks if a string matches a pattern**

```java
System.out.println("abc123".matches("[a-z]+[0-9]+")); // true
```

---

## **5. String Conversion Methods**

### **5.1 `valueOf()` – Converts different types to a string**

```java
System.out.println(String.valueOf(100));  // "100"
System.out.println(String.valueOf(3.14)); // "3.14"
```

### **5.2 `join()` – Joins multiple strings with a delimiter**

```java
System.out.println(String.join(", ", "Apple", "Banana", "Cherry")); 
// Output: "Apple, Banana, Cherry"
```

---

# **2. Methods of the `StringBuilder` Class (`java.lang.StringBuilder`)**

Unlike `String`, **`StringBuilder` is mutable**, making it more efficient for repeated modifications.

---

## **Basic Methods in `StringBuilder`**

### **1.1 `append()` – Adds text at the end**

```java
StringBuilder sb = new StringBuilder("Hello");
sb.append(" World");
System.out.println(sb); // Output: "Hello World"
```

### **1.2 `insert(index, str)` – Inserts text at a specific position**

```java
sb.insert(5, " Java");
System.out.println(sb); // Output: "Hello Java World"
```

### **1.3 `replace(start, end, str)` – Replaces a portion of the string**

```java
sb.replace(6, 10, "Python");
System.out.println(sb); // Output: "Hello Python World"
```

### **1.4 `delete(start, end)` – Removes a portion of the string**

```java
sb.delete(6, 12);
System.out.println(sb); // Output: "Hello World"
```

### **1.5 `reverse()` – Reverses the string**

```java
sb.reverse();
System.out.println(sb); // Output: "dlroW olleH"
```

---

## **2. StringBuilder vs. String Performance**

### **Concatenation Using `String` (Slow)**

```java
String str = "";
for (int i = 0; i < 10000; i++) {
    str += i; // ❌ Inefficient (creates a new object each time)
}
```

### **Concatenation Using `StringBuilder` (Fast)**

```java
StringBuilder sb = new StringBuilder();
for (int i = 0; i < 10000; i++) {
    sb.append(i); // ✅ Efficient (modifies existing object)
}
```

✅ **Use `StringBuilder` for large or frequent modifications**.

---

# **3. Differences Between `String` and `StringBuilder`**

|Feature|`String`|`StringBuilder`|
|---|---|---|
|**Mutability**|Immutable|Mutable|
|**Performance**|Slower (new object every time)|Faster (modifies existing object)|
|**Thread-Safe?**|Yes (Immutable objects are safe)|No (Not synchronized)|
|**Usage**|Use when modifications are rare|Use for frequent modifications|

---

# **4. Interview Questions**

1. **Why is `String` immutable?**
    
    - Security, caching, and performance optimizations.
2. **Which is faster: `String` or `StringBuilder`?**
    
    - `StringBuilder` (since it modifies the existing object).
3. **What is the difference between `StringBuffer` and `StringBuilder`?**
    
    - `StringBuffer` is **thread-safe (synchronized)**, `StringBuilder` is **faster but not synchronized**.
4. **How does `split()` differ from `substring()`?**
    
    - `split()` breaks a string into an array, while `substring()` extracts part of a string.
5. **Can we convert `StringBuilder` to `String`?**
    
    - Yes, using `.toString()`:
    
    ```java
    StringBuilder sb = new StringBuilder("Hello");
    String str = sb.toString();
    ```
    

---

# **Summary**

✔ **Use `String` for immutable data** and **`StringBuilder` for performance**.  
✔ **Important `String` methods**: `length()`, `substring()`, `indexOf()`, `replace()`, `toUpperCase()`.  
✔ **Important `StringBuilder` methods**: `append()`, `insert()`, `replace()`, `reverse()`.

---

🚀 **Next Topic?** Want to explore **StringBuffer**, **Regular Expressions**, or another Java topic?