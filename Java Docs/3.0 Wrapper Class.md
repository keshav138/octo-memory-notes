# **Wrapper Classes in Java**

Wrapper classes in Java **convert primitive data types into objects**. They are useful when working with **Collections, Streams, Generics, and APIs** that require objects instead of primitives.

---

## **1. What Are Wrapper Classes?**

Each **primitive type** in Java has a corresponding **wrapper class** in the `java.lang` package.

|Primitive Type|Wrapper Class|
|---|---|
|`byte`|`Byte`|
|`short`|`Short`|
|`int`|`Integer`|
|`long`|`Long`|
|`float`|`Float`|
|`double`|`Double`|
|`char`|`Character`|
|`boolean`|`Boolean`|

✔ **Wrapper classes allow primitives to be used as objects.**  
✔ Used in **collections (ArrayList, HashMap, etc.)** since they store objects, not primitives.

---

## **2. Creating Wrapper Objects**

### **Using Constructor (Deprecated since Java 9)**

```java
Integer num = new Integer(10); // ❌ Not recommended
```

### **Using `valueOf()` (Recommended)**

```java
Integer num = Integer.valueOf(10); // ✅ Best practice
Double pi = Double.valueOf(3.14);
```

---

## **3. Autoboxing (Primitive → Wrapper)**

Autoboxing is the **automatic conversion of a primitive type into its corresponding wrapper class**.

### **Example:**

```java
public class AutoBoxingExample {
    public static void main(String[] args) {
        int x = 5;
        Integer obj = x; // Autoboxing: int → Integer
        System.out.println("Wrapper Object: " + obj);
    }
}
```

✅ No need to manually wrap the primitive type. Java does it automatically.

---

## **4. Unboxing (Wrapper → Primitive)**

Unboxing is the **automatic conversion of a wrapper object back into a primitive type**.

### **Example:**

```java
public class UnboxingExample {
    public static void main(String[] args) {
        Integer obj = Integer.valueOf(20);
        int x = obj; // Unboxing: Integer → int
        System.out.println("Primitive Value: " + x);
    }
}
```

✅ Java automatically extracts the primitive value.

---

## **5. Wrapper Class Methods**

Wrapper classes **provide utility methods** to work with numbers and booleans.

| Method               | Description                             |
| -------------------- | --------------------------------------- |
| `parseInt(String s)` | Converts a `String` to `int`            |
| `valueOf(String s)`  | Converts a `String` to a wrapper object |
| `toString()`         | Converts wrapper object to `String`     |
| `doubleValue()`      | Returns a primitive `double` value      |
| `intValue()`         | Returns a primitive `int` value         |
| `compareTo(T obj)`   | Compares two wrapper objects            |
| `equals(Object obj)` | Checks if two objects are equal         |

---

### **Example 1: Converting String to Primitive**

```java
public class ParseExample {
    public static void main(String[] args) {
        String str = "100";
        int num = Integer.parseInt(str); // ✅ String → int
        System.out.println(num * 2); // Output: 200
    }
}
```

### **Example 2: Using `valueOf()`**

```java
public class ValueOfExample {
    public static void main(String[] args) {
        Integer obj = Integer.valueOf("50"); // ✅ String → Wrapper
        System.out.println(obj + 10); // Output: 60
    }
}
```

### **Example 3: Comparing Wrapper Objects**

```java
public class CompareExample {
    public static void main(String[] args) {
        Integer a = 100;
        Integer b = 200;
        
        System.out.println(a.compareTo(b)); // -1 (a < b)
        System.out.println(b.compareTo(a)); // 1 (b > a)
    }
}
```

---

## **6. Why Use Wrapper Classes?**

✅ **Collections & Generics:** `ArrayList<Integer>` instead of `ArrayList<int>`  
✅ **Type Conversion:** `Integer.parseInt("123")` → `int`  
✅ **Nullability:** Wrapper objects can be `null`, primitives cannot.  
✅ **Multithreading:** Objects can be synchronized, primitives cannot.

---

## **7. Performance Considerations**

🚀 **Primitives are faster** than wrapper classes since wrapper objects require **extra memory and processing time**.  
⚡ **Avoid unnecessary autoboxing/unboxing** in performance-critical applications.

---

## **8. Real-World Example: Storing Integers in an `ArrayList`**

```java
import java.util.ArrayList;

public class WrapperListExample {
    public static void main(String[] args) {
        ArrayList<Integer> numbers = new ArrayList<>();
        numbers.add(10); // Autoboxing: int → Integer
        numbers.add(20);

        int x = numbers.get(0); // Unboxing: Integer → int
        System.out.println(x);
    }
}
```

✅ `ArrayList` stores `Integer` objects, not `int` directly.

---

## **9. Interview Questions**

