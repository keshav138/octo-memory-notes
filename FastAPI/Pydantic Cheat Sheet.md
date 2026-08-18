# Pydantic Cheat Sheet

The 20% of Pydantic you'll use 80% of the time. Each item covers: **what it does, why you use it, syntax, and a working example** — plus "Must Know" gotchas where they bite people.

> **Version note:** This cheat sheet is written for **Pydantic v2** (current, used by FastAPI 0.100+). Where v1 differs, it's called out — you'll see legacy code in tutorials.

---

## 0. BaseModel — The Foundation

**What:** A class that defines the shape of your data and validates it at creation.
**Why:** It's the single building block for request/response bodies, config objects, and settings. Everything else in Pydantic hangs off it.

```python
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    price: float
    is_offer: bool = False     # default → optional field

item = Item(name="Laptop", price=999.99)
print(item.name)      # Laptop       (dot access)
print(item.is_offer)  # False        (default applied)
```

**Must Know:**
- Invalid data **raises `ValidationError`** immediately — you get fail-fast validation for free.
- Fields are declared with **type hints**; everything else is automatic.
- `Item(name=...)` validates. `Item.model_validate(dict)` validates a dict. `Item.model_construct(...)` skips validation (fast, rarely needed).

---

## 1. Field Types & Automatic Conversion

**What:** Pydantic converts input values to the declared types when possible.
**Why:** JSON from APIs is strings ("42") — you want real types (42) with zero manual parsing.

```python
from pydantic import BaseModel

class User(BaseModel):
    age: int
    height: float
    is_admin: bool

u = User(age="42", height="1.8", is_admin="true")   # all strings!
print(u.age)        # 42        (int)
print(u.height)     # 1.8       (float)
print(u.is_admin)   # True      (bool)
print(u.model_dump())  # {'age': 42, 'height': 1.8, 'is_admin': True}
```

**Must Know:**
- Conversion is strict about garbage: `User(age="abc")` → `ValidationError`.
- Pydantic v2 is strict about type coercion in some cases — `"42"` → `int` works, but `"1.8"` → `int` fails.
- `bool` parsing: `"true"`, `"yes"`, `"1"` → `True`; `"false"`, `"no"`, `"0"` → `False`.

---

## 2. Optional Fields & Defaults

**What:** Mark fields optional with defaults (`= None`) or `Optional`/`| None`.
**Why:** Most real-world data has fields that may be missing. Declare it, don't crash on it.

```python
from pydantic import BaseModel

class User(BaseModel):
    username: str                  # required — no default
    email: str | None = None       # v2 style: optional, None if absent
    age: int = 18                  # default value

u = User(username="john")
print(u.model_dump())   # {'username': 'john', 'email': None, 'age': 18}

User()  # ❌ ValidationError: username is required
```

**Must Know:**
- **`str | None = None`** is the v2 way. `Optional[str] = None` works too but is v1-style.
- `str = None` (no `| None`) **raises a validation error in v2** — must declare the None.
- Use `...` (Ellipsis) for required: `name: str = ...` — explicit "must provide".
- Defaults can be factories: `tags: list[str] = []` works in v2, but for mutable defaults use `Field(default_factory=list)`.

---

## 3. Field() — Constraints & Metadata

**What:** `Field()` attaches validation rules and metadata to a field.
**Why:** "Must be > 0", "max 50 chars", "this is the title" — declarative rules instead of manual checks.

```python
from pydantic import BaseModel, Field

class Product(BaseModel):
    name: str = Field(min_length=1, max_length=50)
    price: float = Field(gt=0, description="Price must be positive")
    tags: list[str] = Field(default_factory=list)
    sku: str = Field(pattern=r"^[A-Z]{3}-\d{4}$")

Product(name="Book", price=10.5, sku="ABC-1234")   # ✅
Product(name="Book", price=-5, sku="abc")          # ❌ ValidationError
```

**Common constraints:** `gt`, `ge`, `lt`, `le` (numbers); `min_length`, `max_length`, `pattern` (strings); `min_items`, `max_items` (lists).

**Must Know:**
- `Field()` is also where `alias` lives — map JSON keys to Python names:
  ```python
  class User(BaseModel):
      first_name: str = Field(alias="firstName")
  User.model_validate({"firstName": "John"})   # JSON uses camelCase
  ```
