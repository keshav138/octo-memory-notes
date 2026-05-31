## Kubernetes YAML Structure

Every K8s YAML file follows this skeleton, top to bottom:

```yaml
apiVersion: ...
kind: ...
metadata: ...
spec: ...
```

These 4 top-level fields are **always present, always in this order.** Everything else lives inside them.

---

### The 4 Top-Level Fields

**`apiVersion`** — Which API group/version this object belongs to.

- `v1` — core objects (Pod, Service, ConfigMap)
- `apps/v1` — workload objects (Deployment, ReplicaSet)
- `batch/v1` — Jobs, CronJobs

**`kind`** — What object you're defining. (`Deployment`, `Service`, `Pod`, etc.)

**`metadata`** — Identity of the object.

```yaml
metadata:
  name: flask-app           # required, unique within namespace
  namespace: default        # optional, defaults to 'default'
  labels:                   # key-value tags, used for selecting/grouping
    app: flask-app
    env: production
```

**`spec`** — The actual desired state. **This changes completely depending on `kind`.** A Deployment spec looks nothing like a Service spec.

---

### How Nesting Works

Indentation = ownership. A child is owned/scoped by its parent.

```yaml
spec:                          # Deployment spec
  replicas: 2
  selector:                    # how Deployment finds its Pods
    matchLabels:
      app: flask-app
  template:                    # Pod template (a Pod definition, nested inside)
    metadata:
      labels:
        app: flask-app
    spec:                      # Pod spec (different from Deployment spec)
      containers:
        - name: flask-container
          image: flask-app:latest
          ports:
            - containerPort: 5000
```

Notice there are **two `spec` blocks** — one for the Deployment, one for the Pod template inside it. This is normal and expected.

---

### The `template` Block

This is the most confusing part for beginners. Inside a Deployment, `template` is essentially **a full Pod definition** nested inside the Deployment spec.

```yaml
# Deployment spec
spec:
  replicas: 2
  selector: ...
  template:           # ← everything below here is the Pod
    metadata:         # Pod's metadata (needs labels to match selector)
      labels:
        app: flask-app
    spec:             # Pod's spec
      containers: []
```

The Deployment uses this template to stamp out however many pod replicas you asked for.

---

### Labels & Selectors — The Glue

Labels are how objects find and talk to each other. The same label must appear in 3 places to wire a Deployment + Service together:

```yaml
# Deployment
spec:
  selector:
    matchLabels:
      app: flask-app        # 1. Deployment looks for pods with this label

  template:
    metadata:
      labels:
        app: flask-app      # 2. Pods get this label stamped on them

---
# Service
spec:
  selector:
    app: flask-app          # 3. Service routes traffic to pods with this label
```

If any of these three mismatch, things silently break (pods run but get no traffic, or deployment can't manage its pods).

---

### Multi-object Files

You can stack multiple objects in one file using `---` as a separator. Order doesn't technically matter to K8s but convention is Deployment first, Service second.

```yaml
apiVersion: apps/v1
kind: Deployment
...
---
apiVersion: v1
kind: Service
...
```

---

### Summary of the Mental Model

```
apiVersion  →  tells K8s which API to use
kind        →  what you're creating
metadata    →  name, labels (identity + grouping)
spec        →  desired state (unique per kind)
  └─ for Deployments, spec contains a template
       └─ template contains another metadata + spec (the Pod)
```

The general rule: **top = identity, bottom = behavior.** The deeper you go, the more specific the configuration gets.