You're absolutely right. Here's the **Pareto version** - the 20% of commands you'll use 80% of the time.

## The Essential 15 Commands

### 1. View Everything
```bash
# See all pods (across all namespaces)
kubectl get pods -A

# See everything in current namespace
kubectl get all

# See pods with which node they're on
kubectl get pods -o wide
```

### 2. Check Deployments & Services
```bash
# Your Django deployments
kubectl get deployments

# Your services (networking)
kubectl get svc

# All nodes in cluster
kubectl get nodes
```

### 3. Debugging (80% of your troubleshooting)
```bash
# See WHY something isn't working (most important command)
kubectl describe pod <pod-name>
kubectl describe deployment <name>

# See logs from a pod
kubectl logs <pod-name>

# Follow logs in real-time
kubectl logs -f <pod-name>

# Get a shell inside a container
kubectl exec -it <pod-name> -- bash
```

### 4. Making Changes
```bash
# Apply your YAML files (daily driver)
kubectl apply -f deployment.yaml

# Delete something
kubectl delete -f deployment.yaml
# or
kubectl delete pod <pod-name>

# Scale your Django app up/down
kubectl scale deployment <name> --replicas=10
```

### 5. Common Flags You'll Actually Use

| Flag | When to use | Example |
|------|-------------|---------|
| `-n <namespace>` | See resources in specific namespace | `kubectl get pods -n production` |
| `-A` | See everything across ALL namespaces | `kubectl get pods -A` |
| `-f` | Work with YAML files | `kubectl apply -f app.yaml` |
| `-l` | Filter by label | `kubectl get pods -l app=django` |
| `-o wide` | See more details (IPs, nodes) | `kubectl get pods -o wide` |

### 6. Real-World Workflow Example

```bash
# 1. Deploy your Django app
kubectl apply -f django-deployment.yaml

# 2. Check it's running
kubectl get pods
# Output: django-7f8g9h-abc12    Running

# 3. See the logs (is it starting up?)
kubectl logs django-7f8g9h-abc12

# 4. Oops, something's wrong. Check details
kubectl describe pod django-7f8g9h-abc12
# Look at "Events" section at bottom

# 5. Maybe need to scale up
kubectl scale deployment django --replicas=10

# 6. Check rollout status
kubectl rollout status deployment django

# 7. Get shell inside for debugging
kubectl exec -it django-7f8g9h-abc12 -- bash
# Now you're inside the container, can run python manage.py shell etc.

# 8. Port forward to test locally
kubectl port-forward pod/django-7f8g9h-abc12 8000:8000
# Now visit localhost:8000 in your browser

# 9. Expose pod
	kubectl expose deployment web

```

## The "Oh Crap" Commands (When Things Break)

```bash
# Pod stuck in CrashLoopBackOff? Check logs of crashed container
kubectl logs <pod-name> --previous

# Need to force delete a stuck pod
kubectl delete pod <pod-name> --force --grace-period=0

# Can't remember what namespace something is in?
kubectl get pods -A | grep django

# Deployment not updating? Restart it
kubectl rollout restart deployment <name>

# Undo a bad deployment
kubectl rollout undo deployment <name>
```

## Your Daily Mental Model

Just remember these 4 patterns:

1. **GET** = "Show me what's there"
   - `kubectl get pods`, `kubectl get deployments`, `kubectl get nodes`

2. **DESCRIBE** = "Why isn't this working?"
   - `kubectl describe pod <name>` (look at Events section)

3. **LOGS** = "What's it saying?"
   - `kubectl logs <pod-name>` (add `-f` to follow)

4. **APPLY** = "Make this change"
   - `kubectl apply -f file.yaml`

## One-Liners Worth Memorizing

```bash
# Watch pods in real-time (like top for containers)
kubectl get pods -w

# See resource usage
kubectl top pods
kubectl top nodes

# Switch to a different namespace (save typing -n every time)
kubectl config set-context --current --namespace=staging

# Check cluster health
kubectl cluster-info
```

That's honestly 80%+ of what you'll type day-to-day. The rest you'll Google when needed.