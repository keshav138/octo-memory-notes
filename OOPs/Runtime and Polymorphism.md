## Compile-Time Polymorphism (Static Binding)

Resolved by the compiler _before_ the program runs, based on the **reference type** and **method signature** (name + parameter list).

**Achieved via: Method Overloading** (same method name, different parameters)

```java
class Calculator {
    int add(int a, int b) { return a + b; }
    double add(double a, double b) { return a + b; }
    int add(int a, int b, int c) { return a + b + c; }
}
```

The compiler decides _which_ `add()` to call just by looking at the argument types/count at compile time. No object behavior is involved — it's purely a signature match.

---

## Runtime Polymorphism (Dynamic Binding)

Resolved at **runtime**, based on the **actual object type** (not the reference type). This is what makes OOP flexible.

**Achieved via: Method Overriding** (subclass redefines a parent's method)

```java
class Animal {
    void sound() { System.out.println("Some generic animal sound"); }
}

class Dog extends Animal {
    @Override
    void sound() { System.out.println("Bark"); }
}

class Cat extends Animal {
    @Override
    void sound() { System.out.println("Meow"); }
}
```

### The `Animal a = new Dog()` example

```java
Animal a = new Dog();
a.sound();  // prints "Bark"
```

What's happening here:

|Part|Type|Purpose|
|---|---|---|
|`Animal a`|**Reference type**|Determines what methods are _visible_/callable through `a` (compile-time check)|
|`new Dog()`|**Object type**|Determines _which version_ of an overridden method actually runs (runtime decision)|

- At **compile time**, the compiler only checks: "Does `Animal` have a `sound()` method?" — Yes → allowed.
- At **runtime**, the JVM looks at the actual object in memory (`Dog`), sees it overrides `sound()`, and calls `Dog`'s version instead of `Animal`'s.

This is called **dynamic method dispatch**.

```java
Animal a1 = new Dog();
Animal a2 = new Cat();
Animal a3 = new Animal();

a1.sound(); // Bark
a2.sound(); // Meow
a3.sound(); // Some generic animal sound
```

Same reference type (`Animal`), same method call (`sound()`) — different output depending on the _actual_ object. That's the essence of runtime polymorphism.

### Why `Animal a = new Dog()` and not `Dog d = new Dog()`?

This pattern (**upcasting**) is used for:

- **Polymorphic collections**: `List<Animal> animals = List.of(new Dog(), new Cat());` — loop through and call `sound()` without caring what specific type each is.
- **Loose coupling**: code depends on the `Animal` contract, not concrete subclasses — easier to extend later.

One caveat: through `a`, you can only call methods declared in `Animal`. If `Dog` has an extra method like `fetch()`, you can't call `a.fetch()` unless you downcast: `((Dog) a).fetch()`.

---

### Quick Summary

||Compile-time|Runtime|
|---|---|---|
|Also called|Static / Early binding|Dynamic / Late binding|
|Mechanism|Method Overloading|Method Overriding|
|Decided by|Compiler (signature match)|JVM (actual object at runtime)|
|Flexibility|Less|More — enables true OOP behavior|

---

Good question — Python's dynamic typing changes both halves of this story.

## Compile-Time Polymorphism: Doesn't really exist in Python

Python has **no separate compilation step** that resolves method signatures ahead of time, and it has **no true method overloading**.

```python
class Calculator:
    def add(self, a, b):
        return a + b
    def add(self, a, b, c):   # this just overwrites the first add()
        return a + b + c

calc = Calculator()
calc.add(2, 3)        # TypeError: missing 1 required positional argument
```

Only the **last definition** of `add` survives — Python doesn't distinguish methods by parameter list at all. If you want overload-like behavior, you fake it with:

- Default arguments: `def add(self, a, b, c=0)`
- `*args` / `**kwargs`
- `functools.singledispatch` (a decorator that dispatches based on the _type_ of the first argument — but this checks types at **runtime**, not compile time)

So "compile-time polymorphism" as a concept doesn't map onto Python the way it does in Java/C++.

---

## Runtime Polymorphism: This is where Python actually shines — via Duck Typing

Since there's no static type checking, Python doesn't need reference types (`Animal a = ...`) at all. It uses **duck typing**: _"If it walks like a duck and quacks like a duck, treat it like a duck."_ Any object that has the right method can be used — regardless of class hierarchy.

```python
class Animal:
    def sound(self):
        print("Some generic animal sound")

class Dog(Animal):
    def sound(self):
        print("Bark")

class Cat(Animal):
    def sound(self):
        print("Meow")

animals = [Dog(), Cat(), Animal()]
for a in animals:
    a.sound()
# Bark
# Meow
# Some generic animal sound
```

No `Animal a = new Dog()` needed — you just create `Dog()` directly. Python still resolves `sound()` at runtime by looking at the object's actual class (via `type(a).__mro__`, the method resolution order), so it's still dynamic dispatch — just without the reference-type ceremony Java requires.

### The truly "Pythonic" part: inheritance isn't even required

```python
class Robot:              # doesn't inherit from Animal at all
    def sound(self):
        print("Beep boop")

animals = [Dog(), Cat(), Robot()]
for a in animals:
    a.sound()   # works fine — Python doesn't care about the class hierarchy
```

This wouldn't compile in Java without `Robot` implementing some shared interface/superclass. In Python, **behavior matters more than type** — as long as the object has a `.sound()` method, it's usable.

---

### Side-by-side takeaway

||Java|Python|
|---|---|---|
|Overloading|Real compile-time feature|Doesn't exist (last def wins); faked via defaults/`*args`/`singledispatch`|
|Overriding|Runtime, needs inheritance + reference type|Runtime, via duck typing — inheritance optional|
|Type checking|Static (compiler enforces `Animal` has `sound()`)|None — checked only when the method is actually called (`AttributeError` if missing)|
|"Polymorphism" driver|Class hierarchy + reference types|Shared method names/interfaces (informal, no contract enforced)|

So in short: Python skips compile-time polymorphism almost entirely, and its runtime polymorphism is duck-typing-based rather than reference-type-based — which is more flexible but also means errors (like a missing method) only surface when that code path actually runs.