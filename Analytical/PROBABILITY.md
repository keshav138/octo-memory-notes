### Core Concepts

- **Probability** = (Number of favorable outcomes)/(Total number of outcomes)
- Probability always lies between 0 and 1
- P(not A) = 1 - P(A)
- **Certain event**: P = 1
- **Impossible event**: P = 0

### Important Formulas

**Addition Rule**:

- P(A or B) = P(A) + P(B) - P(A and B)
- For mutually exclusive events: P(A or B) = P(A) + P(B)

**Multiplication Rule**:

- P(A and B) = P(A) × P(B) [for independent events]

**Conditional Probability**:

- P(A|B) = P(A and B)/P(B)

### Card Problems (52 cards)

- 4 suits: Hearts, Diamonds (Red); Clubs, Spades (Black)
- Each suit: 13 cards (A, 2-10, J, Q, K)
- 26 red cards, 26 black cards
- 12 face cards (J, Q, K of each suit)

### Dice Problems

- Single die: 6 outcomes
- Two dice: 36 outcomes
- Sum of 7: (1,6), (2,5), (3,4), (4,3), (5,2), (6,1) = 6 ways

**Q20.** From 10 tickets numbered 1 to 10, three are drawn at random. Find probability that the numbers are in arithmetic progression.

<details> <summary>Solution</summary>

Total ways = C(10,3) = 120

AP sequences: 
(1,2,3), (2,3,4), (3,4,5), (4,5,6), (5,6,7), (6,7,8), (7,8,9), (8,9,10) - 8 sequences
(1,3,5), (2,4,6), (3,5,7), (4,6,8), (5,7,9), (6,8,10) - 6 sequences
(1,4,7), (2,5,8), (3,6,9), (4,7,10) - 4 sequences
(1,5,9), (2,6,10) - 2 sequences

Total = 8 + 6 + 4 + 2 = 20

Actually, let me be more systematic:
Common difference 1: 8 sequences
Common difference 2: 6 sequences
Common difference 3: 4 sequences
Common difference 4: 2 sequences

Total = 20 favorable

P = 20/120 = 1/6

**Answer: 1/6**

</details>

**Q23.** Three cards are drawn from a deck without replacement. Find probability all are of same suit.

<details> <summary>Solution</summary>

P(All same suit) = P(All spades) + P(All hearts) + P(All diamonds) + P(All clubs)

P(All spades) = 13/52 × 12/51 × 11/50

Since all suits are identical:
P = 4 × (13/52 × 12/51 × 11/50)
= 4 × (1716/132600)
= 6864/132600
= 11/850

**Answer: 11/850**

</details>


**Q25.** A lot of 100 items contains 10 defective items. Three items are selected at random. Find probability that at least one is defective.

<details> <summary>Solution</summary>

P(At least 1 defective) = 1 - P(None defective)

P(All good) = 90/100 × 89/99 × 88/98
= 704880/970200
= 11748/16170

P(At least 1 defective) = 1 - 11748/16170 = 4422/16170 = 737/2695

**Answer: 737/2695 ≈ 0.27**

</details>

**B9.** A bag contains 5 white and 4 black balls. A ball is drawn and replaced along with 2 more of same color. Then another ball is drawn. Find probability that second ball is white.

<details> <summary>Solution</summary>

Case 1: 1st white, then 2nd white
P = 5/9 × 7/11 = 35/99

Case 2: 1st black, then 2nd white
P = 4/9 × 5/11 = 20/99

P(2nd white) = 35/99 + 20/99 = 55/99 = 5/9

**Answer: 5/9**

</details>
