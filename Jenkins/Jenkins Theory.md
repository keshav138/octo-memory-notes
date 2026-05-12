# Jenkins – Complete Theoretical Foundation

Not just "how to click buttons" — understanding **where Jenkins fits in production**, **why it exists**, and **how to think about CI/CD pipelines**.

---

## Part 1: What Jenkins Actually Is

**One sentence**: Jenkins is an automation server that builds, tests, and deploys your code whenever changes happen.

**More accurately**: Jenkins is a workflow orchestration engine that executes a sequence of steps (pipeline) triggered by events (code push, schedule, manual) across multiple environments.

### The Core Problem Jenkins Solves

| Without CI/CD | With Jenkins |
|---------------|--------------|
| "Works on my machine" | Build runs on clean agent every time |
| Manual deployment (forget steps) | Automated, repeatable deployment |
| Test after deploy (or never) | Test before deploy |
| Deploy on Friday → panic | Deploy any time, rollback easily |
| No one knows how to release | Pipeline is code in Git |

---

## Part 2: Jenkins Architecture (Production View)

### Development Environment (What you did in class)

```
Your Laptop (Windows/Mac)
    └── Docker Desktop
        └── Jenkins Container
            └── Jobs/Pipelines run locally
```

This is fine for learning but **never** for production.

### Production Environment (Real World)

```
┌─────────────────────────────────────────────────────────────┐
│                    Production Jenkins Setup                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐     ┌──────────────┐     ┌─────────────┐ │
│  │   Jenkins    │     │   Build      │     │  Deploy     │ │
│  │   Master     │────▶│   Agents     │────▶│  Targets    │ │
│  │  (Controller)│     │  (Workers)   │     │  (AWS/K8s)  │ │
│  └──────────────┘     └──────────────┘     └─────────────┘ │
│         │                    │                    │         │
│         ▼                    ▼                    ▼         │
│  ┌──────────────┐     ┌──────────────┐     ┌─────────────┐ │
│  │  PostgreSQL  │     │  Docker      │     │  EC2, ECS,  │ │
│  │  (metadata)  │     │  (build env) │     │  Beanstalk  │ │
│  └──────────────┘     └──────────────┘     └─────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Key Components in Production

| Component | What It Does | Production Reality |
|-----------|--------------|--------------------|
| **Jenkins Master (Controller)** | Orchestrates jobs, serves UI, stores config | Needs HA (multiple masters) or just highly available single with backup |
| **Jenkins Agents (Nodes/Workers)** | Actually execute build steps | Run on separate VMs/containers, often spot instances for cost |
| **Build Environment** | Where code compiles, tests run | Ephemeral (destroy after each build) for consistency |
| **Artifact Repository** | Stores build outputs (jars, Docker images) | S3, Artifactory, Nexus, ECR |
| **Metadata Store** | Jenkins config, job history, credentials | PostgreSQL (external DB, not H2 embedded) |

### Where Jenkins Sits in Production Pipeline

```
Developer Push to GitHub
         │
         ▼
    GitHub Webhook ─────────────────────┐
         │                               │
         ▼                               ▼
    Jenkins Master ─────────────▶  (Triggers Pipeline)
         │
         ├──▶ Agent 1: Checkout code
         ├──▶ Agent 2: Run unit tests
         ├──▶ Agent 3: Build Docker image
         ├──▶ Agent 4: Push to ECR
         ├──▶ Agent 5: Deploy to Staging
         ├──▶ Agent 6: Run integration tests
         ├──▶ Agent 7: Deploy to Production (if tests pass)
         │
         ▼
    Notifications (Slack, Email) ───▶ Team
