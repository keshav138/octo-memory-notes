# AWS Cloud — Interview Reference Notes

Comprehensive but interview-focused. Each section: **what it is → why it exists → how it integrates → example scenario**.

---

## 1. Cloud Fundamentals

### Service Models
- **IaaS** (Infrastructure as a Service): You manage OS, runtime, app. AWS manages hardware, virtualization, networking. Example: EC2.
- **PaaS** (Platform as a Service): AWS manages OS/runtime too; you manage app + config. Example: Elastic Beanstalk, RDS.
- **SaaS**: Fully managed application. Example: Amazon Chime, WorkMail.
- **FaaS** (Function as a Service, subset of serverless): You only manage code. Example: Lambda.

**Interview angle**: Be ready to place any AWS service on this spectrum and explain the trade-off — less management overhead = less control.

### Global Infrastructure
- **Region**: Independent geographic area (e.g., `us-east-1`). Fully isolated from other regions unless you explicitly replicate data.
- **Availability Zone (AZ)**: One or more discrete data centers within a region, with independent power/cooling/networking. Regions have 3+ AZs typically.
- **Edge Location**: Used by CloudFront/Route53 for caching content closer to users; separate from AZs.

**Why it matters**: High availability designs deploy across multiple AZs (survive a data center failure); disaster recovery designs deploy across multiple regions (survive a regional outage).

**Example**: An app with EC2 instances in `us-east-1a` and `us-east-1b` behind a load balancer survives an AZ outage. To survive a full region outage, you'd need a DR setup in `us-west-2` (pilot light, warm standby, or multi-site active-active).

---

## 2. IAM (Identity and Access Management)

- **Users**: Individual identities (people or apps) with long-term credentials.
- **Groups**: Collections of users sharing permissions.
- **Roles**: Temporary credentials assumed by a user, service, or external identity — no long-term keys. This is how services like EC2 or Lambda get permissions to call other AWS APIs.
- **Policies**: JSON documents defining permissions (Allow/Deny on Actions + Resources), attached to users/groups/roles.

### Key Concepts
- **Principle of least privilege**: grant only the permissions needed.
- **Policy evaluation logic**: explicit Deny always wins > explicit Allow > implicit Deny (default).
- **Resource-based vs identity-based policies**: An S3 bucket policy (resource-based) can grant access to another account without that account needing an identity-based policy for it.
- **STS (Security Token Service)**: Issues temporary credentials — underlies role assumption, federation (SSO), and cross-account access.

**Integration example**: An EC2 instance needs to read/write to an S3 bucket. Instead of hardcoding access keys on the instance, you attach an **IAM role** (via an instance profile) to the EC2 instance. The instance calls STS automatically (via the metadata service) to get temporary credentials scoped to a policy allowing `s3:GetObject`/`s3:PutObject` on that specific bucket. This is the standard "don't hardcode credentials" answer interviewers look for.

---

## 3. Compute

### EC2 (Elastic Compute Cloud)
- Virtual machines ("instances") of various families: general purpose (M-series), compute-optimized (C-series), memory-optimized (R-series), storage-optimized (I-series), GPU (P/G-series).
- **Purchasing options**:
  - On-Demand: pay per second/hour, no commitment — good for unpredictable workloads.
  - Reserved Instances: 1 or 3-year commitment for discount — good for steady-state workloads.
  - Spot Instances: bid on spare capacity at up to 90% discount, can be reclaimed with 2-minute warning — good for fault-tolerant, interruptible workloads (batch processing, CI runners).
  - Savings Plans: commit to $/hour of compute usage, flexible across instance types.
- **AMI (Amazon Machine Image)**: Template (OS + software) used to launch instances — used for consistent, repeatable deployments.

### Auto Scaling Groups (ASG)
- Automatically adds/removes EC2 instances based on demand (CPU utilization, custom CloudWatch metric, or schedule).
- Requires a **Launch Template** defining instance config.
- **Integration**: ASG + ELB — the load balancer's health checks feed into the ASG, which replaces unhealthy instances automatically.

**Example need**: An e-commerce site sees 5x traffic during a sale. An ASG with a target-tracking policy (e.g., keep average CPU at 50%) scales out instances automatically and scales back in after the sale, avoiding both downtime and over-provisioning cost.

