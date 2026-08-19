# Python Exam Prep — Core Topics + Related Areas

---

## 1. Object Model & Magic (Dunder) Methods

### `__repr__` vs `__str__`
- `__repr__`: unambiguous, developer-facing. Goal: `eval(repr(obj))` should ideally recreate the object.
- `__str__`: readable, user-facing. Falls back to `__repr__` if not defined.
- `repr()` is called implicitly inside containers (e.g., printing a list of objects calls `repr()` on each element, not `str()`).

```python
class Point:
    def __init__(self, x, y): self.x, self.y = x, y
    def __repr__(self): return f"Point({self.x}, {self.y})"

p = Point(1, 2)
print(p)          # calls __str__ -> falls back to __repr__ -> Point(1, 2)
print([p])        # always uses __repr__ -> [Point(1, 2)]
```

**Watch for:** default `object.__repr__` output (`<__main__.Point object at 0x...>`) when neither is defined.

### `getattr` / `setattr` / `hasattr` / `__getattr__` / `__getattribute__`
- `getattr(obj, name, default)` — dynamic attribute lookup; avoids `AttributeError` if default given.
- `hasattr(obj, name)` — internally just tries `getattr` and catches exceptions.
- `__getattr__(self, name)` — called **only** when normal lookup fails (attribute not found).
- `__getattribute__(self, name)` — called for **every** attribute access (rarely overridden; easy to cause infinite recursion).

```python
class Config:
    def __getattr__(self, name):
        return f"default_{name}"

c = Config()
print(c.timeout)          # 'default_timeout' — normal lookup failed, __getattr__ kicks in
print(getattr(c, 'x', 'fallback'))  # 'default_x' (never hits fallback since __getattr__ always succeeds)
```

### Multiple Inheritance, MRO, the Diamond Problem
- Python uses **C3 linearization** to compute Method Resolution Order (`ClassName.__mro__` or `.mro()`).
- Diamond: `D(B, C)`, `B(A)`, `C(A)` — resolution order is `D -> B -> C -> A -> object`, **not** naive depth-first.
- `super()` follows the MRO chain, not necessarily the immediate parent — this is what lets cooperative multiple inheritance work.

```python
class A:
    def who(self): print("A")
class B(A):
    def who(self): print("B"); super().who()
class C(A):
    def who(self): print("C"); super().who()
class D(B, C):
    def who(self): print("D"); super().who()

D().who()
# D B C A  <- NOT D B A C A (naive depth-first would double-call A)
print(D.__mro__)  # (D, B, C, A, object)
```

**Common trap:** predicting output without knowing C3 — always trace via `__mro__`, don't assume left-to-right depth-first.

### Related: Descriptors & `property`
- `@property` is a descriptor under the hood (`__get__`, `__set__`, `__delete__`).
- Useful to know: difference between instance `__dict__` lookup and descriptor lookup priority (data descriptors override instance `__dict__`).

---

## 2. Scoping, Closures & Mutability

### Identity vs Equality
- `is` compares object identity (memory address); `==` compares value (via `__eq__`).
- Small int caching (-5 to 256) and interned strings can make `is` "accidentally" True for immutables — don't rely on it.

### In-place Mutation vs Rebinding
```python
x = [1, 2, 3]
y = x
x[:] = [4, 5, 6]   # slice assignment -> mutates the SAME object in place
print(x is y)      # True
print(y)           # [4, 5, 6]  — y sees the change too, same object

x = [4, 5, 6]
x = [7, 8, 9]      # this REBINDS x to a new object
print(x is y)      # False now
```
**Key distinction:** `x[:] = ...`, `x.append()`, `x.extend()` mutate in place. `x = ...` rebinds the name to a new object entirely. This is the #1 source of "wait, why did the other variable change too?" confusion.

