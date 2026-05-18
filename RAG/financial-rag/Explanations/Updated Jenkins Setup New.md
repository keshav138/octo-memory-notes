The issue is that tests run inside the `python:3.11.9-slim` Docker agent container — which has Python. But that container doesn't have Docker CLI installed in it.

You have two separate contexts:

```
Jenkins container (has Docker CLI now) ✓
    └── python:3.11.9-slim agent container (no Docker CLI) ✗ ← build runs here
```

---

### Cleanest fix — split agents per stage

Tests need Python, Docker stages need Docker. Use `agent none` at top level and specify per stage:

```groovy
pipeline {
    agent none

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_NAME = "keshavmaiya/financial-rag"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            agent any
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies & Test') {
            agent {
                docker {
                    image 'python:3.11.9-slim'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                }
            }
            steps {
                sh '''
                    pip install --quiet torch --index-url https://download.pytorch.org/whl/cpu
                    pip install --quiet -r requirements.txt
                    pip install --quiet pytest httpx
                    python -m pytest tests/test_api.py -v
                '''
            }
        }

        stage('Build & Push Docker Image') {
            agent any  // runs directly on Jenkins container which has Docker CLI
            steps {
                sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                    docker push ${IMAGE_NAME}:latest
                    docker logout
                """
            }
        }
    }

    post {
        success {
            echo "Pipeline succeeded - image pushed as ${IMAGE_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "Pipeline failed"
        }
    }
}
```

`agent any` runs directly on the Jenkins container — which now has Docker CLI. `agent { docker {...} }` runs inside the Python container — which has Python. Clean separation.