```

---

## Part 3: Jenkins vs Modern CI/CD Tools

Where Jenkins stands in 2024:

| Tool | Type | Jenkins Still Wins | Jenkins Loses |
|------|------|--------------------|----------------|
| **GitHub Actions** | Cloud-native CI | Custom plugins, complex workflows, non-GitHub repos | Simplicity, GitHub integration, no server management |
| **GitLab CI** | Integrated | Heterogeneous environments, legacy setups | GitLab ecosystem, simpler YAML |
| **CircleCI** | Cloud/SaaS | Self-hosted requirement, compliance | Developer experience, speed |
| **Azure Pipelines** | Cloud | Multi-cloud, custom plugins | Microsoft ecosystem |
| **Bamboo** | Atlassian | Jenkins is free, more plugins | Jira integration |

**When to choose Jenkins in 2024**:
- You have complex, custom build processes
- You need complete control over agents (security, compliance)
- You have existing investment in Jenkins plugins
- You're running on-prem or air-gapped environments
- You need to support legacy build systems

**When NOT to choose Jenkins**:
- Starting new project from scratch
- Small team without DevOps focus
- Everything already in GitHub/GitLab

---

## Part 4: Jenkins Pipeline Fundamentals

### Two Types of Pipelines

| Aspect | Declarative Pipeline | Scripted Pipeline |
|--------|---------------------|-------------------|
| Syntax | Structured, simpler | Groovy-based, flexible |
| Learning curve | Easier | Steeper |
| Best for | Most use cases | Complex custom logic |
| Example | `pipeline { agent any; stages { stage('Build') { ... } } }` | `node { stage('Build') { ... } }` |

### Declarative Pipeline Structure (The One You'll Use 90% of time)

```groovy
pipeline {
    // Where to run this pipeline
    agent any  // or 'docker', 'kubernetes', 'label', 'none'
    
    // Environment variables available to all stages
    environment {
        APP_NAME = 'my-flask-app'
        AWS_REGION = 'us-east-1'
    }
    
    // Parameters for manual builds
    parameters {
        string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: 'Environment to deploy')
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run integration tests')
    }
    
    // Triggers for automatic runs
    triggers {
        cron('H 2 * * *')  // Daily at 2 AM
        pollSCM('* * * * *')  // Poll Git every minute (not recommended)
        // Better: GitHub webhook triggers via plugin
    }
    
    // Stages run sequentially
    stages {
        stage('Checkout') {
            steps {
                checkout scm  // Pull from Git
            }
        }
        
        stage('Build') {
            steps {
                sh 'docker build -t my-app .'
            }
        }
        
        stage('Test') {
            parallel {
                stage('Unit Tests') {
                    steps { sh 'pytest tests/unit' }
                }
                stage('Lint') {
                    steps { sh 'flake8 app/' }
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'main'  // Only deploy from main branch
            }
            steps {
                sh 'deploy-to-staging.sh'
            }
        }
        
        stage('Integration Tests') {
            steps {
                sh 'run-tests-against-staging.sh'
            }
        }
        
        stage('Deploy to Production') {
            when {
                expression { params.DEPLOY_ENV == 'production' }
            }
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
                sh 'deploy-to-production.sh'
            }
        }
    }
    
    // Always run after pipeline finishes
    post {
        success {
            slackSend(message: "Pipeline succeeded: ${env.JOB_NAME} - ${env.BUILD_NUMBER}")
        }
        failure {
            email(to: 'team@company.com', subject: "Build failed!", body: "Check ${env.BUILD_URL}")
        }
        always {
            cleanWs()  // Clean workspace
        }
    }
}
```

### The Agent Concept (Critical for Production)

**Agent types**:

| Agent Type | When to Use | Production Setup |
|------------|-------------|------------------|
| `agent any` | Learning, simple jobs | Never (unpredictable) |
| `agent { label 'docker' }` | Builds needing Docker | Agents labeled by capability |
| `agent { docker { image 'python:3.9' } }` | Isolated, reproducible builds | Most common for containerized pipelines |
| `agent { kubernetes { yaml '...' } }` | Dynamic pod per stage | Cloud-native Jenkins |
| `agent none` | Different agent per stage | Complex pipelines |

**Production best practice**:
- Master runs NO builds (set `executors = 0`)
- Dedicated agents for different workload types
- Ephemeral agents (destroy after each job)
- Spot instances for non-critical builds

---

## Part 5: Where Jenkins Sits in Your Development Workflow

### Full Production Flow (With All Pieces)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         COMPLETE PRODUCTION PIPELINE                     │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  DEVELOPER                    CI/CD                     INFRASTRUCTURE  │
│  ─────────                    ────                     ──────────────   │
│                                                                          │
│  Write code ──▶ Git push ──▶ GitHub ──┬─▶ Jenkins                        │
│      ▲                    (webhook)   │      │                           │
│      │                                │      ▼                           │
│      │                                │  ┌────────────┐                  │
│      │                                │  │ 1. Checkout│                  │
│      │                                │  │ 2. Lint    │                  │
│      │                                │  │ 3. Unit    │──▶ Artifacts    │
│      │                                │  │    Tests   │                  │
│      │                                │  └────────────┘                  │
│      │                                │      │                           │
│      │                                │      ▼                           │
│      │                                │  ┌────────────┐                  │
│      │                                │  │ 4. Build   │                  │
│      │                                │  │    Docker  │──▶ ECR/Registry │
│      │                                │  └────────────┘                  │
│      │                                │      │                           │
│      │                                │      ▼                           │
│      │ Notifications (Slack) ◀────────┤ 5. Deploy   ◀─── Terraform      │
│      │                                │    Staging      (Infra as Code)  │
│      │                                │      │                           │
│      │                                │      ▼                           │
│      │                                │ 6. Integration Tests             │
│      │                                │      │                           │
│      │                                │      ▼                           │
│      │                    (Manual approval)                              │
│      │                                │      │                           │
│      │                                │      ▼                           │
│      │                                │ 7. Deploy Production             │
│      │                                │      │                           │
│      │                                │      ▼                           │
│      └────────────────────────────────┘  Smoke Tests                     │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### Where Jenkins Runs in Different Environments

| Environment | Jenkins Location | Why |
|-------------|------------------|-----|
| **Local Dev** | Docker on laptop | Experimentation, debugging pipelines |
| **Development CI** | Small VM (t3.medium) | Quick feedback, no critical data |
| **Staging CI** | Larger VM (t3.large) | More thorough testing, longer runs |
| **Production CI** | Multi-master + 10+ agents | High availability, security compliance |
| **On-Prem Enterprise** | Dedicated racks | Air-gapped, security requirements |

### Typical Organization Setup (Real Example)

```
┌────────────────────────────────────────────────────────────────┐
│                         COMPANY NETWORK                         │
├────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐      │
│  │ Management  │     │  Build      │     │  Production │      │
│  │ Network     │     │  Network    │     │  Network    │      │
│  │             │     │             │     │             │      │
│  │ Jenkins     │     │ Jenkins     │     │ AWS Account │      │
│  │ Master      │────▶│ Agents      │────▶│ (Prod)      │      │
│  │ (t3.large)  │     │ (Spot fleet)│     │             │      │
│  └─────────────┘     └─────────────┘     └─────────────┘      │
│         │                    │                    │            │
│         ▼                    ▼                    ▼            │
│  ┌─────────────┐     ┌─────────────┐     ┌─────────────┐      │
│  │  Secrets    │     │  Artifact   │     │  Monitoring │      │
│  │  (Vault)    │     │  (Nexus)    │     │  (CloudWatch)│      │
│  └─────────────┘     └─────────────┘     └─────────────┘      │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

