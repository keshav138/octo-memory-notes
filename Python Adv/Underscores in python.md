In Python, the meaning of one underscore (`_`) or two underscores (`__`) depends entirely on where you put them.

Here is the quick breakdown of what they mean based on their placement:

## 1. Single Underscore (`_`)

- Single Leading Underscore (`_variable`): A hint to other programmers that a variable or method is intended for internal use (similar to "private" in other languages). It is not strictly enforced by the interpreter, but if you use `from module import *`, Python will not import names starting with a single underscore. [1, 2, 3]
- Standalone Underscore (`_`): Used as a temporary or throwaway variable name. Use this when you need a variable for syntax reasons (like in a loop or unpacking), but you don't actually care about its value (e.g., `for _ in range(5):`). [1, 4, 5]
- Single Trailing Underscore (`variable_`): Used by convention to avoid naming conflicts with Python keywords. For example, if you want a variable named `class`, you should name it `class_` instead. [1, 6]
- Inside numbers (`1_000_000`): Acts as a visual separator to make large numbers easier to read. Python ignores it completely. [4, 7]

## 2. Double Underscore (`__`)

- Double Leading Underscore (`__variable`): Tells the Python interpreter to rewrite the attribute name inside a class to avoid naming conflicts in subclasses. This behavior is called name mangling. For example, inside a class named `Dog`, `__secret` automatically becomes `_Dog__secret`, making it harder to accidentally override. [1, 3, 4, 8]
- Double Leading and Trailing Underscore (`__variable__`): Reserved for special built-in features in Python, commonly called "dunder" methods (Double UNDERscore). Examples include `__init__` for constructors or `__str__` to change how an object prints. You should never invent your own names using this format. [1, 9, 10, 11]

---

|Syntax|Common Term / Name|Main Purpose|Enforced by Python?|
|---|---|---|---|
|`_var`|Leading underscore|Signals a variable is for internal/private use.|No (just a convention).|
|`_`|Standalone underscore|Represents an unused or throwaway variable.|No.|
|`var_`|Trailing underscore|Prevents conflicts with Python keywords (e.g., `list_`).|No.|
|`__var`|Leading dunder|Triggers name mangling to protect subclass variables.|Yes (the name changes).|
|`__var__`|Dunder methods|System-defined methods (e.g., `__init__`, `__len__`).|Yes (core language features).|
