## EXAMPLE 1: PLAY TENNIS DECISION (STEP-BY-STEP TREE BUILDING)

Let's decide whether to **Play Tennis** based on weather conditions.

### **Training Dataset:**

|Day|Outlook|Temperature|Humidity|Wind|Play Tennis|
|---|---|---|---|---|---|
|1|Sunny|Hot|High|Weak|No|
|2|Sunny|Hot|High|Strong|No|
|3|Overcast|Hot|High|Weak|Yes|
|4|Rain|Mild|High|Weak|Yes|
|5|Rain|Cool|Normal|Weak|Yes|
|6|Rain|Cool|Normal|Strong|No|
|7|Overcast|Cool|Normal|Strong|Yes|
|8|Sunny|Mild|High|Weak|No|
|9|Sunny|Cool|Normal|Weak|Yes|
|10|Rain|Mild|Normal|Weak|Yes|
|11|Sunny|Mild|Normal|Strong|Yes|
|12|Overcast|Mild|High|Strong|Yes|
|13|Overcast|Hot|Normal|Weak|Yes|
|14|Rain|Mild|High|Strong|No|

**Summary:**

- Total: 14 days
- Play=Yes: 9 days
- Play=No: 5 days

---

## STEP 1: CALCULATE ROOT NODE ENTROPY

**Formula:** Entropy = -Σ(pᵢ × log₂(pᵢ))

```
At Root (all 14 samples):
P(Yes) = 9/14 = 0.643
P(No) = 5/14 = 0.357

Entropy(Root) = -(0.643 × log₂(0.643) + 0.357 × log₂(0.357))
              = -(0.643 × (-0.638) + 0.357 × (-1.486))
              = -(-0.410 - 0.530)
              = 0.940
```

**Interpretation:** High entropy (0.940) means data is impure/mixed. We need to split!

---

## STEP 2: CALCULATE INFORMATION GAIN FOR EACH FEATURE

We'll try splitting on each feature and see which gives the best Information Gain.

### **OPTION 1: Split on OUTLOOK**

Outlook has 3 values: Sunny, Overcast, Rain

**Sunny (5 samples):**

- Days: 1, 2, 8, 9, 11
- Yes: 2 (days 9, 11)
- No: 3 (days 1, 2, 8)

```
P(Yes|Sunny) = 2/5 = 0.4
P(No|Sunny) = 3/5 = 0.6

Entropy(Sunny) = -(0.4 × log₂(0.4) + 0.6 × log₂(0.6))
               = -(0.4 × (-1.322) + 0.6 × (-0.737))
               = -(-0.529 - 0.442)
               = 0.971
```

**Overcast (4 samples):**

- Days: 3, 7, 12, 13
- Yes: 4 (all of them!)
- No: 0

```
P(Yes|Overcast) = 4/4 = 1.0
P(No|Overcast) = 0/4 = 0

Entropy(Overcast) = -(1.0 × log₂(1.0) + 0 × log₂(0))
                  = -(0 + 0)
                  = 0  ← PURE! Perfect split!
```

**Rain (5 samples):**

- Days: 4, 5, 6, 10, 14
- Yes: 3 (days 4, 5, 10)
- No: 2 (days 6, 14)

```
P(Yes|Rain) = 3/5 = 0.6
P(No|Rain) = 2/5 = 0.4

Entropy(Rain) = -(0.6 × log₂(0.6) + 0.4 × log₂(0.4))
              = -(0.6 × (-0.737) + 0.4 × (-1.322))
              = -(-0.442 - 0.529)
              = 0.971
```

**Weighted Average Entropy after splitting on Outlook:**

```
Entropy(after Outlook split) = (5/14) × 0.971 + (4/14) × 0 + (5/14) × 0.971
                              = 0.347 + 0 + 0.347
                              = 0.694
```

**Information Gain for Outlook:**

```
Gain(Outlook) = Entropy(Root) - Entropy(after split)
              = 0.940 - 0.694
              = 0.246
```

---

### **OPTION 2: Split on HUMIDITY**

