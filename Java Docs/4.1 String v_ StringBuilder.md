Sure! Here’s a **comprehensive table** of **String and StringBuilder methods**, along with their **functionality, syntax, input, and output.** 🚀

---

## **📌 String Class Methods**

| **Method**                                     | **Functionality**                             | **Format**                         | **Input**                          | **Output** |
| ---------------------------------------------- | --------------------------------------------- | ---------------------------------- | ---------------------------------- | ---------- |
| `length()`                                     | Returns length of the string                  | `str.length()`                     | None                               | `int`      |
| `charAt(int index)`                            | Returns character at a specific index         | `str.charAt(2)`                    | `int index`                        | `char`     |
| `substring(int start)`                         | Extracts substring from start index           | `str.substring(3)`                 | `int start`                        | `String`   |
| `substring(int start, int end)`                | Extracts substring from start to end-1        | `str.substring(2, 5)`              | `int start, int end`               | `String`   |
| `indexOf(String s)`                            | Returns first occurrence index of a substring | `str.indexOf("Java")`              | `String s`                         | `int`      |
| `lastIndexOf(String s)`                        | Returns last occurrence index of a substring  | `str.lastIndexOf("a")`             | `String s`                         | `int`      |
| `contains(CharSequence s)`                     | Checks if string contains a given sequence    | `str.contains("Java")`             | `String s`                         | `boolean`  |
| `startsWith(String s)`                         | Checks if string starts with a given prefix   | `str.startsWith("He")`             | `String s`                         | `boolean`  |
| `endsWith(String s)`                           | Checks if string ends with a given suffix     | `str.endsWith("ld")`               | `String s`                         | `boolean`  |
| `toLowerCase()`                                | Converts string to lowercase                  | `str.toLowerCase()`                | None                               | `String`   |
| `toUpperCase()`                                | Converts string to uppercase                  | `str.toUpperCase()`                | None                               | `String`   |
| `trim()`                                       | Removes leading and trailing spaces           | `str.trim()`                       | None                               | `String`   |
| `replace(char old, char new)`                  | Replaces characters                           | `str.replace('a', 'e')`            | `char old, char new`               | `String`   |
| `replaceAll(String regex, String replacement)` | Replaces substring using regex                | `str.replaceAll("\\s+", "-")`      | `String regex, String replacement` | `String`   |
| `split(String regex)`                          | Splits string into an array                   | `str.split(",")`                   | `String regex`                     | `String[]` |
| `equals(Object o)`                             | Checks if two strings are equal               | `str.equals("hello")`              | `String o`                         | `boolean`  |
| `equalsIgnoreCase(String s)`                   | Compares strings ignoring case                | `str.equalsIgnoreCase("HELLO")`    | `String s`                         | `boolean`  |
| `concat(String s)`                             | Appends a string                              | `str.concat(" World")`             | `String s`                         | `String`   |
| `isEmpty()`                                    | Checks if string is empty                     | `str.isEmpty()`                    | None                               | `boolean`  |
| `compareTo(String s)`                          | Compares two strings lexicographically        | `str.compareTo("hello")`           | `String s`                         | `int`      |
| `compareToIgnoreCase(String s)`                | Compares two strings ignoring case            | `str.compareToIgnoreCase("HELLO")` | `String s`                         | `int`      |
| `matches(String regex)`                        | Checks if string matches regex                | `str.matches("\\d{3}")`            | `String regex`                     | `boolean`  |
| `toCharArray()`                                | Converts string to character array            | `str.toCharArray()`                | None                               | `char[]`   |

---

## **📌 StringBuilder Class Methods**

|**Method**|**Functionality**|**Format**|**Input**|**Output**|
|---|---|---|---|---|
|`length()`|Returns length of the builder|`sb.length()`|None|`int`|
|`capacity()`|Returns current capacity|`sb.capacity()`|None|`int`|
|`append(String s)`|Appends a string|`sb.append("Java")`|`String s`|`StringBuilder`|
|`insert(int index, String s)`|Inserts a string at a given index|`sb.insert(2, "Hi")`|`int index, String s`|`StringBuilder`|
|`replace(int start, int end, String s)`|Replaces text between indices|`sb.replace(1, 3, "AB")`|`int start, int end, String s`|`StringBuilder`|
|`delete(int start, int end)`|Deletes text between indices|`sb.delete(2, 4)`|`int start, int end`|`StringBuilder`|
|`deleteCharAt(int index)`|Deletes character at a given index|`sb.deleteCharAt(2)`|`int index`|`StringBuilder`|
|`reverse()`|Reverses the builder content|`sb.reverse()`|None|`StringBuilder`|
|`setLength(int newLength)`|Sets the length of the builder|`sb.setLength(5)`|`int newLength`|`void`|
|`charAt(int index)`|Returns character at index|`sb.charAt(3)`|`int index`|`char`|
|`indexOf(String s)`|Returns first occurrence index|`sb.indexOf("Java")`|`String s`|`int`|
|`substring(int start)`|Returns substring from index|`sb.substring(3)`|`int start`|`String`|
|`substring(int start, int end)`|Returns substring from start to end-1|`sb.substring(2, 5)`|`int start, int end`|`String`|
|`ensureCapacity(int minCapacity)`|Ensures buffer capacity|`sb.ensureCapacity(50)`|`int minCapacity`|`void`|

---

## **📌 Key Differences: String vs StringBuilder**

|**Feature**|**String**|**StringBuilder**|
|---|---|---|
|**Mutability**|Immutable (cannot change value)|Mutable (modifies value directly)|
|**Thread Safety**|Not thread-safe|Not thread-safe|
|**Performance**|Slower (new object created on modification)|Faster (modifies in-place)|
|**Memory Usage**|Uses more memory (new objects created)|Uses less memory (modifies buffer)|
## **📌 Summary**

|**Operation**|**Effect on Capacity**|
|---|---|
|`StringBuilder()`|Default capacity = `16`|
|`StringBuilder(int capacity)`|Initial capacity is set to the given value|
|`sb.append("long text")`|If length exceeds capacity, new capacity = `(oldCapacity * 2) + 2`|
|`sb.ensureCapacity(n)`|Ensures at least `n` capacity|


---

## **📌 Example Usage**

```java
public class StringVsStringBuilder {
    public static void main(String[] args) {
        // String example (immutable)
        String str = "Hello";
        str = str.concat(" World");
        System.out.println(str); // Hello World

        // StringBuilder example (mutable)
        StringBuilder sb = new StringBuilder("Hello");
        sb.append(" World");
        System.out.println(sb); // Hello World
    }
}
```

---

## **🚀 Conclusion**

- **Use `String`** when values **do not change** frequently.
- **Use `StringBuilder`** when **modifications** are frequent for better performance.

Let me know if you need more details! 🚀🔥