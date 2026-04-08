			
## TYPE 1: Basic Probability Concepts

**Q1.** A bag contains 5 red, 4 blue, and 3 green balls. Find the probability of drawing a red ball.

<details> <summary>Solution</summary>

Total balls = 5 + 4 + 3 = 12
Red balls = 5

P(Red) = 5/12

**Answer: 5/12**

</details>

**Q2.** A card is drawn from a well-shuffled deck of 52 cards. Find the probability of getting a king.

<details> <summary>Solution</summary>

Total cards = 52
Number of kings = 4

P(King) = 4/52 = 1/13

**Answer: 1/13**

</details>

**Q3.** What is the probability of getting an even number when a die is thrown?

<details> <summary>Solution</summary>

Total outcomes = 6 (1, 2, 3, 4, 5, 6)
Even numbers = 3 (2, 4, 6)

P(Even) = 3/6 = 1/2

**Answer: 1/2**

</details>

---

## TYPE 2: Complementary Events

**Q4.** If the probability of rain is 0.3, what is the probability of no rain?

<details> <summary>Solution</summary>

P(No rain) = 1 - P(Rain)
= 1 - 0.3 = 0.7

**Answer: 0.7 or 7/10**

</details>

**Q5.** A bag has 8 red and 6 black balls. What is the probability of NOT drawing a red ball?

<details> <summary>Solution</summary>

Total balls = 14
P(Red) = 8/14 = 4/7

P(Not Red) = 1 - 4/7 = 3/7

**Answer: 3/7**

</details>

**Q6.** The probability that a student passes an exam is 0.85. What is the probability of failure?

<details> <summary>Solution</summary>

P(Fail) = 1 - P(Pass)
= 1 - 0.85 = 0.15

**Answer: 0.15 or 15%**

</details>

---

## TYPE 3: AND Events (Independent Events)

**Q7.** Two coins are tossed. Find the probability of getting two heads.

<details> <summary>Solution</summary>

P(Head on 1st coin) = 1/2
P(Head on 2nd coin) = 1/2

P(Both heads) = 1/2 × 1/2 = 1/4

**Answer: 1/4**

</details>

**Q8.** Three coins are tossed simultaneously. Find the probability of getting all tails.

<details> <summary>Solution</summary>

P(All tails) = (1/2) × (1/2) × (1/2) = 1/8

**Alternative:** Total outcomes = 2³ = 8
Favorable outcome = 1 (TTT)
P = 1/8

**Answer: 1/8**

</details>

**Q9.** A bag has 5 red and 4 blue balls. Two balls are drawn with replacement. Find probability both are red.

<details> <summary>Solution</summary>

Total balls = 9

P(1st red) = 5/9
P(2nd red) = 5/9 (replacement)

P(Both red) = 5/9 × 5/9 = 25/81

**Answer: 25/81**

</details>

---

## TYPE 4: OR Events (Mutually Exclusive)

**Q10.** A card is drawn from a deck. Find probability of getting either a king or a queen.

<details> <summary>Solution</summary>

P(King) = 4/52
P(Queen) = 4/52

P(King or Queen) = 4/52 + 4/52 = 8/52 = 2/13

**Answer: 2/13**

</details>

**Q11.** A die is thrown. What is the probability of getting a 2 or a 5?

<details> <summary>Solution</summary>

P(2) = 1/6
P(5) = 1/6

P(2 or 5) = 1/6 + 1/6 = 2/6 = 1/3

**Answer: 1/3**

</details>

**Q12.** From a deck, find probability of drawing a red card or a king.

<details> <summary>Solution</summary>

P(Red card) = 26/52
P(King) = 4/52
P(Red King) = 2/52 (overlap)

P(Red or King) = 26/52 + 4/52 - 2/52 = 28/52 = 7/13

**Answer: 7/13**

</details>

---

## TYPE 5: Conditional Probability

**Q13.** A bag has 4 red and 5 blue balls. Two balls are drawn without replacement. Find probability that second is blue given first is red.

<details> <summary>Solution</summary>

After drawing 1 red ball:
Remaining = 8 balls (3 red, 5 blue)

P(2nd blue | 1st red) = 5/8

**Answer: 5/8**

</details>

**Q14.** From a deck, two cards are drawn without replacement. Find probability both are aces.

