Let's set up Jenkins.

The goal here is a simple CI pipeline that:

```
code push → Jenkins pulls → runs tests → builds Docker image → pushes to Docker Hub
```

---

### Step 1 — Add Jenkins to `docker-compose.yml`

Add this service:

```yaml
  jenkins:
    image: jenkins/jenkins:lts
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock  # lets Jenkins run Docker commands
    user: root
```

And add `jenkins_data` to the volumes section at the bottom:

```yaml
volumes:
  prometheus_data:
  grafana_data:
  jenkins_data:
```

---

### Step 2 — Add a basic test first

Jenkins needs something to test. Create `tests/test_api.py`:

```python
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

def test_query_empty_question():
    response = client.post("/query", json={"question": ""})
    assert response.status_code == 400

def test_ingest_non_pdf():
    from io import BytesIO
    response = client.post(
        "/ingest",
        files={"file": ("test.txt", BytesIO(b"test content"), "text/plain")}
    )
    assert response.status_code == 400
```

Install pytest:

```powershell
pip install pytest pytest-asyncio httpx
```

Run locally first to confirm passing:

```powershell
pytest tests/ -v
```

---

### Step 3 — `Jenkinsfile`

Create `jenkins/Jenkinsfile` in your jenkins folder:

```groovy
pipeline {
    agent any

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
                    python -m venv venv
                    . venv/bin/activate
                    pip install --quiet torch --index-url https://download.pytorch.org/whl/cpu
                    pip install --quiet -r requirements.txt
                    pip install --quiet pytest httpx
                '''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    pytest tests/ -v
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

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
    }

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

---

### Step 4 — Jenkins initial setup

Restart compose:

```powershell
docker-compose down
docker-compose up --build
```

Open `http://localhost:8080`, then:

1. Get initial admin password:

```powershell
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

2. Install suggested plugins
3. Create admin user

---

### Step 5 — Configure Docker Hub credentials in Jenkins

1. **Manage Jenkins** → **Credentials** → **System** → **Global credentials** → **Add Credentials**
2. Kind: `Username with password`
3. Username: your Docker Hub username
4. Password: your Docker Hub password or access token
5. ID: `dockerhub-credentials` — must match the Jenkinsfile exactly

---

### Step 6 — Create Pipeline job

1. **New Item** → name it `financial-rag` → select **Pipeline**
2. Under Pipeline section:
    - Definition: `Pipeline script from SCM`
    - SCM: `Git`
    - Repository URL: your GitHub repo URL
    - Script Path: `jenkins/Jenkinsfile`
3. Save → **Build Now**

---

### What's happening here — learn this

**`credentials('dockerhub-credentials')`**

- Jenkins injects credentials as `_USR` and `_PSW` env vars automatically
- Never hardcode credentials in Jenkinsfile — this is the correct pattern

**`/var/run/docker.sock`**

- Mounts the host Docker socket into Jenkins container
- Lets Jenkins run `docker build` and `docker push` using the host's Docker daemon
- Called "Docker outside of Docker" (DooD) pattern

**`${BUILD_NUMBER}`**

- Jenkins built-in variable, increments each build
- Tags each image uniquely — you can roll back to any previous build

**`post` block**

- `always` runs regardless of success/failure — good for cleanup
- `success/failure` for notifications or specific actions

---

Let me know once the pipeline runs successfully and we'll move to Terraform.