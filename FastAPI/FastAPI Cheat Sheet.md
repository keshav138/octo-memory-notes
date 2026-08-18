# FastAPI Cheat Sheet

The 20% of FastAPI you'll use 80% of the time. Each item covers: **what it does, why you use it, syntax, and a working example** — plus "Must Know" gotchas where they bite people.

---

## 0. App Setup & Running

**What:** Create a FastAPI instance and serve it with uvicorn.
**Why:** Every FastAPI app starts with these 4 lines.

```python
# main.py
from fastapi import FastAPI

app = FastAPI()   # the application object everything hangs off

@app.get("/")
def root():
    return {"message": "Hello"}
```

```bash
pip install fastapi uvicorn
uvicorn main:app --reload
# main = filename (main.py) | app = the FastAPI() instance | --reload = dev only
```

**Must Know:**
- Interactive docs are automatic: `/docs` (Swagger UI) and `/redoc`. Always open `/docs` to test endpoints without writing client code.
- `app = FastAPI()` accepts useful kwargs: `title`, `description`, `version` — these show up in `/docs`.

---

## 1. Path Parameters

**What:** Values embedded in the URL path, e.g. `/users/123`.
**Why:** Identify a specific resource. Always required.

```python
@app.get("/items/{item_id}")
def get_item(item_id: int):        # type hint = automatic validation
    return {"item_id": item_id}

@app.get("/files/{file_path:path}")  # :path = capture full path incl. slashes
def get_file(file_path: str):
    return {"path": file_path}
```

**Example call:** `GET /items/42` → `{"item_id": 42}`

**Must Know:**
- The **type hint does the validation**: `GET /items/abc` returns a 422 error automatically.
- Path params with no default are **required** — a request without them 404s.
- Route order matters: declare `/items/me` **before** `/items/{item_id}`, otherwise "me" is captured as `item_id`.

---

## 2. Query Parameters

**What:** Values after `?` in the URL, e.g. `/items?skip=0&limit=10`.
**Why:** Filtering, pagination, search — anything optional about a list request.

```python
@app.get("/items/")
def list_items(skip: int = 0, limit: int = 10, q: str | None = None):
    # Parameters NOT in the path → automatically query parameters
    return {"skip": skip, "limit": limit, "q": q}

@app.get("/items/")               # required query param (no default)
def search_items(q: str):
    return {"q": q}
```

**Example call:** `GET /items/?skip=20&limit=5&q=book` → `{"skip": 20, "limit": 5, "q": "book"}`

**Must Know:**
- **No default → required** query parameter. Default value → optional.
- `None` is a valid default; in Pydantic v2 use `str | None`, not just `str = None` (which breaks validation).
- Booleans work: `?in_stock=true` → `in_stock: bool = True`.
- List query params need `Query()`: `tags: list[str] = Query(None)` → `?tags=a&tags=b`.

---

## 3. Request Body (Pydantic Models)

**What:** JSON sent in POST/PUT/PATCH requests, parsed and validated into a Pydantic model.
**Why:** 90% of API writes are "take JSON, validate it, save it."

```python
from pydantic import BaseModel

class Item(BaseModel):
    name: str
    price: float
    is_offer: bool = False        # default → optional field

@app.post("/items/")
def create_item(item: Item):      # single Pydantic param = the JSON body
    return {"name": item.name, "total": item.price * 1.2}
```

**Example request:** `POST /items/` with body `{"name": "Laptop", "price": 999.99}`
**Response:** `{"name": "Laptop", "total": 1199.99}`

**Must Know:**
- If a param is a Pydantic model, FastAPI expects it in the **body**. If it's a simple type (`int`, `str`), it's a **query param**.
- Invalid JSON shape → automatic **422** with details of every failed field. You get validation for free.
- **Singular vs plural body:** `item: Item` expects `{"name": ...}`. `items: list[Item]` expects `[{"name": ...}, ...]`.
- **Multiple body params** need `Body()`: `def update(item: Item, importance: int = Body(...))`.

---

## 4. Response Model

**What:** `response_model=` on the decorator filters/validates/serializes what you return.
**Why:** Hide sensitive fields (passwords), guarantee output shape, populate `/docs`.

