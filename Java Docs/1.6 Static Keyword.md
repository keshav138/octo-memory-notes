# **`static` Keyword in Java**

The `static` keyword in Java is used for **memory management** and allows members (variables, methods, blocks, and nested classes) to belong to the **class itself rather than an instance**.

---

## **Where Can `static` Be Used?**

Java allows `static` to be applied to the following:

|Element|Usage|
|---|---|
|**Variables**|Shared across all instances of the class.|
|**Methods**|Can be called without creating an object.|
|**Blocks**|Executes once when the class is loaded.|
|**Nested Classes**|Can access only static members of the outer class.|

---

## **1. Static Variables (Class Variables)**

A `static` variable is **shared among all objects** of a class. It is stored in the **class area (method area)**, rather than being created with each object.

### **Example:**

```java
class Counter {
    static int count = 0; // Static variable (shared among all instances)

    Counter() {
        count++; // Increment shared count
        System.out.println("Count: " + count);
    }
}

public class Main {
    public static void main(String[] args) {
        Counter obj1 = new Counter();
        Counter obj2 = new Counter();
        Counter obj3 = new Counter();
    }
}
```

### **Output:**

```
Count: 1
Count: 2
Count: 3
```

✅ `count` is **shared** among all instances, meaning every new object increments the same variable.

### **Key Points:**

✔ **Belongs to the class, not an object**.  
✔ **Common for all objects** (modifying one affects all).  
✔ **Useful for constants, counters, and shared properties**.

---

## **2. Static Methods**

A `static` method **belongs to the class** and can be called **without creating an object**.

### **Example:**

```java
class MathUtils {
    static int square(int x) {
        return x * x;
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println(MathUtils.square(5)); // ✅ No need to create an object
    }
}
```

### **Output:**

```
25
```

### **Rules for Static Methods:**

✅ Can **only access static data** (cannot use instance variables).  
✅ Cannot use **`this` or `super`** (because there is no instance context).  
✅ Best for **utility methods** (e.g., `Math.pow()`, `Integer.parseInt()`).

❌ **Example of Incorrect Usage:**

```java
class Test {
    int x = 10;

    static void show() {
        // System.out.println(x); // ❌ Error: Cannot access instance variable
    }
}
```

---

## **3. Static Blocks (Initialization Blocks)**

A `static` block **executes once** when the class is loaded.

### **Example:**

```java
class StaticBlockExample {
    static {
        System.out.println("Static Block Executed");
    }

    StaticBlockExample() {
        System.out.println("Constructor Called");
    }
}

public class Main {
    public static void main(String[] args) {
        StaticBlockExample obj1 = new StaticBlockExample();
        StaticBlockExample obj2 = new StaticBlockExample();
    }
}
```

### **Output:**

```
Static Block Executed
Constructor Called
Constructor Called
```

✅ **Static block runs once**, while the constructor runs every time an object is created.

### **Key Points:**

✔ **Executes before constructors** and only once per class.  
✔ Used for **static variable initialization**.

---

## **4. Static Nested Class**

A **static nested class** is a class defined inside another class **with `static` modifier**.

### **Example:**

```java
class OuterClass {
    static class StaticNested {
        void display() {
            System.out.println("Inside Static Nested Class");
        }
    }
}

public class Main {
    public static void main(String[] args) {
        OuterClass.StaticNested obj = new OuterClass.StaticNested();
        obj.display();
    }
}
```

### **Output:**

```
Inside Static Nested Class
```

### **Key Points:**

✔ Can **only access static members** of the outer class.  
✔ Does **not require an instance** of the outer class.

---

## **5. Static vs Instance Members**

|Feature|Static (`static`)|Instance (Non-static)|
|---|---|---|
|**Memory**|**Class area** (shared)|**Heap memory** (per object)|
|**Belongs to**|Class|Individual objects|
|**Access**|`ClassName.member`|`object.member`|
|**Instance Access**|❌ Cannot access instance members|✅ Can access all members|
|**Method Context**|No `this` or `super`|Has `this`|

---

## **Real-World Use Cases**

✅ **Utility Classes** (`Math`, `Collections`)  
✅ **Shared Counters/Configurations**  
✅ **Factory Methods**  
✅ **Singleton Design Pattern** (Single instance)  
✅ **Static Blocks for Database Connections**

---

## **Interview Questions**

1. **Can a static method be overridden?**
    
    - No, **static methods are bound to the class** and cannot be overridden (only hidden).
2. **Can we use `this` inside a static method?**
    
    - No, because `this` refers to an **instance**, and static methods do not belong to any instance.
3. **Why can’t a static method access instance variables?**
    
    - Static methods **belong to the class**, whereas instance variables belong to objects, which might not exist.
4. **Can a class be `static`?**
    
    - Yes, **only a nested class** can be `static`, but **top-level classes cannot**.

---

## **Summary**

|Static Feature|Description|
|---|---|
|**Static Variable**|Shared among all instances|
|**Static Method**|Can be called without an object|
|**Static Block**|Runs once when the class loads|
|**Static Nested Class**|Can access only static members|

---

Would you like a deep dive into **static vs non-static methods**, or should we move to the next topic? 🚀