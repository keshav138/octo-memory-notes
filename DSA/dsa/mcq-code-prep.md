# MCQ Code Prep — Snippets for C, C++, Java, Python

Small code snippets of the kind that get turned into MCQs. Each one tests one
deep point of the language — the classic traps where a shallow reading gives
the wrong answer. Predict the output of each snippet **before** reading the note.

---

## 1. C — Memory, Pointers & UB

### 1.1 `sizeof` traps

```c
char *p = "hello";
printf("%zu %zu %zu %zu\n",
    sizeof(p),       // size of the POINTER (8 on 64-bit), not the string
    sizeof("hello"), // 6 — array, includes '\0'
    sizeof(char),    // always 1 BY DEFINITION
    strlen(p));      // 5
```

```c
int arr[5];
int *q = arr;
printf("%zu %zu\n", sizeof(arr), sizeof(q)); // 20 vs 8 — array decays in q

void f(int a[]) { printf("%zu\n", sizeof(a)); } // prints 8 — decays to pointer
```

### 1.2 Pointer arithmetic

```c
int a[] = {1, 2, 3, 4};
int *p = a;
printf("%d\n", *(p + 2));          // 3
printf("%td\n", &a[3] - &a[0]);    // 3 (elements, not bytes)
printf("%d\n", *(p + 1) == p[1]);  // 1 — identical
```

### 1.3 Array indexing is commutative

```c
int a[] = {10, 20, 30};
printf("%d %d\n", a[2], 2[a]);     // 30 30 — a[i] == *(a+i) == i[a]
```

### 1.4 Increment & sequence points (UB)

```c
int x = 5;
printf("%d %d\n", x++, ++x);       // UNDEFINED — evaluation order not fixed

int i = 0;
i = i++;                            // UNDEFINED — two writes between sequence points
```

### 1.5 `const` vs pointer

```c
const char *p = "abc";   // pointer to const: p[0] = 'x' is ERROR; p = "def" is OK
char *const q = buf;     // const pointer:   q = other is ERROR; q[0] = 'x' is OK
const char *const r = "abc"; // both locked
```

### 1.6 `char` signedness & `EOF`

```c
char c;
while ((c = getchar()) != EOF)   // BUG if char is unsigned: EOF(-1) never matches
    putchar(c);

int d;
while ((d = getchar()) != EOF)   // correct
```

### 1.7 Pre/post increment

```c
int x = 1;
int y = x++ + ++x;      // UNDEFINED — never ask this in real code
int a = 1, b = 1;
int p = a++;            // p = 1, a = 2
int q = ++b;            // q = 2, b = 2
```

### 1.8 `printf` format specifiers

```c
unsigned int u = 1;
printf("%d\n", u);            // 1 — but %d expects int, technically wrong specifier
printf("%u\n", -1);           // 4294967295 — bits reinterpreted
printf("%f\n", 1);            // UNDEFINED — int passed to %f (varargs: no conversion)
printf("%d\n", 1.0);          // UNDEFINED / garbage
```

### 1.9 `sizeof` vs `strlen` vs null

```c
char s[5] = "abc";     // s = {'a','b','c',0,0}
printf("%zu\n", sizeof(s));   // 5
printf("%zu\n", strlen(s));   // 3 — stops at first NUL

char t[] = "ab\0cd";
printf("%zu\n", strlen(t));   // 2 — embedded NUL terminates early
```

### 1.10 Integer promotion

```c
char a = 100, b = 100;
char c = a + b;        // int arithmetic, then truncated: 200 % 256 = -56
printf("%d\n", a + b); // 200 — promoted to int, no overflow
printf("%d\n", c);     // -56 (if char is signed)
```

### 1.11 Static vs local lifetime

```c
int *f(void) {
    int x = 42;
    return &x;          // DANGLING — returning address of stack variable
}
int *g(void) {
    static int y = 42;
    return &y;          // OK — static storage
}
```

### 1.12 `struct` padding

```c
struct A { char c; int i; };        // sizeof = 8 (3 padding bytes)
struct B { char c; char d; int i; };// sizeof = 8 (2 padding bytes)
struct C { int i; char c; };        // sizeof = 8 (trailing pad to align)
```

### 1.13 Endianness

```c
unsigned int x = 0x01020304;
unsigned char *p = (unsigned char *)&x;
printf("%02x\n", p[0]);   // 04 on little-endian, 01 on big-endian
```

### 1.14 Signed overflow & UB

```c
int x = 2147483647;
x = x + 1;               // UNDEFINED — signed overflow

unsigned int y = 4294967295u;
y = y + 1;               // well-defined: wraps to 0
```

### 1.15 String literal pooling

```c
char *a = "same";
char *b = "same";
printf("%d\n", a == b);       // often 1 — pooled, but not guaranteed
char x[] = "same";
printf("%d\n", a == x);       // 0 — different array
```

### 1.16 Precedence of dereference & postfix

```c
char s[] = "abc";
char *p = s;
*p++ = 'X';     // same as *(p++) — writes 'X' to s[0], then p advances
(*p)++;         // increments s[1]
```

### 1.17 `#define` macro double evaluation

```c
#define SQUARE(x) x*x
#define SAFE(x)   ((x)*(x))

SQUARE(3+2)       // 3 + 2*3 + 2 = 11, NOT 25
SAFE(3+2)         // 25
SQUARE(a++)       // a++ * a++ — UB
```

### 1.18 Ternary & comma operator

```c
int a = 1, b = 2;
a > b ? a++ : b++;     // only b++ runs -> b = 3
int c = (a = 3, b = 4, a + b);   // comma: left to right, value = 7
```

### 1.19 `free` & dangling

```c
int *p = malloc(sizeof(int));
*p = 5;
free(p);
// p is now dangling; *p is UB; double free is UB

p = malloc(sizeof(int)); // fine — p reassigned
```

### 1.20 `strcpy` vs `memcpy` vs `strncpy`

```c
char d[10];
strcpy(d, "hi");       // copies 'h','i','\0'
strncpy(d, "hello", 3);// copies h,e,l — NO '\0' if n < len (dirty buffer)
memcpy(d, "hi", 3);    // exact bytes, no NUL logic
```

---

## 2. C++ — OOP, STL & Subtleties

### 2.1 `virtual` & destructors

```cpp
struct Base {
    virtual ~Base() { cout << "B"; }   // virtual dtor: delete via Base* runs ~Derived
};
struct Derived : Base {
    ~Derived() { cout << "D"; }
};
Base *b = new Derived();
delete b;                 // prints "DB" (if ~Base virtual); prints "B" only if NOT virtual
```

### 2.2 Virtual dispatch in constructors

```cpp
struct Base {
    Base() { show(); }              // virtual call inside ctor -> calls BASE version
    virtual void show() { cout << "base "; }
};
struct Derived : Base {
    void show() override { cout << "derived "; }
};
Derived d;    // prints "base " — Derived not constructed yet
```

### 2.3 Slicing

```cpp
struct Base { virtual void f() { cout << "B"; } };
struct D : Base { int extra = 5; void f() override { cout << "D"; } };

D d;
Base b = d;       // SLICED — extra is cut off, virtual pointer is Base's
b.f();            // "B"

Base &r = d;      // reference keeps full object
r.f();            // "D"
```

### 2.4 Pure virtual & abstract classes

```cpp
struct A { virtual void f() = 0; };   // abstract — cannot instantiate A
struct B : A { void f() override {} };
// A a;      // compile error
B b;        // OK
```

### 2.5 Name hiding

```cpp
struct Base { void f(int) { cout << "base"; } };
struct Derived : Base {
    void f(double) { cout << "derived"; }  // HIDES all Base::f overloads
};
Derived d;
d.f(1);           // "derived" — 1 converts to double; Base::f is hidden
d.f(1.5);         // "derived"
// fix: using Base::f; in Derived
```

### 2.6 Access specifiers in inheritance

```cpp
struct Base { public: int a; protected: int b; private: int c; };
struct Pub : public Base  { void g(){ a=1; b=2; /* c=3; ERROR */ } };
struct Pro : protected Base { void g(){ a=1; b=2; } };
struct Pri : private Base   { void g(){ a=1; b=2; } };
// Pro x; x.a = 1;  ERROR — a is protected now
// Pri y; y.a = 1;  ERROR — a is private now
```

