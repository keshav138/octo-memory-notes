# Terraform – Complete Notes for Practice

## 1. What is Infrastructure as Code (IaC)?

**IaC** = managing and provisioning infrastructure (servers, networks, VMs, load balancers, databases) using machine-readable definition files instead of manual processes or interactive configuration tools.

**Benefits**:
- Version control for infrastructure
- Repeatability and consistency
- Automation-friendly (CI/CD)
- Auditability and documentation

**Two approaches**:
- **Declarative** (What → Terraform, CloudFormation)  
- **Imperative** (How → CLI scripts, SDKs)

Terraform is **declarative** – you define the **desired state**, Terraform figures out how to achieve it.

---

## 2. Terraform Core Concepts

| Concept | Meaning |
|---------|---------|
| **Provider** | Plugin to interact with cloud/platform (AWS, GCP, Azure, etc.) |
| **Resource** | A single infrastructure component (e.g., EC2 instance, S3 bucket) |
| **Data Source** | Query existing infrastructure info |
| **Variable** | Input parameter to a Terraform config |
| **Output** | Return value from a Terraform config |
| **State** | Snapshot of actual deployed infrastructure (Terraform tracks it) |
| **Module** | Reusable container of multiple resources |
| **Backend** | Where Terraform stores state (local or remote like S3) |

---

## 3. Installation & Setup

### Install Terraform (macOS/Linux/WSL)
```bash
# macOS
brew install terraform

# Linux (example)
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Verify
terraform -v
```

### Cloud CLI (example: AWS)
```bash
aws configure   # set access key, secret, region
```

---

## 4. Terraform Workflow (Basic)

```bash
terraform init      # download provider plugins
terraform plan      # preview changes
terraform apply     # create/update infrastructure
terraform destroy   # delete everything
```

---

## 5. Writing Your First Terraform Script (AWS + Flask App)

We’ll launch an EC2 instance, install Docker, and run a simple Flask app inside a container.

### Step 1: Project structure
```
flask-terraform/
├── main.tf
├── variables.tf
├── outputs.tf
└── user_data.sh
```

### Step 2: `main.tf`

```hcl
# Configure AWS provider
provider "aws" {
  region = var.aws_region
}

# Security group to allow HTTP (port 5000 for Flask) and SSH
resource "aws_security_group" "flask_sg" {
  name        = "flask-sg"
  description = "Allow Flask and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Fetch latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# EC2 instance
resource "aws_instance" "flask_app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.flask_sg.id]
  key_name               = var.key_name   # your existing AWS key pair

  user_data = file("user_data.sh")

  tags = {
    Name = "flask-docker-instance"
  }
}
```

### Step 3: `variables.tf`

```hcl
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of your EC2 key pair"
}
```

### Step 4: `outputs.tf`

```hcl
output "instance_public_ip" {
  value = aws_instance.flask_app.public_ip
}

output "flask_app_url" {
  value = "http://${aws_instance.flask_app.public_ip}:5000"
}
```

### Step 5: `user_data.sh` (bootstrap script)

```bash
#!/bin/bash
# Install Docker
apt update -y
apt install -y docker.io
systemctl start docker
systemctl enable docker

# Run a Flask app container
docker run -d -p 5000:5000 --name flask-app \
  -e FLASK_ENV=production \
  python:3.9-slim \
  sh -c "pip install flask && \
         echo 'from flask import Flask; app = Flask(__name__); @app.route(\"/\") def home(): return \"Hello from Flask on Terraform!\"; if __name__ == \"__main__\": app.run(host=\"0.0.0.0\", port=5000)' > app.py && \
         python app.py"
```

> 💡 **Note**: For real apps, you’d build a Docker image locally and push to ECR/Docker Hub. The above keeps it self-contained for learning.

### Step 6: Deploy

```bash
terraform init
terraform plan -var="key_name=your-key-name"
terraform apply -var="key_name=your-key-name" -auto-approve

# Get the IP from outputs
curl http://<public-ip>:5000   # Should see "Hello from Flask on Terraform!"
```

### Step 7: Cleanup

```bash
terraform destroy -var="key_name=your-key-name" -auto-approve
```

---

## 6. Terraform State Management

- **Local state**: `terraform.tfstate` (not suitable for teams)
- **Remote state** (recommended for CI/CD)

### Remote state with AWS S3 + DynamoDB (locking)

```hcl
# backend.tf
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "flask-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

Then run:
```bash
terraform init -reconfigure
```

---

## 7. Terraform Variables & Best Practices

### Variable precedence (high to low):
1. `-var` or `-var-file` CLI flag
2. `terraform.tfvars` or `*.auto.tfvars`
3. Environment variables (TF_VAR_name)
4. Variable defaults

### Example `terraform.tfvars`:

```hcl
aws_region    = "us-west-2"
instance_type = "t3.small"
key_name      = "jenkins-key"
```

### Sensitive variables:
```hcl
variable "db_password" {
  sensitive = true
}
```

---

## 8. Data Sources & Dependencies

**Data source** = query external info (like existing AMI, VPC, subnet)

```hcl
data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "main" {
  vpc_id = data.aws_vpc.default.id
  # ...
}
```

**Explicit dependency**:
```hcl
resource "aws_instance" "app" {
  depends_on = [aws_db_instance.main]
}
```

---

## 9. Terraform Modules

Reusable logic.

### Module structure:
```
modules/
  flask-server/
    main.tf
    variables.tf
    outputs.tf
