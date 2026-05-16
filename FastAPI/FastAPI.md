Here are your **FastAPI notes**, structured as requested: first the **absolute minimum baseline knowledge**, then a **practical step-by-step guide** to write and understand FastAPI apps.

---

# PART 1 – BASE NEED-TO-KNOW FACTS & FIGURES

## What is FastAPI?
- A modern Python web framework for building APIs.
- **Based on**: Starlette (web handling) + Pydantic (data validation).
- **Key promise**: Very high performance (on par with Node.js and Go), easy to write, automatic interactive docs.

## Mandatory Prerequisites
- Python 3.8+ (ideally 3.10+).
- Understand basic Python types (e.g., `str`, `int`, `List`, `Dict`, `Optional`).
- Know how HTTP methods work: `GET`, `POST`, `PUT`, `DELETE`, `PATCH`.

## Core Concepts You Must Know Before Starting
| Concept | What it is |
|---------|-------------|
| **Path parameter** | Part of the URL path, e.g., `/users/123` → `user_id = 123` |
| **Query parameter** | After `?`, e.g., `/users?skip=10&limit=5` |
| **Request body** | JSON data sent in `POST`/`PUT` requests |
| **Response model** | The shape of JSON you return |
| **Pydantic model** | A Python class that defines data validation & serialization |
| **Dependency injection** | A way to reuse logic (auth, DB sessions) across endpoints |
| **Async/await** | Optional but supported for high concurrency |

## One-Line Facts (Memorize these)
1. FastAPI automatically validates request data using type hints.
2. You get **OpenAPI** schema and **Swagger UI** at `/docs` for free.
3. Every endpoint is an **async def** or **def** – FastAPI runs normal `def` in a thread pool.
4. **Path parameters** are required by default; **query parameters** are optional unless you make them required.
5. Use `Response` models to filter/transform output data.
6. **HTTPException** is the standard way to return errors (4xx, 5xx).
7. Dependencies are just functions decorated with `Depends()`.

---

# PART 2 – HOW EVERYTHING GOES (PRACTICAL GUIDE)

## 1. Installation
```bash
pip install fastapi uvicorn
# uvicorn is the ASGI server that runs FastAPI
```

## 2. Minimal App – Understand the Pieces
```python
from fastapi import FastAPI

app = FastAPI()  # main application instance

@app.get("/")    # decorator declares HTTP method & path
def root():
    return {"message": "Hello World"}
```

Run:
```bash
uvicorn main:app --reload
# main = filename (main.py), app = FastAPI instance
# --reload = auto-restart on code changes
```

## 3. Path & Query Parameters
```python
from fastapi import FastAPI

app = FastAPI()

# Path parameter (required)
@app.get("/items/{item_id}")
def get_item(item_id: int):           # type hint = validation
    return {"item_id": item_id}

# Query parameters (skip, limit come from ?skip=0&limit=10)
@app.get("/items/")
def list_items(skip: int = 0, limit: int = 10):
    return {"skip": skip, "limit": limit}

# Combined
@app.get("/products/{product_id}")
def get_product(product_id: int, q: str = None, in_stock: bool = True):
    return {"id": product_id, "query": q, "in_stock": in_stock}
```

**Key rules:**
- Parameters not in the path → automatically query parameters.
- Default values (`= None` or `= 10`) → optional. No default → required.

## 4. Request Body with Pydantic (POST, PUT)
```python
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Item(BaseModel):
    name: str
    price: float
    is_offer: bool = False   # default value

@app.post("/items/")
def create_item(item: Item):   # FastAPI reads JSON body → validates → creates Item object
    # item.name, item.price, item.is_offer are available
    return {"item_name": item.name, "price_with_tax": item.price * 1.19}
```

**POST request example:**
```json
{
  "name": "Laptop",
  "price": 999.99
}
```
Response:
```json
{"item_name": "Laptop", "price_with_tax": 1189.99}
```

## 5. Response Model – Control Output
```python
from pydantic import BaseModel

class UserIn(BaseModel):
    username: str
    password: str

class UserOut(BaseModel):
    username: str
    # password excluded automatically

@app.post("/users/", response_model=UserOut)
def create_user(user: UserIn):
    # In real life: save user, hash password
    return user   # FastAPI filters out 'password' using response_model
```

**Why?**  
- Hides sensitive data.
- Documents output format.
- Validates what you return.

## 6. Error Handling (HTTPException)
```python
from fastapi import FastAPI, HTTPException

app = FastAPI()

fake_db = {1: "apple", 2: "banana"}

@app.get("/fruit/{fruit_id}")
def get_fruit(fruit_id: int):
    if fruit_id not in fake_db:
        raise HTTPException(status_code=404, detail="Fruit not found")
    return {"name": fake_db[fruit_id]}
```

## 7. Dependency Injection – The Star Feature
```python
from fastapi import FastAPI, Depends, HTTPException, Header

app = FastAPI()

# Dependency: a function that can be reused
def get_current_user(authorization: str = Header(...)):
    if authorization != "secret-token":
        raise HTTPException(status_code=401)
    return {"user": "john"}

@app.get("/secure")
def secure_route(user_data: dict = Depends(get_current_user)):
    return {"message": "Welcome", "user": user_data}
```

**Common uses:** DB sessions, authentication, request validation.

## 8. Async Support (When to Use)
```python
# Use async if you call external APIs, DB drivers that support async (e.g., asyncpg, httpx)
@app.get("/slow")
async def slow_endpoint():
    await asyncio.sleep(2)
    return {"status": "done"}

# Use normal def for CPU-bound or sync code (FastAPI runs it in thread pool)
@app.get("/cpu")
def cpu_bound():
    return sum(range(10_000_000))
```

**Rule:** Prefer `async def` when doing I/O with async libraries; otherwise use `def`.

## 9. Running & Deployment Cheatsheet
```bash
# Development
uvicorn main:app --reload --port 8000

# Production (with gunicorn + uvicorn workers)
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker

# With Docker
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
```

## 10. Common Pitfalls (Avoid These)
| Mistake | Why it fails |
|---------|--------------|
| Forgetting `response_model` in POST → exposes passwords | Data leakage |
| Defining body param with default `= None` but not type `Optional` | Pydantic doesn’t make it optional |
| Using `async` with sync libraries (e.g., `requests`) | Blocks the event loop |
| Path parameter declared after query param in function signature | Order doesn’t matter, FastAPI handles it |
| Not using `...` (Ellipsis) for required body fields | `...` means required, `None` means optional |

Example of required field:
```python
class Item(BaseModel):
    name: str = ...   # ... = required
    description: str = None  # optional
```

---

# Final Check – Can You Now Run FastAPI Scripts?

✅ You know how to install FastAPI and run with uvicorn.  
✅ You can write endpoints with path, query, and body parameters.  
✅ You understand Pydantic models for validation and response filtering.  
✅ You know how to raise HTTP errors.  
✅ You’ve seen dependencies and async basics.

**Next step for mastery:**  
Read the official [FastAPI Tutorial - User Guide](https://fastapi.tiangolo.com/tutorial/) – you now understand 80% of it already.