Here's a **massive syntax-focused set** covering **PyTorch, TensorFlow/Keras, Scikit-learn, Hugging Face, JAX, and XGBoost** — with **micro-explanations** after each answer. Mixed formats (single, multi, fill-in, true/false, code output).

---

## **PYTORCH SYNTAX**

**Q1 (Code output):** What does this print?
```python
import torch
x = torch.tensor([1.0, 2.0, 3.0], requires_grad=True)
y = (x ** 2).sum()
y.backward()
print(x.grad)
```
**A:** `tensor([2., 4., 6.])`  
*Micro-explanation:* `dy/dx_i = 2*x_i`, so gradients are `[2, 4, 6]`. Backward accumulates into `.grad`.

---

**Q2 (Fill-in):** To move a PyTorch model to GPU, you call `model._______('cuda')`  
**A:** `.to()`  
*Micro-explanation:* `.to(device)` is the universal method. `.cuda()` also works but is less flexible.

---

**Q3 (Multi):** Which are **valid ways** to disable gradient tracking in PyTorch?  
A) `with torch.no_grad():`  
B) `torch.set_grad_enabled(False)`  
C) `x.detach()`  
D) `x.requires_grad = False`  
E) `torch.stop_gradients()`  
**A:** A, B, C, D  
*Micro-explanation:* E doesn't exist. `detach()` creates a new tensor without gradient history.

---

**Q4 (True/False):** `torch.nn.CrossEntropyLoss` applies softmax internally.  
**A:** True  
*Micro-explanation:* It combines `LogSoftmax` + `NLLLoss` — never pass softmax outputs directly.

---

**Q5 (Single):** Which creates a **trainable parameter**?  
A) `torch.tensor([1.0, 2.0])`  
B) `torch.nn.Parameter(torch.randn(2, 3))`  
C) `torch.zeros(3, requires_grad=False)`  
D) `torch.ones(5).detach()`  
**A:** B  
*Micro-explanation:* `Parameter` is a tensor auto-added to `model.parameters()`. Others don't track gradients by default.

---

**Q6 (Code output):** What prints?
```python
x = torch.randn(4, 10)
linear = torch.nn.Linear(10, 5)
out = linear(x)
print(out.shape)
```
**A:** `torch.Size([4, 5])`  
*Micro-explanation:* Linear layer transforms last dimension from 10 → 5. Batch size (4) unchanged.

---

**Q7 (Fill-in):** To zero out gradients before `backward()`, call `optimizer._______()`  
**A:** `.zero_grad()`  
*Micro-explanation:* Gradients accumulate by default; zeroing prevents double-counting across batches.

---

**Q8 (Multi):** Which dataloader settings **affect memory usage and iteration order**?  
A) `batch_size`  
B) `shuffle`  
C) `num_workers`  
D) `pin_memory`  
E) `drop_last`  
**A:** All of them  
*Micro-explanation:* `pin_memory` speeds up CPU→GPU transfer. `num_workers` parallelizes loading.

---

**Q9 (Single):** `torch.cat((a, b), dim=0)` requires that:  
A) All dimensions except dim=0 match  
B) All dimensions must match exactly  
C) Only the last dimension matches  
D) Tensors must be 2D only  
**A:** A  
*Micro-explanation:* Concatenation dimension can differ; all others must be identical.

---

**Q10 (True/False):** `model.eval()` disables dropout and batch norm statistics update.  
**A:** True  
*Micro-explanation:* Switch to inference mode. Use with `torch.no_grad()` for evaluation.

---

## **TENSORFLOW / KERAS SYNTAX**

**Q11 (Code output):** What shape?
```python
import tensorflow as tf
x = tf.ones((32, 224, 224, 3))
y = tf.keras.layers.GlobalAveragePooling2D()(x)
print(y.shape)
```
**A:** `(32, 3)`  
*Micro-explanation:* GlobalAvgPool2D reduces each spatial dimension (224×224) to 1 per channel.

---

**Q12 (Fill-in):** In Keras, `model.compile(optimizer='adam', loss=_______ , metrics=['accuracy'])` for binary classification.  
**A:** `'binary_crossentropy'`  
*Micro-explanation:* Binary output uses sigmoid + binary crossentropy. Multi-class uses `categorical_crossentropy`.

