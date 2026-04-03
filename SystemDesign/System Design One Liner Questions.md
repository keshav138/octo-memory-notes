```
1. How do you avoid making multiple requests, if on a payment gateway a user makes multiple clicks on the pay button?
   We implement a idempotency key with the POST request. Server stores result with key. If request comes with same key again, returns cached result of pending/done/rejected. Prevents double charges. 
```

```

```