### 2.7 `const` member functions

```cpp
struct S {
    int x;
    void f() const { /* x = 5; ERROR */ }
    void g() {}
    mutable int cache;          // mutable CAN change in const fn
};
const S s;
s.f();          // OK
// s.g();       // ERROR — const object, non-const method
```

### 2.8 References vs pointers

```cpp
int x = 5;
int &r = x;      // alias — no null, no reseating
int *p = &x;
r = 10;          // x == 10
int y = 20;
r = y;           // COPIES y into x — reference never reseats!
p = &y;          // pointer reseats fine
```

### 2.9 Copy vs move

```cpp
vector<int> a = {1, 2, 3};
vector<int> b = a;            // deep copy
vector<int> c = move(a);      // move — a is now empty (valid but unspecified)
cout << a.size();             // typically 0, but state is UNSPECIFIED — only reuse is safe
```

### 2.10 Rule of three/five

```cpp
struct S {
    int *p;
    S() : p(new int(5)) {}
    S(const S &o) : p(new int(*o.p)) {}          // deep copy ctor
    S &operator=(const S &o) { *p = *o.p; return *this; } // copy assign
    ~S() { delete p; }                            // dtor
    // missing any of these -> double-free or shallow copy bugs
};
```

### 2.11 Initialization order & list

```cpp
struct S {
    int a, b;                       // declared in this order: a FIRST
    S(int x) : b(x), a(b + 1) {}    // init list says b first — but a is initialized FIRST
};
// Initialization runs in DECLARATION order, not list order:
// a = b + 1 reads b before b is initialized -> UB / garbage in a, b == x
S s(5);      // s.b == 5, s.a is unspecified (UB)
```

### 2.12 Static initialization order fiasco

```cpp
// file1.cpp
extern int global;
int use = global + 1;   // value depends on which file initializes first — UNSPECIFIED
```

### 2.13 Operator overloading & chaining

```cpp
struct S {
    int v = 0;
    S &operator+=(int x) { v += x; return *this; }  // return *this for chaining
};
S s;
s += 1; s += 2;          // OK — returns reference
```

### 2.14 Function overloading & default args

```cpp
void f(int x) {}
void f(int x, int y = 5) {}
// f(1);      // AMBIGUOUS — both match

void g(int x) {}
void g(double x) {}
g(1);         // int version
g(1.0);       // double version
g('a');       // int (char promotes to int)
```

### 2.15 Lambda captures

```cpp
int x = 5;
auto a = [x]() { return x; };         // copy — x frozen at 5
auto b = [&x]() { return ++x; };      // reference — sees live x
auto c = [=]() { return x; };         // copy-all
auto d = [&]() { return x; };         // ref-all
x = 10;
a();   // 5
b();   // 11
auto e = [x = x + 1]() { return x; }; // init capture — 11
```

### 2.16 `static` in class vs file

```cpp
struct S {
    static int count;     // one copy shared by all objects — defined OUTSIDE class
};
int S::count = 0;
S a, b;
a.count++;               // S::count == 1 for both
```

### 2.17 Template & type deduction

```cpp
template <typename T> void f(T x) {}        // by value: strips const/ref
template <typename T> void g(T &x) {}       // by ref: deduces exact type
const int ci = 5;
f(ci);      // T = int
g(ci);      // T = const int
f("abc");   // T = const char*  (array decays)
```

### 2.18 `explicit` & implicit conversions

```cpp
struct S {
    explicit S(int x) {}
};
void take(S s) {}
// take(5);        // ERROR — explicit blocks implicit conversion
take(S(5));        // OK
S s2 = 5;          // ERROR (copy-init also blocked)
S s3(5);           // OK
```

### 2.19 Inheritance & hiding of `operator=`

```cpp
struct Base { int x; };
struct D : Base { int y; };
D d1, d2;
d1 = d2;        // copies BOTH x and y (default operator= copies base too)
```

### 2.20 `enum` vs `enum class`

```cpp
enum E1 { A = 1, B };
enum class E2 { A = 1, B };
int x = A;         // OK — unscoped enum converts to int
// int y = E2::A;  // ERROR — scoped, needs cast
```

### 2.21 `vector` size vs capacity

```cpp
vector<int> v;
v.reserve(10);
cout << v.size();      // 0 — reserve does NOT create elements
cout << v.capacity();  // 10
v.push_back(1);        // size 1, capacity 10 — no realloc
```

### 2.22 Iterator invalidation

```cpp
vector<int> v = {1, 2, 3};
auto it = v.begin();
v.push_back(4);        // reallocation may invalidate it
cout << *it;           // UNDEFINED

for (auto it = v.begin(); it != v.end(); ++it) {
    v.push_back(*it);  // INFINITE LOOP / UB — end() invalidated
}
```

### 2.23 `std::map` ordering & key rules

```cpp
map<int, string> m;     // sorted by KEY (red-black tree)
m[3] = "c"; m[1] = "a"; m[2] = "b";
for (auto &[k, val] : m) cout << k;   // 123

map<int, string, greater<int>> mg;    // descending
```

### 2.24 `operator[]` vs `at` vs `find`

```cpp
map<int, int> m;
m[5] = 1;
m[7];           // INSERTS {7, 0} — key now exists!
cout << m.size();  // 2
m.at(9);        // throws out_of_range
m[9] = 3;       // inserts
m.at(9);        // 3
```

### 2.25 `erase` in loop

```cpp
vector<int> v = {1, 2, 3, 4};
for (auto it = v.begin(); it != v.end();) {
    if (*it % 2 == 0) it = v.erase(it);  // erase returns next valid iterator
    else ++it;
}   // v = {1, 3}
```

### 2.26 Reference semantics in `auto`

```cpp
vector<int> v = {1, 2, 3};
auto a = v[0];          // copy
auto &b = v[0];         // reference
for (auto x : v) x = 9;       // copies — v unchanged
for (auto &x : v) x = 9;      // v = {9,9,9}
```

### 2.27 `const` iterator vs `cbegin`

```cpp
const vector<int> v = {1, 2, 3};
auto it = v.begin();       // const_iterator
// *it = 5;                // ERROR
auto it2 = v.cbegin();     // same thing, explicit
```

### 2.28 `emplace_back` vs `push_back`

```cpp
vector<pair<int, int>> v;
v.push_back({1, 2});           // constructs pair then moves
v.emplace_back(1, 2);          // constructs in place — no temp
```

### 2.29 Move semantics & `&&`

```cpp
string s = "hello";
string a = s;              // copy
string b = std::move(s);   // move — s is now "unspecified" (often empty)
cout << b;                 // hello
// s may or may not print hello — don't rely on moved-from state
```

### 2.30 `std::function` & `bind`

```cpp
function<int(int)> f = [](int x) { return x * 2; };
cout << f(3);        // 6
auto g = std::bind([](int a, int b) { return a + b; }, 5, std::placeholders::_1);
cout << g(10);       // 15
```

### 2.31 Exception safety & RAII

```cpp
struct File {
    File() { cout << "open\n"; }
    ~File() { cout << "close\n"; }    // runs even when exception thrown
};
void f() {
    File f;
    throw runtime_error("x");         // ~File() still runs — RAII
}
```

### 2.32 `mutable` & `static` interplay

```cpp
struct S {
    static int count;    // class-level, no per-object storage
    mutable int cached;
    void f() const { cached = 5; }   // mutable allows mutation in const fn
};
```

### 2.33 Casting & `reinterpret_cast`

```cpp
int x = 0x41424344;
char *p = reinterpret_cast<char *>(&x);   // view int as bytes
cout << p[0];   // 'D' on little-endian
int *ip = nullptr;
// static_cast<int>(3.9) == 3 — compile-time checked
// dynamic_cast<Derived*>(basePtr) — runtime checked, needs virtual
```

### 2.34 `friend` & operator overloading

```cpp
struct S {
    int v;
    friend ostream &operator<<(ostream &os, const S &s) {
        return os << s.v;
    }
};
S s{42};
cout << s;   // 42
```

