Perfect — let's move from local Docker to **AWS EC2 with Terraform**. Same Flask app, but now running on a real cloud VM.

---

# Part 1: AWS Setup Prerequisites (5 minutes)

## 1. Create AWS Account & IAM User

If you don't have AWS access:

1. Go to [aws.amazon.com](https://aws.amazon.com) → Create account (free tier)
2. Go to IAM → Users → Create user (e.g., `terraform-user`)
3. Attach policy: `AdministratorAccess` (for learning; restrict later)
4. Create access key → Download CSV (store safely)

## 2. Configure AWS credentials on Windows

```powershell
# Install AWS CLI
winget install --id Amazon.AWSCLI

# Configure credentials
aws configure
# Enter:
# - Access Key ID (from CSV)
# - Secret Access Key (from CSV)
# - Region: us-east-1 (or your preferred)
# - Output format: json
```

Verify:
```powershell
aws sts get-caller-identity
# Should show your account details
```

## 3. Create an SSH Key Pair (to access EC2)

```powershell
# Generate key pair (replace with your key name)
aws ec2 create-key-pair --key-name terraform-flask-key --query 'KeyMaterial' --output text > terraform-flask-key.pem

# Secure the key (Windows PowerShell)
icacls terraform-flask-key.pem /inheritance:r /grant:r "${env:USERNAME}:R"
```

---

# Part 2: Terraform on Windows (Direct Installation)

Instead of Docker for AWS, install Terraform directly (easier for cloud):

```powershell
# Using Chocolatey (or download manually)
choco install terraform

# Or download from: https://developer.hashicorp.com/terraform/downloads
# Add to PATH manually

# Verify
terraform -version
```

**Alternative**: Keep using Docker if you prefer:

```powershell
# Same alias but with AWS credentials mounted
function tf {
  docker run --rm `
    -v ${PWD}:/workspace `
    -v ${env:USERPROFILE}/.aws:/root/.aws `
    -w /workspace `
    hashicorp/terraform:latest $args
}
```

---

# Part 3: Basic EC2 + Flask (User Data Script)

## Project Structure

```
C:\terraform-aws-flask\
├── main.tf
├── variables.tf
├── outputs.tf
└── user_data.sh
```

## Step 1: `main.tf` (AWS provider + EC2 + security group)

```hcl
# Configure AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Security group to allow SSH (port 22) and Flask (port 5000)
resource "aws_security_group" "flask_sg" {
  name        = "flask-sg-${var.environment}"
  description = "Allow SSH and Flask traffic"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow from anywhere (restrict in production)
  }

  # Flask app access
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "flask-sg-${var.environment}"
    Environment = var.environment
  }
}

# Get the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 instance
resource "aws_instance" "flask_app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.flask_sg.id]

  # User data script (runs on first boot)
  user_data = file("${path.module}/user_data.sh")

  # User data script is bash, must start with shebang
  user_data_replace_on_change = true

  tags = {
    Name        = "flask-app-${var.environment}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Elastic IP (optional - gives fixed public IP)
resource "aws_eip" "flask_eip" {
  instance = aws_instance.flask_app.id
  domain   = "vpc"

  tags = {
    Name = "flask-eip-${var.environment}"
  }
}
```

## Step 2: `variables.tf`

```hcl
variable "aws_region" {
  description = "AWS region to deploy"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"  # Free tier eligible
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "terraform-flask-key"
}
```

## Step 3: `outputs.tf`

```hcl
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.flask_app.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.flask_app.public_dns
}

output "flask_app_url" {
  description = "URL to access the Flask app"
  value       = "http://${aws_instance.flask_app.public_ip}:5000"
}

output "elastic_ip" {
  description = "Elastic IP (fixed IP)"
  value       = aws_eip.flask_eip.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.flask_app.public_ip}"
}
```

## Step 4: `user_data.sh` (bootstrap script)

```bash
#!/bin/bash
set -e  # Exit on error

# Update system
apt-get update -y

# Install Docker
apt-get install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu

# Create a simple Flask app directory
mkdir -p /home/ubuntu/flask-app
cat > /home/ubuntu/flask-app/app.py << 'EOF'
from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    hostname = socket.gethostname()
    return f"""
    <html>
        <body>
            <h1>Hello from Terraform-managed Flask!</h1>
            <p>Instance: {hostname}</p>
            <p>Environment: {os.getenv('ENVIRONMENT', 'unknown')}</p>
        </body>
    </html>
    """

@app.route('/health')
def health():
    return "OK", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# Create Dockerfile
cat > /home/ubuntu/flask-app/Dockerfile << 'EOF'
FROM python:3.9-slim
WORKDIR /app
COPY app.py .
RUN pip install flask
ENV ENVIRONMENT=prod
EXPOSE 5000
CMD ["python", "app.py"]
EOF

# Build and run Docker container
cd /home/ubuntu/flask-app
docker build -t flask-app .
docker run -d -p 5000:5000 --name flask-container --restart always flask-app

# Output success message (will appear in EC2 console logs)
echo "Flask app deployed successfully!"
```

---

# Part 4: Running Terraform Commands

## Initialize Terraform

```powershell
cd C:\terraform-aws-flask
terraform init
```

Expected output:
```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws v5.whatever...
Terraform has been successfully initialized!
```

## Preview changes

```powershell
terraform plan
```

You'll see:
```
Plan: 4 to add, 0 to change, 0 to destroy.
- aws_eip.flask_eip
- aws_instance.flask_app
- aws_security_group.flask_sg
- data.aws_ami.ubuntu
```

## Apply (deploy infrastructure)

```powershell
terraform apply
```

Type `yes` when prompted.

Wait 2-3 minutes for EC2 to launch and user_data to run.

## Check outputs

```powershell
terraform output
```

Example output:
```
elastic_ip = "54.123.45.67"
flask_app_url = "http://54.123.45.67:5000"
instance_public_ip = "54.123.45.67"
ssh_command = "ssh -i terraform-flask-key.pem ubuntu@54.123.45.67"
```

## Test the Flask app

Open browser to: `http://<your-instance-ip>:5000`

You should see:
```
Hello from Terraform-managed Flask!
Instance: ip-172-31-XXX
Environment: prod
```

## SSH into the instance (optional)

```powershell
ssh -i terraform-flask-key.pem ubuntu@<public-ip>

# Check Docker container
docker ps
docker logs flask-container
```

---

# Part 5: Make Changes and Re-apply

## Change 1: Update instance type

Edit `terraform.tfvars` (create this file):

```hcl
instance_type = "t3.micro"
environment   = "dev"
```

Apply:
```powershell
terraform apply
```

Terraform will show: `aws_instance.flask_app must be replaced` (instance type change requires recreation).

## Change 2: Update user_data to change Flask message

Edit `user_data.sh`, change the message. Then:

```powershell
terraform apply
```

Only user_data changed → Terraform will **replace** the instance (since `user_data_replace_on_change = true`).

---

# Part 6: Add Variables File (Best Practice)

Create `terraform.tfvars`:

```hcl
aws_region    = "us-east-1"
environment   = "dev"
instance_type = "t2.micro"
key_name      = "terraform-flask-key"
```

Now you can just run:
```powershell
terraform apply -auto-approve   # Uses terraform.tfvars automatically
```

For different environments:
```powershell
# Create separate var files
terraform apply -var-file="dev.tfvars"
terraform apply -var-file="prod.tfvars"
```

---

# Part 7: Destroy Everything (Important!)

```powershell
terraform destroy
# Type 'yes'
```

This removes:
- EC2 instance
- Elastic IP (released)
- Security group

**Always destroy** after practice to avoid AWS charges.

Check AWS Console to confirm everything is gone.

---

# Part 8: What You've Accomplished

```
✅ AWS credentials configured on Windows
✅ Terraform initialized with AWS provider
✅ Security group created (SSH + Flask ports)
✅ EC2 instance launched with Ubuntu
✅ Bootstrap script installed Docker + Flask
✅ Flask app running in container
✅ Elastic IP assigned
✅ Outputs displayed
✅ Infrastructure destroyed
```

---

# Part 9: Common Issues & Fixes

| Problem | Solution |
|---------|----------|
| `Error: No valid credential sources` | Run `aws configure` again |
| `InvalidKeyPair.NotFound` | Create key pair or check name spelling |
| `Instance limit exceeded` | Delete old instances or request limit increase |
| `Permission denied (public key)` | Wrong key or `chmod 400` on .pem file |
| `Connection refused` on port 5000 | Wait 2-3 min for user_data to finish |
| `terraform init` fails | Check internet/DNS or run as admin |
| `terraform apply` takes forever | t2.micro can be slow; normal |

---

# Part 10: Quick Commands Reference

```powershell
# Terraform lifecycle
terraform init                     # Setup providers
terraform validate                 # Check syntax
terraform plan                     # Preview
terraform apply                    # Deploy
terraform apply -auto-approve      # Skip confirmation
terraform destroy                  # Delete all
terraform destroy -auto-approve

# State management
terraform state list               # All resources
terraform state show aws_instance.flask_app  # Details
terraform refresh                  # Sync state with real resources

# Outputs
terraform output
terraform output instance_public_ip

# Debugging (verbose)
TF_LOG=DEBUG terraform apply
```

---

# Part 11: Next Steps (Your Path)

Now that EC2 is working:

1. **Add a database** (RDS PostgreSQL for Flask)
2. **Add a load balancer** (ALB in front of multiple Flask instances)
3. **Use Terraform modules** (reuse your config)
4. **Remote state** (store terraform.tfstate in S3)
5. **Integrate with Jenkins** (automated plan/apply)

---

# Practice Exercises

## Exercise 1: Deploy with different name
Change `environment` variable to `staging` → Terraform creates **new** isolated resources.

## Exercise 2: Add a second EC2 instance
Use `count` meta-argument:

```hcl
resource "aws_instance" "flask_app" {
  count = 2
  # ... rest same
}
```

## Exercise 3: Output the private IPs
Add to `outputs.tf`:
```hcl
output "private_ips" {
  value = aws_instance.flask_app[*].private_ip
}
```

## Exercise 4: Add a simple variable validation
```hcl
variable "instance_type" {
  validation {
    condition     = contains(["t2.micro", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Instance type must be one of: t2.micro, t3.micro, t3.small"
  }
}
```

---

**You're now running a Flask app on AWS EC2, fully managed by Terraform!**

Ready to:
1. Add RDS database to this setup?
2. Move to Jenkins pipeline to auto-deploy?
3. Or add a load balancer for multiple instances?