<details> <summary>Solution</summary>

P(1st ace) = 4/52
P(2nd ace | 1st ace) = 3/51

P(Both aces) = 4/52 × 3/51 = 12/2652 = 1/221

**Answer: 1/221**

</details>

**Q15.** A bag contains 6 white and 4 black balls. Three balls are drawn successively without replacement. Find probability all are white.

<details> <summary>Solution</summary>

P(1st white) = 6/10
P(2nd white | 1st white) = 5/9
P(3rd white | first 2 white) = 4/8

P(All white) = 6/10 × 5/9 × 4/8 = 120/720 = 1/6

**Answer: 1/6**

</details>

---

## TYPE 6: At Least / At Most Problems

**Q16.** Two coins are tossed. Find probability of getting at least one head.

<details> <summary>Solution</summary>

**Method 1 (Using complement):**
P(At least 1 head) = 1 - P(No heads)
= 1 - P(Both tails)
= 1 - (1/2 × 1/2)
= 1 - 1/4 = 3/4

**Method 2 (Direct):**
Favorable outcomes: HH, HT, TH = 3
Total outcomes = 4
P = 3/4

**Answer: 3/4**

</details>

**Q17.** Three coins are tossed. Find probability of getting at least 2 heads.

<details> <summary>Solution</summary>

Total outcomes = 8

Favorable: HHH, HHT, HTH, THH = 4

P(At least 2 heads) = 4/8 = 1/2

**Answer: 1/2**

</details>

**Q18.** A die is rolled twice. Find probability of getting at least one six.

<details> <summary>Solution</summary>

P(At least one 6) = 1 - P(No 6 in both rolls)
= 1 - (5/6 × 5/6)
= 1 - 25/36
= 11/36

**Answer: 11/36**

</details>

---

## TYPE 7: Combinations in Probability

**Q19.** A committee of 3 is chosen from 5 men and 4 women. Find probability that committee has 2 men and 1 woman.

<details> <summary>Solution</summary>

Total ways = C(9,3) = 84

Favorable ways = C(5,2) × C(4,1) = 10 × 4 = 40

P = 40/84 = 10/21

**Answer: 10/21**

</details>

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

---

## TYPE 8: Card Problems

**Q21.** Two cards are drawn from a deck without replacement. Find probability both are hearts.

<details> <summary>Solution</summary>

P(1st heart) = 13/52
P(2nd heart | 1st heart) = 12/51

P(Both hearts) = 13/52 × 12/51 = 156/2652 = 1/17

**Answer: 1/17**

</details>

**Q22.** A card is drawn from a deck. Find probability it's a face card (Jack, Queen, King).

<details> <summary>Solution</summary>

Face cards = 3 per suit × 4 suits = 12

P(Face card) = 12/52 = 3/13

**Answer: 3/13**

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

---

## TYPE 9: Defective Items Problems

**Q24.** A box contains 10 good and 3 defective bulbs. Two bulbs are selected at random. Find probability both are good.

<details> <summary>Solution</summary>

Total bulbs = 13

P(1st good) = 10/13
P(2nd good | 1st good) = 9/12

P(Both good) = 10/13 × 9/12 = 90/156 = 15/26

**Answer: 15/26**

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

---

## TYPE 10: Independent Trials

**Q26.** The probability of hitting a target is 1/3. If 3 shots are fired independently, find probability of hitting target at least once.

<details> <summary>Solution</summary>

P(Hit at least once) = 1 - P(Miss all 3)

P(Miss) = 1 - 1/3 = 2/3

P(Miss all) = (2/3)³ = 8/27

P(Hit at least once) = 1 - 8/27 = 19/27

**Answer: 19/27**

</details>

**Q27.** Two students attempt to solve a problem independently. Their probabilities of solving are 1/2 and 1/3. Find probability that problem is solved.

<details> <summary>Solution</summary>

P(Problem solved) = 1 - P(Both fail)

P(1st fails) = 1 - 1/2 = 1/2
P(2nd fails) = 1 - 1/3 = 2/3

P(Both fail) = 1/2 × 2/3 = 1/3

P(Problem solved) = 1 - 1/3 = 2/3

**Answer: 2/3**

</details>

---

## TYPE 11: Selecting from Groups