- `description` shows up in FastAPI's `/docs` — free documentation.

---

## 4. Nested Models

**What:** Models inside models.
**Why:** Real JSON is nested (`{"user": {"address": {...}}}`). Mirror the structure.

```python
from pydantic import BaseModel

class Address(BaseModel):
    street: str
    city: str

class User(BaseModel):
    name: str
    address: Address          # nested model
    tags: list[str]           # list of primitives

u = User(name="John", address={"street": "Main St", "city": "NYC"}, tags=["a"])
print(u.address.city)   # NYC
```

**Must Know:**
- Dicts convert to nested models automatically — no manual construction.
- Nested invalid data produces a `ValidationError` pointing at the exact nested path (`address.city`).
- For arbitrary extra nested data you don't want to model: `metadata: dict` — plain dicts are fine.

---

## 5. Serialization: model_dump() / model_dump_json()

**What:** Convert a model back to a dict or JSON string.
**Why:** You validate/process in Python, then serialize for the DB, API response, or log.

```python
from pydantic import BaseModel

class User(BaseModel):
    name: str
    password: str

u = User(name="john", password="secret")

u.model_dump()            # {'name': 'john', 'password': 'secret'}
u.model_dump(exclude={"password"})   # {'name': 'john'}
u.model_dump_json()       # '{"name":"john","password":"secret"}'
```

**Must Know:**
- **v2:** `model_dump()` / `model_dump_json()`. **v1 (legacy):** `.dict()` / `.json()` — deprecated in v2 but everywhere in old tutorials.
- Common kwargs: `exclude={"field"}`, `include={"field"}`, `exclude_none=True` (drop None fields — great for PATCH).
- In FastAPI, returning a model with `response_model` serializes automatically — you rarely call this by hand there.

---

## 6. Validators (field_validator)

**What:** Custom validation logic that runs after type validation.
**Why:** Built-in constraints can't express everything ("must be a valid SKU", "transform to lowercase").

```python
from pydantic import BaseModel, field_validator

class User(BaseModel):
    name: str
    email: str

    @field_validator("email")
    @classmethod
    def email_must_contain_at(cls, v: str) -> str:
        if "@" not in v:
            raise ValueError("invalid email")
        return v.lower()          # return value replaces the field

User(name="john", email="JOHN@X.COM")   # ✅ email becomes 'john@x.com'
User(name="john", email="nope")         # ❌ ValidationError: invalid email
```

