## DOM — Deeper Dive (Debug + Write From Scratch)

The DOM (Document Object Model) is the browser's live tree representation of your HTML. JS scripts read/manipulate this tree — that's literally what "DOM manipulation" means. For debug/write tasks, you need three skills: **select**, **modify**, **react to events**. Bugs in these exams usually hide in one of a handful of classic traps — I've flagged them.

### 1. Selecting Elements

```js
document.getElementById("myId");          // single element, no dot/# prefix needed
document.querySelector(".myClass");        // first match, CSS selector syntax
document.querySelectorAll("li");           // ALL matches → NodeList
document.getElementsByClassName("x");      // HTMLCollection (older, avoid unless asked)
document.getElementsByTagName("div");      // HTMLCollection
```

**Trap #1 — `querySelector` returns `null` if nothing matches.**

```js
const btn = document.querySelector(".submit");
btn.addEventListener("click", fn);   // ❌ TypeError if .submit doesn't exist yet
```

If a debug question crashes with `Cannot read properties of null`, this is almost always why — either a typo in the selector, or the script ran **before** the element existed in the DOM (see Trap #4).

**Trap #2 — `querySelectorAll`/`getElementsByClassName` don't have array methods directly.**

```js
document.querySelectorAll("li").map(...)   // ❌ TypeError, NodeList has no .map
[...document.querySelectorAll("li")].map(...)  // ✅ spread to array first
Array.from(document.querySelectorAll("li")).map(...) // ✅ alternative
```

NodeList _does_ have `.forEach` (modern browsers), but not `map`/`filter`/`reduce`.

**Trap #3 — Live vs static collections.**  
`getElementsByClassName`/`getElementsByTagName` return **live** collections (auto-update as DOM changes). `querySelectorAll` returns a **static** snapshot. This matters if you loop and modify the DOM inside the loop — a live collection can shrink/grow mid-iteration and skip elements or infinite-loop.

### 2. Creating, Inserting, Removing

```js
const li = document.createElement("li");
li.textContent = "New item";
li.classList.add("active");

parentEl.appendChild(li);           // add as last child
parentEl.prepend(li);               // add as first child
parentEl.insertBefore(li, refNode); // insert before a specific child
existingEl.remove();                // remove itself from DOM
parentEl.removeChild(childEl);      // older syntax, still valid

parentEl.replaceChild(newEl, oldEl);
```

### 3. Reading/Writing Content & Attributes

```js
el.textContent = "plain text";    // safe, no HTML parsing (prefer this)
el.innerHTML = "<b>bold</b>";     // parses HTML — use carefully (XSS risk if untrusted input)
el.setAttribute("data-id", "5");
el.getAttribute("data-id");
el.dataset.id;                     // shorthand for data-* attributes → el.dataset.id
el.value;                          // for inputs — NOT innerText/textContent
el.checked;                        // for checkboxes/radios
el.style.backgroundColor = "red";  // camelCase for CSS properties in JS
el.classList.add/remove/toggle/contains("className");
```

**Trap #4 — input values.** People often try `input.textContent` or `input.innerHTML` to read a form field's typed value — wrong, you need `input.value`.

### 4. Events

```js
el.addEventListener("click", function (e) {
  console.log(e.target);         // the actual element clicked
  console.log(e.currentTarget);  // the element the listener is attached to
  e.preventDefault();            // stop default action (form submit, link nav)
  e.stopPropagation();           // stop bubbling to ancestors
});

el.removeEventListener("click", namedFn); // must pass the SAME function reference
```

**Trap #5 — anonymous functions can't be removed.**

```js
el.addEventListener("click", () => console.log("hi"));
el.removeEventListener("click", () => console.log("hi")); // ❌ does nothing — different function reference!
```

To remove a listener later, you must store the function in a variable and pass that same reference to both `add` and `remove`.

**Trap #6 — `this` inside a regular-function event handler = the element**, but inside an arrow function, `this` = whatever it was in the surrounding scope (usually not the element). This is the DOM version of the `this` gotcha from before:

```js
el.addEventListener("click", function () { console.log(this); }); // `this` = el
el.addEventListener("click", () => { console.log(this); });        // `this` = outer scope, NOT el
```

### 5. Event Bubbling & Delegation (very commonly tested)

Events **bubble** — they fire on the target first, then travel up through ancestors. This lets you attach ONE listener to a parent instead of one per child (**event delegation**) — important for elements added dynamically after page load:

```js
document.querySelector("#list").addEventListener("click", function (e) {
  if (e.target.tagName === "LI") {
    console.log("Clicked:", e.target.textContent);
  }
});
```

This handles **future** `<li>` elements too, since the listener is on the parent, not on each `<li>` individually.

**Trap #7 — attaching a listener directly to elements that don't exist yet.**

```js
document.querySelectorAll(".item").forEach(item => {
  item.addEventListener("click", fn);
});
// New .item elements added LATER will NOT have this listener — only ones present at the time this ran.
```

If a debug question adds items dynamically and "clicks stop working" on new items, the fix is event delegation (attach to a stable parent, check `e.target`), not attaching to each item.

### 6. Script Timing — the #1 "why is my element null" bug

**Trap #8 — running JS before the DOM has loaded.** If your `<script>` tag is in `<head>` (before the `<body>` content) and runs immediately, `document.getElementById(...)` returns `null` because that element doesn't exist in the DOM yet.

Fixes:

```js
document.addEventListener("DOMContentLoaded", function () {
  // safe — DOM is fully parsed here
});
```

or simply place the `<script>` tag at the end of `<body>`, or use `defer` on the script tag.

### 7. Forms

```js
form.addEventListener("submit", function (e) {
  e.preventDefault();              // stop actual page reload/navigation
  const data = new FormData(form); // grab all field values
  console.log(data.get("email"));
});
```

### 8. Quick Debug Checklist (run through this when given broken code)

1. Is the selector correct/typo-free, and does the element exist **at the time the script runs**? (Trap #1, #8)
2. Is a NodeList/HTMLCollection being treated like an array without conversion? (Trap #2)
3. Are listeners attached to elements that get replaced/added later? Should this be delegation instead? (Trap #7)
4. Is `this` behaving unexpectedly because of arrow vs regular function? (Trap #6)
5. Is `.value` vs `.textContent`/`.innerHTML` used correctly for the element type? (Trap #4)
6. Off-by-one/scope bug from `var` in a loop attaching listeners (same `var` closure trap from the async section) — e.g., all buttons alerting the same last index instead of their own.

Want me to fold this DOM section into the same markdown file as a new section, or keep it separate?