---

**Q13 (Multi):** Which are **valid ways to save/load a Keras model**?  
A) `model.save('model.h5')`  
B) `tf.keras.models.load_model('model.h5')`  
C) `model.save_weights('weights.h5')`  
D) `pickle.dump(model)`  
E) `model.to_json()` + `model.from_json()`  
**A:** A, B, C, E  
*Micro-explanation:* Pickling is unsafe and not recommended for Keras models.

---

**Q14 (Single):** To freeze a layer during training in TensorFlow:  
A) `layer.trainable = False`  
B) `layer.enabled = False`  
C) `tf.stop_gradient(layer)`  
D) `layer.requires_grad = False`  
**A:** A  
*Micro-explanation:* Set `trainable=False` before compiling, or recompile after changing.

---

**Q15 (True/False):** `tf.function` decorator compiles Python functions into TensorFlow graphs for speed.  
**A:** True  
*Micro-explanation:* Uses AutoGraph to convert Python control flow into TF ops. Debugging can be trickier.

---

**Q16 (Code output):**
```python
a = tf.constant([[1, 2], [3, 4]])
b = tf.constant([[5, 6], [7, 8]])
c = tf.matmul(a, b)
print(c[0, 0].numpy())
```
**A:** `19` (1*5 + 2*7 = 19)  
*Micro-explanation:* Matrix multiplication. Index `[0,0]` is first row × first column.

---

**Q17 (Fill-in):** Keras `Model.fit()` returns a `_______` object containing loss and metrics history.  
**A:** `History`  
*Micro-explanation:* Access via `history.history` dict with keys like 'loss', 'accuracy'.

---

**Q18 (Multi):** Which callbacks are **built into Keras**?  
A) `EarlyStopping`  
B) `ModelCheckpoint`  
C) `ReduceLROnPlateau`  
D) `TensorBoard`  
E) `GradientClipping`  
**A:** A, B, C, D  
*Micro-explanation:* Gradient clipping is an optimizer argument, not a callback.

---

**Q19 (Single):** `tf.data.Dataset.batch(32).prefetch(tf.data.AUTOTUNE)` does what?  
A) Loads 32 samples, then prefetches next batch  
B) Shuffles then batches  
C) Repeats dataset infinitely  
D) Caches entire dataset in RAM  
**A:** A  
*Micro-explanation:* `prefetch` overlaps data preprocessing and model execution.

---

**Q20 (True/False):** In TF 2.x, `tf.Session()` is required for eager execution.  
**A:** False  
*Micro-explanation:* Eager execution is default in TF 2.x. Sessions are from TF 1.x graph mode.

---

## **SCIKIT-LEARN SYNTAX**

**Q21 (Code output):**
```python
from sklearn.preprocessing import StandardScaler
import numpy as np
X = np.array([[1, 2], [3, 4], [5, 6]])
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)
print(X_scaled[:, 0].mean())
```
**A:** `0.0` (within float precision)  
*Micro-explanation:* StandardScaler centers to mean 0 and scales to unit variance.

---

**Q22 (Fill-in):** To perform train-test split with stratification:  
`from sklearn.model_selection import _______`  
**A:** `train_test_split` (with `stratify=y` parameter)  
*Micro-explanation:* `stratify` preserves class distribution in both splits.

---

**Q23 (Multi):** Which are **valid cross-validation iterators**?  
A) `KFold`  
B) `StratifiedKFold`  
C) `TimeSeriesSplit`  
D) `LeaveOneOut`  
E) `RandomSplit`  
**A:** A, B, C, D  
*Micro-explanation:* `RandomSplit` doesn't exist — use `ShuffleSplit` instead.

---

**Q24 (Single):** `Pipeline([('scaler', StandardScaler()), ('clf', LogisticRegression())])` does what during `fit`?  
A) Scales then fits classifier  
B) Fits classifier then scales  
C) Scales and fits in parallel  
D) Scales only if accuracy improves  
**A:** A  
*Micro-explanation:* Pipelines apply transformers sequentially before final estimator.

---

**Q25 (True/False):** `GridSearchCV` refits the best model on the full training data by default.  
**A:** True  
*Micro-explanation:* `refit=True` (default) — use `cv_results_` and `best_estimator_` after.

