There is no "magic number" where a query suddenly breaks, but in the industry, the rule of thumb is that performance starts to degrade noticeably after **5 to 7 JOINs**. Once you hit **10+ JOINs**, you are entering "danger zone" territory for most relational databases like PostgreSQL or MySQL.

The actual bottleneck depends on several factors beyond just the count.

---

## 1. The Optimizer's Complexity

The database **Query Optimizer** has to decide the most efficient order to join your tables ($A \to B \to C$ vs. $B \to C \to A$).

- The number of possible join permutations grows **factorially** ($n!$).
    
- For 3 tables, there are 6 possible paths.
    
- For 10 tables, there are **3,628,800** possible paths.
    
    If the number of joins is too high, the optimizer might spend more time "thinking" about how to run the query than actually executing it, or it might give up and pick a sub-optimal plan.
    

---

## 2. Factors That Move the Needle

How many joins you can handle depends on your schema design:

- **Indexing:** If you are joining on columns that aren't indexed, even **2 JOINs** can kill a database with a few million rows. If all foreign keys are properly indexed, 10 joins might still run in milliseconds.
    
- **Data Volume:** Joining two tables with 100 rows is trivial. Joining 5 tables where each has 10 million rows requires massive memory (RAM) for "Hash Joins" or "Merge Joins."
    
- **Result Set Size:** If your JOINs create a massive **Cartesian Product** (where one row in A matches 100 in B, which each match 100 in C), the intermediate data can bloat and crash the query.
    

---

## 3. When to Stop Joining and Start Refactoring

If you find your queries requiring double-digit joins, it’s usually a sign of one of two things:

### **Over-Normalization**

You may have broken your data down into too many tiny tables (e.g., having a separate table for `UserCity`, `UserState`, and `UserCountry` instead of one `Addresses` table).

- **Solution:** **Denormalization**. Add some redundant data to your main tables to reduce the need for joins.
    

### **The Wrong Tool for the Job**

If your data is a complex web of relationships (like a social network "friends of friends" query), SQL JOINs are the wrong tool.

- **Solution:** Use a **Graph Database** (like Neo4j). While SQL struggles with deep relationships, Graph DBs are designed to traverse thousands of connections per second.
    

---

## 4. Practical Limits by Database

- **MySQL:** Hard limit of **61 tables** in a single join (but you'll hit performance walls long before that).
    
- **PostgreSQL:** No hard limit, but it switches to a "Genetic Query Optimizer" (GEQO) after 12 tables by default because the standard math becomes too slow.
    
- **SQLite:** Typically limited to **64 joins**.
    

Since you've worked with **Django**, its ORM often hides these joins from you. Using `.select_related()` (which uses JOINs) is great for performance up to a point, but if you're pulling in too many related objects, switching to `.prefetch_related()` (which does separate smaller queries) is often the better "scaling" move.

Are you currently seeing slow response times on a specific project, or are you planning the architecture for something new?