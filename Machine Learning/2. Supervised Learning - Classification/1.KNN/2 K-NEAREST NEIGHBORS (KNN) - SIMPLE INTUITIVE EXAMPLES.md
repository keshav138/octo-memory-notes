## EXAMPLE 1: FRUIT CLASSIFICATION (2D - EASY TO VISUALIZE)

Let's classify fruits based on **Weight** and **Sweetness** (scale 1-10).

### **Training Dataset:**

|Fruit|Weight (g)|Sweetness|Label|
|---|---|---|---|
|A1|150|7|Apple|
|A2|160|8|Apple|
|A3|140|6|Apple|
|A4|155|7|Apple|
|O1|180|9|Orange|
|O2|170|8|Orange|
|O3|190|9|Orange|
|L1|60|2|Lemon|
|L2|55|3|Lemon|
|L3|65|2|Lemon|

**Visual representation:**

```
Sweetness
    10 |
     9 |              O1    O3
     8 |         A2  O2
     7 |    A1  A4
     6 |    A3
     5 |
     4 |
     3 |              L2
     2 |         L1  L3
     1 |
     0 |_________________________
        0   50  100  150  200  Weight (g)
```

---

### **PREDICTION WITH K=3 (Step-by-Step)**

**Test Point:** Weight = 165g, Sweetness = 8

**Visualize:**

```
     9 |              O1    O3
     8 |    [?]  A2  O2        ← Test point here
     7 |    A1  A4
```

---

### **Step 1: Calculate Distances**

Using **Euclidean Distance**: √[(x₁-x₂)² + (y₁-y₂)²]

**To each training point:**

```
Distance to A1 (150, 7):
d = √[(165-150)² + (8-7)²]
  = √[15² + 1²]
  = √[225 + 1]
  = √226
  = 15.03

Distance to A2 (160, 8):
d = √[(165-160)² + (8-8)²]
  = √[5² + 0²]
  = √25
  = 5.0 ✓ NEAR!

Distance to A3 (140, 6):
d = √[(165-140)² + (8-6)²]
  = √[25² + 2²]
  = √[625 + 4]
  = √629
  = 25.08

Distance to A4 (155, 7):
d = √[(165-155)² + (8-7)²]
  = √[10² + 1²]
  = √[100 + 1]
  = √101
  = 10.05

Distance to O1 (180, 9):
d = √[(165-180)² + (8-9)²]
  = √[15² + 1²]
  = √[225 + 1]
  = √226
  = 15.03

Distance to O2 (170, 8):
d = √[(165-170)² + (8-8)²]
  = √[5² + 0²]
  = √25
  = 5.0 ✓ NEAR!

Distance to O3 (190, 9):
d = √[(165-190)² + (8-9)²]
  = √[25² + 1²]
  = √[625 + 1]
  = √626
  = 25.02

Distance to L1 (60, 2):
d = √[(165-60)² + (8-2)²]
  = √[105² + 6²]
  = √[11025 + 36]
  = √11061
  = 105.17

Distance to L2 (55, 3):
d = √[(165-55)² + (8-3)²]
  = √[110² + 5²]
  = √[12100 + 25]
  = √12125
  = 110.11

Distance to L3 (65, 2):
d = √[(165-65)² + (8-2)²]
  = √[100² + 6²]
  = √[10000 + 36]
  = √10036
  = 100.18
```

---

### **Step 2: Sort by Distance**

|Rank|Point|Fruit|Distance|
|---|---|---|---|
|1|A2|Apple|5.0|
|2|O2|Orange|5.0|
|3|A4|Apple|10.05|
|4|A1|Apple|15.03|
|5|O1|Orange|15.03|
|6|A3|Apple|25.08|
|7|O3|Orange|25.02|
|8|L3|Lemon|100.18|
|9|L1|Lemon|105.17|
|10|L2|Lemon|110.11|

---

### **Step 3: Select K=3 Nearest Neighbors**