### 2.35 Copy elision & RVO

```cpp
S make() {
    S s;
    return s;    // RVO — no copy in practice
}
S s = make();    // no copy (elision guaranteed since C++17)
```

### 2.36 `volatile` & `register` (legacy)

```cpp
volatile int x;    // every access reads memory, no caching
// register int r; // deprecated keyword, ignored
```

### 2.37 Default member initializers

```cpp
struct S {
    int a = 5;          // default member initializer
    S() {}              // a = 5
    S(int x) : a(x) {}  // a = x overrides
};
```

### 2.38 Deleting constructors

```cpp
struct S {
    S() = default;
    S(const S &) = delete;      // non-copyable
    S &operator=(const S &) = delete;
};
```

### 2.39 Override & final

```cpp
struct Base { virtual void f() {} };
struct D : Base {
    void f() override {}     // compile error if Base::f signature mismatches
};
struct E final {};           // cannot be derived from
// struct F : E {};          // ERROR
```

### 2.40 Private inheritance vs composition

```cpp
struct Base { void f() {} };
struct D : private Base {     // "implemented in terms of" — f() is private in D
    void g() { f(); }         // OK inside
};
D d;
// d.f();                     // ERROR — private inheritance hides base interface
```

### 2.41 `std::array` vs C array

```cpp
std::array<int, 3> a = {1, 2, 3};
std::array<int, 3> b = a;       // deep copy — C arrays can't
cout << a.size();               // 3 — C arrays don't know size
```

### 2.42 `shared_ptr` vs `unique_ptr`

```cpp
auto u = std::make_unique<int>(5);
// auto u2 = u;              // ERROR — unique_ptr is move-only
auto u2 = std::move(u);      // ownership transfer

auto s = std::make_shared<int>(5);
auto s2 = s;                 // refcount 2
```

### 2.43 `new[]` vs `delete[]`

```cpp
int *p = new int[10];
delete[] p;        // correct — delete p is UB
int *q = new int;
delete q;
```

### 2.44 `const` pointer semantics

```cpp
int x = 1, y = 2;
int *p = &x;          // pointer to int
const int *q = &x;    // pointer to const — can't write *q
int *const r = &x;    // const pointer — can't reseat r
const int *const s = &x;  // both
q = &y;  // OK
// *q = 5; // ERROR
// r = &y; // ERROR
```

### 2.45 Reference vs pointer member init

```cpp
struct S {
    int &r;
    S(int &x) : r(x) {}   // reference MUST be initialized in member-init list
};
int x = 5;
S s(x);
```

### 2.46 Static member access through instance

```cpp
struct S { static int x; };
int S::x = 10;
S s;
cout << s.x;    // 10 — works, but S::x is idiomatic
```

### 2.47 Shallow copy default

```cpp
struct S {
    int *p;
    S() : p(new int(5)) {}
    // no copy ctor — default SHALLOW copy shares p!
};
S a;
S b = a;        // b.p == a.p — double-free on destruction
```

### 2.48 Constructor chaining & delegation

```cpp
struct S {
    int a;
    S() : S(5) {}       // delegating ctor (C++11)
    S(int x) : a(x) {}
};
```

### 2.49 `std::optional` & `std::variant`

```cpp
std::optional<int> f(bool b) {
    if (b) return 42;
    return std::nullopt;    // empty state
}
auto v = f(true);
cout << *v;           // 42 — deref throws if empty
cout << v.value_or(0); // safe access

std::variant<int, double> var = 5;
std::get<int>(var);    // 5
// std::get<double>(var); // throws bad_variant_access
```

### 2.50 `static_cast` vs `reinterpret_cast` vs `const_cast`

```cpp
const int x = 5;
int *p = const_cast<int *>(&x);   // removes const — UB if object truly const
int i = 5;
double d = static_cast<double>(i);  // 5.0 — checked
void *vp = &i;
int *q = static_cast<int *>(vp);    // OK from void*
char *c = reinterpret_cast<char *>(q);  // raw bits, no checks
```

### 2.51 Inheritance of static members

```cpp
struct Base { static int x; };
int Base::x = 1;
struct D : Base {};
D::x = 5;           // same variable as Base::x — statics not inherited per-object
cout << Base::x;    // 5
```

### 2.52 `operator=` and self-assignment

```cpp
struct S {
    int *p;
    S &operator=(const S &o) {
        if (this == &o) return *this;    // self-assignment guard
        delete p;
        p = new int(*o.p);
        return *this;
    }
};
```

### 2.53 `initializer_list` & narrowing

```cpp
std::vector<int> v = {1, 2, 3};
int x{3.5};      // ERROR — brace-init forbids narrowing
int y(3.5);      // OK — truncates to 3
```

### 2.54 Const overloading

```cpp
struct S {
    void f() { cout << "non-const"; }
    void f() const { cout << "const"; }
};
S s;
s.f();            // non-const
const S &r = s;
r.f();            // const
```

### 2.55 `switch` fallthrough & scoping

```cpp
int x = 2;
switch (x) {
case 1:
    int y = 5;      // ERROR in C++ if case 2 sees it uninitialized — scope it
    break;
case 2:
    // y = 6;       // compiler error: jump bypasses init
    break;
}
```

### 2.56 Type of string literals

```cpp
auto s = "abc";         // const char*
auto s2 = "abc"s;       // std::string (needs using namespace std::string_literals)
char arr[] = "abc";     // char[4]
```

### 2.57 `std::set` of pointers vs values

```cpp
std::set<int *> s;
int x = 5;
s.insert(&x);
int y = 5;
s.insert(&y);           // both inserted — compares ADDRESSES, not values
cout << s.size();       // 2
```

### 2.58 `decltype` vs `auto`

```cpp
int x = 5;
int &r = x;
auto a = r;            // int — strips reference
decltype(r) b = r;     // int& — keeps reference
decltype(auto) c = r;  // int& — keeps reference (C++14)
```

### 2.59 `override` correctness

```cpp
struct Base { virtual void f(int) {} };
struct D : Base {
    // void f(double) override {}  // ERROR — no matching base virtual
    void f(int) override {}         // OK
};
```

### 2.60 `constexpr` & compile-time

```cpp
constexpr int square(int x) { return x * x; }
int arr[square(5)];    // OK — 25 known at compile time
const int y = 5;
int arr2[y];           // OK — y is constant expression
```

### 2.61 `nullptr` vs `NULL` vs `0`

```cpp
void f(int) { cout << "int"; }
void f(char *) { cout << "ptr"; }
f(NULL);     // prints "int" — NULL is 0
f(nullptr);  // prints "ptr" — nullptr is pointer type
```

### 2.62 Constructor with single arg & copy-init

```cpp
struct S { S(int) {} };
S s1 = 5;       // implicit conversion — copy-init
S s2{5};        // direct-init
// S s3{3.5};   // ERROR with braces — narrowing
S s4(3.5);      // OK — narrowing allowed with parens
```

### 2.63 `shared_ptr` cycles & weak_ptr

```cpp
struct Node {
    std::shared_ptr<Node> next;   // cycle: A->B->A — both never freed
    std::weak_ptr<Node> prev;     // weak breaks the cycle
};
```

### 2.64 `std::string` small string optimization

```cpp
std::string s = "hi";
std::string t = s;
t[0] = 'X';
cout << s;   // "hi" — copy on write / SSO guarantees independence
```

### 2.65 `std::numeric_limits`

```cpp
std::numeric_limits<int>::max();     // 2147483647
std::numeric_limits<int>::min();     // -2147483648
std::numeric_limits<double>::infinity();
```

### 2.66 `#define` vs `constexpr`

```cpp
#define N 10          // textual — no type, no scope
constexpr int M = 10; // typed, scoped, compile-time
// #undef N
// N = 5;  // ERROR either way
```

### 2.67 `inline` functions

```cpp
inline int add(int a, int b) { return a + b; }   // ODR-safe in headers
// multiple definitions across TUs OK for inline
```

### 2.68 Multiple inheritance ambiguity

```cpp
struct A { void f() {} };
struct B { void f() {} };
struct C : A, B {};
C c;
// c.f();            // AMBIGUOUS
c.A::f();            // disambiguated
```