### Late-Binding Closures (classic loop bug)
```python
def make_adders():
    return [lambda x, i=i: x + i for i in range(3)]

adders = make_adders()
print([f(10) for f in adders])   # [10, 11, 12] — correct, because of i=i

# WITHOUT the i=i trick:
def make_adders_buggy():
    return [lambda x: x + i for i in range(3)]
adders2 = make_adders_buggy()
print([f(10) for f in adders2])  # [12, 12, 12] — all closures share the SAME final i
```
- Closures capture **variables by reference**, not by value, at call time — not at definition time.
- `i=i` works because default argument values ARE evaluated once, at function-definition time (this is also the classic **mutable default argument** gotcha in a different guise).

### Related: Mutable Default Arguments
```python
def f(item, bucket=[]):   # DANGER: bucket is created ONCE, shared across all calls
    bucket.append(item)
    return bucket

f(1)  # [1]
f(2)  # [1, 2]  <- surprise, not [2]
```
Fix: use `bucket=None` and `bucket = bucket or []` inside.

### LEGB Scoping Rule
Local → Enclosing → Global → Built-in. Know `global` and `nonlocal` keywords and when each is required to *assign* to an outer-scope variable (not needed for reading).

---

## 3. Concurrency: Threading, the GIL, and Asyncio

### Basic Threading
```python
import threading

def worker(i):
    print(f"worker {i}")

threads = [threading.Thread(target=worker, args=(i,)) for i in range(4)]
for t in threads: t.start()
for t in threads: t.join()   # wait for all to finish
```
- `args` must be a **tuple** — `args=(i,)` not `args=(i)` (the latter is just `i` in parens, not a tuple).
- Forgetting `.join()` means the main thread may exit before workers finish.

### The GIL (Global Interpreter Lock) & Thread Safety
- CPython's GIL ensures only one thread executes Python bytecode at a time.
- **Single atomic bytecode operations** (like `list.append()`, `dict[key] = value`, `list.pop()`) are effectively thread-safe because they can't be interrupted mid-operation.
- **Compound operations** (read-modify-write, e.g., `x += 1`, `if key not in d: d[key] = 0`) are **NOT** thread-safe — they involve multiple bytecode steps and can be interleaved between threads, causing race conditions.
- GIL means threading doesn't give true CPU parallelism for CPU-bound work in pure Python — it's useful for I/O-bound work (network calls, file I/O) where threads release the GIL while waiting.
- For CPU-bound parallelism, use `multiprocessing` (separate processes, separate GILs) instead.

```python
counter = 0
def increment():
    global counter
    for _ in range(100000):
        counter += 1     # NOT atomic (read, add, write) -> race condition with multiple threads
```
Use `threading.Lock()` to protect compound operations:
```python
lock = threading.Lock()
def safe_increment():
    global counter
    with lock:
        counter += 1
```

### Asyncio
```python
import asyncio

async def task(n):
    await asyncio.sleep(1)
    return n * 2

async def main():
    coros = [task(i) for i in range(4)]
    results = await asyncio.gather(*coros)
    print(results)

asyncio.run(main())
```
Key points:
- `async def` defines a coroutine; calling it doesn't run it — it returns a coroutine object that must be `await`ed or scheduled.
- `asyncio.sleep()` is **non-blocking** — it yields control back to the event loop so other coroutines can run. This is fundamentally different from `time.sleep()`, which blocks the whole thread.
- `asyncio.gather(*coros)` runs coroutines **concurrently** (interleaved on one thread via the event loop) — total time ≈ time of the *slowest* one, not the sum (unlike sequential `await`ing each one in a loop).
- `asyncio.run(main())` is the standard entry point — creates an event loop, runs `main()`, closes the loop.
- Common typos to watch for on the exam itself: `asyncio.sleep`, `asyncio.gather`, `asyncio.run` (not `async.sleep`/`async.gather`/`async.io`).

### Threading vs Asyncio vs Multiprocessing (likely comparison question)
| Model | Parallelism | Best for | Concern |
|---|---|---|---|
| `threading` | Concurrent (GIL-limited) | I/O-bound | Race conditions on compound ops |
| `asyncio` | Concurrent, single-threaded | I/O-bound, many small tasks | Must be `await`-aware everywhere; one blocking call stalls everything |
| `multiprocessing` | True parallel (separate GILs) | CPU-bound | Higher memory/IPC overhead |

---

## 4. Introspection & Metaprogramming

