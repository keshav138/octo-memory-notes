# **🚀 Nested Classes & Lambda Expressions in Java**

Java provides **nested classes** to logically group classes that are **only used in one place**, and **lambda expressions** to make functional programming easier. Let’s explore both in detail.

---

# **🔹 Nested Classes in Java**

A **nested class** is a class **inside another class**. It helps in **encapsulating** logic and improving code readability.

### **📌 Types of Nested Classes**

1️⃣ **Static Nested Class** (No reference to outer class)  
2️⃣ **Non-Static Inner Class** (Has reference to outer class)  
3️⃣ **Local Inner Class** (Inside a method)  
4️⃣ **Anonymous Inner Class** (Created for one-time use)

---

## **1️⃣ Static Nested Class**

🔹 A **static nested class** behaves like a **normal class** but is **inside another class**.  
🔹 Since it's `static`, it **cannot access non-static members** of the outer class.

```java
class Outer {
    static String outerStaticVar = "Static Outer Variable";

    static class NestedStaticClass {  // ✅ Static Nested Class
        void display() {
            System.out.println("Accessing: " + outerStaticVar);  // ✅ Allowed
        }
    }
}

public class StaticNestedExample {
    public static void main(String[] args) {
        Outer.NestedStaticClass obj = new Outer.NestedStaticClass(); // ✅ No need to create Outer instance
        obj.display();
    }
}
```

### **✅ Output**

```
Accessing: Static Outer Variable
```

---

## **2️⃣ Non-Static Inner Class (Member Inner Class)**

🔹 A **non-static inner class** (also called **Member Inner Class**) can access **both static and non-static** members of the outer class.  
🔹 It **requires an instance** of the outer class to be created.

```java
class Outer {
    private String outerVar = "Outer Variable";

    class Inner {  // 🔹 Non-Static Inner Class
        void display() {
            System.out.println("Accessing: " + outerVar);  // ✅ Can access outer class members
        }
    }
}

public class InnerClassExample {
    public static void main(String[] args) {
        Outer outer = new Outer();  
        Outer.Inner inner = outer.new Inner();  // ✅ Requires Outer instance
        inner.display();
    }
}
```

### **✅ Output**

```
Accessing: Outer Variable
```

---

## **3️⃣ Local Inner Class**

🔹 A **local inner class** is defined **inside a method**.  
🔹 It **cannot be accessed outside** the method.  
🔹 It can **access local variables** if they are **final or effectively final** (unchanged after initialization).

```java
class Outer {
    void outerMethod() {
        class LocalInner {  // 🔹 Local Inner Class
            void display() {
                System.out.println("Inside Local Inner Class");
            }
        }
        LocalInner local = new LocalInner();
        local.display();
    }
}

public class LocalInnerExample {
    public static void main(String[] args) {
        Outer outer = new Outer();
        outer.outerMethod();  // ✅ Local inner class is accessed inside method
    }
}
```

### **✅ Output**

```
Inside Local Inner Class
```

---

## **4️⃣ Anonymous Inner Class**

🔹 An **anonymous inner class** is a class **without a name**, used when a class is needed **only once**.  
🔹 It is usually used with **interfaces or abstract classes**.

```java
abstract class Animal {
    abstract void makeSound();
}

public class AnonymousInnerExample {
    public static void main(String[] args) {
        Animal dog = new Animal() {  // ✅ Anonymous Inner Class
            @Override
            void makeSound() {
                System.out.println("Dog barks!");
            }
        };

        dog.makeSound();  // ✅ Calls the method of anonymous class
    }
}
```

### **✅ Output**

```
Dog barks!
```

---

# **🔹 Lambda Expressions in Java**

A **lambda expression** is a short way to write **anonymous functions** (methods without a name).  
It makes **functional programming** easy and reduces **boilerplate code**.

### **📌 Rules for Lambda Expressions**

✅ Used to implement **functional interfaces** (interfaces with a single method).  
✅ Uses **arrow notation** `->` to define behavior.  
✅ No need for method name or return type.

---

## **🔹 Functional Interface (Single Abstract Method)**

A **functional interface** is an interface that has **only one abstract method**.

```java
@FunctionalInterface
interface Calculator {
    int operation(int a, int b);
}
```

---

## **1️⃣ Lambda Expression for Addition**

```java
public class LambdaExample {
    public static void main(String[] args) {
        Calculator add = (a, b) -> a + b;  // ✅ Lambda expression
        System.out.println("Sum: " + add.operation(5, 3));
    }
}
```

### **✅ Output**

```
Sum: 8
```

---

## **2️⃣ Lambda with Custom Functional Interface**

```java
@FunctionalInterface
interface Greeting {
    void sayHello(String name);
}

public class LambdaGreetingExample {
    public static void main(String[] args) {
        Greeting greeting = (name) -> System.out.println("Hello, " + name);  
        greeting.sayHello("John");  // ✅ Calls lambda function
    }
}
```

### **✅ Output**

```
Hello, John
```

---

## **3️⃣ Lambda with Java's Built-in Functional Interfaces**

### **✅ Using `Predicate<T>` (Checks condition)**

```java
import java.util.function.Predicate;

public class PredicateExample {
    public static void main(String[] args) {
        Predicate<Integer> isEven = (n) -> n % 2 == 0;
        System.out.println(isEven.test(4)); // ✅ true
        System.out.println(isEven.test(5)); // ✅ false
    }
}
```

### **✅ Output**

```
true
false
```

---

## **4️⃣ Lambda with Collections (`forEach()`)**

```java
import java.util.*;

public class LambdaForEachExample {
    public static void main(String[] args) {
        List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
        names.forEach(name -> System.out.println("Hello, " + name));
    }
}
```

### **✅ Output**

```
Hello, Alice
Hello, Bob
Hello, Charlie
```

---

# **🔹 Summary: Nested Classes vs. Lambda Expressions**

|Feature|Nested Classes|Lambda Expressions|
|---|---|---|
|**Purpose**|Encapsulation & Code Organization|Functional Programming (Anonymous Methods)|
|**Types**|Static, Non-static, Local, Anonymous|Works with Functional Interfaces|
|**Access to Outer Class Members**|✅ (Inner class can access outer class members)|❌ Cannot access non-final outer variables|
|**Can Have Constructor?**|✅ Yes|❌ No|
|**Common Usage**|GUI, Event Handling, Helper Classes|Streams, Functional Programming|

---

# **🚀 Which One Should You Use?**

✅ **Use Nested Classes** when you need to group classes that are logically related.  
✅ **Use Lambda Expressions** when working with functional interfaces to **write concise code**.

Would you like more **real-world examples** or an **interview-level discussion**? 🚀