# JavaScript One-Nighter 

Accenture's tech assessment (NQT-style / CareerHub / AMCAT-style vendor tests) for the "web" section leans on:

- **MCQs on HTML/CSS/JS fundamentals**
- **"What is the output?" JS snippets** (the classic gotcha style — coercion, hoisting, scope, `this`, async order)
- Occasional short coding task (string/array manipulation, DOM-ish logic)

Since you already think like a programmer (Python/C++), this guide skips "what is a variable" and focuses on **where JS behaves differently from what you expect**, because that's where these exams trap people.

---

## 1. Mental Model Shift (Python/C++ → JS)

|Concept|Python/C++|JavaScript|
|---|---|---|
|Typing|Static (C++) / Dynamic (Python)|Dynamic + **weakly typed** (auto coercion)|
|Equality|`==` is value equality|`==` coerces types; `===` is strict (use this by default)|
|Block scope|Yes|`let`/`const` = block scope; `var` = **function scope** (ignores blocks)|
|Null-ish|`None` / `nullptr`|Two "empty" values: `null` and `undefined`|
|Functions|First-class in Python, not in C++|Always first-class; huge use of callbacks|
|`this`|N/A (Python `self` is explicit)|Dynamic, depends on **how** a function is called|
|Concurrency|Threads (C++), GIL (Python)|**Single-threaded + event loop** (async via callback queue)|
|Arrays|list/vector, homogeneous-ish|Arrays can hold mixed types, are objects under the hood|

---

## 2. Variables: `var` vs `let` vs `const`

```js
console.log(a); // undefined (hoisted, not TDZ)
var a = 5;

console.log(b); // ReferenceError (Temporal Dead Zone)
let b = 5;
```

- `var`: function-scoped, hoisted with value `undefined`. Can be redeclared.
- `let`: block-scoped, hoisted but in **TDZ** until declaration line. Can be reassigned, not redeclared.
- `const`: block-scoped, must be initialized, **cannot be reassigned** — but if it's an object/array, its **contents can still mutate**.

```js
const arr = [1, 2];
arr.push(3);      // ✅ allowed
arr = [4, 5];      // ❌ TypeError
```

**Classic exam trap — `var` in loops:**

```js
for (var i = 0; i < 3; i++) {
  setTimeout(() => console.log(i), 0);
}
// prints: 3 3 3  (var is shared across iterations)

for (let i = 0; i < 3; i++) {
  setTimeout(() => console.log(i), 0);
}
// prints: 0 1 2  (let creates a new binding per iteration)
```

---

## 3. Data Types & `typeof`

Primitives: `string`, `number`, `boolean`, `undefined`, `null`, `symbol`, `bigint`. Everything else (arrays, functions, objects) is `object` (or `function`).

```js
typeof undefined   // "undefined"
typeof null        // "object"   ⚠️ famous JS bug, memorize this
typeof NaN         // "number"   ⚠️ NaN is a number type
typeof []          // "object"
typeof function(){}// "function"
```

**Truthy / Falsy** — only these are falsy:

```
false, 0, -0, 0n, "", null, undefined, NaN
```

Everything else (including `"0"`, `[]`, `{}`) is **truthy**. This is a favorite MCQ trap:

```js
if ([]) console.log("yes");   // "yes" — empty array is truthy!
if ("0") console.log("yes");  // "yes" — non-empty string is truthy!
```

---

## 4. Equality & Coercion (`==` vs `===`)

Always use `===` / `!==` unless you have a specific reason. But the exam WILL test `==`:

```js
0 == false        // true
0 == ''           // true
'' == false       // true
null == undefined // true
NaN == NaN        // false  (NaN never equals itself, even itself)
[1,2] == '1,2'    // true  (array coerced to string)
'5' + 3           // "53"  (string concatenation wins)
'5' - 3           // 2     (numeric coercion for - * /)
'5' * '2'         // 10
[] + []           // ""
[] + {}           // "[object Object]"
{} + []           // 0 (in statement context — quirky, less commonly tested)
```

