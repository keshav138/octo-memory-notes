# AWS Services Overview – Practical Guide for DevOps & Cloud Engineers

A **focused, practical overview** of AWS services you'll actually use. Think of this as your cheat sheet for what each service does and when to reach for it.

---

## Part 1: Compute Services (Where your code runs)

### EC2 (Elastic Compute Cloud)
**What it does**: Virtual machines in the cloud (rent a computer)

**When to use**:
- Need full control over OS and software
- Legacy apps that need specific configs
- Long-running workloads

**Key concepts**:
- **Instance types**: t2.micro (free tier), m5.large (general), c5.xlarge (compute-optimized)
- **AMI**: Amazon Machine Image (OS template)
- **Security groups**: Virtual firewall
- **Key pairs**: SSH access

**Example use case**: Running a Flask app on Ubuntu with custom dependencies

### Lambda
**What it does**: Run code without servers (pay per execution)

**When to use**:
- Event-driven tasks (file upload → process image)
- APIs with low traffic
- Scheduled jobs (cron replacements)

**Key concepts**:
- **Triggers**: S3, API Gateway, CloudWatch Events, SQS
- **Time limit**: 15 minutes max execution
- **Memory**: 128MB - 10GB
- **Cold start**: First request can be slow

**Example use case**: Image resizing when user uploads to S3

```
S3 Upload → Lambda Trigger → Process Image → Save back to S3
```

### Elastic Beanstalk
**What it does**: PaaS (Platform as a Service) – just upload code, AWS handles rest

**When to use**:
- You want to focus on code, not infrastructure
- Standard web apps (Node, Python, Java, .NET, Docker)
- Quick prototyping

**Key concepts**:
- **Environment**: Running version of your app
- **Configuration**: Auto-scaling, LB, RDS attached easily
- **Deployment**: Just `eb deploy`

**Example use case**: Deploy a Flask app without writing Terraform or managing EC2

### ECS (Elastic Container Service) & Fargate
**What it does**: Run Docker containers on AWS

**When to use**:
- You're already using Docker
- Want orchestration without managing Kubernetes

**Two launch types**:
- **ECS on EC2**: You manage worker nodes
- **Fargate (serverless)**: AWS manages everything – just define container (preferred)

**Example use case**: Running your Flask Docker container without EC2 management

---

## Part 2: Storage Services (Where your data lives)

### S3 (Simple Storage Service)
**What it does**: Object storage (unlimited files, like a giant hard drive in the cloud)

**When to use**:
- Static websites (HTML, CSS, JS)
- User uploads (profile pics, documents)
- Data lakes, backups, logs

**Key concepts**:
- **Buckets**: Like folders (globally unique name)
- **Objects**: Files + metadata
- **Storage classes**: 
  - Standard (frequent access)
  - Intelligent-Tiering (automatic)
  - Glacier (archive, cheap retrieval cost)

**Example use case**: Hosting a static React app or storing user-uploaded images

### EBS (Elastic Block Storage)
**What it does**: Hard drives for EC2 instances (like an external SSD)

**When to use**:
- Database storage (needs persistence)
- Application data that changes frequently

**Key concepts**:
- **Volume types**: gp3/gp2 (SSD), io1/io2 (high performance)
- **Snapshots**: Backups to S3
- **Attachment**: One EC2 instance per volume (mostly)

**Example use case**: Root disk for your Flask EC2 instance

### EFS (Elastic File System)
**What it does**: Shared network drive (like a NAS)

**When to use**:
- Multiple EC2 instances need to access same files
- Serverless (Lambda) needs shared state

**Key concepts**:
- **NFS protocol**: Linux-friendly
- **Automatic scaling**: Grows/shrinks as you use it
- **Mount targets**: Connect to your VPC

**Example use case**: WordPress media uploads shared across multiple web servers

### RDS (Relational Database Service)
**What it does**: Managed databases (PostgreSQL, MySQL, SQL Server, etc.)

**When to use**:
- Need relational database with ACID transactions
- Don't want to manage backups, patching, replication

**Key concepts**:
- **Aurora**: AWS's high-performance MySQL/PostgreSQL compatible DB
- **Multi-AZ**: Automatic failover to standby
- **Read replicas**: Scale read traffic

**Example use case**: Storing user accounts and orders for your Flask e-commerce app

### DynamoDB
**What it does**: NoSQL key-value database (serverless)

**When to use**:
- High throughput, low latency
- Simple data model (user profiles, session data)
- Serverless workloads (Lambda)

**Key concepts**:
- **Tables**: Single or composite primary key
- **Capacity modes**: 
  - Provisioned (predictable traffic)
  - On-demand (variable/spiky traffic)
- **Global tables**: Multi-region replication

**Example use case**: Storing user session tokens or product catalog for high-traffic API

---

## Part 3: Networking Services (How things connect)