1. **Why do we need wrapper classes in Java?**
    
    - To use primitives in **collections, generics, and APIs** that require objects.
2. **What is autoboxing and unboxing?**
    
    - Autoboxing: **Primitive → Wrapper** (e.g., `int → Integer`).
    - Unboxing: **Wrapper → Primitive** (e.g., `Integer → int`).
3. **What is the difference between `parseInt()` and `valueOf()`?**
    
    - `parseInt()` returns a **primitive int**.
    - `valueOf()` returns an **Integer object**.
4. **Are wrapper objects immutable?**
    
    - Yes, wrapper objects **cannot be modified after creation**.

---

## **Summary**

|Feature|Description|
|---|---|
|**Wrapper Classes**|Convert primitives to objects|
|**Autoboxing**|Primitive → Wrapper (Automatic)|
|**Unboxing**|Wrapper → Primitive (Automatic)|
|**Common Methods**|`parseInt()`, `valueOf()`, `toString()`|
|**Performance**|Primitives are faster than wrappers|

---
Arithmetic operations **are possible** on wrapper objects in Java because of **unboxing**. When you use a wrapper object in an arithmetic operation, Java **automatically converts it into a primitive type** before performing the operation.

---

## **1. Arithmetic Operations on Wrapper Objects**

### **Example:**

```java
public class WrapperArithmetic {
    public static void main(String[] args) {
        Integer a = 10;
        Integer b = 20;

        Integer sum = a + b;  // ✅ Unboxing happens before addition
        Integer product = a * b;  // ✅ Unboxing before multiplication

        System.out.println("Sum: " + sum);  // Output: 30
        System.out.println("Product: " + product);  // Output: 200
    }
}
```

### **How It Works?**

- `a + b` → Java **unboxes** `a` and `b` to `int` before addition.
- The result (`int`) is then **autoboxed** back into an `Integer`.

---

## **2. Example with Mixed Wrapper & Primitive Types**

```java
public class MixedOperations {
    public static void main(String[] args) {
        Integer num = 50;
        int result = num + 25;  // ✅ Unboxing happens automatically
        System.out.println(result); // Output: 75
    }
}
```

✅ Java **automatically unboxes `num`** before performing `num + 25`.

---

## **3. Wrapper Objects in Compound Assignments (`+=`, `*=`, etc.)**

```java
public class CompoundOperations {
    public static void main(String[] args) {
        Integer x = 5;
        x += 10; // ✅ Unboxes x, adds 10, then re-boxes
        System.out.println(x); // Output: 15
    }
}
```

### **Why Does This Work?**

1. `x += 10` → Java **unboxes** `x` to `int`.
2. Addition happens (`5 + 10 = 15`).
3. Result (`int 15`) is **autoboxed** back into `Integer`.

---

## **4. What About `null` Wrapper Objects?**

🚨 **Be careful when performing arithmetic on `null` wrapper objects**, as they will cause a `NullPointerException` due to unboxing.

### **Example:**

```java
public class NullWrapperExample {
    public static void main(String[] args) {
        Integer x = null;
        System.out.println(x + 10); // ❌ NullPointerException
    }
}
```

❌ **Error:** `x` is `null`, so Java cannot unbox it into `int`.

---

## **5. Performance Considerations**

While Java **makes arithmetic operations seamless on wrapper objects**, using **primitives (`int`, `double`) is much faster** because:

- Wrapper objects require **memory allocation** (heap storage).
- Unboxing and autoboxing add **extra processing overhead**.

### **Example: Comparing Performance**

```java
public class PerformanceTest {
    public static void main(String[] args) {
        long start, end;

        int sum1 = 0;
        start = System.nanoTime();
        for (int i = 0; i < 1000000; i++) {
            sum1 += i;
        }
        end = System.nanoTime();
        System.out.println("Primitive int time: " + (end - start));

        Integer sum2 = 0;
        start = System.nanoTime();
        for (int i = 0; i < 1000000; i++) {
            sum2 += i; // Causes repeated unboxing/boxing
        }
        end = System.nanoTime();
        System.out.println("Wrapper Integer time: " + (end - start));
    }
}
```

⚡ **Output (varies by machine, but `int` is always faster):**

```
Primitive int time: 300000 ns
Wrapper Integer time: 900000 ns
```

✅ **Use `int` where possible for better performance!**

---

## **Final Takeaways**

✔ **Arithmetic is possible on wrapper objects** due to **automatic unboxing**.  
✔ **Compound operations (`+=`, `-=`, etc.) work** because of unboxing.  
✔ **Be careful with `null` wrapper objects** → causes `NullPointerException`.  
✔ **Using primitives is faster** due to reduced memory and processing overhead.

---

Would you like to explore more about **performance optimizations** or move to the next topic? 🚀