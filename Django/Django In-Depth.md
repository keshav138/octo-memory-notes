## Django Deep Dive: Complete Interview Preparation Guide

This comprehensive guide covers Django from fundamentals to advanced concepts, with special focus on WSGI/ASGI, plus interview Q&A for each section. Later we'll map this to your specific project files.

---

## PART 1: Django Fundamentals (Must-Know for Any Level)

### 1.1 What is Django? (The Elevator Pitch)

> "Django is a high-level Python web framework that encourages rapid development and clean, pragmatic design. It follows the 'batteries-included' philosophy, providing everything from ORM to authentication out of the box." 

**Key differentiators:**
- **Batteries-included**: Admin panel, authentication, ORM, forms, caching, signals
- **Security-focused**: CSRF protection, XSS prevention, SQL injection protection
- **Scalable**: Powers Instagram, Pinterest, Mozilla, Disqus 

### 1.2 Django Architecture: MVT vs. MVC (Most Common Interview Question)

This is **the most frequently asked** Django concept. Here's exactly what to say:

| Traditional MVC | Django MVT | What it does |
|----------------|------------|--------------|
| Model | **Model** | Database structure and data access |
| View | **Template** | HTML presentation layer |
| Controller | **View** | Business logic, request handling |

**The Perfect Interview Answer:**

> "Django follows the MVT (Model-View-Template) pattern, which is Django's interpretation of MVC. The **Model** defines data structure, the **Template** handles presentation (like MVC's View), and the **View** contains business logic (like MVC's Controller). Django handles the controller logic internally via URL dispatchers." 

```
Request Flow:
Browser → URL Dispatcher → View (logic) → Model (DB) → Template (HTML) → Response
```

### 1.3 Project vs. App (Critical Distinction)

| Aspect | Project | App |
|--------|---------|-----|
| **Definition** | The entire website configuration | A specific module/feature |
| **Contains** | Settings, URLs, WSGI/ASGI config | Models, Views, Templates specific to feature |
| **Example** | `ecommerce_site/` | `products/`, `cart/`, `users/` |
| **Can have** | Multiple apps | Belongs to one project |

**Interview Answer**: "A project represents the entire web application, while apps are reusable components that provide specific functionality. For example, a blog project might have `posts`, `comments`, and `authors` apps. Apps can be reused across projects." 

### 1.4 Django Request/Response Lifecycle (Must Be Able to Diagram)

This is frequently asked in experienced interviews. Here's the step-by-step:

```
1. Client sends HTTP request
2. WSGI/ASGI server receives request (Gunicorn, Daphne, Uvicorn)
3. Middleware processes request (each has process_request)
4. URL dispatcher matches path to view
5. View executes (calls models, business logic)
6. View returns response (rendered template or JSON)
7. Middleware processes response (process_response)
8. WSGI/ASGI server sends HTTP response to client
```

**The Perfect Interview Answer**: 

> "When a request arrives, Django first processes it through middleware's `process_request` methods. Then the URL resolver finds a matching view function. The view interacts with models (via ORM) and returns an HttpResponse or rendered template. The response then goes through middleware's `process_response` before being sent to the client."

### 1.5 Django Interview Questions: Fundamentals

| Question | Answer |
|----------|--------|
| **What is Django ORM?** | Object-Relational Mapping that lets you interact with databases using Python instead of SQL. `User.objects.filter(age__gt=18)` instead of `SELECT * FROM users WHERE age > 18`  |
| **What are signals in Django?** | Allow decoupled apps to be notified when actions occur. Common: `post_save`, `pre_delete`. Used for things like sending welcome emails after user creation.  |
| **What databases does Django support?** | PostgreSQL (recommended), MySQL, SQLite (development), Oracle. PostgreSQL is preferred for production.  |
| **What's the Django Admin interface?** | Auto-generated, customizable admin panel from models. Access at `/admin`. Great for internal tools.  |
| **How do you see raw SQL from a QuerySet?** | `print(queryset.query)` shows the SQL Django generates.  |

---

## PART 2: Deep Dive on WSGI vs. ASGI (Your Requested Topic)

This is a **senior-level differentiator**. Understanding this shows deep Django knowledge.

### 2.1 What Are WSGI and ASGI? (The Foundation)

