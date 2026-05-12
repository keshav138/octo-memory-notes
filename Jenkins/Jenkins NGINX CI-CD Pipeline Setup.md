CI/CD Pipeline: Docker + Nginx + AWS Deployment

Perfect starter pipeline. Let's build this step by step — from **local testing** to **fully automated deployment on AWS**.

---

## Part 1: What We're Building

```
Developer pushes code to GitHub
         │
         ▼
    GitHub Webhook ─────► Jenkins
         │                   │
         │                   ▼
         │              Build Docker image
         │                   │
         │                   ▼
         │              Push to Docker Hub
         │                   │
         │                   ▼
         │              Deploy to AWS EC2
         │                   │
         ▼                   ▼
    User visits: http://EC2_IP → sees index.html
```

**Tech stack**:
- Git repository (GitHub)
- Jenkins (CI/CD orchestrator)
- Docker (containerize nginx + index.html)
- Docker Hub (image registry)
- AWS EC2 (runs the container)

---

## Part 2: Local Setup & Testing (Before Jenkins)

### Step 1: Project Structure

Create a new directory:

```powershell
mkdir nginx-demo-cicd
cd nginx-demo-cicd
```

Create these files:

**`index.html`** (your webpage):
```html
<!DOCTYPE html>
<html>
<head>
    <title>Jenkins CI/CD Demo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            padding: 40px;
            display: inline-block;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        h1 { font-size: 3em; }
        .version { margin-top: 30px; padding: 10px; background: rgba(0,0,0,0.3); border-radius: 10px; }
        .badge { display: inline-block; background: #4CAF50; padding: 5px 15px; border-radius: 20px; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Jenkins CI/CD Pipeline</h1>
        <p>This page was deployed automatically by Jenkins!</p>
        <div class="badge">Deployed: <span id="timestamp"></span></div>
        <div class="version">
            <p>Build Number: <strong id="build-number"></strong></p>
            <p>Commit: <strong id="commit"></strong></p>
        </div>
    </div>

    <script>
        document.getElementById('timestamp').innerText = new Date().toLocaleString();
        // Environment variables injected by Docker at build time
        document.getElementById('build-number').innerText = document.getElementById('build-number').innerText || 'v1.0';
        document.getElementById('commit').innerText = document.getElementById('commit').innerText || 'local';
    </script>
</body>
</html>
```

**`Dockerfile`**:
```dockerfile
# Use official nginx image
FROM nginx:alpine

# Copy our custom index.html to nginx's web directory
COPY index.html /usr/share/nginx/html/index.html

# Optional: Custom nginx config (if needed)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Nginx automatically starts (default command)
```

**`nginx.conf`** (optional — create if you need custom config):
```nginx
server {
    listen 80;
    server_name localhost;
    
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
    
    # Health check endpoint
    location /health {
        return 200 'OK';
        add_header Content-Type text/plain;
    }
}
```

### Step 2: Test Locally (Before Any Automation)

```powershell
# Build the Docker image
docker build -t nginx-demo:latest .

# Run it locally
docker run -d -p 8080:80 --name nginx-test nginx-demo:latest

# Test it
curl http://localhost:8080
# Or open browser to http://localhost:8080

# Clean up
docker stop nginx-test
docker rm nginx-test
```

✅ **Success**: You can see `index.html` at localhost:8080

---

## Part 3: Push to GitHub

### Step 1: Create GitHub Repository

```powershell
# Either via GitHub UI or CLI:
gh repo create nginx-demo-cicd --public
```

### Step 2: Push your code

```powershell
git init
git add .
git commit -m "Initial commit: nginx + index.html"
git remote add origin https://github.com/YOUR_USERNAME/nginx-demo-cicd.git
git branch -M main
git push -u origin main
```

---

## Part 4: AWS EC2 Setup (Deployment Target)

### Step 1: Launch EC2 Instance

```powershell
# Using AWS CLI (or do via Console)

# Create security group for nginx (port 80)
aws ec2 create-security-group --group-name nginx-demo-sg --description "Allow HTTP for nginx demo"

# Add inbound rule for port 80
aws ec2 authorize-security-group-ingress --group-name nginx-demo-sg --protocol tcp --port 80 --cidr 0.0.0.0/0

# Add inbound rule for SSH (your IP only)
aws ec2 authorize-security-group-ingress --group-name nginx-demo-sg --protocol tcp --port 22 --cidr YOUR_IP_ADDRESS/32

# Launch EC2 (Ubuntu 22.04)
aws ec2 run-instances \
    --image-id ami-0c55b159cbfafe1f0 \
    --instance-type t2.micro \
    --key-name YOUR_KEY_NAME \
    --security-group-ids sg-YOUR_SG_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=nginx-demo-server}]'
```

