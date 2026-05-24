### Terraform files

Create these inside your `terraform/` folder:

---

### `terraform/main.tf`

```hcl
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

# security group
resource "aws_security_group" "financial_rag_sg" {
  name        = "financial-rag-sg"
  description = "Security group for Financial RAG app"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # FastAPI
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Prometheus
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Grafana
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# key pair
resource "aws_key_pair" "financial_rag_key" {
  key_name   = "financial-rag-key"
  public_key = file(var.public_key_path)
}

# EC2 instance
resource "aws_instance" "financial_rag" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.financial_rag_key.key_name
  vpc_security_group_ids = [aws_security_group.financial_rag_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io docker-compose
    systemctl start docker
    systemctl enable docker

    # create app directory
    mkdir -p /app
    cd /app

    # create .env file
    cat > .env <<ENVFILE
    GROQ_API_KEY=${var.groq_api_key}
    HUGGINGFACEHUB_API_TOKEN=${var.hf_token}
    CHROMA_PERSIST_DIR=./chroma_db
    COLLECTION_NAME=financial_docs
    ENVFILE

    # create docker-compose.yml pulling from Docker Hub
    cat > docker-compose.yml <<COMPOSEFILE
    version: "3.8"
    services:
      app:
        image: ${var.dockerhub_image}
        ports:
          - "8000:8000"
        volumes:
          - ./chroma_db:/app/chroma_db
        env_file:
          - .env

      prometheus:
        image: prom/prometheus:latest
        ports:
          - "9090:9090"
        volumes:
          - ./prometheus.yml:/etc/prometheus/prometheus.yml
        command:
          - "--config.file=/etc/prometheus/prometheus.yml"

      grafana:
        image: grafana/grafana:latest
        ports:
          - "3000:3000"
        environment:
          - GF_SECURITY_ADMIN_PASSWORD=admin
          - GF_SECURITY_ADMIN_USER=admin
        depends_on:
          - prometheus
    COMPOSEFILE

    # create prometheus config
    cat > prometheus.yml <<PROMFILE
    global:
      scrape_interval: 15s
    scrape_configs:
      - job_name: "financial-rag"
        static_configs:
          - targets: ["app:8000"]
    PROMFILE

    # pull and start
    docker-compose up -d
  EOF

  tags = {
    Name = "financial-rag-server"
  }
}
```

---

### `terraform/variables.tf`

```hcl
variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS - ap-south-1"
  default     = "ami-0f58b397bc5c1f2e8"
}

variable "public_key_path" {
  description = "Path to your local SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "groq_api_key" {
  description = "Groq API key"
  sensitive   = true
}

variable "hf_token" {
  description = "HuggingFace token"
  sensitive   = true
}

variable "dockerhub_image" {
  description = "Docker Hub image to deploy"
  default     = "keshavmaiya/financial-rag:latest"
}
```

---

### `terraform/outputs.tf`

```hcl
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.financial_rag.public_ip
}

output "app_url" {
  description = "Financial RAG API URL"
  value       = "http://${aws_instance.financial_rag.public_ip}:8000"
}

output "grafana_url" {
  description = "Grafana URL"
  value       = "http://${aws_instance.financial_rag.public_ip}:3000"
}
```

---

### `terraform/terraform.tfvars`

```hcl
groq_api_key    = "your_groq_api_key"
hf_token        = "your_hf_token"
dockerhub_image = "keshavmaiya/financial-rag:latest"
```

Add this to `.gitignore` immediately — it has secrets:

```gitignore
terraform/terraform.tfvars
terraform/.terraform/
terraform/*.tfstate
terraform/*.tfstate.backup
```

---

### SSH key — generate if you don't have one

```powershell
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

---

### Run it

```powershell
cd terraform
terraform init
terraform plan    # preview what gets created
terraform apply   # actually create it, type 'yes' when prompted
```

After apply finishes it'll output your EC2 public IP. App takes ~3-4 minutes to start on the instance (Docker pulling images).

Then hit:

```
http://EC2_IP:8000/docs
http://EC2_IP:3000  (Grafana)
```

Let me know what you get.