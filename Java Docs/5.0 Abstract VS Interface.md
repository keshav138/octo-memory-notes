# **🚀 Abstract Class vs Interface in Java**

Java provides **Abstract Classes** and **Interfaces** to achieve **abstraction**. Let's explore both in depth.

---

# **🔹 Abstract Class in Java**

An **abstract class** is a class that **cannot be instantiated** but can have abstract methods (without implementation) and concrete methods (with implementation).

### **📌 Key Features of Abstract Class**

✅ Can have **abstract methods** (without body)  
✅ Can have **concrete methods** (with body)  
✅ Can **define constructors**  
✅ Can have **instance variables**  
✅ Supports **inheritance (extends keyword)**

---

### **🔹 Abstract Class Example**

```java
abstract class Animal {
    String name;

    Animal(String name) {   // ✅ Constructor allowed
        this.name = name;
    }

    abstract void makeSound();  // 🔹 Abstract method (must be implemented by subclass)

    void sleep() {  // 🔹 Concrete method (has implementation)
        System.out.println(name + " is sleeping...");
    }
}

class Dog extends Animal {
    Dog(String name) {
        super(name);
    }

    @Override
    void makeSound() {
        System.out.println(name + " barks!");
    }
}

public class AbstractExample {
    public static void main(String[] args) {
        // Animal a = new Animal();  // ❌ ERROR: Cannot instantiate abstract class
        Animal d = new Dog("Buddy"); // ✅ Upcasting (Dog is an Animal)
        d.makeSound();  // ✅ Calls Dog's makeSound()
        d.sleep();      // ✅ Uses concrete method from Animal
    }
}
```

### **✅ Output**

```
Buddy barks!
Buddy is sleeping...
```

### **🔹 Why Use Abstract Classes?**

- To provide a **common structure** for related classes.
    
- Allows **code reuse** by defining **concrete methods**.
    
- Forces subclasses to **implement abstract methods**.
    

---

# **🔹 Interface in Java**

An **interface** is a blueprint for a class that only contains **abstract methods (before Java 8)** and **static/default methods (since Java 8).**

### **📌 Key Features of Interfaces**

✅ Cannot have **constructors** (cannot be instantiated).  
✅ Supports **multiple inheritance** (A class can implement multiple interfaces).  
✅ Contains only **public and abstract methods** (before Java 8).  
✅ **Default and static methods** were added in **Java 8**.  
✅ Variables are **implicitly `public static final` (constants).**

---

### **🔹 Interface Example**

```java
interface Animal {
    void makeSound();  // 🔹 Abstract method (No body)
}

class Dog implements Animal {
    @Override
    public void makeSound() {
        System.out.println("Dog barks!");
    }
}

public class InterfaceExample {
    public static void main(String[] args) {
        Animal a = new Dog(); // ✅ Upcasting
        a.makeSound();  // ✅ Calls Dog's implementation
    }
}
```

### **✅ Output**

```
Dog barks!
```

---

# **🔹 Abstract Class vs Interface (Side-by-Side)**

|Feature|**Abstract Class**|**Interface**|
|---|---|---|
|**Methods**|Can have both **abstract & concrete** methods|Before Java 8: Only **abstract** methods, After Java 8: Can have **default & static** methods|
|**Variables**|Can have **instance variables**|Only **public static final (constants)**|
|**Constructors**|✅ Can have constructors|❌ Cannot have constructors|
|**Access Modifiers**|Can have **any access modifier**|Methods are **public by default**|
|**Multiple Inheritance**|❌ Not allowed (A class can extend only one abstract class)|✅ Allowed (A class can implement multiple interfaces)|
|**Use Case**|Used for **common behavior & code reuse**|Used for **defining contracts**|

---

# **🔹 Default and Static Methods in Interface (Java 8+)**

Since **Java 8**, interfaces can have **default** and **static** methods.

### **✅ Default Method (Instance Method in Interface)**

```java
interface Animal {
    void makeSound(); // Abstract method

    default void sleep() {  // ✅ Default method (has implementation)
        System.out.println("Sleeping...");
    }
}

class Dog implements Animal {
    @Override
    public void makeSound() {
        System.out.println("Dog barks!");
    }
}

public class DefaultMethodExample {
    public static void main(String[] args) {
        Dog d = new Dog();
        d.makeSound();  // ✅ Calls overridden method
        d.sleep();      // ✅ Uses default method
    }
}
```

### **✅ Output**

```
Dog barks!
Sleeping...
```

---

### **✅ Static Method (Directly Called on Interface)**

```java
interface Animal {
    static void info() {  // ✅ Static method (Only accessible via interface)
        System.out.println("Animals exist in nature.");
    }
}

public class StaticMethodExample {
    public static void main(String[] args) {
        Animal.info(); // ✅ Static method is called via interface
    }
}
```

### **✅ Output**

```
Animals exist in nature.
```

---

# **🔹 Multiple Interface Implementation**

Since Java **does not support multiple inheritance with classes**, interfaces **solve this limitation**.

### **✅ Multiple Interfaces Example**

```java
interface Animal {
    void makeSound();
}

interface Pet {
    void play();
}

class Dog implements Animal, Pet {
    @Override
    public void makeSound() {
        System.out.println("Dog barks!");
    }

    @Override
    public void play() {
        System.out.println("Dog plays fetch!");
    }
}

public class MultipleInterfacesExample {
    public static void main(String[] args) {
        Dog d = new Dog();
        d.makeSound();
        d.play();
    }
}
```

### **✅ Output**

```
Dog barks!
Dog plays fetch!
```

---

# **🔹 Key Differences Between Abstract Class and Interface**

### **1️⃣ When to Use Abstract Class?**

✅ If you **want to provide common behavior** (some methods implemented).  
✅ If **you need constructors**.  
✅ If the class has **instance variables**.

### **2️⃣ When to Use an Interface?**

✅ If you need to **define a contract** (like `List`, `Set`, etc.).  
✅ If you need **multiple inheritance**.  
✅ If you only need **abstract methods**.

---

# **🔹 Real-World Analogy**

|Concept|Abstract Class|Interface|
|---|---|---|
|**Blueprint of a Vehicle**|A **Car Blueprint** (has wheels, engine, but different brands customize it)|A **Drivable Vehicle** (any moving vehicle must have `start()` and `stop()` methods)|
|**Smartphone**|Abstract class `Smartphone` (has a battery, screen, but brands modify UI)|Interface `Connectable` (any device that connects via Bluetooth or WiFi must implement it)|

---

# **🔹 Summary**

|Feature|Abstract Class|Interface|
|---|---|---|
|**Methods**|Can have both **abstract & concrete** methods|Only **abstract** methods (before Java 8)|
|**Multiple Inheritance**|❌ Not supported|✅ Supported|
|**Default Methods**|❌ Not supported|✅ Supported (Java 8+)|
|**Static Methods**|✅ Allowed|✅ Allowed (Java 8+)|
|**Instance Variables**|✅ Allowed|❌ Only constants (`public static final`)|
|**Constructors**|✅ Allowed|❌ Not allowed|

---

## **🚀 Which One Should You Use?**

🔹 **Use an abstract class** when defining a **base class** with common behavior.  
🔹 **Use an interface** when defining a **contract** for multiple unrelated classes.

Would you like to see **more real-world examples** or an **interview-level discussion**? 🚀