```python
class UserIn(BaseModel):
    username: str
    password: str

class UserOut(BaseModel):
    username: str                    # password NOT declared → stripped

@app.post("/users/", response_model=UserOut)
def create_user(user: UserIn):
    return user                      # 'password' is automatically removed

@app.get("/users/", response_model=list[UserOut])   # list responses
def list_users():
    return [{"username": "a"}, {"username": "b"}]
```

**Must Know:**
- `response_model` = **runtime** filtering (real protection). A bare return type hint (`-> UserOut`) does **nothing** at runtime.
- It also **converts and validates** what you return — wrong types become 500s, catching your bugs.
- Fast paths: use `response_model` always for public APIs; skip it only for quick prototypes.
- If the actual response can be one of several shapes, use `response_model=Union[Success, Error]`.

---

## 5. Error Handling (HTTPException)

**What:** Raise `HTTPException` to return proper HTTP error responses.
**Why:** Clients (and you) need structured 4xx/5xx errors, not stack traces.

```python
from fastapi import HTTPException

fake_db = {1: "apple"}

@app.get("/fruit/{fruit_id}")
def get_fruit(fruit_id: int):
    if fruit_id not in fake_db:
        raise HTTPException(status_code=404, detail="Fruit not found")
    return {"name": fake_db[fruit_id]}
```

**Example response:** `404 {"detail": "Fruit not found"}`

