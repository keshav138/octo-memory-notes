## How to Run Kubernetes First (The Easy Way)

For practice, you don't need 5 servers. You need **Minikube** - it runs Kubernetes locally on your laptop .

### Step 1: Install Minikube and kubectl

**On macOS:**
```bash
brew install minikube kubectl
```

**On Linux:**
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

**On Windows (with Chocolatey):**
```bash
choco install minikube kubernetes-cli
```

### Step 2: Start Your Cluster

```bash
# Start a local Kubernetes cluster
minikube start

# Check it's working
kubectl cluster-info

# See your node (you'll have 1 node, not 5)
kubectl get nodes
```

That's it. You now have a running Kubernetes cluster on your machine .

---

## Practice Snippets - Copy, Paste, Learn

### Snippet 1: Deploy Your First App (Hello World)

This deploys an nginx web server .

```bash
# Create a deployment named "web" running nginx
kubectl create deployment web --image=nginx

# See your deployment
kubectl get deployments

# See the pod (container) running
kubectl get pods

# See what's happening in detail
kubectl describe pod web
```

### Snippet 2: Expose Your App to See It

Your app is running but you can't access it yet. This exposes it .

```bash
# Expose the deployment as a service
kubectl expose deployment web --type=NodePort --port=80

# See the service
kubectl get services

# Access your app (Minikube gives you the URL)
minikube service web
```

Your browser should open with the nginx welcome page.

### Snippet 3: Scale Your App Up and Down

```bash
# Scale to 3 copies (replicas) of your app
kubectl scale deployment web --replicas=3

# See all 3 pods running
kubectl get pods

# Scale back down to 1
kubectl scale deployment web --replicas=1

# Watch the pods disappear
kubectl get pods -w
```

### Snippet 4: See Live Logs and Enter a Container

```bash
# Get the pod name first
kubectl get pods

# Follow logs from a pod (use your actual pod name)
kubectl logs -f web-xxxxxxxxxx-xxxxx

# Get a shell inside the container (like SSH into it)
kubectl exec -it web-xxxxxxxxxx-xxxxx -- /bin/bash

# Once inside, try:
ls
cat /usr/share/nginx/html/index.html
exit  # to leave
```

### Snippet 5: Create a Deployment Using a YAML File

Create a file named `myapp.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-first-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: my-first-app-service
spec:
  type: NodePort
  selector:
    app: myapp
  ports:
    - port: 80
      targetPort: 80
```

Apply it and check:

```bash
# Create everything from the file
kubectl apply -f myapp.yaml

# See your deployment and service
kubectl get deployments
kubectl get services

# Get the URL to access it
minikube service my-first-app-service
```

### Snippet 6: Clean Up Everything

```bash
# Delete by the same file
kubectl delete -f myapp.yaml

# Or delete the deployment directly
kubectl delete deployment web

# Stop Minikube when done practicing
minikube stop

# If you want to completely delete the cluster
minikube delete
```

---

## Your 15-Minute Practice Session

Run these commands in order:

```bash
# 1. Start cluster
minikube start

# 2. Deploy nginx
kubectl create deployment web --image=nginx

# 3. Check it's running
kubectl get pods

# 4. Expose it
kubectl expose deployment web --type=NodePort --port=80

# 5. See it in browser
minikube service web

# 6. Scale it up
kubectl scale deployment web --replicas=3

# 7. See 3 pods running
kubectl get pods

# 8. See logs
kubectl logs -l app=web  # shows logs from all pods with label app=web

# 9. Clean up when done
kubectl delete service web
kubectl delete deployment web
```

---

## What Each Command Does

| Command | What it does |
|---------|--------------|
| `kubectl create deployment` | Creates a deployment that runs your container  |
| `kubectl get pods` | Lists all running containers (pods) |
| `kubectl expose deployment` | Creates a service to access your app  |
| `kubectl scale deployment` | Changes number of replicas  |
| `minikube service` | Opens your app in a browser |
| `kubectl logs` | Shows container output  |
| `kubectl exec -it` | Gives you a shell inside the container |

This is the 20% of Kubernetes that gives you 80% of the value. Once you're comfortable with these, you can explore Ingress, ConfigMaps, and PersistentVolumes.