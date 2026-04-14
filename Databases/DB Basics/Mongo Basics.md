Perfect! Let me give you the foundational basics first, then we'll reinforce with practical CRUD examples. This will give you a complete picture from ground up.

---

## Part 1: MongoDB Basics - The Foundation

### What Makes MongoDB Different?

| **SQL (MySQL/PostgreSQL)** | **MongoDB** |
|---------------------------|-------------|
| Databases | Databases |
| Tables | Collections |
| Rows | Documents |
| Columns | Fields |
| Fixed Schema | Dynamic Schema |
| JOINs required | Embedded documents reduce JOINs |
| ACID transactions (limited) | ACID transactions (full since v4.0) |

### Key Concepts

**1. Document-Oriented**
Instead of storing data in rows across multiple tables, MongoDB stores related data together in a single document.

```javascript
// SQL Approach (3 tables)
Users: id, name, email
Orders: id, user_id, total
OrderItems: id, order_id, product, price

// MongoDB Approach (1 collection)
db.orders.insertOne({
  _id: ObjectId("..."),
  user: {
    name: "John",
    email: "john@email.com"
  },
  total: 150.00,
  items: [
    { product: "Laptop", price: 1000, quantity: 1 },
    { product: "Mouse", price: 50, quantity: 1 }
  ],
  createdAt: new Date()
})
```

**2. Schema Flexibility**
Documents in the same collection can have different fields:

```javascript
// Both can exist in same collection
db.users.insertOne({ name: "Alice", email: "alice@email.com" })
db.users.insertOne({ 
  name: "Bob", 
  email: "bob@email.com", 
  phone: "123-456-7890",
  preferences: { theme: "dark" }
})
```

**3. _id Field**
Every document MUST have a unique `_id`. If you don't provide one, MongoDB auto-creates it:

```javascript
// MongoDB adds _id automatically
db.users.insertOne({ name: "John" })
// Result: { _id: ObjectId("507f191e810c19729de860ea"), name: "John" }

// You can provide your own
db.users.insertOne({ _id: "user_123", name: "John" })
```

---

## Part 2: Complete CRUD Operations with Examples

Let's use a **library management system** as our example.

### Setup - Create Database & Collection

```javascript
// Use/create database (switches context)
use library

// Collections are created automatically on first insert
// But you can explicitly create them:
db.createCollection("books")
db.createCollection("members")
db.createCollection("borrow_records")
```

---

### CREATE Operations (Insert)

#### 1. `insertOne()` - Insert a Single Document

```javascript
// Insert a book
db.books.insertOne({
  title: "The Pragmatic Programmer",
  author: "David Thomas",
  isbn: "978-0201616224",
  price: 49.99,
  genres: ["programming", "software engineering"],
  publishedYear: 1999,
  inStock: true,
  ratings: [
    { userId: "user1", score: 5, review: "Must read!" },
    { userId: "user2", score: 4, review: "Great book" }
  ]
})

// Response:
{
  acknowledged: true,
  insertedId: ObjectId("65a1b2c3d4e5f6789a0b1c2d")
}
```

#### 2. `insertMany()` - Insert Multiple Documents

```javascript
db.books.insertMany([
  {
    title: "Clean Code",
    author: "Robert Martin",
    isbn: "978-0132350884",
    price: 45.99,
    genres: ["programming", "best practices"],
    publishedYear: 2008
  },
  {
    title: "You Don't Know JS",
    author: "Kyle Simpson",
    isbn: "978-1491924464",
    price: 39.99,
    genres: ["javascript", "programming"],
    publishedYear: 2014
  }
])

// Response includes all inserted IDs
```

#### 3. `insert()` - Deprecated but still works (use insertOne/insertMany instead)

---

### READ Operations (Query)

#### 1. `find()` - Retrieve Documents

```javascript
// Find all books (returns cursor)
db.books.find()

// Pretty print (formatted)
db.books.find().pretty()

// Find with filter
db.books.find({ author: "Robert Martin" })

// Find with multiple conditions (AND by default)
db.books.find({ 
  author: "David Thomas", 
  publishedYear: 1999 
})
```

#### 2. Comparison Operators

