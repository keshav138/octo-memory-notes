# AWS Lambda & Elastic Beanstalk – Practical Deep Dive

Two completely different approaches to running code. Let's understand **when** and **how** to use each, with working examples.

---

## Part 1: Mental Model First

```
Elastic Beanstalk = "Give me a platform, I'll give you code"
Lambda = "Give me a function, I'll run it when needed"

Beanstalk → Always running, full app, server-like thinking
Lambda   → Runs only when called, event-driven, function thinking
```

---

# AWS Lambda Deep Dive

## What Lambda Really Is

**Serverless Function-as-a-Service (FaaS)**:
- Upload code, AWS runs it
- No servers to manage (really)
- Pay only when code executes
- Auto-scales from 0 to thousands

## When to Use Lambda (vs EC2)

| Use Lambda | Don't Use Lambda |
|------------|------------------|
| API backends (low to medium traffic) | Long-running processes (>15 min) |
| File processing (upload → transform) | Heavy machine learning training |
| Scheduled jobs (cron) | WebSockets (long-lived connections) |
| Real-time data transformation | Apps needing full framework control |
| S3 event handlers | Large monolithic apps |

## Lambda Limitations (Critical)

- **Timeout**: Maximum 15 minutes (900 seconds)
- **Memory**: 128 MB to 10,240 MB (10 GB)
- **Temp storage**: 512 MB to 10,240 MB (ephemeral)
- **Request size**: 6 MB (API Gateway) / 256 KB (direct)
- **Cold start**: 100ms - 1 second (can be slower)

---

## Lambda Hands-On: Three Working Examples

### Prerequisite: AWS CLI configured

```powershell
aws configure
# Set region to us-east-1 or your preferred
```

---

### Example 1: Simple "Hello Lambda" (Using AWS Console)

**Goal**: Create a Lambda that returns JSON response

#### Step 1: Create Lambda function

```powershell
# Create a role for Lambda
aws iam create-role --role-name lambda-basic-role --assume-role-policy-document '{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "lambda.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }]
}'

# Attach basic execution policy
aws iam attach-role-policy --role-name lambda-basic-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
```

#### Step 2: Create Lambda (Python 3.9)

```powershell
# Create function code (save as lambda_function.py)
@'
def lambda_handler(event, context):
    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": "{\"message\": \"Hello from Lambda!\"}"
    }
'@ | Out-File -Encoding UTF8 lambda_function.py

# Zip it
Compress-Archive -Path lambda_function.py -DestinationPath function.zip
```

#### Step 3: Deploy Lambda

```powershell
aws lambda create-function \
    --function-name hello-lambda \
    --runtime python3.9 \
    --role arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/lambda-basic-role \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://function.zip
```

#### Step 4: Test it

```powershell
# Invoke Lambda
aws lambda invoke --function-name hello-lambda --payload '{}' output.json

# See result
cat output.json
```

**Expected output**:
```json
{"statusCode":200,"headers":{"Content-Type":"application/json"},"body":"{\"message\": \"Hello from Lambda!\"}"}
```

---

### Example 2: Flask App on Lambda (Using Mangum)

**This is important** – running Flask on Lambda lets you reuse existing Flask code.

#### Step 1: Create Flask app

Create `flask_lambda.py`:
```python
from flask import Flask, jsonify, request
from mangum import Mangum

app = Flask(__name__)

# Your regular Flask routes
@app.route('/')
def hello():
    return jsonify({"message": "Flask running on Lambda!"})

@app.route('/users/<user_id>')
def get_user(user_id):
    return jsonify({"user_id": user_id, "name": f"User {user_id}"})

@app.route('/echo', methods=['POST'])
def echo():
    data = request.get_json()
    return jsonify({"you_sent": data})

# Mangum adapter converts Flask to Lambda handler
handler = Mangum(app)

# For local testing
if __name__ == '__main__':
    app.run(port=5000)
```

#### Step 2: Create requirements.txt

```
flask==2.3.0
mangum==0.17.0
```

#### Step 3: Package and deploy

```powershell
# Create directory structure
mkdir flask-lambda
cd flask-lambda

# Create files above, then:

# Install dependencies locally
pip install -r requirements.txt -t .

# Add your code
copy flask_lambda.py .

# Zip everything
Compress-Archive -Path * -DestinationPath ../flask-lambda.zip

# Deploy
aws lambda create-function \
    --function-name flask-on-lambda \
    --runtime python3.9 \
    --role arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/lambda-basic-role \
    --handler flask_lambda.handler \
    --zip-file fileb://../flask-lambda.zip \
    --timeout 30 \
    --memory-size 512
```