Rule of thumb: `+` prefers string concat if either side is a string; `-`, `*`, `/` force numeric coercion.

**`??` vs `||`:**

```js
0 || 10        // 10   (0 is falsy, so || moves on)
0 ?? 10        // 0    (?? only falls through on null/undefined)
```

---

## 5. Functions

### Declaration vs Expression vs Arrow

```js
function foo() {}          // hoisted fully (can call before definition)
const bar = function() {}; // hoisted as var (undefined until assigned)
const baz = () => {};      // arrow function — NOT hoisted usably, no own `this`
```

### Arrow functions vs regular — the `this` trap

```js
const obj = {
  name: "Keshav",
  regular: function () { console.log(this.name); },
  arrow: () => { console.log(this.name); }
};
obj.regular(); // "Keshav" — `this` = obj
obj.arrow();   // undefined — arrow uses `this` from enclosing (outer) scope, not obj
```

Rule: **arrow functions don't bind their own `this`** — they inherit it lexically from where they're defined. This is a very common "explain this behavior" question.

### Default params, Rest, Spread

```js
function greet(name = "Guest") { return `Hi ${name}`; }

function sum(...nums) { return nums.reduce((a,b)=>a+b,0); } // rest — gathers args into array
sum(1,2,3); // 6

const arr1 = [1,2], arr2 = [...arr1, 3]; // spread — expands array
const obj2 = {...{a:1}, b:2};             // spread on objects too
```

---

## 6. Scope & Closures

A closure = a function that "remembers" variables from its outer scope even after that outer function has returned. This is THE most commonly asked JS concept in interviews/exams.

```js
function counter() {
  let count = 0;
  return function () {
    count++;
    return count;
  };
}
const inc = counter();
inc(); // 1
inc(); // 2  — `count` persisted between calls (closure)
```

**Loop + closure trap (already shown above with var/let) — know it cold.**

---

## 7. Arrays — Know These Methods (very high-yield for MCQs)

|Method|What it does|Mutates original?|
|---|---|---|
|`push`/`pop`|add/remove at end|Yes|
|`shift`/`unshift`|remove/add at start|Yes|
|`splice(start, count, ...items)`|remove/insert in place|Yes|
|`slice(start, end)`|extract a copy (end excluded)|No|
|`map(fn)`|transform each element → new array|No|
|`filter(fn)`|keep elements passing test → new array|No|
|`reduce(fn, initial)`|fold into single value|No|
|`forEach(fn)`|loop, no return value|No|
|`find(fn)` / `findIndex(fn)`|first match / its index|No|
|`some(fn)` / `every(fn)`|boolean check|No|
|`includes(val)`|membership check|No|
|`sort(fn)`|sorts **in place**, default is **string** sort!|Yes|
|`concat`|merge arrays|No|
|`flat(depth)`|flatten nested arrays|No|
|`Array.from(...)`|build array from iterable/array-like|No|

