# DOUBT 1

```
I understand getting probabilities out of the softmax function, but why do we need to multiply it with v, doesnt the prob in itself tell you what value to access
```

That's a very good question, because it gets at **what attention is actually trying to produce**.

You're thinking:

> If softmax tells me that "animal" got 99.7% probability, why not just pick "animal"? Why multiply by V?

The answer is:

**The attention mechanism isn't trying to select a token. It's trying to produce a new vector representation.**

---

### What softmax gives you

After computing:

$
\text{softmax}(QK^T)  
$

you might get:

```text
animal : 0.997
street : 0.001
cross  : 0.002
```

These numbers only tell you:

> "How much attention should I pay to each token?"

They do **not** contain any semantic information themselves.

---

### Analogy: Search Engine

Imagine you search:

```text
"Python machine learning"
```

The search engine returns:

```text
Result A : 90%
Result B : 7%
Result C : 3%
```

Do these percentages contain the article contents?

No.

They only tell you which documents are relevant.

You still need to fetch the documents themselves.

That's what the Values are.

---

### Keys are for matching

Think of Keys as labels:

```text
Animal article
Street article
Crossing article
```

Queries compare against these labels.

Keys help answer:

> "Which information should I look at?"

---

### Values are the actual information

Values contain the information that will be transferred.

```text
V_animal
V_street
V_cross
```

are vectors containing learned features.

The model computes:

```text
0.997 × V_animal
+ 0.001 × V_street
+ 0.002 × V_cross
```

which creates a brand-new vector.

---

### Why not just choose the highest probability?

You could imagine:

```text
argmax(attention)
```

meaning:

```text
Pick animal only
```

But that would be very limiting.

Suppose attention is:

```text
King   : 0.45
Queen  : 0.40
Prince : 0.15
```

The model may genuinely need information from all three.

A weighted average lets it combine concepts.

---

### Another perspective

Suppose each Value is 3-dimensional.

```text
V_animal = [10, 5, 2]
V_street = [1, 8, 7]
V_cross  = [4, 3, 9]
```

Attention weights:

```text
[0.8, 0.1, 0.1]
```

Output:

```text
0.8*[10,5,2]
+0.1*[1,8,7]
+0.1*[4,3,9]
```

Result:

```text
[8.5, 5.1, 2.6]
```

The output is a **new vector**, not a token ID.

That vector becomes the updated representation of the current token.

---

### The deeper reason Q, K and V are separate
#important
Notice that:

```text
Q and K
```

are only used to calculate relevance.

After softmax, they're gone.

The information that actually survives and gets passed to the next layer comes from:

```text
V
```

That's why they're called Values.

Think:

```text
Q = What am I looking for?
K = What can I offer?
V = What do I actually contain?
```

The softmax tells you **where to look**.

The Values provide **what gets retrieved**.

Without multiplying by V, you'd only know which tokens were important—you wouldn't actually obtain any information from them. The output would just be a list of probabilities instead of a meaningful vector that the next transformer layer can use.

---

# DOUBT 2

```
If the output vector is different, does it represent some other word not in the original sentence
```

This is actually one of the most important insights about transformers.

The answer is:

**Usually no. The output vector does not necessarily correspond to any word at all.**

---

Let's start with a token:

```text
cat
```

Its initial embedding might be:

```text
E_cat
```

which came from the embedding table.

That embedding is associated with the token "cat".

---

After one attention layer, the model computes:

```text
0.7 * V_cat
+
0.2 * V_dog
+
0.1 * V_pet
```

and gets:

```text
H1
```

Now, does `H1` correspond to a token in the vocabulary?

Not necessarily.

It's just a point somewhere in the vector space.

Think of mixing colors:

```text
Red + Blue = Purple
```

Purple wasn't one of the original colors.

Similarly:

```text
cat-information
+
pet-information
+
animal-information
```

can produce a new vector that isn't the embedding of any specific token.

---

### What the vector represents

Instead of representing a word, it represents a **conceptual state**.

For example:

```text
The animal didn't cross the street because it was tired.
```

After attention, the vector for "it" might roughly encode:

```text
"It refers to animal"
+
"animal is tired"
+
"animal is the subject"
```