#### Step 4: Test with API Gateway (to get HTTP endpoint)

```powershell
# Create HTTP API
aws apigatewayv2 create-api \
    --name flask-api \
    --protocol-type HTTP \
    --target arn:aws:lambda:us-east-1:$(aws sts get-caller-identity --query Account --output text):function:flask-on-lambda

# Add permission for API Gateway to invoke Lambda
aws lambda add-permission \
    --function-name flask-on-lambda \
    --statement-id api-gateway-invoke \
    --action lambda:InvokeFunction \
    --principal apigateway.amazonaws.com
```

Now visit the URL from the API response → Your Flask app runs on Lambda!

---

### Example 3: S3-Triggered Lambda (Practical Use Case)

**Goal**: Automatically resize images when uploaded to S3

#### Step 1: Create S3 bucket

```powershell
# Create bucket (must be globally unique)
aws s3 mb s3://my-image-resize-bucket-$(aws sts get-caller-identity --query Account --output text)
```

#### Step 2: Create Lambda with Pillow (image processing)

```python
# resize_lambda.py
import boto3
from PIL import Image
import io
import os

s3 = boto3.client('s3')

def lambda_handler(event, context):
    # Get bucket and key from S3 event
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        
        # Download image
        response = s3.get_object(Bucket=bucket, Key=key)
        image_data = response['Body'].read()
        
        # Resize image
        img = Image.open(io.BytesIO(image_data))
        img.thumbnail((200, 200))  # Resize to 200x200 max
        
        # Save resized version
        output_buffer = io.BytesIO()
        img.save(output_buffer, format=img.format)
        
        # Upload resized version
        output_key = f"resized/{os.path.basename(key)}"
        s3.put_object(
            Bucket=bucket,
            Key=output_key,
            Body=output_buffer.getvalue(),
            ContentType=response['ContentType']
        )
        
    return {"statusCode": 200}
```

#### Step 3: Package and deploy with layer (Pillow requires compilation)

```powershell
# Easier: Use AWS managed Pillow layer
# Deploy Lambda first, then add layer

aws lambda create-function \
    --function-name image-resizer \
    --runtime python3.9 \
    --role arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/lambda-basic-role \
    --handler resize_lambda.lambda_handler \
    --zip-file fileb://resize-lambda.zip
```

#### Step 4: Add S3 trigger

```powershell
# Add permission for S3 to invoke Lambda
aws lambda add-permission \
    --function-name image-resizer \
    --statement-id s3-invoke \
    --action lambda:InvokeFunction \
    --principal s3.amazonaws.com \
    --source-arn arn:aws:s3:::my-image-resize-bucket-* \
    --source-account $(aws sts get-caller-identity --query Account --output text)

# Now configure S3 event (using AWS Console - easier)
# Console: S3 → Bucket → Properties → Event Notifications
# Event type: PUT
# Destination: Lambda function → image-resizer
```

**Test**: Upload any image to the bucket → Check `resized/` folder for 200x200 version.

---

## Lambda Cold Start Demonstration

```python
# cold_start_test.py
import time

start_time = None

def lambda_handler(event, context):
    global start_time
    
    if start_time is None:
        start_time = time.time()
        print(f"COLD START: Initialization took {start_time} seconds")
    else:
        print(f"WARM: Function reused")
    
    return {
        "statusCode": 200,
        "body": f"Start time: {start_time}"
    }
```

Run twice → First invocation slower, second faster.

---

# AWS Elastic Beanstalk Deep Dive

## What Elastic Beanstalk Really Is

**Platform as a Service (PaaS)**:
- Upload code → AWS provisions: EC2, Load Balancer, Auto Scaling, Security Groups
- You control environment variables, instance types
- AWS handles: deployments, health monitoring, patches

## Beanstalk vs Alternatives

| Aspect | Beanstalk | Lambda | EC2 (raw) |
|--------|-----------|--------|-----------|
| Control | Medium | Low | Full |
| Ops work | Low | Minimal | High |
| Cost model | Always running | Pay per execution | Always running |
| Stateful | Yes | Stateless (mostly) | Yes |
| Best for | Web apps | Event handlers | Full control |

## Beanstalk Components

```
Application (container for environments)
    └── Environment (dev, staging, prod)
        ├── EC2 instances (running your code)
        ├── Auto Scaling Group (scale up/down)
        ├── Load Balancer (distribute traffic)
        ├── Security Groups (firewall)
        └── RDS (optional - attached database)
```

