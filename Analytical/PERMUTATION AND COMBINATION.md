### Fundamental Principle

- **Multiplication Rule**: If one operation can be done in m ways and another in n ways, both can be done in m×n ways
- **Addition Rule**: If one operation can be done in m ways OR another in n ways, there are m+n ways

### Factorials

- **n! = n × (n-1) × (n-2) × ... × 2 × 1**
- 0! = 1
- n! = n × (n-1)!

### Permutations (Order Matters)

- **Arrangement of n different things taken r at a time**: ⁿPᵣ = n!/(n-r)!
- **All arrangements of n things**: ⁿPₙ = n!
- **Arrangements with repetition**: If there are n things with p alike, q alike, etc: n!/(p! × q! × ...)
- **Circular permutations**: (n-1)! [clockwise = anticlockwise]
- **Circular permutations (distinct)**: (n-1)!/2 [when clockwise ≠ anticlockwise]

### Combinations (Order Doesn't Matter)

- **Selection of r things from n different things**: ⁿCᵣ = n!/[r!(n-r)!]
- **ⁿCᵣ = ⁿCₙ₋ᵣ**
- **ⁿC₀ = ⁿCₙ = 1**
- **ⁿCᵣ + ⁿCᵣ₋₁ = ⁿ⁺¹Cᵣ**

### Key Relationships

- ⁿPᵣ = ⁿCᵣ × r!
- Use permutation when order matters (arrangements)
- Use combination when order doesn't matter (selections)

### Practice Problems

**Example 1**: How many 4-digit numbers can be formed from digits 1,2,3,4,5,6 without repetition? **Solution**: ⁶P₄ = 6!/(6-4)! = 6!/2! = 720/2 = 360

**Example 2**: From 10 students, how many committees of 4 can be formed? **Solution**: ¹⁰C₄ = 10!/(4!×6!) = (10×9×8×7)/(4×3×2×1) = 210

**Example 3**: In how many ways can 7 people sit around a circular table? **Solution**: (7-1)! = 6! = 720