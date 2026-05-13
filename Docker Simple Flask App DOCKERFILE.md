# Simple Flask App with Docker – Complete Guide

A **minimal, working example** you can run in 2 minutes.

---

## Part 1: The Flask App (`app.py`)

```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        "message": "Hello from Flask in Docker!",
        "status": "running"
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
```

**What this does**:
- Creates a Flask web server
- Listens on all network interfaces (`0.0.0.0`) so Docker can expose it
- Port 5000 (default Flask port)
- Two endpoints: `/` (home) and `/health` (health check)

---

## Part 2: The Dockerfile

```dockerfile
# Use official Python runtime as base image
FROM python:3.9-slim

# Set working directory inside container
WORKDIR /app

# Copy requirements first (for better caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY app.py .

# Expose the port the app runs on
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
```

**Line-by-line explanation**:

| Line | What it does |
|------|--------------|
| `FROM python:3.9-slim` | Start from lightweight Python 3.9 image |
| `WORKDIR /app` | Create and switch to `/app` directory |
| `COPY requirements.txt .` | Copy requirements file into container |
| `RUN pip install...` | Install Python packages |
| `COPY app.py .` | Copy our Flask app into container |
| `EXPOSE 5000` | Document that container listens on port 5000 |
| `CMD ["python", "app.py"]` | Run the app when container starts |

---

## Part 3: Requirements File (`requirements.txt`)

```txt
flask==2.3.0
```

---

## Part 4: Complete Project Structure

```
my-flask-app/
├── app.py
├── Dockerfile
└── requirements.txt
```

---

## Part 5: Build and Run Commands

### Step 1: Build the Docker Image

```bash
# Navigate to your project directory
cd my-flask-app

# Build the image (notice the dot at the end)
docker build -t flask-app .

# -t = tag/name the image
# . = build context (current directory)
```

**Expected output**:
```
[+] Building 2.5s (10/10) FINISHED
 => [1/5] FROM python:3.9-slim
 => [2/5] WORKDIR /app
 => [3/5] COPY requirements.txt .
 => [4/5] RUN pip install --no-cache-dir -r requirements.txt
 => [5/5] COPY app.py .
 => exporting to image
 => => naming to docker.io/library/flask-app
```

### Step 2: Run the Container

```bash
# Run the container
docker run -d -p 5000:5000 --name flask-container flask-app

# Explanation:
# -d = detached mode (runs in background)
# -p 5000:5000 = map host port 5000 to container port 5000
# --name = give container a name
# flask-app = image name to run
```

### Step 3: Test It

```bash
# Test with curl
curl http://localhost:5000

# Expected output:
# {"message":"Hello from Flask in Docker!","status":"running"}

# Test health endpoint
curl http://localhost:5000/health

# Expected output:
# {"status":"healthy"}
```

**Or open browser**: http://localhost:5000

---

## Part 6: Useful Commands

```bash
# View running containers
docker ps

# View logs
docker logs flask-container

# Stop container
docker stop flask-container

# Start stopped container
docker start flask-container

# Remove container (must be stopped first)
docker rm flask-container

# Remove image
docker rmi flask-app

# Run in foreground (to see logs in real-time)
docker run -p 5000:5000 flask-app

# Run with auto-remove (cleans up after stop)
docker run --rm -p 5000:5000 flask-app

# Run with custom name and environment variable
docker run -d -p 5000:5000 --name my-flask -e FLASK_ENV=production flask-app

# Execute command inside running container
docker exec -it flask-container bash

# View container resource usage
docker stats flask-container
```

---

## Part 8: Make It Better (Optional Improvements)

### Better Dockerfile (Production Ready)

```dockerfile
FROM python:3.9-slim

WORKDIR /app

# Create non-root user
RUN adduser --disabled-password --gecos '' appuser

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY app.py .

# Switch to non-root user
USER appuser

EXPOSE 5000

# Use gunicorn for production (instead of Flask dev server)
# First add gunicorn to requirements.txt: gunicorn==20.1.0
# Then change CMD to:
# CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
CMD ["python", "app.py"]
```

### Docker Compose (for development)

Create `docker-compose.yml`:

```yaml
version: '3.8'
services:
  flask-app:
    build: .
    ports:
      - "5000:5000"
    environment:
      - FLASK_ENV=development
      - FLASK_DEBUG=1
    volumes:
      # Mount local code for hot reload (no rebuild needed)
      - ./app.py:/app/app.py
```

Run with:
```bash
docker-compose up -d
```

---

## Summary: Quick Command Reference

| Task | Command |
|------|---------|
| Build image | `docker build -t flask-app .` |
| Run container | `docker run -d -p 5000:5000 --name flask-container flask-app` |
| Test API | `curl http://localhost:5000` |
| View logs | `docker logs flask-container` |
| Stop container | `docker stop flask-container` |
| Remove container | `docker rm flask-container` |
| Remove image | `docker rmi flask-app` |
| Open bash in container | `docker exec -it flask-container bash` |

---

That's it! You now have a working Flask app in Docker. Ready to integrate this into your Jenkins pipeline?