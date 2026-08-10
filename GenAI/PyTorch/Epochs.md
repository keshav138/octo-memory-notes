An **epoch** represents one complete pass of the entire training dataset through a machine learning model.

  

If your dataset contains 10,000 images, 1 epoch means the neural network has processed, computed losses for, and updated its weights based on all 10,000 images exactly once.

  

### The Epoch Pipeline (Iterative Learning)

Because datasets are usually too large to fit into GPU memory all at once, an epoch is divided into smaller chunks called **batches**:

  

$$\text{1 Epoch} = \left( \frac{\text{Total Training Samples}}{\text{Batch Size}} \right) \text{ Steps / Iterations}$$

#### Example Breakdown:

- **Total Dataset Size:** 32,000 sentences
    
      
    
- **Batch Size:** 32
    
      
    
- **Iterations (Steps) per Epoch:** $32,000 / 32 = 1,000$ steps
    
      
    
- **Total Epochs:** 10
    
      
    

During training, the model performs **1,000 forward/backward updates** to complete 1 epoch. Over 10 epochs, the model performs **10,000 total updates**, seeing each sentence 10 times.

  

### Why Do We Need Multiple Epochs?

On the first pass (Epoch 1), the model's weights are random or unoptimized, leading to high error (loss). A single pass isn't enough for gradient descent to adjust millions of parameters to their optimal values.

  

- **Too Few Epochs (Underfitting):** The model hasn't seen the data enough times to learn underlying patterns, trends, or features.
    
      
    
- **Too Many Epochs (Overfitting):** The model starts memorizing noise and specific details of the training set rather than learning general concepts, leading to poor performance on new/unseen validation data.
    
      
    

### What Epochs Mean in Transformers & LLMs

While the mathematical definition of an epoch remains identical across deep learning models, its practical application changes dramatically depending on the architecture:

  

#### 1. Computer Vision & Standard CNNs / RNNs

- **Epoch Count:** Typically high (**30 to 300+ epochs**).
    
      
    
- **Behavior:** Image datasets (e.g., ImageNet with 1.2M images) are relatively small compared to the capacity of the models. They require passing the same dataset through the network dozens or hundreds of times to converge.
    
      
    

#### 2. Fine-Tuning Transformers (e.g., BERT, RoBERTa, LLM Instruction Tuning)

- **Epoch Count:** Very low (**2 to 5 epochs**).
    
      
    
- **Behavior:** Pre-trained Transformers already understand general language representations. During downstream fine-tuning (e.g., sentiment classification or task adaptation), training for more than 3–5 epochs often causes catastrophic forgetting or severe overfitting.
    
      
    

#### 3. Pre-training Large Language Models (LLMs like GPT-4, Llama, Mistral)

- **Epoch Count:** Often **1 single epoch** (or even < 1 epoch).
    
      
    
- **Behavior:** Pre-training web-scale LLMs involves billions or trillions of tokens (e.g., 2–15 trillion tokens). Because the dataset is so vast and compute is expensive:
    
      
    - Models rarely see the exact same document twice.
        
          
        
    - Progress is tracked strictly by **Total Tokens Processed** or **Global Steps** rather than epochs.
        
          
        
    - A single pass through a multi-trillion token dataset takes weeks or months on thousands of GPUs, making multi-epoch pre-training unnecessary and prone to overfitting on web data.
        

### Summary Checklist

|**Concept**|**Definition**|
|---|---|
|**Batch Size**|Number of training samples processed in one forward/backward pass.|
|**Step / Iteration**|One weight update using a single batch.|
|**Epoch**|One full cycle through all batches in the dataset.|
|**Epochs in Standard DL**|Many passes (e.g., 50–200 epochs).|
|**Epochs in LLM Fine-tuning**|Few passes (e.g., 2–5 epochs).|
|**Epochs in LLM Pre-training**|Typically 1 single pass across trillions of tokens.|