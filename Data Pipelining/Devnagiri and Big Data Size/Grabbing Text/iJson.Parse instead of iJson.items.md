This is actually a great point in your project to understand **how streaming parsers work**, because the difference between `ijson.items()` and `ijson.parse()` is exactly why they're useful for LLM-scale datasets.

I'll explain this as if we're implementing the parser ourselves.

---

# The big picture

Your JSON file looks something like

```json
[
    {
        "_id": ...,
        "link": "...",
        "page_1":{
            "text_data":"..."
        }
    },
    {
        ...
    }
]
```

A normal parser (like `json.load`) thinks:

> "Let me read the ENTIRE file and build one giant Python object."

So after parsing you'd have

```python
[
    {...},
    {...},
    {...}
]
```

For 22 GB this is impossible.

---

# How `ijson.items()` works

`ijson.items(f, "item")` is already smarter.

Instead of building

```python
[
    doc1,
    doc2,
    doc3,
    ...
]
```

it does

```
Read bytes
↓

Build doc1

↓

Yield doc1

↓

Delete doc1

↓

Build doc2

↓

Yield doc2
```

So memory becomes roughly

```
Memory ≈ size of one document
```

instead of

```
Memory ≈ size of entire file
```

This is much better.

---

# But there's still a problem

Suppose one document looks like

```
{
    page_1
    page_2
    page_3
    ...
    page_1000
}
```

`ijson.items()` must still construct the **entire dictionary** before it can give it to you.

So internally it does

```
Create {}

↓

Add "_id"

↓

Add "link"

↓

Add page_1

↓

Add page_2

↓

...

↓

Add page_1000

↓

Yield dictionary
```

Even if your code only needs

```
page_1.text_data
```

everything gets built.

That's what the comment in your new script is referring to.

---

# `ijson.parse()` works differently

Instead of building objects...

it becomes a **stream of parser events**.

Imagine reading the JSON character by character.

```
[
```

Parser says

```
start_array
```

Then it sees

```
{
```

Parser says

```
start_map
```

Then

```
"_id"
```

Parser says

```
map_key
```

Then

```
{
```

Parser says

```
start_map
```

Then

```
"$oid"
```

Parser says

```
map_key
```

Then

```
"66..."
```

Parser says

```
string
```

Then

```
}
```

Parser says

```
end_map
```

and so on.

---

So instead of

```python
doc
```

you receive

```python
(prefix, event, value)
```

one at a time.

---

For example

```
{
    "link":"abc",
    "page_3":{
        "text_data":"Hello"
    }
}
```

becomes approximately

```
('', start_map, None)

('link', map_key, 'link')

('link', string, 'abc')

('page_3', map_key, 'page_3')

('page_3', start_map, None)

('page_3.text_data', map_key, 'text_data')

('page_3.text_data', string, 'Hello')

('page_3', end_map, None)

('', end_map, None)
```

Notice:

No dictionary exists.

Just events.

---

# Understanding prefix

The prefix is simply

> "Where am I inside the JSON tree?"

Suppose

```json
{
    "page_3":{
        "text_data":"Hello"
    }
}
```

Parser walks

```
root

↓

page_3

↓

text_data
```

So prefix becomes

```
page_3.text_data
```

When inside the array of books, prefixes start with `item`, which is why you see

```
item.page_3.text_data
```

---

# Understanding event

The event tells you

> "What just happened?"

Examples

```
start_map
```

means

```
{
```

was encountered.

---

```
end_map
```

means

```
}
```

was encountered.

---

```
map_key
```

means

```
"text_data"
```

was encountered.

---

```
string
```

means

```
"The actual string value"
```

was encountered.

---

# Understanding value

Suppose parser reaches

```json
"text_data":"Hello Nepal"
```

then

```
prefix

↓

item.page_3.text_data
```

event

```
string
```

value

```
Hello Nepal
```

So

```python
(prefix, event, value)
```

becomes

```python
(
    "item.page_3.text_data",
    "string",
    "Hello Nepal"
)
```

---

# Now your script makes sense

The parser is created once and then iterated event by event.

When it encounters the start of a top-level document,

```python
if prefix == "item" and event == "start_map":
```

it knows:

```
New document begins.
```

so it resets

```python
current_doc_text = None
```

because we haven't seen any text for this document yet.

---

Later, when it reaches

```
item.page_3.text_data
```

the condition

```python
elif event == "string" and prefix.endswith(".text_data"):
```

matches.

Now

```
value
```

contains the actual OCR text.

So

```python
current_doc_text = value
```

stores only that string.

---

Eventually the parser reaches

```
}
```

that closes the document.

That generates

```
prefix == "item"

event == "end_map"
```

At this point the script knows:

> "I've finished reading this document."

Only then does it write the extracted text to the buffer or output file.

---

# Why this is more memory efficient

With `items()`:

```
JSON
↓

Build entire dict

↓

Give dict to you
```

Memory contains

```
_id
link
page_1
page_2
page_3
...
```

---

With `parse()`:

```
JSON

↓

"_id"

↓

"link"

↓

"text_data"

↓

"}"
```

No complete dictionary is ever created.

Only tiny parser events plus the current value exist.

---

# One subtle limitation

There's one important thing to understand.

Even `parse()` **cannot split a JSON string**.

Suppose a JSON value is

```json
"text_data":"5 million characters..."
```

The parser still has to read until it finds the closing quotation mark before it can yield the string.

So memory usage becomes roughly

```
largest text_data string
```

instead of

```
largest document dictionary
```

This is why `parse()` is a significant improvement over `items()` for your corpus, but if you genuinely have a single `text_data` containing tens or hundreds of millions of characters, that individual string still has to be allocated. Based on what you've found so far, however, it seems your largest values are in the range of a few million characters, which is usually manageable and much smaller than constructing an entire document dictionary containing many fields.