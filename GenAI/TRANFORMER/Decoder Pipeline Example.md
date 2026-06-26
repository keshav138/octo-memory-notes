Let's walk through it as if you asked:

> "How many runs did Kohli score in the latest India vs Australia match?"

I'll separate the **system level** and the **transformer level**.

---

# 1. User sends query

Input:

```text
How many runs did Kohli score in the latest India vs Australia match?
```

At this point the model itself doesn't yet know whether it needs the web.

---

# 2. Orchestration layer decides

A layer outside the transformer examines the query.

It notices:

```text
latest
India vs Australia match
```

which suggests recent information.

So it decides:

```text
Perform web search
```

---

# 3. Retriever gets documents

Suppose it finds:

```text
Article 1:
India defeated Australia by 6 wickets.

Article 2:
Virat Kohli scored 98 runs off 105 balls.

Article 3:
India chased 276 with 8 balls remaining.
```

---

# 4. Prompt assembly

The system now constructs a giant prompt.

Conceptually:

```text
System:
Answer accurately using the provided sources.

Retrieved Article 1:
India defeated Australia by 6 wickets.

Retrieved Article 2:
Virat Kohli scored 98 runs off 105 balls.

Retrieved Article 3:
India chased 276 with 8 balls remaining.

User:
How many runs did Kohli score?
```

---

# 5. Tokenization

Everything gets converted to tokens.

Maybe:

```text
India
defeated
Australia
...
Virat
Kohli
scored
98
runs
...
How
many
runs
did
Kohli
score
?
```

becomes:

```text
[3521, 818, 9421, ...]
```

Thousands of token IDs.

---

# 6. Embedding lookup

Each token becomes a vector.

For example:

```text
"Kohli" -> 8192 numbers
"98"    -> 8192 numbers
"runs"  -> 8192 numbers
```

Now the model has a huge matrix:

```text
num_tokens × embedding_dimension
```

---

# 7. First transformer layer

Every token creates:

```text
Q
K
V
```

vectors.

For example:

```text
Q_Kohli
K_Kohli
V_Kohli

Q_98
K_98
V_98
```

---

# 8. Attention begins

Now imagine we're generating the answer.

The current hidden state is essentially asking:

```text
What should come next?
```

The query vectors generated from:

```text
How many runs did Kohli score?
```

start comparing themselves against all keys.

---

The attention scores may look roughly like:

```text
Kohli  -> 0.45
scored -> 0.30
98     -> 0.20
runs   -> 0.04
other tokens -> tiny
```

Not actual numbers, just intuition.

---

# 9. Value retrieval

Those attention weights are multiplied by values.

Conceptually:

```text
0.45 × V_Kohli
+
0.30 × V_scored
+
0.20 × V_98
+
0.04 × V_runs
```

This creates a new hidden representation.

Notice:

- We did not retrieve a database row.
    
- We did not "jump" directly to token 98.
    

Instead the model blended information from many tokens.

---

# 10. Dozens of layers repeat

This process happens:

```text
Attention
↓
Feed Forward Network
↓
Attention
↓
Feed Forward Network
↓
...
```

40–100+ layers depending on model size.

Each layer refines the hidden states.

Eventually the model develops an internal representation that's roughly:

```text
User asks for Kohli's score.
Retrieved documents say 98 runs.
Answer should mention 98.
```

Not as text, but as vectors.

---

# 11. Final hidden state

For the next token to generate, suppose the final vector is:

```text
H_final
```

The model compares it against every vocabulary token.

```text
H_final · E_0
H_final · E_1
...
H_final · E_100000
```

Maybe:

```text
"98"      -> 14.7
"100"     -> 3.1
"Kohli"   -> 2.8
"runs"    -> 1.5
```

---

# 12. Softmax

Convert to probabilities:

```text
98      -> 99.2%
100     -> 0.5%
others  -> 0.3%
```

---

# 13. Emit token

Model outputs:

```text
98
```

---

# 14. Repeat

Now context becomes:

```text
How many runs did Kohli score?

98
```

The model predicts the next token.

Maybe:

```text
runs
```

Then:

```text
.
```

Then maybe another explanatory sentence.

---

# The most important insight

Many people imagine:

```text
Question
↓
Search
↓
Find sentence
↓
Copy answer
```

But transformers don't really work like that.

It's closer to:

```text
Question
↓
Search
↓
Put retrieved text into context
↓
Run attention over ALL tokens
↓
Build internal representations
↓
Generate answer token by token
```

The retrieved article becomes part of the model's temporary working memory, and the exact same attention machinery that understands normal language is what connects:

```text
"Kohli"
     ↔
"scored"
     ↔
"98"
     ↔
"runs"
```

to produce the answer.