---

## Elastic Beanstalk Hands-On: Flask Deployment

### Prerequisite: Install EB CLI

```powershell
# Using pip
pip install awsebcli --upgrade

# Verify
eb --version
```

---

### Example 1: Deploy Simple Flask App (5 minutes)

#### Step 1: Create Flask app structure

```powershell
mkdir flask-eb-app
cd flask-eb-app
```

Create `application.py` (EB expects this name or `app.py`):
```python
from flask import Flask, jsonify, request
import os

application = Flask(__name__)  # EB looks for 'application'

@application.route('/')
def hello():
    return jsonify({
        "message": "Hello from Elastic Beanstalk!",
        "environment": os.environ.get("ENVIRONMENT", "unknown"),
        "instance_id": os.environ.get("INSTANCE_ID", "unknown")
    })

@application.route('/health')
def health():
    return "OK", 200

@application.route('/info', methods=['GET', 'POST'])
def info():
    return jsonify({
        "method": request.method,
        "headers": dict(request.headers),
        "args": request.args.to_dict()
    })

if __name__ == '__main__':
    application.run(host='0.0.0.0', port=8080)
```

Create `requirements.txt`:
```
flask==2.3.0
```

Create `.ebextensions/flask.config` (configuration for EB):
```yaml
option_settings:
  aws:elasticbeanstalk:container:python:
    WSGIPath: application:application
  aws:elasticbeanstalk:environment:
    EnvironmentType: SingleInstance  # For development (no LB, cheaper)
  aws:autoscaling:launchconfiguration:
    InstanceType: t3.micro
    EC2KeyName: terraform-flask-key  # Your key pair name
```

#### Step 2: Initialize EB application

```powershell
# Initialize EB (creates .elasticbeanstalk directory)
eb init -p python-3.9 flask-demo --region us-east-1

# When prompted:
# - Select your key pair
# - Set up SSH? Yes
```

#### Step 3: Create environment and deploy

```powershell
# Create dev environment
eb create flask-dev-env

# Wait ~5 minutes... Beanstalk provisions everything
# Once done, you'll see: "Environment health is green"

# Open in browser
eb open
```

#### Step 4: Update and redeploy

```powershell
# Make a change to application.py
# Then deploy
eb deploy

# View logs
eb logs

# SSH into EC2 instance
eb ssh
```

#### Step 5: Set environment variables

```powershell
# Set environment variable
eb setenv ENVIRONMENT=production FLASK_DEBUG=false

# Restart environment
eb restart
```

#### Step 6: Clean up

```powershell
# Terminate environment (stops all resources)
eb terminate flask-dev-env

# Delete application
eb terminate --all
```

---

### Example 2: Full Flask App with Database

#### Project structure for production:
```
flask-eb-prod/
├── application.py
├── requirements.txt
├── .ebextensions/
│   ├── flask.config
│   └── database.config
└── .elasticbeanstalk/
```

#### `application.py` (with RDS integration):

```python
from flask import Flask, jsonify, request
import os
import psycopg2
from psycopg2.extras import RealDictCursor

application = Flask(__name__)

# Get database config from environment
DB_HOST = os.environ.get('RDS_HOST')
DB_NAME = os.environ.get('RDS_DB_NAME', 'ebdb')
DB_USER = os.environ.get('RDS_USERNAME', 'ebroot')
DB_PASS = os.environ.get('RDS_PASSWORD')

def get_db():
    return psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASS
    )

@application.route('/')
def home():
    return jsonify({
        "app": "Flask on Beanstalk",
        "database": DB_HOST
    })

@application.route('/users', methods=['GET', 'POST'])
def users():
    conn = get_db()
    cur = conn.cursor(cursor_factory=RealDictCursor)
    
    if request.method == 'POST':
        name = request.json.get('name')
        cur.execute("INSERT INTO users (name) VALUES (%s) RETURNING id", (name,))
        conn.commit()
        return jsonify({"id": cur.fetchone()['id']}), 201
    
    cur.execute("SELECT id, name, created_at FROM users")
    users = cur.fetchall()
    cur.close()
    conn.close()
    return jsonify(users)
```

#### `.ebextensions/database.config` (auto-create RDS):