**3 Closest neighbors:**

1. A2 (Apple) - distance 5.0
2. O2 (Orange) - distance 5.0
3. A4 (Apple) - distance 10.05

---

### **Step 4: Majority Voting**

```
Votes:
Apple:  2 votes (A2, A4) ✓✓
Orange: 1 vote  (O2) ✓
Lemon:  0 votes

Prediction: APPLE (2 > 1)
```

---

### **What if K=1?**

**1 nearest neighbor:**

- A2 (Apple) at distance 5.0

**Prediction: APPLE**

---

### **What if K=5?**

**5 nearest neighbors:**

1. A2 (Apple) - 5.0
2. O2 (Orange) - 5.0
3. A4 (Apple) - 10.05
4. A1 (Apple) - 15.03
5. O1 (Orange) - 15.03

```
Votes:
Apple:  3 votes (A2, A4, A1) ✓✓✓
Orange: 2 votes (O2, O1) ✓✓

Prediction: APPLE (3 > 2)
```

---

### **Visual Understanding:**

```
     9 |              O1    O3
     8 | A2 [?] O2          
     7 |    A1  A4
     6 |    A3
     
The test point [?] is:
- Very close to A2 (Apple) and O2 (Orange)
- Moderately close to A4 (Apple)
- Far from all Lemons

With K=3: 2 Apples vs 1 Orange → Predict Apple
```

**Key Insight:** KNN literally finds the closest training examples and asks "What are my neighbors?"

---

## EXAMPLE 2: MOVIE RECOMMENDATION (WITH DIFFERENT DISTANCE METRICS)

Recommend movies based on **Action Score** and **Romance Score** (scale 1-10).

### **Training Dataset:**

|Movie|Action|Romance|Genre|
|---|---|---|---|
|Die Hard|9|2|Action|
|Terminator|10|1|Action|
|Mad Max|9|3|Action|
|The Notebook|1|10|Romance|
|Titanic|2|9|Romance|
|Love Actually|2|10|Romance|
|Avengers|8|4|Action|
|Spider-Man|7|5|Action|

---

### **Test Movie:** Action = 8, Romance = 3

**Question:** What genre is this movie?

---

### **Method 1: Euclidean Distance (K=3)**

**Calculate distances:**

```
To Die Hard (9, 2):
d = √[(8-9)² + (3-2)²] = √[1 + 1] = √2 = 1.41 ✓

To Terminator (10, 1):
d = √[(8-10)² + (3-1)²] = √[4 + 4] = √8 = 2.83 ✓

To Mad Max (9, 3):
d = √[(8-9)² + (3-3)²] = √[1 + 0] = √1 = 1.0 ✓

To The Notebook (1, 10):
d = √[(8-1)² + (3-10)²] = √[49 + 49] = √98 = 9.90

To Titanic (2, 9):
d = √[(8-2)² + (3-9)²] = √[36 + 36] = √72 = 8.49

To Love Actually (2, 10):
d = √[(8-2)² + (3-10)²] = √[36 + 49] = √85 = 9.22

To Avengers (8, 4):
d = √[(8-8)² + (3-4)²] = √[0 + 1] = √1 = 1.0 ✓

To Spider-Man (7, 5):
d = √[(8-7)² + (3-5)²] = √[1 + 4] = √5 = 2.24
```

**3 Nearest (K=3):**

1. Mad Max (Action) - 1.0
2. Avengers (Action) - 1.0
3. Die Hard (Action) - 1.41

**Vote: 3 Action, 0 Romance** **Prediction: ACTION ✓**

---

### **Method 2: Manhattan Distance (K=3)**

**Formula:** |x₁-x₂| + |y₁-y₂|