### 2.69 Virtual inheritance (diamond)

```cpp
struct Base { int x; };
struct A : virtual Base {};
struct B : virtual Base {};
struct C : A, B {};
C c;
c.x = 5;             // single x — no diamond duplication
```

### 2.70 `template` specialization

```cpp
template <typename T> struct Check { static const bool v = false; };
template <> struct Check<int> { static const bool v = true; };
cout << Check<double>::v;   // 0
cout << Check<int>::v;      // 1
```

### 2.71 `typename` in templates

```cpp
template <typename T>
void f(T &t) {
    typename T::iterator it = t.begin();   // 'typename' needed for dependent type
}
```

### 2.72 `std::forward` & perfect forwarding

```cpp
template <typename T>
void relay(T &&x) {           // universal reference
    target(std::forward<T>(x));   // lvalue stays lvalue, rvalue stays rvalue
}
```

### 2.73 Lambda with `mutable`

```cpp
int x = 5;
auto f = [x]() mutable { return ++x; };   // copy can be modified
cout << f();   // 6
cout << f();   // 7
cout << x;     // 5 — original untouched
```

### 2.74 `sizeof` on classes with virtual

```cpp
struct Empty {};
struct Virtual { virtual void f() {} };
cout << sizeof(Empty);    // 1 — never zero
cout << sizeof(Virtual);  // 8 — vptr
```

### 2.75 `std::move` on `const` objects

```cpp
const std::string s = "hi";
std::string t = std::move(s);   // s is const — this is a COPY, not a move
cout << s;   // "hi" — still valid
```

### 2.76 Implicit `bool` conversion

```cpp
struct S {
    explicit operator bool() const { return true; }
};
S s;
if (s) {}              // OK — contextual conversion
// bool b = s;         // ERROR — explicit
bool b2 = static_cast<bool>(s);  // OK
```

### 2.77 `operator->` chaining

```cpp
struct Inner { void f() {} };
struct Ptr {
    Inner *i;
    Inner *operator->() { return i; }
};
Ptr p{new Inner};
p->f();          // p.operator->()->f() — automatic recursion until raw ptr
```

### 2.78 Rvalue ref & temporary lifetime

```cpp
std::string s = "abc";
std::string &&r = s + "def";    // rvalue ref binds to temporary
// lifetime of temporary EXTENDED to r's scope
r[0] = 'X';                      // OK — temporary lives
// std::string &&r2 = s;         // ERROR — can't bind rvalue ref to lvalue
```

### 2.79 Function pointer vs `std::function`

```cpp
int add(int a, int b) { return a + b; }
int (*fp)(int, int) = add;              // raw function pointer
std::function<int(int, int)> f = add;   // can wrap lambdas, bind, etc.
f = [](int a, int b) { return a * b; }; // OK — fp = lambda would fail (capture)
```

### 2.80 `goto` & scope crossing

```cpp
goto label;
int x = 5;      // skipped — using x at label is ERROR
label:
// cout << x;   // ERROR: initialization bypassed
```

---

## 3. Java — OOP, Exceptions & JVM Behavior

### 3.1 `==` vs `.equals()`

```java
String a = "abc";
String b = new String("abc");
System.out.println(a == b);        // false — different objects
System.out.println(a.equals(b));   // true — content

String c = "abc";
String d = "abc";
System.out.println(c == d);        // true — string pool
System.out.println(c == a);        // true
```

### 3.2 String pool & `intern()`

```java
String s1 = new String("hi").intern();
String s2 = "hi";
System.out.println(s1 == s2);      // true — intern returns pool reference
String s3 = "hi" + "there";        // compile-time constant — pooled
String s4 = "hithere";
System.out.println(s3 == s4);      // true
String s5 = new StringBuilder("hi").append("there").toString();
System.out.println(s5 == s4);      // false — runtime created
```

### 3.3 Integer caching

```java
Integer x = 127, y = 127;
System.out.println(x == y);        // true — cached [-128, 127]
Integer a = 128, b = 128;
System.out.println(a == b);        // false — new objects beyond cache
Integer c = new Integer(127);
System.out.println(c == x);        // false — explicit new bypasses cache
```

### 3.4 Autoboxing & unboxing NPE

```java
Integer x = null;
int y = x;                  // NullPointerException — unboxing null

Integer a = 100, b = 100;
System.out.println(a + b);         // 200 — unboxed for arithmetic
System.out.println(a == 100);      // true — unboxed comparison
```

### 3.5 Method overloading with widening vs boxing

```java
void f(long x)   { System.out.println("long"); }
void f(Integer x){ System.out.println("Integer"); }
f(5);                     // "long" — widening beats boxing

void g(Long x)   {}
void g(long x)   {}
// g(5);                   // widening beats boxing: "long"
// g((Long) 5L);           // explicit boxing
```

### 3.6 Overriding & covariant returns

```java
class A {
    Object get() { return null; }
    static void s() { System.out.println("A"); }
    void inst() { System.out.println("A-inst"); }
}
class B extends A {
    String get() { return null; }        // covariant return — legal override
    static void s() { System.out.println("B"); }   // HIDING, not overriding
    void inst() { System.out.println("B-inst"); }
}
A obj = new B();
obj.s();        // "A" — static dispatch
obj.inst();     // "B-inst" — dynamic dispatch
```

### 3.7 Static methods & hiding

```java
class Parent {
    static void f() { System.out.println("P"); }
}
class Child extends Parent {
    static void f() { System.out.println("C"); }
}
Parent p = new Child();
p.f();          // "P" — static methods resolved by reference type
```

### 3.8 Constructor chaining & `super()`

```java
class A {
    A() { System.out.println("A"); }
}
class B extends A {
    B() { System.out.println("B"); }
}
class C extends B {
    C() { System.out.println("C"); }
}
new C();       // prints A B C — super() implicit first
```

### 3.9 `finally` & `return` interaction

```java
int f() {
    try {
        return 1;
    } finally {
        return 2;      // finally's return OVERRIDES
    }
}
System.out.println(f());   // 2

int g() {
    try {
        return 1;
    } finally {
        System.out.println("finally runs");   // runs BEFORE return completes
    }
}
```

### 3.10 Exception order & unreachable code

```java
try {
    throw new ArithmeticException();
} catch (ArithmeticException e) {
    System.out.println("arith");
} catch (RuntimeException e) {        // broader after narrower — OK
    System.out.println("runtime");
}
// catch (ArithmeticException e) after RuntimeException — COMPILE ERROR
```

### 3.11 `static` blocks & initialization order

```java
class S {
    static { System.out.println("static block"); }   // runs once at class load
    { System.out.println("instance block"); }        // runs per object, before ctor
    S() { System.out.println("ctor"); }
}
new S();   // static block, instance block, ctor
new S();   // instance block, ctor
```

### 3.12 Pass by value — object references

```java
void f(String s, int[] a) {
    s = "changed";        // rebinds local — caller unaffected
    a[0] = 99;            // mutates shared array — caller sees it
}
String s = "orig";
int[] a = {1};
f(s, a);
System.out.println(s);    // "orig"
System.out.println(a[0]); // 99
```

### 3.13 Garbage collection & finalize

```java
class S {
    protected void finalize() throws Throwable {
        System.out.println("finalized");   // deprecated since Java 9
    }
}
S s = new S();
s = null;
System.gc();      // just a SUGGESTION — no guarantee
```

### 3.14 `finally` with exceptions

```java
try {
    throw new RuntimeException("A");
} catch (RuntimeException e) {
    throw new RuntimeException("B");
} finally {
    System.out.println("finally");   // runs — then B propagates
}
```

### 3.15 Switch on strings & enums

```java
String s = "a";
switch (s) {          // allowed since Java 7 — compares with .equals()
    case "a": System.out.println("A"); break;
    default: System.out.println("other");
}
// switch(3.5) — COMPILE ERROR: only int, char, String, enum
```

### 3.16 `Math.round` & floating point

```java
System.out.println(Math.round(2.5));     // 3 — rounds UP on .5
System.out.println(Math.round(-2.5));    // -2 — rounds toward positive infinity
System.out.println(0.1 + 0.2);           // 0.30000000000000004
System.out.println(0.1 + 0.2 == 0.3);    // false
```

