Got it! Since you have prior coding experience, I'll focus on advanced examples and underlying concepts rather than just theory. Let’s go over the key topics with relevant explanations and examples:

---

### **1. Java Program Structure & Execution**

A Java program consists of:

- A **class** that defines the blueprint for objects.
- A **main() method** as the entry point.
- The **JDK (Java Development Kit), JRE (Java Runtime Environment), and JVM (Java Virtual Machine)** work together for execution.

**Example:**

```java
public class Test {
    public static void main(String[] args) {
        System.out.println("Java Execution Flow");
    }
}
```

- The **JDK** contains tools for compilation.
- The **JVM** interprets bytecode for execution.
- The **JRE** provides libraries and runtime support.
- The **Java Compiler (`javac`)** compiles source code into **bytecode**, not the JVM. The JVM **interprets and executes bytecode**.
- Java is **platform-independent** because it compiles source code into **bytecode**, which is executed by the JVM on any operating system with a compatible JRE.
- The `java` command runs **compiled Java classes** by launching the JVM. The `javac` command is used for compiling Java source files.
- JVM includes a **Garbage Collector (GC)** that manages heap memory by identifying and reclaiming unused objects. **Objects are stored in heap memory, not stack memory**.
- The **JDK (Java Development Kit)** contains everything needed to develop Java applications, including the compiler (`javac`) and debugging tools. **JRE (Java Runtime Environment)** only provides the necessary libraries and JVM to run Java programs.
- **Stack Memory** stores local variables and method call frames. When a method is invoked, a new frame is pushed onto the stack. When it returns, the frame is popped.

#### **Command-line Arguments**

These allow passing arguments to the `main` method.

```java
public class ArgsExample {
    public static void main(String[] args) {
        System.out.println("First Argument: " + args[0]);
    }
}
```

Run with:

```
java ArgsExample Hello
```

Output:

```
First Argument: Hello
```

---

### **2. Data in the Cart (Primitive Types & Wrapper Classes)**

#### **Type Conversion**

**Implicit (Widening Conversion):** No data loss.

```java
int a = 10;
double b = a;  // Automatically converts int to double
```

**Explicit (Narrowing Conversion):** Requires casting.

```java
double x = 9.7;
int y = (int) x;  // Loss of decimal part
```

#### **Wrapper Classes**

Used for boxing/unboxing:

```java
Integer obj = Integer.valueOf(100);  // Boxing
int num = obj.intValue();            // Unboxing
```

Or use **autoboxing/unboxing**:

```java
Integer n = 50;   // Autoboxing
int m = n;        // Unboxing
```

#### **Access Modifiers & Static Keyword**

|Modifier|Scope|
|---|---|
|`private`|Same class only|
|`default`|Same package|
|`protected`|Same package + subclasses|
|`public`|Everywhere|

**Static Members:** Belong to the class, not instances.

```java
class Counter {
    static int count = 0;  // Shared across all objects
    Counter() { count++; }
}
```

---

### **3. Operators in Java**

#### **Bitwise Operators**

```java
int a = 5, b = 3;
System.out.println(a & b);  // 1  (Bitwise AND)
System.out.println(a | b);  // 7  (Bitwise OR)
System.out.println(a ^ b);  // 6  (Bitwise XOR)
```

#### **Ternary Operator**

```java
int x = 10, y = 20;
int min = (x < y) ? x : y;  // Shorter if-else
```

#### **Operator Precedence**

```java
int result = 10 + 3 * 2;  // Multiplication has higher precedence, so result is 16.
```

---

### **4. Conditional Statements**

#### **Switch-Case with Advanced Usage**

Instead of simple integers, Java 14+ supports **switch expressions**:

```java
int day = 3;
String dayType = switch (day) {
    case 1, 7 -> "Weekend";
    case 2, 3, 4, 5, 6 -> "Weekday";
    default -> "Invalid";
};
```

---

Let me know if you want to focus on any specific section! 🚀