```
To Die Hard (9, 2):
d = |8-9| + |3-2| = 1 + 1 = 2 ✓

To Terminator (10, 1):
d = |8-10| + |3-1| = 2 + 2 = 4

To Mad Max (9, 3):
d = |8-9| + |3-3| = 1 + 0 = 1 ✓

To The Notebook (1, 10):
d = |8-1| + |3-10| = 7 + 7 = 14

To Titanic (2, 9):
d = |8-2| + |3-9| = 6 + 6 = 12

To Love Actually (2, 10):
d = |8-2| + |3-10| = 6 + 7 = 13

To Avengers (8, 4):
d = |8-8| + |3-4| = 0 + 1 = 1 ✓

To Spider-Man (7, 5):
d = |8-7| + |3-5| = 1 + 2 = 3
```

**3 Nearest (K=3):**

1. Mad Max (Action) - 1
2. Avengers (Action) - 1
3. Die Hard (Action) - 2

**Same prediction: ACTION ✓**

---

### **Visual Representation:**

```
Romance
   10 | Notebook  LoveActually
    9 |   Titanic
    8 |
    7 |
    6 |
    5 |                 Spider-Man
    4 |                 Avengers
    3 | MadMax         [?]
    2 | DieHard
    1 | Terminator
    0 |_____________________________
       0  1  2  3  4  5  6  7  8  9  10  Action

The test point [?] at (8, 3) is clearly in the Action cluster!
```

---

## EXAMPLE 3: STUDENT PASS/FAIL (WITH WEIGHTED KNN)

Predict if student will pass based on **Study Hours** and **Sleep Hours**.

### **Training Dataset:**

|Student|Study Hours|Sleep Hours|Result|
|---|---|---|---|
|S1|2|5|Fail|
|S2|3|6|Fail|
|S3|5|7|Pass|
|S4|6|8|Pass|
|S5|7|7|Pass|
|S6|1|4|Fail|
|S7|8|8|Pass|

---

### **Test Student:** Study Hours = 5, Sleep Hours = 6

---

### **K=3 WITHOUT Weights (Uniform)**

**Calculate distances:**

```
To S1 (2, 5): d = √[(5-2)² + (6-5)²] = √[9+1] = √10 = 3.16
To S2 (3, 6): d = √[(5-3)² + (6-6)²] = √[4+0] = √4 = 2.0 ✓
To S3 (5, 7): d = √[(5-5)² + (6-7)²] = √[0+1] = √1 = 1.0 ✓
To S4 (6, 8): d = √[(5-6)² + (6-8)²] = √[1+4] = √5 = 2.24 ✓
To S5 (7, 7): d = √[(5-7)² + (6-7)²] = √[4+1] = √5 = 2.24
To S6 (1, 4): d = √[(5-1)² + (6-4)²] = √[16+4] = √20 = 4.47
To S7 (8, 8): d = √[(5-8)² + (6-8)²] = √[9+4] = √13 = 3.61
```

**3 Nearest neighbors:**

1. S3 (Pass) - distance 1.0
2. S2 (Fail) - distance 2.0
3. S4 (Pass) - distance 2.24

**Uniform voting (each neighbor = 1 vote):**

```
Pass: 2 votes (S3, S4)
Fail: 1 vote  (S2)

Prediction: PASS
```

---

### **K=3 WITH Distance Weights**

**Weight = 1 / distance** (closer neighbors have more influence)

```
Neighbor 1: S3 (Pass) - distance 1.0
  Weight = 1/1.0 = 1.000

Neighbor 2: S2 (Fail) - distance 2.0
  Weight = 1/2.0 = 0.500

Neighbor 3: S4 (Pass) - distance 2.24
  Weight = 1/2.24 = 0.446
```

**Weighted voting:**

```
Pass: 1.000 + 0.446 = 1.446
Fail: 0.500

Prediction: PASS (1.446 > 0.500)
```

**Effect:** S3 has MORE influence because it's CLOSER. This often gives better predictions!

---

### **Comparison:**