### 3.17 Integer division & overflow

```java
System.out.println(5 / 2);        // 2 — integer division
System.out.println(5 / 2.0);      // 2.5
int max = Integer.MAX_VALUE;
System.out.println(max + 1);      // -2147483648 — silent overflow
System.out.println(Math.addExact(max, 1));   // throws ArithmeticException
```

### 3.18 `transient` & serialization

```java
class S implements Serializable {
    transient int secret = 5;       // NOT serialized — restored as 0
    int normal = 10;
}
// after serialize + deserialize: secret == 0, normal == 10
```

### 3.19 `volatile` & visibility

```java
volatile boolean flag = false;   // read/write directly from memory, no thread cache
// guarantees visibility, NOT atomicity — flag++ is still racy
```

### 3.20 `StringBuilder` vs `String` immutability

```java
String s = "a";
s.concat("b");          // returns NEW string — s unchanged
System.out.println(s);  // "a"
String t = s + "b";     // creates new — O(n) each time in a loop

StringBuilder sb = new StringBuilder("a");
sb.append("b");         // mutates in place
```

### 3.21 Inheritance & access modifiers

```java
class A {
    private void f() {}       // NOT inherited
    protected void g() {}     // inherited, visible in subclass + same package
    void h() {}               // package-private: same package only
}
class B extends A {
    // @Override void f() {}  // COMPILE ERROR — private not visible
    @Override void g() {}     // OK — can widen: protected -> public
    // void g() {} with weaker access — COMPILE ERROR
}
```

### 3.22 `instanceof` & null

```java
Object o = null;
System.out.println(o instanceof String);   // false — null instanceof is always false
System.out.println(null instanceof Object); // false
```

### 3.23 Array covariance — runtime hazard

```java
Object[] arr = new String[3];
arr[0] = "ok";
// arr[1] = 5;                    // ArrayStoreException at RUNTIME

List<Object> list = new ArrayList<String>();  // COMPILE ERROR — generics invariant
```

### 3.24 Generics type erasure

```java
List<String> a = new ArrayList<>();
List<Integer> b = new ArrayList<>();
System.out.println(a.getClass() == b.getClass());   // true — both ArrayList
// Can't: T t = new T();  new T[5];  instanceof T  — erased
```

### 3.25 `switch` fallthrough

```java
int x = 2;
switch (x) {
    case 1: System.out.print("one");
    case 2: System.out.print("two");
    case 3: System.out.print("three");   // prints "twothree" — no break!
}
```

### 3.26 `==` on boxed vs primitive

```java
Integer a = 5;
int b = 5;
System.out.println(a == b);      // true — unboxing
Integer c = 200;
Integer d = 200;
System.out.println(c == d);      // false — not cached
System.out.println(c.equals(d)); // true
```

### 3.27 `static` import & shadowing

```java
import static java.lang.Math.PI;
double x = PI;            // direct access
// int PI = 3;            // shadows the static import
```

### 3.28 Overloaded methods & null

```java
void f(String s) { System.out.println("String"); }
void f(Object o) { System.out.println("Object"); }
f(null);        // "String" — most specific wins
// void f(Integer i) — f(null) becomes AMBIGUOUS between String and Integer
```

### 3.29 `finally` skip with `System.exit`

```java
try {
    System.exit(0);     // JVM halts — finally does NOT run
} finally {
    System.out.println("never printed");
}
```

### 3.30 `Comparator` vs `Comparable`

```java
class S implements Comparable<S> {
    int v;
    public int compareTo(S o) { return v - o.v; }   // natural order
}
Comparator<S> byDesc = (a, b) -> b.v - a.v;         // custom order
```

### 3.31 `varargs` vs array

```java
void f(int... xs) {}    // f(1, 2, 3) or f(new int[]{1,2,3})
void g(int[] xs)  {}    // g(new int[]{1,2,3}) only

void f(int... xs) {}
void f(int x) {}        // f(5) picks exact match — f() picks varargs
```

### 3.32 `synchronized` & lock scope

```java
synchronized void f() {          // locks on `this`
}
static synchronized void g() {   // locks on Class object — different lock!
}
// f() and g() don't block each other
```

### 3.33 `try-with-resources` order

```java
try (A a = new A(); B b = new B()) {
    // ...
}   // resources closed in REVERSE order: B then A — even on exception
```

### 3.34 Default interface methods & diamond

```java
interface I1 { default void f() { System.out.println("I1"); } }
interface I2 { default void f() { System.out.println("I2"); } }
class C implements I1, I2 {
    public void f() {          // MUST override — otherwise COMPILE ERROR
        I1.super.f();          // explicit disambiguation
    }
}
```

### 3.35 Anonymous class & effectively final

```java
int x = 5;
Runnable r = new Runnable() {
    public void run() {
        System.out.println(x);   // OK — x is effectively final
        // x = 6;                // ERROR — captured vars must be effectively final
    }
};
```

### 3.36 `finally` when exception thrown in catch

```java
try {
    throw new RuntimeException("A");
} catch (RuntimeException e) {
    throw new RuntimeException("B");    // B propagates, but...
} finally {
    System.out.println("cleanup");       // ...finally runs first
}
```

### 3.37 Char & Unicode

```java
System.out.println('a' + 1);    // 98 — char promotes to int
System.out.println((char) ('a' + 1));   // 'b'
System.out.println("a" + 1);    // "a1" — string concat
System.out.println(1 + 2 + "a");  // "3a" — left to right
```

### 3.38 Array default values

```java
int[] a = new int[3];          // {0, 0, 0}
boolean[] b = new boolean[2];  // {false, false}
String[] s = new String[2];    // {null, null}
```

### 3.39 `%` and negative numbers

```java
System.out.println(-7 % 3);    // -1 — sign follows dividend
System.out.println(7 % -3);    // 1
```

### 3.40 `equals` contract violation

```java
class S {
    int v;
    public boolean equals(Object o) { return o instanceof S && v == ((S) o).v; }
    // no hashCode override — two equal objects may hash differently
}
S a = new S(); a.v = 1;
S b = new S(); b.v = 1;
Set<S> set = new HashSet<>();
set.add(a);
System.out.println(set.contains(b));   // likely false — hashCode mismatch!
```

### 3.41 Bitwise vs logical

```java
int a = 1, b = 2;
System.out.println(a & b);    // 0 — bitwise AND
System.out.println(a | b);    // 3
System.out.println(a ^ b);    // 3
boolean x = true, y = false;
System.out.println(x && y);   // false — short-circuit
System.out.println(x & y);    // false — no short-circuit
System.out.println(1 << 3);   // 8
System.out.println(-8 >> 1);  // -4 — arithmetic shift
System.out.println(-8 >>> 1); // 2147483644 — logical shift, zero-fills
```

### 3.42 `String` concatenation & `+`

```java
System.out.println("a" + 1 + 2);    // "a12" — string concat
System.out.println(1 + 2 + "a");    // "3a"
System.out.println('a' + 'b');      // 195 — char codes added
System.out.println("" + 'a' + 'b'); // "ab"
```

### 3.43 Thread & `start()` vs `run()`

```java
Thread t = new Thread(() -> System.out.println("thread"));
t.run();        // runs on CALLING thread — just a method call
t.start();      // runs on NEW thread — actual concurrency
```

### 3.44 Exception in constructor

```java
class S {
    S() { throw new RuntimeException(); }   // object NOT fully constructed
}
// partial object may leak `this` via static — escape analysis trap
```

### 3.45 `static final` compile-time constants

```java
static final int A = 10;        // compile-time constant — INLINED into bytecode
static final int B = new Random().nextInt();  // NOT compile-time constant
// changing A requires recompiling ALL users, B doesn't
```

### 3.46 Null in `switch` & collections

```java
List<String> l = new ArrayList<>();
l.add(null);               // ArrayList allows null
Map<String, String> m = new HashMap<>();
m.put(null, "x");          // HashMap allows null key
Map<String, String> t = new TreeMap<>();
// t.put(null, "x");       // NullPointerException — TreeMap sorts keys
```

### 3.47 `int` to `char` in arrays

