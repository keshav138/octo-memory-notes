Sure! Here's an example where we use **wrapper objects** (`Integer`, `Double`, `Boolean`, etc.) as **method parameters**.

---

## **Example: Wrapper Objects as Method Parameters**

```java
public class WrapperAsParameter {
    static void modifyValues(Integer num, Double pi, Boolean flag) {
        System.out.println("Original values: " + num + ", " + pi + ", " + flag);
        
        num += 10; // Modifying Integer
        pi *= 2;   // Modifying Double
        flag = !flag; // Modifying Boolean

        System.out.println("Modified inside method: " + num + ", " + pi + ", " + flag);
    }

    public static void main(String[] args) {
        Integer num = 50;
        Double pi = 3.14;
        Boolean flag = true;

        System.out.println("Before method call: " + num + ", " + pi + ", " + flag);
        modifyValues(num, pi, flag);
        System.out.println("After method call: " + num + ", " + pi + ", " + flag);
    }
}
```

---

### **Output:**

```
Before method call: 50, 3.14, true
Original values: 50, 3.14, true
Modified inside method: 60, 6.28, false
After method call: 50, 3.14, true
```

---

### **Key Observations**

1. **Wrapper objects are immutable** – The changes inside `modifyValues()` do not affect the original values in `main()`.
2. Even though objects are passed **by reference**, wrapper classes do not change because they are **immutable** in Java.
3. If you need to modify a wrapper value persistently, you should **return the modified values**.

---

## **Example: Returning Modified Wrapper Objects**

```java
public class WrapperReturnExample {
    static Integer addTen(Integer num) {
        return num + 10; // New Integer object is created
    }

    public static void main(String[] args) {
        Integer value = 50;
        value = addTen(value); // Reassign modified value

        System.out.println("After modification: " + value);
    }
}
```

### **Output:**

```
After modification: 60
```

✅ **Reassignment is necessary** since `Integer` is immutable.

---

Let me know if you need more details! Ready for the next topic? 🚀