```
Uniform weights:  Pass=2, Fail=1  → Pass wins
Distance weights: Pass=1.446, Fail=0.500 → Pass wins (but more confident!)

Visual:
      S3 (Pass) ← VERY CLOSE (distance 1.0)
        ↓
      [Test point]
        ↓
      S2 (Fail) ← Moderately close (distance 2.0)
      S4 (Pass) ← Moderately close (distance 2.24)

S3 being so close makes us more confident in "Pass" prediction.
```

---

## EXAMPLE 4: LOAN APPROVAL (SHOWING IMPACT OF K)

Predict loan approval based on **Income (thousands)** and **Credit Score**.

### **Training Dataset:**

|Person|Income|Credit Score|Approved|
|---|---|---|---|
|P1|30|600|No|
|P2|40|650|No|
|P3|50|700|Yes|
|P4|60|750|Yes|
|P5|70|800|Yes|
|P6|35|620|No|
|P7|75|780|Yes|
|P8|45|680|No|
|P9|65|760|Yes|

---

### **Test Applicant:** Income = 55, Credit Score = 720

**Note:** Features on different scales! Income: 30-75, Credit: 600-800

---

### **WITHOUT Feature Scaling (WRONG!)**

**Calculate distances:**

```
To P1 (30, 600):
d = √[(55-30)² + (720-600)²]
  = √[625 + 14400]
  = √15025 = 122.6

To P3 (50, 700):
d = √[(55-50)² + (720-700)²]
  = √[25 + 400]
  = √425 = 20.6 ✓

To P4 (60, 750):
d = √[(55-60)² + (720-750)²]
  = √[25 + 900]
  = √925 = 30.4 ✓
```

**Problem:** Credit score dominates! (ranges 600-800, much larger than income 30-75)

Differences in credit score create much larger distances than income differences.

---

### **WITH StandardScaler (CORRECT!)**

**First, scale the features:**

```
Income scaled:
μ = 52.78, σ = 15.8
P1: (30-52.78)/15.8 = -1.44
P3: (50-52.78)/15.8 = -0.18
Test: (55-52.78)/15.8 = 0.14

Credit Score scaled:
μ = 704.4, σ = 69.2
P1: (600-704.4)/69.2 = -1.51
P3: (700-704.4)/69.2 = -0.06
Test: (720-704.4)/69.2 = 0.23
```

**Now calculate distances on scaled data:**

```
To P1_scaled (-1.44, -1.51):
d = √[(0.14-(-1.44))² + (0.23-(-1.51))²]
  = √[1.58² + 1.74²]
  = √[2.50 + 3.03]
  = √5.53 = 2.35

To P3_scaled (-0.18, -0.06):
d = √[(0.14-(-0.18))² + (0.23-(-0.06))²]
  = √[0.32² + 0.29²]
  = √[0.10 + 0.08]
  = √0.18 = 0.42 ✓ MUCH CLOSER!

To P4_scaled (0.46, 0.66):
d = √[(0.14-0.46)² + (0.23-0.66)²]
  = √[0.32² + 0.43²]
  = √[0.10 + 0.18]
  = √0.28 = 0.53 ✓
```

**Both features now contribute fairly!**

---

### **Impact of Different K Values**

**K=1 (Only 1 nearest neighbor):**

```
Nearest: P3 (Yes) at distance 0.42
Prediction: YES (Approved)
```

- Very sensitive to noise
- Can overfit

**K=3:**

```
3 Nearest:
1. P3 (Yes) - 0.42
2. P4 (Yes) - 0.53  
3. P9 (Yes) - 0.71

Vote: 3 Yes, 0 No
Prediction: YES (Approved)
```

- More stable
- Good balance

**K=7:**

```
7 Nearest:
1. P3 (Yes)
2. P4 (Yes)
3. P9 (Yes)
4. P5 (Yes)
5. P8 (No)
6. P2 (No)
7. P7 (Yes)

Vote: 5 Yes, 2 No
Prediction: YES (Approved)
```

- More robust
- Smoother decision boundary

**K=9 (all training points):**

```
All 9 neighbors vote
Total: 5 Yes, 4 No
Prediction: YES (Approved)
```