```javascript
// $eq - Equal to
db.books.find({ price: { $eq: 49.99 } })
// Same as: db.books.find({ price: 49.99 })

// $ne - Not equal
db.books.find({ price: { $ne: 49.99 } })

// $gt - Greater than
db.books.find({ price: { $gt: 40 } })

// $gte - Greater than or equal
db.books.find({ price: { $gte: 40 } })

// $lt - Less than
db.books.find({ price: { $lt: 50 } })

// $lte - Less than or equal
db.books.find({ price: { $lte: 45 } })

// $in - In array
db.books.find({ author: { $in: ["David Thomas", "Robert Martin"] } })

// $nin - Not in array
db.books.find({ author: { $nin: ["Unknown Author"] } })
```

#### 3. Logical Operators

```javascript
// $and - All conditions must match
db.books.find({
  $and: [
    { price: { $gt: 40 } },
    { publishedYear: { $lt: 2010 } }
  ]
})
// Simpler way (implicit AND):
db.books.find({ price: { $gt: 40 }, publishedYear: { $lt: 2010 } })

// $or - At least one condition matches
db.books.find({
  $or: [
    { author: "David Thomas" },
    { author: "Robert Martin" }
  ]
})

// $nor - None of the conditions match
db.books.find({
  $nor: [
    { inStock: true },
    { price: { $lt: 30 } }
  ]
})

// $not - Negates a condition
db.books.find({ price: { $not: { $gt: 50 } } })
```

#### 4. Array Operators

```javascript
// $all - Array contains all specified elements
db.books.find({ genres: { $all: ["programming", "javascript"] } })

// $size - Array has exact size
db.books.find({ genres: { $size: 2 } })

// $elemMatch - Matches array elements with multiple conditions
db.books.find({
  ratings: {
    $elemMatch: { score: { $gte: 4 }, review: { $exists: true } }
  }
})
```

#### 5. Field Operators

```javascript
// $exists - Field exists
db.books.find({ ratings: { $exists: true } })
db.books.find({ ratings: { $exists: false } })

// $type - Field is specific type
db.books.find({ price: { $type: "number" } })
// Common types: "string", "number", "array", "object", "bool"
```

#### 6. Projection (Select specific fields)

```javascript
// Include only title and author (1 = include)
db.books.find({}, { title: 1, author: 1 })

// Exclude price (0 = exclude)
db.books.find({}, { price: 0 })

// Include title, exclude _id (must explicitly exclude _id)
db.books.find({}, { title: 1, _id: 0 })
```

#### 7. Query Modifiers

```javascript
// Limit results
db.books.find().limit(5)

// Skip documents
db.books.find().skip(10)  // Skip first 10

// Sort (1 = ascending, -1 = descending)
db.books.find().sort({ publishedYear: -1, title: 1 })

// Count documents
db.books.countDocuments({ author: "David Thomas" })
db.books.find({ author: "David Thomas" }).count()

// Combined example
db.books
  .find({ price: { $gt: 30 } })
  .sort({ publishedYear: -1 })
  .skip(5)
  .limit(10)
```

#### 8. `findOne()` - Returns Single Document

```javascript
// Returns first matching document (or null)
db.books.findOne({ isbn: "978-0201616224" })
```

---

### UPDATE Operations

#### 1. `updateOne()` - Update First Matching Document

```javascript
// Update a book's price
db.books.updateOne(
  { isbn: "978-0201616224" },  // Filter
  { $set: { price: 54.99 } }    // Update operation
)

// Multiple updates in one operation
db.books.updateOne(
  { title: "Clean Code" },
  {
    $set: { 
      inStock: true,
      lastUpdated: new Date()
    },
    $inc: { copiesSold: 1 }  // Increment by 1
  }
)
```

#### 2. `updateMany()` - Update All Matching Documents

```javascript
// Mark all books from 1999 as "classic"
db.books.updateMany(
  { publishedYear: 1999 },
  { $set: { status: "classic" } }
)

// Add a field to all books
db.books.updateMany(
  {},
  { $set: { available: true } }
)
```

#### 3. Update Operators

