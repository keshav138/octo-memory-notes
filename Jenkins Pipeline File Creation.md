# Jenkins Pipeline Scripts – Complete Breakdown

From **basic to advanced**, line by line. No assumptions — I'll explain every single piece.

---

## Part 1: The Two Types of Pipeline Syntax

| Type | Best For | Syntax |
|------|----------|--------|
| **Declarative** | 90% of use cases | Clean, structured, limited Groovy |
| **Scripted** | Complex logic, loops, conditionals | Full Groovy power, more flexible |

**We'll focus on Declarative** (what you'll use 90% of the time)

---

## Part 2: The Basic Structure (Anatomy of a Jenkinsfile)

```groovy
pipeline {                           // REQUIRED: Everything inside this block
    agent any                        // REQUIRED: Where to run this pipeline
    
    stages {                         // REQUIRED: Container for all stage blocks
        stage('Stage Name') {        // Each stage does one logical thing
            steps {                  // REQUIRED: Commands to execute
                echo 'Hello World'   // Actual work
            }
        }
    }
}
```

### The Absolute Minimum Pipeline

```groovy
pipeline {
    agent any
    stages {
        stage('Hello') {
            steps {
                echo 'Hello from Jenkins!'
            }
        }
    }
}
```

**Line by line**:

| Line | Component | What It Does |
|------|-----------|---------------|
| `pipeline {` | Pipeline block | Tells Jenkins this is a declarative pipeline |
| `agent any` | Agent declaration | Run on any available Jenkins agent (master or worker) |
| `stages {` | Stages container | Groups all stages together |
| `stage('Hello') {` | Stage definition | Logical grouping of work (appears in UI as a block) |
| `steps {` | Steps block | Contains actual commands to run |
| `echo 'Hello...'` | Step | Prints message to console log |
| `}` (×4) | Closing braces | Closes blocks in reverse order |

---

## Part 3: Agent Options (Where Code Runs)

### Agent Breakdown

```groovy
pipeline {
    // Option 1: Any available agent
    agent any
    
    // Option 2: Specific label (agent with certain capability)
    agent { label 'docker' }        // Run only on agent labeled 'docker'
    
    // Option 3: Docker container (most common)
    agent {
        docker {
            image 'python:3.9'      // Docker image to use
            args '-v /tmp:/tmp'     // Additional docker arguments
        }
    }
    
    // Option 4: None (declare per stage)
    agent none                      // Each stage defines its own agent
    
    stages {
        stage('Build') {
            agent { label 'linux' } // This stage runs on linux agent
            steps { echo 'Building' }
        }
    }
}
```

### Real Example: Docker Agent for Python

```groovy
pipeline {
    agent {
        docker {
            image 'python:3.9-slim'
            args '-u root'          // Run as root
        }
    }
    stages {
        stage('Check Python Version') {
            steps {
                sh 'python --version'   // Runs inside Python container
            }
        }
    }
}
```

---

## Part 4: Environment Variables

### Setting and Using Variables

```groovy
pipeline {
    agent any
    
    // Environment block: sets variables available to all stages
    environment {
        // Static string
        APP_NAME = 'my-flask-app'
        
        // Credential (from Jenkins credential store)
        DOCKER_CREDS = credentials('docker-hub')  // Creates DOCKER_CREDS_USR and DOCKER_CREDS_PSW
        
        // Built-in Jenkins variables
        BUILD_TIMESTAMP = currentBuild.startTime
        
        // Command output
        GIT_COMMIT_SHORT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
    }
    
    stages {
        stage('Print Variables') {
            steps {
                echo "App Name: ${env.APP_NAME}"
                echo "Build Number: ${env.BUILD_NUMBER}"  // Jenkins built-in
                echo "Job Name: ${env.JOB_NAME}"
                echo "Workspace: ${env.WORKSPACE}"
                echo "Short commit: ${env.GIT_COMMIT_SHORT}"
            }
        }
        
        stage('Docker Login') {
            steps {
                // Credentials automatically create variables
                sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
            }
        }
    }
}
```

### Built-in Jenkins Environment Variables (Most Useful)

