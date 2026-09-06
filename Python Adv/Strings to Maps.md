```python
from collections import Counter

my_string = "hello"
# Directly creates a dictionary-like object counting the characters
char_dict = Counter(my_string)

print(char_dict)
# Output: Counter({'l': 2, 'h': 1, 'e': 1, 'o': 1})

```

```python
my_string = "hello"

# Creates a dictionary with keys from the string and values set to 0
char_dict = dict.fromkeys(my_string, 0)

print(char_dict)
# Output: {'h': 0, 'e': 0, 'l': 0, 'o': 0}

```

```python
my_string = "hello"

# Maps each character to its last seen index position
char_dict = {char: index for index, char in enumerate(my_string)}

print(char_dict)
# Output: {'h': 0, 'e': 1, 'l': 3, 'o': 4}

```