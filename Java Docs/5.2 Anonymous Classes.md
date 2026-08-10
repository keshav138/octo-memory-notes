# Anonymous Classes in Java

Anonymous classes in Java are a way to declare and instantiate a class at the same time without giving it an explicit name. They're useful for creating one-time implementations of interfaces or extensions of classes.

## Basic Concepts

- Anonymous classes are declared and instantiated in a single expression using the `new` operator
- They can extend a class or implement an interface, but not both
- They cannot have explicit constructors (they use the superclass constructor)
- They can access final or effectively final variables from the enclosing scope

## Simple Examples

### 1. Implementing an Interface

```java
interface Greeting {
    void greet();
}

public class AnonymousClassDemo {
    public static void main(String[] args) {
        // Anonymous class implementing Greeting interface
        Greeting englishGreeting = new Greeting() {
            @Override
            public void greet() {
                System.out.println("Hello!");
            }
        };
        
        englishGreeting.greet(); // Output: Hello!
    }
}
```

### 2. Extending a Class

```java
class Animal {
    void makeSound() {
        System.out.println("Some sound");
    }
}

public class AnonymousClassDemo {
    public static void main(String[] args) {
        // Anonymous class extending Animal
        Animal dog = new Animal() {
            @Override
            void makeSound() {
                System.out.println("Bark!");
            }
        };
        
        dog.makeSound(); // Output: Bark!
    }
}
```

## Complex Examples

### 1. With Constructor Arguments

```java
abstract class Vehicle {
    protected String model;
    
    public Vehicle(String model) {
        this.model = model;
    }
    
    abstract void start();
}

public class AnonymousClassDemo {
    public static void main(String[] args) {
        // Anonymous class extending Vehicle with constructor argument
        Vehicle car = new Vehicle("Tesla Model S") {
            @Override
            void start() {
                System.out.println(model + " starting silently...");
            }
            
            // Additional method specific to this anonymous class
            void autoPilot() {
                System.out.println(model + " engaging autopilot");
            }
        };
        
        car.start();
        // car.autoPilot(); // Won't compile - can't call additional methods this way
    }
}
```

### 2. Implementing Multiple Interfaces (Java 8+ with Functional Interfaces)

```java
public class AnonymousClassDemo {
    interface Processor {
        void process(String input);
    }
    
    interface Validator {
        boolean isValid(String input);
    }
    
    public static void main(String[] args) {
        String data = "AnonymousClassExample";
        
        // Complex anonymous class with multiple interface implementations
        Object complex = new Object() {
            // Implements Processor
            public void process(String input) {
                System.out.println("Processing: " + input.toUpperCase());
            }
            
            // Implements Validator
            public boolean isValid(String input) {
                return input != null && !input.isEmpty();
            }
            
            // Additional method
            public String reverse(String input) {
                return new StringBuilder(input).reverse().toString();
            }
        };
        
        // Need to cast to use the interface methods
        if (((Validator) complex).isValid(data)) {
            ((Processor) complex).process(data);
        }
        
        // Can't access reverse() method without reflection
    }
}
```

### 3. Event Listeners in GUI (Common Use Case)

```java
import javax.swing.*;
import java.awt.event.*;

public class ButtonExample {
    public static void main(String[] args) {
        JFrame frame = new JFrame("Anonymous Class Example");
        JButton button = new JButton("Click Me");
        
        // Anonymous class as ActionListener
        button.addActionListener(new ActionListener() {
            private int clickCount = 0;
            
            @Override
            public void actionPerformed(ActionEvent e) {
                clickCount++;
                JOptionPane.showMessageDialog(frame, 
                    "Button clicked " + clickCount + " times");
                
                if (clickCount >= 3) {
                    ((JButton)e.getSource()).setText("Enough clicks!");
                    ((JButton)e.getSource()).setEnabled(false);
                }
            }
        });
        
        frame.add(button);
        frame.setSize(300, 200);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
    }
}
```

## Key Points to Remember

1. **Access Rules**:
   - Can access final or effectively final variables from enclosing scope
   - Can access members of the enclosing class

2. **Limitations**:
   - Cannot declare static members (except for constant variables)
   - Cannot have explicit constructors
   - Cannot implement multiple interfaces (unless using functional interfaces in Java 8+)

3. **Common Uses**:
   - Event listeners in GUI programming
   - Quick implementations of interfaces like Runnable, Callable
   - Creating comparator objects for sorting

4. **Java 8+ Alternatives**:
   - For single-method interfaces, lambda expressions are often cleaner
   ```java
   Runnable r = () -> System.out.println("Lambda is simpler!");
   ```

## When to Use Anonymous Classes

- When you need a one-time implementation that won't be reused
- When you need to override methods of a class or interface
- When you need access to final variables from the enclosing scope
- When the implementation is short and doesn't justify a separate named class

Anonymous classes provide a balance between full class definitions and lambda expressions, offering more flexibility than lambdas while being more concise than named classes.