# **Enumerations (`enum`) in Java**

An **`enum` (enumeration)** in Java is a **special class** that represents a **fixed set of constants**. It improves code **readability, safety, and maintainability** by grouping related constants.

---

## **1. Declaring an `enum`**

```java
enum Day {
    SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY;
}
```

✅ Each value inside an `enum` is called an **enumeration constant** and is **implicitly `public`, `static`, and `final`**.  
✅ **Cannot create objects** of an `enum`.  
✅ **Values are constants (`UPPER_CASE` naming convention)**.

---

## **2. Using an `enum` in Java**

```java
public class EnumExample {
    enum Day { SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY }

    public static void main(String[] args) {
        Day today = Day.WEDNESDAY;
        System.out.println("Today is: " + today);
    }
}
```

### **Output:**

```
Today is: WEDNESDAY
```

✅ `enum` **stores predefined constants**.  
✅ **Used like a variable** (`Day today = Day.WEDNESDAY;`).

---

## **3. Iterating Over an `enum`**

```java
public class EnumIteration {
    enum Color { RED, GREEN, BLUE }

    public static void main(String[] args) {
        for (Color c : Color.values()) {
            System.out.println(c);
        }
    }
}
```

### **Output:**

```
RED
GREEN
BLUE
```

✅ `.values()` returns an **array of all constants**.

---

## **4. `switch` Statement with `enum`**

```java
public class EnumSwitchExample {
    enum Level { LOW, MEDIUM, HIGH }

    public static void main(String[] args) {
        Level level = Level.MEDIUM;

        switch (level) {
            case LOW:
                System.out.println("Low level");
                break;
            case MEDIUM:
                System.out.println("Medium level");
                break;
            case HIGH:
                System.out.println("High level");
                break;
        }
    }
}
```

### **Output:**

```
Medium level
```

✅ **No need for `break` after cases (but recommended for readability).**  
✅ `switch` works **directly** with `enum` values.

---

## **5. `enum` with Fields and Methods**

```java
enum Size {
    SMALL("S"), MEDIUM("M"), LARGE("L");

    private String abbreviation; // Field

    // Constructor
    Size(String abbreviation) {
        this.abbreviation = abbreviation;
    }

    // Getter method
    public String getAbbreviation() {
        return abbreviation;
    }
}

public class EnumWithFields {
    public static void main(String[] args) {
        Size mySize = Size.MEDIUM;
        System.out.println("Size: " + mySize);
        System.out.println("Abbreviation: " + mySize.getAbbreviation());
    }
}
```

### **Output:**

```
Size: MEDIUM
Abbreviation: M
```

✅ **`enum` can have fields, methods, and constructors.**  
✅ **Constructors are always `private`** (cannot create objects manually).


### **Want to Experiment?**

Modify the code like this and print each step:

```java
enum Size {
    SMALL("S"), MEDIUM("M"), LARGE("L");

    private String abbreviation;

    // Constructor
    Size(String abbreviation) {
        System.out.println("Constructor called for: " + this.name());
        this.abbreviation = abbreviation;
    }

    public String getAbbreviation() {
        return abbreviation;
    }
}

public class EnumWithFields {
    public static void main(String[] args) {
        System.out.println("Fetching MEDIUM size...");
        Size mySize = Size.MEDIUM;
        System.out.println("Size: " + mySize);
        System.out.println("Abbreviation: " + mySize.getAbbreviation());
    }
}

```

```
Constructor called for: SMALL
Constructor called for: MEDIUM
Constructor called for: LARGE
Fetching MEDIUM size...
Size: MEDIUM
Abbreviation: M

```

This proves that:

- Enum constructors are **called when the enum is first loaded**, not when you create a new instance.
- The `abbreviation` variable **already holds the correct value**.

---

### **Final Answer**

✔️ The abbreviation is set in the **constructor during enum constant initialization**.  
✔️ The `getAbbreviation()` method simply **returns the stored value**.  
✔️ The enum constants (`SMALL`, `MEDIUM`, `LARGE`) act as **pre-initialized objects**.

---

## **6. `enum` with Abstract Methods**

```java
enum Operation {
    ADD {
        public int apply(int a, int b) { return a + b; }
    },
    SUBTRACT {
        public int apply(int a, int b) { return a - b; }
    };

    // Abstract method
    public abstract int apply(int a, int b);
}

public class EnumWithAbstractMethods {
    public static void main(String[] args) {
        System.out.println("5 + 3 = " + Operation.ADD.apply(5, 3));
        System.out.println("5 - 3 = " + Operation.SUBTRACT.apply(5, 3));
    }
}
```

