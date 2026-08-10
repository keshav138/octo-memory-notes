Here are your notes on the given Java topics, structured with explanations and code snippets.

---

## **Inheritance and Polymorphism**

### **1. Inheritance**

Inheritance allows a child class to acquire the properties and behavior of a parent class.

```java
class Animal {
    void makeSound() {
        System.out.println("Animal makes a sound");
    }
}

class Dog extends Animal {
    void makeSound() {  // Overriding the method
        System.out.println("Dog barks");
    }
}

public class Test {
    public static void main(String[] args) {
        Dog d = new Dog();
        d.makeSound();  // Output: Dog barks
    }
}
```

### **2. Method Overriding**

When a subclass provides its own implementation of a method from its superclass.

```java
class Parent {
    void show() {
        System.out.println("Parent class");
    }
}

class Child extends Parent {
    @Override
    void show() {
        System.out.println("Child class");
    }
}

public class OverrideExample {
    public static void main(String[] args) {
        Parent obj = new Child();
        obj.show();  // Output: Child class
    }
}
```

### **3. The `super` Keyword**

Used to refer to the immediate parent class.

```java
class Parent {
    void display() {
        System.out.println("Parent method");
    }
}

class Child extends Parent {
    void display() {
        super.display();  // Calls parent class method
        System.out.println("Child method");
    }
}

public class SuperExample {
    public static void main(String[] args) {
        Child c = new Child();
        c.display();
    }
}
```

### **4. Object Class and Overriding `toString()` and `equals()`**

By default, every Java class inherits from `Object`, which provides methods like `toString()` and `equals()`.

#### **Overriding `toString()`**

```java
class Employee {
    String name;
    
    Employee(String name) {
        this.name = name;
    }
    
    @Override
    public String toString() {
        return "Employee name: " + name;
    }
}

public class ToStringExample {
    public static void main(String[] args) {
        Employee e = new Employee("John");
        System.out.println(e);  // Calls toString()
    }
}
```

#### **Overriding `equals()`**

```java
class Employee {
    String name;
    
    Employee(String name) {
        this.name = name;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;//Checks if both references point to the same memory location (i.e., the same object). If so, they are obviously equal, so return `true`.
        if (!(obj instanceof Employee)) return false;//Checks if `obj` is an instance of `Employee`. If `obj` is `null` or from another class, return `false`.
        Employee e = (Employee) obj;//Downcasting: `obj` is an `Object`, so we cast it to `Employee` (`Employee e = (Employee) obj;`)
        return this.name.equals(e.name);
    }
}

public class EqualsExample {
    public static void main(String[] args) {
        Employee e1 = new Employee("John");
        Employee e2 = new Employee("John");
        System.out.println(e1.equals(e2));  // true
    }
}
```

## **Why is this Check Necessary?**
if (!(obj instanceof Employee)) return false;
- The `equals()` method in Java takes an **`Object`** as a parameter:
## Overiding equals() and toString()
```java
class Employee {
    String name;
    int id;

    Employee(String name, int id) {
        this.name = name;
        this.id = id;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Employee)) return false;
        Employee e = (Employee) obj;
        return this.name.equals(e.name) && this.id == e.id;
    }

    @Override
    public String toString() {
        return "Employee{Name='" + name + "', ID=" + id + "}";
    }
}

public class Main {
    public static void main(String[] args) {
        Employee e1 = new Employee("Alice", 101);
        Employee e2 = new Employee("Alice", 101);
        Employee e3 = new Employee("Bob", 102);

        System.out.println("e1: " + e1);  // Calls toString()
        System.out.println("e2: " + e2);
        System.out.println("e1 equals e2? " + e1.equals(e2));  // true
        System.out.println("e1 equals e3? " + e1.equals(e3));  // false
    }
}


```

### **5. Using `super` and `final` Keywords**

- `super` calls parent methods.
    
- `final` prevents method overriding.
    

```java
class Parent {
    final void show() {
        System.out.println("Cannot override this method");
    }
}

class Child extends Parent {
    // void show() {}  // Error! Cannot override a final method
}
```