| Variable | What It Contains |
|----------|------------------|
| `BUILD_NUMBER` | Unique build number (increments each build) |
| `BUILD_ID` | Same as BUILD_NUMBER (legacy) |
| `JOB_NAME` | Name of the job/pipeline |
| `WORKSPACE` | Path to agent's workspace directory |
| `GIT_COMMIT` | Git commit hash (if checkout happened) |
| `GIT_BRANCH` | Branch being built |
| `JENKINS_URL` | Jenkins server URL |
| `BUILD_URL` | URL to this specific build |

---

## Part 5: Steps (The Actual Commands)

### Most Common Steps

```groovy
pipeline {
    agent any
    stages {
        stage('Examples') {
            steps {
                // 1. Echo (print to console)
                echo 'Hello World'
                
                // 2. Shell command
                sh 'ls -la'
                sh 'python app.py --test'
                
                // 3. Run with return value
                script {
                    def output = sh(script: 'echo "hello"', returnStdout: true).trim()
                    echo "Output was: ${output}"
                }
                
                // 4. Run with return status
                def exitCode = sh(script: 'some-command', returnStatus: true)
                
                // 5. Checkout code from Git
                checkout scm  // Uses the pipeline's configured SCM
                
                // 6. Git with specific repo
                git branch: 'main', url: 'https://github.com/user/repo.git'
                
                // 7. Docker build
                sh 'docker build -t myapp .'
                
                // 8. Write file
                writeFile file: 'config.txt', text: 'my config content'
                
                // 9. Read file
                def content = readFile('config.txt')
                
                // 10. Sleep/wait
                sleep time: 5, unit: 'SECONDS'
                
                // 11. Timeout a step
                timeout(time: 10, unit: 'MINUTES') {
                    sh 'long-running-command'
                }
                
                // 12. Retry a flaky step
                retry(3) {
                    sh 'flaky-command'
                }
            }
        }
    }
}
```

---

## Part 6: Post Actions (Run After Pipeline)

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'exit 0'  // Success
                // sh 'exit 1'  // Failure (uncomment to test)
            }
        }
    }
    
    // post: Runs after ALL stages complete
    post {
        // Always runs, regardless of outcome
        always {
            echo 'This always runs'
            cleanWs()  // Clean workspace (good practice)
        }
        
        // Runs only if pipeline succeeded
        success {
            echo 'Pipeline succeeded!'
            // Send email, Slack notification
        }
        
        // Runs only if pipeline failed
        failure {
            echo 'Pipeline failed!'
            // Send alert, log error
        }
        
        // Runs only if pipeline was unstable (tests failed but build succeeded)
        unstable {
            echo 'Tests failed but build succeeded'
        }
        
        // Runs only if pipeline was aborted by user
        aborted {
            echo 'User aborted the build'
        }
    }
}
```

---

## Part 7: Parameters (User Input When Triggering)

```groovy
pipeline {
    agent any
    
    // Define parameters (appear as form fields when clicking "Build with Parameters")
    parameters {
        // String parameter
        string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: 'Environment to deploy to')
        
        // Choice (dropdown)
        choice(name: 'REGION', choices: ['us-east-1', 'us-west-2', 'eu-west-1'], description: 'AWS Region')
        
        // Boolean (checkbox)
        booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run integration tests')
        
        // Password (hidden)
        password(name: 'API_KEY', description: 'Third-party API key')
    }
    
    stages {
        stage('Use Parameters') {
            steps {
                echo "Deploying to: ${params.DEPLOY_ENV}"
                echo "Region: ${params.REGION}"
                
                if (params.RUN_TESTS) {
                    echo 'Running tests...'
                    sh 'pytest'
                }
                
                // Use password parameter
                sh "curl -H \"API-Key: ${params.API_KEY}\" https://api.example.com"
            }
        }
        
        stage('Conditional Deploy') {
            when {
                expression { params.DEPLOY_ENV == 'production' }
            }
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'  // Manual approval
                sh './deploy-prod.sh'
            }
        }
    }
}
```

---

## Part 8: Triggers (Automatic Starting)

```groovy
pipeline {
    agent any
    
    triggers {
        // Cron schedule (minute hour day month weekday)
        cron('H 2 * * *')  // Daily at 2 AM
        // H = hash (random minute within hour to avoid thundering herd)
        
        // Poll SCM (check for changes every minute)
        pollSCM('* * * * *')
        
        // Trigger after another job completes
        upstream(upstreamProjects: 'build-job', threshold: hudson.model.Result.SUCCESS)
        
        // GitHub webhook trigger (requires GitHub plugin)
        // No configuration needed — just set webhook in GitHub
    }
    
    stages {
        stage('Build') {
            steps {
                echo 'Triggered build'
            }
        }
    }
}
```

### Cron Schedule Syntax

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of week (0 - 7) (Sunday = 0 or 7)
│ │ │ │ │
* * * * *
```