---

## Part 6: Jenkins Credentials & Security (Production Critical)

### Where Secrets Live

| Secret Type | Storage Location | In Pipeline Reference |
|-------------|------------------|----------------------|
| Git passwords/tokens | Jenkins Credentials Store | `git credentialsId: 'github-token'` |
| AWS access keys | Jenkins Credentials Store | `withAWS(credentials: 'aws-key')` |
| Docker registry passwords | Jenkins Credentials Store | `docker.withRegistry(..., 'docker-hub')` |
| API keys (3rd party) | HashiCorp Vault (external) | `withVault(...)` |
| Database passwords | AWS Secrets Manager | `aws secretsmanager get-secret-value` |

### Credentials in Pipeline (Best Practice)

```groovy
pipeline {
    environment {
        // Pull from Jenkins credentials store
        DOCKER_REGISTRY = credentials('docker-registry-creds')
        AWS_ACCOUNT = credentials('aws-account-id')
    }
    
    stages {
        stage('Deploy to AWS') {
            steps {
                withAWS(region: 'us-east-1', credentials: 'aws-key') {
                    sh 'aws ecs update-service ...'
                }
            }
        }
        
        stage('Access Database') {
            steps {
                // Pull from AWS Secrets Manager at runtime
                script {
                    def dbSecret = sh(script: 'aws secretsmanager get-secret-value --secret-id flask/db --query SecretString --output text', returnStdout: true).trim()
                    // Use dbSecret in deployment
                }
            }
        }
    }
}
```