### VPC (Virtual Private Cloud)
**What it does**: Your private network inside AWS (like your own data center in the cloud)

**When to use**: Always – every AWS resource lives in a VPC

**Key concepts**:
- **CIDR block**: IP range (e.g., 10.0.0.0/16)
- **Subnets**: Public (internet accessible) or Private
- **Route tables**: Traffic routing rules
- **Internet Gateway**: Allows internet access
- **NAT Gateway**: Allows private subnets to access internet (but not inbound)

**Typical setup**:
```
Public Subnet (Web servers)  →  Internet Gateway
Private Subnet (Database)    →  NAT Gateway for outbound internet
```

### ALB (Application Load Balancer)
**What it does**: Distributes traffic across multiple targets (EC2, containers, Lambda)

**When to use**:
- HTTP/HTTPS traffic (web apps)
- Need path-based routing (`/api`, `/static`)
- Need host-based routing (`api.myapp.com`, `www.myapp.com`)

**Key concepts**:
- **Listeners**: Port and protocol (80, 443)
- **Target groups**: Where traffic goes (EC2 instances, IPs, Lambda)
- **Health checks**: Automatically remove unhealthy targets

**Example use case**: Balancing traffic across three Flask EC2 instances

### API Gateway
**What it does**: Create and manage APIs (REST, WebSocket, HTTP)

**When to use**:
- Expose Lambda functions as REST API
- API key management, rate limiting
- Request transformation

**Key concepts**:
- **Endpoints**: Edge-optimized, Regional, Private
- **Stages**: Dev, test, prod
- **Caching**: Reduce Lambda calls

**Example use case**: Frontend calls `https://api.myapp.com/users` → API Gateway → Lambda → DynamoDB

### CloudFront
**What it does**: CDN (Content Delivery Network) – cache content at edge locations

**When to use**:
- Static assets (images, CSS, JS)
- Global users needing low latency
- DDoS protection

**Key concepts**:
- **Origins**: S3 bucket, ELB, EC2, or custom
- **Behaviors**: Cache rules by path
- **Invalidations**: Clear cache manually (costs money)

**Example use case**: Serving React app from S3 with CloudFront for global speed

### Route 53
**What it does**: DNS (Domain Name System) – point domain names to AWS resources

**When to use**:
- Register domains
- Route traffic (simple, weighted, latency-based, geolocation)

**Key concepts**:
- **Record types**: A (IPv4), CNAME (alias), MX (email)
- **Alias records**: AWS-specific (points to ELB, CloudFront for free)
- **Routing policies**: Simple, weighted, latency, failover, geolocation

**Example use case**: `flask.myapp.com` → ALB, `static.myapp.com` → CloudFront/S3

---

## Part 4: Security & Identity

### IAM (Identity and Access Management)
**What it does**: Who can do what on which resources

**When to use**: Every time you give someone or something access to AWS

**Key concepts**:
- **Users**: Individual people (long-term credentials)
- **Groups**: Collections of users (admins, developers, read-only)
- **Roles**: For services (EC2 needs S3 access → attach role)
- **Policies**: JSON documents defining permissions

