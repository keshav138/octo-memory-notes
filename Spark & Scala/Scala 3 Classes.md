Yes, absolutely. While Scala is famous for its functional programming capabilities, it is still a **purely object-oriented language**. In fact, every single value in Scala is an object under the hood.

  

You use standard classes when you need to define blueprints that encapsulate state, dependencies, and complex behaviors—such as database connections, service layers, or application logic.

  

Here is how standard classes work in Scala, and how they differ from the `case classes` we looked at earlier.

  

### The Primary Constructor

In Scala, the primary constructor is built right into the class signature. You don't need to write a separate constructor function inside the body. The entire body of the class _is_ the constructor.

  

Scala

```scala
// The parameters in the signature form the primary constructor
class DatabaseConnection(url: String, port: Int) {
  
  // Anything written directly in the class body executes when instantiated
  println("Initializing connection object...")

  // Encapsulated private state
  private val fullUrl: String = s"$url:$port"

  // Public behavior
  def connect(): Unit = {
    println(s"Successfully connected to $fullUrl")
  }
}

// Instantiating a standard class requires the 'new' keyword
val db = new DatabaseConnection("localhost", 5432)
db.connect()
```

### Standard Classes vs. Case Classes

Since Scala has both, it helps to know when to reach for which:

  

- **Use `class`:** When you are building services, managers, or objects that might need to hold mutable state, manage private internal variables, or require complex inheritance. (Think: `Server`, `DatabaseClient`, `AuthenticationService`).
    
      
    
- **Use `case class`:** When you are strictly modeling immutable data. Case classes automatically generate getters, structural equality checks, and don't require the `new` keyword. (Think: `UserRecord`, `TelemetryData`, `JSONPayload`).
    
      
    

### Inheritance and Overriding

Standard classes can extend other classes or implement `Traits`. Scala requires you to explicitly use the `override` keyword when changing a parent method's behavior, which prevents accidental bugs.

Scala

```scala
class AnalyticsEngine {
  def process(data: String): Unit = {
    println(s"Processing standard data: $data")
  }
}

class FastF1Engine extends AnalyticsEngine {
  // 'override' is mandatory here
  override def process(data: String): Unit = {
    println(s"Processing high-speed telemetry: $data")
  }
}
```