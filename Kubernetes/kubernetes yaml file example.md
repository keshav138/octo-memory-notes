Two versions — local image and DockerHub pull.

---

## Option 1: Local Image (your Flask app)

> ⚠️ Local images only work if you're using **minikube**. Run `eval $(minikube docker-env)` first, then build your image — this builds it **inside** minikube's Docker daemon so K8s can find it.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
        - name: flask-container
          image: my-flask-app:latest      # your local image name
          imagePullPolicy: Never          # don't try to pull from registry
          ports:
            - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: flask-service
spec:
  type: NodePort
  selector:
    app: flask-app
  ports:
    - port: 5000
      targetPort: 5000
      nodePort: 30001                     # access via localhost:30001
```

**To access:** `minikube service flask-service`

---

## Option 2: DockerHub Image

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
        - name: flask-container
          image: username/my-flask-app:latest   # dockerhub image
          imagePullPolicy: Always               # always pull fresh
          ports:
            - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: flask-service
spec:
  type: NodePort
  selector:
    app: flask-app
  ports:
    - port: 5000
      targetPort: 5000
      nodePort: 30001
```

**To access:** `minikube service flask-service` or `localhost:30001`

---

## Apply & Basic Commands

Since minikube runs its own separate docker container, it does not know where the build for the image is.
Either we build the image on the minikube docker.
```bash
minikube start
minikube docker-env | Invoke-Expression
docker build -t flask-app:v1
docker images
```
Or we can load the image if its already built.
```
minikube image load my-flask-app:latest
```


```bash
kubectl apply -f flask.yaml           # deploy everything
kubectl get pods                      # check pods are Running
kubectl get services                  # check service
kubectl logs <pod-name>               # view logs
kubectl delete -f flask.yaml          # tear it all down
```


```bash
minikube start         # start the cluster
minikube stop          # stop it (doesn't delete anything)
minikube delete        # wipe the cluster entirely
minikube dashboard     # opens a web UI to see everything visually
minikube service <name> # opens a NodePort service in browser + gives you the URL
```

`minikube service flask-service` -> to actually create a port tunnel into the container to access the flask server.

---

## What's happening here

| Thing                  | Purpose                                                   |
| ---------------------- | --------------------------------------------------------- |
| `Deployment`           | Manages your pods, ensures `replicas` count stays healthy |
| `replicas: 2`          | Runs 2 pod instances                                      |
| `selector/matchLabels` | Connects Deployment → Pods via label matching             |
| `containerPort`        | Port your Flask app listens on inside the container       |
| `Service (NodePort)`   | Exposes the pods to outside traffic via a stable port     |
| `targetPort`           | Which port on the pod to forward traffic to               |
| `nodePort`             | The external port you hit from your machine               |