Humidity has 2 values: High, Normal

**High (7 samples):**

- Days: 1, 2, 3, 4, 8, 12, 14
- Yes: 3 (days 3, 4, 12)
- No: 4 (days 1, 2, 8, 14)

```
P(Yes|High) = 3/7 = 0.429
P(No|High) = 4/7 = 0.571

Entropy(High) = -(0.429 × log₂(0.429) + 0.571 × log₂(0.571))
              = -(0.429 × (-1.222) + 0.571 × (-0.808))
              = -(-0.524 - 0.461)
              = 0.985
```

**Normal (7 samples):**

- Days: 5, 6, 7, 9, 10, 11, 13
- Yes: 6 (days 5, 7, 9, 10, 11, 13)
- No: 1 (day 6)

```
P(Yes|Normal) = 6/7 = 0.857
P(No|Normal) = 1/7 = 0.143

Entropy(Normal) = -(0.857 × log₂(0.857) + 0.143 × log₂(0.143))
                = -(0.857 × (-0.222) + 0.143 × (-2.807))
                = -(-0.190 - 0.401)
                = 0.591
```

**Weighted Average Entropy:**

```
Entropy(after Humidity split) = (7/14) × 0.985 + (7/14) × 0.591
                               = 0.493 + 0.296
                               = 0.789
```

**Information Gain for Humidity:**

```
Gain(Humidity) = 0.940 - 0.789 = 0.151
```

---

### **OPTION 3: Split on WIND**

Wind has 2 values: Weak, Strong

**Weak (8 samples):**

- Days: 1, 3, 4, 5, 8, 9, 10, 13
- Yes: 6 (days 3, 4, 5, 9, 10, 13)
- No: 2 (days 1, 8)

```
P(Yes|Weak) = 6/8 = 0.75
P(No|Weak) = 2/8 = 0.25

Entropy(Weak) = -(0.75 × log₂(0.75) + 0.25 × log₂(0.25))
              = -(0.75 × (-0.415) + 0.25 × (-2.0))
              = -(-0.311 - 0.500)
              = 0.811
```

**Strong (6 samples):**

- Days: 2, 6, 7, 11, 12, 14
- Yes: 3 (days 7, 11, 12)
- No: 3 (days 2, 6, 14)

```
P(Yes|Strong) = 3/6 = 0.5
P(No|Strong) = 3/6 = 0.5

Entropy(Strong) = -(0.5 × log₂(0.5) + 0.5 × log₂(0.5))
                = -(0.5 × (-1) + 0.5 × (-1))
                = -(-0.5 - 0.5)
                = 1.0  ← Maximum entropy! 50-50 split
```

**Weighted Average Entropy:**

```
Entropy(after Wind split) = (8/14) × 0.811 + (6/14) × 1.0
                          = 0.463 + 0.429
                          = 0.892
```

**Information Gain for Wind:**

```
Gain(Wind) = 0.940 - 0.892 = 0.048
```

---

### **OPTION 4: Split on TEMPERATURE**

Temperature has 3 values: Hot, Mild, Cool

**Hot (4 samples):**

- Days: 1, 2, 3, 13
- Yes: 2 (days 3, 13)
- No: 2 (days 1, 2)

```
Entropy(Hot) = -(0.5 × log₂(0.5) + 0.5 × log₂(0.5)) = 1.0
```

**Mild (6 samples):**

- Days: 4, 8, 10, 11, 12, 14
- Yes: 4 (days 4, 10, 11, 12)
- No: 2 (days 8, 14)

```
P(Yes|Mild) = 4/6 = 0.667
P(No|Mild) = 2/6 = 0.333

Entropy(Mild) = -(0.667 × log₂(0.667) + 0.333 × log₂(0.333))
              = -(0.667 × (-0.585) + 0.333 × (-1.585))
              = -(-0.390 - 0.528)
              = 0.918
```

**Cool (4 samples):**

- Days: 5, 6, 7, 9
- Yes: 3 (days 5, 7, 9)
- No: 1 (day 6)

