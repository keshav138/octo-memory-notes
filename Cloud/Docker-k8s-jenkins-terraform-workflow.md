I'll give you structured notes on each — architecture, components, and how data/control flows through them.

---

## 🐳 Docker

**What it is:** A containerization platform. Packages apps + dependencies into isolated, portable units.

**Core Components:**

- **Dockerfile** — Blueprint. Instructions to build an image (`FROM`, `RUN`, `COPY`, `CMD`, etc.)
- **Image** — Read-only snapshot built from Dockerfile. Layered filesystem (each instruction = a layer).
- **Container** — Running instance of an image. Has its own process space, network, filesystem (writable layer on top).
- **Docker Engine** — The daemon (`dockerd`) that manages images, containers, networks, volumes.
- **Docker CLI** — Client that talks to the daemon via REST API.
- **Registry** — Image storage. Docker Hub is default; can be private (ECR, GCR, self-hosted).
- **Volumes** — Persistent storage outside the container lifecycle.
- **Networks** — Bridge (default, single host), Host (shares host network), Overlay (multi-host).

**Flow:**

```
Dockerfile → docker build → Image → docker run → Container
                                  ↕
                             Registry (push/pull)
```

**docker-compose** — Multi-container orchestration for local dev. Defines services, networks, volumes in one YAML.

---

## ☸️ Kubernetes (K8s)

**What it is:** Container orchestration. Manages deployment, scaling, networking, and self-healing of containerized workloads across a cluster.

**Two Planes:**

### Control Plane (Brain)

- **API Server** — Single entry point. Everything (CLI, controllers, nodes) talks through it.
- **etcd** — Distributed key-value store. Source of truth for all cluster state.
- **Scheduler** — Assigns Pods to Nodes based on resource availability + constraints.
- **Controller Manager** — Runs controllers (ReplicaSet, Deployment, Node, Job controllers) that reconcile desired vs actual state.
- **Cloud Controller Manager** — Interfaces with cloud provider APIs (load balancers, storage, nodes).

### Worker Node (Execution)

- **kubelet** — Agent on each node. Receives Pod specs from API server, manages container lifecycle.
- **kube-proxy** — Handles networking rules, service routing on the node.
- **Container Runtime** — Actually runs containers (containerd, CRI-O).

**Core Objects (what you deploy):**

- **Pod** — Smallest unit. One or more containers sharing network/storage.
- **ReplicaSet** — Ensures N pods are always running.
- **Deployment** — Manages ReplicaSets. Handles rollouts, rollbacks.
- **Service** — Stable network endpoint for a set of pods (ClusterIP, NodePort, LoadBalancer).
- **Ingress** — HTTP routing layer on top of Services (host/path-based routing).
- **ConfigMap / Secret** — Inject config/creds into pods.
- **PersistentVolume / PVC** — Storage abstraction.
- **Namespace** — Logical cluster partitioning.

**Flow:**

```
kubectl apply (YAML) → API Server → etcd (stores state)
                                  ↓
                    Scheduler → assigns to Node
                                  ↓
                    kubelet → pulls image → runs Pod
                                  ↓
                    Controller Manager → watches, reconciles
```

---

## 🔧 Jenkins

**What it is:** Open-source CI/CD automation server. Builds, tests, and deploys code via pipelines.

**Core Components:**

- **Master (Controller)** — Orchestrates everything. Hosts the UI, manages jobs, distributes work to agents.
- **Agents (Nodes)** — Workers that actually execute pipeline steps. Can be static VMs, Docker containers, K8s pods.
- **Executor** — A slot on an agent for running a job. One agent can have multiple executors.
- **Job / Project** — A task definition. Types: Freestyle (GUI-defined), Pipeline (code-defined).
- **Jenkinsfile** — Groovy DSL file checked into source. Defines the pipeline as code.
- **Plugins** — Core to Jenkins extensibility (~1800+). Git, Docker, K8s, Slack, AWS all via plugins.
- **Build Queue** — Jobs waiting for an available executor.

**Pipeline Structure (Declarative):**

```groovy
pipeline {
  agent any
  stages {
    stage('Build')  { steps { ... } }
    stage('Test')   { steps { ... } }
    stage('Deploy') { steps { ... } }
  }
  post { failure { notify() } }
}
```

**Flow:**

```
SCM push/webhook → Jenkins Master → queues job
                                  ↓
                    picks Agent → runs stages sequentially
                                  ↓
                    artifacts, test reports, notifications
```

**Multi-branch Pipeline** — Automatically creates pipeline per branch. Common pattern for PR-based CI.

---

## 🏗️ Terraform

**What it is:** Infrastructure as Code (IaC) tool. Declaratively defines and provisions cloud infrastructure across providers.

**Core Components:**

- **Configuration Files (`.tf`)** — HCL (HashiCorp Config Language). Declare resources, variables, outputs.
- **Provider** — Plugin that talks to a platform (AWS, GCP, Azure, K8s). Downloads on `init`.
- **Resource** — Fundamental unit. A thing to create (`aws_instance`, `google_storage_bucket`).
- **Module** — Reusable group of resources. Like a function for infra.
- **State File (`terraform.tfstate`)** — JSON snapshot of real-world infra. Terraform's source of truth. Stored locally or remotely (S3 + DynamoDB for locking).
- **Plan** — Diff between current state and desired config. Shows what will change before applying.
- **Backend** — Where state is stored and how operations run (local, S3, Terraform Cloud).
- **Variables & Outputs** — Parameterize configs; expose values from modules/root.
- **Data Sources** — Read existing infra not managed by Terraform.

**Workflow:**

```
.tf files → terraform init   (downloads providers, sets up backend)
          → terraform plan   (computes diff vs state)
          → terraform apply  (provisions infra, updates state)
          → terraform destroy (tears down)
```

**State reconciliation flow:**

```
Desired Config (.tf) + State File → Plan → API calls to Provider → Real Infra
                                                                        ↓
                                                              State file updated
```

---

## How They Fit Together (Common Stack)

```
Terraform       → provisions the K8s cluster + cloud infra
Jenkins         → CI/CD: builds Docker images, runs tests, deploys to K8s
Docker          → packages the app into images, pushed to registry
Kubernetes      → pulls images, runs containers at scale, handles networking
```