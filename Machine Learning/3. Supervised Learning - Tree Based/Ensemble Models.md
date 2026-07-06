Ensemble models work by combining multiple individual machine learning models (called "base learners") to produce a single, highly accurate, and robust prediction. Instead of relying on a single "expert" algorithm, they leverage the wisdom of the crowd, allowing the models to compensate for each other's blind spots.

The overall framework operates through three primary techniques, each executing the "group approach" differently: 
  

1. Bagging (Bootstrap Aggregating)

  

Bagging aims to reduce variance (preventing the model from overfitting to the training data).

- How it works: It trains multiple models independently in _parallel_. Each model is trained on a random, slightly different subset of the training data (drawn with replacement).
- Making the final prediction: For classification, the ensemble takes a majority vote. For regression, it averages the outputs.
- _Example:_ Random Forest.

2. Boosting

  

Boosting aims to reduce bias (preventing the model from underfitting or making overly simple assumptions).

- How it works: It trains models _sequentially_ (one after the other). Instead of making independent guesses, each new model is specifically trained to correct the errors and mistakes made by the previous models.
- Making the final prediction: It weights the predictions, placing higher importance on the models that perform better on the tricky, previously misclassified data.
- _Examples:_ AdaBoost, XGBoost, and Gradient Boosting Machines (GBM).

3. Stacking (Stacked Generalization)

  

Stacking utilizes a combination of entirely different algorithms.

- How it works: Instead of using a simple vote or average, it feeds the predictions of several base models into a new, higher-level model called a meta-learner.
- Making the final prediction: The meta-learner is trained to figure out which base models are the most trustworthy and how much weight should be assigned to each one's prediction.

Why are they so popular?

- Higher Accuracy: An ensemble almost always outperforms any single underlying model.
- Robustness: If one model makes an odd prediction, the others cancel it out, making the system resilient to noisy data.
- Generalization: They perform significantly better on unseen data.
