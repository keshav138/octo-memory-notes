`As in do we need to install python on jenkins container manually or do it through the Jenkinsfile`

Both are valid but serve different purposes:

**Pre-installing on the agent (what we did)** — standard for persistent agents where you control the machine. Install once, all pipelines use it. Normal in company setups where agents are dedicated servers.

**Docker agent** — the cleaner, more modern approach. Each build gets a fresh environment, no "works on my machine" issues. This is what most teams do now.

---

The cleanest fix for our case is using a Docker agent in the Jenkinsfile — no manual apt-get needed:

```groovy
pipeline {
    agent {
        docker {
            image 'python:3.11.9-slim'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_NAME = "your_dockerhub_username/financial-rag"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    pip install --quiet torch --index-url https://download.pytorch.org/whl/cpu
                    pip install --quiet -r requirements.txt
                    pip install --quiet pytest httpx
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh 'pytest tests/ -v'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push to Docker Hub') {
            steps {
                sh """
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

Key differences:

- `agent { docker { image 'python:3.11.9-slim' } }` — Jenkins pulls this image and runs every stage inside it. Python is guaranteed, correct version, no manual installs
- No `venv` needed — the container itself is already isolated
- `-v /var/run/docker.sock:/var/run/docker.sock` — passes Docker socket so we can still run `docker build` inside the container

Also need to install the Docker Pipeline plugin in Jenkins: **Manage Jenkins** → **Plugins** → **Available** → search `Docker Pipeline` → install.

This is the right way to do it — go with this approach.