### Lambda
- Serverless compute — runs code in response to events, no server management, billed per invocation + duration (ms-level billing).
- Max execution time: 15 minutes. Stateless between invocations (though execution context can be reused for "warm starts").
- **Cold start**: latency incurred when a new execution environment is initialized — a common interview topic. Mitigated via Provisioned Concurrency.
- **Integration**: Lambda is the glue in most serverless architectures — triggered by S3 events, API Gateway requests, DynamoDB Streams, SQS messages, EventBridge rules, CloudWatch schedule (cron).

**Example need**: When a user uploads an image to S3, an S3 event notification triggers a Lambda function that resizes the image and writes a thumbnail back to another S3 bucket — no server ever provisioned.

### ECS / EKS / Fargate (Containers)
- **ECS (Elastic Container Service)**: AWS's own container orchestrator. Runs Docker containers as "Tasks" grouped into "Services."
- **EKS (Elastic Kubernetes Service)**: Managed Kubernetes control plane — used when you need K8s portability/ecosystem (Helm charts, K8s-native tooling) or already run K8s elsewhere.
- **Fargate**: Serverless compute engine for containers — works with both ECS and EKS. You define CPU/memory needs; AWS manages the underlying EC2 fleet. No node/host patching.
- **EC2 launch type** (vs Fargate): you manage the underlying EC2 instances yourself — more control, cheaper at scale, more ops overhead.

**Interview angle — ECS vs EKS vs Lambda**:
- Lambda: short-lived, event-driven, stateless functions.
- ECS/Fargate: long-running services, more control over runtime, still low ops (with Fargate).
- EKS: needed when the org standardizes on Kubernetes or needs multi-cloud portability.

**Example need**: A microservices app with 10 always-on services, each needing custom OS-level dependencies not well-suited to Lambda's 15-minute/stateless model → run as ECS tasks on Fargate, each service behind an ALB target group.

---

## 4. Storage

### S3 (Simple Storage Service)
- Object storage (not a file system) — objects (files) stored in **buckets**, addressed by key. 11 9's durability.
- **Storage classes** (cost vs retrieval trade-off):
  - Standard: frequent access.
  - Intelligent-Tiering: auto-moves objects between tiers based on access patterns.
  - Standard-IA / One Zone-IA: infrequent access, cheaper storage, retrieval fee.
  - Glacier / Glacier Deep Archive: archival, minutes-to-hours retrieval, very cheap storage.
- **Versioning**: keeps multiple variants of an object — protects against accidental overwrite/delete.
- **Lifecycle policies**: automatically transition or expire objects (e.g., move to Glacier after 90 days).
- **S3 event notifications**: trigger Lambda/SQS/SNS on object create/delete.

**Integration example**: Static website hosting — S3 bucket serves HTML/CSS/JS directly, fronted by **CloudFront** (CDN) for caching/HTTPS, with **Route 53** mapping a custom domain to the CloudFront distribution.

### EBS (Elastic Block Store)
- Block storage — attached to a single EC2 instance (like a virtual hard drive), persists independently of instance lifecycle.
- Types: gp3 (general purpose SSD), io2 (high-IOPS, e.g., databases), st1/sc1 (throughput-optimized HDD for large sequential workloads).
- **Snapshots**: point-in-time backups stored in S3 (incremental).

**EBS vs S3**: EBS = block storage, single-AZ, attached to one instance, needed for OS volumes/databases. S3 = object storage, regional, accessed via API/HTTP, needed for unstructured data at scale.

### EFS (Elastic File System)
- Managed NFS — shared file storage, mountable by **multiple** EC2 instances or Lambda functions simultaneously.
- **Use case**: Shared config/content across a fleet of web servers, or Lambda functions needing shared persistent storage beyond `/tmp`'s limits.

---

## 5. Databases

### RDS (Relational Database Service)
- Managed relational DB (MySQL, PostgreSQL, MariaDB, Oracle, SQL Server). AWS handles patching, backups, failover.
- **Multi-AZ**: synchronous standby replica in a different AZ — automatic failover for HA, not for read scaling.
- **Read Replicas**: asynchronous copies for read scaling (can be cross-region) — not automatically used for failover.