**Q28.** A bag contains 5 white, 7 red, and 8 black balls. If 3 balls are drawn at random, find probability that all are of different colors.

<details> <summary>Solution</summary>

Total ways = C(20,3) = 1140

Favorable ways = C(5,1) × C(7,1) × C(8,1) = 5 × 7 × 8 = 280

P = 280/1140 = 14/57

**Answer: 14/57**

</details>

**Q29.** There are 4 red, 3 black, and 5 white balls in a bag. Three balls are drawn. Find probability that exactly 2 are red.

<details> <summary>Solution</summary>

Total ways = C(12,3) = 220

Favorable = C(4,2) × C(8,1) = 6 × 8 = 48

P = 48/220 = 12/55

**Answer: 12/55**

</details>

---

## SPECIAL SECTION: DIE PROBLEMS

### Single Die

**D1.** Find probability of getting a prime number on rolling a die.

<details> <summary>Solution</summary>

Prime numbers on die: 2, 3, 5 = 3 numbers

P = 3/6 = 1/2

**Answer: 1/2**

</details>

**D2.** A die is rolled. Find probability of getting a number greater than 4.

<details> <summary>Solution</summary>

Numbers > 4: 5, 6 = 2 numbers

P = 2/6 = 1/3

**Answer: 1/3**

</details>

**D3.** What is the probability of getting a multiple of 3 when a die is thrown?

<details> <summary>Solution</summary>

Multiples of 3: 3, 6 = 2 numbers

P = 2/6 = 1/3

**Answer: 1/3**

</details>

### Two Dice

**D4.** Two dice are thrown. Find probability of getting a sum of 7.

<details> <summary>Solution</summary>

Total outcomes = 6 × 6 = 36

Favorable: (1,6), (2,5), (3,4), (4,3), (5,2), (6,1) = 6 outcomes

P = 6/36 = 1/6

**Answer: 1/6**

</details>

**D5.** Two dice are rolled. Find probability that sum is greater than 9.

<details> <summary>Solution</summary>

Sum > 9 means sum = 10, 11, or 12

Sum = 10: (4,6), (5,5), (6,4) = 3 ways
Sum = 11: (5,6), (6,5) = 2 ways
Sum = 12: (6,6) = 1 way

Total = 6 ways

P = 6/36 = 1/6

**Answer: 1/6**

</details>

**D6.** Two dice are thrown simultaneously. Find probability of getting a doublet (same number on both).

<details> <summary>Solution</summary>

Doublets: (1,1), (2,2), (3,3), (4,4), (5,5), (6,6) = 6 outcomes

P = 6/36 = 1/6

**Answer: 1/6**

</details>

**D7.** Two dice are thrown. Find probability that product of numbers is 12.

<details> <summary>Solution</summary>

Product = 12: (2,6), (3,4), (4,3), (6,2) = 4 outcomes

P = 4/36 = 1/9

**Answer: 1/9**

</details>

**D8.** Two dice are rolled. Find probability that at least one shows 6.

<details> <summary>Solution</summary>

P(At least one 6) = 1 - P(No 6 on both)

P(No 6) = 5/6 on each die

P(No 6 on both) = 5/6 × 5/6 = 25/36

P(At least one 6) = 1 - 25/36 = 11/36

**Answer: 11/36**

</details>

**D9.** Two dice are thrown. What is the probability of getting an even sum?

<details> <summary>Solution</summary>

Even sum occurs when:
- Both even: 3 × 3 = 9 ways
- Both odd: 3 × 3 = 9 ways

Total = 18 ways

P = 18/36 = 1/2

**Answer: 1/2**

</details>

**D10.** Two dice are thrown together. Find probability that difference between numbers is 2.

<details> <summary>Solution</summary>

Difference = 2:
(1,3), (2,4), (3,5), (4,6) = 4 ways
(3,1), (4,2), (5,3), (6,4) = 4 ways

Total = 8 ways

P = 8/36 = 2/9

**Answer: 2/9**

</details>

### Three Dice

**D11.** Three dice are thrown. Find probability of getting a sum of 10.

<details> <summary>Solution</summary>

Total outcomes = 6³ = 216

Combinations for sum = 10:
(1,3,6), (1,4,5), (2,2,6), (2,3,5), (2,4,4), (3,3,4) and their arrangements

