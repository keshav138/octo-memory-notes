# Cloud Economics – What Every Engineer Must Know

Not a pricing sheet. This is **how to think about cloud costs** so you don't get a surprise bill and can make intelligent trade-offs.

---

## Part 1: The Mental Shift (Most Important)

### Traditional IT (On-Premise)
```
Buy servers → Pay upfront → Depreciate over 3-5 years → Run 24/7 whether used or not
```

### Cloud
```
Pay as you go → No upfront → Variable cost → Scale up/down → Pay only for what you use
```

**The trap**: Cloud can be cheaper OR more expensive than on-prem. It depends entirely on **how you use it**.

| Scenario | On-Prem Wins | Cloud Wins |
|----------|--------------|-------------|
| Steady 24/7 workload | ✓ (once depreciated) | |
| Spiky traffic (e.g., retail holiday) | | ✓ |
| Unknown demand | | ✓ |
| Need to move fast | | ✓ |
| Predictable, constant load | ✓ | |

---

## Part 2: The 4 Pillars of Cloud Pricing

### 1. Compute (EC2, Lambda, Beanstalk)

**EC2 Pricing Models** (most important to understand):

| Model | How It Works | Best For | Discount vs On-Demand |
|-------|--------------|----------|----------------------|
| **On-Demand** | Pay by the second/hour | Development, unpredictable workloads | 0% (baseline) |
| **Reserved Instances (RI)** | Commit to 1 or 3 years | Steady-state apps (web servers, databases) | Up to 72% |
| **Spot Instances** | Bid for unused capacity (can be terminated anytime) | Batch jobs, stateless processing, CI/CD | Up to 90% |
| **Savings Plans** | Commit to $/hour spend (flexible across instance families) | Mixed workloads | Up to 66% |

**Real example**:
- On-Demand t3.micro: ~$0.0104/hour (~$7.50/month)
- 3-year RI (all upfront): ~$0.003/hour (~$2.20/month) → **70% savings**

**Critical**: A t3.micro running 24/7 costs ~$90/year. A forgotten test environment costs real money.

**Lambda Pricing**:
```
Cost = (Number of requests × $0.20 per million) + (GB-seconds × $0.00001667)

Example: 1 million requests, 128MB memory, 100ms each
= $0.20 (requests) + $0.21 (compute) = ~$0.41
```

### 2. Storage (S3, EBS, RDS)

**S3 Storage Tiers** (same data, different access patterns):

| Tier | Use Case | Price/GB/month | Retrieval cost |
|------|----------|----------------|----------------|
| S3 Standard | Frequent access | $0.023 | Free (instant) |
| S3 Intelligent-Tiering | Unknown pattern | $0.023 + monitoring | Free |
| S3 Standard-IA | Infrequent (backups) | $0.0125 | Per GB retrieval |
| S3 Glacier (Archive) | Long-term compliance | $0.004 | Hours to retrieve |
| S3 Glacier Deep Archive | 10+ year retention | $0.00099 | 12-48 hours |

**EBS (EC2 hard drives)**:
- gp3 (SSD general purpose): ~$0.08/GB-month
- io2 (high performance): ~$0.125/GB-month + IOPS charges

**RDS (Databases)**:
- Storage: ~$0.10-0.30/GB-month
- IOPS: Additional if provisioned
- Backup storage: Usually includes 100% of DB size free

### 3. Data Transfer (The Hidden Trap)

**This is where surprises happen**:

| Transfer Direction | Cost |
|--------------------|------|
| Within same region, same AZ | Free |
| Within same region, different AZ | ~$0.01/GB |
| EC2 → Internet (outbound) | $0.09-0.15/GB (first 1GB free) |
| CloudFront → Internet | $0.085/GB (cheaper than direct) |
| Between regions | $0.02/GB |

**Real trap**: Moving 100GB from S3 to EC2 in different AZ costs $1. Doing it 1000 times (automated job) = $1000.

### 4. Managed Services Markup

Paying for convenience:
- Running own PostgreSQL on EC2: Cheaper but more work
- RDS (managed PostgreSQL): ~50-100% premium
- ElastiCache (managed Redis): ~30-50% premium

**Rule**: Use managed services when engineer time > cloud markup.

---

## Part 3: Total Cost of Ownership (TCO)

### What TCO Actually Means

TCO = All costs of running your workload over X years

**On-Prem TCO**:
```
Hardware + Software licenses + Facilities (power, cooling, space)
+ People (sysadmins, network, storage) + Maintenance contracts
+ Opportunity cost (time to provision)
```

**Cloud TCO**:
```
Compute + Storage + Data Transfer + Managed Services
+ People (fewer ops, more development)
+ Opportunity benefit (faster time to market)
```

### The 5-Year TCO Comparison (Simplified)

| Cost Component | On-Prem ($) | Cloud ($) |
|----------------|-------------|-----------|
| Servers (50 VMs) | 150,000 | 0 |
| Networking gear | 30,000 | 0 |
| Power/cooling | 20,000/year | 0 |
| Sysadmins (2 people) | 240,000/year | 80,000/year (1 person) |
| Cloud compute (on-demand) | 0 | 72,000/year |
| Cloud storage | 0 | 12,000/year |
| **5-Year Total** | ~$2.2M | ~$1.1M |