### Aurora
- AWS-proprietary MySQL/PostgreSQL-compatible engine — storage layer decoupled and auto-replicated across 3 AZs (6 copies). Higher throughput and faster failover than standard RDS.
- **Aurora Serverless**: auto-scales capacity based on load — good for intermittent/unpredictable workloads.

### DynamoDB
- Managed NoSQL, key-value/document store. Single-digit millisecond latency at any scale.
- **Partition key** (+ optional sort key) determines data distribution across partitions — critical for avoiding "hot partitions" (interview favorite: designing a partition key that distributes traffic evenly).
- **DynamoDB Streams**: change log of item-level modifications — commonly triggers Lambda for event-driven processing.
- **On-demand vs provisioned capacity**: provisioned = set RCU/WCU (predictable cost, needs Auto Scaling for spikes); on-demand = pay per request (simpler, costs more at high steady volume).

**Integration example**: An order-processing system stores orders in DynamoDB. A DynamoDB Stream triggers a Lambda function that updates an inventory count and publishes an SNS notification — fully event-driven, no polling.

### ElastiCache
- Managed in-memory cache (Redis or Memcached). Sits in front of RDS/DynamoDB to reduce read load and latency.
- **Example need**: A product catalog page hit thousands of times/minute reads from ElastiCache first (cache hit = sub-millisecond); on a cache miss, falls back to RDS and repopulates the cache.

### Redshift
- Managed data warehouse, columnar storage, optimized for OLAP (complex analytical queries over large datasets), not transactional workloads. Often loaded from S3 via `COPY` commands, and integrates with QuickSight for BI dashboards.

**Interview angle — choosing a database**:
- Transactional, relational, need joins/ACID → RDS/Aurora.
- Massive scale, simple access patterns, flexible schema → DynamoDB.
- Analytics over huge historical datasets → Redshift.
- Caching layer → ElastiCache.

---

## 6. Networking

### VPC (Virtual Private Cloud)
- Your logically isolated network within AWS, defined by a CIDR block (e.g., `10.0.0.0/16`).
- **Subnets**: subdivisions of the VPC CIDR, each tied to one AZ.
  - **Public subnet**: has a route to an **Internet Gateway (IGW)**.
  - **Private subnet**: no direct route to the internet; outbound internet access (if needed) via a **NAT Gateway** placed in a public subnet.
- **Route Tables**: control traffic routing per subnet.
- **Security Groups**: stateful, instance-level firewall (if you allow inbound, the response is automatically allowed out).
- **Network ACLs (NACLs)**: stateless, subnet-level firewall (must explicitly allow both inbound and outbound).

**Interview angle — SG vs NACL**: SG = stateful, applies to instances/ENIs, allow-rules only. NACL = stateless, applies to subnets, supports allow AND deny rules — used for explicit IP blocking at the subnet level.

**Example architecture (classic 3-tier)**:
- Public subnet: ALB (internet-facing).
- Private subnet (app tier): EC2/ECS instances, only reachable from the ALB's security group.
- Private subnet (data tier): RDS, only reachable from the app tier's security group.
- NAT Gateway in the public subnet lets the private app tier pull OS updates/packages without being directly internet-reachable.

### Load Balancers (Elastic Load Balancing)
- **ALB (Application Load Balancer)**: Layer 7 (HTTP/HTTPS) — supports path-based/host-based routing, good for microservices, WebSocket, gRPC.
- **NLB (Network Load Balancer)**: Layer 4 (TCP/UDP) — ultra-low latency, static IP support, good for extreme performance needs or non-HTTP protocols.
- **Health checks**: determine which targets receive traffic; feeds into ASG replacement logic.

### Route 53
- Managed DNS + domain registration. Also supports **routing policies**: simple, weighted (A/B testing, gradual rollout), latency-based, geolocation, failover (active-passive DR).

### CloudFront
- CDN — caches content at edge locations close to users, reduces latency and origin load.
- **Origins** can be S3 (static content), an ALB, or any custom HTTP endpoint.
- Integrates with **AWS WAF** (Web Application Firewall) at the edge to block malicious traffic before it reaches the origin, and with **ACM** (Certificate Manager) for free HTTPS certs.

