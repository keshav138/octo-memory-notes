Yep. `pathlib` is Python's modern way of working with **files and folders**, and `Path` is the main class you'll use.

## 1. Basic setup

```python
from pathlib import Path
```

Create a path:

```python
path = Path("models/model.pkl")
```

This doesn't create anything—it just represents that path.

---

## 2. Joining paths — the most useful part

Instead of:

```python
os.path.join("models", "model.pkl")
```

you can do:

```python
path = Path("models") / "model.pkl"
```

You can chain it:

```python
path = Path("project") / "models" / "model.pkl"
```

The `/` here means **join paths**, not division.

---

## 3. `.` and `..`

Same concepts as normal filesystem paths:

```python
Path(".")
```

means current directory.

```python
Path("..")
```

means parent directory.

So from:

```text
project/
├── models/
└── scripts/
    └── script.py
```

you could write:

```python
path = Path("..") / "models" / "model.pkl"
```

giving:

```text
../models/model.pkl
```

---

## 4. Getting the script's own location

This is particularly useful for your previous question.

```python
Path(__file__)
```

is the path of the Python file itself.

Usually you'll want:

```python
script_dir = Path(__file__).resolve().parent
```

If your structure is:

```text
project/
├── models/
│   └── model.pkl
└── scripts/
    └── script.py
```

then:

```python
script_dir = Path(__file__).resolve().parent
```

points to:

```text
project/scripts/
```

Go up one:

```python
project_dir = script_dir.parent
```

Then:

```python
model_path = project_dir / "models" / "model.pkl"
```

### In one line

```python
model_path = Path(__file__).resolve().parent.parent / "models" / "model.pkl"
```

This is generally much safer than:

```python
Path("../models/model.pkl")
```

because it isn't dependent on **where you ran Python from**.

---

# 5. Checking if something exists

```python
path.exists()
```

```python
if path.exists():
    print("Found!")
```

Check whether it's a file:

```python
path.is_file()
```

or a directory:

```python
path.is_dir()
```

---

# 6. Reading and writing files

Instead of:

```python
with open("data.txt", "r") as f:
    data = f.read()
```

you can do:

```python
path = Path("data.txt")

data = path.read_text()
```

Writing:

```python
path.write_text("Hello world")
```

For binary files:

```python
data = path.read_bytes()
```

```python
path.write_bytes(data)
```

---

# 7. Getting filename and extension

Given:

```python
path = Path("models/my_model.pkl")
```

### Filename

```python
path.name
```

→

```text
my_model.pkl
```

### Extension

```python
path.suffix
```

→

```text
.pkl
```

### Filename without extension

```python
path.stem
```

→

```text
my_model
```

### Parent directory

```python
path.parent
```

→

```text
models
```

---

# 8. Creating directories

```python
output_dir = Path("output")
output_dir.mkdir()
```

If parent directories might not exist:

```python
output_dir.mkdir(parents=True, exist_ok=True)
```

This is very common for ML/data projects:

```python
output_dir = Path("results")
output_dir.mkdir(parents=True, exist_ok=True)

output_file = output_dir / "predictions.csv"
```

---

# 9. Finding files

You can use:

```python
Path("models").iterdir()
```

to iterate through everything inside `models`.

For example:

```python
for file in Path("models").iterdir():
    print(file)
```

Only `.pkl` files:

```python
for file in Path("models").glob("*.pkl"):
    print(file)
```

Recursively through subdirectories:

```python
Path("models").rglob("*.pkl")
```

---

# 10. Absolute paths

```python
path.resolve()
```

turns something like:

```text
../models/model.pkl
```

into something like:

```text
C:\Users\Keshav\project\models\model.pkl
```

You can also start with:

```python
Path.cwd()
```

which gives your **current working directory**.

For example:

```python
print(Path.cwd())
```

---

## The handful I'd memorize

For everyday Python/ML projects, these are probably **90% of what you'll need**:

```python
from pathlib import Path

# Create path
p = Path("models/model.pkl")

# Join paths
p = Path("models") / "model.pkl"

# Current working directory
Path.cwd()

# Location of current Python script
Path(__file__).resolve()

# Parent directory
p.parent

# Filename
p.name

# Extension
p.suffix

# Without extension
p.stem

# Does it exist?
p.exists()

# Is file/directory?
p.is_file()
p.is_dir()

# Create directory
p.mkdir(parents=True, exist_ok=True)

# Read/write
p.read_text()
p.write_text("hello")

# Find files
Path("models").glob("*.pkl")
```

**The key mental model:** `Path` is basically an object representing a filesystem path, and you manipulate that object rather than manually constructing strings like `"../models/model.pkl"`.