---

**Q26 (Code output):**
```python
from sklearn.metrics import accuracy_score
y_true = [0, 1, 1, 0]
y_pred = [0, 0, 1, 1]
print(accuracy_score(y_true, y_pred))
```
**A:** `0.5`  
*Micro-explanation:* 2 correct (indices 0 and 2) out of 4 → 50%.

---

**Q27 (Fill-in):** To one-hot encode categorical features: `from sklearn.preprocessing import _______`  
**A:** `OneHotEncoder`  
*Micro-explanation:* Use `sparse_output=False` for dense array. `pd.get_dummies` is pandas alternative.

---

**Q28 (Multi):** Which scikit-learn functions follow **fit-transform** pattern?  
A) `StandardScaler`  
B) `PCA`  
C) `SimpleImputer`  
D) `LogisticRegression`  
E) `MinMaxScaler`  
**A:** A, B, C, E  
*Micro-explanation:* Estimators have `fit`; transformers have `fit_transform`. `LogisticRegression` is predictor.

---

**Q29 (Single):** `make_pipeline` vs `Pipeline`: difference?  
A) No difference  
B) `make_pipeline` auto-names steps  
C) `make_pipeline` only works for regression  
D) `Pipeline` is deprecated  
**A:** B  
*Micro-explanation:* `make_pipeline` assigns lowercase class names as step names automatically.

---

**Q30 (True/False):** `RandomizedSearchCV` always finds a better hyperparameter set than `GridSearchCV`.  
**A:** False  
*Micro-explanation:* Random search explores more diverse values but no guarantee — often faster and nearly as good.

---

## **HUGGING FACE TRANSFORMERS SYNTAX**

**Q31 (Code output):**
```python
from transformers import AutoTokenizer, AutoModel
tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")
tokens = tokenizer("Hello world", return_tensors="pt")
print(tokens["input_ids"].shape)
```
**A:** `torch.Size([1, 3])` (batch=1, tokens=3: [CLS], hello, world)  
*Micro-explanation:* BERT adds special `[CLS]` at start. Returns PyTorch tensors with `return_tensors="pt"`.

---

**Q32 (Fill-in):** To load a model for sequence classification:  
`model = AutoModelForSequenceClassification.from_pretrained("bert-base-uncased", num_labels=_______)`  
**A:** number of classes (e.g., 2)  
*Micro-explanation:* Automatically adds classification head. `num_labels` defines output dimension.

---

**Q33 (Multi):** Which are **valid tokenizer return types**?  
A) `return_tensors="pt"` (PyTorch)  
B) `return_tensors="tf"` (TensorFlow)  
C) `return_tensors="np"` (NumPy)  
D) `return_tensors="jax"` (JAX)  
E) `return_tensors="list"`  
**A:** A, B, C, D  
*Micro-explanation:* "list" isn't supported — returns Python lists by default.

---

**Q34 (Single):** `tokenizer.decode([101, 2054, 2154])` returns:  
A) List of strings  
B) Single string  
C) Tensor of tokens  
D) Raw bytes  
**A:** B  
*Micro-explanation:* `decode` converts token IDs back to human-readable text. `101` = `[CLS]`.

---

**Q35 (True/False):** `Trainer` class requires manually writing PyTorch training loop.  
**A:** False  
*Micro-explanation:* `Trainer` abstracts loops, gradient steps, logging, evaluation, checkpointing.

---

**Q36 (Code output):**
```python
from transformers import pipeline
classifier = pipeline("sentiment-analysis")
result = classifier("I love this!")
print(result[0]["label"])
```
**A:** `"POSITIVE"` (or similar, depending on default model)  
*Micro-explanation:* Pipeline handles tokenization, model inference, and postprocessing.

---

**Q37 (Fill-in):** To push a fine-tuned model to Hugging Face Hub: `model.push_to_hub("_______")`  
**A:** `"your-username/model-name"`  
*Micro-explanation:* Requires authentication (`huggingface-cli login`). Also push tokenizer.

---

