# **Varargs (`Variable Arguments`) in Java**

Varargs (**variable-length arguments**) allow a method to accept **a variable number of arguments** of the same type. Instead of defining multiple overloaded methods, you can use **varargs** (`...`) to pass **zero or more arguments**.

---

## **1. Syntax of Varargs**

```java
returnType methodName(dataType... variableName) {
    // Method body
}
```

- **Ellipsis (`...`)** denotes a **varargs parameter**.
- The varargs parameter **must be the last parameter** in the method signature.
- Internally, varargs are treated as an **array** (`T[]`).

---

## **2. Example: Simple Varargs Method**

```java
public class VarargsExample {
    static void printNumbers(int... nums) {
        for (int num : nums) {
            System.out.print(num + " ");
        }
        System.out.println();
    }

    public static void main(String[] args) {
        printNumbers(1, 2, 3);       // ✅ Pass multiple arguments
        printNumbers(10, 20, 30, 40); // ✅ Pass any number of arguments
        printNumbers();               // ✅ No arguments (valid)
    }
}
```

### **Output:**

```
1 2 3 
10 20 30 40 
```

---

## **3. How Varargs Work Internally**

Internally, Java converts **varargs into an array**.

```java
static void printNumbers(int... nums) {
    for (int num : nums) {
        System.out.print(num + " ");
    }
}
```

is equivalent to:

```java
static void printNumbers(int[] nums) {
    for (int num : nums) {
        System.out.print(num + " ");
    }
}
```

✅ **Varargs are just syntactic sugar for arrays.**

---

## **4. Using Varargs with Other Parameters**

You can use **varargs with other parameters**, but **varargs must be the last parameter**.

### **Example:**

```java
public class VarargsWithParams {
    static void showDetails(String name, int... scores) {
        System.out.print(name + " Scores: ");
        for (int score : scores) {
            System.out.print(score + " ");
        }
        System.out.println();
    }

    public static void main(String[] args) {
        showDetails("Alice", 90, 85, 80);
        showDetails("Bob", 75, 70);
        showDetails("Charlie"); // ✅ No scores passed
    }
}
```

### **Output:**

```
Alice Scores: 90 85 80 
Bob Scores: 75 70 
Charlie Scores: 
```

---

## **5. Passing an Array to Varargs**

Since varargs internally use arrays, you can **pass an array explicitly**.

### **Example:**

```java
public class VarargsArrayExample {
    static void printArray(int... nums) {
        for (int num : nums) {
            System.out.print(num + " ");
        }
        System.out.println();
    }

    public static void main(String[] args) {
        int[] arr = {1, 2, 3, 4, 5};
        printArray(arr); // ✅ Passing an array
    }
}
```

### **Output:**

```
1 2 3 4 5
```

✅ Arrays can be passed directly.

---

## **6. Varargs with Method Overloading**

If a method is overloaded with a **varargs and a regular method**, the **exact match is preferred**.

### **Example:**

```java
class OverloadVarargs {
    static void show(int a) {
        System.out.println("Single int: " + a);
    }

    static void show(int... nums) {
        System.out.println("Varargs method called");
    }

    public static void main(String[] args) {
        show(10); // Calls single int method (Exact match preferred)
        show(10, 20, 30); // Calls varargs method
    }
}
```

### **Output:**

```
Single int: 10
Varargs method called
```

✅ **Exact matches take precedence over varargs.**

---

## **7. Multiple Varargs Parameters?**

🚨 **You cannot have multiple varargs parameters in a method.**

❌ **Example:**

```java
// ❌ ERROR: Only one varargs parameter allowed
static void invalidMethod(int... a, String... b) {}
```

✅ **Fix:** Use an array for one of the parameters.

---

## **8. Common Mistakes**

### **Ambiguity with Overloading**

```java
class VarargsAmbiguity {
    static void show(int... nums) {
        System.out.println("Varargs method");
    }

    static void show(Integer... nums) {
        System.out.println("Wrapper Varargs method");
    }

    public static void main(String[] args) {
        // show(10); // ❌ Compilation error: Ambiguous method call
    }
}
```

🚨 **Both `int...` and `Integer...` are valid, leading to ambiguity.**

✅ **Fix:** Avoid overloading varargs with similar types.

---

## **9. Real-World Use Cases**

✔ **Utility Methods:** `Arrays.asList(T... a)`  
✔ **Logging Frameworks:** `Logger.log(String format, Object... args)`  
✔ **Mathematical Operations:** `sum(int... numbers)`

---

## **10. Interview Questions**

1. **Can we have multiple varargs in one method?**
    
    - ❌ No, only one varargs parameter is allowed.
2. **Can we pass an array to a varargs method?**
    
    - ✅ Yes, since varargs are internally arrays.
3. **What happens if we pass no arguments to a varargs method?**
    
    - ✅ It works fine; the method receives an **empty array**.
4. **What is the difference between `int...` and `int[]` in method parameters?**
    
    - `int...` allows flexible arguments (`sum(1,2,3,4)`), while `int[]` requires an array (`sum(new int[]{1,2,3})`).

---

## **Summary**

|Feature|Description|
|---|---|
|**Varargs Syntax**|`void methodName(int... nums) {}`|
|**Internally Uses**|Arrays (`int...` → `int[]`)|
|**Must Be Last Parameter**|`method(String name, int... scores)` ✅|
|**Allows 0+ Arguments**|`sum()` or `sum(1,2,3,4)`|
|**Precedence**|Exact match wins over varargs|

---

🚀 **Next Topic?** Want to explore **method overloading further** or move to a new concept?