**NEVER**:
- Hardcode secrets in Jenkinsfile
- Print secrets in logs (`sh 'set -x'` is dangerous)
- Commit secrets to Git

---

## Part 7: Jenkins Pipeline Triggers (Production)

### Trigger Methods

| Trigger | When to Use | Production Example |
|---------|-------------|-------------------|
| **GitHub webhook** | Push to branch | `main` branch → deploy to staging |
| **Pull Request** | Code review | PR opened → run tests, comment results |
| **Schedule (cron)** | Nightly builds | Daily security scan, database backups |
| **Manual (with parameters)** | Production deploys | Choose environment, version, features |
| **Upstream job** | Dependent pipelines | Build image → trigger deploy pipeline |
| **Generic webhook** | External events | Chat bot, monitoring alert, Jira transition |

### Webhook Setup in Production

```
GitHub Repository
    │
    │ (Settings → Webhooks)
    │ Payload URL: https://jenkins.company.com/github-webhook/
    │ Content type: application/json
    │ Events: Push, Pull Request
    │
    ▼
Jenkins (with GitHub Plugin)
    │
    │ Checks: Is this branch/PR configured?
    │
    ▼
Pipeline execution
```

---

## Part 8: Blue-Green & Canary Deployments with Jenkins

### What These Mean (For Your Interview)

| Strategy | What Happens | Rollback | Jenkins Role |
|----------|--------------|----------|--------------|
| **Blue-Green** | Two identical environments (Blue = live, Green = new). Switch traffic when ready. | Instant (switch back) | Jenkins triggers switch via load balancer |
| **Canary** | Deploy to 5% of users, monitor, then 50%, then 100% | Gradual | Jenkins gradually increases traffic weight |
| **Rolling** | Replace instances one by one | Slow | Jenkins triggers instance rotations |
| **Feature Flags** | Deploy code behind toggle, enable later | Instant (flip toggle) | Jenkins just deploys, app toggles (not Jenkins concern) |

### Blue-Green Pipeline (Production Pattern)

```groovy
pipeline {
    stages {
        stage('Deploy to Green') {
            steps {
                sh 'terraform apply -target=aws_lb_listener.green'
                sh './run-smoke-tests.sh green'
            }
        }
        
        stage('Switch Traffic') {
            input { message: 'Switch from Blue to Green?' }
            steps {
                // Update load balancer listener rules
                sh './switch-to-green.sh'
            }
        }
        
        stage('Destroy Blue') {
            steps {
                // Keep for 24 hours for rollback
                sh './maintain-blue-for-rollback.sh'
            }
        }
    }
}
```

---

## Part 9: Jenkins Shared Libraries (DRY for Pipelilnes)

### The Problem

Without shared libraries, you copy-paste this across 50 repos:

```groovy
stage('Build Docker Image') {
    sh 'docker build -t my-app .'
    sh 'docker tag my-app ecr/my-app:${BUILD_NUMBER}'
    sh 'docker push ecr/my-app:${BUILD_NUMBER}'
}
```

### The Solution (Shared Library)

`vars/flaskPipeline.groovy`:
```groovy
def buildAndPush(imageName) {
    sh """
        docker build -t ${imageName}:${env.BUILD_NUMBER} .
        docker tag ${imageName}:${env.BUILD_NUMBER} ${imageName}:latest
        docker push ${imageName}:${env.BUILD_NUMBER}
    """
}

def deployTo(environment, region) {
    sh """
        aws ecs update-service --cluster flask-${environment} --service flask-app --region ${region}
    """
}
```

