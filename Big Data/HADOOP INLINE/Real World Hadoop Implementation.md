Excellent question. Moving from "word count" (toy example) to **real production tasks** is where MapReduce truly shines. Let me give you a **real-world complex example** that actually runs in production at companies like Uber, Netflix, and Walmart.

---

## Real-World Production Example: Clickstream Analysis for E-commerce

### Business Problem
An e-commerce company (like Amazon/Flipkart) wants to analyze user behavior to answer:
1. **Most common path to purchase** (Which sequence of pages leads to a sale?)
2. **Abandonment points** (At which step do users leave?)
3. **Product recommendation** (Users who viewed X also viewed Y)

### Input Data: Raw Clickstream Logs (50 GB/day across 1000 web servers)

Each line is a JSON record from a user's click:

```json
{"user_id": "U1001", "session_id": "S789", "timestamp": "2024-01-15T10:30:22Z", "page": "/product/123", "action": "view", "product_id": "P123", "referrer": "/search?q=laptop"}
{"user_id": "U1001", "session_id": "S789", "timestamp": "2024-01-15T10:32:15Z", "page": "/cart", "action": "add_to_cart", "product_id": "P123", "quantity": 1}
{"user_id": "U1001", "session_id": "S789", "timestamp": "2024-01-15T10:35:40Z", "page": "/checkout", "action": "purchase", "order_id": "ORD999", "amount": 899}
{"user_id": "U2002", "session_id": "S790", "timestamp": "2024-01-15T10:31:10Z", "page": "/product/456", "action": "view", "product_id": "P456"}
{"user_id": "U2002", "session_id": "S790", "timestamp": "2024-01-15T10:33:20Z", "page": "/cart", "action": "add_to_cart", "product_id": "P456"}
{"user_id": "U2002", "session_id": "S790", "timestamp": "2024-01-15T10:35:00Z", "page": "/product/789", "action": "view", "product_id": "P789"}
{"user_id": "U2002", "session_id": "S790", "timestamp": "2024-01-15T10:38:00Z", "page": "/checkout", "action": "abandon_cart"}
{"user_id": "U3003", "session_id": "S791", "timestamp": "2024-01-15T10:40:00Z", "page": "/product/123", "action": "view", "product_id": "P123"}
{"user_id": "U3003", "session_id": "S791", "timestamp": "2024-01-15T10:45:00Z", "page": "/product/123", "action": "add_to_cart", "product_id": "P123"}
```

---

## High-Level MapReduce Flow for Sessionization & Path Analysis

This is a **multi-stage MapReduce pipeline** (3 jobs chained together).

```
Raw Logs (50GB on HDFS)
        │
        ▼
┌───────────────────────────────────────────────────────────────────┐
│                    JOB 1: SESSIONIZATION                          │
│  Goal: Group clicks into sessions, sort by timestamp              │
│  Input:  Raw JSON logs (unsorted, interleaved across users)       │
│  Output: SessionID → sorted sequence of clicks                    │
└───────────────────────────────────────────────────────────────────┘
        │
        ▼
┌───────────────────────────────────────────────────────────────────┐
│                    JOB 2: PATH CONSTRUCTION                       │
│  Goal: Convert each session into a page sequence                  │
│  Input:  Sorted session clicks                                    │
│  Output: Page transition (from_page → to_page) with count         │
└───────────────────────────────────────────────────────────────────┘
        │
        ▼
┌───────────────────────────────────────────────────────────────────┐
│                    JOB 3: FREQUENT PATH MINING                    │
│  Goal: Find most common 3-step sequences                          │
│  Input:  Page transitions with counts                             │
│  Output: Top 100 paths (page1 → page2 → page3) with frequency     │
└───────────────────────────────────────────────────────────────────┘
```

---

## Detailed Walkthrough of Each Job

### JOB 1: Sessionization (The "Group By" Problem)

**Challenge:** Logs are scattered across 1000 web servers, interleaved in time. We need all clicks from one user session together, in time order.

#### Mapper (JOB 1):
```java
Input: (byte_offset, json_line)

Mapper logic:
1. Parse JSON
2. Extract (session_id, timestamp, page, action, product_id)
3. Output: Key = session_id, Value = (timestamp, page, action, product_id)
```

**What Mapper emits (from our sample data):**

| Mapper Instance | Input Line | Output Key | Output Value |
|----------------|------------|------------|---------------|
| Mapper A (Node 1) | U1001 view P123 | S789 | (10:30:22, view, P123) |
| Mapper A (Node 1) | U1001 cart P123 | S789 | (10:32:15, add_to_cart, P123) |
| Mapper A (Node 1) | U1001 purchase | S789 | (10:35:40, purchase, ORD999) |
| Mapper B (Node 2) | U2002 view P456 | S790 | (10:31:10, view, P456) |
| Mapper B (Node 2) | U2002 cart P456 | S790 | (10:33:20, add_to_cart, P456) |
| Mapper B (Node 2) | U2002 view P789 | S790 | (10:35:00, view, P789) |
| Mapper B (Node 2) | U2002 abandon | S790 | (10:38:00, abandon_cart, null) |
| Mapper C (Node 3) | U3003 view P123 | S791 | (10:40:00, view, P123) |
| Mapper C (Node 3) | U3003 cart P123 | S791 | (10:45:00, add_to_cart, P123) |