**Examples**:
| Schedule | Cron |
|----------|------|
| Every 15 minutes | `H/15 * * * *` |
| Daily at 9 AM | `H 9 * * *` |
| Monday-Friday at 6 PM | `H 18 * * 1-5` |
| First of month at midnight | `H 0 1 * *` |
| Every Sunday at 3 AM | `H 3 * * 0` |

---

## Part 9: When Conditions (Conditional Stages)

```groovy
pipeline {
    agent any
    stages {
        stage('Always Run') {
            steps {
                echo 'This always runs'
            }
        }
        
        stage('Only on Main Branch') {
            when {
                branch 'main'
            }
            steps {
                echo 'Running on main branch only'
            }
        }
        
        stage('Only on Pull Request') {
            when {
                changeRequest()  // True when building a PR
            }
            steps {
                echo 'Running for pull request'
            }
        }
        
        stage('Based on Environment Variable') {
            when {
                environment name: 'DEPLOY_TO_PROD', value: 'true'
            }
            steps {
                echo 'Deploy to production'
            }
        }
        
        stage('Expression Condition') {
            when {
                expression {
                    return env.BUILD_NUMBER.toInteger() % 2 == 0
                }
            }
            steps {
                echo 'This runs on even build numbers only'
            }
        }
        
        stage('Multiple Conditions (ALL must be true)') {
            when {
                allOf {
                    branch 'main'
                    environment name: 'SKIP_TESTS', value: 'false'
                }
            }
            steps {
                echo 'Runs when all conditions pass'
            }
        }
        
        stage('Any Condition (ONE must be true)') {
            when {
                anyOf {
                    branch 'develop'
                    branch 'feature/*'
                }
            }
            steps {
                echo 'Runs on develop OR feature branches'
            }
        }
        
        stage('Skip When') {
            when {
                not {
                    branch 'main'
                }
            }
            steps {
                echo 'Runs on ALL branches EXCEPT main'
            }
        }
    }
}
```

---

## Part 10: Tools (Use Build Tools)

```groovy
pipeline {
    agent any
    
    // Tools block: install/use specific tool versions
    tools {
        maven 'maven-3'      // Maven installation name in Jenkins config
        jdk 'jdk-11'        // JDK installation name
        nodejs 'node-14'    // Node.js installation
    }
    
    stages {
        stage('Build with Maven') {
            steps {
                sh 'mvn --version'
                sh 'mvn clean compile'
            }
        }
        
        stage('Build with Node') {
            steps {
                sh 'node --version'
                sh 'npm install'
            }
        }
    }
}
```

---

## Part 11: Complete Basic Examples

### Example 1: Simple Shell Script Pipeline

```groovy
pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building application...'
                sh 'make build'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'make test'
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                echo 'Deploying to production...'
                sh 'make deploy'
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs!'
        }
    }
}
```

