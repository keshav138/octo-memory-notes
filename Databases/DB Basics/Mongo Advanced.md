This is a classic "last-minute" sprint, and MongoDB interviews for backend roles often focus on **how** you use it, not just **what** it is. Since you have limited time, let's focus on high-yield concepts, tricky behaviors, and the situational questions that trip up freshers.

Here is your MongoDB cram session.

---

### 1. Core Philosophy: BSON & Document Structure
Unlike SQL (tables/rows), MongoDB stores **Documents** (JSON-like) in **Collections**.
- **BSON:** Binary JSON. It supports data types that JSON doesn't (e.g., `Date`, `ObjectId`, `Decimal128`).
- **`_id`:** Every document must have a unique `_id`. If you don't provide one, MongoDB auto-generates an `ObjectId` (12-byte: timestamp + machine ID + process ID + counter). *You can extract the timestamp from an ObjectId without storing a separate `createdAt` field.*

### 2. Advanced CRUD Mechanics
The interview isn’t about `find()` and `insert()`. It’s about the modifiers and options.

#### `$inc` (Atomic Updates)
Used for counters, votes, etc. **Crucial:** It must be used with `$inc` on a number field. If the field doesn’t exist, it creates it.
```javascript
// Increment views by 1. Atomic.
db.articles.updateOne({ _id: 1 }, { $inc: { views: 1 } });
```
**Situational:** *"If 1000 users click an article simultaneously, how do you prevent data loss?"*
**Answer:** Use `$inc`. It is an atomic operation at the document level. MongoDB uses **document-level locking** (since WiredTiger engine), so each update is isolated.

#### `$exists` (Handling Sparse Data)
Used to find documents where a field is present or missing.
```javascript
// Find users who haven't set a profile picture (field missing)
db.users.find({ profile_pic: { $exists: false } });
```
**Situational:** *"Why is using `$exists` on a non-indexed field slow?"*
**Answer:** It requires a COLLSCAN (scanning every document) because the index only stores existing keys; checking for *non-existence* is inefficient unless the field is indexed.

#### `$set` vs `$unset`
- `$set`: Adds or updates fields.
- `$unset`: Removes a field.

#### `upsert: true`
A powerful option for `updateOne`/`updateMany`. If no document matches the filter, it creates a new one using the filter + the update data.
**Situational:** *"You need to track unique page views per day. If the record doesn't exist for today, create it; if it does, increment it."*
**Answer:**
```javascript
db.stats.updateOne(
  { date: "2023-10-27", page: "/home" },
  { $inc: { views: 1 } },
  { upsert: true } // Creates the doc if it doesn't exist
);
```

---

### 3. Aggregation Pipeline (The Heavy Hitter)
This is the most common "coding" section of a backend test. Think of it as the MongoDB equivalent of SQL `GROUP BY`, `JOIN`, and `WHERE` combined.
The pipeline flows left to right: `[Stage 1] -> [Stage 2] -> [Stage 3]`.

#### Key Stages:
1.  **`$match`:** Filtering. **Best Practice:** Put `$match` as early as possible to reduce the number of documents flowing into the pipeline. Use indexes here.
2.  **`$group`:** Grouping. Similar to SQL `GROUP BY`. Requires an `_id` field defining the group key.
    - *Accumulators:* `$sum`, `$avg`, `$push` (creates an array), `$first`, `$last`.
3.  **`$unwind`:** Deconstructs an array. If a document has an array of tags, `$unwind` creates one document per tag.
    - **Situational:** *"What happens if the array is empty?"*
    - **Answer:** By default, the document is dropped. To preserve it, use `{ $unwind: { path: "$array", preserveNullAndEmptyArrays: true } }`.
4.  **`$lookup`:** The "JOIN" operation. Performs a left outer join with another collection in the same database.
    ```javascript
    // Join orders with users
    {
      $lookup: {
        from: "users",
        localField: "userId",
        foreignField: "_id",
        as: "userDetails"
      }
    }
    ```
    *Note:* The output `userDetails` is an **array** (even if one match) because MongoDB allows multiple matches.
5.  **`$project`:** Reshapes documents (include/exclude fields, rename, compute new fields).
6.  **`$addFields`:** Adds new fields without removing existing ones (unlike `$project` which requires you to specify all fields).

#### Complex Aggregation Example (Situational)
**Question:** *"You have an `orders` collection. Each order has `userId`, `items` (array), and `total`. Find the top 3 users by total spending, but only include users who have purchased more than 5 items in total (across all orders)."*