### **6. `instanceof` Operator**

Checks if an object is an instance of a specific class.

```java
class Animal {}

class Dog extends Animal {}

public class InstanceofExample {
    public static void main(String[] args) {
        Animal a = new Dog();
        System.out.println(a instanceof Dog);  // true
    }
}
```

---

## **Abstract Class and Interface**

### **1. Abstract Class and Abstract Methods**

Abstract classes cannot be instantiated.

```java
abstract class Animal {
    abstract void makeSound();  // Abstract method
}

class Dog extends Animal {
    void makeSound() {
        System.out.println("Bark");
    }
}
```

### **2. Interfaces**

Interfaces define a contract.

```java
interface Animal {
    void makeSound();
}

class Dog implements Animal {
    public void makeSound() {
        System.out.println("Bark");
    }
}
```

### **3. Static and Default Methods in Interfaces**

```java
interface Animal {
    default void info() {
        System.out.println("This is an animal");
    }
    
    static void staticMethod() {
        System.out.println("Static method in interface");
    }
}
```

---

## **Nested Class and Lambda Expressions**

### **1. Nested Classes**

```java
class Outer {
    class Inner {
        void display() {
            System.out.println("Inner class method");
        }
    }
}
```

### **2. Static and Non-static Nested Classes**

```java
class Outer {
    static class StaticNested {
        void display() {
            System.out.println("Static nested class");
        }
    }
}
```

### **3. Local and Anonymous Classes**

```java
abstract class Animal {
    abstract void makeSound();
}

public class Test {
    public static void main(String[] args) {
        Animal a = new Animal() {
            void makeSound() {
                System.out.println("Anonymous class method");
            }
        };
        a.makeSound();
    }
}
```

### **4. Functional Interface and Lambda Expressions**

```java
@FunctionalInterface
interface MyInterface {
    void show();
}

public class LambdaExample {
    public static void main(String[] args) {
        MyInterface obj = () -> System.out.println("Lambda expression");
        obj.show();
    }
}
```

---

## **Utility Classes: Working with Dates**

```java
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class DateExample {
    public static void main(String[] args) {
        LocalDate date = LocalDate.now();
        System.out.println(date.format(DateTimeFormatter.ofPattern("dd-MM-yyyy")));
    }
}
```

---

## **Exceptions and Assertions**

### **1. Exception Overview**

```java
try {
    int result = 10 / 0;
} catch (ArithmeticException e) {
    System.out.println("Cannot divide by zero");
}
```

### **2. Exception Hierarchy and Types**

- Checked Exceptions (must be handled): `IOException`
    
- Unchecked Exceptions (runtime): `NullPointerException`
    

### **3. Propagation**

```java
class Test {
    void method1() throws ArithmeticException {
        throw new ArithmeticException("Error");
    }
}
```

### **4. Try, Catch, Finally**

```java
try {
    int result = 10 / 0;
} catch (ArithmeticException e) {
    System.out.println("Error caught");
} finally {
    System.out.println("Always executed");
}
```

### **5. Throw and Throws**

```java
void validate(int age) throws IllegalArgumentException {
    if (age < 18) throw new IllegalArgumentException("Underage");
}
```

### **6. Multi-catch**

```java
try {
    int arr[] = new int[5];
    arr[10] = 50;
} catch (ArithmeticException | ArrayIndexOutOfBoundsException e) {
    System.out.println("Exception handled");
}
```

### **7. Try-With-Resources**

```java
try (BufferedReader br = new BufferedReader(new FileReader("test.txt"))) {
    System.out.println(br.readLine());
} catch (IOException e) {
    e.printStackTrace();
}
```

### **8. Custom Exceptions**

```java
class MyException extends Exception {
    MyException(String msg) {
        super(msg);
    }
}
```

### **9. Assertions**

```java
int age = 15;
assert age >= 18 : "Not an adult";
```

---

This should cover all the topics for your test. Let me know if you need more details! 🚀