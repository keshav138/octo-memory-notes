You have a massive advantage going into this interview: you didn't just follow a tutorial; you engineered a system to solve real business problems (like the Agile offboarding logic). Interviewers aren't just looking for correct syntax; they want to see that you understand the trade-offs of your architectural decisions.

Here is your comprehensive interview cheat sheet, broken down by the phases of your project, followed by general "must-know" Django questions.

### Phase 1: Relational Foundation & Authentication

**Q1: Why did you choose JWTs over standard Django session cookies?**

- **The Trap:** They want to see if you understand statelessness versus stateful architectures.
    
- **The Answer:** "I chose JWTs to keep the backend completely stateless, which makes scaling easier and perfectly decouples the API from the Vanilla JS frontend. Since the server doesn't have to look up a session ID in the database for every request, it reduces database load. However, I know JWTs have a downside—they can't be easily revoked before they expire. That's why I implemented a dual-token system (short-lived access token, long-lived refresh token) and utilized a token blacklist for the logout view."
    

**Q2: In your database design, when would you use `on_delete=CASCADE` versus `SET_NULL`?**

- **The Trap:** Testing your understanding of referential integrity vs. historical data preservation.
    
- **The Answer:** "`CASCADE` is for strict dependencies. For example, if a `Project` is deleted, its `Tasks` must be deleted too, because a task can't exist without a project. I use `SET_NULL` (or handle it manually in business logic) for historical integrity. For instance, when we remove a user from a project team, I explicitly _didn't_ cascade delete the tasks they created. Instead, I reassigned the workload and preserved their name as the original reporter so we didn't destroy the project's audit trail."
    

---

### Phase 2: The RESTful API Layer

**Q3: What is the "N+1 Query Problem," and how did you prevent it in your API?**

- **The Trap:** This is the most frequently asked Django ORM question. If you don't know it, it's a red flag.
    
- **The Answer:** "The N+1 problem happens when the ORM executes one query to fetch a list of items, and then an additional query for each item to fetch related data (like fetching 50 tasks, and then hitting the DB 50 more times to get the assignee's username). I solved this in my `TaskViewSet` by overriding `get_queryset` and using `select_related('assigned_to')` for foreign keys, and `prefetch_related('team_members')` for Many-to-Many fields. This reduces 51 database hits down to just 1 or 2."
    

**Q4: Why use DRF `ViewSets` and `Routers` instead of writing individual API views?**

- **The Trap:** Checking if you understand DRY (Don't Repeat Yourself) principles and standard REST conventions.
    
- **The Answer:** "ViewSets handle standard CRUD operations natively, which keeps the codebase DRY and ensures the API adheres strictly to REST conventions. It keeps `urls.py` completely clean. For business logic that falls outside standard CRUD—like marking a task complete or assigning a user—I used the `@action` decorator to create custom routing, ensuring all logic related to Tasks stayed encapsulated within the `TaskViewSet`."
    

---

### Phase 3: Event-Driven Business Logic

**Q5: When transferring a removed user's tasks, why did you use `Task.objects.filter().update()` instead of looping through the tasks and calling `.save()` on each?**

- **The Trap:** Testing your knowledge of database optimization and Django's memory handling.
    
- **The Answer:** "Using `.update()` translates directly to a single SQL `UPDATE` statement at the database level. It is incredibly fast. If I looped through the tasks and called `.save()`, it would pull every single task into Python memory, instantiate a model object, and hit the database individually. If the user had 1,000 tasks, `.save()` would cause a massive memory spike and 1,000 database hits; `.update()` does it in milliseconds with one hit."
    

**Q6: What are the risks of using Django Signals?**

- **The Trap:** Signals feel like magic, but senior engineers know they can be dangerous.
    
- **The Answer:** "Signals are great for decoupling logic—like triggering my WebSocket notifications without cluttering my Views. However, they have two main risks. First, they obscure the control flow, making debugging harder because the trigger happens invisibly. Second, standard Django signals are synchronous. If my notification logic fails or takes too long, it will block the main thread and prevent the actual Task from saving. For a massive scale, I would move that logic out of signals and into an asynchronous task queue like Celery."
    

---

### Phase 4: The Real-Time Engine (WebSockets)

**Q7: Explain why you needed Redis to make WebSockets work in Django Channels.**

- **The Trap:** Seeing if you actually understand the architecture, or if you just copied a Channels tutorial.
    
- **The Answer:** "Django Channels runs on Daphne, and usually, you have multiple Daphne worker processes running. If User A is connected via WebSocket to Worker 1, and User B sends an HTTP request to Worker 2 that assigns a task to User A, Worker 2 has no way to talk to Worker 1. Redis acts as the centralized message broker (Pub/Sub). Worker 2 yells the notification into Redis, Redis broadcasts it to all workers, and Worker 1 hears it and pushes the data down User A's open WebSocket."
    

**Q8: Explain what `async` and `await` actually do under the hood.**

- **The Trap:** Checking your fundamental understanding of asynchronous Python.
    
- **The Answer:** "In synchronous code, if a function requests data from a database, the entire server thread freezes and waits for the response. `async` tells Python that a function might pause. `await` is the actual pause button. When the code hits `await self.send()`, it yields control back to the server's event loop, saying 'I'm waiting for network I/O; go handle other users' requests while I wait.' It prevents long-lived WebSocket connections from monopolizing server resources."
    

---

### General "Must-Know" Django Backend Questions

**Q9: What is Django Middleware, and give an example of when you would use it.**

- **The Answer:** "Middleware is a series of hooks that process requests globally before they reach the View, and responses before they return to the client. It's like an onion the request has to pass through. In my project, I wrote custom ASGI middleware for WebSockets because standard token authentication reads HTTP headers, which WebSockets don't support well. My middleware intercepted the connection, parsed the JWT from the query string, verified it, and attached the `User` object to the connection scope before it reached the Consumer."
    

**Q10: "Fat Models, Thin Views" is a common Django mantra. What does it mean?**

- **The Answer:** "It means your Views should only handle the mechanics of the HTTP request and response (parsing input, checking permissions, returning JSON/HTML). Your core business logic should live in the Models (or in separate Service layers). For example, a method to calculate a project's completion percentage shouldn't be written inside the `ProjectViewSet`; it should be a property or method on the `Project` model itself, so it can be reused anywhere in the app, like the admin panel or a background task."
    

**Q11: How does Django prevent SQL Injection?**

- **The Answer:** "Django’s ORM parameterizes queries under the hood. When you write `User.objects.get(username=user_input)`, Django doesn't just concatenate that string into the raw SQL. It sends the SQL query and the user input to the database driver separately, completely neutralizing any malicious SQL commands hidden in the input. You only risk SQL injection in Django if you actively use `RawSQL` or `.raw()` and manually format strings into the query."
    

---

**How are you feeling about explaining the transition from standard HTTP to the ASGI/WebSocket infrastructure? We can drill deeper into that specific "layer cake" if it still feels fuzzy.**