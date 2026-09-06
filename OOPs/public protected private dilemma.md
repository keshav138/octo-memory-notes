Interviewers love these tricky questions because they test whether you understand the difference between **scope/accessibility (compile-time visibility)** and **memory layout (runtime existence)**.

  

Here is the exact mental model to crush every variation of this question.

  

### The Fundamental Rule: "Inherited in Memory, Hidden from Scope"

When a child class inherits from a parent with `private` fields:

  

- **Does the child object actually have that private field in memory?** **YES.**
    
    When you allocate a child instance, the memory block allocated on the heap includes all fields from the parent (including `private` ones) plus the child's own fields. The parent's constructor runs to initialize those private fields.
    
      
    
- **Can the child access that field directly by name (`this.x`)?** **NO.**
    
    The compiler blocks direct access because the field is outside the child's visibility scope. It can only be read or modified through inherited `public` or `protected` parent methods (getters/setters).
    
      
    

```
[ Heap Memory Layout of Child Object ]
┌──────────────────────────────────────┐
│ Parent fields (including private x)  │ <-- Exists in memory!
│ Child fields                         │
└──────────────────────────────────────┘
```

### The 4 Classic "Gotcha" Interview Scenarios

#### 1. Field Hiding / Variable Shadowing (Not Overriding!)

Interviewers will define a `private` (or public) field in the parent, and a field with the **exact same name** in the child, then ask: _"What prints?"_

  

Java

```
class Parent {
    public int x = 10;
}
class Child extends Parent {
    public int x = 20; // Shadows/hides Parent.x
}

Parent p = new Child();
System.out.println(p.x); // Prints 10!
```

- **The Gotcha:** **Fields are not polymorphic.** They do NOT use dynamic dispatch (`vtable`).
    
      
    
- **Why:** Field access is resolved at **compile time based on the reference type** (`Parent`), not the runtime instance (`Child`). Both fields exist side-by-side in the memory of the same object.
    
      
    

#### 2. Private Method "Overriding" That Isn't Overriding

The interviewer puts a `private void doSomething()` in the parent and a `public void doSomething()` in the child.

  

Java

```
class Parent {
    private void print() { System.out.println("Parent"); }
    public void execute() { print(); }
}
class Child extends Parent {
    public void print() { System.out.println("Child"); }
}

Child c = new Child();
c.execute(); // Prints "Parent"!
```

- **The Gotcha:** You **cannot override a private method**.
    
      
    
- **Why:** Because `Parent.print()` is `private`, the compiler binds `execute()` directly to `Parent.print()` at compile-time (`invokespecial` in bytecode). The child's `print()` method is completely unrelated; it is a brand-new method that happens to have the same name.
    
      
    

#### 3. Accessing Private Members of ANOTHER Instance of the Same Class

Can instance `A` access the private fields of instance `B` if they are the same class?

  

Java

```
class Node {
    private int val;
    public boolean isBigger(Node other) {
        return this.val > other.val; // COMPILES PERFECTLY!
    }
}
```

- **The Gotcha:** People assume `private` means "only inside `this` instance."
    
      
    
- **Reality:** Access modifiers are enforced at the **class level, not the object/instance level**. Any code inside the `Node` class can access private fields of _any_ `Node` instance.
    
      
    

#### 4. The `super()` Constructor Dilemma

_"If the parent class only has a private constructor, can it be extended?"_

  

- **Answer:** **No.**
    
      
    
- **Why:** Every child constructor implicitly or explicitly calls `super()`. If the parent has only `private Parent()`, the child cannot invoke `super()`, resulting in a compile-time error.
    
      
    
- **Architecture takeaway:** This is how you enforce singleton patterns or force factory methods (e.g., `class MathUtility { private MathUtility() {} }`).
    
      
    

### 15-Second Answer for the Interviewer

> "A child object physically contains all parent private fields in memory—it has to, because the parent constructor initializes them. However, accessibility is checked at compile-time, so the child has no direct visibility to those fields and must interact with them via inherited `public` or `protected` methods. Also, fields cannot be overridden—only hidden/shadowed—because field resolution is strictly static based on the reference type."

---

In C++, access specifiers like `public`, `protected`, and `private` are used in two distinct places:

  

1. **Inside a class:** To set the visibility of members (`int x;`).
    
      
    
2. **In the inheritance declaration:** To set an **access ceiling (filter)** for how those members enter the derived class (`class Derived : protected Base`).
    
      
    

When you inherit using `protected Base`, you are telling the compiler: **"Demote anything more accessible than `protected` down to `protected`."**

  

### The Access Ceiling Rule

Think of the inheritance specifier as a **cap**:

  

$$\text{Final Visibility in Derived} = \min(\text{Original Visibility in Base}, \text{Inheritance Specifier})$$

Where visibility rank is: $\text{private} < \text{protected} < \text{public}$.

  

|**Base Member**|**Inherited via : public Base**|**Inherited via : protected Base**|**Inherited via : private Base**|
|---|---|---|---|
|`public`|**`public`**|**`protected`** (demoted)|**`private`** (demoted)|
|`protected`|**`protected`**|**`protected`** (unchanged)|**`private`** (demoted)|
|`private`|**Inaccessible**|**Inaccessible**|**Inaccessible**|

_Note: `private` members of `Base` are never directly accessible by `Derived` under any inheritance mode._

  

### Concrete Example: How It Affects Real Code

C++

```
class Base {
public:
    int pub = 1;
protected:
    int prot = 2;
private:
    int priv = 3;
};

// PROTECTED INHERITANCE:
// - pub becomes 'protected' inside Derived
// - prot stays 'protected' inside Derived
// - priv is inaccessible
class Derived : protected Base {
public:
    void memberFunction() {
        pub = 10;   // OK: inside Derived, 'pub' is protected
        prot = 20;  // OK: inside Derived, 'prot' is protected
        // priv = 30; // COMPILE ERROR: Base::priv is private
    }
};
```

#### Where the Demotion Bites You: Outside the Class (`main()`)

Because `pub` was demoted to `protected` inside `Derived`, external callers can no longer touch it:

  

C++

```
int main() {
    Base b;
    b.pub = 100; // OK: 'pub' is public on Base

    Derived d;
    d.pub = 100; // COMPILE ERROR! 'pub' is now protected in Derived!
}
```

### How It Propagates to Grandchildren (`GrandChild`)

The key reason interviewers ask about `protected` vs `private` inheritance is what happens to the next generation in the hierarchy.

  

#### With `protected Base`:

Grandchildren can still access those members because `protected` members stay available to subclasses:

  

C++

```
class GrandChild : public Derived {
public:
    void test() {
        pub = 50;  // OK! 'pub' was protected in Derived, so GrandChild inherits it!
        prot = 60; // OK! 'prot' was protected in Derived, so GrandChild inherits it!
    }
};
```

#### Compare this with `private Base`:

If `Derived` had inherited via `: private Base`, both `pub` and `prot` would have become `private` to `Derived`. In that case, `GrandChild` would get a compile error trying to access `pub` or `prot`.

  

### Summary Checklist for an Interview

- **Inside `Derived`:** You can access both `pub` and `prot` freely.
    
      
    
- **Outside `Derived` (e.g., `main()`):** Neither `pub` nor `prot` can be accessed on a `Derived` object (`d.pub` fails).
    
      
    
- **Inside `GrandChild`:** Both `pub` and `prot` are still accessible because they are `protected`.
    
      
    
- **Polymorphism:** You **cannot** convert a `Derived*` to a `Base*` from normal outside code (e.g., `Base* ptr = new Derived()` fails) because the base class relationship itself is protected/hidden from the outside world.