**Sort trap** (like Python's `sorted()` needing a key, but worse default):

```js
[10, 2, 1].sort();          // [1, 10, 2]  — default sort is lexicographic (string)!
[10, 2, 1].sort((a,b)=>a-b); // [1, 2, 10]  — always pass a comparator for numbers
```

`reduce` syntax (equivalent to Python's `functools.reduce`):

```js
[1,2,3,4].reduce((acc, cur) => acc + cur, 0); // 10
```

Destructuring (like Python tuple unpacking):

```js
const [a, b, ...rest] = [1, 2, 3, 4]; // a=1, b=2, rest=[3,4]
const { x, y = 5 } = { x: 1 };        // x=1, y=5 (default)
```

---

## 8. Strings — Common Methods

```js
"Hello".length              // 5
"Hello".toUpperCase()/toLowerCase()
"Hello".slice(1,3)           // "el"  (like Python slicing but args are start,end)
"Hello".includes("ell")      // true
"Hello".indexOf("l")         // 2
"Hello".split("")            // ['H','e','l','l','o']
"  hi  ".trim()              // "hi"
"a,b,c".split(",")           // ["a","b","c"]
["a","b"].join("-")          // "a-b"
`Value is ${1+1}`             // template literal → "Value is 2"
"5".padStart(3, "0")          // "005"
"Hello".replace("l", "L")     // "HeLlo" (first only; use /l/g for global)
```

Strings are **immutable** in JS too (like Python) — all methods return new strings.

---

## 9. Objects

```js
const person = { name: "Keshav", age: 22 };

// access
person.name;      // dot notation
person["name"];   // bracket notation (needed for dynamic keys)

// methods
Object.keys(person);    // ["name","age"]
Object.values(person);  // ["Keshav",22]
Object.entries(person); // [["name","Keshav"],["age",22]]

// optional chaining & nullish coalescing (ES2020, likely tested)
person.address?.city;        // undefined instead of throwing error
person.age ?? "unknown";     // 22 (only falls back on null/undefined)

// shorthand
const name = "Keshav";
const obj = { name };  // same as { name: name }

// spread/merge
const merged = { ...person, city: "Ludhiana" };
```

---

## 10. Loops

```js
for (let i = 0; i < arr.length; i++) {}  // classic
for (const item of arr) {}               // values — use for ARRAYS
for (const key in obj) {}                // keys   — use for OBJECTS (avoid for arrays)
arr.forEach((item, index) => {});        // functional style
```

`for...of` = values (arrays, strings, maps, sets — anything iterable). `for...in` = keys/indices (objects, and arrays but NOT recommended — includes inherited/enumerable props).

---

## 11. Async JS — Callbacks, Promises, async/await (HIGH YIELD)

### The core idea: JS is single-threaded, uses an **event loop**

- **Call stack** runs sync code first, always.
- **Microtask queue** (Promises, `async/await`) runs next, before rendering/next macrotask.
- **Macrotask queue** (`setTimeout`, `setInterval`, I/O) runs last.

**The #1 "predict the output" question type:**

```js
console.log("1");
setTimeout(() => console.log("2"), 0);
Promise.resolve().then(() => console.log("3"));
console.log("4");

// Output: 1  4  3  2
// sync code first (1,4) → microtasks (Promise: 3) → macrotasks (setTimeout: 2)
```

**Memorize this order: sync → microtasks (Promises) → macrotasks (setTimeout/setInterval).**

### Promises

```js
const p = new Promise((resolve, reject) => {
  // do work
  resolve("done");   // or reject("error")
});

p.then(result => console.log(result))
 .catch(err => console.log(err))
 .finally(() => console.log("always runs"));

Promise.all([p1, p2]);   // waits for all, fails fast if any rejects
Promise.race([p1, p2]);  // resolves/rejects as soon as first settles
Promise.allSettled([p1, p2]); // waits for all, never short-circuits
```

### async/await (syntactic sugar over Promises)

```js
async function getData() {
  try {
    const res = await fetch("url");   // pauses here, doesn't block thread
    const data = await res.json();
    return data;
  } catch (err) {
    console.log(err);
  }
}
```

- `async` function always returns a **Promise**.
- `await` only works inside `async` functions (or top-level modules).
- Errors from `await` are caught with normal `try/catch`.

---

## 12. `this` Keyword — Rules Summary

1. Inside a regular function called as `obj.method()` → `this` = `obj`.
2. Inside a regular function called standalone → `this` = `undefined` (strict mode) or global object.
3. Arrow functions → `this` = whatever `this` was in the **enclosing lexical scope**.
4. `call`, `apply`, `bind` let you explicitly set `this`:

```js
function greet() { console.log(this.name); }
const p = { name: "Keshav" };
greet.call(p);   // "Keshav" — call: invoke immediately, args individually
greet.apply(p);  // same, but args as an array
const bound = greet.bind(p); // returns new function, doesn't invoke yet
bound();          // "Keshav"
```

---

## 13. Classes (OOP in JS — similar shape to C++/Python, different guts)

```js
class Animal {
  constructor(name) { this.name = name; }
  speak() { return `${this.name} makes a sound`; }
  static create(name) { return new Animal(name); } // static method
}

class Dog extends Animal {
  speak() { return `${super.speak()}, specifically a bark`; }
}

const d = new Dog("Rex");
d.speak();
```

- Under the hood, JS still uses **prototype-based inheritance** — classes are sugar over prototypes.
- `instanceof` checks the prototype chain: `d instanceof Animal` → `true`.

---

## 14. Hoisting Summary Table

|Declared as|Hoisted?|Usable before declaration?|
|---|---|---|
|`var x`|Yes, initialized `undefined`|Yes (value is `undefined`)|
|`let x` / `const x`|Yes, but in TDZ|No — `ReferenceError`|
|`function foo(){}`|Fully hoisted (incl. body)|Yes|
|`const foo = function(){}`|Only the `var`-like binding|No — `TypeError: not a function`|

---

## 15. DOM Basics (in case web section includes DOM/event Qs)

```js
document.getElementById("id");
document.querySelector(".class");       // first match
document.querySelectorAll("div");        // NodeList of all matches

el.addEventListener("click", function (e) {
  console.log(e.target); // element that triggered event
});

el.innerHTML = "<b>text</b>";  // sets HTML
el.textContent = "text";        // sets plain text (safer, no HTML parsing)
el.style.color = "red";
el.classList.add("active");
el.classList.toggle("hidden");

// event bubbling: events propagate from target up to ancestors by default
e.stopPropagation();  // stop bubbling
e.preventDefault();   // stop default browser action (e.g. form submit, link navigation)
```

---

## 16. JSON

```js
JSON.stringify({a:1});   // '{"a":1}'  — object → string
JSON.parse('{"a":1}');   // {a:1}      — string → object
```

---

## 17. Error Handling

```js
try {
  throw new Error("custom error");
} catch (err) {
  console.log(err.message);
} finally {
  console.log("always runs");
}
```

---

## 18. Rapid-Fire "Predict the Output" Drills (do these out loud)

```js
console.log(typeof typeof 1);          // "string" (typeof 1 → "number", typeof "number" → "string")
console.log([1,2,3] + [4,5,6]);        // "1,2,34,5,6" (both arrays → strings, concatenated)
console.log(1 < 2 < 3);                // true  → (1<2)=true→1, 1<3=true
console.log(3 > 2 > 1);                // false → (3>2)=true→1, 1>1=false
console.log("5" + 2 + 3);              // "523" (left to right, string wins once triggered)
console.log(5 + 2 + "3");              // "73"  (number math happens first, then concat)
console.log([] == ![]);                // true  (![] is false; [] == false → "" == false → true)
console.log(typeof NaN);               // "number"
console.log(0.1 + 0.2 === 0.3);        // false (floating point precision, same as most languages)
console.log([1,2,3].length = 1, [1,2,3]); // careful: length is settable, truncates array
```

---

## 19. Last-Minute Checklist

- [ ] `==` vs `===` and coercion rules
- [ ] `var` vs `let`/`const` scoping + hoisting + TDZ
- [ ] Truthy/falsy list memorized
- [ ] Closures — write one from scratch
- [ ] Arrow function `this` vs regular function `this`
- [ ] Array methods: map/filter/reduce/forEach differences
- [ ] `sort()` default behavior (string-based) trap
- [ ] Event loop order: sync → microtask (Promise) → macrotask (setTimeout)
- [ ] Promise chaining + async/await + try/catch
- [ ] Destructuring & spread/rest syntax
- [ ] `typeof null` is `"object"`, `typeof NaN` is `"number"`
- [ ] Optional chaining `?.` and nullish coalescing `??`

Good luck for the exam.