Both are **interfaces** between web servers and Python web applications (Django).

| Feature | WSGI | ASGI |
|---------|------|------|
| **Full name** | Web Server Gateway Interface | Asynchronous Server Gateway Interface |
| **Python standard since** | PEP 333 (2003) | PEP 3333 (2018) |
| **Code execution** | Synchronous only | Synchronous AND asynchronous |
| **Protocol support** | HTTP only | HTTP, HTTP/2, WebSocket, SSE |
| **Concurrency model** | One request per thread/process | Single thread with async event loop |
| **Use case** | Traditional web apps | WebSockets, long-polling, real-time |

**The Perfect Interview Answer**:

> "WSGI is the original Python standard for serving web applications synchronously. ASGI is the newer standard that adds asynchronous support, allowing Django to handle WebSockets, long-polling, and real-time features. For traditional HTTP requests, Django's ASGI handler can run synchronous code in threads, but ASGI truly shines when you need bidirectional communication or high concurrency." 

### 2.2 The WSGI Interface (Django's Default)

**How it works:**
```python
# This is what a WSGI application looks like
def application(environ, start_response):
    # environ: dict of HTTP request data
    # start_response: callable to send response headers
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [b'Hello World']
```

**Django's WSGI file** (`wsgi.py` - created by `startproject`):
```python
import os
from django.core.wsgi import get_wsgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
application = get_wsgi_application()  # This is the WSGI callable
```

**How to deploy WSGI:**
```bash
# Using Gunicorn (most common)
gunicorn myproject.wsgi:application --workers 4 --bind 0.0.0.0:8000

# Using uWSGI
uwsgi --http :8000 --module myproject.wsgi:application
```

**Limitations of WSGI:**
- One request per thread (thousands of threads = high memory)
- No WebSocket support
- Blocking I/O ties up threads

### 2.3 The ASGI Interface (Modern Django)

**How it works:**
```python
# This is what an ASGI application looks like
async def application(scope, receive, send):
    # scope: dict with request metadata (type: 'http' or 'websocket')
    # receive: async function to get request body
    # send: async function to send response
    
    await send({
        'type': 'http.response.start',
        'status': 200,
        'headers': [(b'content-type', b'text/html')],
    })
    await send({
        'type': 'http.response.body',
        'body': b'Hello World',
    })
```

**Django's ASGI file** (`asgi.py` - created by `startproject`):
```python
import os
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
application = get_asgi_application()  # This is the ASGI callable
```

**How to deploy ASGI:**
```bash
# Using Daphne (Django's ASGI reference server)
daphne myproject.asgi:application --bind 0.0.0.0 --port 8000

# Using Uvicorn (faster)
uvicorn myproject.asgi:application --host 0.0.0.0 --port 8000

# Using Hypercorn
hypercorn myproject.asgi:application --bind 0.0.0.0:8000
``` 

### 2.4 ASGI Middleware (Advanced)

You can wrap Django's ASGI application with custom ASGI middleware:

```python
# In asgi.py
from some_asgi_library import AmazingMiddleware

application = get_asgi_application()
application = AmazingMiddleware(application)  # Wrap it
``` 

**Important Warning from Django Docs**:

> "While Django's default ASGI handler will run all your code in a synchronous thread, if you choose to run your own async handler you must be aware of async-safety. Do not call blocking synchronous functions or libraries in any async code." 

### 2.5 When to Use WSGI vs. ASGI (Interview Gold)

| Use WSGI When... | Use ASGI When... |
|------------------|------------------|
| Traditional request/response web app | Need WebSockets (chat, live updates) |
| REST API without long polling | Server-Sent Events (SSE) |
| Running in production with Gunicorn | Need HTTP/2 multiplexing |
| Compatibility with older servers | High concurrency with many idle connections |
| Simpler deployment | Building real-time features |

**The Pro Answer**: "For most Django projects, you can deploy with WSGI today and migrate to ASGI later. But if you're starting fresh with real-time requirements (chat, notifications, live dashboards), start with ASGI. Django's ASGI handler can run your existing synchronous code in threads, so the migration is backward compatible." 

### 2.6 WSGI/ASGI Interview Questions