**Or via Console**:
1. EC2 → Launch Instance
2. Name: `nginx-demo-server`
3. AMI: Ubuntu 22.04 (free tier)
4. Instance type: t2.micro
5. Key pair: Create or use existing
6. Security group: Create new, allow HTTP (80) and SSH (22)
7. Launch

### Step 2: Install Docker on EC2

SSH into your EC2 instance:

```powershell
ssh -i your-key.pem ubuntu@EC2_PUBLIC_IP
```

Run these commands:

```bash
# Update and install Docker
sudo apt update
sudo apt install -y docker.io

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add ubuntu user to docker group (so you don't need sudo)
sudo usermod -aG docker ubuntu

# Verify Docker works
docker --version

# Log out and back in (or run: newgrp docker)
exit
# SSH again
```

### Step 3: Test Deployment Manually (from EC2)

```bash
# On EC2, pull and run your image
docker pull YOUR_DOCKER_USERNAME/nginx-demo:latest
docker run -d -p 80:80 --name nginx-app YOUR_DOCKER_USERNAME/nginx-demo:latest

# Test locally on EC2
curl localhost

# Verify in browser
# http://EC2_PUBLIC_IP
```

✅ **Success**: You see your index.html via EC2 public IP

---

## Part 5: Jenkins Setup (CI/CD Server)

### Option A: Jenkins on EC2 (Recommended — persistent)

Launch a **separate** EC2 instance for Jenkins:

```powershell
# Similar to above, but with different security group
# Jenkins needs port 8080 open
```

SSH into Jenkins EC2 and install Jenkins:

```bash
# Install Java (Jenkins requirement)
sudo apt update
sudo apt install -y openjdk-11-jdk

# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update
sudo apt install -y jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Access Jenkins: `http://JENKINS_EC2_IP:8080`

### Option B: Jenkins on Docker (Quick for learning)

```powershell
docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -u root \
  jenkins/jenkins:lts

# Get initial password
docker logs jenkins
```

### Jenkins Initial Setup (Both Options)

1. Open `http://JENKINS_IP:8080`
2. Enter initial admin password
3. Install suggested plugins
4. Create admin user

### Install Required Jenkins Plugins

Go to **Manage Jenkins → Plugins → Available Plugins** and install:
- Docker Pipeline
- Docker Commons
- Docker Build step
- GitHub Integration
- Pipeline AWS Steps

---

## Part 6: Configure Jenkins Credentials

### Step 1: Docker Hub Credentials

In Jenkins:
1. **Manage Jenkins → Credentials → System → Global credentials (unrestricted)**
2. **Add Credentials**
   - Kind: Username with password
   - Scope: Global
   - Username: `YOUR_DOCKER_USERNAME`
   - Password: `YOUR_DOCKER_PASSWORD`
   - ID: `docker-hub-credentials`
   - Description: `Docker Hub login`

### Step 2: GitHub Credentials (if private repo)

Add GitHub personal access token:
- Kind: Secret text
- Secret: `GITHUB_TOKEN`
- ID: `github-token`

### Step 3: AWS Credentials (for EC2 deployment)

Install AWS credentials plugin, then:
- Kind: AWS credentials
- Access Key ID: `YOUR_AWS_ACCESS_KEY`
- Secret Key: `YOUR_AWS_SECRET_KEY`
- ID: `aws-credentials`

---

## Part 7: Create the Jenkins Pipeline

### Pipeline Script (Jenkinsfile)

Create this `Jenkinsfile` in your GitHub repository (next to index.html and Dockerfile):

