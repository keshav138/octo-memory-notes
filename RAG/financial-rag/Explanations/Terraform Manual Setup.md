### Step 1 — Install Terraform on Windows

Download from the official site:

```
https://developer.hashicorp.com/terraform/install#windows
```

Download the Windows AMD64 zip, extract it, and move `terraform.exe` to a folder like `C:\terraform\`.

Then add to PATH:

- Search "Environment Variables" in Windows
- Under System Variables → `Path` → Edit → New → add `C:\terraform`
- Open a new PowerShell and verify:

```powershell
terraform -version
```

---

### Step 2 — AWS credentials setup

You need an IAM user with programmatic access:

1. Go to AWS Console → **IAM** → **Users** → **Create User**
2. Username: `terraform-user`
3. Attach policy: `AmazonEC2FullAccess`
4. After creation → **Security Credentials** tab → **Create Access Key**
5. Choose CLI → download the CSV

Then configure locally:

```powershell
aws configure
```

If AWS CLI isn't installed:

```
https://aws.amazon.com/cli/
```

Enter:

```
AWS Access Key ID: your_access_key
AWS Secret Access Key: your_secret_key
Default region: ap-south-1
Default output format: json
```

```
// to check connection
aws sts get-called-identity
```
---

Once both are done let me know and we'll write the Terraform files.