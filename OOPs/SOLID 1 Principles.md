**SOLID** is an acronym for five foundational design principles in Object-Oriented Programming (OOP), introduced by Robert C. Martin (Uncle Bob). They guide developers in writing software that is modular, maintainable, testable, and easy to extend over time without introducing bugs.

  

### The 5 Principles

**1. S — Single Responsibility Principle (SRP)**

  

- **Rule:** A class should have **one, and only one, reason to change**.
    
      
    
- **Concept:** Every class or module should handle a single part of the system's functionality.
    
      
    
- **Example:** An `Invoice` class should only hold invoice data and business rules. Generating a PDF or saving the invoice to a PostgreSQL database belongs in separate `InvoicePdfPrinter` and `InvoiceRepository` classes.
    
      
    

**2. O — Open-Closed Principle (OCP)**

  

- **Rule:** Software entities should be **open for extension, but closed for modification**.
    
      
    
- **Concept:** You should be able to add new features or behaviors without modifying existing, tested source code.
    
      
    
- **Example:** Use interfaces and polymorphism (like strategy patterns) to introduce new discount rules or payment gateways as separate classes instead of stacking `if-else` branches inside existing logic.
    
      
    

**3. L — Liskov Substitution Principle (LSP)**

  

- **Rule:** Subtypes must be **substitutable for their base types** without altering the correctness of the program.
    
      
    
- **Concept:** A child class should adhere to the behavior expected by the parent class interface. If a function works with class `A`, it shouldn't crash or behave unexpectedly when passed an instance of `A`'s subclass `B`.
    
      
    
- **Example:** If `Square` inherits from `Rectangle`, modifying the width of a `Square` also alters its height, violating assumptions made by code expecting a standard `Rectangle`. Instead, both should implement a broader `Shape` interface.
    
      
    

**4. I — Interface Segregation Principle (ISP)**

  

- **Rule:** Clients should **not be forced to depend on methods they do not use**.
    
      
    
- **Concept:** Prefer several small, role-specific interfaces over a single bloated, "fat" interface.
    
      
    
- **Example:** Instead of a massive `Worker` interface with `code()`, `design()`, and `cook()`, break it into focused interfaces like `Developer`, `Designer`, and `Chef`. A software engineer class only needs to implement `Developer`.
    
      
    

**5. D — Dependency Inversion Principle (DIP)**

  

- **Rule:**
    
      
    1. High-level modules should not depend on low-level modules; **both should depend on abstractions**.
        
          
        
    2. Abstractions should not depend on details; **details should depend on abstractions**.
        
          
        
- **Concept:** Decouple your business logic from concrete infrastructure tools (databases, third-party APIs, UI).
    
      
    
- **Example:** A `UserService` should depend on a `UserRepository` interface rather than directly instantiating a concrete `PostgresUserRepository`. This makes swapping the storage layer or mocking it for unit tests straightforward.
    

### Summary Checklist

| **Principle** | **Focus**          | **What It Prevents**                                           |     |
| ------------- | ------------------ | -------------------------------------------------------------- | --- |
| **S**RP       | Cohesion & Scope   | God classes with too many responsibilities                     |     |
| **O**CP       | Extensibility      | Regressions in existing code when adding features              |     |
| **L**SP       | Subtyping behavior | Broken inheritance hierarchies and unexpected runtime errors   |     |
| **I**SP       | Interface design   | Forcing classes to write empty or dummy method overrides       |     |
| **D**IP       | Decoupling         | Tight coupling to concrete third-party or infrastructure tools | e   |
|               |                    |                                                                |     |