**Must Know:**
- **v2:** `@field_validator("field")`. **v1:** `@validator("field")` — different import, same idea.
- Always `@classmethod` in v2 (v1 didn't require it).
- The returned value **replaces** the field — use this to normalize (strip, lowercase).
- Validate multiple fields: `@field_validator("a", "b")`. Access other fields via `ValidationInfo` (v2) or `values` (v1).
- The decorator runs **after** type conversion — `v` is already the right type.

---

## 7. model_config / ConfigDict

**What:** Per-model settings controlling parsing/serialization behavior.
**Why:** Common switches: accept attributes from ORM objects, strip unknown fields, forbid extras.

```python
from pydantic import BaseModel, ConfigDict

class User(BaseModel):
    model_config = ConfigDict(from_attributes=True, str_strip_whitespace=True)

    name: str
    age: int

class UserStrict(BaseModel):
    model_config = ConfigDict(extra="forbid")   # reject unknown fields
    name: str

UserStrict(name="a", extra_field=1)   # ❌ ValidationError: Extra inputs are not permitted
```

**Most-used options:**

| Option | Effect |
|--------|--------|
| `from_attributes=True` | `User.model_validate(orm_object)` works (v1: `orm_mode=True`) |
| `extra="forbid"` | Unknown JSON fields → error (default is `"ignore"`) |
| `str_strip_whitespace=True` | Strips leading/trailing spaces from strings |
| `use_enum_values=True` | Serialize enums as their values, not names |

**Must Know:**
- **v1 used** `class Config: orm_mode = True` — you'll see this in every old FastAPI tutorial. v2 replaced it with `model_config = ConfigDict(...)`.
- `from_attributes=True` is **required** to validate SQLAlchemy/SQLModel ORM objects.

---

## 8. Common Field Types (EmailStr, UUID, datetime)

**What:** Ready-made types for common data shapes.
**Why:** Don't regex-validate emails and UUIDs yourself.

```python
from pydantic import BaseModel, EmailStr, UUID4
from datetime import datetime

class User(BaseModel):
    email: EmailStr                    # needs: pip install pydantic[email]
    id: UUID4
    created_at: datetime

User(email="john@example.com", id="f47ac10b-58cc-4372-a567-0e02b2c3d479",
     created_at="2026-01-15T10:30:00Z")   # ✅ ISO string → datetime object
User(email="not-an-email", ...)           # ❌ ValidationError
```

**Must Know:**
- `EmailStr` requires `pip install pydantic[email]` (or `email-validator`) — a common ImportError otherwise.
- Datetime parsing accepts ISO 8601 strings automatically.
- FastAPI pairs these perfectly: invalid email in a request body → automatic 422.

---

## 9. Union & Literal (Choice Types)

**What:** A field can be one of several types (`Union`) or one of several exact values (`Literal`).
**Why:** Model real-world polymorphism and enums without classes.

```python
from typing import Union, Literal
from pydantic import BaseModel

class Event(BaseModel):
    type: Literal["click", "view"]    # only these exact strings
    data: Union[int, str, None]       # int or str or None

Event(type="click", data=5)        # ✅
Event(type="scroll", data=5)       # ❌ ValidationError: type must be 'click' or 'view'
Event(type="view", data=[1, 2])    # ❌ ValidationError: data must be int/str/None
```

**Must Know:**
- `X | Y` is the modern `Union[X, Y]` — use it.
- **Union matching order matters:** in v1, `Union[int, str]` with value `"5"`... in v2 it's **smart** (tries best match). Legacy gotcha mostly gone.
- `Literal` is great for status fields: `status: Literal["pending", "active", "banned"]`.
- In FastAPI, `response_model=Union[Success, Error]` documents multiple possible responses.

---

## 10. List / Dict of Models (Collection Types)

**What:** Typed collections: `list[Item]`, `dict[str, Item]`.
**Why:** API responses are almost always collections of models — validate every element.

```python
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    price: float

class Order(BaseModel):
    items: list[Item]                       # list of models
    quantities: dict[str, int]              # dict of primitives

o = Order(items=[{"name": "A", "price": 1.0}], quantities={"A": 3})
print(o.items[0].name)   # A
```

**Must Know:**
- Every element is validated — one bad item fails the whole model with a precise index path (`items.0.name`).
- Dicts with model values validate values too: `dict[str, Item]`.
- Use `tuple[...]` for fixed-length, and `set[...]` for unique collections.

---

## Must-Know Gotchas (The Short List)

| Gotcha | Explanation |
|--------|-------------|
| `str = None` in v2 | Must be `str \| None = None`. Missing `\| None` → ValidationError. |
| v1 vs v2 naming | `.dict()` → `model_dump()`, `@validator` → `@field_validator`, `class Config` → `model_config`, `parse_obj` → `model_validate`. |
| `EmailStr` ImportError | Install `pydantic[email]` separately. |
| Extra fields silently dropped | Default behavior ignores unknown JSON keys; use `extra="forbid"` if that's a bug. |
| `from_attributes` missing | Validating an ORM object without it fails — `model_validate(orm_obj)` needs `from_attributes=True`. |
| Mutable defaults | `tags: list[str] = []` — shared across instances in v1 (v2 copies it). Use `Field(default_factory=list)` to be safe. |
| Validator replaces value | `@field_validator` must `return` the (possibly transformed) value, or the field becomes None. |

---

## The Daily Driver Pattern

```python
from pydantic import BaseModel, Field, field_validator, ConfigDict

class UserCreate(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

    username: str = Field(min_length=3, max_length=30)
    email: EmailStr
    password: str = Field(min_length=8)
    role: Literal["admin", "user"] = "user"

    @field_validator("username")
    @classmethod
    def normalize_username(cls, v: str) -> str:
        return v.lower()

class UserOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    username: str
    email: EmailStr
    role: str
    # password intentionally not declared → never serialized
```