Then in any Jenkinsfile:
```groovy
@Library('my-jenkins-lib') _

pipeline {
    stages {
        stage('Build') {
            steps {
                flaskPipeline.buildAndPush('my-flask-app')
            }
        }
        stage('Deploy') {
            steps {
                flaskPipeline.deployTo('staging', 'us-east-1')
            }
        }
    }
}
```

---

## Part 10: Jenkins in Production – Operational Realities

### What You Must Handle

| Concern | Production Solution |
|---------|---------------------|
| **Master downtime** | Multi-master or automated backups + restore procedure |
| **Lost build history** | Backup Jenkins home (config, jobs, logs) to S3 regularly |
| **Agent failures** | Auto-scaling agent pool, retry logic in pipeline |
| **Plugins breaking** | Test plugin upgrades on staging Jenkins, use Plugin Manager |
| **Hung builds** | Timeout each stage (`options { timeout(time: 1, unit: 'HOURS') }`) |
| **Resource exhaustion** | Limit concurrent jobs per agent, use quotas |
| **Security** | Run agents as non-root, network isolation, secrets encryption |

### Backup Strategy (Production Must-Have)

```bash
# Backup script (runs daily via cron)
#!/bin/bash
BACKUP_FILE="jenkins-backup-$(date +%Y%m%d).tar.gz"

# Backup Jenkins home (excludes workspaces, logs)
tar -czf $BACKUP_FILE \
    --exclude='workspace' \
    --exclude='logs' \
    --exclude='caches' \
    /var/jenkins_home

# Upload to S3
aws s3 cp $BACKUP_FILE s3://company-jenkins-backups/

# Keep last 30 daily, last 12 monthly
```

---

## Part 11: Jenkins Pipeline Best Practices (Cheat Sheet)

### Do's

```groovy
// ✅ Use declarative pipeline
pipeline { ... }

// ✅ Set timeout
options { timeout(time: 30, unit: 'MINUTES') }

// ✅ Retry flaky operations
retry(3) { sh 'flaky-command' }

// ✅ Use environment blocks
environment { DOCKER_REGISTRY = credentials('docker-hub') }

// ✅ Clean workspace
post { always { cleanWs() } }

// ✅ Use when conditions
when { branch 'main' }

// ✅ Use tools directive
tools { docker '20.10' }
```

### Don'ts

```groovy
// ❌ Hardcoded paths
sh '/home/user/build.sh'  // Instead: relative paths

// ❌ Long-running stages without timeouts
stage('Deploy') {
    steps { sh 'deploy.sh' }  // Add timeout
}

// ❌ Using agent any in production
agent any  // Instead: agent { label 'docker-linux' }

// ❌ Sensitive data in environment as plain text
environment { PASSWORD = 'hardcoded' }  // Instead: credentials()

// ❌ Disabling SSL verification
sh 'curl -k https://...'  // Instead: fix certificates
```

---

## Part 12: Jenkins + Terraform + Flask (The Integration You're Building Toward)

### The Complete Picture