```

### Using a module:

```hcl
module "flask_dev" {
  source = "./modules/flask-server"
  
  instance_type = "t2.micro"
  key_name      = "dev-key"
}

module "flask_prod" {
  source = "./modules/flask-server"
  
  instance_type = "t3.medium"
  key_name      = "prod-key"
}
```

### Public module (Terraform Registry):
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  
  name = "flask-vpc"
  cidr = "10.0.0.0/16"
}
```

---

## 10. Terraform Functions & Meta-arguments

### Common functions:
```hcl
# String & collection
join(",", ["a", "b", "c"])   # "a,b,c"
split(",", "a,b,c")          # ["a", "b", "c"]
length(var.list)

# Lookup
lookup(var.map, "key", "default")

# File
file("user_data.sh")
```

### Meta-arguments:
- `count` – create multiple resources

```hcl
resource "aws_instance" "app" {
  count = 3
  ami   = "..."
}
```

- `for_each` – for maps/sets

```hcl
resource "aws_instance" "app" {
  for_each = toset(["web1", "web2"])
  tags = { Name = each.key }
}
```

- `lifecycle` – control behavior

```hcl
lifecycle {
  create_before_destroy = true
  prevent_destroy       = true   # protect resource
  ignore_changes        = [ami]  # don't redeploy on AMI change
}
```

---

## 11. Terraform with Flask App (Better Example – Manual Docker Build)

Instead of inline script, build locally and push to ECR:

```hcl
# Build & push Docker image (using external data or null_resource)
resource "aws_ecr_repository" "flask_repo" {
  name = "flask-app"
}

# Then in user_data
user_data = <<-EOF
  #!/bin/bash
  aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.flask_repo.repository_url}
  docker pull ${aws_ecr_repository.flask_repo.repository_url}:latest
  docker run -d -p 5000:5000 ${aws_ecr_repository.flask_repo.repository_url}:latest
EOF
```

---

## 12. Hands-on Practice Exercises (Flask Focus)

### Exercise 1: Launch Flask on EC2 with Terraform (done above)

### Exercise 2: Add an RDS PostgreSQL database for Flask

```hcl
resource "aws_db_instance" "flask_db" {
  engine         = "postgres"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  db_name        = "flaskdb"
  username       = var.db_user
  password       = var.db_password
  skip_final_snapshot = true
}

output "db_endpoint" {
  value = aws_db_instance.flask_db.endpoint
}
```

Then modify Flask app to use environment variables for DB connection.

### Exercise 3: Create an Application Load Balancer (ALB) in front of two Flask instances

```hcl
resource "aws_lb" "flask_alb" {
  name = "flask-alb"
  internal = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.default.ids
}

resource "aws_lb_target_group" "flask_tg" {
  port = 5000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.flask_alb.arn
  port = 80
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.flask_tg.arn
  }
}
```

### Exercise 4: Parameterize environment (dev/staging/prod) using `terraform workspaces`

```bash
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev
terraform apply -var-file="dev.tfvars"
```

---

## 13. Terraform + Jenkins Preview (What’s Next)

In Jenkins pipeline, you’ll do:

```groovy
stage('Terraform') {
  steps {
    sh 'terraform init'
    sh 'terraform apply -auto-approve'
  }
}
```

With remote state, Jenkins can:
- Plan on PR  
- Apply on merge to main  
- Destroy on branch deletion  

---

## 14. Common Errors & Fixes

| Error | Fix |
|-------|-----|
| `Invalid credentials` | Run `aws configure` again |
| `Backend bucket not found` | Create S3 bucket manually first |
| `State lock conflict` | Delete DynamoDB lock or wait |
| `Resource already exists` | Import into state: `terraform import aws_instance.foo i-123` |

---

## 15. Quick Reference – Commands

```bash
terraform init                # init providers & modules
terraform plan                # dry run
terraform apply               # deploy
terraform destroy             # delete all
terraform fmt                 # format code
terraform validate            # check syntax
terraform state list          # show managed resources
terraform state show <res>    # details
terraform output              # show outputs
terraform import <res> <id>   # bring existing resource under Terraform
```

---

## Next Step After Terraform

You can now:
1. Write Terraform to set up a Flask app environment (EC2 + RDS + ALB)  
2. Store state remotely (S3 + DynamoDB)  
3. Parameterize for dev/prod  
4. Then **integrate Terraform into a Jenkins pipeline** (next topic)

Would you like me to next cover **Jenkins pipeline setup with Terraform** (including GitHub triggers, approvals, and AWS credentials handling)?