**Answer:**
```javascript
db.orders.aggregate([
  // Stage 1: Unwind items to count them individually
  { $unwind: "$items" },
  // Stage 2: Group by user to sum totals and count items
  {
    $group: {
      _id: "$userId",
      totalSpent: { $sum: "$total" }, // Note: This double counts if total is per order? Careful.
      totalItems: { $sum: 1 }
    }
  },
  // Stage 3: Filter users with >5 items
  { $match: { totalItems: { $gt: 5 } } },
  // Stage 4: Sort and limit
  { $sort: { totalSpent: -1 } },
  { $limit: 3 }
]);
```
*(Interviewers look for you to realize `$sum: "$total"` inside a `$group` after an `$unwind` might double-count. Usually, you'd `$group` by order first, then by user, but the above is the quick answer.)*

---

### 4. Index Optimization (Performance)
Without indexes, MongoDB scans every document (COLLSCAN). This kills performance.

#### Types:
- **Single Field:** Standard index.
- **Compound Index:** Index on multiple fields (e.g., `{ last_name: 1, first_name: 1 }`).
- **Multikey Index:** Automatically created when you index an array field. MongoDB indexes each element of the array.
- **Text Index:** For search functionality.

#### The Rules:
1.  **ESR Rule (Equality, Sort, Range):** When building a compound index, place fields you do **equality** checks on first, then fields for **sorting**, then fields for **range** queries (`$gt`, `$lt`).
2.  **Covered Query:** If the index contains **all** the fields requested in the query *and* you exclude `_id` (`{_id: 0}`), MongoDB never touches the actual document. It reads only from RAM (index). Extremely fast.
3.  **Sorting:** If you sort on a field not in the index, MongoDB performs a blocking sort (in-memory). If the result set exceeds 32MB, it throws an error.

**Situational:** *"I have a query: `db.users.find({ age: { $gt: 18 }, status: "active" }).sort({ name: 1 })`. What index should I create?"*
**Answer:** `{ status: 1, name: 1, age: 1 }`. (Equality `status` first, then `name` for sort, then range `age` last). If you put `age` before `name`, MongoDB cannot use the index for sorting efficiently.

---

### 5. Replication Set Architecture (High Availability)
This is the "architecture" part. A fresher is expected to know the roles, not just "it replicates data."

#### Components:
- **Primary:** The only node that accepts write operations. Records all changes to the **Oplog** (operations log).
- **Secondary:** Replicates data from the Primary by tailing the Oplog. Can serve read operations (if `readPreference` allows).
- **Arbiter:** A lightweight node. **Does not hold data.** It participates in elections to break ties (e.g., 2 nodes can't agree on a Primary, Arbiter votes to decide). *Avoid arbiters if possible; use 3 data-bearing nodes.*

#### Failover:
If the Primary goes offline, an election occurs (usually 5-12 seconds). A Secondary becomes the new Primary. Writes fail during this window unless you configure write concerns.

#### Write Concern & Read Concern (Data Consistency)
- **Write Concern (`w`):** Acknowledgment level.
    - `w: 1` : Acknowledged by Primary only (default).
    - `w: "majority"` : Acknowledged by majority of nodes (ensures durability—won't roll back).
- **Read Concern:**
    - `"local"`: Default. Reads whatever is on the node (might be stale).
    - `"majority"`: Reads data that has been acknowledged by majority (no rollbacks).
    - `"linearizable"`: Strongest. Reads reflect all writes that succeeded with majority.

**Situational:** *"You have a critical financial transaction. How do you ensure it isn't lost or rolled back during a network partition?"*
**Answer:** Use `writeConcern: { w: "majority" }` and `readConcern: { level: "majority" }`. This ensures the data is persisted on the majority of nodes before acknowledging the client, preventing rollbacks.

---

### 6. Sharding (Horizontal Scaling)
If the interviewer asks about sharding (common for "backend" roles), focus on the concept:
- **Shard Key:** The field used to distribute data across shards.
- **Choice of Shard Key is critical.**
    - **Bad:** Monotonically increasing keys (e.g., `ObjectId`). This causes all writes to go to one shard (hot spot).
    - **Good:** High cardinality, random distribution, or compound keys.

---

### 7. Situational & Behavioral Scenarios (Common Fresher Traps)

#### Scenario A: "Why is my query slow?"
**Investigation steps:**
1.  Run `.explain("executionStats")`.
2.  Check for `COLLSCAN` (no index used).
3.  Check if the index is being used but is inefficient (`IXSCAN` followed by many `FETCH`es).
4.  Check if the query is using `$regex` without an anchor `^` (cannot use index efficiently).

#### Scenario B: "I need to update millions of documents. Doing it in a loop is slow."
**Answer:** Use `bulkWrite()` or `updateMany()` with `allowDiskUse: true` if it involves aggregation. Batching writes reduces network round trips.

#### Scenario C: "MongoDB uses a lot of RAM. Why?"
**Answer:** MongoDB uses the OS's virtual memory system. It maps data files into memory. WiredTiger (storage engine) uses LRU (Least Recently Used) cache. It will use as much RAM as available to cache data and indexes. **Do not turn on SWAP.**

#### Scenario D: "What is an ObjectId and why is it useful?"
**Answer:** A 12-byte identifier. It is useful because the first 4 bytes are a timestamp. You can sort by `_id` to sort by creation time. You can retrieve the creation date without storing a separate field: `new ObjectId("507c7f79bcf86cd7994f6c0e").getTimestamp()`.

---

### Quick Cheat Sheet for TOMORROW

| Topic | Golden Rule |
| :--- | :--- |
| **CRUD** | `$inc` is atomic; `upsert` creates if missing; `$exists` checks for field presence. |
| **Aggregation** | `$match` early; `$unwind` arrays; `$group` with accumulators; `$lookup` for joins. |
| **Indexes** | ESR rule (Equality, Sort, Range). Covered queries (index only) are fastest. |
| **Replication** | Primary = writes; Secondary = reads (if configured); Oplog = replication log; Majority = safety. |
| **Performance** | Avoid `$where` (JavaScript execution). Use `explain()`. Keep working set in RAM. |

**Last advice:** If they ask a situational question, think **"Atomicity"** (use `$inc`, `$set`), **"Indexes"** (for speed), or **"Pipeline stages"** (for complex data reshaping).

Good luck! You've got this.