```groovy
pipeline {
    agent any
    
    environment {
        // Credential IDs from Jenkins
        DOCKER_CREDS = credentials('docker-hub-credentials')
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_IMAGE = "${DOCKER_CREDS_USR}/nginx-demo"
        
        // AWS Configuration
        AWS_REGION = 'us-east-1'
        EC2_PUBLIC_IP = 'YOUR_EC2_PUBLIC_IP'  // Replace with your EC2 IP
    }
    
    triggers {
        // Poll GitHub every minute (simplest for demo)
        pollSCM('* * * * *')
        
        // Better: GitHub webhook (requires setup)
        // GenericTrigger(...)
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }
        
        stage('Display Build Info') {
            steps {
                echo "Building: ${env.JOB_NAME} - ${env.BUILD_NUMBER}"
                echo "Git Commit: ${env.GIT_COMMIT}"
                sh 'ls -la'
                sh 'cat index.html | head -5'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh """
                    docker build -t ${DOCKER_IMAGE}:${env.BUILD_NUMBER} .
                    docker tag ${DOCKER_IMAGE}:${env.BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing to Docker Hub...'
                sh """
                    echo ${DOCKER_CREDS_PSW} | docker login -u ${DOCKER_CREDS_USR} --password-stdin
                    docker push ${DOCKER_IMAGE}:${env.BUILD_NUMBER}
                    docker push ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('Deploy to EC2') {
            steps {
                echo 'Deploying to AWS EC2...'
                
                // Deploy via SSH to EC2
                sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${EC2_PUBLIC_IP} << 'ENDSSH'
                        # Stop old container
                        docker stop nginx-app || true
                        docker rm nginx-app || true
                        
                        # Pull latest image
                        docker pull ${DOCKER_IMAGE}:latest
                        
                        # Run new container
                        docker run -d -p 80:80 --name nginx-app --restart always ${DOCKER_IMAGE}:latest
                        
                        # Verify deployment
                        echo "=== Deployment Verification ==="
                        sleep 2
                        curl -s localhost | grep -q "Jenkins CI/CD" && echo "✓ Deployment successful!" || echo "✗ Deployment failed"
                    ENDSSH
                """
            }
        }
        
        stage('Health Check') {
            steps {
                echo 'Checking health endpoint...'
                sh """
                    curl -s http://${EC2_PUBLIC_IP}:80/health || true
                """
            }
        }
    }
    
    post {
        success {
            echo '🎉 Pipeline succeeded!'
            echo "http://${EC2_PUBLIC_IP}"
            
            // Optional: Send Slack notification
            // slackSend(color: 'good', message: "Deployment successful: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
        }
        failure {
            echo '💥 Pipeline failed!'
            // slackSend(color: 'danger', message: "Deployment failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}")
        }
        always {
            echo 'Pipeline finished.'
            // Clean up Docker stuff
            sh 'docker system prune -f || true'
        }
    }
}
```

### Important: Setup SSH Key for Jenkins Agent

Jenkins needs to SSH into your EC2 deployment target:

```powershell
# On your Jenkins server (or Jenkins container)

# Copy your EC2 key pair to Jenkins
scp -i your-key.pem ubuntu@JENKINS_IP:~/your-key.pem

# Or if Jenkins is on Docker:
docker cp your-key.pem jenkins:/var/jenkins_home/.

# SSH into Jenkins container
docker exec -it jenkins bash

# Set correct permissions
mkdir -p /var/jenkins_home/.ssh
cp /var/jenkins_home/your-key.pem /var/jenkins_home/.ssh/id_rsa
chmod 600 /var/jenkins_home/.ssh/id_rsa

# Test SSH connection
ssh -o StrictHostKeyChecking=no ubuntu@YOUR_EC2_IP
```

---

## Part 8: Create Jenkins Job

### Method 1: Pipeline from SCM (Recommended)

1. **New Item** → Enter name: `nginx-demo-cicd`
2. Select **Pipeline**
3. Under **Pipeline** section:
   - Definition: **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: `https://github.com/YOUR_USERNAME/nginx-demo-cicd.git`
   - Branches to build: `*/main`
   - Script Path: `Jenkinsfile`
4. **Save**

### Method 2: Test with Manual Script (Quick verification)

1. **New Item** → `nginx-demo-test` → Pipeline
2. Under **Pipeline**:
   - Definition: **Pipeline script**
   - Script:

```groovy
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                echo 'Jenkins is working!'
                sh 'docker --version'
            }
        }
    }
}
```

3. **Build Now** (should show Docker version)

---

## Part 9: Run the Pipeline

### First Build