### API Gateway
- Managed entry point for APIs — handles routing, throttling, authorization, request/response transformation.
- **Integration**: Commonly paired with Lambda ("Lambda proxy integration") to build fully serverless REST/HTTP/WebSocket APIs — API Gateway handles the HTTP layer, Lambda handles business logic, no server ever exists.

---

## 7. Messaging & Integration (Decoupling)

The interview theme here: **synchronous coupling is fragile; queues/topics/streams decouple producers and consumers.**

### SQS (Simple Queue Service)
- Managed message queue. Producers push messages; consumers poll and process, then delete.
- **Standard queue**: at-least-once delivery, best-effort ordering, near-unlimited throughput.
- **FIFO queue**: exactly-once processing, strict ordering, lower throughput ceiling.
- **Dead Letter Queue (DLQ)**: captures messages that fail processing repeatedly, for later inspection — prevents "poison pill" messages from blocking the queue indefinitely.

**Example need**: A web app accepts video upload requests. Instead of processing (transcoding) synchronously and making the user wait, the request is pushed to SQS; a fleet of worker EC2/Lambda instances pulls from the queue and processes asynchronously. If traffic spikes, the queue absorbs the burst instead of overloading workers.

### SNS (Simple Notification Service)
- Pub/sub messaging — one message published to a **topic** fans out to multiple subscribers (SQS queues, Lambda, email, SMS, HTTP endpoints) simultaneously.
- **SQS vs SNS**: SQS = one message, pulled by one consumer (point-to-point). SNS = one message, pushed to many subscribers (fan-out). Very common pattern: **SNS + multiple SQS queues subscribed to it** — each downstream service gets its own durable queue off the same event.

### EventBridge
- Event bus for routing events based on content/pattern matching, from AWS services, SaaS partners, or custom apps, to targets like Lambda, Step Functions, SQS.
- More powerful routing/filtering than SNS; commonly used for event-driven architectures decoupling many microservices.

### Kinesis
- Real-time streaming data ingestion (e.g., clickstreams, IoT telemetry, log data) at high throughput, with ordered records within a "shard," consumed by multiple applications independently (unlike SQS where a message is removed once consumed).
- **Kinesis vs SQS**: Kinesis = high-throughput ordered stream, multiple consumers can replay/read independently, data retained for a window (default 24h, up to 365 days). SQS = simpler task/work queue, message deleted once processed.

---

## 8. Infrastructure as Code & CI/CD

### CloudFormation
- AWS-native IaC — define infrastructure in YAML/JSON templates, deployed as "stacks." Supports rollback on failure, drift detection.
- **Terraform** (not AWS-native, but frequently asked about in interviews): third-party, multi-cloud IaC tool — often preferred when infra spans multiple providers.

### CodePipeline / CodeBuild / CodeDeploy
- **CodePipeline**: orchestrates the CI/CD workflow (source → build → test → deploy stages).
- **CodeBuild**: managed build/test service (compiles code, runs unit tests, produces artifacts).
- **CodeDeploy**: automates deployment to EC2, Lambda, or ECS — supports blue/green and canary deployment strategies.

**Example flow**: Code pushed to a Git repo → CodePipeline triggers → CodeBuild runs tests and builds a Docker image → image pushed to **ECR** (Elastic Container Registry) → CodeDeploy performs a blue/green deployment to ECS, shifting traffic gradually while monitoring CloudWatch alarms, with automatic rollback on error spike.

---

## 9. Monitoring, Logging & Governance

- **CloudWatch**: metrics, logs, alarms, dashboards. Alarms can trigger Auto Scaling actions, SNS notifications, or Lambda functions.
- **CloudTrail**: records API calls (who did what, when) across the account — used for auditing/security investigation, distinct from CloudWatch (which is about performance/operational metrics).
- **Config**: tracks resource configuration changes over time and evaluates compliance against rules (e.g., "flag any S3 bucket that becomes public").
- **X-Ray**: distributed tracing — visualizes request flow across microservices to pinpoint latency bottlenecks.

