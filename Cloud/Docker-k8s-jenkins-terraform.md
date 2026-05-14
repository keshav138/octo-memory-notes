# DevOps Interview Study Guide

A comprehensive quiz covering the core pillars of modern DevOps: Docker, Kubernetes, Terraform, and Jenkins.

## 🐳 Docker

**Q1: What is Docker and why is it used?** Docker is a containerization platform that packages an application and all its dependencies into a lightweight, portable container, ensuring it runs consistently across different environments.

**Q2: What's the difference between a Docker image and a container?** An image is a read-only blueprint/template; a container is a running instance of that image. You can run multiple containers from the same image.

**Q3: What is a Dockerfile?** A text file containing step-by-step instructions to build a Docker image — things like base image, copying files, installing dependencies, and setting the entry command.

**Q4: What does docker-compose do?** It lets you define and run multi-container applications using a YAML file (`docker-compose.yml`), starting all services with a single command.

**Q5: What is the difference between CMD and ENTRYPOINT?** `ENTRYPOINT` sets the default executable that always runs; `CMD` provides default arguments that can be overridden at runtime. They're often used together.

**Q6: What is a Docker volume?** A volume is a persistent storage mechanism that lives outside the container's filesystem, so data survives container restarts or deletions.

**Q7: What is a Docker network?** A virtual network that lets containers communicate with each other. By default, containers on the same network can reach each other by name.

**Q8: What does `docker build -t` do?** It builds an image from a Dockerfile and tags it with a name (e.g., `docker build -t myapp:latest .`), making it easy to reference later.

**Q9: What is the difference between COPY and ADD in a Dockerfile?** Both copy files into the image, but `ADD` also supports URLs and auto-extracts tar archives. `COPY` is preferred for simple file copying since it's more explicit.

**Q10: What is a multi-stage build?** A Dockerfile technique using multiple `FROM` statements to keep the final image small — you build in one stage and copy only the output artifacts to a lean final stage.

**Q11: What does `--rm` flag do in `docker run`?** It automatically removes the container when it exits, useful for one-off tasks where you don't want leftover stopped containers.

**Q12: What is Docker Hub?** A public registry where Docker images are stored and shared. `docker pull` and `docker push` use it by default to download or upload images.

## ☸️ Kubernetes

**Q1: What is Kubernetes and what problem does it solve?** Kubernetes (K8s) is a container orchestration system that automates deployment, scaling, and management of containerized apps across a cluster of machines.

**Q2: What is a Pod?** The smallest deployable unit in Kubernetes — it wraps one or more containers that share the same network and storage, typically one container per pod.

**Q3: What is a Deployment?** A higher-level object that manages a ReplicaSet, ensuring a specified number of pod replicas are always running and handling rolling updates/rollbacks.

**Q4: What is a Service in Kubernetes?** A stable network endpoint that exposes a set of pods. Since pod IPs change, a Service gives a consistent IP/DNS name to reach them, with load balancing built in.

**Q5: What is the difference between ClusterIP, NodePort, and LoadBalancer?** `ClusterIP` is internal-only. `NodePort` exposes the service on a static port on each node. `LoadBalancer` provisions an external cloud load balancer.

**Q6: What is a ConfigMap?** An object to store non-sensitive configuration data (env vars, config files) separately from container images, making apps easier to configure without rebuilding.

**Q7: What is a Secret?** Similar to ConfigMap but for sensitive data like passwords and tokens — stored base64-encoded and injected into pods as env vars or mounted files.

**Q8: What is a Namespace?** A virtual cluster within a cluster used to isolate resources by team or environment (e.g., dev, staging, prod), useful in multi-team setups.

**Q9: What does `kubectl apply -f` do?** It applies the configuration in a YAML file to the cluster — creating or updating resources declaratively, and is the standard way to deploy workloads.

**Q10: What is a DaemonSet?** Ensures one pod runs on every (or selected) node in the cluster — commonly used for logging agents, monitoring, or network plugins.

**Q11: What is a Liveness vs Readiness probe?** Liveness checks if the container is alive (restarts it if not); Readiness checks if it's ready to receive traffic (removes it from the load balancer if not).

**Q12: What is Horizontal Pod Autoscaling (HPA)?** Automatically scales the number of pod replicas based on CPU/memory usage or custom metrics, allowing apps to handle variable traffic loads.