1. Click **Build Now** on your `nginx-demo-cicd` job
2. Watch console output (click the build #, then Console Output)

### Verify Deployment

After successful build:
1. Check Jenkins console → shows EC2 IP
2. Open browser: `http://YOUR_EC2_IP`
3. You should see your `index.html`!

### Trigger Automatically

**Option 1: PollSCM (already configured)**
- Jenkins checks GitHub every minute for changes
- Push a change to `index.html`, wait up to 60 seconds

**Option 2: GitHub Webhook (better)**

In GitHub repo:
1. Settings → Webhooks → Add webhook
2. Payload URL: `http://JENKINS_IP:8080/github-webhook/`
3. Content type: `application/json`
4. Events: Just push events
5. Save

Then remove `pollSCM` trigger from Jenkinsfile.

---

## Part 10: Test the Full Pipeline

### Step 1: Make a change locally

Edit `index.html`:
```html
<!-- Change the version number or message -->
<div class="badge">Deployed: <span id="timestamp"></span> via Jenkins v2.0</div>
```

### Step 2: Commit and push

```powershell
git add index.html
git commit -m "Updated index.html with new version"
git push origin main
```

### Step 3: Watch Jenkins

- Within 60 seconds (pollSCM) or instantly (webhook)
- Jenkins starts a new build
- Builds Docker image with updated content
- Pushes to Docker Hub
- Deploys to EC2

### Step 4: Refresh browser

- `http://YOUR_EC2_IP`
- Your changes are live!

---

## Part 11: Troubleshooting Common Issues

| Problem | Solution |
|---------|----------|
| `docker: command not found` | Jenkins agent needs Docker installed: `apt install docker.io` |
| `Permission denied` connecting to Docker | Add Jenkins user to docker group: `sudo usermod -aG docker jenkins` |
| SSH connection refused | Check EC2 security group (port 22 open) and key permissions |
| Cannot pull private image | Make sure `docker login` succeeds (check credentials in Jenkins) |
| EC2 not reachable | Security group must allow port 80 from 0.0.0.0/0 |
| Port 80 already in use on EC2 | `docker stop nginx-app` before redeploy |
| Jenkins build hangs | Check timeout settings; add `options { timeout(time: 10, unit: 'MINUTES') }` |
| Webhook not triggering | Test webhook in GitHub settings → "Recent Deliveries" |

---

## Part 12: Full End-to-End Test Checklist

```bash
# 1. Local test
docker build -t nginx-demo .
docker run -p 8080:80 nginx-demo
curl localhost:8080
# ✅

# 2. Push to GitHub
git push origin main
# ✅

# 3. Jenkins triggers (wait or webhook)
# Check Jenkins console for "Started by ..."
# ✅

# 4. Build stage passes
# Console shows "Building Docker image... Success"
# ✅

# 5. Push to Docker Hub passes
# Console shows "Pushing to Docker Hub... Success"
# ✅

# 6. Deploy to EC2 passes
# Console shows "Deployment successful"
# ✅

# 7. Browser test
open http://EC2_IP
# Shows index.html with build number
# ✅
```

---

## Part 13: Enhancements (After Basic Works)

### 1. Add build number to HTML

Modify Jenkinsfile to inject build number:

```groovy
stage('Update HTML with Build Info') {
    steps {
        sh """
            sed -i "s/BUILD_NUMBER_PLACEHOLDER/${env.BUILD_NUMBER}/g" index.html
            sed -i "s/COMMIT_PLACEHOLDER/${env.GIT_COMMIT}/g" index.html
        """
    }
}
```

### 2. Add test stage

```groovy
stage('Test Deployment') {
    steps {
        sh """
            sleep 5  # Wait for container to start
            curl -f http://${EC2_PUBLIC_IP} || exit 1
            curl -f http://${EC2_PUBLIC_IP}/health || exit 1
        """
    }
}
```

### 3. Add rollback capability

```groovy
stage('Rollback?') {
    when { expression { return params.ROLLBACK == true } }
    steps {
        sh """
            ssh ubuntu@${EC2_PUBLIC_IP} << 'ENDSSH'
                docker stop nginx-app
                docker rm nginx-app
                docker run -d -p 80:80 --name nginx-app ${DOCKER_IMAGE}:${prev_build_number}
            ENDSSH
        """
    }
}
```

### 4. Add email notifications

```groovy
post {
    failure {
        emailext (
            subject: "Pipeline Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
            body: "Check console: ${env.BUILD_URL}",
            to: 'team@example.com'
        )
    }
}
```

---

## Summary: What You've Built

```
✅ Local Docker image (nginx + index.html)
✅ GitHub repository with source code
✅ Jenkins Pipeline (Jenkinsfile as code)
✅ Docker Hub integration (store images)
✅ EC2 deployment (automated pull and run)
✅ Automated triggers (push to GitHub = new deploy)
```

**Your pipeline now**:
- Builds automatically on code push
- Creates reproducible Docker images
- Deploys consistently to AWS
- Gives you versioned rollbacks

**Next steps after this**:
1. Add Blue/Green deployment (zero downtime)
2. Add AWS Load Balancer (scale to multiple instances)
3. Use Terraform to provision EC2 (instead of manual)
4. Add staging environment (test before prod)

Ready to try this hands-on? Or want to dive deeper into any specific part (like GitHub webhooks, Docker optimization, or Jenkins agent setup)?