**Must Know:**
- `detail` can be any JSON-serializable value (str, dict, list) — not just strings.
- You can add custom headers: `HTTPException(400, detail="x", headers={"X-Error": "bad"})`.
- **Never** `return {"error": ...}` with a 200 status for failures — use HTTPException.
- For validation errors you raise yourself (not FastAPI's 422), use `RequestValidationError` handler or just HTTPException 422.

---

## 6. Dependency Injection (Depends)

**What:** `Depends()` injects the return value of a function into your endpoint.
**Why:** Reuse auth, DB sessions, and shared logic across endpoints without copy-paste. FastAPI's killer feature.

```python
from fastapi import Depends, Header, HTTPException

def get_current_user(authorization: str = Header(...)):
    if authorization != "secret-token":
        raise HTTPException(status_code=401, detail="Unauthorized")
    return {"user": "john"}          # this value gets injected

@app.get("/secure")
def secure_route(user: dict = Depends(get_current_user)):
    return {"message": "Welcome", "user": user}
```

**Example call:** `GET /secure` with header `Authorization: secret-token` → `{"message": "Welcome", "user": {"user": "john"}}`

**Must Know:**
- Dependencies can themselves depend on other dependencies (chain them).
- A dependency can be **async**, can **yield** (for DB sessions — setup before, teardown after), and its result is **cached per request** (called once even if used by 3 endpoints).
- Reuse the same dependency in `app = FastAPI(dependencies=[Depends(verify_token)])` to apply it to **all** routes.
- `Header(...)` means required header; `Header(None)` optional.

---

## 7. Headers, Cookies, Forms & Files

**What:** Read the other common request parts. All use the same pattern: `param: type = Header/Form/File(...)`.
**Why:** Auth tokens come in headers; web forms and uploads come as form data.

```python
from fastapi import Header, Cookie, Form, File, UploadFile

@app.get("/who")
def who(user_agent: str = Header(None), session: str = Cookie(None)):
    return {"ua": user_agent, "session": session}

@app.post("/login")
def login(username: str = Form(...), password: str = Form(...)):
    return {"user": username}           # HTML form fields, not JSON

@app.post("/upload")
async def upload(file: UploadFile = File(...)):
    content = await file.read()         # UploadFile = async, streamed
    return {"filename": file.filename, "size": len(content)}
```

**Must Know:**
- **Header names auto-convert:** `user_agent` ↔ `User-Agent` header.
- `Form`/`File` → request must be `application/x-www-form-urlencoded` or `multipart/form-data`, **not** JSON.
- Prefer `UploadFile` over `bytes` for files: it streams to disk instead of loading into memory.
- When you use Form/File params, you **cannot** also declare a Pydantic body model on the same endpoint.

---

## 8. Path Operation Parameters (status_code, tags, summary)

**What:** Extra decorator kwargs that control behavior and docs.
**Why:** Correct status codes matter; tags organize your `/docs`.

```python
@app.post("/items/", status_code=201, tags=["items"], summary="Create an item")
def create_item(item: Item):
    return item

@app.get("/items/{item_id}", response_model=Item, tags=["items"])
def get_item(item_id: int):
    ...
```

**Must Know:**
- Default success codes: `GET` → 200, `POST` → 200 (you usually override to 201), `DELETE` → 200 (consider 204).
- `tags` groups endpoints in Swagger UI — cheap organization, use it.
- `response_model` + `status_code` together document the full contract of the endpoint.

---

## 9. async vs def

**What:** Endpoints can be `async def` or normal `def`.
**Why:** Picking wrong kills performance. `async` is for concurrent I/O; `def` runs in a thread pool.

```python
import httpx, asyncio

@app.get("/fast")          # async = waits concurrently for I/O
async def fast():
    async with httpx.AsyncClient() as c:
        r = await c.get("https://api.example.com/data")
    return r.json()

@app.get("/cpu")           # def = runs in thread pool, doesn't block event loop
def cpu_bound():
    return sum(range(10_000_000))
```

**Must Know:**
- **Rule of thumb:** use `async def` when calling async libraries (httpx, asyncpg, aiomysql). Use `def` for sync code (SQLAlchemy sync, requests, CPU-heavy work).
- **Never** call a blocking sync library (`requests`, `time.sleep`) inside `async def` — it freezes the entire event loop.
- Both work; FastAPI handles the difference for you. Just match the libraries you use.

---

## 10. APIRouter (Organizing Larger Apps)

**What:** Split routes into modules, then mount them on the main app.
**Why:** One file works for demos; any real app with 3+ resource types needs routers.

```python
# routers/users.py
from fastapi import APIRouter
router = APIRouter(prefix="/users", tags=["users"])

@router.get("/")                    # → GET /users/
def list_users():
    return [{"name": "john"}]

# main.py
from fastapi import FastAPI
from routers.users import router as users_router

app = FastAPI()
app.include_router(users_router)    # mounts all /users routes
```

**Must Know:**
- `prefix` on the router applies to every route in it — no repetition.
- Routers can be nested: a router can `include_router` another.
- You can mount routers with a dependency: `app.include_router(router, dependencies=[Depends(verify)])` to protect a whole section.

---

## 11. CORS (Quick Setup)

**What:** Middleware that allows browser clients on other origins to call your API.
**Why:** Any separate-frontend project hits CORS errors on the first request.

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # your frontend's origin
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Must Know:**
- `allow_origins=["*"]` for dev convenience, but list real origins in production (wildcards don't work with credentials/cookies).
- The error you're solving: browser console shows "blocked by CORS policy" — the fix is always server-side.

---

## Must-Know Gotchas (The Short List)

| Gotcha | Explanation |
|--------|-------------|
| `/items/me` after `/items/{item_id}` | "me" gets captured as an int `item_id` → 422. Static routes go first. |
| Pydantic model param vs plain param | Model type → read from body; plain type (`int`, `str`) → read from query. |
| `str = None` in Pydantic v2 | Use `str | None`. `str = None` raises validation error. |
| Blocking calls in `async def` | Freezes the event loop. Use sync `def` instead. |
| Return type hint ≠ filtering | Only `response_model` filters output. The hint is for IDEs only. |
| Form + body model on one endpoint | Can't have both. Form endpoints take Form/File params only. |
| `...` vs `None` in models | `name: str = ...` required. `name: str | None = None` optional. |

---

## The Daily Driver Pattern

This one snippet covers ~80% of a typical CRUD endpoint:

```python
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel

app = FastAPI(title="My API")

class ItemCreate(BaseModel):
    name: str
    price: float

class ItemOut(BaseModel):
    id: int
    name: str
    price: float

db = {}  # pretend database
counter = 0

@app.post("/items/", response_model=ItemOut, status_code=201)
def create_item(item: ItemCreate):
    global counter
    counter += 1
    db[counter] = {**item.model_dump(), "id": counter}
    return db[counter]

@app.get("/items/{item_id}", response_model=ItemOut)
def get_item(item_id: int):
    if item_id not in db:
        raise HTTPException(404, detail="Item not found")
    return db[item_id]
```