**But**: If you run those 50 VMs 24/7 with Reserved Instances, cloud TCO drops to ~$800k.

**The point**: Cloud TCO is **engineer-dependent**. Poorly architectured cloud costs more than on-prem.

---

## Part 4: Billing Fundamentals

### How AWS Billing Works

**The Hierarchy**:
```
Master Account (Enterprise)
  └── Linked Account 1 (Development)
  └── Linked Account 2 (Staging)
  └── Linked Account 3 (Production)
```

**Consolidated Billing** (for organizations):
- One bill for all accounts
- Volume discounts across accounts
- Reserved Instances shared across accounts

### Common Billing Surprises

**Surprise 1: Unattached resources**
```powershell
# These cost money even if not used:
- Unattached EBS volumes (~$0.10/GB-month)
- Unused Elastic IPs (~$0.005/hour)
- Idle load balancers (~$0.0225/hour)
- Old snapshots (EBS, RDS)
- Unused NAT Gateways (~$0.045/hour)
```

**Surprise 2: Data egress from monitoring**
- CloudWatch logs: $0.50/GB ingested
- VPC Flow Logs: $0.50/GB
- X-Ray tracing: $5 per million traces

**Surprise 3: Support plans**
- Basic: Free
- Developer: $29/month (or 3% of monthly usage)
- Business: $100/month (or 10% of monthly usage)
- Enterprise: $15,000/month

### AWS Cost Explorer (Your Best Friend)

You can view:
- Cost by service (EC2, S3, RDS, etc.)
- Cost by region
- Cost by tag (`Environment=Production` vs `Development`)
- Forecast next month's bill

---

## Part 5: Cost Optimization Strategies

### The 5 Levers You Can Pull

**1. Right-size instances**
- Most over-provisioned resource in cloud
- Start small, monitor CPU/memory, scale up only if needed
- Tool: AWS Compute Optimizer (free recommendations)

**2. Use Savings Plans / Reserved Instances**
- For steady workloads: Buy 1-year RI immediately
- Break-even is usually 3-6 months

**3. Implement Auto Scaling**
- Run 1 instance at night, 10 during peak hours
- Instead of 10 instances 24/7

**4. Use Spot Instances for fault-tolerant workloads**
- Batch processing, CI/CD runners, container orchestration nodes
- Can save 70-90%

**5. Delete unused resources**
- Tag everything with `ExpirationDate`
- Automate deletion of test environments after hours

### Architecture Choices That Affect Cost

| Choice | Cheaper | More Expensive |
|--------|---------|----------------|
| Database | Self-managed on EC2 | RDS Aurora |
| Container orchestration | ECS with Spot | EKS (control plane costs) |
| File storage | EBS (single AZ) | EFS (multi-AZ) |
| Load balancing | Application LB (per hour) | Network LB (similar) |
| CDN | CloudFront | Direct S3 + Internet |

### Real-World Optimization Example

**Bad**:
- 10 t3.large EC2 (4GB RAM each) running 24/7
- RDS db.m5.large (8GB RAM) Multi-AZ
- No auto scaling
- 100GB data transfer/month

**Cost**: ~$1,200/month

**Optimized**:
- Auto scaling: 2-10 instances based on CPU
- Switch from t3.large to t3.medium (2GB RAM is enough)
- RDS: Switch to single-AZ, add read replica only if needed
- Add CloudFront for static assets

**New cost**: ~$400/month

---

## Part 6: Free Tier (Your Learning Budget)

### Always-Free Services
- Lambda: 1 million requests/month
- DynamoDB: 25GB storage, 25 write units
- CloudWatch: 10 metrics, 5GB logs
- SQS: 1 million requests
- SNS: 1 million publishes

### 12-Month Free Tier (new accounts)
- EC2: 750 hours/month t2.micro
- RDS: 750 hours/month db.t2.micro
- S3: 5GB standard storage
- CloudFront: 50GB data transfer
- ELB: 750 hours

### After Free Tier Expires (Personal projects)
- Small t4g.nano EC2: ~$3/month
- S3 for static site: <$0.50/month
- CloudFront: ~$1/month
- Route 53 (domain): $0.50/month for hosted zone

**Personal project budget**: $5-10/month is reasonable

---

## Part 7: Cost Monitoring Tools

### AWS Native Tools

**AWS Budgets** (set alerts):
```powershell
# Example: Alert when monthly spend exceeds $100
aws budgets create-budget \
    --account-id 123456789012 \
    --budget file://budget.json \
    --notifications-with-subscribers file://notifications.json
```

**Cost Anomaly Detection** (ML-based):
- Detects unusual spending patterns
- Example: 10x increase in data transfer
- Sends alert automatically

**AWS Cost and Usage Report (CUR)**:
- Most detailed (hourly, per-resource)
- Can query with Athena (SQL on your bill)
- Overkill for most, necessary for large orgs

### Third-Party (When you have >$10k/month spend)

