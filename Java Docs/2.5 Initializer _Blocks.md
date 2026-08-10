# **Initializer Blocks in Java**

Initializer blocks in Java are used to **initialize instance variables** and **execute code** before the constructor runs. There are two types:

1. **Instance Initializer Block (`{}`)** – Runs when an object is created.
2. **Static Initializer Block (`static {}`)** – Runs when the class is loaded.

---

## **1. Instance Initializer Block (`{}`)**

- Runs **before the constructor** whenever an object is created.
- Used to **initialize instance variables** when different constructors share the same logic.

### **Example: Instance Initializer Block**

```java
class Car {
    String model;
    
    // Instance Initializer Block
    {
        System.out.println("Instance Initializer Block Executed");
        model = "Default Model";
    }

    // Constructor
    Car(String model) {
        this.model = model;
        System.out.println("Constructor Executed");
    }

    void display() {
        System.out.println("Car Model: " + model);
    }
}

public class Main {
    public static void main(String[] args) {
        Car car1 = new Car("Tesla");
        Car car2 = new Car("BMW");
        car1.display();
        car2.display();
    }
}
```

### **Output:**

```
Instance Initializer Block Executed
Constructor Executed
Instance Initializer Block Executed
Constructor Executed
Car Model: Tesla
Car Model: BMW
```

✅ The **initializer block runs before every constructor call**.  
✅ **Useful for initializing common fields across multiple constructors.**

---

## **2. Static Initializer Block (`static {}`)**

- Runs **once** when the class is **loaded into memory**.
- Used for **static variable initialization**.

### **Example: Static Initializer Block**

```java
class Database {
    static String dbURL;

    // Static Block
    static {
        System.out.println("Static Block Executed");
        dbURL = "jdbc:mysql://localhost:3306/mydb";
    }

    static void connect() {
        System.out.println("Connecting to Database: " + dbURL);
    }
}

public class Main {
    public static void main(String[] args) {
        Database.connect();
        Database.connect(); // Static block runs only once
    }
}
```

### **Output:**

```
Static Block Executed
Connecting to Database: jdbc:mysql://localhost:3306/mydb
Connecting to Database: jdbc:mysql://localhost:3306/mydb
```

✅ The **static block runs once**, no matter how many objects or method calls happen.

---

## **3. Order of Execution**

|**Type**|**When It Runs?**|
|---|---|
|**Static Block (`static {}`)**|When the class is loaded (once)|
|**Instance Block (`{}`)**|Before each constructor call|
|**Constructor**|After the instance initializer block|

### **Example: Order of Execution**

```java
class Order {
    // Static Block
    static {
        System.out.println("1. Static Block");
    }

    // Instance Block
    {
        System.out.println("2. Instance Block");
    }

    // Constructor
    Order() {
        System.out.println("3. Constructor");
    }
}

public class Main {
    public static void main(String[] args) {
        System.out.println("Main Method Starts");
        Order obj1 = new Order(); // Creates first object
        Order obj2 = new Order(); // Creates second object
    }
}
```

### **Output:**

```
1. Static Block
Main Method Starts
1. Instance Block
2. Constructor
3. Instance Block
4. Constructor
```

✅ **Static Block → Main Method → Instance Block → Constructor** (Instance block runs for every object).

---

## **4. Initializing `final` Variables Using Blocks**

Instance initializer blocks **help initialize `final` instance variables** because constructors cannot modify `final` variables after assignment.

### **Example: Using Instance Block for `final` Variables**

```java
class Employee {
    final int id;
    
    // Instance Block
    {
        id = 100; // ✅ Allowed for final variables
        System.out.println("Instance Block: ID assigned");
    }

    Employee() {
        System.out.println("Constructor: Employee Created");
    }
}

public class Main {
    public static void main(String[] args) {
        Employee e1 = new Employee();
    }
}
```

### **Output:**

```
Instance Block: ID assigned
Constructor: Employee Created
```

✅ **Instance block can initialize `final` variables** before the constructor runs.

---

## **5. Multiple Static and Instance Blocks**

- If a class has **multiple instance blocks**, they execute **in order** before the constructor.
- If a class has **multiple static blocks**, they execute **in order** when the class loads.

### **Example: Multiple Blocks Execution Order**

```java
class Example {
    // First Static Block
    static {
        System.out.println("1. First Static Block");
    }

    // Instance Block 1
    {
        System.out.println("2. First Instance Block");
    }

    // Second Static Block
    static {
        System.out.println("3. Second Static Block");
    }

    // Instance Block 2
    {
        System.out.println("4. Second Instance Block");
    }

    // Constructor
    Example() {
        System.out.println("5. Constructor");
    }
}

public class Main {
    public static void main(String[] args) {
        Example obj1 = new Example();
        Example obj2 = new Example();
    }
}
```

### **Output:**

```
1. First Static Block
2. Second Static Block
3. First Instance Block
4. Second Instance Block
5. Constructor
6. First Instance Block
7. Second Instance Block
8. Constructor
```

✅ **Static blocks execute first (only once), instance blocks run before every constructor call.**

---

## **6. Key Differences Between Static & Instance Blocks**

|Feature|**Static Block**|**Instance Block**|
|---|---|---|
|Runs|When the class loads|Before constructor execution|
|Runs how many times?|**Once** per class|**Every time an object is created**|
|Can access|**Static variables & methods** only|**Instance variables & methods**|
|Purpose|Initialize **static** fields|Initialize **instance** fields|

---

## **7. Common Use Cases**

✅ **Static Blocks:**

- Load **configuration settings** (e.g., database URLs).
- Initialize **static variables**.

✅ **Instance Blocks:**

- Assign **common values** before constructor execution.
- Reduce **constructor code duplication**.

---

## **8. Interview Questions**

1. **Can an instance initializer block access static variables?**
    
    - ✅ Yes, but not vice versa.
2. **Can a class have multiple static or instance blocks?**
    
    - ✅ Yes, they execute **in order** from top to bottom.
3. **Does an instance initializer block run if we call a static method?**
    
    - ❌ No, because no object is created.
4. **Can a static block access `this` keyword?**
    
    - ❌ No, `this` refers to an instance, and static blocks don’t belong to instances.

---

## **9. Summary**

✔ **Instance Block (`{}`)** – Runs **before** the constructor for each object.  
✔ **Static Block (`static {}`)** – Runs **once** when the class loads.  
✔ **Useful for initializing `final` variables, static variables, and configuration settings**.  
✔ **Execution Order:** **Static Block → Instance Block → Constructor**.

---

🚀 **Next Topic?** Want to explore **Constructors vs Initializer Blocks**, **Object Lifecycle**, or another Java concept?