- Too smooth
- Loses local patterns

---

## EXAMPLE 5: TEMPERATURE CLASSIFICATION (1D - SIMPLEST POSSIBLE)

Classify weather as **Cold**, **Mild**, or **Hot** based only on **Temperature**.

### **Training Data:**

|Day|Temperature (°C)|Weather|
|---|---|---|
|1|5|Cold|
|2|8|Cold|
|3|10|Cold|
|4|15|Mild|
|5|18|Mild|
|6|20|Mild|
|7|25|Hot|
|8|28|Hot|
|9|30|Hot|

---

### **Visualize on Number Line:**

```
Cold      Mild        Hot
 |         |          |
 5  8  10  15  18  20  25  28  30
 •  •  •   •   •   •   •   •   •
```

---

### **Test: Temperature = 17°C**

**Calculate distances (just absolute differences in 1D):**

```
|17 - 5|  = 12  (Cold)
|17 - 8|  = 9   (Cold)
|17 - 10| = 7   (Cold)
|17 - 15| = 2   (Mild) ✓
|17 - 18| = 1   (Mild) ✓
|17 - 20| = 3   (Mild) ✓
|17 - 25| = 8   (Hot)
|17 - 28| = 11  (Hot)
|17 - 30| = 13  (Hot)
```

**K=3 Nearest:**

1. 18°C (Mild) - distance 1
2. 15°C (Mild) - distance 2
3. 20°C (Mild) - distance 3

**Vote: 3 Mild, 0 Cold, 0 Hot** **Prediction: MILD ✓**

**Visual:**

```
    15   17  18  20
    •    ?   •   •
    Mild     Mild Mild

17°C falls right in the middle of Mild temperatures!
```

---

### **Test: Temperature = 12°C (Boundary Case)**

**Calculate distances:**

```
|12 - 5|  = 7   (Cold)
|12 - 8|  = 4   (Cold)
|12 - 10| = 2   (Cold) ✓
|12 - 15| = 3   (Mild) ✓
|12 - 18| = 6   (Mild)
|12 - 20| = 8   (Mild)
|12 - 25| = 13  (Hot)
|12 - 28| = 16  (Hot)
|12 - 30| = 18  (Hot)
```

**K=3 Nearest:**

1. 10°C (Cold) - distance 2
2. 15°C (Mild) - distance 3
3. 8°C (Cold) - distance 4

**Vote: 2 Cold, 1 Mild** **Prediction: COLD**

**Visual:**

```
  8    10  12  15
  •    •   ?   •
  Cold Cold    Mild

12°C is on the boundary - closer to Cold cluster!
```

---

## KEY INSIGHTS FROM EXAMPLES

### **1. Distance is Everything**

```
KNN asks: "Who are my neighbors?"
Not: "What's the probability?" (like Naive Bayes)
Not: "What's the equation?" (like Linear Regression)

Just: "Find closest points and copy their labels"
```

---

### **2. Why Scaling Matters**

**Loan Example showed:**

```
Without scaling:
Income difference: 55-50 = 5
Credit difference: 720-700 = 20

Credit dominates! (20 >> 5)

With scaling:
Income difference: 0.32
Credit difference: 0.29

Fair contribution!
```

---

### **3. Impact of K**

```
K=1: Very sensitive, can overfit
     Student with distance 1.0 decides everything
     
K=3: Balanced
     Considers small neighborhood
     
K=5: More robust
     Less sensitive to noise
     
K=all: Too smooth
       Just predicts majority class
```

**Rule of thumb:** Start with K = √n (square root of training samples)

---

### **4. Weighted vs Uniform**

**Student Example:**

```
Uniform: All 3 neighbors vote equally
Weighted: Closer neighbor (S3, distance 1.0) has MORE influence

Weighted often better because:
- Closer points more relevant
- Distance contains information
```

---

### **5. Why KNN is "Lazy"**