### `sys._getframe()` and Frame Objects
- `sys._getframe(depth)` returns a frame object from the call stack (0 = current frame, 1 = caller, etc.). Considered a CPython implementation detail — prefer the `inspect` module in production code, but exams may still test raw usage.
- Frame attributes: `f_locals` (dict of local variables in that frame), `f_globals`, `f_back` (the calling frame), `f_code`.

```python
import sys

def inner():
    x = 42
    frame = sys._getframe(0)
    print(frame.f_locals.get('x'))   # 42

def outer():
    y = "hello"
    frame = sys._getframe(1)  # caller's frame, relative to wherever this executes
    ...
inner()
```
- `.f_locals.get('name')` is a safe way to introspect variables without raising `KeyError`/`NameError` if absent.

### The `inspect` Module (likely related exam topic)
- `inspect.currentframe()` — safer, more portable equivalent to `sys._getframe(0)`.
- `inspect.stack()` — full call stack as a list of frame records.
- `inspect.signature(func)` — introspect a function's parameters (used heavily in decorators/frameworks).

### Why This Matters (conceptual, likely to be asked)
Frame/attribute introspection underlies: debuggers, logging libraries (getting caller's line number), ORMs and dependency-injection frameworks (inspecting function signatures), and dynamic attribute proxies (`__getattr__`-based lazy loading, mocking).

---

## 5. Other Likely-Related Topics (not in your snippets, but same exam "family")

Given the mix above (object model, closures, concurrency, introspection), these commonly round out the same syllabus:

- **Iterators & Generators**: `__iter__`/`__next__` protocol, `yield` vs `return`, generator exhaustion (can only iterate once), `yield from`.
- **Decorators**: function wrapping, `functools.wraps` (preserves `__name__`/`__doc__`), decorators with arguments (three levels of nested functions).
- **Context Managers**: `__enter__`/`__exit__`, `with` statement, `contextlib.contextmanager`.
- **`*args` / `**kwargs`**: argument unpacking/packing, positional-only (`/`) and keyword-only (`*`) parameter syntax (PEP 570).
- **Exception Handling nuances**: `else` and `finally` clauses on `try`, exception chaining (`raise ... from ...`), custom exception classes.
- **Shallow vs Deep Copy**: `copy.copy()` vs `copy.deepcopy()` — relevant given the mutability question above.
- **Comprehension scoping**: list/dict/set comprehensions have their **own scope** in Python 3 (unlike loop variables in a plain `for` loop, which leak into enclosing scope).

```python
[i for i in range(5)]
print(i)  # NameError in Py3 — comprehension variable doesn't leak

for i in range(5): pass
print(i)  # 4 — regular for-loop variable DOES leak
```

---

## 6. Advanced / "Gotcha-Prone" Topics

### `__slots__`
Restricts instance attributes to a fixed set, removes per-instance `__dict__`, saves memory, and **prevents adding new attributes dynamically**.
```python
class P:
    __slots__ = ('x', 'y')

p = P()
p.x = 1
p.z = 5   # AttributeError — 'z' not in __slots__
```
Trap: if a subclass doesn't also define `__slots__`, it gets a `__dict__` back anyway (defeats the purpose).

### Metaclasses
- `type` is the metaclass of all classes by default. `class Foo(metaclass=Meta)` lets `Meta.__new__`/`__init__` control class *creation itself* (not instance creation).
- Order of calls: `Meta.__new__` → `Meta.__init__` → then normal `Class.__new__` → `Class.__init__` for instances.
- Exam favorite: distinguishing `__new__` (creates/returns the object, can return a different type) vs `__init__` (initializes an already-created object, must return `None`).

### Operator Overloading Edge Cases
- `__eq__` without `__hash__` → object becomes **unhashable** (Python sets `__hash__ = None` automatically when you define `__eq__` but not `__hash__`).
- `__radd__` triggers when the left operand's `__add__` returns `NotImplemented` (e.g., `5 + custom_obj` triggers `custom_obj.__radd__(5)`).
- `__eq__` returning `NotImplemented` (not `False`) lets Python try the reflected comparison on the other operand.

### String Interning & Small Int Caching (classic "why is `is` True/False" trap)
```python
a = "hello"
b = "hello"
print(a is b)          # True — interned literal

a = "hello world!"
b = "hello world!"
print(a is b)           # Often False — strings with spaces/complex chars aren't auto-interned

x = 256
y = 256
print(x is y)           # True — small int cache (-5 to 256)

x = 257
y = 257
print(x is y)           # False (in a script) — outside the cache range
```

### Float Precision
```python
print(0.1 + 0.2 == 0.3)      # False — binary floating point representation
print(0.1 + 0.2)              # 0.30000000000000004
```

### Short-Circuit Evaluation with Side Effects
```python
def a(): print("a"); return False
def b(): print("b"); return True

a() and b()   # prints only "a" — b() never called
a() or b()    # prints "a" then "b" — or needs to evaluate b since a() is False
```

### Chained Comparisons
```python
print(1 < 2 < 3)      # True  — equivalent to (1<2) and (2<3)
print(1 < 3 > 2)      # True  — chained comparisons aren't just left-to-right binary ops
print(False == 0)     # True  — bool is a subclass of int
print(True + True)    # 2     — booleans behave as ints in arithmetic
```

### Walrus Operator (`:=`) Scope
```python
data = [y := 5, y**2, y**3]
print(data)   # [5, 25, 125]
print(y)      # 5 — leaks into enclosing scope (unlike comprehension loop vars)
```

### Class Attribute vs Instance Attribute (mutable class-level default trap)
```python
class Bag:
    items = []              # CLASS attribute — shared across ALL instances!
    def add(self, x):
        self.items.append(x)

b1, b2 = Bag(), Bag()
b1.add(1)
print(b2.items)   # [1] — surprise, b2 sees b1's item because items is shared
```

### Generators: `send()`, exhaustion, and `yield from`
```python
def gen():
    x = yield 1
    print("received:", x)
    yield x + 1

g = gen()
print(next(g))      # 1  (runs to first yield)
print(g.send(10))   # prints "received: 10", then yields 11

# Exhaustion:
it = iter([1, 2])
list(it); list(it)   # second call -> [] , generators/iterators are single-use
```

### Decorator Stacking Order
```python
def upper(f):
    def wrap(): return f().upper()
    return wrap

def excite(f):
    def wrap(): return f() + "!"
    return wrap

@upper
@excite
def greet(): return "hello"

print(greet())   # "HELLO!" — decorators apply bottom-up, but the outer one wraps LAST-applied result
```
(`excite` applied first → `"hello!"`, then `upper` applied → `"HELLO!"`)

---

## 7. "Predict the Output" Drill — Mixed & Malicious

Try each one *before* reading the answer.

**Q1.**
```python
def f(a, b=[]):
    b.append(a)
    return b

print(f(1))
print(f(2))
```
<details><summary>Answer</summary>[1]<br>[1, 2] — mutable default argument shared across calls</details>

**Q2.**
```python
x = [1, 2, 3]
def modify(lst):
    lst = lst + [4]
modify(x)
print(x)
```
<details><summary>Answer</summary>[1, 2, 3] — `lst + [4]` creates a NEW list and rebinds the local name `lst`; doesn't affect caller's `x`</details>

**Q3.**
```python
class A:
    def __init__(self): self.x = 1
class B(A):
    def __init__(self): self.y = 2

b = B()
print(hasattr(b, 'x'))
```
<details><summary>Answer</summary>False — B's `__init__` doesn't call `super().__init__()`, so A's `__init__` never runs</details>

**Q4.**
```python
print([x for x in range(3)] == [x for x in range(3)])
print([x for x in range(3)] is [x for x in range(3)])
```
<details><summary>Answer</summary>True (equal values)<br>False (different objects — is checks identity)</details>

**Q5.**
```python
funcs = []
for i in range(3):
    def f():
        return i
    funcs.append(f)
print([f() for f in funcs])
```
<details><summary>Answer</summary>[2, 2, 2] — late binding, all closures reference the same final `i` (loop var leaks in Python)</details>

**Q6.**
```python
try:
    print("A")
    raise ValueError("bad")
except ValueError:
    print("B")
else:
    print("C")
finally:
    print("D")
```
<details><summary>Answer</summary>A<br>B<br>D — `else` only runs if NO exception occurred; `finally` always runs</details>

**Q7.**
```python
print(bool("False"))
print(bool([]))
print(bool([0]))
print("0" == 0)
```
<details><summary>Answer</summary>True (non-empty string is truthy, regardless of content)<br>False (empty list)<br>True (non-empty list, even holding falsy 0)<br>False (different types, no implicit conversion)</details>

**Q8.**
```python
a = (1, [2, 3])
a[1].append(4)
print(a)
```
<details><summary>Answer</summary>(1, [2, 3, 4]) — tuple itself is immutable, but the LIST inside it is still mutable</details>

**Q9.**
```python
class Meta(type):
    def __new__(cls, name, bases, dct):
        dct['greeting'] = 'hi'
        return super().__new__(cls, name, bases, dct)

class Foo(metaclass=Meta):
    pass

print(Foo.greeting)
print(Foo().greeting)
```
<details><summary>Answer</summary>hi<br>hi — metaclass injects a class attribute at class-creation time, inherited by all instances</details>

**Q10.**
```python
import threading
counter = 0
def inc():
    global counter
    for _ in range(1_000_000):
        counter += 1

threads = [threading.Thread(target=inc) for _ in range(2)]
for t in threads: t.start()
for t in threads: t.join()
print(counter)
```
<details><summary>Answer</summary>Some number LESS than 2,000,000 (non-deterministic, varies per run) — `counter += 1` is not atomic (read-modify-write across 3 bytecode ops), so threads interleave and lose increments despite the GIL</details>

**Q11.**
```python
async def f():
    return 1

print(f())
```
<details><summary>Answer</summary>&lt;coroutine object f at 0x...&gt; and a RuntimeWarning about the coroutine never being awaited — calling an async function does NOT run it, it just creates a coroutine object</details>

**Q12.**
```python
x = 10
def outer():
    x = 20
    def inner():
        nonlocal x
        x = 30
    inner()
    print(x)
outer()
print(x)
```
<details><summary>Answer</summary>30 (inner's nonlocal reassigns outer's x)<br>10 (global x is untouched — nonlocal only reaches the nearest enclosing function scope, not global)</details>

**Q13.**
```python
class A:
    def __eq__(self, other):
        return True

s = {A(), A()}
print(len(s))
```
<details><summary>Answer</summary>2, NOT 1 — defining `__eq__` without `__hash__` sets `__hash__` to `None` implicitly... but wait: this actually raises `TypeError: unhashable type` when put in a set. (Trick question — the "obvious" answer of 1 is wrong AND the naive "no change" answer is also wrong; it errors.)</details>

**Q14.**
```python
print(id([]) == id([]))
a = []
b = []
print(id(a) == id(b))
```
<details><summary>Answer</summary>Can be True — CPython may reuse the same memory address for the first temporary list since it's garbage-collected immediately after `id()` returns (classic id-reuse trap; NOT guaranteed by language spec, just CPython implementation detail)<br>False — a and b are both alive simultaneously, so must have distinct addresses</details>

**Q15.**
```python
def gen():
    for i in range(3):
        yield i

g = gen()
print(sum(g))
print(sum(g))
```
<details><summary>Answer</summary>3 (0+1+2)<br>0 — generator is exhausted after first full consumption, second `sum()` sees nothing</details>

---

## Quick Self-Test Checklist
- [ ] Can you trace MRO output for a diamond inheritance class hierarchy by hand?
- [ ] Can you explain why `x[:] = [...]` differs from `x = [...]` in terms of identity?
- [ ] Can you fix a late-binding closure bug two different ways?
- [ ] Can you name which built-in list/dict ops are atomic under the GIL and which aren't?
- [ ] Can you explain why `asyncio.sleep()` ≠ `time.sleep()` inside a coroutine?
- [ ] Can you write `sys._getframe().f_locals.get(...)` and explain what frame it targets?
- [ ] Can you explain `__getattr__` vs `__getattribute__` trigger conditions?
