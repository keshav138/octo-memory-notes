# Jenkins Lab Guide
### From Installation to CI/CD Pipelines

---

## Table of Contents

1. [Introduction to Jenkins](#1-introduction-to-jenkins)
2. [Why Use Docker for Jenkins?](#2-why-use-docker-for-jenkins)
3. [Prerequisites](#3-prerequisites)
4. [Step-by-Step Jenkins Installation Using Docker](#4-step-by-step-jenkins-installation-using-docker)
5. [Demonstration Programs](#5-demonstration-programs)
6. [Key Commands Summary](#6-key-commands-summary)
7. [Common Errors & Fixes](#7-common-errors--fixes)
8. [Viva Questions](#8-viva-questions)

---

## 1. Introduction to Jenkins

### What is Jenkins?

Jenkins is a free, open-source **automation server** written in Java. It was originally developed as "Hudson" at Sun Microsystems and later forked as Jenkins in 2011. Today, Jenkins is one of the most widely used tools in the DevOps ecosystem, trusted by thousands of organizations worldwide to automate repetitive software development tasks.

In simple terms: **Jenkins helps developers build, test, and deploy applications automatically — so humans don't have to do it manually every time.**

### The Problem Jenkins Solves

To appreciate Jenkins, let's look at what software development looked like **before** automation tools:

#### Before Jenkins — Manual Workflow

```
Developer writes code
        ↓
Manually compiles the code on local machine
        ↓
Manually runs all test cases one by one
        ↓
Manually packages the application (.jar / .war / .zip)
        ↓
Manually uploads to a server (FTP / SSH)
        ↓
Manually sends email to team: "Deployment done!"
```

**Problems with this approach:**
- Takes 30–60 minutes of manual effort per deployment
- Human errors are common (forgot to run tests, wrong file uploaded)
- If 10 developers push code the same day, someone has to repeat this 10 times
- No visibility — team doesn't know if tests passed or failed
- Works on one machine, breaks on another ("works on my machine" syndrome)

#### After Jenkins — Automated Workflow

```
Developer pushes code to GitHub
        ↓
Jenkins automatically detects the new code
        ↓
Jenkins automatically compiles the code
        ↓
Jenkins automatically runs all tests
        ↓
Jenkins automatically deploys (if tests pass)
        ↓
Jenkins automatically notifies the team with results
```

**Benefits:**
- Entire process completes in minutes without human intervention
- Tests always run — no human can skip them by mistake
- Every deployment follows the exact same steps, every single time
- Team gets immediate feedback if something breaks
- Multiple developers' code can be integrated several times a day

---

### The Core Concept: CI/CD

Jenkins is built around the CI/CD philosophy. Understanding this concept is essential.

```
┌─────────────────────────────────────────────────────────────────┐
│                        CI / CD PIPELINE                         │
│                                                                 │
│  Developer  →  GitHub  →  Jenkins  →  Test  →  Deploy  →  Live │
│                                                                 │
│  ◄─────── Continuous Integration ────────►                      │
│                          ◄──────── Continuous Deployment ──────►│
└─────────────────────────────────────────────────────────────────┘
```

#### Continuous Integration (CI)

Continuous Integration is the practice of merging code changes into a shared repository **frequently** (multiple times a day), and automatically verifying each change by building and testing it.

The key idea: *integrate early, integrate often, catch bugs early.*

When a developer pushes code to GitHub:
1. Jenkins automatically pulls the latest code
2. Jenkins compiles/builds it
3. Jenkins runs automated tests
4. Jenkins reports: ✅ Success or ❌ Failure

If a test fails, the team knows immediately — not days later when the code is already mixed with everyone else's changes.

#### Continuous Deployment (CD)

Continuous Deployment takes CI one step further. After successful testing, Jenkins **automatically deploys** the application to a server (staging or production).

No human needs to say "okay, deploy it." Jenkins already knows — if tests passed, ship it.

---

### Jenkins Architecture

Jenkins follows a **Master-Agent (Controller-Worker)** architecture, which allows it to scale and distribute workloads.

```
                     ┌─────────────────────────────────┐
                     │        JENKINS MASTER           │
                     │         (Controller)            │
                     │                                 │
                     │  • Manages the dashboard (UI)   │
                     │  • Schedules jobs               │
                     │  • Distributes work to agents   │
                     │  • Stores build history         │
                     │  • Manages plugins              │
                     └──────────────┬──────────────────┘
                                    │
               ┌────────────────────┼────────────────────┐
               │                    │                    │
               ▼                    ▼                    ▼
   ┌───────────────────┐ ┌─────────────────────┐ ┌──────────────────────┐
   │   AGENT / WORKER  │ │   AGENT / WORKER    │ │   AGENT / WORKER     │
   │      (Node 1)     │ │      (Node 2)       │ │       (Node 3)       │
   │                   │ │                     │ │                      │
   │  Runs Java builds │ │  Runs Python tests  │ │  Deploys to AWS      │
   └───────────────────┘ └─────────────────────┘ └──────────────────────┘
```

**Jenkins Master (Controller):**
- The brain of Jenkins
- Hosts the web dashboard at `http://localhost:8080`
- Schedules and monitors all jobs
- Does not execute heavy build tasks itself (delegates to agents)

**Jenkins Agents (Workers):**
- Machines that execute the actual build/test/deploy tasks
- Can be Windows, Linux, or Mac machines
- Can run on physical servers, VMs, or Docker containers
- In a simple setup (like ours), the master also acts as the agent

**Jobs / Pipelines:**
- A "Job" is a defined task — like "pull code, run tests, deploy"
- A "Pipeline" is a series of stages written as code (Jenkinsfile)

---

### Jenkins Pipeline — Stages

A Jenkins Pipeline is a script (written in Groovy) that defines what Jenkins should do, step by step. Pipelines are visual and organized into **stages**:

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  Source  │───►│  Build   │───►│   Test   │───►│  Deploy  │
│   Code   │    │          │    │          │    │          │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
   GitHub        Compile         Unit tests       Live server
```

In Jenkins dashboard, this looks like a colorful row of green/red boxes — each box represents a stage. This visual feedback makes it easy to see exactly where a build failed.

---

### Key Features of Jenkins

| Feature | Description |
|---|---|
| **Open Source** | Free to use, large community, actively maintained |
| **1,800+ Plugins** | Integrate with Git, Docker, AWS, Slack, JIRA, and more |
| **Pipeline as Code** | Write your entire automation logic as a `Jenkinsfile` |
| **Distributed Builds** | Distribute work across multiple machines (agents) |
| **Platform Independent** | Runs on Windows, Linux, macOS |
| **Easy Web UI** | Browser-based dashboard for creating and monitoring jobs |
| **Notifications** | Email, Slack, or Teams alerts on build status |
| **Parameterized Builds** | Pass variables to builds (like environment names) |

---

### Jenkins vs. Other CI/CD Tools

| Tool | Type | Best For |
|---|---|---|
| **Jenkins** | Self-hosted, open-source | Full control, large teams, complex pipelines |
| **GitHub Actions** | Cloud-based, built into GitHub | Small-medium projects already on GitHub |
| **GitLab CI/CD** | Built into GitLab | Teams using GitLab |
| **CircleCI** | Cloud-based SaaS | Fast setup, managed infrastructure |
| **Travis CI** | Cloud-based SaaS | Open-source projects |

Jenkins remains the most popular for enterprise environments because of its flexibility and the ability to self-host.

---

## 2. Why Use Docker for Jenkins?

Instead of installing Jenkins directly on your operating system, we will run Jenkins inside a **Docker container**.

### Direct Installation vs Docker

| Aspect | Direct Installation | Docker |
|---|---|---|
| Setup time | 15–30 minutes, multiple steps | 2 minutes, one command |
| Dependencies | Java must be installed separately | All dependencies bundled inside image |
| Conflicts | May conflict with existing software | Completely isolated environment |
| Removal | Complex uninstall process | One command: `docker rm` |
| Portability | Tied to your machine | Same setup on any machine |
| Reproducibility | "Works on my machine" problem | Identical environment everywhere |

### How Docker Containers Work (Key Concept)

```
┌─────────────────────────────────────────────────┐
│                 YOUR COMPUTER                   │
│                                                 │
│   ┌─────────────────────────────────────────┐   │
│   │         DOCKER ENGINE                   │   │
│   │                                         │   │
│   │   ┌──────────────────────────────────┐  │   │
│   │   │     JENKINS CONTAINER            │  │   │
│   │   │                                  │  │   │
│   │   │   Linux OS (Debian)              │  │   │
│   │   │   Java Runtime Environment       │  │   │
│   │   │   Jenkins Application            │  │   │
│   │   │   Jenkins Home Directory         │  │   │
│   │   │                                  │  │   │
│   │   │   Port 8080 → Web Dashboard      │  │   │
│   │   │   Port 50000 → Agent Comm.       │  │   │
│   │   └──────────────────────────────────┘  │   │
│   └─────────────────────────────────────────┘   │
│                                                 │
│   Your Windows / macOS system stays clean!      │
└─────────────────────────────────────────────────┘
```

> **Important:** The Jenkins container runs **Linux internally**, even if your host machine is Windows. This is why we use Linux shell commands (`echo`, `sleep`, `python3`) instead of Windows commands (`echo`, `timeout`, `python`) inside Jenkins.

---

## 3. Prerequisites

Before starting the lab, ensure the following are ready:

### System Requirements

| Requirement | Minimum |
|---|---|
| Operating System | Windows 10/11 (64-bit), macOS 10.15+, or Ubuntu 20.04+ |
| RAM | 4 GB (8 GB recommended) |
| Disk Space | 10 GB free |
| Virtualization | Must be enabled in BIOS (for Windows) |

### Software to Install

1. **Docker Desktop**
   - Download from: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
   - Verify installation: Open terminal and run `docker --version`
   - You should see something like: `Docker version 24.x.x`

2. **A Web Browser**
   - Chrome, Firefox, or Edge (for accessing Jenkins dashboard)

3. **Git** (for Program 4 — GitHub integration)
   - Download from: [https://git-scm.com](https://git-scm.com)

---

## 4. Step-by-Step Jenkins Installation Using Docker

### Step 1: Start Docker Desktop

- Open **Docker Desktop** application
- Wait until the bottom-left shows: ✅ **"Docker is running"**
- Do not proceed until Docker is fully started

### Step 2: Pull Jenkins Docker Image

Open **Command Prompt** or **PowerShell** and run:

```bash
docker pull jenkins/jenkins:lts
```

**What this does:**
- `jenkins/jenkins` → The official Jenkins image from Docker Hub
- `lts` → Long Term Support version (stable, recommended for production)
- Docker downloads all the necessary files (about 460 MB)

**Expected output:**
```
lts: Pulling from jenkins/jenkins
...
Status: Downloaded newer image for jenkins/jenkins:lts
```

### Step 3: Run Jenkins Container

```bash
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins-container jenkins/jenkins:lts
```

**Explanation of each part:**

| Flag | Meaning |
|---|---|
| `-d` | Detached mode — runs in background, you keep your terminal |
| `-p 8080:8080` | Maps container port 8080 to host port 8080 (Jenkins web UI) |
| `-p 50000:50000` | Maps port 50000 for Jenkins agent communication |
| `--name jenkins-container` | Names the container for easy reference |
| `jenkins/jenkins:lts` | The Docker image to use |

### Step 4: Check Running Container

```bash
docker ps
```

**Expected output:**

```
CONTAINER ID   IMAGE                 COMMAND                  CREATED         STATUS         PORTS                                              NAMES
a1b2c3d4e5f6   jenkins/jenkins:lts   "/usr/bin/tini -- /u…"   2 minutes ago   Up 2 minutes   0.0.0.0:8080->8080/tcp, 0.0.0.0:50000->50000/tcp   jenkins-container
```

Look for:
- ✅ `STATUS = Up`
- ✅ `PORTS = 0.0.0.0:8080->8080/tcp`

### Step 5: Open Jenkins in Browser

Navigate to:

```
http://localhost:8080
```

Jenkins will display an **"Unlock Jenkins"** screen and ask for a password.

### Step 6: Get the Initial Admin Password

Run this command in your terminal (on your **host machine**, not inside the container):

```bash
docker exec jenkins-container cat /var/jenkins_home/secrets/initialAdminPassword
```

**Expected output:**
```
e7a8c9d1a2b3c4d5e6f7a8b9c0d1e2f3
```

Copy this password → paste it in the Jenkins browser page.

> **Alternative method** if the above doesn't work:
> ```bash
> docker logs jenkins-container
> ```
> Scroll up in the output to find the password printed between two rows of asterisks (`*`).

### Step 7: Install Suggested Plugins

- Click **"Install Suggested Plugins"**
- Jenkins will automatically install ~20 commonly used plugins
- Wait 5–10 minutes for installation to complete

### Step 8: Create Admin User

Fill in the form:
- **Username:** your choice (e.g., `admin`)
- **Password:** choose a strong password
- **Email:** your email address

Click **"Save and Continue"**

### Step 9: Configure Jenkins URL

- Leave the default URL as `http://localhost:8080/`
- Click **"Save and Finish"**

### Step 10: Start Using Jenkins

Click **"Start using Jenkins"**

🎉 **The Jenkins dashboard is now open!**

---

## 5. Demonstration Programs

> **Teaching Flow:**
> 1. Explain the concept (5 min)
> 2. Live demo by instructor (10 min)
> 3. Students replicate independently (15 min)
> 4. Discuss output and viva questions (5 min)

---

### Program 1: Hello World Job

**Goal:** Understand how Jenkins executes a simple command and view the output.

**Concept:** Jenkins acts as a task executor — it runs commands automatically, just like a terminal, but triggered on demand or on a schedule.

#### Steps

**Step 1: Create a New Job**

1. From the Jenkins Dashboard, click **"New Item"**
2. Enter name: `HelloWorldJob`
3. Select **"Freestyle Project"**
4. Click **"OK"**

**Step 2: Configure the Build Step**

1. Scroll down to the **"Build Steps"** section
2. Click **"Add build step"**
3. Select **"Execute shell"** ⚠️ (NOT "Execute Windows batch command" — Jenkins runs Linux inside Docker)

**Step 3: Write the Commands**

```bash
echo "Hello Students!"
echo "Welcome to Jenkins Automation"
echo "This message was printed by Jenkins automatically."
```

**Step 4: Save and Run**

1. Click **"Save"**
2. Click **"Build Now"** (left sidebar)

**Step 5: View the Output**

1. In the **"Build History"** section (bottom-left), click on **#1**
2. Click **"Console Output"**

**Expected Output:**

```
Started by user admin
Running as SYSTEM
Building in workspace /var/jenkins_home/workspace/HelloWorldJob
[HelloWorldJob] $ /bin/sh -xe /tmp/jenkins...sh
+ echo 'Hello Students!'
Hello Students!
+ echo 'Welcome to Jenkins Automation'
Welcome to Jenkins Automation
+ echo 'This message was printed by Jenkins automatically.'
This message was printed by Jenkins automatically.
Finished: SUCCESS
```

#### Key Concepts

- The `+` before each line shows Jenkins is executing that command
- `Finished: SUCCESS` (green) = job completed without errors
- `Finished: FAILURE` (red) = something went wrong — always check Console Output to debug

---

### Program 2: Simulating a Build Process

**Goal:** Show how Jenkins simulates a real-world build pipeline with timed steps.

**Concept:** In real projects, builds take time — compiling thousands of files, running database migrations, packaging artifacts. `sleep` simulates this time delay so students can observe the execution flow.

#### Steps

**Step 1: Create New Job**

- Name: `BuildSimulation`
- Type: Freestyle Project

**Step 2: Add Build Step → Execute shell**

```bash
echo "==============================="
echo "   BUILD PROCESS STARTING..."
echo "==============================="
echo ""
echo "[Step 1] Fetching latest source code..."
sleep 2
echo "         Done. ✓"

echo "[Step 2] Compiling source code..."
sleep 3
echo "         Done. ✓"

echo "[Step 3] Running unit tests..."
sleep 2
echo "         All 12 tests passed. ✓"

echo "[Step 4] Packaging application..."
sleep 2
echo "         Package created: app-v1.0.jar ✓"

echo ""
echo "==============================="
echo "   BUILD SUCCESSFUL! ✓"
echo "==============================="
```

**Expected Console Output:**

```
[Step 1] Fetching latest source code...
         Done. ✓
[Step 2] Compiling source code...
         Done. ✓
[Step 3] Running unit tests...
         All 12 tests passed. ✓
[Step 4] Packaging application...
         Package created: app-v1.0.jar ✓

===============================
   BUILD SUCCESSFUL! ✓
===============================
Finished: SUCCESS
```

> **Classroom Note:** Use `sleep` (Linux) inside Docker-Jenkins. Do NOT use `timeout /t` — that is a Windows command and will fail.

---

### Program 3: Running a Python Script via Jenkins

**Goal:** Show that Jenkins can execute real programming languages and scripts.

**Concept:** Jenkins is not limited to shell commands. It can run Python, Node.js, Maven, Gradle — any tool installed in the environment.

> **Important:** The Jenkins Docker container does not have Python installed by default. Follow the setup steps below before running the job.

#### Setup — Install Python Inside Jenkins Container

**Step 1: Enter the container as root user**

Run on your **host machine terminal** (PowerShell / CMD):

```bash
docker exec -u 0 -it jenkins-container bash
```

The `-u 0` flag logs you in as the **root user** (required to install packages).

**Step 2: Update package list and install Python**

Inside the container:

```bash
apt update
apt install -y python3
```

**Step 3: Verify installation**

```bash
python3 --version
```

Expected: `Python 3.x.x`

**Step 4: Exit the container**

```bash
exit
```

#### Create the Jenkins Job

**Step 1: Create New Job**

- Name: `PythonJob`
- Type: Freestyle Project

**Step 2: Add Build Step → Execute shell**

```bash
# Create the Python file inside Jenkins workspace
cat > hello.py << 'EOF'
print("=" * 40)
print("  Hello from Python via Jenkins!")
print("  Python is working inside Docker.")
print("=" * 40)

numbers = [1, 2, 3, 4, 5]
total = sum(numbers)
print(f"  Sum of {numbers} = {total}")
EOF

# Run the Python file
python3 hello.py
```

**Expected Console Output:**

```
========================================
  Hello from Python via Jenkins!
  Python is working inside Docker.
========================================
  Sum of [1, 2, 3, 4, 5] = 15
Finished: SUCCESS
```

> **Why create the file in the build step?** The Jenkins container has its own isolated filesystem. Files on your Windows Desktop are not accessible inside the container. By creating the file within the build step itself, we ensure it exists in the Jenkins workspace.

> **Why `python3` and not `python`?** In modern Linux systems, `python` may point to Python 2 (deprecated). Always use `python3` to explicitly use Python 3.

---

### Program 4: Jenkins + GitHub Integration (Basic CI)

**Goal:** Demonstrate real Continuous Integration — Jenkins automatically pulls code from GitHub and runs it.

**Concept:** This is the most important concept in CI/CD. Developers push code to GitHub; Jenkins automatically detects it, pulls the code, and executes it — without any manual trigger.

#### Setup — Create a GitHub Repository

**Step 1:** Go to [https://github.com](https://github.com) and create a new repository
- Repository name: `jenkins-demo`
- Make it **Public**
- Add a README file

**Step 2:** Create a file named `app.py` in the repository:

```python
print("=" * 40)
print("  CI/CD Pipeline is Working!")
print("  Code pulled from GitHub by Jenkins.")
print("=" * 40)
```

#### Configure Jenkins Job

**Step 1: Create New Job**

- Name: `GitHubIntegrationJob`
- Type: Freestyle Project

**Step 2: Configure Source Code Management**

1. Scroll to **"Source Code Management"**
2. Select **"Git"**
3. Enter your repository URL:
   ```
   https://github.com/YOUR_USERNAME/jenkins-demo.git
   ```
4. Leave Branch as `*/main` (or `*/master` depending on your repo)

**Step 3: Add Build Step → Execute shell**

```bash
echo "Jenkins has pulled the latest code from GitHub!"
echo ""
echo "Files in workspace:"
ls -la
echo ""
echo "Running the application..."
python3 app.py
```

**Step 4: Build Now**

Jenkins will:
1. Connect to GitHub
2. Clone/pull the repository into its workspace
3. List the files
4. Execute `app.py`

**Expected Console Output:**

```
Cloning the remote Git repository
Cloning repository https://github.com/YOUR_USERNAME/jenkins-demo.git

Jenkins has pulled the latest code from GitHub!

Files in workspace:
total 16
drwxr-xr-x 3 jenkins jenkins 4096 Jan 01 10:00 .
drwxr-xr-x 8 jenkins jenkins 4096 Jan 01 10:00 ..
-rw-r--r-- 1 jenkins jenkins  142 Jan 01 10:00 app.py
-rw-r--r-- 1 jenkins jenkins   48 Jan 01 10:00 README.md

Running the application...
========================================
  CI/CD Pipeline is Working!
  Code pulled from GitHub by Jenkins.
========================================
Finished: SUCCESS
```

> **This is CI in action.** Now, every time you push a change to GitHub and click "Build Now" in Jenkins (or configure an automatic trigger), Jenkins will pull the latest code and run it.

---

### Program 5: First Jenkins Pipeline (Most Important)

**Goal:** Introduce Declarative Pipelines — the modern, industry-standard way to define Jenkins automation.

**Concept:** A Pipeline is a script (called a `Jenkinsfile`) that describes your entire CI/CD process as code. This means your automation logic lives in your repository alongside your application code.

#### Create a Pipeline Job

**Step 1: Create New Item**

- Name: `MyFirstPipeline`
- Select **"Pipeline"** (NOT Freestyle Project)
- Click **"OK"**

**Step 2: Add Pipeline Script**

Scroll to the **"Pipeline"** section. Select **"Pipeline script"** and enter:

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Stage 1: Building the project...'
                echo 'Compiling source code...'
                sh 'sleep 1'
                echo 'Build complete!'
            }
        }

        stage('Test') {
            steps {
                echo 'Stage 2: Running automated tests...'
                sh 'sleep 1'
                echo 'All tests passed!'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Stage 3: Deploying to server...'
                sh 'sleep 1'
                echo 'Deployment successful!'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed! Check the logs.'
        }
    }
}
```

**Step 3: Save and Build Now**

**Expected Console Output:**

```
[Pipeline] Start of Pipeline
[Pipeline] node
[Pipeline] stage (Build)
[Pipeline] echo: Stage 1: Building the project...
[Pipeline] echo: Compiling source code...
[Pipeline] echo: Build complete!
[Pipeline] stage (Test)
[Pipeline] echo: Stage 2: Running automated tests...
[Pipeline] echo: All tests passed!
[Pipeline] stage (Deploy)
[Pipeline] echo: Stage 3: Deploying to server...
[Pipeline] echo: Deployment successful!
[Pipeline] post
[Pipeline] echo: Pipeline completed successfully!
Finished: SUCCESS
```

You will also see a **Stage View** at the top of the job page showing colorful boxes for Build → Test → Deploy. ✅✅✅

#### Understanding the Pipeline Script

```
pipeline { ... }           → Defines the entire pipeline block

    agent any              → Run on any available agent (machine)

    stages { ... }         → Container for all stages

        stage('Build') {   → A single named stage
            steps { ... }  → Commands to execute in this stage
        }

    post { ... }           → Actions after pipeline finishes
        success { ... }    → Only runs if pipeline succeeded
        failure { ... }    → Only runs if pipeline failed
```

---

### Program 6: Pipeline with Real Shell Commands

**Goal:** Combine pipeline stages with actual shell commands for a more realistic demonstration.

```groovy
pipeline {
    agent any

    stages {
        stage('Environment Info') {
            steps {
                echo 'Gathering system information...'
                sh 'echo "Hostname: $(hostname)"'
                sh 'echo "Current user: $(whoami)"'
                sh 'echo "Working directory: $(pwd)"'
                sh 'date'
            }
        }

        stage('Create Files') {
            steps {
                echo 'Creating project files...'
                sh 'echo "Version 1.0" > version.txt'
                sh 'echo "Build successful" > build-status.txt'
                sh 'ls -la'
            }
        }

        stage('Read and Display Files') {
            steps {
                echo 'Reading created files...'
                sh 'cat version.txt'
                sh 'cat build-status.txt'
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Cleaning up workspace...'
                sh 'rm -f version.txt build-status.txt'
                echo 'Cleanup done.'
            }
        }
    }
}
```

---

## 6. Key Commands Summary

### Docker Commands for Jenkins

```bash
# Pull the Jenkins image
docker pull jenkins/jenkins:lts

# Start Jenkins container
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins-container jenkins/jenkins:lts

# Check running containers
docker ps

# Get the initial admin password
docker exec jenkins-container cat /var/jenkins_home/secrets/initialAdminPassword

# View Jenkins logs (alternative way to find password)
docker logs jenkins-container

# Stop Jenkins container
docker stop jenkins-container

# Start existing container again
docker start jenkins-container

# Remove container (CAREFUL: this deletes all data)
docker rm jenkins-container

# Enter container shell as Jenkins user
docker exec -it jenkins-container bash

# Enter container shell as ROOT user (for installing packages)
docker exec -u 0 -it jenkins-container bash
```

### Linux Commands Used Inside Jenkins

```bash
echo "message"      # Print text to console
sleep 3             # Pause for 3 seconds
pwd                 # Print current directory
ls -la              # List all files with details
cat filename        # Print file contents
python3 script.py   # Run a Python script
hostname            # Show machine name
whoami              # Show current user
date                # Show current date and time
```

---

## 7. Common Errors & Fixes

### Error 1: `/bin/sh: 1: cmd: not found`

**Cause:** You selected "Execute Windows batch command" instead of "Execute shell"

**Fix:** Edit the job → Remove the Windows batch step → Add "Execute shell" step

**Rule:** Jenkins runs Linux inside Docker. Always use **Execute shell** and Linux commands.

---

### Error 2: `docker: not found` (when inside container)

**Cause:** You tried to run `docker` commands inside the Jenkins container

**Fix:** `exit` the container first, then run Docker commands on your **host machine terminal**

**Rule:** Docker commands always run on the host, not inside a container.

---

### Error 3: `python3: command not found`

**Cause:** Python is not installed inside the Jenkins container

**Fix:**
```bash
docker exec -u 0 -it jenkins-container bash
apt update
apt install -y python3
exit
```

---

### Error 4: `Permission denied` when running `apt update`

**Cause:** You entered the container as the `jenkins` user (non-root), who cannot install packages

**Fix:** Use `-u 0` to enter as root:
```bash
docker exec -u 0 -it jenkins-container bash
```

---

### Error 5: `No such file or directory` for scripts

**Cause:** The file exists on your Windows system but Jenkins cannot access it — the container has its own separate filesystem

**Fix:** Create the file inside the Jenkins build step using:
```bash
cat > hello.py << 'EOF'
print("Hello!")
EOF
python3 hello.py
```

---

### Error 6: Port 8080 already in use

**Cause:** Another application is using port 8080

**Fix:** Use a different port mapping:
```bash
docker run -d -p 9090:8080 -p 50000:50000 --name jenkins-container jenkins/jenkins:lts
```

Then access Jenkins at `http://localhost:9090`

---

### Quick Debugging Rule

> **"When Jenkins fails, always click on the build number and open Console Output. The error message is always there."**

---

## 8. Viva Questions

### Conceptual Questions

1. **What is Jenkins and what problem does it solve?**
   > Jenkins is an open-source automation server that automates the build, test, and deployment process, eliminating the need for manual, repetitive tasks in software development.

2. **What is CI/CD? Explain both terms.**
   > Continuous Integration (CI) is the practice of automatically building and testing code every time a developer pushes changes. Continuous Deployment (CD) is automatically deploying the application after successful testing.

3. **What is a Jenkins Pipeline?**
   > A Pipeline is a series of automated steps written as code (in a Groovy script) that defines the entire CI/CD process — build, test, deploy — in a structured, version-controlled way.

4. **What is the difference between a Freestyle Job and a Pipeline?**
   > Freestyle jobs are configured through the UI (clicking and filling forms). Pipelines are defined as code in a Jenkinsfile, which can be version-controlled in Git alongside application code.

5. **What is the difference between Jenkins Master and Agent?**
   > The Master (Controller) manages the dashboard, schedules jobs, and distributes work. Agents (Workers) are machines that actually execute the build/test/deploy steps.

### Technical Questions

6. **What is the default port for Jenkins?**
   > Port **8080**

7. **Why do we use Docker to run Jenkins?**
   > Docker provides easy setup, isolated environment, no dependency conflicts, and easy removal — making Jenkins portable and reproducible.

8. **Why must we use `Execute shell` instead of `Execute Windows batch command` in our Jenkins setup?**
   > Because our Jenkins runs inside a Linux Docker container. Windows batch commands (`cmd.exe`) do not exist in Linux.

9. **Why do we need to enter the container as root (`-u 0`) to install Python?**
   > Jenkins runs as a non-root user inside the container for security reasons. Installing packages requires root (administrator) privileges.

10. **Why can't Jenkins (inside Docker) access files from your Windows Desktop directly?**
    > Docker containers have their own isolated filesystem, completely separate from the host machine. Files must be mounted using Docker volumes or created inside the container.

11. **What happens when you click "Build Now" in Jenkins?**
    > Jenkins creates a new build entry, executes all configured build steps in sequence, records the console output, and marks the build as SUCCESS or FAILURE based on the exit code.

12. **What is a Jenkinsfile?**
    > A Jenkinsfile is a text file that contains the definition of a Jenkins Pipeline written in Groovy DSL. It is typically stored in the root of the project's Git repository.

---

## Teaching Plan

| Time | Activity |
|---|---|
| 0–10 min | Explain concepts: Jenkins, CI/CD, Architecture |
| 10–15 min | Show diagrams, answer concept questions |
| 15–35 min | Live demo: Installation + Programs 1 & 2 |
| 35–55 min | Live demo: Programs 3–5 (Python, GitHub, Pipeline) |
| 55–80 min | Students perform independently |
| 80–90 min | Viva questions, troubleshoot common errors |

**Pro Tip:** Walk around while students are working. The most common issues are:
- Selecting "Windows batch command" instead of "Execute shell"
- Running Docker commands inside the container
- Python not installed — guide them through the `apt install` process

---

*Jenkins Lab Guide — For Classroom Use*
