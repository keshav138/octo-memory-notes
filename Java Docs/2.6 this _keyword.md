# **`this` Keyword in Java**

The **`this`** keyword in Java refers to the **current object of a class**. It is primarily used to **avoid naming conflicts, call constructors, and pass the current object**.

---

## **1. When to Use `this`?**

✔ **Differentiate between instance and local variables**  
✔ **Invoke another constructor in the same class**  
✔ **Return the current object**  
✔ **Pass the current object to a method**  
✔ **Pass the current object as a constructor argument**

---

## **2. Using `this` to Resolve Variable Shadowing**

If a method parameter has the same name as an instance variable, `this` helps differentiate them.

### **Example: Without `this` (Incorrect)**

```java
class Car {
    String model;
    
    Car(String model) {
        model = model; // ❌ Does not assign the parameter to instance variable
    }

    void display() {
        System.out.println("Model: " + model); // Null (not assigned correctly)
    }
}
```

---

### **Example: Using `this` (Correct)**

```java
class Car {
    String model;

    Car(String model) {
        this.model = model; // ✅ Assigns parameter to instance variable
    }

    void display() {
        System.out.println("Model: " + this.model);
    }
}

public class Main {
    public static void main(String[] args) {
        Car car = new Car("Tesla");
        car.display(); // Output: Model: Tesla
    }
}
```

✅ **`this.model` refers to the instance variable**, while `model` refers to the method parameter.

---

## **3. Using `this()` to Call Another Constructor**

A constructor can call **another constructor** in the same class using `this()`, reducing code duplication.

### **Example:**

```java
class Student {
    String name;
    int age;

    // Constructor 1
    Student() {
        this("Unknown", 18); // ✅ Calls Constructor 2
    }

    // Constructor 2
    Student(String name, int age) {
        this.name = name;
        this.age = age;
    }

    void display() {
        System.out.println("Student: " + name + ", Age: " + age);
    }
}

public class Main {
    public static void main(String[] args) {
        Student s1 = new Student(); // Calls Student()
        Student s2 = new Student("Alice", 22); // Calls Student(String, int)
        
        s1.display(); // Output: Student: Unknown, Age: 18
        s2.display(); // Output: Student: Alice, Age: 22
    }
}
```

✅ **Avoids redundant code by reusing another constructor.**  
🚨 **Rule:** `this()` must be the **first statement** in the constructor.

---

## **4. Using `this` to Return the Current Object**

`this` can be returned from a method to allow **method chaining**.

### **Example:**

```java
class Person {
    String name;

    Person setName(String name) {
        this.name = name;
        return this; // ✅ Returns current object
    }

    void display() {
        System.out.println("Name: " + name);
    }
}

public class Main {
    public static void main(String[] args) {
        new Person().setName("John").display(); // ✅ Method chaining
    }
}
```

✅ `setName()` **returns `this`, allowing method calls to be chained.**

---

## **5. Using `this` to Pass the Current Object**

The `this` keyword can be used to pass the **current object** as an argument.

### **Example:**

```java
class Printer {
    void print(Person p) {
        System.out.println("Printing: " + p.name);
    }
}

class Person {
    String name;

    Person(String name) {
        this.name = name;
    }

    void sendToPrinter() {
        Printer printer = new Printer();
        printer.print(this); // ✅ Passes current object
    }
}

public class Main {
    public static void main(String[] args) {
        Person p = new Person("Alice");
        p.sendToPrinter(); // Output: Printing: Alice
    }
}
```

✅ **Passes the current object (`this`) to another method.**

---

## **6. Using `this` in an Anonymous Class**

The **`this` keyword behaves differently in anonymous inner classes**.

### **Example:**

```java
class Outer {
    void print() {
        System.out.println("Outer class print()");
    }

    void test() {
        new Printer() {
            void print() {
                System.out.println("Anonymous class print()");
                System.out.println(this.getClass().getName()); // Refers to anonymous class
            }
        }.print();
    }
}

class Printer {
    void print() {
        System.out.println("Printer class print()");
    }
}

public class Main {
    public static void main(String[] args) {
        new Outer().test();
    }
}
```

### **Output:**

```
Anonymous class print()
Main$1
```

✅ **`this` inside an anonymous class refers to the anonymous class itself, not the outer class.**

---

## **7. When to Avoid `this`?**

- ❌ **Static Context:**
    
    - `this` **cannot** be used inside a `static` method because `static` methods belong to the **class, not an instance**.
    
    ```java
    class Example {
        static void show() {
            // System.out.println(this); // ❌ Error: Cannot use 'this' in static context
        }
    }
    ```
    
- ❌ **Outside a Non-Static Method:**
    
    - `this` **only works within instance methods and constructors**.

---

## **8. `this` vs `super`**

|Feature|`this`|`super`|
|---|---|---|
|Refers to|Current instance|Parent class|
|Calls Constructor|`this()` (Same class)|`super()` (Superclass)|
|Used for|Calling instance variables, methods|Accessing parent methods, variables|
|Static Methods?|❌ No|❌ No|

---

## **9. Interview Questions**

1. **Can we use `this` inside a static method?**
    
    - ❌ No, `this` is tied to an instance, and static methods do not belong to instances.
2. **Can a constructor call itself using `this()`?**
    
    - ❌ No, that would cause an **infinite recursion** (StackOverflowError).
3. **What happens if `this()` and `super()` are used together in a constructor?**
    
    - ❌ **Compile-time error**. Either `this()` or `super()` **must be the first statement**, but not both.
4. **Why is `this` used for method chaining?**
    
    - ✅ It allows returning the **current instance**, making code more readable.

---

## **10. Summary**

✔ **`this` refers to the current instance**.  
✔ **Used to differentiate instance and local variables**.  
✔ **Can call another constructor using `this()`**.  
✔ **Can return the current object (`this`) for method chaining**.  
✔ **Cannot be used in static methods**.

---

🚀 **Next Topic?** Want to cover **`super` keyword**, **Inheritance**, or another Java concept?