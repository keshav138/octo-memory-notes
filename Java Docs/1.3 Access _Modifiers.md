
Access modifiers in Java **control the visibility and accessibility** of classes, methods, and variables. They define **who** can access a particular piece of code.

---

## **Types of Access Modifiers in Java**

Java provides **four** types of access modifiers:

|Modifier|Class|Package|Subclass|World (Other Classes)|
|---|---|---|---|---|
|**private**|✅|❌|❌|❌|
|**default** (no modifier)|✅|✅|❌|❌|
|**protected**|✅|✅|✅|❌|
|**public**|✅|✅|✅|✅|

✅ = Accessible, ❌ = Not Accessible

---

## **1. `private` (Most Restrictive)**

- **Scope:** Accessible **only within the same class**.
- **Cannot** be accessed by subclasses or other classes.
- **Usage:** Used to **encapsulate** data, ensuring controlled access via **getters and setters**.

### **Example:**

```java
class PrivateExample {
    private int data = 42; // Private variable

    private void display() { // Private method
        System.out.println("Private Data: " + data);
    }

    public void accessPrivate() { // Public method to access private members
        display();
    }
}

public class Main {
    public static void main(String[] args) {
        PrivateExample obj = new PrivateExample();
        // obj.data = 50; // ❌ Error: data has private access
        // obj.display(); // ❌ Error: display() has private access

        obj.accessPrivate(); // ✅ Accessing private data through a public method
    }
}
```

**Key Takeaways:** ✔ Used for **data hiding** and **encapsulation**.  
✔ Only accessible **inside the same class**.  
✔ Accessible via **public getter/setter methods**.

---

## **2. `default` (Package-Private)**

- **Scope:** Accessible **only within the same package** (if no modifier is specified).
- **Not accessible** from outside the package, even by subclasses.
- **Usage:** Used when you want **package-level access**.

### **Example:**

```java
class DefaultExample { // No modifier → package-private
    void showMessage() {
        System.out.println("Default access modifier in action!");
    }
}

// Another class in the same package
public class Main {
    public static void main(String[] args) {
        DefaultExample obj = new DefaultExample();
        obj.showMessage(); // ✅ Accessible within the same package
    }
}

// In a different package
// ❌ class OtherPackageClass {
//     DefaultExample obj = new DefaultExample(); // Error: Cannot access
// }
```

**Key Takeaways:** ✔ No modifier = **package-private** access.  
✔ Can be accessed **within the same package**.  
✔ **Not accessible** outside the package, even by subclasses.

---

## **3. `protected` (Package + Subclasses)**

- **Scope:** Accessible **within the same package** and **subclasses in other packages**.
- **Usage:** Used to allow **subclasses to inherit properties** while still maintaining some restriction.

### **Example:**

```java
package mypackage;

class ProtectedExample {
    protected String message = "Hello from protected modifier!";
    
    protected void display() {
        System.out.println(message);
    }
}
```

#### **Accessing from a subclass in another package:**

```java
package anotherpackage;
import mypackage.ProtectedExample;

class SubClass extends ProtectedExample {
    void accessProtected() {
        System.out.println(message); // ✅ Accessible via inheritance
        display(); // ✅ Accessible via inheritance
    }
}

public class Main {
    public static void main(String[] args) {
        SubClass obj = new SubClass();
        obj.accessProtected(); // ✅ Works because it's inherited
    }
}
```

#### **Accessing from a non-subclass in another package:**

```java
package anotherpackage;
import mypackage.ProtectedExample;

public class Main {
    public static void main(String[] args) {
        ProtectedExample obj = new ProtectedExample();
        // obj.display(); // ❌ Error: Protected members can't be accessed outside package without inheritance
    }
}
```

**Key Takeaways:** ✔ Allows **subclass inheritance** even if in **different packages**.  
✔ Not accessible in **other packages unless inherited**.  
✔ Useful when designing a **class hierarchy**.

---

## **4. `public` (Least Restrictive)**

- **Scope:** Accessible **everywhere** in the program.
- **Usage:** Used for **class declarations, methods, and variables** that need to be accessed globally.

### **Example:**

```java
package mypackage;

public class PublicExample {
    public int number = 100;

    public void display() {
        System.out.println("Public method accessed!");
    }
}
```

#### **Accessing from another package:**

```java
package anotherpackage;
import mypackage.PublicExample;

public class Main {
    public static void main(String[] args) {
        PublicExample obj = new PublicExample();
        System.out.println(obj.number); // ✅ Accessible
        obj.display(); // ✅ Accessible
    }
}
```

**Key Takeaways:** ✔ No access restrictions.  
✔ Can be accessed **from anywhere**.  
✔ Used for APIs, utility classes, and constants.

---

## **Access Modifiers in Classes**

|Modifier|Class|Constructor|Methods|Variables|
|---|---|---|---|---|
|`private`|❌ (Not Allowed)|✅|✅|✅|
|`default`|✅|✅|✅|✅|
|`protected`|❌ (Not Allowed)|✅|✅|✅|
|`public`|✅|✅|✅|✅|

✔ **Classes can only be `public` or default (package-private)**.  
❌ `private` and `protected` **cannot be used for top-level classes**.

---

## **When to Use Which Modifier?**

|Scenario|Best Modifier|
|---|---|
|**Encapsulation (Data Hiding)**|`private`|
|**Internal Use Within a Package**|`default` (no modifier)|
|**Allowing Inheritance But Restricting Access**|`protected`|
|**Making API Methods/Classes Accessible Everywhere**|`public`|

---

## **Advanced Example**

```java
package mypackage;

public class AccessModifiersDemo {
    private String privateMessage = "Private!";
    String defaultMessage = "Default!";
    protected String protectedMessage = "Protected!";
    public String publicMessage = "Public!";

    public void showMessages() {
        System.out.println(privateMessage);
        System.out.println(defaultMessage);
        System.out.println(protectedMessage);
        System.out.println(publicMessage);
    }
}
```

### **Accessing from another class in the same package**

```java
package mypackage;

public class SamePackageClass {
    public static void main(String[] args) {
        AccessModifiersDemo obj = new AccessModifiersDemo();
        // System.out.println(obj.privateMessage); // ❌ Error
        System.out.println(obj.defaultMessage); // ✅ Accessible
        System.out.println(obj.protectedMessage); // ✅ Accessible
        System.out.println(obj.publicMessage); // ✅ Accessible
    }
}
```

### **Accessing from another package**

```java
package anotherpackage;
import mypackage.AccessModifiersDemo;

public class OtherPackageClass extends AccessModifiersDemo {
    public static void main(String[] args) {
        OtherPackageClass obj = new OtherPackageClass();
        // System.out.println(obj.privateMessage); // ❌ Error
        // System.out.println(obj.defaultMessage); // ❌ Error
        System.out.println(obj.protectedMessage); // ✅ Accessible via inheritance
        System.out.println(obj.publicMessage); // ✅ Accessible
    }
}
```

---

## **Summary**

✅ `private` → **Most restrictive** (only inside the class).  
✅ `default` → **Accessible within the same package** (no modifier).  
✅ `protected` → **Accessible in the package + subclasses outside package**.  
✅ `public` → **Accessible everywhere**.

---

Let me know what topic you want next! 🚀