```javascript
// $set - Set field value
db.books.updateOne(
  { title: "Clean Code" },
  { $set: { price: 49.99 } }
)

// $unset - Remove field
db.books.updateOne(
  { title: "Clean Code" },
  { $unset: { temporaryField: "" } }
)

// $inc - Increment number
db.books.updateOne(
  { title: "Clean Code" },
  { $inc: { views: 1 } }
)

// $mul - Multiply number
db.books.updateOne(
  { title: "Clean Code" },
  { $mul: { price: 0.9 } }  // 10% discount
)

// $rename - Rename field
db.books.updateOne(
  { title: "Clean Code" },
  { $rename: { "author": "authorName" } }
)

// $min/$max - Update only if new value is min/max
db.books.updateOne(
  { title: "Clean Code" },
  { $min: { price: 30 } }  // Only updates if current price > 30
)

// $push - Add element to array
db.books.updateOne(
  { title: "Clean Code" },
  { $push: { genres: "software-craftsmanship" } }
)

// $push with modifiers
db.books.updateOne(
  { title: "Clean Code" },
  {
    $push: {
      ratings: {
        $each: [{ userId: "user3", score: 5 }],
        $slice: -10,  // Keep only last 10
        $sort: { score: -1 }  // Sort by score descending
      }
    }
  }
)

// $addToSet - Add to array only if not exists (unique)
db.books.updateOne(
  { title: "Clean Code" },
  { $addToSet: { tags: "bestseller" } }
)

// $pop - Remove first (1) or last (-1) array element
db.books.updateOne(
  { title: "Clean Code" },
  { $pop: { genres: 1 } }  // Remove last
)

// $pull - Remove all matching array elements
db.books.updateOne(
  { title: "Clean Code" },
  { $pull: { genres: "obsolete" } }
)

// $pullAll - Remove multiple values
db.books.updateOne(
  { title: "Clean Code" },
  { $pullAll: { genres: ["old", "deprecated"] } }
)
```

#### 4. `replaceOne()` - Replace Entire Document

```javascript
// Replace whole document (keeps _id)
db.books.replaceOne(
  { isbn: "978-0201616224" },
  {
    title: "The Pragmatic Programmer (20th Anniversary)",
    author: "David Thomas",
    isbn: "978-0201616224",
    price: 69.99,
    // All other fields are gone
  }
)
```

#### 5. Upsert (Update or Insert)

```javascript
// If book exists, update; if not, create it
db.books.updateOne(
  { isbn: "978-0135957059" },
  {
    $set: {
      title: "Designing Data-Intensive Applications",
      author: "Martin Kleppmann",
      price: 59.99
    }
  },
  { upsert: true }  // Creates if doesn't exist
)
```

---

### DELETE Operations

#### 1. `deleteOne()` - Delete Single Document

```javascript
// Delete first matching book
db.books.deleteOne({ isbn: "978-0132350884" })
```

#### 2. `deleteMany()` - Delete Multiple Documents

```javascript
// Delete all books with price > 100
db.books.deleteMany({ price: { $gt: 100 } })

// Delete all books from 1999
db.books.deleteMany({ publishedYear: 1999 })

// Delete all documents (BE CAREFUL!)
db.books.deleteMany({})
```

---

## Part 3: Practical CRUD Scenarios

### Scenario 1: E-commerce Cart System

```javascript
// Create cart collection
db.carts.insertOne({
  userId: "user_123",
  items: [
    { productId: "prod_1", name: "Laptop", quantity: 1, price: 999 },
    { productId: "prod_2", name: "Mouse", quantity: 2, price: 25 }
  ],
  createdAt: new Date()
})

// Add item to cart (if exists, increment quantity; if not, push)
db.carts.updateOne(
  { userId: "user_123" },
  {
    $inc: { "items.$[item].quantity": 1 }
  },
  {
    arrayFilters: [{ "item.productId": "prod_1" }]
  }
)

// Alternative: Add new item
db.carts.updateOne(
  { userId: "user_123" },
  {
    $push: {
      items: { productId: "prod_3", name: "Keyboard", quantity: 1, price: 75 }
    }
  }
)

// Remove item
db.carts.updateOne(
  { userId: "user_123" },
  { $pull: { items: { productId: "prod_2" } } }
)

// Update item quantity
db.carts.updateOne(
  { userId: "user_123", "items.productId": "prod_1" },
  { $set: { "items.$.quantity": 3 } }
)

// Get cart with total calculation (using aggregation)
db.carts.aggregate([
  { $match: { userId: "user_123" } },
  { $unwind: "$items" },
  {
    $group: {
      _id: "$_id",
      userId: { $first: "$userId" },
      items: { $push: "$items" },
      total: { $sum: { $multiply: ["$items.price", "$items.quantity"] } }
    }
  }
])
```

### Scenario 2: Blog System

