This is exactly the point where many people get stuck. The missing piece is **what the decoder is actually learning**. Let's use a more realistic example and focus on the data flowing through the model.

Suppose our training dataset contains thousands of sentence pairs like:

|English|French|
|---|---|
|He is a boy|Il est un garçon|
|She is happy|Elle est heureuse|
|I like apples|J'aime les pommes|

The model has **no built-in knowledge of French**. It starts with random weights.

---

# Training: What goes into the encoder?

The English sentence is tokenized.

```text
He     is     a     boy
 │      │      │      │
 ▼      ▼      ▼      ▼
E₁     E₂     E₃     E₄
```

These embeddings go through several encoder layers.

After many layers:

```text
E₁ → Z₁
E₂ → Z₂
E₃ → Z₃
E₄ → Z₄
```

These **Z vectors** are contextual representations. They are just vectors—not English words anymore.

The encoder outputs

```text
[Z₁ Z₂ Z₃ Z₄]
```

Think of this as the encoder saying:

> "Here's everything I understood about this sentence."

---

# What goes into the decoder?

This is the crucial part.

The decoder receives the **French sentence shifted right by one token**.

Instead of

```text
Il est un garçon
```

it receives

```text
<START> Il est un
```

So the decoder input is

```text
<START>   Il    est    un
```

These become embeddings

```text
D₁
D₂
D₃
D₄
```

Notice:

The decoder **does not receive "garçon".**

That is what it must predict.

---

# What does the decoder produce?

After self-attention, cross-attention, and FFNs, the decoder outputs

```text
Y₁
Y₂
Y₃
Y₄
```

Each **Y** goes through a final linear layer and softmax.

The predictions are

```text
Position 1 → Il
Position 2 → est
Position 3 → un
Position 4 → garçon
```

Compare this with the targets:

|Decoder Input|Target|
|---|---|
|`<START>`|Il|
|Il|est|
|est|un|
|un|garçon|

So the decoder is really learning:

> "Given everything the encoder understood, plus the French words so far, what is the next French word?"

---

# But how does it know French?

Initially it **doesn't**.

Suppose on day one:

Encoder input:

```text
He is a boy
```

Decoder input:

```text
<START>
```

Output probabilities:

```text
pizza
0.12

bonjour
0.09

garçon
0.01

Il
0.003
```

It predicts

```text
pizza
```

which is nonsense.

The loss is huge.

Backpropagation adjusts all the weights.

---

Next training example.

Still wrong.

Adjust again.

---

After millions of examples:

The decoder notices patterns.

Whenever the encoder produces vectors representing

```text
He
```

and the decoder currently has

```text
<START>
```

the correct next word is almost always

```text
Il
```

The weights slowly change until that becomes the highest-probability output.

No dictionary is ever provided. The mapping is learned because the model is repeatedly rewarded for producing the correct French continuation.

---

# What is cross-attention actually doing?

Suppose the decoder is trying to predict

```text
garçon
```

The encoder memory is

```text
He     is     a     boy

↓

Z₁     Z₂     Z₃     Z₄
```

The decoder currently has

```text
Il est un
```

Internally, the decoder asks:

> "Which encoder vectors are relevant for predicting the next word?"

Maybe the attention looks like

```text
Decoder token: "un"

looks at

He   → 5%
is   → 2%
a    →10%
boy  →83%
```

Most of the information comes from the encoder's representation of "boy".

So the decoder output becomes heavily influenced by Z₄.

Eventually it predicts

```text
garçon
```

---

# During inference

Now there are **no French labels available**.

Encoder:

```text
He is a boy

↓

Z₁ Z₂ Z₃ Z₄
```

Decoder starts with only

```text
<START>
```

It predicts

```text
Il
```

Now the decoder input becomes

```text
<START> Il
```

It predicts

```text
est
```

Then

```text
<START> Il est
```

predicts

```text
un
```

Then

```text
<START> Il est un
```

predicts

```text
garçon
```

The encoder output **never changes** during this process. The decoder simply keeps consulting those encoder vectors while generating one token at a time.

---

# The key insight

The model is **not translating one English word into one French word**.

Instead:

```text
English sentence
        │
        ▼
Encoder
        │
        ▼
A set of contextual vectors representing
the meaning of the entire sentence
        │
        ▼
Decoder
        │
        ▼
Learns to generate a French sentence
whose tokens best match the training examples.
```

So the encoder's job is to build a rich representation of the **meaning** of the source sentence, and the decoder's job is to learn the conditional probability

$$
P(\text{next French token} \mid \text{previous French tokens}, \text{encoder output})  
$$

The "knowledge of French" isn't stored anywhere separately. It's encoded in the learned weights of the decoder (and the shared embedding/output layers), which have been optimized over millions of English–French sentence pairs to assign high probability to correct French continuations.