| Question | Answer |
|----------|--------|
| **What's the difference between WSGI and ASGI?** | WSGI is synchronous-only, handles HTTP only. ASGI supports async, WebSockets, HTTP/2, and multiple protocols.  |
| **When should you choose ASGI over WSGI?** | When you need WebSockets, long-polling, or high concurrency with many idle connections (like a chat server). |
| **Can Django use both?** | Yes. Django provides both `wsgi.py` and `asgi.py`. Your deployment server chooses which interface to use.  |
| **Does ASGI make Django faster for regular HTTP?** | Not significantly. The main benefit is concurrency, not raw speed. For CPU-bound tasks, you still need multiple workers. |
| **What ASGI servers can I use?** | Daphne (Django's reference), Uvicorn (fastest), Hypercorn.  |

---

## PART 3: Django Project Structure (For Your File-by-File Review)

### 3.1 Standard Django Project Layout

```
myproject/                    # PROJECT root
├── manage.py                 # CLI utility for Django commands
├── requirements.txt          # Python dependencies
├── .env                      # Environment variables (SECRET_KEY, DEBUG, DB)
├── myproject/                # PROJECT CONFIG directory
│   ├── __init__.py
│   ├── settings.py           # All configuration
│   ├── urls.py               # Root URL routing
│   ├── wsgi.py               # WSGI entry point
│   └── asgi.py               # ASGI entry point (if using async)
├── apps/                     # All Django apps (organized)
│   ├── users/                # APP: user management
│   │   ├── __init__.py
│   │   ├── admin.py
│   │   ├── apps.py
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── serializers.py    # DRF serializers (if using DRF)
│   │   ├── forms.py
│   │   └── tests.py
│   └── blog/                 # APP: blog functionality
│       ├── __init__.py
│       ├── admin.py
│       ├── models.py
│       ├── views.py
│       ├── urls.py
│       └── tests.py
├── static/                   # Static files (CSS, JS, images)
│   ├── css/
│   ├── js/
│   └── images/
├── staticfiles/              # Collected static files (production)
├── media/                    # User-uploaded files
├── templates/                # Project-level templates
│   ├── base.html
│   └── 404.html
└── logs/                     # Application logs
```

### 3.2 Critical Template Directory Pattern (Common Interview Trap)

**The Problem**: Two apps both have `index.html`. Which one wins? 

**Bad structure (causes conflicts):**
```
blog/
  templates/
    post_list.html      # Referenced as "post_list.html"
forum/
  templates/
    post_list.html      # Same name! Conflicts!
```

**Good structure (namespace by app):**
```
blog/
  templates/
    blog/               # Namespace folder
      post_list.html    # Referenced as "blog/post_list.html"
forum/
  templates/
    forum/              # Namespace folder
      post_list.html    # Referenced as "forum/post_list.html"
```

**Why this matters**: Django searches `INSTALLED_APPS` in order. Without namespacing, the first matching template wins - likely the wrong one. 

**Interview Question**: "How do you avoid template name conflicts?"
**Answer**: "Use app-namespaced template directories: `app/templates/app/template.html` and reference as `app/template.html`. This ensures templates from different apps don't collide."

### 3.3 Key Files Explained (For Your Review)

| File | Purpose | What Interviewers Ask |
|------|---------|----------------------|
| `manage.py` | Django CLI wrapper | "What's the difference between `django-admin` and `manage.py`?" (manage.py sets project settings) |
| `settings.py` | All configuration | "How do you manage settings across environments?" (Use environment variables + separate files) |
| `urls.py` | URL routing | "What's the difference between `path()` and `re_path()`?" (path for simple, re_path for regex) |
| `models.py` | Database structure | "What's the difference between `OneToOneField` and `ForeignKey`?" |
| `views.py` | Request/response logic | "Function-based vs Class-based views: when to use each?" |
| `admin.py` | Admin panel config | "How do you customize the Django admin?" |
| `forms.py` | Form validation | "When would you use a Form vs a ModelForm?" |

---

## PART 4: Core Components Deep Dive

### 4.1 Django ORM (Most Tested Topic)

**Basic CRUD Operations:**
```python
# CREATE
user = User.objects.create(username='john', email='john@example.com')

# READ (Multiple)
users = User.objects.filter(is_active=True)

# READ (Single)
user = User.objects.get(id=1)  # Raises DoesNotExist if not found

# UPDATE
User.objects.filter(id=1).update(email='new@example.com')

# DELETE
User.objects.filter(is_active=False).delete()
```

**Common Query Patterns (Interview Favorites):**

| Requirement | ORM Code |
|-------------|----------|
| Greater than | `User.objects.filter(age__gt=18)` |
| Contains (case-insensitive) | `User.objects.filter(name__icontains='john')` |
| In a list | `User.objects.filter(id__in=[1,2,3])` |
| Between values | `User.objects.filter(created_at__range=(start_date, end_date))` |
| Exclude | `User.objects.exclude(is_active=False)` |
| Order by | `User.objects.order_by('-created_at')` (descending) |
| Limit/Offset | `User.objects.all()[10:20]` |

**The N+1 Query Problem (Critical Interview Topic):**

```python
# PROBLEM: N+1 queries (1 for books + N for each author)
books = Book.objects.all()
for book in books:
    print(book.author.name)  # Hits DB for each book!

# SOLUTION 1: select_related (for ForeignKey relationships)
books = Book.objects.select_related('author').all()
for book in books:
    print(book.author.name)  # Single JOIN query

# SOLUTION 2: prefetch_related (for ManyToMany/Reverse relationships)
authors = Author.objects.prefetch_related('books').all()
```

**Interview Question**: "Explain the N+1 problem and how Django solves it."
**Answer**: "The N+1 problem occurs when you query for N objects, then access a related field on each, resulting in N+1 database hits. Django provides `select_related()` for ForeignKey relationships (uses SQL JOIN) and `prefetch_related()` for ManyToMany/reverse relationships (uses separate query + Python joining)."

### 4.2 Views: Function-Based vs. Class-Based (The Great Debate)

| Aspect | Function-Based Views (FBV) | Class-Based Views (CBV) |
|--------|---------------------------|------------------------|
| **Simplicity** | Very simple, explicit | Complex, requires inheritance knowledge |
| **Code reuse** | Hard (decorators, helpers) | Easy (mixins, inheritance) |
| **Readability** | Clear flow | Can be magical |
| **Best for** | Simple pages, API endpoints | CRUD operations, forms, repeated patterns |
| **Built-in** | Minimal | ListView, DetailView, FormView, CreateView, etc. |

**FBV Example:**
```python
def book_list(request):
    books = Book.objects.all()
    return render(request, 'books/list.html', {'books': books})
```

**CBV Example:**
```python
class BookListView(ListView):
    model = Book
    template_name = 'books/list.html'
    context_object_name = 'books'
    paginate_by = 20
```

**Interview Answer**: "I use FBV for simple, unique views where the logic is clear and won't be reused. I use CBV with mixins for CRUD operations, form handling, and any pattern that repeats across multiple views - they dramatically reduce boilerplate once you understand the inheritance chain."

### 4.3 Middleware (The Request/Processing Pipeline)

**Common built-in middleware:**
- `SecurityMiddleware`: Security headers
- `SessionMiddleware`: Session management
- `CommonMiddleware`: URL normalization
- `CsrfViewMiddleware`: CSRF protection
- `AuthenticationMiddleware`: Associates user with requests

**Custom Middleware Example:**
```python
# middleware.py
class RequestLoggingMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Process request (before view)
        print(f"Request: {request.method} {request.path}")
        
        response = self.get_response(request)  # Call view
        
        # Process response (after view)
        print(f"Response: {response.status_code}")
        return response
```

**Interview Question**: "What's middleware used for?"
**Answer**: "Middleware provides a way to process requests globally before they reach views and responses before they're sent to clients. Common uses: authentication, logging, CORS, security headers, request/response compression, and rate limiting." 

### 4.4 Django REST Framework (DRF) - For API Interviews

Since you mentioned backend focus, DRF is essential:

| DRF Component | Purpose | Example |
|---------------|---------|---------|
| **Serializer** | Converts complex data (models) to/from JSON | `UserSerializer` |
| **ViewSet** | Groups CRUD operations | `ModelViewSet` for full CRUD |
| **Router** | Auto-generates URLs from ViewSets | `DefaultRouter()` |
| **Permissions** | Access control | `IsAuthenticated`, `IsAdminUser` |
| **Authentication** | API auth methods | Token, JWT, Session |

**Basic DRF Setup:**
```python
# serializers.py
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email']

# views.py
class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]

# urls.py
router = DefaultRouter()
router.register('users', UserViewSet)
urlpatterns = router.urls
```

**Interview Question**: "Difference between Django and Django REST Framework?"
**Answer**: "Django is a full-stack web framework for building HTML websites with templates. DRF is an extension that adds tools for building RESTful APIs - serializers, view sets, authentication classes, and browsable APIs. You can use both together or DRF standalone for API-only backends." 

---

## PART 5: Intermediate to Advanced Topics

### 5.1 Authentication & Authorization

| Concept | Django Implementation |
|---------|----------------------|
| **Authentication** | Who they are - `django.contrib.auth` |
| **Authorization** | What they can do - Permissions & Groups |
| **Session Auth** | Default for web apps (cookie-based) |
| **Token Auth** | For APIs (DRF's TokenAuthentication) |
| **JWT Auth** | Stateless tokens (djangorestframework-simplejwt) |

**Permission Classes in DRF:**
```python
from rest_framework.permissions import IsAuthenticated, IsAdminUser, AllowAny

class OrderViewSet(viewsets.ModelViewSet):
    def get_permissions(self):
        if self.action == 'create':
            return [IsAuthenticated()]  # Any logged-in user can create
        elif self.action == 'destroy':
            return [IsAdminUser()]      # Only admins can delete
        return [AllowAny()]              # Anyone can view
```

### 5.2 Caching Strategies in Django

Django supports multiple cache backends :

| Cache Backend | Use Case |
|---------------|----------|
| **Memcached** | Production, distributed, fast |
| **Redis** | Production, more features (sessions, rate limiting) |
| **Database** | Small sites, single server |
| **File-based** | Development, no external deps |
| **Local-memory** | Per-process, fastest but not shared |

**Cache usage patterns:**
```python
from django.core.cache import cache

# Low-level cache API
cache.set('my_key', 'hello', timeout=300)
value = cache.get('my_key')

# Per-view cache
from django.views.decorators.cache import cache_page

@cache_page(60 * 15)  # Cache for 15 minutes
def blog_list(request):
    ...

# Template fragment caching
{% load cache %}
{% cache 500 sidebar request.user.id %}
    <!-- Expensive sidebar content -->
{% endcache %}
```

### 5.3 Signals (Loose Coupling)

**Common use cases:**
```python
from django.db.models.signals import post_save
from django.dispatch import receiver

@receiver(post_save, sender=User)
def send_welcome_email(sender, instance, created, **kwargs):
    if created:  # Only on first creation
        send_mail('Welcome!', 'Thanks for joining', ...)

@receiver(post_save, sender=Order)
def update_inventory(sender, instance, **kwargs):
    for item in instance.items.all():
        item.product.stock -= item.quantity
        item.product.save()
```

**When NOT to use signals**: Heavy processing, external API calls, anything that should be visible in the main flow.

### 5.4 Common Security Features (Django Does This For You)

| Threat | Django's Protection |
|--------|---------------------|
| **SQL Injection** | ORM uses parameterized queries |
| **XSS** | Templates auto-escape variables |
| **CSRF** | CSRF middleware + tokens in forms |
| **Clickjacking** | X-Frame-Options middleware |
| **SSL/HTTPS** | SecurityMiddleware can redirect |

**Interview Question**: "How does Django prevent SQL injection?"
**Answer**: "Django's ORM uses parameterized queries, which separate SQL code from data. Even when using `raw()` queries, you should pass parameters as a list rather than interpolating strings. Never use string formatting to build SQL queries." 

---

## PART 6: Django Interview Questions by Category

### Beginner Level Questions

| Question | Answer |
|----------|--------|
| **How do you create a new Django project?** | `django-admin startproject projectname` |
| **How do you create a new app?** | `python manage.py startapp appname` |
| **What's the difference between `django-admin` and `manage.py`?** | `manage.py` is project-specific and sets `DJANGO_SETTINGS_MODULE` automatically. `django-admin` is global.  |
| **What command runs the development server?** | `python manage.py runserver` |
| **How do you create database tables from models?** | `python manage.py makemigrations` then `python manage.py migrate` |
| **What's a QuerySet?** | A collection of database queries to retrieve objects. QuerySets are lazy - they don't hit the DB until evaluated.  |

### Intermediate Level Questions

| Question | Answer |
|----------|--------|
| **Explain Django's MVT architecture.** | Model (data), View (logic), Template (presentation). Django's version of MVC.  |
| **What are Django migrations?** | Migrations track changes to models and apply them to the database schema. They're Python files in `app/migrations/`. |
| **How do you handle static files in production?** | `python manage.py collectstatic` gathers all static files into `STATIC_ROOT`. Configure web server (Nginx/Apache) or CDN to serve them.  |
| **What's the purpose of `select_related` and `prefetch_related`?** | Optimize database queries. `select_related` for ForeignKey (JOIN). `prefetch_related` for ManyToMany/reverse (separate query). |
| **How do you implement custom user models?** | Create model inheriting from `AbstractUser` or `AbstractBaseUser`, set `AUTH_USER_MODEL` in settings. **Do this before first migration.** |

### Advanced/Senior Level Questions

| Question | Answer |
|----------|--------|
| **Explain WSGI vs ASGI.** | WSGI is synchronous, HTTP-only. ASGI supports async, WebSockets, HTTP/2. Django supports both via `wsgi.py` and `asgi.py`.  |
| **How do you optimize database performance in Django?** | `select_related`/`prefetch_related`, add `db_index` to filtered fields, use `only()`/`defer()`, implement caching, use `explain()` to analyze queries.  |
| **What caching strategies does Django support?** | Per-view, template fragment, low-level cache API. Backends: Memcached, Redis, DB, file, local-memory.  |
| **How do you handle concurrent requests on a single product?** | Use `select_for_update()` to lock rows, or use atomic transactions with version fields. For high scale, use Redis distributed locks.  |
| **Describe Django's request/response cycle in detail.** | WSGI/ASGI → Middleware (request) → URL dispatcher → View → Middleware (response) → WSGI/ASGI response.  |

### Scenario-Based Questions

| Scenario | Answer |
|----------|--------|
| **User reports slow dashboard. How do you debug?** | 1. Enable `DEBUG` to see SQL queries. 2. Check for N+1 queries. 3. Use Django Debug Toolbar. 4. Add `select_related`/`prefetch_related`. 5. Consider caching. |
| **API endpoint getting 10,000 requests/second. How do you scale?** | 1. Add caching (Redis). 2. Use read replicas for DB. 3. Add more Gunicorn workers. 4. Implement rate limiting. 5. Use CDN for static content. |
| **How do you handle a third-party API that's slow?** | Use async tasks (Celery). Return 202 Accepted immediately, process webhook, or implement polling with status endpoint.  |

---

## PART 7: Quick Reference Cheat Sheet

### Django Commands

| Command | Purpose |
|---------|---------|
| `django-admin startproject name` | Create new project |
| `python manage.py startapp name` | Create new app |
| `python manage.py runserver` | Start dev server |
| `python manage.py makemigrations` | Create migration files |
| `python manage.py migrate` | Apply migrations |
| `python manage.py createsuperuser` | Create admin user |
| `python manage.py shell` | Django-aware Python shell |
| `python manage.py collectstatic` | Collect static files |
| `python manage.py test` | Run tests |

### Settings Patterns

```python
# Environment-specific settings
import os

DEBUG = os.environ.get('DEBUG', 'False') == 'True'
SECRET_KEY = os.environ.get('DJANGO_SECRET_KEY')

# Database configuration
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.environ.get('DB_NAME'),
        'USER': os.environ.get('DB_USER'),
        'PASSWORD': os.environ.get('DB_PASSWORD'),
        'HOST': os.environ.get('DB_HOST'),
        'PORT': os.environ.get('DB_PORT', '5432'),
    }
}
```

---

## Next Steps: Your Project Review

Now that you have the complete Django reference, we can go through your project **file by file**. Tell me:

1. **Your project structure** - Send me the output of `tree` or list your directories
2. **Specific files you want to review** - `models.py`, `views.py`, `settings.py`, etc.
3. **Areas you're concerned about** - Performance, security, patterns, testing

I'll help you:
- Identify potential interview questions from YOUR code
- Suggest improvements and best practices
- Prepare explanations for your architecture decisions
- Practice answering "why did you do it this way?"

Ready when you are!