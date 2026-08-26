# AWS EC2 — Task 2: VPC, SSH & RDP Access

_Client machine: Windows. SSH uses the built-in OpenSSH client; RDP uses the built-in Remote Desktop Connection app (`mstsc`), with an IAM/SSM Fleet Manager fallback if direct RDP fails._

---

## Resource Reference

|Resource|Name|Notes|
|---|---|---|
|VPC|`demo-vpc`|CIDR: `10.0.0.0/16`|
|Public Subnet|`demo-public-subnet`|CIDR: `10.0.1.0/24`|
|Internet Gateway|`demo-igw`|Attached to VPC|
|Route Table|`demo-public-rt`|`0.0.0.0/0` → IGW|
|Security Group (SSH)|`ssh-web-sg`|SSH + HTTP inbound|
|Security Group (RDP)|`rdp-sg`|RDP inbound|
|Key Pair (Linux)|`ubuntu-key`|`.pem` — used to log in|
|Key Pair (Windows)|`windows-key`|`.pem` — used only to decrypt the admin password|

---

## Part A — Build the Shared Network (do once)

This VPC/subnet is reused by both the SSH and RDP instances.

1. **Create the VPC**
    - Console → VPC → **Create VPC** → _VPC only_
    - Name: `demo-vpc` · IPv4 CIDR: `10.0.0.0/16` · No IPv6 · Tenancy: Default
2. **Create the subnet**
    - VPC → Subnets → **Create subnet**
    - VPC: `demo-vpc` · Name: `demo-public-subnet` · AZ: No preference · CIDR: `10.0.1.0/24`
3. **Enable auto-assign public IP**
    - Select `demo-public-subnet` → Actions → Edit subnet settings → enable **Auto-assign public IPv4 address** → Save
4. **Create & attach the Internet Gateway**
    - VPC → Internet Gateways → **Create** → name `demo-igw` → create
    - Select it → Actions → **Attach to VPC** → `demo-vpc`
5. **Create & configure the route table**
    - VPC → Route Tables → **Create** → name `demo-public-rt` · VPC: `demo-vpc`
    - Open it → Routes tab → Edit routes → Add route: destination `0.0.0.0/0` → target `demo-igw` → Save
    - Subnet associations tab → Edit → associate `demo-public-subnet` → Save

✅ The public subnet now has a route to the internet.

---

## Part B — SSH Access (Ubuntu Instance)

### B1. Security group

- Security Groups → **Create security group**
- Name: `ssh-web-sg` · VPC: `demo-vpc`
- Inbound rules:

|Type|Protocol|Port|Source|
|---|---|---|---|
|SSH|TCP|22|My IP (recommended)|
|HTTP|TCP|80|0.0.0.0/0|

> ⚠️ Opening SSH to `0.0.0.0/0` exposes it to brute-force attempts — keep it restricted to **My IP**.

### B2. Key pair

- EC2 → Key Pairs → **Create key pair**
- Name: `ubuntu-key` · Type: RSA · Format: `.pem`
- The private key downloads once — store it safely (AWS keeps no copy).

### B3. Launch the instance

- EC2 → **Launch Instance** → Name: `ubuntu-web-server`
- AMI: Ubuntu Server 24.04 LTS (Free tier)
- Instance type: `t2.micro` / `t3.micro`
- Key pair: `ubuntu-key`
- Network settings → Edit: VPC `demo-vpc`, subnet `demo-public-subnet`, Auto-assign public IP: **Enable**
- Security group: `ssh-web-sg`
- Storage: default (8 GiB gp3) → **Launch instance**
- Wait for **Running** + **2/2 status checks passed**, then note the **Public IPv4 address**

### B4. Connect via SSH (Windows, built-in OpenSSH)

```powershell
cd \path\to\downloaded\key
icacls .\ubuntu-key.pem /inheritance:r
icacls .\ubuntu-key.pem /grant:r "$($env:USERNAME):(R)"
ssh -i ubuntu-key.pem ubuntu@<PUBLIC_IP_OR_DNS>
```

Type `yes` when prompted to accept the host fingerprint. Success looks like:

```
ubuntu@ip-10-0-1-XX:~$
```

📌 Default usernames by AMI: `ubuntu` (Ubuntu), `ec2-user` (Amazon Linux), `admin` (Debian).

---

## Part C — RDP Access (Windows Instance)

### C1. Security group

- Security Groups → **Create security group**
- Name: `rdp-sg` · VPC: `demo-vpc`
- Inbound rule: RDP · TCP · 3389 · Source: My IP (recommended)

### C2. Key pair

- EC2 → Key Pairs → **Create key pair**
- Name: `windows-key` · Type: RSA · Format: `.pem`
- This key only **decrypts the admin password** — it isn't used to log in directly.