#### Shuffle & Sort (JOB 1):
All records with same session_id go to same reducer, sorted by timestamp.

**Reducer 0 gets Session S789:**
```
S789: [(10:30:22, view, P123), (10:32:15, add_to_cart, P123), (10:35:40, purchase, ORD999)]
```

**Reducer 1 gets Session S790:**
```
S790: [(10:31:10, view, P456), (10:33:20, add_to_cart, P456), (10:35:00, view, P789), (10:38:00, abandon_cart, null)]
```

**Reducer 2 gets Session S791:**
```
S791: [(10:40:00, view, P123), (10:45:00, add_to_cart, P123)]
```

#### Reducer (JOB 1):
Output: SessionID → Sorted sequence as CSV string

```
Output of Job 1 (written to HDFS as intermediate data):
S789    view,P123|add_to_cart,P123|purchase,ORD999
S790    view,P456|add_to_cart,P456|view,P789|abandon_cart
S791    view,P123|add_to_cart,P123
```

---

### JOB 2: Path Construction (Session to Page Transitions)

**Goal:** Convert each session into page-to-page transitions.

#### Mapper (JOB 2):
Input from Job 1 output:
```
Key: S789, Value: view,P123|add_to_cart,P123|purchase,ORD999
```

**Mapper logic:** Split the sequence, emit each adjacent pair as (from_page → to_page)

| Session | Parse to pages | Emitted Transitions |
|---------|---------------|---------------------|
| S789 | [view/P123, add_to_cart/P123, purchase] | (view/P123 → add_to_cart/P123), (add_to_cart/P123 → purchase) |
| S790 | [view/P456, add_to_cart/P456, view/P789, abandon_cart] | (view/P456 → add_to_cart/P456), (add_to_cart/P456 → view/P789), (view/P789 → abandon_cart) |
| S791 | [view/P123, add_to_cart/P123] | (view/P123 → add_to_cart/P123) |

**Mapper output (key = transition, value = 1):**
```
(view/P123 → add_to_cart/P123, 1)  ← from S789
(add_to_cart/P123 → purchase, 1)   ← from S789
(view/P456 → add_to_cart/P456, 1)  ← from S790
(add_to_cart/P456 → view/P789, 1)  ← from S790
(view/P789 → abandon_cart, 1)      ← from S790
(view/P123 → add_to_cart/P123, 1)  ← from S791
```

#### Shuffle & Group (JOB 2):
```
(view/P123 → add_to_cart/P123): [1, 1]  ← 2 occurrences
(add_to_cart/P123 → purchase): [1]      ← 1 occurrence
(view/P456 → add_to_cart/P456): [1]
(add_to_cart/P456 → view/P789): [1]
(view/P789 → abandon_cart): [1]
```

#### Reducer (JOB 2):
Sum the counts for each transition.

**Output of Job 2:**
```
view/P123 → add_to_cart/P123    2
add_to_cart/P123 → purchase     1
view/P456 → add_to_cart/P456    1
add_to_cart/P456 → view/P789    1
view/P789 → abandon_cart        1
```

---

### JOB 3: Frequent Path Mining (3-Step Sequences)

**Goal:** Find the most common 3-page sequences (e.g., search → product → cart → checkout).

#### Mapper (JOB 3):
Reads the transitions and builds sliding windows.

```
Input transitions (from Job 2 output, but need raw sessions again):
Actually, Job 3 would read the raw session sequences from Job 1 output.

From S789: view/P123 → add_to_cart/P123 → purchase
3-step sequences: [view/P123, add_to_cart/P123, purchase]

From S790: view/P456 → add_to_cart/P456 → view/P789 → abandon_cart
3-step sequences: [view/P456, add_to_cart/P456, view/P789]
                 [add_to_cart/P456, view/P789, abandon_cart]

From S791: view/P123 → add_to_cart/P123
(not enough steps for 3-step sequence)
```

**Mapper output:**
```
([view/P123, add_to_cart/P123, purchase], 1)
([view/P456, add_to_cart/P456, view/P789], 1)
([add_to_cart/P456, view/P789, abandon_cart], 1)
```

#### Reducer (JOB 3):
Count frequencies and sort to find top paths.

**Final Output (Top paths):**
```
1. view/P123 → add_to_cart/P123 → purchase         1 session
2. view/P456 → add_to_cart/P456 → view/P789        1 session
3. add_to_cart/P456 → view/P789 → abandon_cart     1 session
```

**Business insight:** Users who view product P123 are likely to purchase after adding to cart. Users who view P456 often browse another product (P789) before abandoning.