**Interview angle — CloudWatch vs CloudTrail**: CloudWatch = "how is my system performing" (metrics/logs/alarms). CloudTrail = "who did what" (API-level audit log). Very commonly confused, worth stating clearly.

---

## 10. Security & Encryption

- **KMS (Key Management Service)**: managed encryption keys — used to encrypt data at rest across S3, EBS, RDS, etc. Supports automatic key rotation.
- **Secrets Manager**: stores and rotates secrets (DB credentials, API keys) — apps retrieve secrets at runtime instead of hardcoding them.
- **WAF**: filters HTTP traffic at the edge (CloudFront/ALB) against common exploits (SQL injection, XSS) using rule sets.
- **Shield**: DDoS protection (Standard = automatic/free; Advanced = paid, more coverage + 24/7 DDoS response team).
- **Encryption in transit vs at rest**: in transit = TLS/HTTPS between client and service; at rest = data encrypted on disk (via KMS-managed keys), both often asked together.

---

## 11. Well-Architected Framework (common interview closer)

Five (now six) pillars AWS uses to evaluate architecture quality:
1. **Operational Excellence** — run and monitor systems, improve processes continuously.
2. **Security** — protect data/systems (least privilege, encryption, traceability).
3. **Reliability** — recover from failure, scale to meet demand (multi-AZ, auto-healing).
4. **Performance Efficiency** — use resources efficiently, adapt as needs change.
5. **Cost Optimization** — avoid unneeded spend (right-sizing, Spot, Savings Plans).
6. **Sustainability** — minimize environmental impact of workloads.

**How to use this in an interview**: If asked to design a system, explicitly walk through trade-offs against these pillars (e.g., "Multi-AZ RDS improves Reliability but costs more — a good trade-off for a production payment system, less justified for a dev environment").

---

## 12. Common End-to-End Architecture Patterns (tie-it-together examples)

### A. Classic 3-tier web app
Route 53 → CloudFront (static assets) → ALB (public subnet) → EC2/ECS in ASG (private subnet, app tier) → RDS Multi-AZ (private subnet, data tier). Security groups scoped tier-to-tier. CloudWatch alarms drive scaling and alerting.

### B. Fully serverless API
API Gateway → Lambda → DynamoDB. Cognito (not detailed above, but worth knowing: managed user authentication/authorization) issues JWT tokens validated by API Gateway before invoking Lambda. No servers, scales automatically, pay-per-request.

### C. Event-driven data pipeline
Producers → Kinesis (ingest stream) → Lambda (transform) → S3 (data lake, raw + processed) → Redshift (via COPY, for analytics) → QuickSight (dashboards).

### D. Decoupled order processing
API Gateway → Lambda (validates + writes order to DynamoDB) → DynamoDB Streams → Lambda (triggers) → SNS topic → fan-out to: SQS queue for fulfillment service, SQS queue for notification service, SQS queue for analytics ingestion. Each downstream service processes independently and at its own pace; a slow analytics consumer doesn't block fulfillment.

---

## 13. Quick-Fire Comparison Table (for rapid recall)

| Need | Service |
|---|---|
| VM-based compute | EC2 |
| Event-driven, short-lived compute | Lambda |
| Long-running containers, low ops | ECS/EKS + Fargate |
| Object storage, static assets | S3 |
| Block storage for one instance | EBS |
| Shared file storage across instances | EFS |
| Relational DB, managed | RDS/Aurora |
| NoSQL, massive scale, low latency | DynamoDB |
| In-memory cache | ElastiCache |
| Data warehouse / analytics | Redshift |
| Point-to-point async task queue | SQS |
| Fan-out pub/sub | SNS |
| Content-based event routing | EventBridge |
| Real-time ordered streaming, replayable | Kinesis |
| CDN | CloudFront |
| DNS + routing policies | Route 53 |
| L7 load balancing | ALB |
| L4 load balancing | NLB |
| API front door for Lambda/services | API Gateway |
| IaC (AWS-native) | CloudFormation |
| Secrets storage/rotation | Secrets Manager |
| Encryption key management | KMS |
| Audit log of API calls | CloudTrail |
| Metrics/alarms/logs | CloudWatch |