```java
int[] arr = new int[]{'a', 'b'};     // {97, 98} — char widens to int
char[] c = new char[]{65, 66};       // {'A', 'B'}
```

### 3.48 Overloaded `main`

```java
public static void main(String[] args) {}        // real entry
public static void main(String args) {}          // overload — not entry
// both can coexist — JVM calls the String[] one
```

### 3.49 Method resolution with inheritance

```java
class A { void f(int x) { System.out.println("A"); } }
class B extends A { void f(double x) { System.out.println("B"); } }
B b = new B();
b.f(1);        // "B" — double wins at compile time (overload in B hides A's)
b.f(1.0);      // "B"
```

### 3.50 Object `clone` is protected

```java
class S implements Cloneable {
    int v;
    public Object clone() throws CloneNotSupportedException {
        return super.clone();     // shallow copy
    }
}
// S without implements Cloneable -> CloneNotSupportedException
```

---

## 4. Python — Runtime Semantics & Gotchas

### 4.1 Mutable default arguments

```python
def f(x, lst=[]):
    lst.append(x)
    return lst

print(f(1))   # [1]
print(f(2))   # [1, 2] — the SAME list persists between calls!
```

### 4.2 Late binding in closures

```python
funcs = [lambda: i for i in range(3)]
print([f() for f in funcs])     # [2, 2, 2] — all see final i

funcs = [lambda i=i: i for i in range(3)]   # fix: bind i as default
print([f() for f in funcs])     # [0, 1, 2]
```

### 4.3 `is` vs `==`

```python
a = 256
b = 256
print(a is b)          # True — small int cache [-5, 256]
a = 257
b = 257
print(a is b)          # False — beyond cache
print(a == b)          # True

a = "hello"; b = "hello"
print(a is b)          # True — string interning
```

### 4.4 Tuple mutation trap

```python
t = (1, 2, [3, 4])
# t[0] = 5               # TypeError — tuple immutable
t[2].append(5)           # works! — the LIST inside is mutable
print(t)                 # (1, 2, [3, 4, 5])

x = 5
y = 5
x += 1                   # rebinds x to 6 — int is immutable
print(x, y)              # 6 5
```

### 4.5 Shallow vs deep copy

```python
import copy
a = [[1, 2], [3, 4]]
b = list(a)          # shallow — outer list copied, inner lists SHARED
b[0].append(99)
print(a)             # [[1, 2, 99], [3, 4]] — a changed too!
c = copy.deepcopy(a) # fully independent
c[0].append(100)
print(a)             # [[1, 2, 99], [3, 4]] — untouched
```

### 4.6 `+` vs `+=` on lists

```python
a = [1, 2]
b = a
a += [3]        # MUTATES a in place — b sees it
print(b)        # [1, 2, 3]

a = a + [4]     # creates NEW list — b unchanged
print(a, b)     # [1, 2, 3, 4] [1, 2, 3]
```

### 4.7 Integer division & float precision

```python
print(5 / 2)          # 2.5 — true division
print(5 // 2)         # 2 — floor division
print(-5 // 2)        # -3 — FLOORS, not truncates
print(-5 % 3)         # 1 — Python modulo is always non-negative sign of divisor
print(0.1 + 0.2)      # 0.30000000000000004
print(0.1 + 0.2 == 0.3)   # False
```

### 4.8 String multiplication & immutability

```python
s = "abc"
s[0] = "X"             # TypeError — strings immutable
print("ha" * 3)        # "hahaha"
print("x" in "xyz")    # True — substring check
```

### 4.9 Default `None` idiom

```python
def f(x, lst=None):
    if lst is None:
        lst = []
    lst.append(x)
    return lst
print(f(1))    # [1]
print(f(2))    # [2] — fresh list each call
```

### 4.10 List comprehension scope

```python
x = 10
l = [x for x in range(3)]
print(x)        # 10 — comprehension has OWN scope (Python 3)
print(l)        # [0, 1, 2]

[x for x in range(3)]
# print(x)      # NameError — comprehension variable doesn't leak
```

### 4.11 `and` / `or` short-circuit values

```python
print(0 or "default")        # "default"
print(1 and 2)               # 2 — returns the DECIDING operand
print([] or [1, 2])          # [1, 2]
print("" and "hi")           # ""
```

### 4.12 Chained comparison

```python
print(1 < 2 < 3)     # True — (1<2) and (2<3)
print(3 < 2 < 1)     # False
print(1 < 2 > 3)     # False
print(0 == False)    # True — bool is subclass of int
print(1 == True)     # True
print(1 is True)     # False
```

### 4.13 Walrus operator

```python
if (n := len("hello")) > 3:
    print(n)        # 5 — assignment expression

while (line := input()) != "quit":
    print(line)
```

### 4.14 `del` vs reassignment

```python
a = [1, 2, 3]
b = a
del a[0]      # mutates — b = [2, 3]
del a         # unbinds name — b still [2, 3]
# print(a)    # NameError
```

### 4.15 `*args` / `**kwargs` unpacking

```python
def f(a, b, c): return a + b + c
l = [1, 2, 3]
print(f(*l))             # 6 — list unpacked positionally

d = {"a": 1, "b": 2, "c": 3}
print(f(**d))            # 6 — dict unpacked by keyword

def g(*args, **kwargs):
    print(args)          # tuple
    print(kwargs)        # dict
g(1, 2, x=3, y=4)
```

### 4.16 Generator vs list

```python
g = (x * x for x in range(3))     # generator — lazy
print(g)                          # <generator object ...>
print(list(g))                    # [0, 1, 4]
print(list(g))                    # [] — GENERATOR EXHAUSTED

l = [x * x for x in range(3)]     # list — eager
print(l, l)                       # [0, 1, 4] [0, 1, 4]
```

### 4.17 Iterator & `next()`

```python
it = iter([1, 2, 3])
print(next(it))       # 1
print(next(it))       # 2
print(next(it))       # 3
print(next(it))       # StopIteration — raised on exhaustion
```

### 4.18 `dict` ordering & key types

```python
d = {3: "c", 1: "a", 2: "b"}
print(list(d))        # [3, 1, 2] — INSERTION order (Python 3.7+)

d[[1]] = "x"          # TypeError — list unhashable
d[(1, 2)] = "ok"      # tuple hashable — fine
```

### 4.19 Slicing & negative indices

```python
s = "abcdef"
print(s[::-1])        # "fedcba"
print(s[1:4])         # "bcd" — end EXCLUSIVE
print(s[-2:])         # "ef"
print(s[::2])         # "ace"
print(s[10:20])       # "" — no error on out-of-range slice
```

### 4.20 `enumerate` & `zip`

```python
for i, v in enumerate(["a", "b"]):
    print(i, v)       # 0 a / 1 b

a = [1, 2, 3]
b = ["x", "y"]
print(list(zip(a, b)))        # [(1, 'x'), (2, 'y')] — stops at SHORTEST
print(list(zip_longest(a, b, fillvalue=0)))  # [(1,'x'),(2,'y'),(3,0)]
```

### 4.21 `in` on strings vs lists

```python
print("ell" in "hello")       # True — substring
print(["ell"] in ["hello"])   # False — list membership is exact element
print("ell" in ["hello"])     # False
```

### 4.22 Truthiness

```python
print(bool([]), bool({}), bool(""), bool(0), bool(None))   # all False
print(bool([0]), bool(" "), bool(-1))                      # all True
# empty containers, zero, None are falsy — EVERYTHING else truthy
```

### 4.23 Integer caching & `is`

```python
a = -5
b = -5
print(a is b)      # True — small int cache
a = 1000
b = 1000
print(a is b)      # False
a = "abc"
b = "abc"
print(a is b)      # True — interned literal
a = "a" * 1000
b = "a" * 1000
print(a is b)      # False — computed strings not interned
```

### 4.24 `set` vs `frozenset` & unhashable

```python
s = {1, 2, 3}
s.add(4)
# s.add([5])       # TypeError — list unhashable
fs = frozenset([1, 2])
# fs.add(3)        # AttributeError — frozen
d = {fs: "ok"}     # frozenset CAN be a dict key
```

### 4.25 `@property` & descriptors

