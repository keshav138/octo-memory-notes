An **abstract class** is an incomplete blueprint that serves as a common base for closely related classes (an **"is-a"** relationship), whereas an **interface** is a formal contract that defines capabilities or behavior a class must provide (a **"can-do"** relationship).

  

|**Feature**|**Abstract Class**|**Interface**|
|---|---|---|
|**Core Concept**|Identity: What an object _is_.|Capability: What an object _can do_.|
|**Inheritance**|Single inheritance (a class can extend only one class in Java, C#, etc.).|Multiple implementation (a class can implement multiple interfaces).|
|**State / Fields**|Can hold instance variables, mutable state, and constructors.|Cannot hold instance state (fields are implicitly `public static final` constants in Java).|
|**Methods**|Mix of abstract (unimplemented) and fully implemented concrete methods.|Primarily method signatures (though modern languages allow `default`/`static` methods).|
|**Access Modifiers**|Methods and fields can be `private`, `protected`, or `public`.|Declarations are typically `public` by default.|
|**Constructors**|Can define constructors (invoked by subclass via `super()`).|Cannot have constructors.|
|**Speed**|Marginally faster method dispatch via standard virtual method table (`vtable`).|Slightly more lookup overhead via interface dispatch table (`itable`), though largely negligible.|

**Conceptual Difference**

  

- **Abstract Class ("is-a"):**
    
    Use an abstract class when classes share core identity, internal state, and code logic:
    
      
    - `Dog` **is an** `Animal`.
        
          
        
    - `Sedan` **is a** `Car`.
        
        Both share fields like `species` or `vinNumber`, and can share concrete implementations of common logic (e.g., `breathe()` or `consumeFuel()`).
        
          
        
- **Interface ("can-do"):**
    
    Use an interface when distinct, unrelated classes need to provide the same behavior or API:
    
      
    - `Document`, `Receipt`, and `Photo` can all implement `Printable`.
        
          
        
    - `User`, `Cart`, and `Session` can all implement `Serializable`.
        
        They do not share a common lineage; they just promise to implement a specific action.
        
          
        

**Quick Rule of Thumb**

  

- Choose an **Abstract Class** if you want to share common code, define constructors, or manage mutable state across tightly coupled, related subclasses.
    
      
    
- Choose an **Interface** if you want to define a contract across unrelated classes or enable polymorphism via multiple inheritance.