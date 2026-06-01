Let me break Kubernetes down to its core first, then we'll write the files.

---

**The mental model**

Think of it like this — Docker Compose is "run these containers on _this_ machine". Kubernetes is "run these containers, and I don't care which machine, just keep them alive".

Everything in Kubernetes is defined in YAML files called **manifests**. You describe _what you want_, Kubernetes figures out _how to do it_.

---

**3 concepts you need for 90% of use cases**

**Deployment** — "Run this container image, keep N copies alive, restart if it crashes."

**Service** — "Give this container a stable way to be reached." Containers are temporary, their IPs change. A Service sits in front and gives a fixed address.

**Types of Service:**

- `ClusterIP` — only reachable inside the cluster (default)
- `NodePort` — exposes a port on the node itself, reachable from outside (what we'll use with minikube)
- `LoadBalancer` — for cloud providers, gives a public IP

That's genuinely it for a basic setup. One Deployment + one Service per app.

---

**The YAML structure to memorize**

Every Kubernetes manifest has these 4 top-level fields:

```yaml
apiVersion:   # which API to use
kind:         # what type of object (Deployment, Service, etc.)
metadata:     # name, labels
spec:         # the actual config — differs per kind
```

---

Now the actual files for your project. Since minikube has its own internal Docker daemon, we need to point your terminal at it so it can see locally built images directly, no registry needed.

---**The `---` in the middle** just separates two manifests in one file. Kubernetes reads them as two separate objects.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask-app       # Deployment manages pods with this label
  template:
    metadata:
      labels:
        app: flask-app     # Pod gets this label
    spec:
      containers:
        - name: flask-app
          image: flask-monitoring-flask-app:latest
          imagePullPolicy: Never   # use local image, don't try Docker Hub
          ports:
            - containerPort: 5000

---

apiVersion: v1
kind: Service
metadata:
  name: flask-app-service
spec:
  type: NodePort
  selector:
    app: flask-app         # routes traffic to pods with this label
  ports:
    - port: 5000           # port on the Service
      targetPort: 5000     # port on the container
      nodePort: 30500      # port you'll hit from your browser (30000-32767)
```

---

**How the label system works** (this is what confuses most people)

```
Deployment  →  selector.matchLabels: app: flask-app
                         ↓ manages pods that have this label
Pod         →  labels: app: flask-app
                         ↑ Service finds pods using this same label
Service     →  selector: app: flask-app
```

They're all just talking to each other via matching labels.

---

**To run it:**

```bash
# 1. start minikube
minikube start

# 2. point your terminal's docker at minikube's daemon
eval $(minikube docker-env)        # mac/linux
# on Windows (PowerShell):
minikube docker-env | Invoke-Expression

# 3. build the image inside minikube's docker
docker build -t flask-monitoring-flask-app:latest .

# 4. apply the manifest
kubectl apply -f k8s-flask.yml

# 5. check it's running
kubectl get pods
kubectl get services

# 6. get the URL to open in browser
minikube service flask-app-service --url
```

---

**Useful kubectl commands to know:**

```bash
kubectl get pods                        # list running pods
kubectl describe pod <pod-name>         # full detail if something's wrong
kubectl logs <pod-name>                 # container logs
kubectl delete -f k8s-flask.yml        # tear it all down
```

The key thing to remember — `kubectl apply` is idempotent, you can run it repeatedly and it'll only update what changed.