```
P(Yes|Cool) = 3/4 = 0.75
P(No|Cool) = 1/4 = 0.25

Entropy(Cool) = -(0.75 × log₂(0.75) + 0.25 × log₂(0.25))
              = 0.811
```

**Weighted Average Entropy:**

```
Entropy(after Temperature split) = (4/14) × 1.0 + (6/14) × 0.918 + (4/14) × 0.811
                                  = 0.286 + 0.393 + 0.231
                                  = 0.910
```

**Information Gain for Temperature:**

```
Gain(Temperature) = 0.940 - 0.910 = 0.030
```

---

## STEP 3: COMPARE INFORMATION GAINS

```
Feature         Information Gain
-----------------------------------
Outlook         0.246  ← HIGHEST! Best split
Humidity        0.151
Wind            0.048
Temperature     0.030
```

**Decision:** Split on **OUTLOOK** at the root because it has the highest Information Gain!

---

## STEP 4: BUILD THE TREE

### **Root Node: Split on OUTLOOK**

```
                    [All 14 samples]
                    Yes: 9, No: 5
                         |
              ┌──────────┼──────────┐
              |          |          |
          Outlook=   Outlook=   Outlook=
           Sunny    Overcast     Rain
              |          |          |
         [5 samples] [4 samples] [5 samples]
         Yes:2 No:3  Yes:4 No:0  Yes:3 No:2
```

---

### **Branch 1: OVERCAST**

```
Samples: 4 (days 3, 7, 12, 13)
Yes: 4
No: 0

This is PURE! All samples are "Yes"
Leaf Node: Predict YES
```

**No need to split further!**

---

### **Branch 2: SUNNY (Need to split further)**

```
Samples: 5 (days 1, 2, 8, 9, 11)
Yes: 2
No: 3

Still impure, need another split
```

**Current Entropy:**

```
Entropy(Sunny) = 0.971 (calculated earlier)
```

**Try splitting on remaining features:** Temperature, Humidity, Wind

**Split on HUMIDITY:**

- **High (3 samples):** Days 1, 2, 8 → All No (0 Yes, 3 No) → Entropy = 0 ✓
- **Normal (2 samples):** Days 9, 11 → All Yes (2 Yes, 0 No) → Entropy = 0 ✓

```
Information Gain = 0.971 - 0 = 0.971  ← PERFECT SPLIT!
```

**Split on WIND:**

- **Weak (3 samples):** Days 1, 8, 9 → Mixed (1 Yes, 2 No)
- **Strong (2 samples):** Days 2, 11 → Mixed (1 Yes, 1 No)

```
Not as good as Humidity
```

**Decision:** When Outlook=Sunny, split on **HUMIDITY**

```
Outlook = Sunny
    |
    ├─ Humidity = High
    |     → Predict NO (3 samples, all No)
    |
    └─ Humidity = Normal
          → Predict YES (2 samples, all Yes)
```

---

### **Branch 3: RAIN (Need to split further)**

```
Samples: 5 (days 4, 5, 6, 10, 14)
Yes: 3
No: 2

Entropy(Rain) = 0.971
```

**Try splitting on remaining features:**

**Split on WIND:**

- **Weak (3 samples):** Days 4, 5, 10 → All Yes (3 Yes, 0 No) → Entropy = 0 ✓
- **Strong (2 samples):** Days 6, 14 → All No (0 Yes, 2 No) → Entropy = 0 ✓

```
Information Gain = 0.971 - 0 = 0.971  ← PERFECT SPLIT!
```

**Decision:** When Outlook=Rain, split on **WIND**

```
Outlook = Rain
    |
    ├─ Wind = Weak
    |     → Predict YES (3 samples, all Yes)
    |
    └─ Wind = Strong
          → Predict NO (2 samples, all No)
```

---

## FINAL DECISION TREE

