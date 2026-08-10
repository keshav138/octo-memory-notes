# **Comprehensive Guide to Nested Classes, Functional Interfaces, and Lambda Expressions in Java**

## **Table of Contents**
1. [Nested Classes](#1-nested-classes)  
   - 1.1 Static Nested Class  
   - 1.2 Non-Static (Inner) Nested Class  
   - 1.3 Comparison Table  
   - 1.4 Use Cases & Best Practices  

2. [Local and Anonymous Classes](#2-local-and-anonymous-classes)  
   - 2.1 Local Class  
   - 2.2 Anonymous Class  
   - 2.3 Comparison Table  
   - 2.4 Use Cases & Best Practices  

3. [Functional Interfaces & Lambda Expressions](#3-functional-interfaces--lambda-expressions)  
   - 3.1 Functional Interface  
   - 3.2 Lambda Expressions  
   - 3.3 Method References  
   - 3.4 Comparison Table  
   - 3.5 Use Cases & Best Practices  

4. [Common Mistakes & Interview Questions](#4-common-mistakes--interview-questions)  

---

## **1. Nested Classes**
Nested classes are classes defined inside another class. They help in logically grouping classes, improving encapsulation, and increasing readability.

### **1.1 Static Nested Class**
- Defined with the `static` keyword.
- Cannot access non-static members of the outer class directly.
- Can be instantiated without an instance of the outer class.

#### **Example:**
```java
class Outer {
    static int outerStaticVar = 10;
    int outerNonStaticVar = 20;

    static class StaticNested {
        void display() {
            System.out.println("Static nested: " + outerStaticVar);
            // System.out.println(outerNonStaticVar); // Error: Cannot access non-static member
        }
    }
}

public class Main {
    public static void main(String[] args) {
        Outer.StaticNested nested = new Outer.StaticNested();
        nested.display(); // Output: Static nested: 10
    }
}
```

### **1.2 Non-Static (Inner) Nested Class**
- Must be instantiated using an instance of the outer class.
- Can access both static and non-static members of the outer class.

#### **Example:**
```java
class Outer {
    int outerVar = 30;

    class Inner {
        void display() {
            System.out.println("Inner class: " + outerVar);
        }
    }
}

public class Main {
    public static void main(String[] args) {
        Outer outer = new Outer();
        Outer.Inner inner = outer.new Inner();
        inner.display(); // Output: Inner class: 30
    }
}
```

### **1.3 Comparison Table**
| Feature                | Static Nested Class | Non-Static (Inner) Class |
|------------------------|---------------------|--------------------------|
| **Keyword**            | `static`            | No `static`              |
| **Access to Outer Class Members** | Only static members | Both static & non-static |
| **Instantiation**      | `Outer.StaticNested obj = new Outer.StaticNested();` | `Outer.Inner obj = outer.new Inner();` |
| **Memory Efficiency**  | Better (no reference to outer class) | Requires outer instance |
| **Use Case**           | Helper classes, utility functions | Tightly coupled logic |

### **1.4 Use Cases & Best Practices**
- **Static Nested Class**: Use when the nested class doesn’t need access to outer class instance variables (e.g., `Map.Entry` in Java Collections).
- **Non-Static Inner Class**: Use when the nested class needs access to outer class members (e.g., event listeners in GUI).

---

## **2. Local and Anonymous Classes**
### **2.1 Local Class**
- Defined inside a method or block.
- Can access `final` or effectively final local variables.

#### **Example:**
```java
class Outer {
    void outerMethod() {
        final int localVar = 40;
        
        class LocalClass {
            void display() {
                System.out.println("Local class: " + localVar);
            }
        }
        
        LocalClass local = new LocalClass();
        local.display(); // Output: Local class: 40
    }
}
```

### **2.2 Anonymous Class**
- A class without a name, defined and instantiated in a single statement.
- Used for one-time implementations (e.g., event listeners, `Runnable`).

#### **Example:**
```java
interface Greeting {
    void greet();
}

public class Main {
    public static void main(String[] args) {
        Greeting greeting = new Greeting() { // Anonymous class
            @Override
            public void greet() {
                System.out.println("Hello from Anonymous Class!");
            }
        };
        greeting.greet(); // Output: Hello from Anonymous Class!
    }
}
```

### **2.3 Comparison Table**
| Feature                | Local Class | Anonymous Class |
|------------------------|-------------|------------------|
| **Name**               | Has a name  | No name          |
| **Reusability**        | Limited to method scope | One-time use |
| **Access to Variables** | Only `final` or effectively final | Same as Local Class |
| **Use Case**           | When a class is needed only inside a method | Quick interface/abstract class implementation |

### **2.4 Use Cases & Best Practices**
- **Local Class**: When a class is needed only within a method (e.g., complex logic inside a loop).
- **Anonymous Class**: For quick implementations (e.g., `Thread`, `Comparator`).  
  **Best Practice**: Prefer **lambda expressions** if the interface is functional.

---

## **3. Functional Interfaces & Lambda Expressions**
### **3.1 Functional Interface**
- An interface with **exactly one abstract method** (`@FunctionalInterface` enforces this).
- Examples: `Runnable`, `Comparator`, `Predicate`.

#### **Example:**
```java
@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);
}

public class Main {
    public static void main(String[] args) {
        Calculator add = (a, b) -> a + b;
        System.out.println(add.calculate(5, 3)); // Output: 8
    }
}
```

### **3.2 Lambda Expressions**
- Shortcut for implementing functional interfaces.
- Syntax: `(parameters) -> { body }`

#### **Example:**
```java
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
names.forEach(name -> System.out.println(name)); // Lambda
```

### **3.3 Method References**
- Shorthand for lambdas calling existing methods.
- Types:  
  - `Class::staticMethod`  
  - `object::instanceMethod`  
  - `Class::instanceMethod`  

#### **Example:**
```java
names.forEach(System.out::println); // Method reference
```

### **3.4 Comparison Table**
| Feature                | Anonymous Class | Lambda Expression | Method Reference |
|------------------------|----------------|-------------------|------------------|
| **Syntax**             | Verbose (`new Interface() { ... }`) | Concise (`(a,b) -> a+b`) | Shortest (`System.out::println`) |
| **Scope**              | Can have state (variables) | Stateless | Stateless |
| **Use Case**           | Multiple methods | Single-method interfaces | Reusing existing methods |

### **3.5 Use Cases & Best Practices**
- **Functional Interfaces**: Use for callbacks, event handling, and stream operations.
- **Lambdas**: Best for short, stateless operations.
- **Method References**: When simply calling an existing method.

---

## **4. Common Mistakes & Interview Questions**
### **Common Mistakes**
1. **Trying to modify non-final variables in local/anonymous classes** → Causes compilation error.
2. **Using non-static nested classes when static would suffice** → Wastes memory.
3. **Confusing lambda syntax** → Ensure the interface is functional.

### **Interview Questions**
1. **Q: What is the difference between static and non-static nested classes?**  
   **A:** Static nested classes don’t require an outer class instance and can’t access non-static members directly.

2. **Q: When would you use an anonymous class over a lambda?**  
   **A:** When implementing an interface with multiple methods or needing state.

3. **Q: What is a functional interface? Give examples.**  
   **A:** An interface with one abstract method (e.g., `Runnable`, `Comparator`).

4. **Q: Can a lambda replace an anonymous class always?**  
   **A:** No, only if the interface is functional.

---

## **Conclusion**
- **Static Nested Class** → Independent helper class.
- **Non-Static Inner Class** → Needs outer class instance.
- **Local Class** → Defined inside a method.
- **Anonymous Class** → One-time implementation.
- **Lambda** → Best for functional interfaces.
- **Method Reference** → Shortcut for method calls.

Understanding these concepts helps write **cleaner, more modular, and efficient Java code**.