```
┌─────────────────────────────────────────────────────────────────┐
│                      YOUR JENKINS PIPELINE                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  GitHub Push                                                      │
│      │                                                            │
│      ▼                                                            │
│  Stage 1: Checkout                                               │
│      │                                                            │
│      ▼                                                            │
│  Stage 2: Terraform Plan ◀───────────┐                           │
│      │ (Infrastructure as Code)        │                           │
│      ▼                                │                           │
│  (Manual Approval for Prod) ──────────┘                           │
│      │                                                            │
│      ▼                                                            │
│  Stage 3: Terraform Apply (VPC, EC2, RDS)                        │
│      │                                                            │
│      ▼                                                            │
│  Stage 4: Build Flask Docker Image                               │
│      │                                                            │
│      ▼                                                            │
│  Stage 5: Push to ECR                                            │
│      │                                                            │
│      ▼                                                            │
│  Stage 6: Deploy to EC2/ECS (using Terraform outputs)            │
│      │                                                            │
│      ▼                                                            │
│  Stage 7: Integration Tests                                      │
│      │                                                            │
│      ▼                                                            │
│  Stage 8: Smoke Tests on Production                              │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Why This Matters

| Without Jenkins | With Jenkins |
|-----------------|--------------|
| Run Terraform manually | Automated plan on every PR |
| Forget to run tests | Tests run automatically |
| Deploy Friday night | Deploy any time, any day |
| No rollback plan | Rollback = redeploy previous version |
| Infrastructure drifts | Terraform detects and fixes |

---

## Part 13: Jenkins Glossary (Terms You Must Know)

| Term | Definition |
|------|------------|
| **Job** | A single task (old style, be careful) |
| **Pipeline** | Series of stages defined as code (modern Jenkins) |
| **Stage** | Logical grouping of steps (Build, Test, Deploy) |
| **Step** | Single action (`sh`, `checkout`, `docker.build`) |
| **Agent** | Where pipeline executes (master, node, container) |
| **Node** | Another name for agent (confusing, same thing) |
| **Executor** | Number of concurrent builds on an agent |
| **Workspace** | Directory where code is checked out and builds run |
| **Artifact** | Build output (jar, Docker image, binary) |
| **Trigger** | What starts the pipeline (webhook, cron, manual) |
| **Post-build action** | What runs after pipeline (notify, cleanup) |

---

## Part 14: What You Should Know for Interviews

### Common Questions

**Q: "How do you handle a failing build in Jenkins?"**
A: "Pipeline has `post { failure { ... } }` block to send alerts. We also use `retry` for transient failures, and have manual approval gate for production. The build is configured to stop on first failure, and we can always roll back by redeploying a known good build number."

**Q: "How do you test a Jenkins pipeline change?"**
A: "Use `replay` feature to modify pipeline without committing. Also have a staging Jenkins instance that mirrors production. For shared libraries, we test in separate branch before merging to main."

**Q: "What's the difference between scripted and declarative pipeline?"**
A: "Declarative is simpler with structured syntax, better for most use cases. Scripted offers more flexibility with Groovy but harder to maintain. We use declarative 90% of the time, and fall back to scripted for complex custom logic."

**Q: "How do you secure Jenkins in production?"**
A: "Jenkins master has no executors (only orchestrates). Agents run as non-root in isolated networks. All credentials in Jenkins secret store or Vault. Pipeline logs are sanitized of secrets. HTTPS with valid certificate. Regular plugin updates, no direct internet from master."

---

## Part 15: Your Learning Path After This Theory

```
✅ Theory completed (you are here)
    │
    ├──▶ Hands-on: Run Jenkins on Docker (already did in class)
    │
    ├──▶ Create first pipeline: "Print Hello World"
    │
    ├──▶ Pipeline with Git checkout + Shell commands
    │
    ├──▶ Add testing stage (pytest for Flask)
    │
    ├──▶ Build Docker image in pipeline
    │
    ├──▶ Push to Docker Hub/ECR
    │
    ├──▶ Trigger Terraform from pipeline
    │
    ├──▶ Deploy Flask app using pipeline
    │
    └──▶ Full pipeline: Test → Build → Push → Deploy (all automated)
```

---

## Summary: Jenkins in Production

| Aspect | Key Takeaway |
|--------|--------------|
| **Architecture** | Master orchestrates, agents execute, never build on master |
| **Pipeline type** | Declarative for 90% of cases |
| **Credentials** | Store in Jenkins secret store, never hardcode |
| **Agents** | Ephemeral, labeled by capability, spot for cost |
| **Backup** | Jenkins home backed up regularly (state, config, jobs) |
| **Triggers** | Webhooks for CI, cron for nightly, manual for prod |
| **Integration** | Works with everything (GitHub, AWS, Docker, Terraform) |

**The big picture**: Jenkins is your **automation glue** — it sits between Git and your infrastructure, making sure every code change goes through the same rigorous process before reaching users.

---

Ready for **hands-on Jenkins pipeline coding** (with Flask + Terraform integration)? Or want to drill deeper into any of these theory topics?