```
                    ROOT: Outlook?
                         |
        ┌────────────────┼────────────────┐
        |                |                |
    Sunny           Overcast            Rain
        |                |                |
    Humidity?         [YES]            Wind?
        |           (4 samples)           |
    ┌───┴───┐                        ┌───┴───┐
    |       |                        |       |
  High   Normal                    Weak   Strong
    |       |                        |       |
  [NO]    [YES]                    [YES]   [NO]
(3 days) (2 days)                (3 days) (2 days)
```

**Tree Statistics:**

- Depth: 2
- Total nodes: 9 (5 leaf nodes, 4 internal nodes)
- All leaf nodes are pure (100% one class)

---

## STEP 5: MAKE PREDICTIONS

### **Test 1:** Outlook=Sunny, Humidity=High, Wind=Weak

```
Follow path:
1. Root: Outlook = Sunny → Go left
2. Humidity = High → Go left
3. Leaf node: NO

Prediction: Don't play tennis
```

### **Test 2:** Outlook=Overcast, Temperature=Hot, Humidity=High

```
Follow path:
1. Root: Outlook = Overcast → Go middle
2. Leaf node: YES

Prediction: Play tennis

Note: Temperature and Humidity don't matter when Overcast!
```

### **Test 3:** Outlook=Rain, Wind=Weak

```
Follow path:
1. Root: Outlook = Rain → Go right
2. Wind = Weak → Go left
3. Leaf node: YES

Prediction: Play tennis
```

---

## GINI IMPURITY VERSION (Alternative)

Let's calculate using **Gini** instead of Entropy for comparison.

**Formula:** Gini = 1 - Σ(pᵢ²)

### **Root Node Gini:**

```
P(Yes) = 9/14 = 0.643
P(No) = 5/14 = 0.357

Gini(Root) = 1 - (0.643² + 0.357²)
           = 1 - (0.413 + 0.127)
           = 1 - 0.540
           = 0.460
```

### **After splitting on OUTLOOK:**

**Sunny:**

```
P(Yes) = 2/5 = 0.4
P(No) = 3/5 = 0.6

Gini(Sunny) = 1 - (0.4² + 0.6²)
            = 1 - (0.16 + 0.36)
            = 1 - 0.52
            = 0.48
```

**Overcast:**

```
Gini(Overcast) = 1 - (1² + 0²) = 0  ← Pure!
```

**Rain:**

```
P(Yes) = 3/5 = 0.6
P(No) = 2/5 = 0.4

Gini(Rain) = 1 - (0.6² + 0.4²)
           = 1 - (0.36 + 0.16)
           = 0.48
```

**Weighted Average Gini:**

```
Gini(after split) = (5/14) × 0.48 + (4/14) × 0 + (5/14) × 0.48
                  = 0.171 + 0 + 0.171
                  = 0.342
```

**Gini Reduction:**

```
Gini Reduction = 0.460 - 0.342 = 0.118
```

**Result:** Outlook still has the highest Gini reduction (best split). **Same tree structure!**

---

## EXAMPLE 2: LOAN APPROVAL (NUMERICAL + CATEGORICAL)

Predict loan approval based on Age, Income, Credit Score, and Employment.

### **Training Dataset:**

|ID|Age|Income|Credit Score|Employment|Approved|
|---|---|---|---|---|---|
|1|25|30k|600|Part-time|No|
|2|30|50k|700|Full-time|Yes|
|3|35|60k|750|Full-time|Yes|
|4|40|70k|800|Full-time|Yes|
|5|22|25k|580|Student|No|
|6|28|45k|680|Full-time|Yes|
|7|50|80k|720|Full-time|Yes|
|8|23|28k|590|Part-time|No|
|9|32|55k|710|Full-time|Yes|
|10|26|35k|620|Part-time|No|

**Summary:**

- Total: 10 applicants
- Approved: 6
- Rejected: 4

---

### **STEP 1: Calculate Root Gini**

```
P(Yes) = 6/10 = 0.6
P(No) = 4/10 = 0.4

Gini(Root) = 1 - (0.6² + 0.4²)
           = 1 - (0.36 + 0.16)
           = 0.48
```

---