```
Training: Just store data (instant!)
         No equations learned
         No model built

Prediction: Calculate all distances (slow!)
           Must compare to every training point
```

Compare to Naive Bayes:

```
Training: Calculate all probabilities (fast!)
Prediction: Just multiply probabilities (instant!)
```

---

### **6. Decision Boundaries**

**In Fruit Example:**

```
Apple cluster:   Around (150, 7)
Orange cluster:  Around (180, 9)
Lemon cluster:   Around (60, 2)

Test point (165, 8) is between Apple and Orange
KNN checks which cluster is closer
```

**Mental Model:**

- Training points are "anchors"
- Test point "pulls" toward nearest anchors
- Majority of nearby anchors wins

---

### **7. Distance Metrics Matter**

**Movie Example showed:**

```
Euclidean: √[(x₁-x₂)² + (y₁-y₂)²]
- "As the crow flies"
- Diagonal distance

Manhattan: |x₁-x₂| + |y₁-y₂|
- "City block" distance
- Along axes only

Both gave same result, but can differ!
```

**When to use:**

- Euclidean: Most common, default choice
- Manhattan: High dimensions, less sensitive to outliers
- Others: Specific domain needs

---

## STEP-BY-STEP PREDICTION RECIPE

**Every KNN prediction follows these steps:**

```
1. SCALE features (if not done already)
   → StandardScaler or MinMaxScaler

2. CALCULATE distance to every training point
   → Usually Euclidean: √(Σ(xᵢ-yᵢ)²)

3. SORT distances (smallest to largest)
   → Find K nearest neighbors

4. COLLECT labels of K neighbors
   → Get their classes/values

5. VOTE (classification) or AVERAGE (regression)
   → Uniform or distance-weighted

6. RETURN prediction
   → Most common class or average value
```

---

## COMMON MISTAKES ILLUSTRATED

### **Mistake 1: Forgetting to Scale**

```
Features: [Age: 25, Salary: 50000]
Distance dominated by Salary!

Wrong distance:
√[(25-30)² + (50000-60000)²] = √[25 + 100000000] ≈ 10000

The age difference (5 years) is completely ignored!

Fix: Scale first!
```

---

### **Mistake 2: Using Even K for Binary Classification**

```
K=4 with binary classes:
Neighbors: [Yes, Yes, No, No]
Vote: 2-2 TIE!

What to predict?
- Random choice (bad!)
- Use K=3 or K=5 instead (odd number)
```

---

### **Mistake 3: K Too Small**

```
K=1 with noisy data:

    • (Incorrect label due to noise)
      [Test point]

Predicts incorrect label because one noisy point is closest!

Fix: Use K=3 or K=5 to smooth out noise
```

---

### **Mistake 4: K Too Large**

```
K=100 in dataset with 110 points:
- Uses almost all training data
- Just predicts most common class
- Loses all local patterns

Fix: K should be much smaller than dataset size
```

---

## PRACTICAL RULES

1. **Always scale features first**
    
    ```python
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    ```
    
2. **Choose odd K for binary classification**
    
    - Avoids ties
    - K=3, 5, 7 common choices
3. **Try different K values**
    
    - Start with K = √n
    - Use cross-validation to find best K
    - Plot error vs K (elbow curve)
4. **Use distance weights**
    
    ```python
    weights='distance'  # Better than 'uniform'
    ```
    
5. **Check your distance metric**
    
    - Euclidean: default, works well
    - Manhattan: try for high dimensions
    - Custom: for special cases

---

## VISUAL SUMMARY

```
KNN in one picture:

Training points:
    ○ ○ ○         □ □ □
    ○ ○             □ □
    ○                 □

New point: ?

Step 1: Find K=3 nearest
    ○ ○             
    ○ ? 

Step 2: Count votes
    Circles: 3
    Squares: 0

Step 3: Predict
    ? is a Circle!

That's KNN!
```

These examples show KNN's core intuition: **"You are the average of your K nearest neighbors"** - it's really that simple!