### Example 2: Docker Build and Push Pipeline

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        DOCKER_IMAGE = 'myusername/myapp'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        DOCKER_CREDS = credentials('docker-hub-credentials')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('Run Tests in Container') {
            steps {
                sh """
                    docker run --rm ${DOCKER_IMAGE}:${DOCKER_TAG} pytest tests/
                """
            }
        }
        
        stage('Login to Docker Hub') {
            steps {
                sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
            }
        }
        
        stage('Push to Registry') {
            steps {
                sh """
                    docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    docker push ${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh """
                    ssh deploy@server './deploy.sh ${DOCKER_IMAGE}:${DOCKER_TAG}'
                """
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
            cleanWs()
        }
        success {
            echo 'Docker image built and pushed!'
        }
    }
}
```

---

## Part 12: Medium Complexity Examples

### Example 3: Multi-Stage Docker Build with Parallel Tests

```groovy
pipeline {
    agent none  // Each stage defines its own agent
    
    environment {
        DOCKER_REGISTRY = 'ecr.us-east-1.amazonaws.com'
        DOCKER_IMAGE = 'myapp'
        AWS_ACCOUNT = credentials('aws-account-id')
    }
    
    stages {
        stage('Checkout') {
            agent any
            steps {
                checkout scm
                script {
                    env.GIT_COMMIT_SHORT = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    env.BUILD_TIMESTAMP = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()
                }
            }
        }
        
        stage('Build Backend') {
            agent {
                docker {
                    image 'maven:3.8-openjdk-11'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                dir('backend') {
                    sh 'mvn clean package -DskipTests'
                    stash name: 'backend-jar', includes: 'target/*.jar'
                }
            }
        }
        
        stage('Build Frontend') {
            agent {
                docker {
                    image 'node:16'
                    args '-v /tmp:/tmp'
                }
            }
            steps {
                dir('frontend') {
                    sh 'npm install'
                    sh 'npm run build'
                    stash name: 'frontend-build', includes: 'dist/**'
                }
            }
        }
        
        stage('Parallel Tests') {
            parallel {
                stage('Backend Unit Tests') {
                    agent {
                        docker { image 'maven:3.8-openjdk-11' }
                    }
                    steps {
                        dir('backend') {
                            unstash 'backend-jar'
                            sh 'mvn test'
                            junit 'target/surefire-reports/*.xml'
                        }
                    }
                }
                
                stage('Frontend Unit Tests') {
                    agent {
                        docker { image 'node:16' }
                    }
                    steps {
                        dir('frontend') {
                            unstash 'frontend-build'
                            sh 'npm test'
                            junit 'test-results.xml'
                        }
                    }
                }
                
                stage('Integration Tests') {
                    agent {
                        docker {
                            image 'python:3.9'
                            args '-v /var/run/docker.sock:/var/run/docker.sock'  // Docker-in-Docker
                        }
                    }
                    steps {
                        sh '''
                            docker-compose -f docker-compose.test.yml up -d
                            sleep 10
                            docker-compose -f docker-compose.test.yml run tester pytest integration/
                            docker-compose -f docker-compose.test.yml down
                        '''
                    }
                }
            }
        }
        
        stage('Build Production Docker Image') {
            agent any
            steps {
                unstash 'backend-jar'
                unstash 'frontend-build'
                
                sh """
                    docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${GIT_COMMIT_SHORT} .
                    docker tag ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${GIT_COMMIT_SHORT} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                """
            }
        }
        
        stage('Push to ECR') {
            agent any
            steps {
                script {
                    sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${DOCKER_REGISTRY}
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${GIT_COMMIT_SHORT}
                        docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                sh """
                    aws ecs update-service --cluster myapp-staging --service backend --force-new-deployment
                """
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to Production?', ok: 'Deploy'
                sh """
                    aws ecs update-service --cluster myapp-prod --service backend --force-new-deployment
                """
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        failure {
            emailext (
                subject: "Pipeline Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "Build failed. Check console: ${env.BUILD_URL}",
                to: 'team@company.com'
            )
        }
        success {
            slackSend (
                color: 'good',
                message: "Deployment successful: ${env.JOB_NAME} #${env.BUILD_NUMBER} (${env.GIT_COMMIT_SHORT})"
            )
        }
    }
}
```

### Example 4: Deployment with Approval and Rollback

```groovy
pipeline {
    agent any
    
    environment {
        APP_VERSION = "v${env.BUILD_NUMBER}"
        DEPLOY_SCRIPT = './deploy.sh'
    }
    
    parameters {
        string(name: 'TARGET_ENV', defaultValue: 'staging', description: 'Environment to deploy')
        choice(name: 'ROLLBACK', choices: ['false', 'true'], description: 'Rollback to previous version')
    }
    
    stages {
        stage('Validate') {
            steps {
                script {
                    def allowedEnvs = ['staging', 'production']
                    if (!(params.TARGET_ENV in allowedEnvs)) {
                        error("Invalid environment: ${params.TARGET_ENV}")
                    }
                }
                echo "Deploying to: ${params.TARGET_ENV}"
            }
        }
        
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    if (params.ROLLBACK == 'true') {
                        // Get previous version from file
                        env.PREV_VERSION = readFile('last_deployed_version.txt').trim()
                        echo "Rolling back to: ${env.PREV_VERSION}"
                    } else {
                        env.PREV_VERSION = null
                    }
                }
            }
        }
        
        stage('Build') {
            when {
                expression { params.ROLLBACK == 'false' }
            }
            steps {
                sh "docker build -t myapp:${APP_VERSION} ."
            }
        }
        
        stage('Deploy to Staging') {
            when {
                expression { params.TARGET_ENV == 'staging' }
            }
            steps {
                sh "${DEPLOY_SCRIPT} staging ${APP_VERSION}"
            }
        }
        
        stage('Smoke Tests') {
            when {
                expression { params.TARGET_ENV == 'staging' }
            }
            steps {
                retry(3) {
                    sh '''
                        sleep 10
                        curl -f http://staging.myapp.com/health || exit 1
                        curl -f http://staging.myapp.com/api/version | grep "${APP_VERSION}"
                    '''
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                expression { params.TARGET_ENV == 'production' }
            }
            steps {
                input message: 'Deploy to PRODUCTION?', ok: 'Deploy to Production'
                
                script {
                    // Save current version before deploying
                    sh 'curl -s http://production.myapp.com/api/version > current_version.txt'
                }
                
                sh "${DEPLOY_SCRIPT} production ${APP_VERSION}"
            }
        }
        
        stage('Verify Production') {
            when {
                expression { params.TARGET_ENV == 'production' }
            }
            steps {
                sh '''
                    sleep 30
                    for i in 1 2 3; do
                        if curl -f http://production.myapp.com/health; then
                            echo "Deployment successful"
                            exit 0
                        fi
                        echo "Waiting for deployment... (attempt $i)"
                        sleep 10
                    done
                    echo "Deployment verification failed"
                    exit 1
                '''
            }
        }
        
        stage('Save Version') {
            when {
                expression { params.ROLLBACK == 'false' && params.TARGET_ENV == 'production' }
            }
            steps {
                writeFile file: 'last_deployed_version.txt', text: APP_VERSION
                stash name: 'deployed-version', includes: 'last_deployed_version.txt'
            }
        }
        
        stage('Rollback on Failure') {
            when {
                expression { params.ROLLBACK == 'true' || (currentBuild.result == 'FAILURE' && env.PREV_VERSION) }
            }
            steps {
                echo "Rolling back to ${env.PREV_VERSION}"
                sh "${DEPLOY_SCRIPT} ${params.TARGET_ENV} ${env.PREV_VERSION} --rollback"
            }
        }
    }
    
    post {
        success {
            echo "Deployment successful! Version: ${APP_VERSION}"
            // Send success notification
        }
        failure {
            echo "Deployment failed! Initiating rollback..."
            // Rollback logic
        }
    }
}
```

---

## Part 13: Pipeline Options (Configuration)

```groovy
pipeline {
    agent any
    
    options {
        // Discard old builds (keep last 10)
        buildDiscarder(logRotator(numToKeepStr: '10'))
        
        // Timeout entire pipeline after 1 hour
        timeout(time: 1, unit: 'HOURS')
        
        // Allow concurrent builds (default: false)
        disableConcurrentBuilds()
        
        // Preserve stashes for subsequent builds
        preserveStashes(buildCount: 5)
        
        // Skip default checkout (if you want manual checkout)
        skipDefaultCheckout()
        
        // Retry entire pipeline on failure
        retry(2)
    }
    
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
    }
}
```

---

## Part 14: Common Patterns & Best Practices

### Pattern 1: Conditional Execution Based on Branch

```groovy
stage('Deploy to Staging') {
    when {
        branch 'develop'
    }
    steps {
        sh './deploy-staging.sh'
    }
}

stage('Deploy to Production') {
    when {
        branch 'main'
        expression { params.CONFIRM == 'yes' }
    }
    steps {
        sh './deploy-production.sh'
    }
}
```

### Pattern 2: Read Version from File

```groovy
stage('Get Version') {
    steps {
        script {
            def versionFile = readFile('VERSION')
            env.APP_VERSION = versionFile.trim()
            echo "Building version: ${env.APP_VERSION}"
        }
    }
}
```

### Pattern 3: Parallel Stages (Speed Up Build)

```groovy
stage('Parallel Testing') {
    parallel {
        stage('Test Unit') {
            steps { sh 'pytest tests/unit' }
        }
        stage('Test Integration') {
            steps { sh 'pytest tests/integration' }
        }
        stage('Test Performance') {
            steps { sh 'pytest tests/performance' }
        }
    }
}
```

### Pattern 4: Matrix Build (Multi-Platform)

```groovy
stage('Build Matrix') {
    matrix {
        axes {
            axis(name: 'OS', values: 'linux', 'windows', 'mac')
            axis(name: 'PYTHON_VERSION', values: '3.8', '3.9', '3.10')
        }
        stages {
            stage('Build') {
                steps {
                    echo "Building on ${OS} with Python ${PYTHON_VERSION}"
                }
            }
        }
    }
}
```

### Pattern 5: Shared Library Usage

```groovy
@Library('my-shared-library') _

pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                // Use function from shared library
                myLibrary.buildDockerImage('myapp')
            }
        }
        stage('Test') {
            steps {
                myLibrary.runTests()
            }
        }
    }
}
```

---

## Part 15: Debugging Techniques

### Debug Step 1: Print Everything

```groovy
stage('Debug Info') {
    steps {
        echo "Workspace: ${env.WORKSPACE}"
        echo "Build Number: ${env.BUILD_NUMBER}"
        echo "Job Name: ${env.JOB_NAME}"
        sh 'pwd'
        sh 'ls -la'
        sh 'env | sort'  // All environment variables
    }
}
```

### Debug Step 2: Catch Failures

```groovy
stage('Risky Operation') {
    steps {
        script {
            try {
                sh 'dangerous-command.sh'
            } catch (Exception e) {
                echo "Command failed: ${e.getMessage()}"
                // Don't fail the build
                currentBuild.result = 'UNSTABLE'
            }
        }
    }
}
```

### Debug Step 3: View Logs in Real Time

```groovy
pipeline {
    options {
        // Show timestamps in logs
        timestamps()
        
        // Color console output
        ansiColor('xterm')
    }
    stages {
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
    }
}
```

---

## Quick Reference: Pipeline Keywords

| Keyword | Purpose |
|---------|---------|
| `pipeline` | Wrapper for entire pipeline |
| `agent` | Where to run |
| `stages` | Container for stage blocks |
| `stage` | Logical grouping of work |
| `steps` | Actual commands to run |
| `environment` | Variables available to all stages |
| `parameters` | User input when triggering build |
| `triggers` | Automatic build starting |
| `tools` | Build tools (Maven, JDK, Node) |
| `when` | Conditional execution |
| `parallel` | Run stages in parallel |
| `matrix` | Run combinations of axes |
| `post` | Run after all stages |
| `options` | Pipeline configuration |

---

This covers **everything** you need to write Jenkins pipelines from scratch. You can now:
- Write basic pipelines with one stage
- Add environment variables and credentials
- Use conditional logic with `when`
- Run parallel stages
- Handle success/failure with `post`
- Deploy with manual approvals
- Debug using environment inspection

Ready to start writing your own pipelines?