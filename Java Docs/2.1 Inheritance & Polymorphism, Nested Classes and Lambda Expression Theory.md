Here’s a structured breakdown of the theory concepts for your Java test topics, along with key points to remember.

---

## **Inheritance and Polymorphism**

### **1. Inheritance**

- Inheritance allows a subclass to acquire properties and behaviors from a parent class.
    
- It promotes code reuse and improves maintainability.
    
- Java supports **single inheritance** but does not support **multiple inheritance** with classes.
    
- Types of inheritance:
    
    - **Single**: One class inherits from another.
        
    - **Multilevel**: A class inherits from another class, which itself is a subclass of another class.
        
    - **Hierarchical**: Multiple classes inherit from a single parent.
        
    - **Hybrid**: Combination of different inheritance types (achieved via interfaces).
        

### **2. Method Overriding**

- Overriding allows a subclass to provide a specific implementation of a method from its superclass.
    
- The method must have the **same name, return type, and parameters**.
    
- The overridden method in the parent class must be **inheritable** (not private or final).
    
- Use the `@Override` annotation to indicate overriding and avoid mistakes.
    

### **3. The `super` Keyword**

- `super` refers to the immediate parent class.
    
- It is used to:
    
    - Call a superclass constructor.
        
    - Access a superclass method that has been overridden.
        
    - Refer to superclass fields when shadowed by subclass fields.
        

### **4. Object Class and Overriding `toString()` and `equals()`**

- The `Object` class is the parent class of all Java classes.
    
- Important `Object` class methods:
    
    - `toString()`: Returns a string representation of an object.
        
    - `equals(Object obj)`: Compares object references unless overridden.
        
    - `hashCode()`: Returns a unique integer for each object.
        

### **5. Using `super` and `final` Keywords**

- The `final` keyword:
    
    - Applied to variables: Prevents reassignment.
        
    - Applied to methods: Prevents overriding.
        
    - Applied to classes: Prevents inheritance.
        

### **6. `instanceof` Operator**

- Used to check whether an object is an instance of a specific class.
    
- Prevents `ClassCastException` during explicit typecasting.
    

---

## **Abstract Class and Interface**

### **1. Abstract Class and Abstract Methods**

- An **abstract class** cannot be instantiated and can have both abstract and concrete methods.
    
- An **abstract method** has no body and must be implemented in the subclass.
    

### **2. Interfaces**

- Defines a contract that implementing classes must follow.
    
- Can contain:
    
    - **Abstract methods** (default before Java 8).
        
    - **Static and default methods** (introduced in Java 8).
        
    - **Private methods** (introduced in Java 9).
        
- Supports **multiple inheritance**, unlike classes.
    

### **3. Static and Default Methods in Interfaces**

- **Default methods** allow interfaces to have method implementations.
    
- **Static methods** belong to the interface and cannot be overridden.
    

---

## **Nested Class and Lambda Expressions**

### **1. Nested Classes**

- A class declared within another class.
    
- Types:
    
    - **Static Nested Class**: Does not require an instance of the outer class.
        
    - **Non-static (Inner) Class**: Requires an instance of the outer class.
        

### **2. Static and Non-static Nested Classes**

- **Static nested classes** behave like top-level classes.
    
- **Non-static nested classes** can access outer class members.
    

### **3. Local and Anonymous Classes**

- **Local Class**: Declared within a method and can only be used inside it.
    
- **Anonymous Class**: A one-time-use class without a name.
    

### **4. Functional Interface and Lambda Expressions**

- A **functional interface** has only one abstract method.
    
- Lambda expressions provide a short syntax for implementing functional interfaces.
    
- Syntax:
    
    ```java
    (parameters) -> { body }
    ```
    

---

## **Utility Classes: Working with Dates**

- `java.time` package (introduced in Java 8) provides modern date/time API.
    
- Key classes:
    
    - `LocalDate` → Represents a date without time.
        
    - `LocalTime` → Represents a time without date.
        
    - `LocalDateTime` → Represents both date and time.
        
    - `DateTimeFormatter` → Formats dates.
        

---

## **Exceptions and Assertions**

### **1. Exception Overview**

- **Exception**: An unexpected event that disrupts program flow.
    
- Java has two types:
    
    - **Checked exceptions**: Must be handled (e.g., `IOException`, `SQLException`).
        
    - **Unchecked exceptions**: Occur at runtime (e.g., `NullPointerException`, `ArrayIndexOutOfBoundsException`).
        

### **2. Exception Hierarchy and Types**

- The root class of all exceptions is `Throwable`.
    
- Two main branches:
    
    - `Exception` (Checked exceptions)
        
    - `Error` (JVM-related, not recoverable)
        

### **3. Propagation of Exceptions**

- If an exception is not caught in a method, it is propagated to the caller.
    
- Handled using `try-catch` or `throws`.
    

### **4. Try, Catch, Finally**

- **`try`**: Contains code that may cause an exception.
    
- **`catch`**: Handles exceptions.
    
- **`finally`**: Executes after try/catch, regardless of exceptions.
    

### **5. Throw and Throws**

- `throw`: Used to explicitly throw an exception.
    
- `throws`: Declares exceptions in a method signature.
    

### **6. Multi-catch**

- Handles multiple exception types in a single `catch` block.
    

### **7. Try-With-Resources**

- Automatically closes resources (e.g., files, database connections).
    

### **8. Custom Exceptions**

- Custom exceptions are created by extending `Exception` or `RuntimeException`.
    

### **9. Assertions**

- Used to test assumptions in code.
    
- Enabled with the `-ea` JVM argument.
    
- Syntax:
    
    ```java
    assert condition : "Error message";
    ```
    

---

### **Summary Table**

|Topic|Key Points|
|---|---|
|**Inheritance**|Code reuse, single/multilevel/hierarchical inheritance.|
|**Polymorphism**|Method overriding enables runtime polymorphism.|
|**Abstract Class**|Can have both abstract and concrete methods.|
|**Interface**|Defines a contract, supports multiple inheritance.|
|**Nested Classes**|Static and non-static (inner) classes.|
|**Lambda Expressions**|Short syntax for functional interfaces.|
|**Date API**|`LocalDate`, `LocalTime`, `LocalDateTime`.|
|**Exceptions**|Checked vs unchecked, try-catch-finally, throw/throws.|
|**Assertions**|Used for debugging, disabled by default.|

---

This should give you a solid theoretical foundation alongside the code snippets. Let me know if you need any clarifications! 🚀