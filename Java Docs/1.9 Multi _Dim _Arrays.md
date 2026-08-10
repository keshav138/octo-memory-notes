# **Multidimensional Arrays in Java**

A **multidimensional array** in Java is an **array of arrays**. It allows you to store **tabular or matrix-like data**.

---

## **1. Declaring and Initializing Multidimensional Arrays**

### **Syntax:**

```java
dataType[][] arrayName = new dataType[rows][columns];
```

---

## **2. Example: 2D Array (Matrix)**

```java
public class MultiDimArray {
    public static void main(String[] args) {
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };

        System.out.println(matrix[1][2]); // Output: 6
    }
}
```

✅ **`matrix[1][2]`** accesses row `1`, column `2` → `6`

---

## **3. Creating a 2D Array with User Input**

```java
import java.util.Scanner;

public class MultiDimArrayInput {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int[][] numbers = new int[2][3]; // 2 rows, 3 columns

        // Taking input
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 3; j++) {
                System.out.print("Enter value for [" + i + "][" + j + "]: ");
                numbers[i][j] = scanner.nextInt();
            }
        }

        // Displaying output
        System.out.println("Matrix:");
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 3; j++) {
                System.out.print(numbers[i][j] + " ");
            }
            System.out.println();
        }
    }
}
```

✅ Uses **nested loops** to **take input and display a matrix**.

---

## **4. Jagged Arrays (Irregular Arrays)**

A **jagged array** is an array where **rows have different column sizes**.

### **Example:**

```java
public class JaggedArrayExample {
    public static void main(String[] args) {
        int[][] jagged = new int[3][]; // 3 rows, unknown columns

        jagged[0] = new int[]{1, 2};
        jagged[1] = new int[]{3, 4, 5};
        jagged[2] = new int[]{6, 7, 8, 9};

        for (int i = 0; i < jagged.length; i++) {
            for (int j = 0; j < jagged[i].length; j++) {
                System.out.print(jagged[i][j] + " ");
            }
            System.out.println();
        }
    }
}
```

✅ Different row lengths → **Jagged Array**

### **Output:**

```
1 2
3 4 5
6 7 8 9
```

---

## **5. Iterating Through a 2D Array (Enhanced for-loop)**

```java
public class EnhancedLoopExample {
    public static void main(String[] args) {
        int[][] matrix = {
            {10, 20},
            {30, 40},
            {50, 60}
        };

        for (int[] row : matrix) {
            for (int num : row) {
                System.out.print(num + " ");
            }
            System.out.println();
        }
    }
}
```

✅ **Enhanced for-loop** simplifies traversal.

---

## **6. Multidimensional Array Length**

```java
public class ArrayLength {
    public static void main(String[] args) {
        int[][] matrix = new int[4][5]; // 4 rows, 5 columns

        System.out.println("Rows: " + matrix.length);        // 4
        System.out.println("Columns in row 0: " + matrix[0].length); // 5
    }
}
```

---

## **7. Passing Multidimensional Arrays to Methods**

```java
public class ArrayMethod {
    static void printArray(int[][] arr) {
        for (int[] row : arr) {
            for (int num : row) {
                System.out.print(num + " ");
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        int[][] data = { {1, 2, 3}, {4, 5, 6} };
        printArray(data);
    }
}
```

✅ **Methods can accept 2D arrays as parameters.**

---

## **8. 3D Arrays (Array of 2D Arrays)**

```java
public class ThreeDArray {
    public static void main(String[] args) {
        int[][][] cube = new int[2][3][4]; // 2 layers, 3 rows, 4 columns

        cube[0][0][0] = 1; // Assigning a value
        System.out.println(cube[0][0][0]); // Output: 1
    }
}
```

✅ **3D arrays** store **multiple 2D arrays**.

---

## **9. Common Mistakes**

❌ **Accessing an element out of bounds**

```java
int[][] arr = new int[2][2];
System.out.println(arr[2][0]); // ❌ Error: Index out of bounds
```

✅ Fix: Use `arr.length` to check bounds.

---

## **10. Interview Questions**

1. **How do you initialize a jagged array?**
    
    - By manually defining different row lengths.
2. **How to find the number of rows in a 2D array?**
    
    - `array.length`
3. **Can a multidimensional array have mixed data types?**
    
    - No, Java arrays are **homogeneous**.

---

## **Summary**

✔ **2D Arrays** store tabular data (`int[][] arr = new int[3][4]`).  
✔ **Jagged Arrays** have variable row lengths.  
✔ **Enhanced for-loops** simplify traversal.  
✔ **3D Arrays** store multiple 2D arrays.

---

Let me know if you want to go deeper into **sorting, searching, or matrix operations**! 🚀