```python
class C:
    @property
    def x(self):
        return self._x

    @x.setter
    def x(self, v):
        self._x = v
c = C()
c.x = 5          # setter called
print(c.x)       # 5
# c.x = "a"      # no validation — setter runs
```

### 4.26 Class vs instance attributes

```python
class C:
    x = [1]        # CLASS attribute — shared!
c1, c2 = C(), C()
c1.x.append(2)
print(c2.x)       # [1, 2] — shared mutable class attribute
c1.x = [9]        # creates INSTANCE attribute on c1
print(c2.x)       # [1, 2] — c2 still sees class attr
```

### 4.27 `__slots__` & memory

```python
class C:
    __slots__ = ("a", "b")     # fixed attributes — no __dict__
c = C()
c.a = 1
# c.z = 2        # AttributeError
```

### 4.28 `super()` & MRO (diamond)

```python
class A:
    def f(self): print("A")
class B(A):
    def f(self): print("B"); super().f()
class C(A):
    def f(self): print("C"); super().f()
class D(B, C):
    pass
D().f()        # B C A — MRO is D, B, C, A (C3 linearization)
print(D.__mro__)
```

### 4.29 `try/except` catch-all & re-raise

```python
try:
    1 / 0
except ZeroDivisionError as e:
    print("caught", e)
except Exception as e:      # catches most, but NOT SystemExit/KeyboardInterrupt
    raise                   # re-raises original with traceback
```

### 4.30 `else` on loops & try

```python
for i in range(3):
    if i == 5:
        break
else:
    print("no break")      # prints — loop completed without break

try:
    x = 1
except:
    pass
else:
    print("no exception")  # runs only if try succeeded
finally:
    print("always")
```

### 4.31 `nonlocal` vs `global`

```python
x = "global"
def outer():
    x = "outer"
    def inner():
        nonlocal x       # refers to OUTER's x
        x = "inner"
    inner()
    return x
print(outer())           # "inner"
print(x)                 # "global" — untouched
```

### 4.32 Variable unpacking

```python
a, b = b, a              # swap — RHS evaluated first
a, *rest = [1, 2, 3, 4]  # a=1, rest=[2,3,4]
*head, tail = [1, 2, 3]  # head=[1,2], tail=3
```

### 4.33 `dict` default & `setdefault`

```python
d = {}
d.setdefault("k", []).append(1)   # returns existing or inserts default
d.setdefault("k", []).append(2)
print(d)                  # {'k': [1, 2]}

from collections import defaultdict
dd = defaultdict(int)     # missing keys -> 0
dd["x"] += 1
print(dd["x"])            # 1
```

### 4.34 `sorted` vs `list.sort` & key

```python
a = [3, 1, 2]
b = sorted(a)         # NEW list — a unchanged
a.sort()              # in-place — returns None
print(a, b)

words = ["aaa", "b", "cc"]
print(sorted(words, key=len))       # ['b', 'cc', 'aaa']
print(sorted(words, key=len, reverse=True))
```

### 4.35 `map`/`filter` laziness

```python
m = map(str, [1, 2, 3])
print(m)               # <map object at 0x...>
print(list(m))         # ['1', '2', '3']
print(list(m))         # [] — EXHAUSTED

f = filter(lambda x: x > 1, [1, 2, 3])
print(list(f))         # [2, 3]
```

### 4.36 `format` & f-strings

```python
x = 3.14159
print(f"{x:.2f}")          # 3.14
print(f"{255:x}")          # ff
print("{:>10}".format("hi"))   # right-aligned width 10
print(f"{x=}")             # x=3.14159 — debug format (3.8+)
```

### 4.37 `__init__` vs `__new__`

```python
class C:
    def __new__(cls, *a, **k):
        print("new")
        return super().__new__(cls)    # creates the object
    def __init__(self):
        print("init")                  # initializes it
C()     # prints "new" then "init"
```

### 4.38 Dunder methods & operator overloading

```python
class V:
    def __init__(self, x): self.x = x
    def __add__(self, o): return V(self.x + o.x)
    def __repr__(self): return f"V({self.x})"
    def __len__(self): return abs(self.x)
print(V(1) + V(2))     # V(3)
print(len(V(-5)))      # 5
```

### 4.39 Context managers

```python
with open("f.txt") as f:     # __enter__ then __exit__
    data = f.read()
# file closed automatically — even on exception

class CM:
    def __enter__(self): print("enter"); return self
    def __exit__(self, *e): print("exit")
with CM():
    pass        # prints enter, exit
```

### 4.40 `bool` is subclass of `int`

```python
print(True + True)        # 2
print(isinstance(True, int))    # True
print(False == 0)         # True
print(sorted([True, 1, 0]))     # [0, 0, 1] — True == 1!
print(sorted([True, 1, 0], key=id))   # distinct objects preserved
```

### 4.41 `del` inside loops over dict

```python
d = {1: "a", 2: "b", 3: "c"}
for k in d:
    # del d[k]       # RuntimeError — dict changed size during iteration
    pass
for k in list(d):     # safe — iterate over copy
    del d[k]
```

### 4.42 Modifying list while iterating

```python
a = [1, 2, 3, 4]
for x in a:
    a.remove(x)      # skips elements! a becomes [2, 4]
print(a)

a = [1, 2, 3, 4]
for x in a[:]:       # iterate over a copy
    a.remove(x)
print(a)             # []
```

### 4.43 `while` with `else` and mutation

```python
i = 0
while i < 3:
    i += 1
    if i == 2:
        continue
    print(i, end=" ")    # 1 3
else:
    print("done")        # runs — no break hit
```

### 4.44 Unbound local

```python
x = 10
def f():
    print(x)        # UnboundLocalError — x is local because of assignment below
    x = 20
f()
```

### 4.45 `%` formatting vs f-string eval timing

```python
name = "world"
s = f"hello {name}"
name = "x"
print(s)           # "hello world" — evaluated at creation

t = "hello %s" % name
print(t)           # "hello x" — evaluated at % call
```

### 4.46 `any`/`all` & short-circuit

```python
print(any([False, True, False]))    # True
print(all([True, True, False]))     # False
print(all([]))                      # True — VACUOUS
print(any([]))                      # False — VACUOUS
```

### 4.47 `str.join` & `split`

```python
print(" ".join(["a", "b", "c"]))     # "a b c"
print("a,b,c".split(","))            # ['a', 'b', 'c']
print("a b  c".split())              # ['a', 'b', 'c'] — whitespace splits greedily
print("  hi  ".strip())              # "hi"
```

### 4.48 `__eq__` & hash contract

```python
class P:
    def __init__(self, x): self.x = x
    def __eq__(self, o): return self.x == o.x
    # no __hash__ — becomes unhashable when __eq__ defined

a, b = P(1), P(1)
print(a == b)        # True
# hash(a)            # TypeError — unhashable
# {a: 1}             # TypeError
```

### 4.49 `__getitem__` & iteration

```python
class C:
    def __getitem__(self, i):
        if i >= 3: raise IndexError
        return i * i
c = C()
print(list(c))       # [0, 1, 4] — iterates until IndexError
print(c[2])          # 4
print(c[-1])         # -1 passed raw — NOT normalized
```

### 4.50 `__iter__` & `__next__`

```python
class Count:
    def __init__(self, n): self.n = n
    def __iter__(self): return self
    def __next__(self):
        if self.n <= 0: raise StopIteration
        self.n -= 1
        return self.n
print(list(Count(3)))      # [2, 1, 0]
```

### 4.51 Decorator order

```python
def deco(f):
    def w(*a): print("before"); f(*a); print("after")
    return w

@deco
def g(): print("body")
g()    # before, body, after

def d1(f): print("d1"); return f
def d2(f): print("d2"); return f
@d1
@d2
def h(): pass
# prints d2 then d1 — applied BOTTOM-UP
```

### 4.52 `functools` & `lru_cache`

```python
from functools import lru_cache, reduce
@lru_cache(maxsize=None)
def fib(n):
    return n if n < 2 else fib(n - 1) + fib(n - 2)
print(fib(10))                 # 55
print(fib.cache_info())        # hits/misses

print(reduce(lambda a, b: a * b, [1, 2, 3, 4]))   # 24
```

