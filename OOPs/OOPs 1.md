Object-Oriented Programming (OOP) is a paradigm built around **objects**—data structures that bundle state (attributes) and behavior (methods)—to model modular, reusable software systems.

  

### The Four Pillars of OOP

**1. Encapsulation**

  

- **Core Concept:** Bundling data and the methods that operate on that data into a single unit (class), while restricting direct access to internal state using access modifiers (`private`, `protected`, `public`).
    
      
    
- **Real-World Analogy:** A **capsule pill** or an **ATM machine**. You interact with the ATM through a keypad and screen to withdraw cash, but you cannot directly reach in and modify the cash dispenser's internal tray count.
    
      
    
- **Software Implementation:**
    
      
    - **Bank Account:** Keeping the `balance` field `private` and exposing public `deposit()` and `withdraw()` methods with built-in validation checks (e.g., preventing negative withdrawals or overdrafts).
        
          
        

**2. Abstraction**

  

- **Core Concept:** Hiding complex implementation details and showing only the essential features of an object to the outside world.
    
      
    
- **Real-World Analogy:** A **car dashboard and steering wheel**. You turn the key, press the gas pedal, or turn the wheel without needing to manage fuel injection timing, spark plug firing order, or transmission gear ratios.
    
      
    
- **Software Implementation:**
    
      
    - **Payment Gateway Interface:** Defining a generic `PaymentProcessor` interface with a `processPayment(amount)` method. The caller does not need to know the underlying API calls, HMAC signature verification, or network protocols for Stripe, PayPal, or Razorpay.
        
          
        

**3. Inheritance**

  

- **Core Concept:** A mechanism where a new class (subclass/child) derives properties and behaviors from an existing class (superclass/parent), promoting code reusability and establishing an "is-a" relationship.
    
      
    
- **Real-World Analogy:** **Biological classification or vehicles**. A _Tesla Model 3_ is a _Sedan_, which is an _Electric Vehicle_, which is a _Motor Vehicle_. It inherits wheels, doors, and acceleration capabilities from generic vehicle definitions without redefining them.
    
      
    
- **Software Implementation:**
    
      
    - **User Roles:** A base `User` class containing `id`, `email`, and `login()`. Subclasses like `AdminUser` and `CustomerUser` inherit these fields while adding role-specific attributes (`permissionsList` or `cartId`).
        
          
        

**4. Polymorphism**

  

- **Core Concept:** The ability of different classes to respond to the same interface or method call in different ways ("many forms").
    
      
    - **Compile-time (Static):** Method overloading (same method name, different parameters).
        
          
        
    - **Runtime (Dynamic):** Method overriding (child class provides a specific implementation of a parent class method).
        
          
        
- **Real-World Analogy:** The **power button on remote controls**. Pressing the power button on an AC remote turns on cooling; pressing it on a TV remote powers up the display. The same trigger produces distinct behaviors depending on the target device.
    
      
    
- **Software Implementation:**
    
      
    - **Notification Dispatcher:** A base class `Notification` with a method `send()`. The subclasses `EmailNotification`, `SMSNotification`, and `PushNotification` override `send()` with their own transport logic, allowing the notification service to iterate over a list of `Notification` objects and call `.send()` uniformly.
        

### Quick Comparison

|**Pillar**|**Focus**|**Key Mechanism**|**Primary Benefit**|
|---|---|---|---|
|**Encapsulation**|Information hiding & data integrity|Access modifiers, getters/setters|Prevents unauthorized state mutation|
|**Abstraction**|Complexity reduction|Interfaces, abstract classes|Simplifies external interface|
|**Inheritance**|Code reuse & hierarchy|`extends`, class derivation|Eliminates redundant code|
|**Polymorphism**|Interchangeability & flexibility|Overriding, overloading, interfaces|Allows plug-and-play components|