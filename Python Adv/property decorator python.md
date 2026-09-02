The `@property` decorator in Python allows you to define methods in a class that can be accessed like attributes (without calling them with parentheses `()`).

  

It provides a clean, Pythonic way to implement **getters, setters, and deleters** without breaking the public interface of a class.

  

### Basic Usage: Read-Only Property (Getter)

The most common use of `@property` is to create computed or read-only attributes.

  

Python

```
class Circle:
    def __init__(self, radius: float):
        self.radius = radius

    @property
    def area(self) -> float:
        """Computed dynamically each time it is accessed."""
        return 3.14159 * (self.radius ** 2)

c = Circle(5)

# Accessed like an attribute, NOT c.area()
print(c.area)  # Output: 78.53975

# Trying to set it directly will raise an AttributeError:
# c.area = 100  # AttributeError: property 'area' of 'Circle' object has no setter
```

### Getters, Setters, and Deleters

To allow setting and deleting an attribute with validation or transformation logic, use the companion `.setter` and `.deleter` decorators.

  

Python

```
class Employee:
    def __init__(self, name: str, salary: float):
        self.name = name
        self.salary = salary  # Automatically triggers the @salary.setter

    # 1. Getter
    @property
    def salary(self) -> float:
        return self._salary

    # 2. Setter
    @salary.setter
    def salary(self, value: float) -> None:
        if value < 0:
            raise ValueError("Salary cannot be negative.")
        self._salary = float(value)

    # 3. Deleter
    @salary.deleter
    def salary(self) -> None:
        print("Resetting salary...")
        del self._salary


# Usage
emp = Employee("Alice", 75000)

print(emp.salary)    # Calls the getter -> 75000.0

emp.salary = 82000   # Calls the setter
print(emp.salary)    # 82000.0

# Validation in action
try:
    emp.salary = -5000
except ValueError as e:
    print(e)         # Output: Salary cannot be negative.

del emp.salary       # Calls the deleter -> "Resetting salary..."
```

_Note: The getter, setter, and deleter methods **must share the exact same method name**._

  

### Why Use `@property`?

- **Encapsulation & Validation:** Check constraints (e.g., non-negative numbers, string types) without exposing raw internals like `_salary`.
    
      
    
- **Backward Compatibility:** Start with simple public attributes (`obj.salary`). If you later need validation, convert it to a `@property` without breaking existing code that accesses `obj.salary`.
    
      
    
- **Computed Attributes:** Derive values on the fly (e.g., full name from first and last name) while keeping attribute-style access.
    
      
    
- **Refactoring Friendly:** Avoid writing explicit Java-style methods like `get_salary()` and `set_salary()`.
    
      
    

### Bonus: Cached Properties (`functools.cached_property`)

If calculating a property is computationally expensive (e.g., querying a database or parsing a heavy file) and the value doesn't change frequently, standard library `functools` provides `cached_property`:

Python

```
from functools import cached_property
import time

class HeavyDataset:
    def __init__(self, data):
        self._data = data

    @cached_property
    def processed_data(self):
        time.sleep(2)  # Simulating an expensive operation
        return [x ** 2 for x in self._data]

ds = HeavyDataset([1, 2, 3, 4, 5])
print(ds.processed_data)  # Takes 2 seconds, caches result
print(ds.processed_data)  # Instant lookup from cache
```