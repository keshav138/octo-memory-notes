**The mental model**

Kubernetes says _"here's what I want running"_. Terraform says _"here's what infrastructure I want to exist"_ — cloud resources like VMs, networks, databases, DNS records. You write it once, Terraform figures out what to create, update, or delete.

---

**The 3 core concepts**

**Provider** — which cloud/service you're talking to. AWS, Azure, GCP, even GitHub. Terraform needs to know this first.

**Resource** — the actual thing you want to create. A VM, a bucket, a database.

**Output** — values you want printed after apply. Like an IP address of the VM you just created.

---

**The structure of every Terraform file**

```hcl
# 1. Tell Terraform which provider to use
provider "aws" {
  region = "us-east-1"
}

# 2. Define a resource
resource "aws_instance" "my_server" {    # resource "TYPE" "NAME"
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

# 3. Output something useful after apply
output "server_ip" {
  value = aws_instance.my_server.public_ip
}
```

---

**Breaking down `resource "aws_instance" "my_server"`**

```
resource  "aws_instance"         "my_server"
   │            │                     │
fixed       resource type          arbitrary
keyword    (aws decides this)     (your name for it)
```

`aws_instance` is not arbitrary — it's a type defined by the AWS provider. `my_server` is completely arbitrary, it's just how you reference this resource elsewhere in your code.

---

**Referencing one resource inside another**

This is the key pattern — `TYPE.NAME.ATTRIBUTE`:

```hcl
resource "aws_security_group" "my_sg" {
  name = "allow-http"
}

resource "aws_instance" "my_server" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_sg.id]  # referencing above
}
```

Terraform also figures out the **order** automatically from these references — it knows to create the security group before the instance.

---

**Variables — so you're not hardcoding everything**

```hcl
variable "instance_type" {
  default = "t2.micro"
}

resource "aws_instance" "my_server" {
  instance_type = var.instance_type    # using the variable
}
```

---

**The 3 commands you need**

```bash
terraform init      # downloads the provider plugins (like npm install)
terraform plan      # dry run — shows what will be created/changed/destroyed
terraform apply     # actually does it, asks for confirmation
terraform destroy   # tears everything down
```

`plan` before `apply` is the habit to build — it's your diff before committing.

---

**Arbitrary vs not arbitrary**

```hcl
provider "aws" {          # "aws" — NOT arbitrary, must match provider name
  region = "us-east-1"   # value — arbitrary (valid AWS region though)
}

resource "aws_instance" "my_server" {
#         └── NOT arbitrary       └── arbitrary, your reference name
  ami           = "ami-xxx"   # NOT arbitrary — must be a real AMI ID
  instance_type = "t2.micro"  # NOT arbitrary — must be a valid instance type
}
```

The resource **type** always comes from the provider's documentation. The resource **name** is always yours to choose, and becomes how you reference it elsewhere as `aws_instance.my_server`.

---

**File structure for a real project**

Terraform doesn't enforce this but convention is:

```
project/
├── main.tf          # resources
├── variables.tf     # variable definitions
├── outputs.tf       # outputs
└── terraform.tfvars # actual values for variables (like .env)
```

You can put everything in one `.tf` file and it works — Terraform reads all `.tf` files in the directory together.