```javascript
// Create post with comments
db.posts.insertOne({
  title: "MongoDB Basics",
  content: "Lorem ipsum...",
  author: "John Doe",
  tags: ["mongodb", "database", "nosql"],
  views: 0,
  comments: [
    {
      user: "Alice",
      text: "Great post!",
      createdAt: new Date(),
      likes: 5
    }
  ],
  createdAt: new Date()
})

// Increment view count
db.posts.updateOne(
  { _id: ObjectId("...") },
  { $inc: { views: 1 } }
)

// Add new comment
db.posts.updateOne(
  { _id: ObjectId("...") },
  {
    $push: {
      comments: {
        user: "Bob",
        text: "Very helpful",
        createdAt: new Date(),
        likes: 0
      }
    }
  }
)

// Like a comment
db.posts.updateOne(
  { 
    _id: ObjectId("..."),
    "comments.user": "Alice"
  },
  { $inc: { "comments.$.likes": 1 } }
)

// Find popular posts
db.posts.find({
  views: { $gt: 1000 },
  "comments.likes": { $gt: 10 }
}).sort({ views: -1 })
```

### Scenario 3: User Profile with Preferences

```javascript
// Create user profile
db.users.insertOne({
  email: "john@email.com",
  profile: {
    firstName: "John",
    lastName: "Doe",
    age: 28,
    preferences: {
      theme: "dark",
      notifications: true,
      language: "en"
    }
  },
  stats: {
    postsCount: 0,
    followers: [],
    following: []
  },
  createdAt: new Date()
})

// Update nested fields
db.users.updateOne(
  { email: "john@email.com" },
  {
    $set: {
      "profile.preferences.theme": "light",
      "profile.age": 29
    }
  }
)

// Add follower
db.users.updateOne(
  { email: "john@email.com" },
  { $addToSet: { "stats.followers": "alice@email.com" } }
)

// Increment post count
db.users.updateOne(
  { email: "john@email.com" },
  { $inc: { "stats.postsCount": 1 } }
)
```

---

## Part 4: Common Patterns & Best Practices

### 1. Query Patterns

```javascript
// Pagination pattern
const page = 1
const pageSize = 20
db.books
  .find()
  .sort({ createdAt: -1 })
  .skip((page - 1) * pageSize)
  .limit(pageSize)

// Check if document exists before insert (prevent duplicates)
const exists = db.users.findOne({ email: "john@email.com" })
if (!exists) {
  db.users.insertOne({ email: "john@email.com", name: "John" })
}
// Better: Use unique index + upsert
```

### 2. Bulk Operations

```javascript
// Bulk write for performance
db.books.bulkWrite([
  { 
    insertOne: { 
      document: { title: "Book 1", author: "Author 1" } 
    } 
  },
  {
    updateOne: {
      filter: { title: "Clean Code" },
      update: { $inc: { sales: 1 } }
    }
  },
  {
    deleteOne: {
      filter: { title: "Old Book" }
    }
  }
])
```

### 3. Error Handling

```javascript
try {
  const result = db.books.insertOne({ 
    title: "Duplicate ISBN",
    isbn: "123456" 
  })
  print(`Inserted: ${result.insertedId}`)
} catch (error) {
  if (error.code === 11000) {  // Duplicate key error
    print("Book with this ISBN already exists")
  } else {
    print(`Error: ${error.message}`)
  }
}
```

---

## Part 5: Quick Reference Card

| **Operation** | **Syntax** | **Example** |
|--------------|-----------|------------|
| **Create DB** | `use databaseName` | `use library` |
| **Insert One** | `db.collection.insertOne({})` | `db.books.insertOne({title: "Book"})` |
| **Insert Many** | `db.collection.insertMany([{}])` | `db.books.insertMany([{}, {}])` |
| **Find All** | `db.collection.find()` | `db.books.find()` |
| **Find One** | `db.collection.findOne({})` | `db.books.findOne({title: "Book"})` |
| **Update One** | `db.collection.updateOne({}, {$set: {}})` | `db.books.updateOne({title: "Book"}, {$set: {price: 10}})` |
| **Update Many** | `db.collection.updateMany({}, {$set: {}})` | `db.books.updateMany({}, {$inc: {stock: 1}})` |
| **Delete One** | `db.collection.deleteOne({})` | `db.books.deleteOne({title: "Old"})` |
| **Delete Many** | `db.collection.deleteMany({})` | `db.books.deleteMany({price: 0})` |

---

This foundation plus the advanced concepts from before should give you a complete picture. Focus on understanding:
1. **When to use each operator** (especially `$inc`, `$push`, `$set`)
2. **How to structure queries** with filters and projections
3. **The relationship between operations** (update with upsert, bulk operations)

Practice these examples in your mind. You'll do great tomorrow! Good luck! 🚀