### C3. Launch the instance

- EC2 → **Launch Instance** → Name: `windows-web-server`
- AMI: Microsoft Windows Server 2025 Base (Free tier)
- Instance type: `t2.micro` / `t3.micro`
- Key pair: `windows-key`
- Network settings → Edit: VPC `demo-vpc`, subnet `demo-public-subnet`, Auto-assign public IP: **Enable**, Security group: `rdp-sg`
- Storage: default → **Launch instance**
- Wait for **Running** + **2/2 checks** (Windows can take 3–5 min)

### C4. Retrieve the Administrator password

- Select the instance → **Connect** → RDP client tab → **Get password**
- Upload `windows-key.pem` → **Decrypt Password**
- Copy and store the decrypted password securely

### C5. Connect via RDP — Primary method

- Press `Win + R` → type `mstsc` → Enter
- Enter the instance's public IP → Connect
- Username: `Administrator`, paste the decrypted password
- Accept the self-signed certificate warning

> ⚠️ If it times out, double-check `rdp-sg`'s source IP matches your **current** public IP, and that status checks have fully passed.

### C6. Fallback — IAM Role + Systems Manager Fleet Manager (use if C5 doesn't work)

**Step 1 — Sign out of the IAM user, sign in as Root**

- Account menu → Sign out → sign back in as **Root user** with email + password (+ MFA if enabled)

**Step 2 — Create an IAM role**

- IAM → Roles → **Create role**
- Trusted entity type: **AWS service** · Use case: **EC2** → Next
- Attach policy: `AmazonSSMManagedInstanceCore` → Next
- Name: `EC2-SSM-Role` → **Create role**

**Step 3 — Attach the role to the Windows instance**

- EC2 → Instances → select the Windows instance
- Actions → Security → **Modify IAM role** → choose `EC2-SSM-Role` → **Update IAM role**

**Step 4 — Wait for the SSM Agent to register**

- Wait ~3–5 minutes
- Systems Manager → **Fleet Manager** → instance should show as **Managed**
- If it doesn't appear: reboot the instance (EC2 → Instance State → Reboot) and re-check after ~5 more minutes

**Step 5 — Connect via Fleet Manager**

- Fleet Manager → click the Node ID → **Node Actions** → **Connect with Remote Desktop**
- Enter the Administrator username/password (from C4) → Connect

**Step 6 — (Optional) Let the IAM user do this directly, without switching to Root each time**

- While still on Root: IAM → Users → select your IAM user → Permissions → **Add inline policy** → JSON, paste:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "FleetManagerGUIConnect",
      "Effect": "Allow",
      "Action": ["ssm-guiconnect:StartConnection", "ssm-guiconnect:GetConnection"],
      "Resource": ["arn:aws:ec2:*:*:instance/*"]
    },
    {
      "Sid": "SessionManager",
      "Effect": "Allow",
      "Action": [
        "ssm:StartSession", "ssm:ResumeSession", "ssm:TerminateSession",
        "ssm:DescribeSessions", "ssm:GetConnectionStatus", "ssm:DescribeInstanceInformation"
      ],
      "Resource": "*"
    },
    {
      "Sid": "SSMMessages",
      "Effect": "Allow",
      "Action": [
        "ssmmessages:CreateControlChannel", "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel", "ssmmessages:OpenDataChannel"
      ],
      "Resource": "*"
    },
    {
      "Sid": "EC2Describe",
      "Effect": "Allow",
      "Action": ["ec2:DescribeInstances", "ec2:DescribeInstanceStatus"],
      "Resource": "*"
    }
  ]
}
```

- Name it `AmazonSSMGUIConnect` → Save
- Sign out of Root, sign back in as your IAM user — Fleet Manager → Connect with Remote Desktop now works directly (username/password, or upload the `.pem` key pair).

---

## Troubleshooting (Task 2 only)

|Problem|Likely Cause|Fix|
|---|---|---|
|SSH: "Permission denied (publickey)"|Wrong key or bad permissions|Confirm `ubuntu-key.pem`, re-run the `icacls` commands|
|RDP won't connect|Security group source IP mismatch|Confirm `rdp-sg`'s RDP rule source = your current public IP|
|RDP still fails after that|Agent/role issue|Use the Fleet Manager fallback (C6)|
|Connection times out (either)|No internet route|Verify `demo-public-rt` has `0.0.0.0/0 → demo-igw`|

---

## Cleanup (after testing)

- Terminate both EC2 instances (EC2 → Instances → Instance State → Terminate)
- Release any Elastic IPs
- Delete `demo-vpc` (and its subnet, route table, IGW) if no longer needed
- Delete `ubuntu-key`, `windows-key`, `ssh-web-sg`, `rdp-sg` if unused