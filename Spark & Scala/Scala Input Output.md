Handling input in Scala relies primarily on the `scala.io` package. Whether you are prompting a user in the console, passing in command-line arguments for a backend script, or reading a local file, the standard library provides simple ways to ingest data.

  

Here are the three primary ways to handle input in Scala.

  

## 1. Console Input (`scala.io.StdIn`)

To read input interactively from the terminal, you use the `StdIn` object. It provides methods like `readLine`, `readInt`, and `readDouble`.

  

Scala

```scala
import scala.io.StdIn

object ConsoleApp {
  def main(args: Array[String]): Unit = {
    // Read a simple string
    println("Enter the target database name:")
    val dbName = StdIn.readLine()

    // Read a specific type (Note: this will crash if the user types a string instead of a number)
    println("Enter the port number:")
    val port = StdIn.readInt() 

    println(s"Connecting to $dbName on port $port...")
  }
}
```

> **The Functional Way:** Because `readInt()` throws a runtime exception if the user inputs text (like "abc"), Scala developers often wrap these calls in `Try` to handle bad input safely without crashing the program.
> 
>   

Scala

```scala
import scala.io.StdIn
import scala.util.{Try, Success, Failure}

println("Enter a timeout value in seconds:")
val userInput = Try(StdIn.readInt())

userInput match {
  case Success(value) => println(s"Timeout set to $value seconds.")
  case Failure(error) => println("Invalid input. Please enter a number.")
}
```

## 2. Command-Line Arguments

When building executable backend scripts or data pipelines, you usually pass input as command-line arguments when the program starts. These are captured in the `args` array within your `main` method.

  

Scala

```scala
object PipelineRunner {
  // 'args' captures all arguments passed after the run command
  def main(args: Array[String]): Unit = {
    if (args.length == 0) {
      println("Error: Please provide a configuration file path.")
      sys.exit(1) // Exit the program with an error code
    }

    val configPath = args(0) // Arrays in Scala are accessed with parentheses (0), not brackets [0]
    println(s"Starting pipeline with config: $configPath")
  }
}
```

_Run via command line:_ `scala PipelineRunner config.json`

  

## 3. Reading Files (`scala.io.Source`)

When you need to ingest a local text file, CSV, or log, `Source.fromFile` is the standard tool. It returns an iterator that lets you process the file line-by-line, which is highly memory efficient for large files.

Scala

```scala
import scala.io.Source

object FileReader {
  def main(args: Array[String]): Unit = {
    val filePath = "server_logs.txt"
    
    // Open the file
    val source = Source.fromFile(filePath)
    
    try {
      // getLines() processes one line at a time, preventing memory overload
      for (line <- source.getLines()) {
        if (line.contains("ERROR")) {
          println(line)
        }
      }
    } finally {
      // Always close the source in a 'finally' block to prevent memory leaks
      source.close()
    }
  }
}
```