## 🏗️ Terraform

**Q1: What is Terraform and what is it used for?** Terraform is an Infrastructure as Code (IaC) tool by HashiCorp that lets you define, provision, and manage cloud infrastructure using declarative config files.

**Q2: What is the difference between declarative and imperative IaC?** Declarative (like Terraform) describes the desired end state and the tool figures out how to reach it. Imperative means writing step-by-step commands to get there.

**Q3: What are the main Terraform commands?** `terraform init` (initialize), `terraform plan` (preview changes), `terraform apply` (apply changes), and `terraform destroy` (remove all managed resources).

**Q4: What is a Terraform provider?** A plugin that knows how to interact with a specific API (e.g., AWS, GCP, Azure). It's declared in the config and downloaded during `terraform init`.

**Q5: What is a Terraform state file?** A `.tfstate` file that tracks which real-world resources Terraform manages. It maps config to actual resources and is used to calculate diffs on each plan.

**Q6: Why should you use remote state?** Storing state in a backend like S3 or Terraform Cloud allows team collaboration, prevents conflicts, and keeps secrets out of version control.

**Q7: What is a Terraform module?** A reusable package of `.tf` files that can be called with inputs — similar to a function. Modules promote DRY infrastructure and consistent patterns.

**Q8: What is the difference between `terraform plan` and `terraform apply`?** `plan` shows what changes would be made without making them; `apply` executes those changes. Always plan before apply in production.

**Q9: What is a data source in Terraform?** A data block that fetches read-only information from outside Terraform (e.g., existing VPC ID, latest AMI ID) to use in your configuration.

**Q10: What are Terraform workspaces?** Named instances of state, letting you use the same config for multiple environments (dev, staging, prod) without duplicating code.

**Q11: What is `terraform import`?** A command to bring an existing resource (created outside Terraform) under Terraform management by importing it into the state file.

**Q12: What is the `terraform.tfvars` file used for?** It stores variable values, keeping them separate from the main config. Terraform automatically loads it so you don't have to pass vars on every command.

## 🛠️ Jenkins

**Q1: What is Jenkins and what is it used for?** Jenkins is an open-source CI/CD automation server that builds, tests, and deploys code automatically whenever changes are pushed, helping teams deliver faster.

**Q2: What is a Jenkins Pipeline?** A suite of plugins that lets you define your entire build/test/deploy process as code in a Jenkinsfile, checked into your repo alongside the app code.

**Q3: What is the difference between Declarative and Scripted pipelines?** Declarative uses a structured, opinionated syntax (`pipeline { stages { stage {} } }`) and is easier to read. Scripted is Groovy-based and more flexible but complex.

**Q4: What is a Jenkinsfile?** A text file containing the pipeline definition, stored in the root of your repo. Jenkins reads it to know how to build and deploy your project.

**Q5: What are Jenkins agents/nodes?** Machines (or containers) where Jenkins runs build jobs. The controller schedules work to agents, letting you distribute load and use different OS environments.

**Q6: What is a Jenkins stage?** A logical step in a pipeline (e.g., Build, Test, Deploy). Stages are shown visually in the UI, making it easy to see where a pipeline passed or failed.

**Q7: What are credentials in Jenkins?** A secure store for secrets like passwords, tokens, and SSH keys. Pipelines reference them by ID (e.g., `withCredentials`) without hardcoding sensitive values.

**Q8: What is a Jenkins trigger?** A condition that starts a pipeline automatically — common ones include SCM polling (check for git changes), webhooks (GitHub push events), and cron schedules.

**Q9: What is the difference between Freestyle and Pipeline jobs?** Freestyle jobs are configured through the UI with limited flexibility. Pipeline jobs use a Jenkinsfile for full code-defined CI/CD with branching, loops, and conditions.

**Q10: What is a shared library in Jenkins?** Reusable Groovy code stored in a separate repo that multiple pipelines can import, avoiding copy-pasting common steps across Jenkinsfiles.

**Q11: What does the `post` block do in a Declarative pipeline?** It defines actions to run after stages complete — e.g., `always` (cleanup), `success` (notify), `failure` (alert). Useful for consistent post-build behavior.

**Q12: What is Blue Ocean in Jenkins?** A modern UI plugin for Jenkins that visualizes pipelines as a clear visual flow, making it easier to understand status, logs, and parallel stages at a glance.