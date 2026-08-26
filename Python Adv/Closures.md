

Closures in Python are one of those concepts that seem mysterious at first glance but are actually quite elegant once you understand how they work. They’re a powerful feature that lets functions “remember” the environment in which they were created — even after that environment is gone.

If you’ve ever used decorators, callback functions, or event handlers in Python, you’ve already benefited from closures, whether you realized it or not. In this article, we’ll go beyond the simple definitions and dive into the how and why of closures, exploring their mechanics and real-world applications.

## Functions as First-Class Citizens

Python treats functions as first-class objects. That means you can assign them to variables, pass them as arguments to other functions, and return them from functions.

Example:

def greet(name):  
    return f"Hello, {name}"

say_hello = greet  
print(say_hello("Alice"))

Output:

Hello, Alice

Here, `say_hello` and `greet` refer to the same function. But this concept becomes far more powerful when we start returning functions from other functions.

## Returning Functions (Function Factories)

Let’s define a function that returns another function.

def make_multiplier(n):  
    def multiplier(x):  
        return x * n  
    return multiplier

times_two = make_multiplier(2)  
times_three = make_multiplier(3)print(times_two(5))  
print(times_three(5))

Output:

10  
15

The outer function `make_multiplier` creates and returns a function `multiplier`. When we call `make_multiplier(2)`, it returns a new function that multiplies its input by 2. But here’s the interesting part: even after `make_multiplier` has finished running, the returned function `multiplier` still “remembers” the value of `n`.

That’s a **closure**.

## What Exactly Is a Closure?

A closure is a function that retains access to variables from its enclosing scope, even if that scope has finished executing.

When Python defines a nested function, it attaches the variables from the outer function’s environment that are referenced inside the inner function. These variables are preserved as part of the closure object.

Let’s inspect one.

def outer():  
    msg = "Python Closures"  
    def inner():  
        print(msg)  
    return inner

func = outer()  
func()

Output:

Python Closures

Although `outer()` has already returned, the `msg` variable still exists inside `func`. You can check this explicitly.

print(func.__closure__)  
print(func.__closure__[0].cell_contents)

Output:

(<cell at 0x000001: str object at 0x000002>,)  
Python Closures

The `__closure__` attribute stores references to variables captured from the outer scope.

## Why Closures Matter

Closures are incredibly useful for preserving state without relying on global variables or classes. They’re a neat way to create function factories, callbacks, and decorators that remember their configuration.

[](https://medium.com/write?source=promotion_paragraph---post_body_banner_better_place_scribble--ccb5979040e0---------------------------------------)

Here’s an example of a simple stateful closure.

def counter():  
    count = 0  
    def increment():  
        nonlocal count  
        count += 1  
        return count  
    return increment

count_func = counter()  
print(count_func())  
print(count_func())  
print(count_func())

Output:

1  
2  
3

Each time `count_func()` is called, it remembers its internal `count` variable — something you can’t achieve easily with plain functions unless you use globals or classes.

## Closures vs. Classes

Closures and classes can often achieve similar things. Both can encapsulate data and behavior. Here’s a comparison using the same counter example.

Using a closure:

def counter():  
    count = 0  
    def increment():  
        nonlocal count  
        count += 1  
        return count  
    return increment

Using a class:

class Counter:  
    def __init__(self):  
        self.count = 0  
    def increment(self):  
        self.count += 1  
        return self.count

Both approaches let you maintain state across calls. Closures are lighter and more functional, while classes are more explicit and scalable for complex systems.

## Closures in Decorators

Closures are the foundation of Python decorators. A decorator wraps a function, adding functionality before or after it runs — and it uses closures to remember the original function.

def logger(func):  
    def wrapper(*args, **kwargs):  
        print(f"Calling {func.__name__} with arguments {args}")  
        result = func(*args, **kwargs)  
        print(f"{func.__name__} returned {result}")  
        return result  
    return wrapper

@logger  
def add(a, b):  
    return a + badd(5, 3)

Output:

Calling add with arguments (5, 3)  
add returned 8

Here, the `wrapper` function is a closure — it remembers `func`, even though `logger()` has already finished executing.

## Closures with Function Configuration

Closures allow you to configure behavior dynamically without rewriting code. Let’s create a customizable logging decorator using closures.

def log_message(prefix):  
    def decorator(func):  
        def wrapper(*args, **kwargs):  
            print(f"{prefix}: Calling {func.__name__}")  
            return func(*args, **kwargs)  
        return wrapper  
    return decorator

@log_message("INFO")  
def greet(name):  
    print(f"Hello, {name}!")greet("Alice")

Output:

INFO: Calling greet  
Hello, Alice!

Each decorated function remembers the prefix that was passed when the decorator was created — a perfect example of closure power.

## When to Use Closures

Closures are excellent for cases where you need to maintain small amounts of state, build function factories, or encapsulate configuration. They shine in functional programming styles and lightweight designs where classes would feel heavy-handed.

However, for more complex state management or when you need inheritance or multiple methods, classes offer better readability and maintainability.

## Conclusion

Closures make Python’s functions more powerful and expressive. They allow functions to retain context, carry data, and dynamically adapt behavior.

Once you start using closures, you’ll realize they’re not just an academic concept — they’re a practical way to write more concise, expressive, and functional code.

Understanding closures opens the door to decorators, function factories, and advanced functional patterns that make Python truly elegant.