### 4.53 `partial` & binding

```python
from functools import partial
def f(a, b, c): return a + b + c
g = partial(f, 1, c=3)
print(g(2))        # 6 — a=1, b=2, c=3
```

### 4.54 `try`-`except` with multiple exceptions

```python
try:
    int("x")
except (ValueError, TypeError) as e:
    print(type(e).__name__)    # ValueError
except Exception:
    print("other")             # never reached here
```

### 4.55 `round()` banker's rounding

```python
print(round(2.5))    # 2 — round half to EVEN
print(round(3.5))    # 4
print(round(2.675, 2))   # 2.67 — float repr trap, not 2.68
```

### 4.56 `id()` & small objects

```python
a = 5
b = 5
print(id(a) == id(b))      # True — same cached object
l1, l2 = [1], [1]
print(id(l1) == id(l2))    # False — distinct lists
print(id(a) == id(b) == id(5))   # True
```

### 4.57 Name mangling

```python
class C:
    def __init__(self):
        self.__secret = 1       # mangled to _C__secret
c = C()
print(c._C__secret)             # 1
# c.__secret                    # AttributeError
```

### 4.58 `staticmethod` vs `classmethod`

```python
class C:
    x = 10
    @staticmethod
    def s(): return "static"       # no cls/self
    @classmethod
    def cm(cls): return cls.x      # gets class — subclass-aware
class D(C):
    x = 20
print(D.cm())       # 20 — classmethod uses D
print(D.s())        # "static"
```

### 4.59 Mutable objects as dict keys — via hash

```python
d = {}
l = [1, 2]
# d[l] = "x"          # TypeError — list unhashable
d[tuple(l)] = "x"     # OK
d[1] = "one"
d[True] = "also"      # True == 1 — OVERWRITES d[1]!
print(d[1])           # "also"
```

### 4.60 `sys.getrefcount` & shared refs

```python
import sys
l = []
print(sys.getrefcount(l))    # 2 — the name + the call argument
l2 = l
print(sys.getrefcount(l))    # 3
```

### 4.61 `try`/`finally` in generators

```python
def gen():
    try:
        yield 1
        yield 2
    finally:
        print("cleanup")
g = gen()
print(next(g))     # 1
g.close()          # "cleanup" — close triggers finally
```

### 4.62 `sorted` with mixed types

```python
# sorted([1, "a"])     # TypeError — int vs str incomparable
print(sorted(["1", "a"]))      # ['1', 'a'] — same type OK
print(sorted([1, 2.0, True]))  # [1, 1, 2.0] — True == 1
```

### 4.63 `import` side effects & `__name__`

```python
# module.py
print("imported")          # runs at import time!
if __name__ == "__main__":  # only when run directly
    print("main")

# imported: prints "imported" once — cached in sys.modules
# second import is a no-op
```

### 4.64 `bytes` vs `str`

```python
s = "héllo"
print(len(s))               # 5 — CHARACTERS
b = s.encode("utf-8")
print(len(b))               # 6 — BYTES (é is 2 bytes)
# "a" + b"b"                # TypeError — can't mix str and bytes
print(b.decode() == s)      # True
```

### 4.65 `*` operator on dicts

```python
d1 = {"a": 1, "b": 2}
d2 = {"b": 3, "c": 4}
print({**d1, **d2})    # {'a':1, 'b':3, 'c':4} — later wins
print(d1 | d2)         # same — dict union (3.9+)
```

### 4.66 `+=` on immutable in function

```python
x = 5
def f():
    # x += 1        # UnboundLocalError — x read before local assignment
    global x
    x += 1
f()
print(x)       # 6
```

### 4.67 `range` object properties

```python
r = range(10)
print(len(r))            # 10
print(5 in r)            # True — O(1) membership
print(r[2])              # 2
print(r == range(10))    # True — range compares by VALUE
print(list(r[2:5]))      # [2, 3, 4]
```

### 4.68 Nested list multiplication

```python
grid = [[0] * 3] * 2     # SAME inner list repeated!
grid[0][0] = 9
print(grid)              # [[9, 0, 0], [9, 0, 0]] — both rows changed!

grid2 = [[0] * 3 for _ in range(2)]   # distinct inner lists
grid2[0][0] = 9
print(grid2)             # [[9, 0, 0], [0, 0, 0]]
```

### 4.69 String slicing & immutability of slices

```python
s = "hello"
t = s[:]
print(s == t, s is t)    # True True — full slice returns SAME object (optimization)
u = s[1:]
print(s, u)              # "hello" "ello" — slice creates new string
```

### 4.70 `else` in `while` with mutation

```python
n = 5
while n > 0:
    n -= 1
    if n == 3:
        continue
    print(n, end=" ")    # 4 2 1 0
else:
    print("| done")      # runs because loop condition failed (no break)
```

### 4.71 Recursion limit & deep copies

```python
import sys
print(sys.getrecursionlimit())    # typically 1000
# recursion beyond it -> RecursionError
```

### 4.72 `tuple` vs list in function signature

```python
def f(a, b): return a, b     # returns a TUPLE
print(type(f(1, 2)))         # <class 'tuple'>

def g(l=[]):                 # the mutable-default trap again
    l.append(1)
    return l
```

### 4.73 `__str__` vs `__repr__`

```python
class C:
    def __str__(self): return "str"
    def __repr__(self): return "repr"
c = C()
print(c)          # str — print uses __str__
print([c])        # [repr] — containers use __repr__
print(f"{c!r}")   # repr — !r forces repr
```

### 4.74 `os.path` & pathlib

```python
from pathlib import Path
p = Path("a") / "b" / "c.txt"
print(p)                # a/b/c.txt (platform sep)
print(p.suffix)         # .txt
print(p.stem)           # c
print(p.parent)         # a/b
```

### 4.75 `timeit` & list vs tuple allocation

```python
# tuples are smaller & faster to create than lists (immutable, fixed size)
import sys
print(sys.getsizeof((1, 2, 3)))   # smaller than list
print(sys.getsizeof([1, 2, 3]))
```

### 4.76 `while` `else` vs `for` `else` with break

```python
for i in range(5):
    if i == 2:
        break
else:
    print("A")       # NOT printed — break skips else

for i in range(5):
    pass
else:
    print("B")       # printed
```

### 4.77 Exception chaining `raise ... from`

```python
try:
    1 / 0
except ZeroDivisionError as e:
    raise ValueError("wrapped") from e   # shows BOTH tracebacks
```

### 4.78 `assert` & `__debug__`

```python
x = 5
assert x > 3, "too small"    # passes
# assert x > 10, "too big"   # AssertionError
# python -O disables ALL asserts — don't use for real validation
```

### 4.79 `eval`/`exec` & scope

```python
x = 10
eval("x + 1")            # 11
exec("y = 5")            # defines y in current scope
# eval("__import__('os').system('ls')")  # dangerous — never eval untrusted input
```

### 4.80 GIL & threading

```python
import threading
# threads share one GIL — CPU-bound Python threads don't run in parallel
# only I/O-bound threading helps; use multiprocessing for CPU work
```

---

## 5. Cross-Language Quick Comparison

| Trap | C | C++ | Java | Python |
|---|---|---|---|---|
| Integer division | `7/2 = 3` | `7/2 = 3` | `7/2 = 3` | `7/2 = 3.5`, `7//2 = 3` |
| Modulo sign | follows dividend | follows dividend | follows dividend | follows divisor |
| Overflow | UB (signed) | UB (signed) | silent wrap | never (big ints) |
| String mutable? | yes (char[]) | yes (`std::string`) | no | no |
| `==` on objects | n/a | default address (unless overloaded) | reference (unless overridden) | value (`__eq__`) |
| Pass semantics | by value | by value/ref/ptr | by value (refs are copies) | by object reference |
| Array bounds | no check | no check | checked (throws) | checked (IndexError) |
| `null` | NULL/0 | nullptr | null | None |
| Memory | manual | RAII/smart ptrs | GC | GC + refcount |
| `static` meaning | internal linkage/persist | class-level/persist | class-level | n/a (class attrs) |
| Default args evaluated | compile time | compile time | compile time | **at def time (runtime!)** |