### **Output:**

```
5 + 3 = 8
5 - 3 = 2
```

✅ Each `enum` constant **overrides the abstract method**.  
✅ **Enums can behave like classes** with custom behavior.

---

## **7. `enum` Inside a Class**

```java
class Shirt {
    enum Size { SMALL, MEDIUM, LARGE }
}

public class NestedEnumExample {
    public static void main(String[] args) {
        Shirt.Size s = Shirt.Size.MEDIUM;
        System.out.println("Selected size: " + s);
    }
}
```

✅ **Enums can be declared inside classes.**

---

## **8. Comparing `enum` Values (`==` vs `.equals()`)**

```java
enum Status { SUCCESS, FAILURE }

public class EnumComparison {
    public static void main(String[] args) {
        Status s1 = Status.SUCCESS;
        Status s2 = Status.SUCCESS;

        System.out.println(s1 == s2);  // ✅ Best practice: Use '==' (true)
        System.out.println(s1.equals(s2)); // Also true
    }
}
```

✅ **Use `==` for comparison** (faster & safer than `.equals()`).

---

## **9. Converting `String` to `enum` and Vice Versa**

```java
enum Animal { DOG, CAT, ELEPHANT }

public class EnumStringConversion {
    public static void main(String[] args) {
        // Convert String to enum
        Animal a = Animal.valueOf("CAT");
        System.out.println(a); // Output: CAT

        // Convert enum to String
        String str = a.name();
        System.out.println(str); // Output: CAT
    }
}
```

✅ `.valueOf("STRING")` converts a `String` to an `enum`.  
✅ `.name()` returns the **string representation** of an `enum`.

---

## **10. `ordinal()` Method**

The `.ordinal()` method returns the **index of an `enum` constant (starting from 0).**

```java
enum Level { LOW, MEDIUM, HIGH }

public class EnumOrdinalExample {
    public static void main(String[] args) {
        System.out.println(Level.LOW.ordinal());   // Output: 0
        System.out.println(Level.MEDIUM.ordinal()); // Output: 1
        System.out.println(Level.HIGH.ordinal());  // Output: 2
    }
}
```

✅ **Useful for sorting but avoid relying on `ordinal()`** (index may change if order changes).

---

## **11. Why Use `enum` Instead of Constants (`final static`)?**

|Feature|`enum`|`final static` Constants|
|---|---|---|
|Type Safety|✅ Ensures valid values|❌ Can store invalid values|
|Readability|✅ Improves code clarity|❌ Less readable|
|Methods|✅ Can have methods|❌ Cannot have methods|
|Comparisons|✅ Use `==` safely|❌ Need `.equals()` for comparison|

### **Bad Practice: Using Constants Instead of `enum`**

```java
class BadPractice {
    public static final int LOW = 1;
    public static final int MEDIUM = 2;
    public static final int HIGH = 3;
}
```

🚨 **Problem:** No type safety → `int` can hold any value (`4` is invalid but still allowed).  
✅ **`enum` prevents invalid values and improves readability.**


```java
enum Level {
    LOW(1), MEDIUM(2), HIGH(3);

    private final int value; // Instance variable to store numeric value

    // Constructor (must be private or package-private)
    Level(int value) {
        this.value = value;
    }

    // Getter method to retrieve numeric value
    public int getValue() {
        return value;
    }
}

public class EnumExample {
    public static void main(String[] args) {
        Level l = Level.MEDIUM;
        System.out.println("Enum Constant: " + l);
        System.out.println("Numeric Value: " + l.getValue());

        // Looping through all constants
        for (Level level : Level.values()) {
            System.out.println(level + " has value " + level.getValue());
        }
    }
}

```



---

## **12. Interview Questions**

1. **Can an `enum` extend a class?**
    
    - ❌ No, but it can implement interfaces.
2. **Can we declare a constructor inside an `enum`?**
    
    - ✅ Yes, but it must be `private` (default).
3. **Can we add methods inside an `enum`?**
    
    - ✅ Yes, just like a class.
4. **What is the default superclass of an `enum`?**
    
    - ✅ `java.lang.Enum<T>`.

---

## **Summary**

✔ **`enum` is a special class for fixed constants**.  
✔ **Can have methods, fields, and constructors**.  
✔ **Safer than using `final static` constants**.  
✔ **Best used for states, settings, categories, and fixed values**.

---

What topic do you want to cover next? 🚀