**Example policy** (allow S3 read of specific bucket):
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::my-flask-bucket/*"
  }]
}
```

**Best practice**: Never use root user – create IAM users/roles. Least privilege.

---

## Part 5: Development & CI/CD Tools

### CodeCommit
**What it does**: Managed Git repositories (AWS's GitHub alternative)

**When to use**:
- Need private Git repos integrated with other AWS services
- Compliance requirements (keep code inside AWS)

### CodeBuild
**What it does**: Build and test code (compile, run tests, produce artifacts)

**When to use**:
- Part of CI/CD pipeline
- Need to build Docker images

**Example**: GitHub push → CodeBuild run tests → CodeDeploy

### CodeDeploy
**What it does**: Automate deployments to EC2, Lambda, or on-prem

**When to use**:
- Blue/green deployments
- Rolling updates with minimal downtime

### CodePipeline
**What it does**: Orchestrate CI/CD workflows (like Jenkins)

**When to use**:
- Fully AWS-native CI/CD
- Simple pipelines without managing Jenkins

**Pipeline example**:
```
Source (CodeCommit/GitHub) → Build (CodeBuild) → Deploy (CodeDeploy/EB/ECS)
```

### CloudFormation
**What it does**: AWS's native Infrastructure as Code (Terraform alternative)

**When to use**:
- You want AWS-native IaC (no third-party tools)
- You're deep in AWS ecosystem

**Key difference from Terraform**:
- **CloudFormation**: AWS only, uses YAML/JSON templates
- **Terraform**: Multi-cloud, uses HCL language

---

## Part 6: Monitoring & Logging

### CloudWatch
**What it does**: Monitoring, logs, alerts, and metrics

**When to use**: Always – for visibility into your resources

**Key concepts**:
- **Metrics**: CPUUtilization, NetworkIn/Out (up to 1-minute granularity)
- **Logs**: Collect logs from EC2, Lambda, RDS
- **Alarms**: Trigger SNS (email, SMS) or Auto Scaling
- **Dashboards**: Custom visualizations

**Example use case**: Alert when CPU > 80% on Flask EC2

### CloudTrail
**What it does**: Audit log of every API call in AWS (who did what, when, from where)

**When to use**:
- Security auditing
- Compliance requirements (HIPAA, SOC)
- Troubleshooting "who deleted that S3 bucket"

**Key concepts**:
- **Management events**: Console logins, resource creation
- **Data events**: S3 object-level, Lambda invocation
- **Trail**: Configure where logs go (S3, CloudWatch Logs)

---

## Part 7: Real-World Flask App Architecture (Putting It Together)

### Simple Tier (Your Terraform example so far)
```
User → EC2 (Flask) → RDS (PostgreSQL)
```

### Production Tier (What you'll work toward)
```
User → Route 53 → CloudFront (CDN) → ALB → EC2 Auto Scaling Group (Flask) → RDS Multi-AZ
                                                    ↓
                                                ElastiCache (Redis for sessions)
```

### Serverless Tier (No EC2 management)
```
User → CloudFront → API Gateway → Lambda (Flask in Lambda via Mangum) → DynamoDB
```

### CI/CD Pipeline
```
GitHub → CodeBuild/CodePipeline → Build Docker image → Push to ECR → Deploy to ECS/Fargate
```

---

## Part 8: Quick Service Decision Tree

**"I want to run my Flask app..."**

| Scenario | Choose |
|----------|--------|
| Just learning, manual control | EC2 |
| Just upload code, let AWS manage | Elastic Beanstalk |
| Already using Docker, want serverless | ECS Fargate |
| Need full container orchestration | EKS (Kubernetes) |
| Small API with low traffic, no server management | Lambda + API Gateway |

**"I need to store..."**

| Scenario | Storage |
|----------|---------|
| Files/images | S3 |
| Database with complex queries | RDS (PostgreSQL/MySQL) |
| High-scale key-value | DynamoDB |
| Shared file system across servers | EFS |

**"I need to secure..."**

| Need | Service |
|------|---------|
| Who can access AWS | IAM |
| Encrypt S3 files | S3 + KMS |
| Secrets (DB passwords, API keys) | Secrets Manager or Parameter Store |
| DDoS protection | AWS Shield + WAF |

---

## Part 9: AWS Free Tier (Your Learning Budget)

Services you can use **for free** (within limits):
- **EC2**: 750 hours/month of t2.micro (one instance 24/7)
- **Lambda**: 1 million requests/month
- **S3**: 5 GB storage, 20k get requests
- **RDS**: 750 hours/month of db.t2.micro
- **CloudWatch**: 10 custom metrics, 5 GB log data
- **DynamoDB**: 25 GB storage, 25 read/write units

**Cost warning**: Always `terraform destroy` when done. Leaving RDS or ALB running will cost money.

---

## Part 10: AWS CLI Commands You'll Actually Use

```bash
# Identity
aws sts get-caller-identity

# EC2
aws ec2 describe-instances
aws ec2 stop-instances --instance-ids i-12345
aws ec2 start-instances --instance-ids i-12345

# S3
aws s3 ls
aws s3 cp file.txt s3://my-bucket/
aws s3 sync ./local-folder s3://my-bucket/folder

# RDS
aws rds describe-db-instances
aws rds create-db-snapshot --db-instance-id my-flask-db

# Logs
aws logs describe-log-groups
```

---

## Summary Table: Core Services Memorize These

| Category | Service | What in 5 words |
|----------|---------|-----------------|
| Compute | EC2 | Virtual machines |
| Compute | Lambda | Run code on demand |
| Container | ECS/Fargate | Docker without servers |
| Storage | S3 | Unlimited object storage |
| Storage | RDS | Managed relational DB |
| Network | VPC | Your private cloud network |
| Network | ALB | Traffic load balancer |
| CDN | CloudFront | Global content cache |
| DNS | Route 53 | Domain name routing |
| Security | IAM | Access control |
| CI/CD | CodePipeline | Automation pipeline |
| Monitoring | CloudWatch | Metrics and logs |

---

## Next Steps After This Overview

Now you can:
1. **Recognize** what each service does in architecture diagrams
2. **Choose** the right service for your Flask app's needs
3. **Understand** the Terraform examples that use these services

**Ready to move to:**
- **Jenkins pipeline fundamentals** (build, test, deploy your Flask app)
- **Or integrating Terraform with Jenkins** (automated `terraform apply`)
- **Or deep dive into one AWS service** (like VPC networking or RDS)

Which direction?