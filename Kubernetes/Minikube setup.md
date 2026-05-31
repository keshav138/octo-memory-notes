## Installing Minikube

### Prerequisites first

You need a container/VM driver. Easiest is **Docker Desktop** — if you already have Docker installed, you're good. If not, install that first.

---

### Installation by OS

**macOS**

```bash
brew install minikube
```

**Windows** (run in PowerShell as Admin)

```powershell
winget install minikube
```

**Linux (Ubuntu/Debian)**

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

---

### Also install kubectl (the CLI to talk to K8s)

**macOS**

```bash
brew install kubectl
```

**Windows**

```powershell
winget install kubectl
```

**Linux**

```bash
sudo apt-get install -y kubectl
```

> On macOS/Windows, **Docker Desktop actually ships kubectl** with it, so you may already have it. Run `kubectl version --client` to check.

---

### Start minikube

```bash
minikube start
```

This spins up a single-node K8s cluster locally using Docker as the driver. First run takes a few minutes — it's downloading the K8s node image.

**Verify everything is working:**

```bash
minikube status        # should show: host, kubelet, apiserver all Running
kubectl get nodes      # should show one node with STATUS = Ready
```

---

### Useful minikube commands to know

```bash
minikube start         # start the cluster
minikube stop          # stop it (doesn't delete anything)
minikube delete        # wipe the cluster entirely
minikube dashboard     # opens a web UI to see everything visually
minikube service <name> # opens a NodePort service in browser + gives you the URL
```

---

Once `kubectl get nodes` shows `Ready`, you're good to go and can apply your YAML files.