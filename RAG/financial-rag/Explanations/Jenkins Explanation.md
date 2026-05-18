This text file is a **Jenkinsfile** written in **Declarative Pipeline syntax**.

Now that you have built your RAG application, set up monitoring, and containerized it with Docker, you need a way to automate testing and deployment every single time you update your code. This is called **CI/CD (Continuous Integration / Continuous Deployment)**.

When you push new code to GitHub, Jenkins reads this script file from top to bottom and automatically runs an automated assembly line: it builds a clean sandbox environment, installs your dependencies, runs your test scripts, packages your app into a Docker container, and ships it to the cloud.

Here is the step-by-step breakdown of how this automated DevOps pipeline functions.

---

## Part 1: The Core Pipeline Wrappers

Groovy

```
pipeline {
    agent any
```

- **`pipeline { ... }`**: This is the mandatory root boundary wrapper. It tells Jenkins: _"Everything inside these brackets is a formal Declarative CI/CD pipeline script."_
    
- **`agent any`**: Dictates **where** this job should execute. Jenkins can manage multiple computer nodes (workers). By specifying `any`, you tell Jenkins: _"Just run this automation on whichever available worker machine has free CPU and memory capacity."_
    

---

## Part 2: Global Configuration (Environment)

Groovy

```
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_NAME = "your_dockerhub_username/financial-rag"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
```

- **`DOCKERHUB_CREDENTIALS = credentials(...)`**: This handles security. You must never hardcode passwords inside a Jenkinsfile repository. This line securely connects to Jenkins' built-in credential vault, pulls out a saved secret named `'dockerhub-credentials'`, and sets up two invisible variables for you to use later: `$DOCKERHUB_CREDENTIALS_USR` (username) and `$DOCKERHUB_CREDENTIALS_PSW` (password).
    
- **`IMAGE_NAME`**: Set up a reusable global variable tracking what repository destination path you want to give your Docker artifact image in the cloud.
    
- **`IMAGE_TAG = "${BUILD_NUMBER}"`**: Every single time Jenkins runs, it increments an automatic counter variable (`1`, `2`, `3`, etc.). Using this as your tag ensures that every single build creates a unique version of your app container, allowing you to easily roll back if a specific build breaks.
    

---

## Part 3: The Assembly Line Stages (`stages`)

The `stages` block acts as the sequential checklist of actions. If any individual stage fails, the pipeline immediately stops, flags an error, and aborts subsequent steps.

### Stage 1: Pulling the Code

Groovy

```
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
```

- **`checkout scm`**: Tells Jenkins to connect to your Source Control Management system (like your connected GitHub repository) and clone 100% of the active project code branch directly onto the worker machine's local workspace directory.
    

### Stage 2: Provisioning Python Environments

Groovy

```
        stage('Install Dependencies') {
            steps {
                sh '''
                    python -m venv venv
                    . venv/bin/activate
                    pip install --quiet torch --index-url https://download.pytorch.org/whl/cpu
                    pip install --quiet -r requirements.txt
                    pip install --quiet pytest httpx
                '''
            }
        }
```

- **`sh '''...'''`**: Executes multi-line raw shell terminal commands.
    
- **The Execution:** It boots up a brand new virtual environment (`venv`) inside Jenkins. It explicitly fetches a lightweight, **CPU-only version of PyTorch**. (Your embedding models rely on PyTorch; fetching the standard version would download a massive 2GB+ file filled with Nvidia CUDA GPU binaries that a basic Jenkins CI server doesn't need, wasting minutes of build time). Then it installs your standard requirements, along with testing tools like `pytest` and `httpx`.
- The **HTTPX** library is a next-generation, fully-featured HTTP client for Python. It is widely used for ==sending HTTP requests, fetching data from web APIs, and web scraping==

#### Key Features of `--quiet`

- **Additive Behavior**: This option can be used up to **three times** to increase the level of silence:
    - `-q`: Suppresses basic informational messages.
    - `-qq`: Further reduces output, often showing only errors.
    - `-qqq`: Silences almost all output, including critical errors.
- **Progress Bars**: When using `--quiet`, pip typically suppresses download progress bars.
- **Log Management**: It helps keep log files small and readable by preventing them from being filled with verbose installation details.
- **JSON Reporting**: It is often paired with the `--report` option when writing to standard output to prevent pip's logging messages from mixing with the JSON data.

### Stage 3: Quality Control Testing

Groovy

```
        stage('Run Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    pytest tests/ -v
                '''
            }
        }
```

- **The Guardrail:** It activates your virtual environment and executes `pytest`. This will run the `test_vectorstore.py` logic you built earlier! If a change you made to your RAG path logic breaks your database or fails an assertion, **the pipeline crashes right here**. Your broken code is blocked and never makes it to production.
    

### Stage 4: Compiling the Container Artifact

Groovy

```
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }
```

- If your tests pass successfully, Jenkins calls the system's local Docker engine to run `docker build`. It packages your application code into an immutable image file tagged with the current build number (e.g., `myusername/financial-rag:14`).
    

### Stage 5: Shipping to the Registry Cloud

Groovy

```
        stage('Push to Docker Hub') {
            steps {
                sh '''
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                    docker push ${IMAGE_NAME}:latest
                '''
            }
        }
```

- **`docker login ... --password-stdin`**: Uses the hidden credential vault values fetched in Part 2 to securely log Jenkins into your public or private Docker Hub cloud profile without exposing passwords in console log tracks.
    
- **`docker push`**: Uploads your versioned container (`:14`) up to Docker Hub.
    
- **`docker tag ... :latest`**: Creates a clone label pointing to the exact same artifact container but names it `:latest`. It pushes that too, so anyone pulling your image on the internet can simply ask for the latest version without tracking explicit numbers.
    

---

## Part 4: Cleanup & Notification Handling (`post`)

The `post` block defines conditional instructions that run _after_ the entire pipeline checklist completes its sequence.

Groovy

```
    post {
        always {
            sh "docker logout"
        }
        success {
            echo "Pipeline succeeded - image pushed as ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "Pipeline failed"
        }
    }
}
```

- **`always`**: No matter what happens (even if your tests crashed or a connection timed out), this block **guarantees** execution. Running `docker logout` ensures your secure Docker Hub credentials are wiped from the active Jenkins worker memory environment workspace, leaving the machine safe.
    
- **`success` / `failure`**: Conditional triggers. Depending on how the pipeline terminated, it streams logs to your terminal display window. In enterprise pipelines, developers often hook these blocks up to send a notification directly to a Slack channel or email list to alert the engineering team of a successful deployment or a broken build.