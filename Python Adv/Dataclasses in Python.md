Python dataclasses are regular Python classes that are specifically geared toward storing data and state. Introduced in Python 3.7 via the [`dataclasses` module](https://docs.python.org/3/library/dataclasses.html), they use a decorator to automatically write repetitive boilerplate code—like constructors and object representations—for you. 

Instead of writing a complex class structure, you simply declare your attributes using type hints.

---

## Why Use Dataclasses? (The Boilerplate Comparison)

To see the value of a dataclass, look at how much cleaner the code becomes compared to a traditional Python class.

## Regular Python Class

```python
class Product:
    def __init__(self, name: str, price: float, quantity: int):
        self.name = name
        self.price = price
        self.quantity = quantity

    def __repr__(self):
        return f"Product(name={self.name!r}, price={self.price!r}, quantity={self.quantity!r})"

    def __eq__(self, other):
        if not isinstance(other, Product):
            return NotImplemented
        return (self.name, self.price, self.quantity) == (other.name, other.price, other.quantity)
```

## The Dataclass Equivalent

```python
from dataclasses import dataclass

@dataclass
class Product:
    name: str
    price: float
    quantity: int
```

## Core Features & Automatically Generated Methods

When you wrap a class with the `@dataclass` decorator, Python automatically injects several critical "dunder" (double underscore) methods: [1]

- `__init__()`: A constructor that accepts arguments for all declared fields in the exact order they are listed.
- `__repr__()`: A clean, readable string representation of the object (e.g., `Product(name='Laptop', price=999.9, quantity=5)`), which is highly useful for debugging.
- `__eq__()`: An equality operator that allows you to compare two instances (e.g., `prod1 == prod2`) based on their actual data rather than their memory addresses.

---

## Core Functionality & Common Settings

Dataclasses are highly customizable through decorator parameters and helper functions: [1, 8]

|Feature|Code Example|Purpose|
|---|---|---|
|Default Values|`quantity: int = 0`|Assigns a default value if one isn't provided during instantiation.|
|Immutability|`@dataclass(frozen=True)`|Makes the object read-only. Trying to modify fields after creation raises an error.|
|Object Sorting|`@dataclass(order=True)`|Automatically adds comparison methods (`<`, `>`, `<=`, `>=`) based on field values.|
|Memory Optimization|`@dataclass(slots=True)`|Shrinks the memory footprint and speeds up attribute access.|

## Handling Mutable Defaults (The `field()` Function)

You cannot use mutable objects (like lists or dictionaries) as direct default values in Python classes. To do this safely in a dataclass, you must use the `field` function combined with a `default_factory`:
```python
from dataclasses import dataclass, field

@dataclass
class ShoppingCart:
    items: list[str] = field(default_factory=list) # Creates a unique list for every instance
```

## Customizing Initialization with `__post_init__`

If you need to validate data or compute a field after the automatically generated `__init__` runs, you can implement the `__post_init__` method: 

```python
@dataclass
class Book:
    title: str
    price: float
    
    def __post_init__(self):
        if self.price < 0:
            raise ValueError("Price cannot be negative")
```

---

## Helpful Built-in Utilities

The `dataclasses` module includes built-in functions to serialize or transform your objects quickly:

```python
from dataclasses import asdict, astuple

book = Book("Python Basics", 29.99)

# Convert to a standard Python dictionary
print(asdict(book))  # {'title': 'Python Basics', 'price': 29.99}

# Convert to a tuple
print(astuple(book)) # ('Python Basics', 29.99)
```



  