**Q38 (Multi):** Which arguments are **common to `model.generate()`**?  
A) `max_new_tokens`  
B) `temperature`  
C) `top_k`  
D) `do_sample`  
E) `num_beams`  
**A:** All of them  
*Micro-explanation:* Greedy (default) vs sampling vs beam search controlled by these.

---

**Q39 (Single):** `AutoModel` vs `AutoModelForCausalLM` difference?  
A) Same thing  
B) `AutoModel` has no LM head  
C) `AutoModelForCausalLM` only for BERT  
D) `AutoModel` is deprecated  
**A:** B  
*Micro-explanation:* `AutoModel` = base transformer without task-specific head. `ForCausalLM` adds language modeling head.

---

**Q40 (True/False):** `tokenizer.pad_token = tokenizer.eos_token` is common for GPT-style models.  
**A:** True  
*Micro-explanation:* GPT has no pad token by default; reusing eos token as pad is standard practice.

---

## **JAX SYNTAX (bonus)**

**Q41 (Code output):**
```python
import jax.numpy as jnp
from jax import grad
def f(x):
    return jnp.sum(x ** 2)
grad_f = grad(f)
print(grad_f(jnp.array([1.0, 2.0, 3.0])))
```
**A:** `[2.0, 4.0, 6.0]`  
*Micro-explanation:* `grad` returns a function computing the gradient. JAX uses functional transformations.

---

**Q42 (Fill-in):** To JIT-compile a function: `from jax import _______` then decorate with `@_______`  
**A:** `jit` → `@jit`  
*Micro-explanation:* Just-in-time compilation traces function and optimizes via XLA.

---

**Q43 (Multi):** Which are **JAX PRNG key rules**?  
A) Never reuse a key  
B) Split key with `jax.random.split(key, num)`  
C) Pass key explicitly to random functions  
D) Keys are global by default  
E) Keys are stateless  
**A:** A, B, C, E  
*Micro-explanation:* JAX PRNG is explicit and functional. Global state doesn't exist.

---

**Q44 (Single):** `jax.vmap` does what?  
A) Vectorizes a function over batch dimension  
B) Maps over dictionary keys  
C) Virtual memory mapping  
D) Version management  
**A:** A  
*Micro-explanation:* Transforms function to operate on batches without manual loops.

---

**Q45 (True/False):** JAX arrays are immutable by default.  
**A:** True  
*Micro-explanation:* In-place updates not allowed. Use `at[]` index update syntax.

---

## **XGBOOST SYNTAX**

**Q46 (Code output):**
```python
import xgboost as xgb
params = {'objective': 'binary:logistic', 'eval_metric': 'logloss'}
dtrain = xgb.DMatrix(X_train, label=y_train)
bst = xgb.train(params, dtrain, num_boost_round=10)
```
What is `DMatrix`?  
**A:** XGBoost's internal optimized data structure (faster than numpy/pandas)  
*Micro-explanation:* DMatrix loads data once and reuses across boosting rounds.

---

**Q47 (Fill-in):** In `xgb.XGBClassifier()`, to monitor validation set: use `eval_set=[(X_val, y_val)]` and `early_stopping_rounds=_______`  
**A:** integer (e.g., 10)  
*Micro-explanation:* Stops if no improvement for N rounds. Prevents overfitting.

---

**Q48 (Multi):** Which **parameters control overfitting** in XGBoost?  
A) `max_depth`  
B) `learning_rate`  
C) `subsample`  
D) `colsample_bytree`  
E) `reg_lambda` (L2)  
**A:** All of them  
*Micro-explanation:* Lower `max_depth`, lower `lr`, subsampling, column sampling, regularization all reduce overfitting.

---

**Q49 (Single):** `xgb.plot_importance(model)` shows:  
A) Feature importance by weight/gain/cover  
B) Tree structure visualization  
C) Learning curves  
D) SHAP values  
**A:** A  
*Micro-explanation:* Default is 'weight' (times feature used for splitting). Use `importance_type='gain'` for performance impact.

---

**Q50 (True/False):** XGBoost can handle missing values natively.  
**A:** True  
*Micro-explanation:* Automatically learns best direction for missing values during training.

---

Want another set focusing on **debugging common errors**, **library-specific gotchas**, or **comparison snippets** (e.g., same task in PyTorch vs TF vs JAX)?