That's much richer than a single word.

---

### Why this is powerful

If every layer had to map back to a word, the model would be extremely limited.

Instead, it operates in a continuous space.

You can think of a hidden vector as representing things like:

```text
80% cat
15% pet
5% predator
```

or

```text
past tense
+
plural
+
subject of sentence
+
currently being discussed
```

These aren't words.

They're features and relationships.

---

### Then how does the model eventually produce words?

Only at the very end.

After dozens of layers, you have a final hidden vector:

```text
H_final
```

This vector is compared against the vocabulary embeddings.

Conceptually:

```text
H_final · E_the
H_final · E_cat
H_final · E_dog
H_final · E_sat
...
```

The model computes a score for every token in the vocabulary.

Maybe:

```text
cat  -> 2.1
dog  -> 8.9
car  -> 0.3
```

After softmax:

```text
dog -> 97%
cat -> 2%
car -> 1%
```

and it outputs:

```text
dog
```

---

### A useful mental model

There are two different kinds of vectors:

#### 1. Token embeddings

These correspond to vocabulary entries.

```text
cat
dog
car
house
```

Each has a stored embedding.

---

#### 2. Hidden states

These are what attention layers produce.

```text
H1
H2
H3
...
```

These usually do **not** correspond to any word.

They are intermediate representations carrying meaning, context, grammar, relationships, and reasoning information.

The transformer spends almost all of its time manipulating **hidden states**, not words.

Only at the very beginning does it convert words → vectors, and only at the very end does it convert vectors → next-word probabilities.

---
# Doubt 3

```
What does the final H_vector cross refer from to get the new word, basically what vocabulary does it refer to?
```

The **model's entire vocabulary**, not the words in the sentence.

This is a crucial distinction.

---

Suppose your input is:

```text
The cat sat on the mat
```

The words in the input are:

```text
The
cat
sat
on
mat
```

But when the model is predicting the next token, it is not choosing only from those 5 words.

It's choosing from **every token in its vocabulary**.

If the vocabulary contains 100,000 tokens, then the model computes something conceptually like:

```text
score("the")      = 1.2
score("cat")      = 4.7
score("dog")      = 8.9
score("house")    = 2.1
score("banana")   = 0.4
score("running")  = 5.2
...
```

for all 100,000 tokens.

---

### Why can it predict words not in the input?

Because the goal is usually:

> "Given the previous tokens, what token should come next?"

Example:

```text
The cat chased the
```

The word "mouse" isn't in the sentence yet.

But the model can still predict:

```text
mouse -> high score
dog   -> medium score
car   -> low score
```

because it's choosing from its entire vocabulary.

---

### What exactly is being compared?

At the end of the transformer you have:

```text
H_final
```

which might be an 8192-dimensional vector.

The model compares it with every vocabulary embedding:

```text
E_the
E_cat
E_dog
E_mouse
...
```

These embeddings belong to the tokenizer's vocabulary—the fixed dictionary the model was trained with.

If there are:

```text
100,000 vocabulary tokens
```

then there are:

```text
100,000 embedding vectors
```

to compare against.

---

### A useful mental model

Imagine the vocabulary is a giant warehouse of token embeddings:

```text
Token          Embedding
--------------------------------
the            E_the
cat            E_cat
dog            E_dog
mouse          E_mouse
running        E_running
...
100,000 entries
```

The transformer produces:

```text
H_final
```

and asks:

> Which vocabulary embedding is most similar to this vector?

The similarities become the logits:

```text
H_final · E_the
H_final · E_cat
H_final · E_dog
...
```

Then softmax turns those into probabilities.

---

### An interesting detail

In many transformer architectures, the output layer actually **reuses** the same embedding matrix that was used at the input.

So:

1. Input token `"dog"` → look up embedding `E_dog`
    
2. Transformer processes everything
    
3. Final hidden state `H_final`
    
4. Compare `H_final` against all embeddings again
    

This is called **weight tying** and saves parameters while often improving performance.

So in that explanation, **vocabulary means the model's fixed token vocabulary (e.g., 50k–200k tokens), not the words that appeared in the current sentence.**