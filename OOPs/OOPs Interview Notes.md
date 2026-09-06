Here are advanced, interview-tested deep dives on each of the 4 OOP pillars, focusing on edge cases, memory mechanics, architectural traps, and how to defend them in senior-level discussions.

  

### 1. Encapsulation (Beyond "Getters and Setters")

Interviewers push past "data hiding" to test whether you understand domain invariants and object integrity.

  

- **Encapsulation vs. Data Hiding vs. Abstraction:**
    
      
    - _Encapsulation:_ Bundles data with the methods that operate on it and enforces access boundaries.
        
          
        
    - _Data Hiding:_ A technique within encapsulation (via `private`/`protected`) to prevent direct state mutation.
        
          
        
    - _Abstraction:_ Hides complexity and implementation details, showing only the public interface.
        
          
        
- **The "Anemic Domain Model" Anti-pattern:**
    
      
    - Having private fields with public getters and setters for everything is **not** true encapsulation; it is an open struct in disguise.
        
          
        
    - _Senior explanation:_ True encapsulation protects **class invariants** (business rules). Instead of `order.setStatus("PAID")`, the object should expose `order.markPaid(paymentReceipt)`, ensuring state transitions are validated internally.
        
          
        
- **Leaky Abstractions via Mutable References:**
    
      
    - Returning a mutable reference (like a standard `List`, `Date`, or internal object) breaks encapsulation because external callers can mutate state without the class knowing.
        
          
        
    - _Fix:_ Return **defensive copies** or **unmodifiable views** (e.g., `Collections.unmodifiableList()` or read-only slices).
        
          
        
- **The Law of Demeter (Principle of Least Knowledge):**
    
      
    - Avoid train wrecks like `user.getAccount().getWallet().getBalance()`. It tightly couples the caller to internal object graphs and violates structural encapsulation. Expose high-level operations like `user.canAfford(amount)` instead.
        
          
        

### 2. Abstraction (Design & Decoupling)

Interviewers probe abstraction to see if you can balance clean contracts against over-engineering.

  

- **Interface Pollution vs. Interface Segregation (ISP):**
    
      
    - _Interview Trap:_ Creating single-implementation interfaces everywhere preemptively (`IUserService` with only `UserServiceImpl`).
        
          
        
    - _Defense:_ Interfaces should model role-based capabilities (`Auditable`, `PaymentProcessor`), not 1:1 shadows of every service. Split fat interfaces into small, cohesive contracts so clients only depend on methods they actually consume.
        
          
        
- **Coupling vs. Cohesion:**
    
      
    - Good abstraction achieves **high cohesion** (everything inside a module is tightly focused on a single concern) and **low coupling** (modules interact strictly through stable, well-defined boundaries).
        
          
        
- **Information Hiding at Boundary Layers:**
    
      
    - Do not let database entities or transport layers leak through abstraction boundaries (e.g., passing an ORM model directly to your frontend/API layer couples business logic to database schema changes). Use DTOs or Value Objects.
        
          
        

### 3. Inheritance (The Fragile Base Class Problem)

Modern technical interviews heavily favor composition over inheritance. Be ready to explain _why_ and identify when inheritance fails.

  

- **Composition over Inheritance:**
    
      
    - Inheritance creates tight compile-time coupling (**white-box reuse**—the child knows and depends on internal base mechanics).
        
          
        
    - Composition creates loose runtime flexibility (**black-box reuse**—objects interact strictly via exposed contracts, easily swapped or mocked).
        
          
        
- **The Fragile Base Class Problem:**
    
      
    - Changing an implementation detail in a base class can silently break subclasses.
        
          
        
    - _Classic Trap:_ If a base class `CustomList` implements `addAll()` by internally looping and calling `add()`, and a subclass overrides both `add()` and `addAll()` to count insertions, calling `addAll()` will increment the counter twice.
        
          
        
- **The Diamond Problem & Multi-Inheritance:**
    
      
    - Occurs when class `D` inherits from `B` and `C`, both of which inherit from `A`. If `B` and `C` override a method from `A`, which one does `D` invoke?
        
          
        
    - _How engines solve it:_
        
          
        - **C++:** Virtual base classes (`virtual public A`).
            
              
            
        - **Python:** Method Resolution Order (**MRO**) using the C3 Linearization algorithm.
            
              
            
        - **Java/C#:** Disallows multiple class inheritance; resolves interface default method clashes by forcing the implementing class to explicitly override and disambiguate.
            
              
            
- **Liskov Substitution Principle (LSP):**
    
      
    - Any subclass must be replaceable for its superclass without breaking system correctness.
        
          
        
    - _Classic Violation:_ The **Square-Rectangle Problem**. A `Square` extending `Rectangle` breaks invariants if setting `width` changes `height`, violating callers' assumptions about standard rectangles.
        
          
        

### 4. Polymorphism (Runtime Mechanics & Dispatch)

This is where interviewers dive under the hood to see if you understand compilers and memory.

  

- **Static (Compile-Time) vs. Dynamic (Runtime) Polymorphism:**
    
      
    - _Static:_ Method overloading, templates/generics. Resolved at compile time via name mangling. Zero runtime dispatch overhead.
        
          
        
    - _Dynamic:_ Method overriding via inheritance or interfaces. Resolved at runtime based on the actual object instance.
        
          
        
- **Under the Hood: How Dynamic Dispatch Works (`vtable` & `vptr`):**
    
      
    - Any class with virtual/overridden methods has a **Virtual Method Table (`vtable`)** created by the compiler—an array of function pointers.
        
          
        
    - Every instantiated object carries a hidden pointer (**`vptr`**) pointing to its class's `vtable`.
        
          
        
    - When calling `animal.speak()`, the CPU looks up the object's `vptr`, offsets into the `vtable`, and invokes the resolved function pointer.
        
          
        
    - _Interface Dispatch (`itable`):_ Because a class can implement multiple unrelated interfaces at differing offsets, dynamic interface dispatch generally requires secondary lookup tables or inline caching, making it slightly more involved than direct `vtable` lookups.
        
          
        
- **Covariance vs. Contravariance:**
    
      
    - **Covariant Return Types:** A subclass method override can return a _more specific_ subtype than the parent method (e.g., parent returns `Animal`, child override returns `Dog`).
        
          
        
    - **Contravariant Parameters:** Accepting a _broader/more generic_ parameter type in an override (supported in some languages/typing systems, though standard Java/C++ strictly enforce identical parameter signatures for overrides to avoid ambiguous dispatch).
        
          
        
- **Double Dispatch / Visitor Pattern:**
    
      
    - Standard dynamic dispatch is **single dispatch**—the method invoked depends only on the runtime type of the caller (`object.method(param)`), while `param` is evaluated at compile time.
        
          
        
    - If the method execution must depend on the runtime types of **both** the receiver and the argument, you need the **Visitor Pattern** (double dispatch).
        

### Quick Cheat-Sheet: Classic Interview Scenarios

|**Question**|**Core Takeaway to State**|
|---|---|
|_"Why not make all methods virtual by default?"_|Virtual dispatch adds a pointer dereference overhead and blocks aggressive compiler optimizations like method inlining.|
|_"Why shouldn't you call virtual/overridable methods inside a constructor?"_|The base class constructor runs _before_ the child class fields are initialized. Calling an overridden method from a base constructor will access uninitialized child state.|
|_"Why prefer Interfaces over Abstract Classes?"_|Avoids single-inheritance locking, allows multiple capability implementations, prevents unwanted state leakage, and makes unit testing/mocking straightforward.|