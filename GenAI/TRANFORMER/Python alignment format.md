```
# Print the source, target and model output
            print_msg('-'*console_width)
            print_msg(f"{f'SOURCE: ':>12}{source_text}")
            print_msg(f"{f'TARGET: ':>12}{target_text}")
            print_msg(f"{f'PREDICTED: ':>12}{model_out_text}")

```

The `:>12` syntax is a Python **string formatting specification** for **right-aligning text to a fixed width**.

  

Here is how it works:

  

### Breakdown of `f"{'SOURCE: ':>12}"`

1. **`:` (Format Specifier Identifier):** Tells Python that a alignment/formatting rule follows.
    
      
    
2. **`>` (Right-Alignment):** Aligns the text to the **right** within its assigned block space.
    
      
    
3. **`12` (Field Width):** Sets the total width of the text block to **12 characters**.
    
      
    

### How Python Renders It

Since the string `'SOURCE: '` is 8 characters long (including the space), Python adds **4 extra padding spaces to the left** to make the total length exactly 12 characters:

  

$$ \text{Output: } \text{\textvisiblespace\textvisiblespace\textvisiblespace\textvisiblespace\texttt{SOURCE: }} $$

When printed alongside target and predicted text:

  

Python

```
print_msg(f"{'SOURCE: ':>12}{source_text}")
print_msg(f"{'TARGET: ':>12}{target_text}")
print_msg(f"{'PREDICTED: ':>12}{model_out_text}")
```

It creates perfectly aligned columns in your terminal output:

  

Plaintext

```
     SOURCE: I am going home.
     TARGET: Vado a casa.
  PREDICTED: Vado a casa.
```

Notice how `SOURCE:`, `TARGET:`, and `PREDICTED:` all align neatly to the right edge at column 12, making terminal logs much cleaner to read.

### Alignment Cheat Sheet in Python f-strings

| **Syntax**  | **Direction**                         | **Example Output (Width 10)** |
| ----------- | ------------------------------------- | ----------------------------- |
| **`:<10`**  | Left-align                            | `'SOURCE: '`                  |
| **`:>10`**  | Right-align                           | `' SOURCE:'`                  |
| **`:^10`**  | Center-align                          | `' SOURCE: '`                 |
| **`:*>10`** | Right-align with custom padding (`*`) | `'***SOURCE:'`                |