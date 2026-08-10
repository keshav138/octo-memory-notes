# **Method Overloading in Java**

Method Overloading in Java allows multiple methods in the **same class** to have the **same name** but with **different parameter lists**.

---

## **1. What is Method Overloading?**

✔ **Same method name**, but **different parameters** (different type, number, or both).  
✔ **Decided at compile-time** → Example of **Compile-time (static) polymorphism**.  
✔ **Return type does NOT determine overloading** (only parameters matter).

---

## **2. Example: Basic Method Overloading**

```java
public class OverloadingExample {
    // Method with one int parameter
    static int add(int a, int b) {
        return a + b;
    }

    // Overloaded method with three int parameters
    static int add(int a, int b, int c) {
        return a + b + c;
    }

    // Overloaded method with double parameters
    static double add(double a, double b) {
        return a + b;
    }

    public static void main(String[] args) {
        System.out.println(add(5, 10));      // Calls add(int, int)
        System.out.println(add(5, 10, 15));  // Calls add(int, int, int)
        System.out.println(add(3.5, 2.5));   // Calls add(double, double)
    }
}
```

### **Output:**

```
15
30
6.0
```

✅ **Java chooses the best matching method** based on the arguments.

---

## **3. Overloading with Different Parameter Types**

```java
public class TypeOverloading {
    static void display(int a) {
        System.out.println("Integer: " + a);
    }

    static void display(double a) {
        System.out.println("Double: " + a);
    }

    public static void main(String[] args) {
        display(10);   // Calls display(int)
        display(5.5);  // Calls display(double)
    }
}
```

### **Output:**

```
Integer: 10
Double: 5.5
```

✅ **Overloaded methods can have different data types.**

---

## **4. Overloading with Different Argument Order**

```java
public class OrderOverloading {
    static void show(String name, int age) {
        System.out.println("Name: " + name + ", Age: " + age);
    }

    static void show(int age, String name) {
        System.out.println("Age: " + age + ", Name: " + name);
    }

    public static void main(String[] args) {
        show("Alice", 25); // Calls show(String, int)
        show(30, "Bob");   // Calls show(int, String)
    }
}
```

### **Output:**

```
Name: Alice, Age: 25
Age: 30, Name: Bob
```

✅ **Different parameter order makes methods distinct.**

---

## **5. Overloading with Type Promotion (Implicit Conversion)**

Java **promotes smaller types** (`byte → short → int → long → float → double`) if no exact match is found.

```java
public class PromotionOverloading {
    static void test(int a) {
        System.out.println("int: " + a);
    }

    static void test(double a) {
        System.out.println("double: " + a);
    }

    public static void main(String[] args) {
        test(5);   // Calls test(int)
        test(5.5); // Calls test(double)
        test('A'); // Calls test(int) (char → int promotion)
    }
}
```

### **Output:**

```
int: 5
double: 5.5
int: 65
```

✅ **Java promotes `char` to `int`, so `test(‘A’)` calls `test(int)`.**

---

## **6. Method Overloading and `varargs`**

If a method uses **varargs**, it is chosen **only if no better match exists**.

```java
public class VarargsOverloading {
    static void show(int a) {
        System.out.println("Single int: " + a);
    }

    static void show(int... values) {
        System.out.println("Varargs method: " + values.length + " arguments");
    }

    public static void main(String[] args) {
        show(10); // Exact match: Calls show(int)
        show(10, 20, 30); // No exact match: Calls show(int...)
    }
}
```

### **Output:**

```
Single int: 10
Varargs method: 3 arguments
```

✅ **Exact matches always take precedence over `varargs`.**

---

## **7. Overloading with Return Type (Not Allowed)**

🚨 **Return type alone cannot differentiate overloaded methods!**

```java
class ReturnTypeError {
    // static int square(int x) { return x * x; }  // ❌ Invalid if return type is the only difference
    // static double square(int x) { return Math.pow(x, 2); } // ❌ Compile-time error
}
```

✅ **Fix:** Change parameter list, not just return type.

---

## **8. Overloading Constructors**

Constructors can also be overloaded to **initialize objects differently**.

```java
class Car {
    String model;
    int year;

    // Constructor 1
    Car(String model) {
        this.model = model;
        this.year = 2024;
    }

    // Constructor 2 (Overloaded)
    Car(String model, int year) {
        this.model = model;
        this.year = year;
    }

    void display() {
        System.out.println(model + " - " + year);
    }
}

public class ConstructorOverloading {
    public static void main(String[] args) {
        Car car1 = new Car("Toyota");
        Car car2 = new Car("Honda", 2022);

        car1.display(); // Toyota - 2024
        car2.display(); // Honda - 2022
    }
}
```

✅ **Overloaded constructors provide multiple ways to create objects.**

---

## **9. Difference Between Overloading and Overriding**

|Feature|**Method Overloading**|**Method Overriding**|
|---|---|---|
|**Where?**|Same class|Subclass|
|**Method Name?**|Same|Same|
|**Parameters?**|Different|Same|
|**Return Type?**|Can be different|Must be same (or covariant)|
|**Access Modifier?**|No restriction|Cannot reduce visibility|
|**Polymorphism?**|Compile-time (static)|Runtime (dynamic)|
|**Annotation?**|No annotation needed|`@Override` is recommended|

---

## **10. Interview Questions**

1. **Can method overloading happen in different classes?**
    
    - ❌ No, overloading is within the **same class**.
2. **Does return type affect method overloading?**
    
    - ❌ No, only parameters matter.
3. **Can we overload static methods?**
    
    - ✅ Yes, static methods can be overloaded.
4. **Can we overload the `main()` method?**
    
    - ✅ Yes, but JVM calls `main(String[] args)`.
5. **What is the difference between method overloading and method overriding?**
    
    - Overloading = **Compile-time polymorphism**
    - Overriding = **Runtime polymorphism**

---

## **Summary**

✔ **Method Overloading = Same name, different parameters**.  
✔ **Overloading can differ by parameter count, type, or order**.  
✔ **Java chooses the best match at compile-time**.  
✔ **Varargs are considered only if no better match exists**.  
✔ **Constructors can also be overloaded**.

---
### COMPILE TIME EXECUTION

- The compiler decides which method to invoke **based on the arguments passed**.
- Since this decision happens at compile-time, overloading is called **static binding**

### **Why Compile-Time?**

- The compiler checks which `add()` method to call based on the **argument types**.
- There is **no ambiguity**; the method selection happens before runtime.
- That’s why **method overloading is resolved at compile time**.

----
### **Key Concept: Dynamic Binding (Late Binding)**

- In **method overriding**, the method in the subclass **replaces** the one in the superclass.
- The **object type at runtime** decides which method to invoke (not the reference type).
- Since the method selection is **not known until runtime**, overriding is called **dynamic binding**.

```java
class Parent {
    void show() {
        System.out.println("Parent show()");
    }
}

class Child extends Parent {
    @Override
    void show() {
        System.out.println("Child show()");
    }
}

public class OverridingExample {
    public static void main(String[] args) {
        Parent obj = new Child();  // Parent reference, Child object
        obj.show();  // Calls Child's show() at runtime
    }
}

```

### **Why Runtime?**

- The compiler **only knows the reference type (`Parent`)**, not the actual object type (`Child`).
- The method to execute is decided **at runtime**, based on the **actual object type**.
- That’s why **method overriding is resolved at runtime**.