(1,3,6): 3! = 6 ways
(1,4,5): 3! = 6 ways
(2,2,6): 3!/2! = 3 ways
(2,3,5): 3! = 6 ways
(2,4,4): 3!/2! = 3 ways
(3,3,4): 3!/2! = 3 ways

Total = 6 + 6 + 3 + 6 + 3 + 3 = 27 ways

P = 27/216 = 1/8

**Answer: 1/8**

</details>

**D12.** Three dice are rolled. Find probability that all show different numbers.

<details> <summary>Solution</summary>

Total outcomes = 216

For all different:
1st die: 6 choices
2nd die: 5 choices
3rd die: 4 choices

Favorable = 6 × 5 × 4 = 120

P = 120/216 = 5/9

**Answer: 5/9**

</details>

---

## SPECIAL SECTION: COLORED BALL PICKING

### Basic Ball Selection

**B1.** A bag contains 5 red, 4 blue, and 3 yellow balls. One ball is picked at random. Find probability it's blue.

<details> <summary>Solution</summary>

Total balls = 12
Blue balls = 4

P(Blue) = 4/12 = 1/3

**Answer: 1/3**

</details>

**B2.** A bag has 6 red and 8 green balls. Two balls are drawn at random. Find probability both are red.

<details> <summary>Solution</summary>

**Without replacement:**
P = 6/14 × 5/13 = 30/182 = 15/91

**Answer: 15/91**

</details>

**B3.** A box contains 7 white and 5 black balls. Three balls are drawn at random. Find probability that 2 are white and 1 is black.

<details> <summary>Solution</summary>

Total ways = C(12,3) = 220

Favorable = C(7,2) × C(5,1) = 21 × 5 = 105

P = 105/220 = 21/44

**Answer: 21/44**

</details>

### Multiple Color Selection

**B4.** A bag contains 4 red, 5 blue, and 6 green balls. If 3 balls are randomly selected, find probability all are of same color.

<details> <summary>Solution</summary>

Total ways = C(15,3) = 455

All red = C(4,3) = 4
All blue = C(5,3) = 10
All green = C(6,3) = 20

Favorable = 4 + 10 + 20 = 34

P = 34/455 = 2/65 (approximately)

**Answer: 34/455**

</details>

**B5.** A bag has 3 red, 4 white, and 5 blue balls. Three balls are drawn. Find probability that one is of each color.

<details> <summary>Solution</summary>

Total ways = C(12,3) = 220

Favorable = C(3,1) × C(4,1) × C(5,1) = 3 × 4 × 5 = 60

P = 60/220 = 3/11

**Answer: 3/11**

</details>

**B6.** A urn contains 5 red, 3 white, and 2 black balls. Two balls are drawn. Find probability both are of same color.

<details> <summary>Solution</summary>

Total ways = C(10,2) = 45

Both red = C(5,2) = 10
Both white = C(3,2) = 3
Both black = C(2,2) = 1

Favorable = 10 + 3 + 1 = 14

P = 14/45

**Answer: 14/45**

</details>

### With Replacement Problems

**B7.** A bag contains 3 red and 2 blue balls. Two balls are drawn with replacement. Find probability both are red.

<details> <summary>Solution</summary>

P(1st red) = 3/5
P(2nd red) = 3/5 (replacement)

P(Both red) = 3/5 × 3/5 = 9/25

**Answer: 9/25**

</details>

**B8.** A box has 4 red, 5 blue, and 6 green balls. Two balls are drawn with replacement. Find probability they are of different colors.

<details> <summary>Solution</summary>

P(Same color) = P(Both red) + P(Both blue) + P(Both green)
= (4/15)² + (5/15)² + (6/15)²
= 16/225 + 25/225 + 36/225
= 77/225

P(Different colors) = 1 - 77/225 = 148/225

**Answer: 148/225**

</details>

### Complex Ball Problems

**B9.** A bag contains 5 white and 4 black balls. A ball is drawn and replaced along with 2 more of same color. Then another ball is drawn. Find probability that second ball is white.

<details> <summary>Solution</summary>

Case 1: 1st white, then 2nd white
P = 5/9 × 7/11 = 35/99

Case 2: 1st black, then 2nd white
P = 4/9 × 5/11 = 20/99

P(2nd white) = 35/99 + 20/99 = 55/99 = 5/9