- **CloudHealth** (VMware) – Industry standard
- **CloudCheckr** – Security + cost
- **Vantage** – Modern UI, developer-focused
- **OpenCost** – Open-source, Kubernetes focused

---

## Part 8: Cloud Economics Interview Questions (What You'll Be Asked)

### Q1: "How would you reduce our AWS bill by 30%?"

**Answer framework**:
1. Analyze current usage (Cost Explorer)
2. Check for idle resources (unused EBS, EIPs, old snapshots)
3. Add Reserved Instances/Savings Plans for steady workloads
4. Implement auto scaling for variable workloads
5. Use S3 storage tiers appropriately
6. Add CloudFront to reduce data transfer costs
7. Tag everything to allocate costs

### Q2: "Should we move our data warehouse to the cloud?"

**Answer**:
- Calculate TCO over 3-5 years
- Consider: Data transfer costs (if data stays in cloud)
- Factor: Engineer time (no more racking servers)
- Consider: Vendor lock-in (can you leave?)
- Look at: Workload pattern (24/7 querying vs sporadic)

### Q3: "Why did our bill double last month?"

**Likely causes**:
- Forgot to shut down test environment
- Data transfer spike (DDoS or misconfigured CDN)
- New feature increased compute usage
- Someone launched larger instances
- NAT Gateway running (forgotten)
- Old snapshots accumulating

---

## Part 9: Practical Cost Management Workflow

### Daily (if you're cost-conscious)
```bash
# Check today's spend so far
aws ce get-cost-and-usage --time-period Start=2024-01-01,End=2024-01-02 --granularity DAILY --metrics "UnblendedCost"
```

### Weekly
- Look for anomalies (10% increase vs previous week)
- Check for untagged resources
- Review each team's spend

### Monthly
- Run AWS Cost Explorer report
- Adjust Reserved Instances coverage
- Delete old snapshots and AMIs
- Review Savings Plan utilization

---

## Part 10: Cost Optimization Checklist (Keep This Handy)

### Compute
- [ ] Are we using Reserved Instances for steady workloads?
- [ ] Can any workloads run on Spot?
- [ ] Are instances right-sized? (Check CPU/memory utilization <40%)
- [ ] Auto scaling configured for dev/staging to turn off at night?
- [ ] Lambda memory configured correctly (not overallocated)

### Storage
- [ ] S3 lifecycle policies moving old data to Glacier?
- [ ] Deleting old EBS snapshots?
- [ ] EBS volumes attached? (detached = still pay)
- [ ] RDS backup retention reasonable? (default 7 days)

### Network
- [ ] CloudFront in front of S3/EC2?
- [ ] NAT Gateway needed? (costs $35/month + data)
- [ ] Inter-AZ traffic minimized?
- [ ] Unused Elastic IPs released?

### Database
- [ ] Multi-AZ needed for non-production?
- [ ] Read replicas actually used?
- [ ] Provisioned IOPS necessary?

### Monitoring & Management
- [ ] Old CloudWatch logs deleted?
- [ ] VPC Flow Logs turned off if not needed?
- [ ] Config rules simplified?

---

## Part 11: Real Horror Stories (So You Learn Without Pain)

**Horror 1: The Forgotten Load Balancer**
- Developer creates ALB for testing
- Forgets to delete
- 3 months later: $300 bill (ALB costs $0.0225/hour × 24 × 90)

**Horror 2: The Open S3 Bucket**
- Logging misconfigured, writes 10TB of logs
- Data transfer + storage = $1,500 surprise

**Horror 3: The CI/CD Runner**
- GitHub Actions triggers 1000 EC2 instances (Spot, fine)
- But forgets to terminate them
- 1000 t3.micro × 12 hours = $120 overnight

**Horror 4: Cross-Region Replication**
- Engineer sets up S3 replication between us-east-1 and ap-southeast-2
- Forgets it's on
- 50TB replicated = $1,000/month in transfer costs

**Lesson**: Always set up billing alerts before deploying anything.

---

## Part 12: Quick Reference Card

| Concept | One Sentence |
|---------|--------------|
| On-Demand | Pay full price, no commitment |
| Reserved Instance | Commit 1-3 years, save 60-70% |
| Spot Instance | Bid for unused capacity, save 90% (but can be killed) |
| Savings Plan | Commit to $/hour, flexible across families |
| Data Transfer | Most hidden cost — egress to internet costs |
| TCO | Total cost including people, power, software |
| T2/T3 Unlimited | Burstable CPUs — can cost extra if always maxed |
| Cost Explorer | UI to analyze spending patterns |
| Budgets | Set alerts before surprise bill |

---

## The Golden Rule of Cloud Economics

> **"The most expensive cloud resource is the one you forget to turn off."**

Your knowledge checklist after this:
- ✅ Can explain On-Demand vs Reserved vs Spot
- ✅ Know where hidden costs hide (data transfer, unattached resources)
- ✅ Can calculate basic TCO
- ✅ Know how to set billing alerts
- ✅ Have optimization strategies ready

**Next topic: Jenkins pipeline fundamentals? Or integrate Terraform + Jenkins for automated deployments?**