```yaml
Resources:
  MyDatabase:
    Type: AWS::RDS::DBInstance
    Properties:
      DBName: ebdb
      Engine: postgres
      EngineVersion: "14.7"
      DBInstanceClass: db.t3.micro
      AllocatedStorage: 20
      StorageType: gp2
      MasterUsername: ebroot
      MasterUserPassword: "YourPassword123!"  # Change in production!
      VPCSecurityGroups:
        - Fn::GetAtt: [AWSEBSecurityGroup, GroupId]

OptionSettings:
  aws:elasticbeanstalk:application:environment:
    RDS_HOST: Fn::GetAtt: [MyDatabase, Endpoint.Address]
    RDS_DB_NAME: ebdb
    RDS_USERNAME: ebroot
    RDS_PASSWORD: "YourPassword123!"
```

Deploy:
```powershell
eb create flask-db-env --database

# Or with specific parameters
eb create flask-db-env \
    --database.engine postgres \
    --database.version 14.7 \
    --database.username ebroot \
    --database.password YourPassword123!
```

---

### Example 3: Docker on Beanstalk (Run any container)

Create `Dockerfile`:
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY application.py .
CMD ["python", "application.py"]
```

Create `Dockerrun.aws.json` (EB configuration):
```json
{
  "AWSEBDockerrunVersion": "1",
  "Image": {
    "Name": "my-flask-app:latest",
    "Update": "true"
  },
  "Ports": [
    {
      "ContainerPort": 5000,
      "HostPort": 8080
    }
  ],
  "Logging": "/var/log/nginx"
}
```

Deploy Docker image:
```powershell
# Build locally
docker build -t my-flask-app .

# EB will build from Dockerrun.aws.json
eb init -p docker flask-docker-app
eb create flask-docker-env
```

---

## Beanstalk CLI Commands Reference

```powershell
# Application management
eb init                    # Initialize app
eb list                    # List environments
eb create <env-name>       # Create environment
eb status                  # Current status
eb health                  # Detailed health

# Deployment
eb deploy                  # Deploy new version
eb events                  # View events
eb logs                    # Get logs
eb ssh                     # SSH into EC2

# Configuration
eb config                  # Edit environment config
eb setenv KEY=value        # Set environment variable
eb printenv                # Show environment variables

# Operations
eb restart                 # Restart app servers
eb rebuild                 # Rebuild environment
eb terminate <env-name>    # Delete environment
eb open                    # Open in browser
```

---

## Quick Comparison: Lambda vs Beanstalk for Flask

| Need | Lambda | Beanstalk |
|------|--------|-----------|
| Traffic pattern | Spiky (scale to zero) | Steady (always on) |
| Cold start tolerance | Good | N/A (always warm) |
| Database connections | Pooling needed | Normal connection pooling |
| File system access | Limited (/tmp 512MB) | Full EBS |
| Background tasks | Must finish in 15 min | Can run indefinitely |
| Cost at 1M requests/month | ~$0.20 | ~$30 (t3.micro) |
| Cost at 10M requests/month | ~$2.00 | ~$30 (same) |
| Time to deploy | Seconds | 5-10 minutes |
| Local testing | Lambda Runtime Emulator | Standard Flask run |

---

## When to Use What (Decision Guide)

```
Your Flask app has:

Long-running requests? (>15 sec) → Beanstalk (or EC2)
Need WebSockets? → Beanstalk
Low/unknown traffic? → Lambda (costs near zero)
Need cron jobs? → Lambda (EventBridge)
Need full control? → EC2
Just want to deploy code fast? → Beanstalk
You're broke? → Lambda (free tier generous)

Combo approach:
- API Gateway + Lambda for API endpoints
- Beanstalk for admin dashboard
- Lambda for cron jobs (cleaning database)
```

---

## Practice Exercises

### Lambda Exercises:
1. **Exercise**: Create Lambda that returns weather data based on city parameter
2. **Exercise**: Build Slack bot Lambda that responds to `/hello` command
3. **Exercise**: Create Lambda that runs every hour and logs current time

### Beanstalk Exercises:
1. **Exercise**: Deploy same Flask app with Blue/Green deployment (`eb clone`)
2. **Exercise**: Add Auto Scaling rule (scale when CPU > 60%)
3. **Exercise**: Enable HTTPS with Let's Encrypt

### Combined Exercise:
Create:
- Beanstalk for main Flask app
- Lambda for image processing (triggered by S3)
- Both share same RDS database

---

## Next Steps

You can now:
- **Show someone** a working Lambda or Beanstalk deployment in 5 minutes
- **Explain** tradeoffs between serverless and platform-based
- **Choose** the right service for different Flask app requirements

Ready to move to **Jenkins pipeline** that deploys Flask apps to Beanstalk/Lambda automatically?