**Answer: 5/9**

</details>

**B10.** Two bags: Bag A has 3 red and 4 blue balls. Bag B has 5 red and 2 blue balls. One ball is transferred from A to B, then a ball is drawn from B. Find probability it's red.

<details> <summary>Solution</summary>

Case 1: Red transferred from A, then red from B
P = 3/7 × 6/8 = 18/56

Case 2: Blue transferred from A, then red from B
P = 4/7 × 5/8 = 20/56

P(Red from B) = 18/56 + 20/56 = 38/56 = 19/28

**Answer: 19/28**

</details>

**B11.** A bag contains 6 red, 4 white, and 8 blue balls. If 4 balls are drawn at random, find probability that at least one is red.

<details> <summary>Solution</summary>

Total balls = 18

P(At least 1 red) = 1 - P(No red)

P(No red) = C(12,4) / C(18,4)
= 495 / 3060
= 33/204

P(At least 1 red) = 1 - 33/204 = 171/204 = 57/68

**Answer: 57/68**

</details>

**B12.** A box has 5 red, 6 blue, and 4 green balls. Three balls are randomly selected without replacement. Find probability that first is red, second is blue, and third is green.

<details> <summary>Solution</summary>

P(1st red) = 5/15
P(2nd blue | 1st red) = 6/14
P(3rd green | 1st red, 2nd blue) = 4/13

P = 5/15 × 6/14 × 4/13 = 120/2730 = 4/91

**Answer: 4/91**

</details>

---

## BONUS: Quick Mental Math Questions

**Q31.** Probability of getting head in coin toss?

<details> <summary>Solution</summary>

P = 1/2

</details>

**Q32.** Two coins tossed, P(At least 1 head)?

<details> <summary>Solution</summary>

P = 3/4

</details>

**Q33.** One die, P(Number > 4)?

<details> <summary>Solution</summary>

P = 2/6 = 1/3

</details>

**Q34.** Two dice, P(Sum = 7)?

<details> <summary>Solution</summary>

P = 6/36 = 1/6

</details>

**Q35.** 52 cards, P(Ace)?

<details> <summary>Solution</summary>

P = 4/52 = 1/13

</details>

---

## KEY FORMULAS SUMMARY

1. **Basic Probability:**
   P(Event) = (Favorable outcomes)/(Total outcomes)

2. **Complement Rule:**
   P(Not A) = 1 - P(A)

3. **AND (Independent Events):**
   P(A and B) = P(A) × P(B)

4. **OR (Mutually Exclusive):**
   P(A or B) = P(A) + P(B)

5. **OR (Not Mutually Exclusive):**
   P(A or B) = P(A) + P(B) - P(A and B)

6. **Conditional Probability:**
   P(B|A) = P(A and B) / P(A)

7. **At Least One:**
   P(At least one) = 1 - P(None)

8. **Combinations:**
   C(n,r) = n! / (r! × (n-r)!)

---

## Important Probability Values to Remember

**Dice:**
- P(Any specific number) = 1/6
- P(Sum = 7 with 2 dice) = 6/36 = 1/6
- P(Doublet with 2 dice) = 6/36 = 1/6

**Cards:**
- P(Specific suit) = 13/52 = 1/4
- P(Face card) = 12/52 = 3/13
- P(Ace) = 4/52 = 1/13
- P(Red card) = 26/52 = 1/2

**Coins:**
- P(Head or Tail) = 1/2
- P(At least 1 head in 2 tosses) = 3/4
- P(At least 1 head in 3 tosses) = 7/8

---

## Practice Strategy for Probability:

1. Always identify if events are independent or dependent
2. For "at least" problems, use complement rule (1 - P(none))
3. In card problems, remember 52 total, 4 suits of 13 each
4. For dice, memorize common sum probabilities
5. In ball problems, check if replacement is mentioned
6. Use combinations for "ways to select" problems
7. Draw tree diagrams for complex sequential events
8. Time target: 60-90 seconds per question

**Pro Tips:**
- "At least one" = 1 - "None"
- "With replacement" = events are independent
- "Without replacement" = conditional probability
- For multiple trials, use (success)^n or (failure)^n
- Always simplify fractions in final answer
- Check if events are mutually exclusive before adding probabilities
- In colored ball problems, track each draw step-by-step