---

## Other Real Production Tasks (Examples)

| Industry | Task | What MapReduce Does |
|----------|------|---------------------|
| **Netflix** | Recommendation Engine | Map: Find users with similar watch history. Reduce: Compute similarity scores, suggest movies. |
| **Uber** | Surge Pricing Analysis | Map: Group rides by time/location. Reduce: Calculate supply/demand ratio per region. |
| **Walmart** | Market Basket Analysis | Map: Find all items in each transaction. Reduce: Count item pairs that appear together (Apriori algorithm). |
| **Google** | PageRank (original) | Map: Distribute link votes from each page. Reduce: Calculate new PageRank scores iteratively. |
| **Facebook** | Friend Suggestions | Map: Find friends-of-friends. Reduce: Count mutual friends, recommend top N. |
| **Bank** | Fraud Detection | Map: Group transactions by user/card. Reduce: Detect patterns (multiple small transactions, location anomalies). |

---

## Detailed Production Example: Market Basket Analysis (Apriori)

**Problem:** Find products frequently bought together (e.g., {bread, butter} appears in 30% of transactions).

### Input: 1 TB of transaction data across 1000 stores

```
Transaction ID | Products
T1001          | {milk, bread, butter, eggs}
T1002          | {bread, butter, jam}
T1003          | {milk, bread, butter}
T1004          | {eggs, bacon, milk}
...
```

### MapReduce Flow:

#### Job 1: Find frequent items (support > 1%)
- **Map:** Emit (product, 1) for each product in each transaction
- **Reduce:** Sum counts, filter to products with support > threshold
- **Output:** {milk, bread, butter, eggs} (others filtered out)

#### Job 2: Find frequent pairs
- **Map:** For each transaction, generate all 2-item combinations from frequent items only
  - T1001: {milk,bread}, {milk,butter}, {milk,eggs}, {bread,butter}, {bread,eggs}, {butter,eggs}
  - Emit (pair, 1)
- **Reduce:** Sum counts, filter pairs with support > threshold
- **Output:** {milk,bread}: 5000, {bread,butter}: 4800, {milk,butter}: 4500

#### Job 3: Find association rules
- **Map:** For each frequent pair {A,B}, emit (A → B) and (B → A)
- **Reduce:** Calculate confidence = count(A,B) / count(A)
- **Output:** bread → butter (confidence = 96%), milk → bread (85%)

**Business action:** Place bread and butter near each other, offer "buy bread get butter discount."

---

## Key Differences: Production vs Toy Examples

| Aspect | Word Count (Toy) | Production Clickstream Analysis |
|--------|------------------|--------------------------------|
| **Input size** | KB | TB to PB |
| **Number of mappers** | 1-3 | 1000+ |
| **Number of reducers** | 1 | 50-200 |
| **Number of jobs** | 1 | 3-10 (chained) |
| **Data format** | Plain text | JSON, Avro, Parquet (compressed) |
| **Key complexity** | Simple string | Composite keys (session_id + timestamp) |
| **Custom logic** | None | Custom partitioner, combiner, sort comparator |
| **Failure handling** | Ignored | Speculative execution, automatic retries |
| **Output usage** | Display | Feed to dashboard, ML model, real-time system |

---

## What Actually Runs in Production (Stack)

```
┌─────────────────────────────────────────────────────────────┐
│                    PRODUCTION DATA PIPELINE                  │
├─────────────────────────────────────────────────────────────┤
│  Data Source → Kafka → Spark Streaming (real-time)          │
│                     ↓                                        │
│              HDFS (raw storage)                             │
│                     ↓                                        │
│              Hive/MapReduce (daily batch - 3 AM)            │
│                     ↓                                        │
│              Pig/Spark (ETL & transformation)               │
│                     ↓                                        │
│              HBase (serving layer for dashboards)           │
│                     ↓                                        │
│              Tableau/Dashboard (business users)             │
└─────────────────────────────────────────────────────────────┘
```

**Note:** In modern production, MapReduce is often replaced by **Spark** (10-100x faster) for iterative jobs, but MapReduce is still used for:
- Extremely large one-time batch jobs (>100 TB)
- Legacy systems
- ETL jobs that don't fit in memory

---

## Quick Summary

| Your Question | Answer |
|---------------|--------|
| **What real tasks use MapReduce?** | Sessionization, recommendations, fraud detection, market basket analysis, PageRank, log processing |
| **How complex are production jobs?** | 3-10 MapReduce jobs chained together, custom partitioners/combiners, 1000+ nodes |
| **What's the hardest part?** | Shuffle phase (network I/O) - 70% of job time often spent in shuffle |
| **Do companies still use MapReduce?** | Yes for batch, but migrating to Spark. New projects should use Spark. |

Would you like me to explain **how to optimize the shuffle phase** (combiner, compression, custom partitioner) or show a **real Pig/Hive script** that does this analysis in 10 lines instead of 3 MapReduce jobs?