### **STEP 2: Find Best Split for INCOME (Numerical)**

Income values: [25k, 28k, 30k, 35k, 45k, 50k, 55k, 60k, 70k, 80k]

**Try threshold: Income ≤ 40k**

**Left (Income ≤ 40k): 5 samples**

- IDs: 1, 5, 8, 10, (and partially 6 at 45k, but let's say) Actually: 1, 5, 8, 10
- Actually IDs: 1, 5, 8, 10 (all at or below 35k)
- Yes: 0
- No: 4

```
Gini(≤40k) = 1 - (0² + 1²) = 0  ← Pure!
```

**Right (Income > 40k): 6 samples**

- IDs: 2, 3, 4, 6, 7, 9
- Yes: 6
- No: 0

```
Gini(>40k) = 1 - (1² + 0²) = 0  ← Pure!
```

**Weighted Gini:**

```
Gini(after Income split at 40k) = (4/10) × 0 + (6/10) × 0 = 0

Gini Reduction = 0.48 - 0 = 0.48  ← PERFECT SPLIT!
```

---

### **Try threshold: Income ≤ 32.5k** (midpoint between 30k and 35k)

**Left (≤32.5k): 4 samples**

- IDs: 1, 5, 8 (and close to 10)
- Let's be precise: 1, 5, 8 (25k, 30k, 28k)
- Yes: 0
- No: 3 (wait, need to recount based on actual data)

Let me recalculate more carefully:

**Income sorted:** 25k, 28k, 30k, 35k, 45k, 50k, 55k, 60k, 70k, 80k

**Best split around 40k (between 35k and 45k):**

**Left (≤37.5k):** IDs 1, 5, 8, 10 (incomes: 30k, 25k, 28k, 35k)

- Approved: 0
- Rejected: 4
- Gini = 0

**Right (>37.5k):** IDs 2, 3, 4, 6, 7, 9 (incomes: 50k, 60k, 70k, 45k, 80k, 55k)

- Approved: 6
- Rejected: 0
- Gini = 0

**Perfect split at Income threshold ≈ 40k!**

---

### **FINAL TREE (Simple Version)**

```
                ROOT: Income?
                      |
        ┌─────────────┴─────────────┐
        |                           |
    Income ≤ 40k              Income > 40k
        |                           |
      [NO]                        [YES]
   (4 samples)                 (6 samples)
   All rejected               All approved
```

**Tree Statistics:**

- Depth: 1 (very shallow!)
- Nodes: 3 (1 root, 2 leaves)
- Perfect classification on training data

---

### **Predictions:**

**Test 1:** Age=27, Income=38k, Credit=650, Employment=Full-time

```
Income = 38k ≤ 40k → Go left
Prediction: REJECTED
```

**Test 2:** Age=35, Income=65k, Credit=750, Employment=Full-time

```
Income = 65k > 40k → Go right
Prediction: APPROVED
```

---

## EXAMPLE 3: ANIMAL CLASSIFICATION (MULTI-CLASS)

Classify animals as Dog, Cat, or Bird based on features.

### **Training Dataset:**

|Animal|Has Fur|Can Fly|Legs|Size|Class|
|---|---|---|---|---|---|
|A1|Yes|No|4|Medium|Dog|
|A2|Yes|No|4|Small|Cat|
|A3|No|Yes|2|Small|Bird|
|A4|Yes|No|4|Large|Dog|
|A5|Yes|No|4|Small|Cat|
|A6|No|Yes|2|Small|Bird|
|A7|Yes|No|4|Medium|Dog|
|A8|No|Yes|2|Tiny|Bird|
|A9|Yes|No|4|Small|Cat|

**Summary:**

- Total: 9 animals
- Dogs: 3
- Cats: 3
- Birds: 3

---

### **Root Gini:**

```
P(Dog) = 3/9 = 0.333
P(Cat) = 3/9 = 0.333
P(Bird) = 3/9 = 0.333

Gini(Root) = 1 - (0.333² + 0.333² + 0.333²)
           = 1 - (0.111 + 0.111 + 0.111)
           = 1 - 0.333
           = 0.667
```

---

### **Split on CAN FLY:**

**Can Fly = Yes (3 samples):**

- A3, A6, A8 (all Birds)
- Dog: 0, Cat: 0, Bird: 3

```
Gini(Fly=Yes) = 1 - (0² + 0² + 1²) = 0  ← Pure!
```

**Can Fly = No (6 samples):**

- A1, A2, A4, A5, A7, A9
- Dog: 3, Cat: 3, Bird: 0

```
P(Dog) = 3/6 = 0.5
P(Cat) = 3/6 = 0.5
P(Bird) = 0

Gini(Fly=No) = 1 - (0.5² + 0.5² + 0²)
             = 1 - (0.25 + 0.25 + 0)
             = 0.5
```

**Weighted Gini:**

```
Gini(after Fly split) = (3/9) × 0 + (6/9) × 0.5
                      = 0 + 0.333
                      = 0.333

Gini Reduction = 0.667 - 0.333 = 0.334
```

---

### **For Can Fly = No branch, split on SIZE:**

**Size = Small (4 samples):**

- A2, A5, A9 (all Cats)
- Dog: 0, Cat: 3 (wait, 4 samples but only 3 cats?)

Let me recount:

- A2 (Cat, Small)
- A5 (Cat, Small)
- A9 (Cat, Small)

Actually only 3 small animals in the "Can't Fly" group.

Let's recalculate:

**Can Fly = No (6 samples): A1, A2, A4, A5, A7, A9**

**Split on SIZE:**

**Small (3 samples):** A2, A5, A9 → All Cats

```
Gini = 0  ← Pure!
```

**Medium (2 samples):** A1, A7 → All Dogs

```
Gini = 0  ← Pure!
```

**Large (1 sample):** A4 → Dog

```
Gini = 0  ← Pure!
```

**Perfect split!**

---

### **FINAL TREE:**

```
                    ROOT: Can Fly?
                         |
        ┌────────────────┴────────────────┐
        |                                 |
      Yes                                No
        |                                 |
     [BIRD]                           Size?
   (3 samples)                            |
   All birds          ┌─────────┬─────────┴─────────┐
                      |         |                   |
                   Small     Medium              Large
                      |         |                   |
                    [CAT]     [DOG]               [DOG]
                 (3 samples) (2 samples)        (1 sample)
```

**Tree Statistics:**

- Depth: 2
- Perfect classification
- Clear logic: "Can it fly?" → Bird. "No? How big?" → Cat (small) or Dog (medium/large)

---

### **Predictions:**

**Test 1:** Has Fur=Yes, Can Fly=No, Legs=4, Size=Small

```
1. Can Fly = No → Go right
2. Size = Small → Go left
3. Prediction: CAT
```

**Test 2:** Has Fur=No, Can Fly=Yes, Legs=2, Size=Tiny

```
1. Can Fly = Yes → Go left
2. Prediction: BIRD
```

---

## EXAMPLE 4: STUDENT PASS/FAIL (SHOWING OVERFITTING)

### **Training Dataset:**

|Student|Study Hours|Sleep Hours|Attendance %|Pass|
|---|---|---|---|---|
|S1|1|4|50|No|
|S2|2|5|60|No|
|S3|5|7|85|Yes|
|S4|6|8|90|Yes|
|S5|7|7|95|Yes|
|S6|3|6|70|No|
|S7|8|8|98|Yes|
|S8|4|6|75|Yes|

---

### **OVERFIT TREE (No constraints, max_depth=None):**

The tree might grow very deep:

```
                    ROOT: Study Hours ≤ 4.5?
                           |
        ┌──────────────────┴──────────────────┐
        |                                     |
       Yes                                   No
        |                                     |
   Attendance ≤ 72.5?                  Sleep ≥ 7.5?
        |                                     |
    ┌───┴───┐                             ┌───┴───┐
   Yes     No                            Yes     No
    |       |                             |       |
 Study≤2.5
```