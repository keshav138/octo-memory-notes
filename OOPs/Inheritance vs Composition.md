**Composition over inheritance** is an object-oriented programming design principle stating that you should achieve **code reuse and flexibility by combining simple objects (composition)** rather than by **extending base classes (inheritance)**

The core difference between composition and inheritance comes down to **how objects relate to each other** and **when their behavior is decided**.

  

- **Inheritance** is an **"is-a"** relationship determined at **compile-time**. A class takes on the entire interface, behavior, and internal structure of another class.
    
      
    
- **Composition** is a **"has-a"** relationship determined at **runtime**. A class contains references to other objects and delegates work to them.
    
      
    

### Core Comparison

|**Dimension**|**Inheritance ("Is-a")**|**Composition ("Has-a")**|
|---|---|---|
|**Relationship**|A `Dog` _is an_ `Animal`.|A `Car` _has an_ `Engine`.|
|**Coupling**|**Tight / White-Box Reuse**: The child exposes and depends on internal implementation details of the parent.|**Loose / Black-Box Reuse**: The containing class only interacts with the public API or interface of the internal component.|
|**Flexibility**|**Static**: Bound at compile-time. An instance cannot swap its parent class at runtime.|**Dynamic**: Bound at runtime. You can swap internal components on the fly (e.g., swapping a `V8Engine` for an `ElectricEngine`).|
|**Encapsulation**|**Weakened**: Subclasses can easily break if the parent class modifies its internal method interactions.|**Preserved**: Internal components can change their implementations completely without affecting the host class.|
|**Multiple Lineage**|Restricted by single inheritance in languages like Java, C#, or Go.|Unrestricted. A class can hold references to dozens of different components.|

### Why the Industry Prefers "Composition Over Inheritance"

A classic architectural trap with inheritance is the **combinatorial explosion of classes**.

  

Imagine modeling game characters that need to fly, swim, or walk:

  

#### 1. The Inheritance Approach (Fails Quickly)

If you start with a base `Character`, then subclass:

  

- `FlyingCharacter`
    
      
    
- `SwimmingCharacter`
    
      
    
- `FlyingAndSwimmingCharacter`
    
      
    
- `WalkingAndFlyingCharacter`
    
      
    

If you add a third capability (like `MagicUsing`), you face an exponential explosion of subclasses. Multiple inheritance solves part of this syntactically, but introduces ambiguities like the **Diamond Problem**.


---

## The Problem with Inheritance

While inheritance is excellent for true hierarchical taxonomies, it creates tight coupling. A subclass is deeply dependent on the implementation details of its parent class (often called the "fragile base class" problem). [2, 5]

Inheritance also forces you to predict relationships at compile-time, which can lead to the "Gorilla-Banana Problem": _You wanted a banana, but you got a gorilla holding the banana and the entire jungle attached to it._ For instance, if you create a `Flyable` parent class with `fly()` and `eat()` methods for a `Duck`, and later want to create an `Airplane` class, inheriting from `Flyable` means your airplane awkwardly inherits an `eat()` method it doesn't need. [6, 7]

## How Composition Fixes This

Instead of a rigid taxonomy, composition lets you build complex functionality by assembling small, independent pieces like building blocks. [3]

## Conceptual Comparison

|Feature|Inheritance ("Is-A")|Composition ("Has-A")|
|---|---|---|
|Coupling|Tight; changes to parent break children.|Loose; components are independent.|
|Binding Time|Static; defined at compile-time.|Dynamic; can change at runtime.|
|Flexibility|Low; a class can usually only extend one parent.|High; can mix and match multiple components.|
|Encapsulation|Weak; exposes parent internals to children.|Strong; details stay hidden inside components.|

---

## Code Example: Managing Roles

Imagine designing software for a school. At first, you have `Students` and `Teachers`. But what happens when a graduate student becomes a Teaching Assistant (TA)? They are _both_ a student and a teacher.

## ❌ The Inheritance Approach (Rigid)

With inheritance, you get stuck in multi-layer deep trees or face languages that don't support multiple inheritance. [1, 2]

```python
class User:
    def login(self): pass

class Student(User):
    def submit_assignment(self): pass

class Teacher(User):
    def grade_assignment(self): pass

# How do we make a TeachingAssistant? 
# Python supports multiple inheritance, but it quickly introduces complexity (like the Diamond Problem).
class TeachingAssistant(Student, Teacher): 
    pass 
```

## The Composition Approach (Flexible)

Instead of defining what a user _is_, we define what a user _has_ (their roles). [6]

```python
class StudentRole:
    def submit_assignment(self): 
        print("Assignment submitted.")

class TeacherRole:
    def grade_assignment(self): 
        print("Assignment graded.")

class User:
    def __init__(self, name):
        self.name = name
        self.roles = [] # Composing behaviors dynamically

    def add_role(self, role):
        self.roles.append(role)

# Now, a Teaching Assistant is easily represented at runtime
ta = User("Alex")
ta.add_role(StudentRole())
ta.add_role(TeacherRole())

# Alex can act out any composed behavior dynamically
for role in ta.roles:
    if isinstance(role, StudentRole):
        role.submit_assignment()
```

## When should you still use inheritance?

"Preferring" composition does not mean "never use" inheritance. Inheritance is still highly effective when: [8]

1. The relationship is a permanent, true subtype (e.g., a `SymmetricMatrix` _is always_ a `Matrix`).
2. You want to share state and code across a vast array of identical variants using patterns like the Template Method pattern.
3. You are building foundational frameworks where polymorphism is strictly controlled. [9]

Would you like to look at a refactoring example in a specific programming language like Java, C#, or JavaScript?

 
### When Should You Still Use Inheritance?

Inheritance is not "bad"—it is just frequently overused where composition was the correct tool. Use inheritance only when **all three** of these conditions are met:

  

1. **True "Is-A" Relationship:** The subclass truly is a specialized subtype of the parent, fulfilling the **Liskov Substitution Principle** (any code expecting the parent can use the child without side effects or surprises).
    
      
    
2. **Stable Base Mechanics:** The base class is designed specifically for extension (open/closed principle) and its lifecycle methods are fixed.
    
      
    
3. **No Capability Slicing:** You want the child to expose the entire API surface of the parent without cherry-picking or disabling parent methods (e.g., throwing `UnsupportedOperationException` for inherited methods is a red flag that you need composition).