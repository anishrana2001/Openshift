# OpenShift / Kubernetes Interview Questions and Answers — Pattern-Wise Guide

This Markdown guide arranges the questions into interview-friendly patterns:

1. Foundations: Kubernetes vs OpenShift  
2. Cluster Architecture and Installation  
3. Deployment and Application Lifecycle  
4. OpenShift Operations: MCO, Upgrades, Control Plane, etcd  
5. Troubleshooting Scenarios  
6. Security, SCC, Secrets, and Service Accounts  
7. Networking, DNS, Service Mesh, and Observability  
8. Backup, DR, Application Data, and Virtualization  
9. Large-Scale Platform Design  
10. Project Experience / Real Interview Story Format  
11. Quick Revision Sheet  

---

# 1. Foundations: Kubernetes vs OpenShift

## 1.1 What is the difference between Kubernetes and OpenShift?

### Interview Answer

Kubernetes is an open-source container orchestration platform used to deploy, scale, and manage containerized applications. OpenShift is Red Hat's enterprise Kubernetes platform built on Kubernetes, but it adds many production-ready features on top.

OpenShift includes Kubernetes plus additional components like integrated CI/CD options, image registry, Routes, Operators, OAuth integration, web console, Security Context Constraints, better enterprise support, cluster operators, and OpenShift-specific tools such as `oc`.

### Key Differences

| Area | Kubernetes | OpenShift |
|---|---|---|
| Base platform | Upstream container orchestration | Enterprise Kubernetes platform |
| CLI | `kubectl` | `oc`, also supports `kubectl` |
| Security | Pod Security Admission / RBAC | SCC, RBAC, OAuth, stricter defaults |
| Networking exposure | Ingress | Route + Ingress |
| Image registry | Optional | Integrated registry available |
| Console | Optional dashboard | Built-in web console |
| CI/CD | External tools | OpenShift Pipelines, GitOps, Builds |
| Support | Community/vendor dependent | Red Hat enterprise support |
| Operators | Optional | Operator-driven platform lifecycle |
| Node OS | Any supported Linux | Red Hat CoreOS for OCP nodes |

### Good Interview Line

> Kubernetes is the orchestration engine. OpenShift is an enterprise Kubernetes distribution with stronger security defaults, integrated developer experience, operators, routes, registry, monitoring, and lifecycle management.

---

## 1.2 What are the main components of Kubernetes Control Plane and Data Plane?

### Interview Answer

Kubernetes has two major areas: the control plane and the data plane.

The control plane manages the cluster state. It includes the API server, etcd, scheduler, controller manager, and cloud controller manager. The data plane consists of worker nodes where actual application workloads run. It includes kubelet, kube-proxy or equivalent networking, container runtime, CNI, and Pods.

### Kubernetes Control Plane Components

| Component | Role |
|---|---|
| API Server | Entry point for all cluster operations |
| etcd | Key-value store for cluster state |
| Scheduler | Assigns Pods to suitable nodes |
| Controller Manager | Runs controllers to reconcile desired state |
| Cloud Controller Manager | Integrates with cloud provider APIs |

### Kubernetes Data Plane Components

| Component | Role |
|---|---|
| Worker Node | Runs application workloads |
| Kubelet | Node agent that manages Pods |
| Container Runtime | Runs containers, usually CRI-O/containerd |
| Kube-proxy / CNI | Handles service networking |
| Pods | Smallest deployable unit |
| Volumes | Provide storage to Pods |

---

## 1.3 What are the main OpenShift components?

### Interview Answer

OpenShift includes all Kubernetes core components plus OpenShift-specific operators and services.

### OpenShift Components

| Component | Purpose |
|---|---|
| OpenShift API Server | Exposes OpenShift-specific APIs |
| Kubernetes API Server | Exposes Kubernetes APIs |
| etcd | Stores cluster state |
| Cluster Version Operator | Manages cluster upgrades |
| Machine Config Operator | Manages node OS configuration |
| Cluster Network Operator | Manages cluster networking |
| Ingress Operator | Manages routers and ingress |
| Authentication Operator | Manages OAuth and identity providers |
| Console Operator | Manages web console |
| Monitoring Operator | Provides Prometheus-based monitoring |
| Image Registry Operator | Manages internal image registry |
| Operator Lifecycle Manager | Manages operators |
| OpenShift SDN / OVN-Kubernetes | Cluster networking |
| Routes | OpenShift-native app exposure |
| SCC | Pod security enforcement |

### Good Interview Line

> OpenShift is Kubernetes plus enterprise operators, integrated registry, routes, OAuth, SCC, monitoring, console, and lifecycle automation.

---

### 1.4 Are Project and Namespace the Same in OpenShift?

**Interview Answer:**

They are almost the same, but the terminology is different.

A **Namespace** is the Kubernetes resource used to separate applications, users, and resources inside a cluster.

A **Project** is OpenShift’s user-friendly representation of a Kubernetes Namespace. When we create an OpenShift Project, OpenShift creates the corresponding Namespace and can also apply permissions, annotations, resource limits, and predefined project settings.

Therefore, the Namespace provides the technical isolation, while the Project provides an easier way for developers and teams to access and manage that isolated environment.

**Best Interview Line:**

> A Namespace is the Kubernetes foundation, while a Project is OpenShift’s user-facing way of managing that Namespace.

**Example:**

When we run:

`oc new-project development`

OpenShift creates a Namespace named `development`, gives the user access to it, and switches the current working project to it.

---

## 1.5.1 What is the difference between Project and Namespace?

### Answer

| Area | Namespace | Project |
|---|---|---|
| Platform | Kubernetes concept | OpenShift concept |
| Purpose | Resource isolation | User-facing workspace |
| Created by | `kubectl create namespace` | `oc new-project` |
| Extra metadata | Basic metadata | Display name, description, templates |
| Access model | RBAC | RBAC plus OpenShift project governance |
| User experience | Admin/dev manually uses namespace | Developer-friendly workspace |

### Commands

```bash
kubectl create namespace dev
oc new-project dev
oc get projects
oc get namespaces
```

## 1.5.2 Can we create multiple namespace inside the Project ?

OpenShift Cluster

├── Project: development   → Namespace: development

├── Project: testing       → Namespace: testing

└── Project: production    → Namespace: production

**Best Interview Line:**

> No, we cannot create multiple namespaces inside an OpenShift Project because a Project itself represents one Kubernetes Namespace. To create separate isolation boundaries, we create multiple Projects or Namespaces in the cluster.
---

## 1.6 What is SCC in OpenShift?

### Interview Answer

SCC stands for Security Context Constraints. SCCs are OpenShift security controls that define what a Pod is allowed to do. They control whether a Pod can run as root, run privileged, use host networking, mount host paths, add Linux capabilities, or use specific SELinux contexts.

SCCs are similar in goal to Kubernetes Pod Security controls but are OpenShift-specific and more integrated with OpenShift security.

### What SCC Controls

| Control | Example |
|---|---|
| Run as root | Allow or deny UID 0 |
| Privileged mode | Allow or deny privileged containers |
| Host network | Allow or deny `hostNetwork` |
| Host PID/IPC | Allow or deny host namespace access |
| HostPath volumes | Allow or deny mounting host paths |
| Linux capabilities | Allow/drop capabilities |
| SELinux | Enforce SELinux labels |
| Volume types | Control allowed volume plugins |

### Useful Commands

```bash
oc get scc
oc describe scc restricted-v2
oc adm policy who-can use scc/privileged
oc adm policy add-scc-to-user anyuid -z my-service-account -n my-namespace
```

### Good Interview Line

> SCC is one of the biggest differences between Kubernetes and OpenShift security. Many containers that run in vanilla Kubernetes fail in OpenShift because OpenShift is stricter by default.

---

# 2. Cluster Architecture and Installation

## 2.1 You are given a task to create a Kubernetes cluster in AWS. What requirement gathering will you do?

### Interview Answer

Before creating a Kubernetes or OpenShift cluster in AWS, I gather requirements across business, application, network, security, operations, compliance, and cost.

### Requirement Gathering Checklist

| Area | Questions |
|---|---|
| Business | What is the purpose of the cluster? Dev, test, production, DR? |
| Availability | Required SLA, RTO, RPO? |
| Region | Which AWS region and availability zones? |
| Cluster type | EKS, self-managed Kubernetes, ROSA, or OpenShift IPI/UPI? |
| Workloads | Stateless, stateful, batch, AI/ML, microservices? |
| Scale | Number of applications, Pods, nodes, namespaces? |
| Compute | Instance types, GPU requirement, autoscaling? |
| Networking | VPC CIDR, Pod CIDR, Service CIDR, private/public subnets? |
| Ingress | ALB/NLB, OpenShift Routes, WAF, external DNS? |
| Security | IAM, RBAC, SSO, MFA, encryption, security scanning? |
| Storage | EBS, EFS, FSx, object storage, CSI driver? |
| Registry | ECR, Quay, internal registry, image scanning? |
| CI/CD | Jenkins, Argo CD, GitHub Actions, Tekton? |
| Observability | Prometheus, CloudWatch, Grafana, Loki, EFK? |
| Backup | etcd backup, Velero/OADP, database backup? |
| Compliance | PCI, HIPAA, ISO, SOC2, audit requirements? |
| Cost | Budget, tagging, autoscaling, reserved instances? |
| Operations | Patch process, upgrade process, support model? |

### AWS-Specific Items

```text
VPC design
Subnet design
NAT gateway requirement
Load balancer type
IAM roles
Security groups
Route tables
Private endpoint requirement
EBS encryption
KMS keys
CloudWatch integration
AWS Backup / Velero / OADP
```

### Good Interview Line

> I do not start with `eksctl create cluster` or OpenShift installer immediately. I first collect workload, network, security, availability, storage, observability, compliance, and cost requirements.

---

## 2.2 Explain how you installed an OpenShift cluster step by step.

### Interview Answer

In a real project, I installed OpenShift using the installer-provisioned infrastructure method on AWS. The high-level steps were requirement gathering, preparing DNS and cloud credentials, downloading the installer and pull secret, creating the install configuration, validating network and quota, running the installer, monitoring bootstrap, validating operators, and handing over the cluster to application teams.

### Step-by-Step OCP IPI Installation

#### Step 1: Gather Requirements

```text
Region
Availability zones
Cluster name
Base domain
Node count
Instance types
Network CIDRs
Storage class
Ingress requirement
Identity provider
Logging/monitoring
Backup requirement
```

#### Step 2: Prepare Prerequisites

```text
AWS account
IAM permissions
Route53 hosted zone
SSH key
Red Hat pull secret
OpenShift installer
oc CLI
AWS CLI
```

#### Step 3: Create Install Directory

```bash
mkdir ocp-install
cd ocp-install
```

#### Step 4: Generate Install Config

```bash
openshift-install create install-config --dir=.
```

Example values:

```yaml
baseDomain: example.com
metadata:
  name: prod-ocp
platform:
  aws:
    region: ap-south-1
controlPlane:
  replicas: 3
compute:
- name: worker
  replicas: 3
```

#### Step 5: Create Cluster

```bash
openshift-install create cluster --dir=. --log-level=info
```

#### Step 6: Monitor Bootstrap

```bash
openshift-install wait-for bootstrap-complete --dir=. --log-level=debug
```

#### Step 7: Validate Cluster

```bash
export KUBECONFIG=auth/kubeconfig

oc get nodes
oc get co
oc get clusterversion
oc get pods -A
```

#### Step 8: Configure Post-Install Items

```text
Identity provider
Default storage class
Image registry
Ingress certificates
Cluster monitoring
Logging
GitOps
RBAC groups
Network policies
Backup
```

#### Step 9: Handover

```text
Admin kubeconfig
Console URL
Authentication details
Monitoring dashboards
Backup procedure
Runbook
Access process
```

### Difficulties Faced and Fixes

| Problem | Root Cause | Fix |
|---|---|---|
| Bootstrap failed | DNS record missing | Fixed Route53 records |
| Worker nodes not joining | Security group issue | Allowed required ports |
| Pull errors | Invalid pull secret | Updated pull secret |
| Operators degraded | Insufficient AWS quota | Increased quota |
| Ingress not reachable | Wrong public/private subnet tagging | Corrected subnet tags |
| Storage class issue | CSI driver/operator issue | Checked operator and AWS permissions |

### Good Interview Line

> I always validate DNS, IAM, quota, subnet routing, pull secret, and installer version before starting OpenShift installation because most installation failures happen around prerequisites.

---

## 2.3 ## 5. How do you design a multi-region OpenShift cluster?

### Interview Answer

First, I would clarify that I normally do not design one stretched OpenShift cluster across multiple distant regions. Stretching a single cluster across regions can create latency and etcd quorum problems.

My preferred approach is one OpenShift cluster per region, managed centrally using Red Hat Advanced Cluster Management and deployed consistently using GitOps tools such as Argo CD.

The design depends on the required RTO and RPO. For stateless applications, I prefer active-active across regions with global DNS or GSLB. For stateful applications, I design data replication at the database or storage layer, and I use OpenShift Data Foundation disaster recovery patterns where appropriate.

### Multi-Region Architecture

| Component | Design |
|---|---|
| Cluster model | One OpenShift cluster per region |
| Management | Red Hat Advanced Cluster Management hub |
| Deployment | Argo CD / GitOps |
| Traffic | Global DNS, GSLB, health checks, weighted routing |
| Apps | Active-active for stateless services |
| Data | Database replication or managed geo-database |
| Stateful DR | ODF Regional-DR / Metro-DR where suitable |
| Secrets | Central Vault or replicated secret manager |
| Registry | Quay or registry mirroring near each region |
| Observability | Central metrics, logs, traces with cluster labels |
| Failover | Automated or controlled based on RTO/RPO |

### Design Pattern

```text
                         Global DNS / GSLB
                               |
              -------------------------------------
              |                                   |
        Region 1 OCP Cluster              Region 2 OCP Cluster
              |                                   |
        Apps + Local Services              Apps + Local Services
              |                                   |
              -------- Replicated Data Layer -------
                               |
                         Central Observability
                         Central GitOps / ACM
```

### Important Design Decisions

| Question | Design Consideration |
|---|---|
| Active-active or active-passive? | Depends on application design and data consistency |
| What is the RTO? | Determines failover automation |
| What is the RPO? | Determines replication strategy |
| Is the app stateless? | Easier to run active-active |
| Is the database regional? | Need database-level replication |
| How are secrets managed? | Central or replicated secret backend |
| How are images distributed? | Registry mirror per region |
| How is traffic routed? | GSLB with health checks |

### Good Interview Line

> I avoid stretching etcd across regions. I design one OpenShift cluster per region, manage them through ACM and GitOps, use global traffic management, and handle state through database replication or OpenShift Data Foundation disaster recovery depending on RTO and RPO.

---
---

# 3. Deployment and Application Lifecycle

## 3.1 What happens inside the cluster when you run `kubectl apply -f deployment.yaml`?

### Interview Answer

When I run `kubectl apply -f deployment.yaml`, the manifest is sent to the Kubernetes API server. The API server authenticates the user, checks authorization through RBAC, runs admission controllers, validates the object, and stores the desired state in etcd.

The Deployment controller then notices the Deployment and creates or updates a ReplicaSet. The ReplicaSet controller ensures the required number of Pods exist. The scheduler assigns pending Pods to nodes, and kubelet starts the containers using the container runtime.

In OpenShift, additional checks like SCC, image policies, routes, and cluster operators can also be involved.

### Flow

| Step | Component | Action |
|---|---|---|
| 1 | kubectl/oc | Sends manifest |
| 2 | API Server | AuthN/AuthZ/admission |
| 3 | etcd | Stores desired state |
| 4 | Deployment Controller | Creates ReplicaSet |
| 5 | ReplicaSet Controller | Creates Pods |
| 6 | Scheduler | Assigns Pods to nodes |
| 7 | Kubelet | Starts containers |
| 8 | Service/EndpointSlice | Updates backends |

### Good Interview Line

> `kubectl apply` updates desired state. Controllers and kubelets do the actual work to make the cluster match that desired state.

---

## 3.2 How do you perform zero-downtime OpenShift upgrades?

### Interview Answer

Zero-downtime OpenShift upgrades require planning. I do not treat cluster upgrade as just clicking an upgrade button. I check cluster health, operator health, application redundancy, PodDisruptionBudgets, node capacity, backups, deprecated APIs, and maintenance windows.

OpenShift upgrades are managed by the Cluster Version Operator. The upgrade updates cluster operators and then node components through the Machine Config Operator. Worker nodes are usually drained and rebooted in a controlled manner.

### Upgrade Checklist

| Phase | Checks |
|---|---|
| Pre-check | `oc get co`, `oc get nodes`, `oc adm upgrade` |
| Backup | Take etcd backup |
| App readiness | Replicas > 1, PDB configured |
| Capacity | Enough spare capacity during node drain |
| APIs | Check deprecated/removed APIs |
| Operators | Ensure all operators are compatible |
| Maintenance | Notify teams and define rollback/restore plan |
| Upgrade | Upgrade through web console or CLI |
| Monitor | Watch operators, nodes, MCPs |
| Post-check | Validate apps, routes, monitoring, logs |

### Commands

```bash
oc get clusterversion
oc adm upgrade
oc get co
oc get mcp
oc get nodes
oc adm must-gather
```

### Application Requirements for Zero Downtime

```text
At least 2 replicas
Readiness probe configured
PodDisruptionBudget configured
RollingUpdate strategy
Enough cluster capacity
Stateless or properly replicated state
External dependency health
```

### Good Interview Line

> Cluster upgrades are only zero-downtime if applications are designed for disruption. OpenShift can upgrade safely, but workloads need replicas, readiness probes, PDBs, and spare capacity.

---

## 3.3 A deployment succeeds in staging but fails in production. What are the most likely causes and how do you systematically identify them?

### Interview Answer

If the same deployment succeeds in staging but fails in production, I compare differences between the environments. The issue is usually configuration, resource limits, security policies, image access, networking, secrets, storage, or version drift.

### Likely Causes

| Area | Possible Cause |
|---|---|
| Config | Different ConfigMap or environment variable |
| Secrets | Missing or wrong secret in production |
| RBAC | ServiceAccount lacks permission |
| SCC/PSS | Production has stricter security |
| Resources | Lower limits or no capacity in production |
| Image | ImagePullBackOff due to registry access |
| Network | NetworkPolicy blocks dependency |
| Storage | PVC/storage class missing |
| DNS | Different service name or namespace |
| Database | Production DB credentials or schema mismatch |
| Version | Different Kubernetes/OCP version |
| Admission | Production has stricter admission policy |

### Systematic Troubleshooting

```bash
oc rollout status deployment/app -n prod
oc describe deployment app -n prod
oc get pods -n prod
oc describe pod pod-name -n prod
oc logs pod-name -n prod --previous
oc get events -n prod --sort-by=.lastTimestamp
oc get configmap,secret -n prod
oc get rolebinding,serviceaccount -n prod
oc get networkpolicy -n prod
oc get pvc -n prod
```

### Compare Staging vs Production

```bash
oc get deployment app -n staging -o yaml > staging.yaml
oc get deployment app -n prod -o yaml > prod.yaml
diff staging.yaml prod.yaml
```

### Good Interview Line

> I do not assume the code is wrong first. I compare staging and production across config, secrets, RBAC, SCC, resources, networking, storage, image access, and cluster policy.

---

## 3.4 A deployment went out and now health checks are passing but users report 500 errors. How do you investigate?

### Interview Answer

If health checks pass but users see 500 errors, it means the basic `/health` endpoint is not covering real user paths or dependencies. I check application logs, ingress/router logs, traces, metrics, dependency health, and recent deployment changes.

### Investigation Steps

#### 1. Confirm Scope

```text
All users or some users?
One route or multiple routes?
One region or all regions?
One API endpoint or all endpoints?
Started after latest deployment?
```

#### 2. Check Rollout and Pods

```bash
oc rollout history deployment/app -n prod
oc rollout status deployment/app -n prod
oc get pods -n prod -o wide
oc describe pod pod-name -n prod
```

#### 3. Check Logs

```bash
oc logs -n prod deploy/app --since=30m
oc logs -n prod pod-name --previous
```

Look for:

```text
NullPointerException
DB connection error
timeout
authentication failure
external API failure
schema mismatch
bad config
```

#### 4. Check Metrics

```text
5xx rate
p95/p99 latency
CPU/memory
DB connection pool
queue lag
dependency latency
```

#### 5. Check Traces

Use trace ID/request ID to identify the exact failing downstream call.

#### 6. Compare Health vs Real Dependency

The health check may only verify that the process is alive. A better readiness probe should verify critical dependencies or use separate deep health checks.

### Actions

| Finding | Action |
|---|---|
| Bad deployment | Roll back |
| Missing config | Fix ConfigMap/Secret and restart |
| DB issue | Fix DB connectivity or schema |
| Dependency failure | Add timeout/fallback/circuit breaker |
| Bad readiness check | Improve readiness probe |
| Partial traffic failure | Check route, service, endpoints |

### Good Interview Line

> Passing health checks do not prove the application is working for real users. I validate real transaction paths, dependencies, logs, metrics, and traces.

---

## 3.5 A container is crashing immediately after startup in production but works fine locally. How will you fix?

### Interview Answer

I treat this as a difference between local and production runtime. I check logs, events, command/entrypoint, environment variables, secrets, file permissions, SCC restrictions, resource limits, image architecture, and dependency availability.

### Commands

```bash
oc get pods -n prod
oc describe pod pod-name -n prod
oc logs pod-name -n prod
oc logs pod-name -n prod --previous
oc get events -n prod --sort-by=.lastTimestamp
```

### Likely Causes

| Cause | Why It Works Locally But Fails in OCP |
|---|---|
| Runs as root locally | OpenShift runs with random non-root UID |
| Missing env variable | Local `.env` file exists, prod secret missing |
| File permission issue | App cannot write to directory |
| Wrong command | Entrypoint different in Kubernetes |
| Secret missing | Production secret not mounted |
| ConfigMap missing | App cannot read config |
| Port mismatch | App listens on wrong port |
| Dependency unavailable | DB/API/DNS blocked in prod |
| Resource limit | App killed or throttled |
| Image architecture | Wrong architecture image |

### OpenShift-Specific Fixes

```text
Do not require root user
Use writable directories like /tmp
Set proper file permissions
Use fsGroup if needed
Avoid writing to read-only image directories
Use correct SCC only when justified
```

### Good Dockerfile Practice

```dockerfile
RUN chmod -R g=u /app
USER 1001
```

### Good Interview Line

> If it works locally but crashes in OpenShift, my first suspicion is runtime difference: non-root UID, missing config/secrets, file permissions, resource limits, or network dependency.

---

## 3.6 How to write Dockerfile without using any base image?

### Interview Answer

A Dockerfile without a normal base image uses `FROM scratch`. `scratch` is an empty image. It is useful for statically compiled binaries, especially Go applications.

You cannot use package managers, shells, or OS libraries inside `scratch` unless you copy them in. That means commands like `sh`, `bash`, `apt`, or `yum` will not work.

### Example: Go Binary with Scratch

```dockerfile
# Build stage
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app main.go

# Final minimal image
FROM scratch
COPY --from=builder /src/app /app
ENTRYPOINT ["/app"]
```

### Important Notes

| Item | Explanation |
|---|---|
| `FROM scratch` | Empty image |
| No shell | Cannot run `/bin/sh` |
| No package manager | Cannot install packages |
| Static binary needed | Best for Go/Rust/static C |
| Certificates | Need to copy CA certs if app calls HTTPS |
| User | Need to handle UID/security carefully |

### Example with CA Certificates

```dockerfile
FROM golang:1.22 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o app main.go

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /src/app /app
USER 1001
ENTRYPOINT ["/app"]
```

### Good Interview Line

> A Dockerfile cannot truly run without any filesystem at all, but it can use `FROM scratch`, which starts from an empty image. It is best for statically compiled binaries.

---

# 4. OpenShift Operations: MCO, Control Plane, etcd, Upgrades

## 4.1 How does MachineConfig Operator work?

### Interview Answer

The Machine Config Operator manages the operating system configuration of OpenShift nodes. It applies MachineConfig objects to groups of nodes through MachineConfigPools. It can update files, systemd units, kernel arguments, registries, SSH keys, and other node-level settings.

The MCO renders MachineConfigs into a rendered configuration for each MachineConfigPool. The Machine Config Daemon runs on each node, compares the current node state with the desired rendered config, drains the node if required, applies the change, reboots the node when needed, and brings it back.

### Main Components

| Component | Role |
|---|---|
| MachineConfig | Desired node OS configuration |
| MachineConfigPool | Group of nodes receiving config |
| MachineConfigController | Creates rendered configs |
| MachineConfigDaemon | Applies config on each node |
| MachineConfigServer | Serves ignition configs |
| MachineConfigOperator | Overall lifecycle management |

### Common Commands

```bash
oc get mcp
oc describe mcp worker
oc get machineconfig
oc describe machineconfig rendered-worker-xxxxx
oc get pods -n openshift-machine-config-operator
oc logs -n openshift-machine-config-operator ds/machine-config-daemon
```

### What Happens During an MCO Change?

```text
1. Admin creates or updates MachineConfig.
2. MCO renders a new configuration.
3. MCP detects new desired config.
4. MCD on each node starts update.
5. Node is cordoned/drained if needed.
6. Config is applied.
7. Node reboots if required.
8. Node returns to Ready.
9. MCP becomes Updated.
```

### Good Interview Line

> MCO is responsible for keeping node OS configuration declarative and consistent. It works through MachineConfigs, MachineConfigPools, rendered configs, and the Machine Config Daemon.

---

## 4.2 How do you recover a failed control plane node?

### Interview Answer

The recovery approach depends on whether the cluster still has etcd quorum.

If only one control plane node fails in a three-master cluster, the cluster usually still has quorum. I would replace the failed master node, ensure it joins the cluster, and verify etcd membership and cluster operators.

If the majority of control plane nodes are lost, then it becomes a disaster recovery scenario and I may need to restore etcd from a valid backup.

### Scenario 1: One Control Plane Node Failed, Quorum Exists

#### Steps

```bash
oc get nodes
oc get co
oc get pods -n openshift-etcd
oc get machine -n openshift-machine-api
```

For IPI clusters:

```text
Delete failed Machine object
Machine API recreates node
Verify node joins
Verify etcd member health
Verify cluster operators
```

Example:

```bash
oc delete machine failed-master -n openshift-machine-api
oc get machines -n openshift-machine-api
oc get nodes
```

#### Validate

```bash
oc get co
oc get nodes
oc get pods -n openshift-etcd
```

### Scenario 2: Majority Control Plane Lost

This is quorum loss. Restore from etcd backup using the OpenShift documented recovery procedure.

### Good Interview Line

> First I check whether etcd quorum is still available. If quorum exists, I replace the failed control plane node. If quorum is lost, I move to etcd disaster recovery from a valid backup.

---

## 4.3 How do you take etcd backup in OpenShift?

### Interview Answer

In OpenShift, etcd backup is usually taken from one healthy control plane node using the `cluster-backup.sh` script. I do not take backups from all masters. I take backup from one control plane node and store it securely outside the cluster.

### Steps

#### 1. SSH to a Control Plane Node

```bash
ssh core@master-0
```

#### 2. Become Root

```bash
sudo -i
```

#### 3. Run Backup Script

```bash
mkdir -p /home/core/backup
/usr/local/bin/cluster-backup.sh /home/core/backup
```

#### 4. Verify Backup Files

```bash
ls -lh /home/core/backup
```

Expected output usually includes:

```text
snapshot_*.db
static_kuberesources_*.tar.gz
```

#### 5. Copy Backup Outside Cluster

```bash
scp core@master-0:/home/core/backup/* .
```

### Best Practices

| Practice | Reason |
|---|---|
| Backup after upgrades | Restore must match cluster version |
| Store outside cluster | Cluster failure should not lose backup |
| Encrypt backup | Backup contains sensitive cluster state |
| Test restore | Untested backup is not reliable |
| Automate backup | Regular DR readiness |
| Keep version metadata | Match backup with OCP version |

### Good Interview Line

> In OpenShift, etcd backup is taken from a single control plane node using `cluster-backup.sh`, and the backup must be stored securely outside the cluster.

---

## 4.4 How do you restore etcd in OpenShift?

### Interview Answer

etcd restore is a disaster recovery operation. I use it only when the cluster has lost majority control plane members or when I need to restore the cluster to a previous state.

The restore must use a backup from the same OpenShift z-stream version. I follow the official OpenShift restore procedure carefully.

### High-Level Restore Flow

```text
1. Identify recovery control plane host.
2. Copy etcd snapshot and static pod resources to recovery host.
3. Stop static pods as required by procedure.
4. Run cluster-restore.sh with backup path.
5. Wait for etcd and API server to come back.
6. Verify cluster operators.
7. Remove/recreate failed control plane nodes if needed.
8. Validate workloads.
```

### Important Warning

```text
etcd restore is not a normal rollback tool.
It restores cluster state to a previous point in time.
Any resources created after the backup can be lost.
```

### Validation Commands

```bash
oc get nodes
oc get co
oc get clusterversion
oc get pods -A
oc get pods -n openshift-etcd
```

### Good Interview Line

> etcd restore is a last-resort DR process. I first check quorum. If quorum is lost, I restore from a version-compatible etcd backup and then validate control plane, operators, and workloads.

---

## 4.5 API is down in production. What steps will you take?

### Interview Answer

If the Kubernetes/OpenShift API is down, I treat it as a control-plane incident. I first confirm whether the issue is API server, load balancer, DNS, authentication, network, or etcd.

### Step-by-Step Approach

#### 1. Confirm User Impact

```bash
oc whoami
oc get nodes
curl -k https://api.cluster.example.com:6443/readyz
```

#### 2. Check DNS and Load Balancer

```bash
nslookup api.cluster.example.com
curl -k https://api.cluster.example.com:6443/healthz
```

Check:

```text
DNS record
Load balancer health
Security groups/firewall
API VIP
Network path
```

#### 3. SSH to Control Plane Node

If API is unreachable externally, SSH to a master node.

```bash
ssh core@master-0
sudo crictl ps
sudo crictl logs <kube-apiserver-container-id>
```

#### 4. Check Static Pods

```bash
sudo crictl ps | grep kube-apiserver
sudo crictl ps | grep etcd
sudo crictl ps | grep kube-controller
sudo crictl ps | grep kube-scheduler
```

#### 5. Check etcd Health

```bash
sudo crictl ps | grep etcd
sudo crictl logs <etcd-container-id>
```

#### 6. Check Node Resources

```bash
df -h
free -m
top
journalctl -u kubelet -n 100
```

### Possible Causes

| Cause | Symptom |
|---|---|
| API LB down | API unavailable externally |
| DNS issue | API hostname not resolving |
| etcd down | API server cannot read state |
| Disk full | API/etcd static pods fail |
| Certificate issue | TLS/auth errors |
| Node failure | One or more masters unreachable |
| Network issue | Masters cannot communicate |
| Kubelet issue | Static pods not running |

### Immediate Actions

| Finding | Action |
|---|---|
| LB/DNS issue | Fix DNS/LB/security groups |
| One master down | Replace/recover node |
| etcd quorum lost | Start DR process |
| Disk full | Free disk carefully |
| Certificate issue | Check cert rotation and operator status |
| Kubelet down | Restart/fix kubelet on master |

### Good Interview Line

> For API downtime, I check from outside-in: DNS, load balancer, API health, then from inside the control plane: kube-apiserver static pod, etcd health, kubelet, disk, certificates, and node status.

---

## 4.6 etcd is consuming 95% disk. What will you do?

### Interview Answer

etcd disk usage at 95% is a critical control-plane incident. I do not randomly delete etcd files. I first identify what disk is full, check etcd alarms/logs, take a backup if possible, and follow documented defrag/cleanup procedures.

### Immediate Checks

```bash
df -h
sudo du -sh /var/lib/etcd/*
sudo crictl ps | grep etcd
sudo crictl logs <etcd-container-id>
```

From cluster if API is available:

```bash
oc get co
oc get pods -n openshift-etcd
oc get events -n openshift-etcd
```

### What I Check

| Check | Reason |
|---|---|
| Disk partition | Confirm actual full filesystem |
| etcd DB size | Check if etcd database is large |
| Logs | Check compaction/defrag errors |
| Events | Identify control-plane issues |
| Backup | Ensure DR safety |
| Large objects | Check excessive secrets/configmaps/events |
| Audit/log files | Ensure not confusing etcd with log growth |

### Possible Causes

```text
Too many Kubernetes events
Too many secrets/configmaps
High churn controllers
Large CRDs/custom resources
Misbehaving operators
No compaction/defrag issue
Disk too small
Logs filling same partition
```

### Safe Actions

```text
1. Take etcd backup if possible.
2. Check etcd health and alarms.
3. Identify large resource growth.
4. Remove unnecessary high-churn resources.
5. Follow OpenShift-supported etcd defrag procedure if required.
6. Expand disk if supported/needed.
7. Monitor etcd DB size and disk alerts.
```

### Unsafe Actions

```text
Do not manually delete files from /var/lib/etcd.
Do not reboot all masters together.
Do not restore without understanding current quorum.
Do not run random etcdctl operations without backup.
```

### Good Interview Line

> At 95% etcd disk usage, I treat it as a control-plane emergency. I take backup, preserve quorum, identify growth, follow supported defrag/cleanup procedures, and never manually delete etcd files.

---

# 5. Troubleshooting Scenarios

## 5.1 You are migrating an application from Kubernetes to OpenShift and your container is not running. How will you troubleshoot it?

### Interview Answer

When an application runs in Kubernetes but fails in OpenShift, I first check OpenShift security differences. OpenShift is stricter by default, especially around running as root, file permissions, host access, and SCC.

### Troubleshooting Commands

```bash
oc get pods -n app-ns
oc describe pod pod-name -n app-ns
oc logs pod-name -n app-ns
oc logs pod-name -n app-ns --previous
oc get events -n app-ns --sort-by=.lastTimestamp
oc get scc
oc adm policy who-can use scc/anyuid
```

### Common Migration Issues

| Issue | Cause | Fix |
|---|---|---|
| Permission denied | Random non-root UID | Fix image permissions |
| Container needs root | OpenShift restricted SCC blocks root | Refactor image or use controlled SCC |
| Cannot bind port 80 | Non-root cannot bind privileged port | Use port 8080 |
| Writes to `/app` fail | Directory not writable | Use `/tmp` or group-writable dir |
| HostPath blocked | SCC does not allow hostPath | Use PVC |
| Privileged container blocked | Restricted SCC | Avoid privileged or justify SCC |
| Image pull fail | Registry secret missing | Add imagePullSecret |
| Route not working | Service/Route mismatch | Check service targetPort |

### Best Fix

Instead of giving `anyuid` or `privileged` immediately, I fix the container image to run as non-root and use proper permissions.

### Good Interview Line

> In Kubernetes-to-OpenShift migration, the first thing I check is SCC and non-root compatibility. OpenShift usually exposes hidden container security issues.

---

## 5.2 Your Kubernetes Pods are being OOMKilled repeatedly despite the application appearing to run fine locally. The memory limit is set to 512Mi but the process only uses 200MB. How do you fix this?

### Interview Answer

OOMKilled means the container exceeded its memory cgroup limit, even if the main process appears to use less memory. The difference can come from JVM heap, native memory, sidecars, page cache, memory spikes, tmpfs, threads, or multiple processes inside the container.

### Investigation

```bash
kubectl describe pod pod-name -n app-ns
kubectl logs pod-name -n app-ns --previous
kubectl top pod pod-name -n app-ns
kubectl get pod pod-name -n app-ns -o yaml
```

Check:

```text
Exit code 137
Reason: OOMKilled
Memory limit
Memory requests
Sidecars
Application runtime settings
Peak memory, not average memory
```

### Why Process Shows 200MB But OOM Happens

| Reason | Explanation |
|---|---|
| Peak memory spike | Average is 200MB but peak exceeds 512Mi |
| JVM native memory | Heap is not total process memory |
| Page cache | Container memory includes cache |
| tmpfs | EmptyDir memory counts toward limit |
| Sidecar | Pod has another container using memory |
| Multiple processes | Main process is not the only memory user |
| Thread stacks | Many threads consume memory |
| Memory leak | Gradual growth before kill |

### Fixes

| Fix | Example |
|---|---|
| Increase limit | 512Mi to 1Gi after measurement |
| Set request properly | Request based on normal usage |
| Tune JVM | `-XX:MaxRAMPercentage=70` |
| Check sidecar | Measure per-container usage |
| Reduce tmpfs usage | Avoid memory-backed emptyDir |
| Add monitoring | Alert before OOM |
| Load test | Reproduce production traffic |
| Profile memory | Heap dump/native memory tracking |

### Example Resource Fix

```yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
  limits:
    memory: "1Gi"
    cpu: "500m"
```

### Good Interview Line

> I trust cgroup memory more than local process observation. OOMKilled is based on container memory usage including spikes, cache, sidecars, native memory, and runtime overhead.

---

## 5.3 A microservice can reach the internet but cannot resolve internal DNS for other services. What do you check?

### Interview Answer

If internet works but internal DNS fails, I troubleshoot DNS path inside the cluster.

### Steps

#### 1. Test DNS from Pod

```bash
oc exec -n app-ns pod-name -- nslookup service-name
oc exec -n app-ns pod-name -- nslookup service-name.target-ns.svc.cluster.local
oc exec -n app-ns pod-name -- cat /etc/resolv.conf
```

#### 2. Check DNS Policy

```bash
oc get pod pod-name -n app-ns -o yaml | grep dnsPolicy -A5
```

Expected:

```yaml
dnsPolicy: ClusterFirst
```

#### 3. Check OpenShift DNS

```bash
oc get pods -n openshift-dns
oc get svc -n openshift-dns
oc logs -n openshift-dns -l dns.operator.openshift.io/daemonset-dns=default
oc get co dns
```

#### 4. Check Service and Endpoints

```bash
oc get svc -n target-ns
oc get endpoints -n target-ns
oc get endpointslice -n target-ns
```

#### 5. Check NetworkPolicy

```bash
oc get networkpolicy -A
```

DNS traffic to CoreDNS/OpenShift DNS should be allowed on UDP/TCP 53.

### Good Interview Line

> Since internet works but internal DNS fails, I check FQDN, Pod DNS policy, OpenShift DNS/CoreDNS health, NetworkPolicy for port 53, and whether the target Service has endpoints.

---

## 5.4 A container is crashing immediately after startup in production but works fine locally. How will you fix?

See section **3.5**.

---

## 5.5 API is down in production. What steps will you take?

See section **4.5**.

---

## 5.6 A deployment went out and health checks are passing but users are getting 500 errors. How do you investigate?

See section **3.4**.

---

## 5.7 You are seeing a latency spike in production. Walk me through how you would use logs, metrics, and traces together to find root cause in under 15 minutes.

### Interview Answer

I follow a correlation approach: metrics tell me where the problem is, traces tell me which dependency is slow, and logs prove the exact error.

### 0–2 Minutes: Confirm Blast Radius

```text
Check p95/p99 latency
Check 5xx rate
Check affected route/service/namespace
Check if issue is one region or all regions
Check latest deployment/change
```

### 2–5 Minutes: Metrics

Check RED metrics:

| Metric | Meaning |
|---|---|
| Rate | Traffic volume |
| Errors | 4xx/5xx |
| Duration | Latency p95/p99 |

Also check:

```text
CPU throttling
Memory pressure
Pod restarts
HPA events
Ingress/router latency
DB connection pool
Queue lag
DNS latency
Sidecar metrics
```

### 5–10 Minutes: Traces

Open slow traces and identify the longest span:

```text
Application handler
Database
External API
Auth service
DNS lookup
Downstream microservice
Message queue
```

### 10–15 Minutes: Logs

Filter logs using trace ID/request ID:

```bash
oc logs -n prod deploy/app --since=15m
oc logs -n prod pod-name --since=15m
```

Look for:

```text
Timeouts
Connection refused
DB slow query
TLS error
DNS failure
OOMKilled
Rate limiting
Retry storm
```

### Decision

| Root Cause | Action |
|---|---|
| Bad deployment | Roll back |
| CPU/memory saturation | Scale/tune resources |
| DB slow | Check locks/queries/pool |
| Dependency slow | Timeout/fallback/circuit breaker |
| One bad node | Cordon/drain |
| DNS issue | Check DNS operator/network policy |
| Retry storm | Reduce retries and add backoff |

### Good Interview Line

> I do not search logs randomly. I use metrics to find the service, traces to find the slow dependency, and logs with trace ID to confirm the root cause.

---

# 6. Security, SCC, Secrets, and Service Accounts

## 6.1 How do you handle secret management in Kubernetes at scale?

### Interview Answer

At scale, I do not store raw secrets directly in Git or create them manually in every namespace. I use an external secret manager such as HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, GCP Secret Manager, or an enterprise KMS-backed solution.

Then I sync or mount secrets using External Secrets Operator, Secrets Store CSI Driver, Sealed Secrets, or SOPS depending on the GitOps model.

### Strategy

| Area | Practice |
|---|---|
| Source of truth | External secret manager |
| GitOps | Store encrypted secrets or ExternalSecret CRs |
| Access | Namespace-level least privilege |
| Rotation | Automated rotation |
| Encryption | etcd encryption at rest |
| Audit | Track reads/writes |
| Workload identity | Prefer short-lived identity |
| OpenShift | Use ESO, SCC, RBAC, namespace isolation |

### Good Interview Line

> Kubernetes Secrets are not an enterprise secret-management solution by themselves. At scale, I externalize secrets, automate rotation, control access, and audit usage.

---

## 6.2 What is your approach to securing a Kubernetes cluster?

### Interview Answer

I secure Kubernetes/OpenShift in layers: authentication, authorization, workload security, network security, secrets, image security, node hardening, audit, runtime detection, and backup.

### Security Layers

| Layer | Controls |
|---|---|
| Authentication | SSO, OAuth, MFA |
| Authorization | RBAC least privilege |
| Pod security | SCC/PSS, non-root workloads |
| Network | Default-deny NetworkPolicy |
| Secrets | External manager, encryption, rotation |
| Images | Scanning, signing, trusted registry |
| Nodes | Patch, harden, restrict SSH |
| API | Audit logs, admission control |
| Runtime | Detect exec, privilege escalation |
| Backup | etcd/application backups |

### Good Interview Line

> My model is default-deny, least privilege, non-root workloads, network segmentation, secure supply chain, external secrets, and continuous audit.

---

## 6.3 An attacker gains access using a stolen service account token. What can they do, and how do you limit the blast radius?

### Interview Answer

A stolen service account token gives the attacker the permissions of that ServiceAccount. The impact depends on RBAC, SCC, NetworkPolicy, and secret access.

### What the Attacker Can Do

| Permission | Attacker Can |
|---|---|
| `get/list secrets` | Steal secrets |
| `create pods` | Run malicious workloads |
| `exec pods` | Access running containers |
| `patch deployments` | Inject malicious images |
| `create rolebindings` | Escalate privileges |
| `list services` | Map internal network |
| `create jobs` | Establish persistence |
| `use privileged SCC` | Attempt node compromise |

### How to Limit Damage

| Control | Action |
|---|---|
| RBAC | Least privilege |
| Namespace scope | Avoid cluster-wide permissions |
| Token | Short-lived projected tokens |
| Automount | Disable where not needed |
| SCC/PSS | Block privileged pods |
| NetworkPolicy | Restrict lateral movement |
| Secrets | Avoid list/watch secrets |
| Audit | Alert suspicious service account calls |
| Rotation | Rotate affected credentials |

### Useful Commands

```bash
oc auth can-i --as=system:serviceaccount:app-ns:app-sa --list -n app-ns
oc adm policy who-can get secrets -n app-ns
oc adm policy who-can create pods -n app-ns
oc adm policy who-can use scc/privileged
oc get rolebinding,clusterrolebinding -A | grep app-sa
```

### Good Interview Line

> A stolen service account token is only as dangerous as the permissions attached to it. I limit blast radius with least privilege, short-lived tokens, SCC, NetworkPolicy, and audit.

---

## 6.4 What is SCC and why does it matter during migration?

See section **1.6** and **5.1**.

---

# 7. Networking, DNS, Service Mesh, and Observability

## 7.1 What is your experience with service meshes?

### Interview Answer

I have worked with service mesh concepts such as Istio and OpenShift Service Mesh for service-to-service traffic management, mTLS, canary deployments, retries, timeouts, circuit breakers, authorization, and observability.

I use service mesh when a platform needs consistent east-west traffic security and visibility without requiring every team to build these capabilities into application code.

### Use Cases

| Use Case | Service Mesh Capability |
|---|---|
| Encryption | mTLS |
| Identity | Workload identity |
| Canary | Weighted routing |
| Resilience | Retries/timeouts/circuit breaker |
| Observability | Metrics/traces/service graph |
| Authorization | Service-to-service access policy |
| Egress | Controlled outbound traffic |

### Good Interview Line

> I use service mesh when platform-level traffic control, security, and observability are needed consistently across microservices.

---

## 7.2 What is a service mesh and what problems does it solve that a traditional load balancer does not?

### Interview Answer

A traditional load balancer distributes traffic, mainly north-south traffic entering the application. A service mesh controls east-west traffic between microservices inside the cluster.

### Comparison

| Capability | Load Balancer | Service Mesh |
|---|---|---|
| Basic traffic distribution | Yes | Yes |
| East-west control | Limited | Strong |
| mTLS between services | No/limited | Yes |
| Service identity | Limited | Yes |
| Fine-grained authorization | Limited | Yes |
| Canary splitting | Limited | Yes |
| Retries/timeouts | Basic | Advanced |
| Circuit breaking | Limited | Yes |
| Distributed tracing | No | Yes |
| Service graph | No | Yes |

### Good Interview Line

> A load balancer distributes traffic. A service mesh secures, observes, and controls service-to-service communication.

---

## 7.3 How would you scale Prometheus for a multi-cluster Kubernetes environment?

### Interview Answer

I would not use one central Prometheus to scrape all Pods in all clusters. I would run Prometheus locally in each cluster and aggregate metrics centrally using Thanos, Cortex, Mimir, Prometheus remote write, federation, or Red Hat ACM Observability.

### Architecture

```text
Cluster A Prometheus ----\
Cluster B Prometheus -----\
Cluster C Prometheus ------> Central Query / Long-Term Storage
Cluster D Prometheus -----/
```

### Design

| Area | Approach |
|---|---|
| Scraping | Local per cluster |
| HA | Prometheus HA pairs |
| Scale | Sharding |
| Labels | cluster, region, env, tenant |
| Storage | Object storage |
| Query | Thanos/Cortex/Mimir |
| Alerting | Local critical + global SLO alerts |
| Cardinality | Strict metric label governance |

### Good Interview Line

> Keep scraping local, aggregate global. Use per-cluster Prometheus, HA, sharding, remote write/Thanos, and strict cardinality control.

---

# 8. Backup, DR, Application Data, and Virtualization

## 8.1 Is it possible to create a VM in the OpenShift cluster?

### Interview Answer

Yes. OpenShift supports virtual machines using OpenShift Virtualization, which is based on KubeVirt. It allows teams to run and manage VMs alongside containers on the same OpenShift platform.

### Use Cases

| Use Case | Example |
|---|---|
| Legacy apps | Apps not yet containerized |
| Migration | Move VMs to OpenShift |
| Hybrid workload | Containers + VMs |
| Modernization | Gradual VM-to-container journey |
| Dev/Test | Temporary VM environments |

### Common Commands

```bash
oc get csv -n openshift-cnv
oc get kubevirt -n openshift-cnv
oc get vm -A
oc get vmi -A
```

### Good Interview Line

> Yes, with OpenShift Virtualization we can run VMs on OpenShift, which helps support legacy workloads and migration paths while using Kubernetes-style management.

---

## 8.2 How do you take the backup of your application data in OpenShift?

### Interview Answer

Application backup depends on what needs to be protected. I separate cluster state backup from application data backup.

etcd backup protects cluster state, not necessarily application-level data. Application backup should include Kubernetes manifests, persistent volume data, database backups, secrets/configs, and external dependencies.

### Backup Areas

| Data Type | Backup Method |
|---|---|
| Kubernetes manifests | GitOps repository |
| Persistent volumes | OADP/Velero with CSI snapshots |
| Databases | Database-native backup |
| Secrets | External secret manager backup |
| Images | Registry backup or mirror |
| Cluster state | etcd backup |
| VM workloads | OADP with OpenShift Virtualization plugin |

### OADP / Velero Flow

```text
1. Install OADP Operator.
2. Configure backup storage location.
3. Configure snapshot location.
4. Create Backup CR.
5. Verify backup status.
6. Test restore in non-prod.
```

### Example Backup CR

```yaml
apiVersion: velero.io/v1
kind: Backup
metadata:
  name: app-backup
  namespace: openshift-adp
spec:
  includedNamespaces:
  - app-ns
  storageLocation: default
```

### Good Interview Line

> etcd backup is for cluster state. Application backup requires GitOps manifests, PVC snapshots, database-native backup, secrets backup, and tested restore procedures.

---

## 8.3 How do you take etcd backup and restore in OpenShift?

See sections **4.3** and **4.4**.

---

# 9. Large-Scale Platform Design

## 9.1 Cluster is running 500+ microservices. How would you design it?

### Interview Answer

For 500+ microservices, I focus on platform scalability, tenancy, security, observability, deployment standardization, and governance. I would not let every team deploy differently.

### Design Areas

| Area | Design |
|---|---|
| Tenancy | Namespace/project per team or app domain |
| RBAC | Group-based least privilege |
| Network | Default-deny NetworkPolicies |
| CI/CD | Standard GitOps pipelines |
| Ingress | Route/Ingress standards |
| Service mesh | For critical east-west traffic |
| Observability | Standard logs, metrics, traces |
| Resource mgmt | Quotas, LimitRanges, HPA |
| Secrets | External secret manager |
| Policies | Admission control / OPA / Kyverno |
| Images | Trusted registry, scanning |
| Reliability | PDB, probes, SLOs |
| Cost | Chargeback/showback labels |
| Multi-cluster | Split by environment, region, business unit, or scale |

### Namespace Pattern

```text
team-a-dev
team-a-test
team-a-prod
team-b-dev
team-b-test
team-b-prod
```

### Standard Application Requirements

```text
Readiness/liveness probes
Resource requests/limits
PDB
HPA
Security context
Non-root image
NetworkPolicy
Centralized logging
Metrics endpoint
Trace propagation
```

### Good Interview Line

> At 500+ microservices, the challenge is not only Kubernetes scale. The real challenge is governance, standardization, observability, security, deployment consistency, and team autonomy.

---

## 9.2 How will you handle drift in Kubernetes using Jenkins?

### Interview Answer

Configuration drift happens when the live cluster state differs from the desired state stored in Git. With Jenkins, I handle drift by making Git the source of truth and running scheduled drift detection jobs.

### Approach

| Step | Action |
|---|---|
| 1 | Store manifests/Helm/Kustomize in Git |
| 2 | Jenkins pulls desired config |
| 3 | Jenkins compares desired vs live |
| 4 | Generate diff report |
| 5 | Fail pipeline or alert if drift exists |
| 6 | Optionally auto-correct with approval |
| 7 | Store audit trail |

### Example Drift Detection Commands

```bash
kubectl diff -f manifests/
kubectl apply --server-side --dry-run=server -f manifests/
helm diff upgrade app chart/ -n app-ns
kustomize build overlays/prod | kubectl diff -f -
```

### Jenkins Pipeline Example

```groovy
pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Detect Drift') {
      steps {
        sh '''
          kustomize build overlays/prod > desired.yaml
          kubectl diff -f desired.yaml || true
        '''
      }
    }

    stage('Apply With Approval') {
      steps {
        input message: 'Apply desired state to fix drift?'
        sh 'kubectl apply -f desired.yaml'
      }
    }
  }
}
```

### Better Alternative

For Kubernetes drift management, GitOps tools like Argo CD or Flux are usually better than Jenkins because they continuously reconcile desired and live state.

### Good Interview Line

> Jenkins can detect and correct drift using `kubectl diff`, Helm diff, and Git as source of truth, but for continuous drift reconciliation I prefer Argo CD or Flux.

---

# 10. Project Experience / Real Interview Story Format

## 10.1 Explain a project experience in deploying an OpenShift cluster and how you addressed deployment errors.

### STAR-Based Interview Answer

### Situation

In one project, we had to deploy an OpenShift cluster on AWS for multiple application teams. The requirement was to support production-grade microservices with secure access, centralized monitoring, GitOps deployment, and high availability.

### Task

My responsibility was to help with cluster installation, validate prerequisites, configure post-install components, onboard applications, and troubleshoot deployment failures during migration.

### Action

I started with requirement gathering: region, availability zones, VPC/subnet design, DNS, IAM permissions, node sizing, storage class, ingress, certificates, identity provider, backup, and monitoring.

After preparing the prerequisites, I used the OpenShift installer to deploy the cluster. Once installation completed, I validated cluster operators, nodes, routes, monitoring, image registry, and storage.

During application onboarding, a few deployments failed. The most common issue was that the application containers were built assuming root access. They worked in vanilla Kubernetes but failed in OpenShift because OpenShift assigns a random non-root UID by default.

I investigated using:

```bash
oc describe pod
oc logs
oc get events
oc get scc
oc adm policy who-can use scc/anyuid
```

The error showed permission denied while writing to the application directory. Instead of immediately assigning privileged SCC, I worked with the application team to update the Dockerfile, fix file permissions, use a writable directory, and run the app as non-root.

Example fix:

```dockerfile
RUN chmod -R g=u /app
USER 1001
```

For a few vendor images that required root, we created a controlled service account and assigned a limited SCC only after security approval.

### Result

The applications were successfully onboarded without weakening the cluster-wide security posture. We also created a container image checklist for teams migrating to OpenShift.

### Good Interview Line

> The biggest lesson was that migration to OpenShift is not just deployment YAML migration. Container images must be OpenShift-ready, especially around non-root execution, file permissions, ports, and SCC compliance.

---

## 10.2 Explain how you installed an OCP cluster step by step, what difficulties you faced, and how you fixed them.

### Interview Answer

I installed OpenShift using IPI on AWS. The steps were:

```text
1. Requirement gathering
2. AWS prerequisite validation
3. DNS and base domain setup
4. Pull secret and SSH key preparation
5. OpenShift installer download
6. install-config.yaml generation
7. Cluster installation
8. Bootstrap monitoring
9. Operator validation
10. Post-install configuration
11. Application onboarding
```

### Commands

```bash
openshift-install create install-config --dir=ocp-install
openshift-install create cluster --dir=ocp-install --log-level=info
export KUBECONFIG=ocp-install/auth/kubeconfig
oc get nodes
oc get co
oc get clusterversion
```

### Difficulties and Fixes

| Difficulty | Root Cause | Fix |
|---|---|---|
| Bootstrap failed | DNS issue | Corrected Route53 entries |
| Nodes not joining | Security group restrictions | Opened required ports |
| Cluster operators degraded | AWS quota issue | Increased service quota |
| Image pull error | Pull secret issue | Updated pull secret |
| Ingress unavailable | Subnet/LB tag issue | Fixed AWS subnet tags |
| App deployment failed | SCC/non-root issue | Fixed image permissions |
| PVC pending | Storage class/CSI issue | Validated storage operator |

### Good Interview Line

> I approach installation failures by validating prerequisites first: DNS, IAM, networking, quota, pull secret, bootstrap logs, cluster operators, and Machine API objects.

---

# 11. Quick Answers for Rapid Interview Round

## 11.1 How does MachineConfig Operator work?

MCO manages OpenShift node OS configuration through MachineConfig and MachineConfigPool. The Machine Config Daemon applies rendered configs on nodes, drains/reboots nodes when required, and reports MCP status.

---

## 11.2 How do you recover a failed control plane node?

First check etcd quorum. If quorum exists, replace the failed master node. If quorum is lost, restore from a valid etcd backup. Validate nodes, etcd pods, and cluster operators.

---

## 11.3 How do you take etcd backup?

SSH to one control plane node and run:

```bash
sudo -i
mkdir -p /home/core/backup
/usr/local/bin/cluster-backup.sh /home/core/backup
```

Copy `snapshot_*.db` and `static_kuberesources_*.tar.gz` outside the cluster.

---

## 11.4 How do you restore etcd?

Use the OpenShift-supported restore procedure with a backup from the same z-stream version. Restore is used for quorum loss or disaster recovery, not as a normal rollback.

---

## 11.5 How do you perform zero-downtime OpenShift upgrades?

Check cluster health, take etcd backup, validate operators, ensure workloads have multiple replicas, readiness probes, PDBs, and spare capacity. Upgrade using Cluster Version Operator and monitor MCPs/operators.

---

## 11.6 API is down. What do you check?

Check DNS, load balancer, API health, kube-apiserver static pods, etcd health, master node resources, certificates, kubelet, disk, and network connectivity.

---

## 11.7 etcd is consuming 95% disk. What do you do?

Treat as critical. Do not delete etcd files manually. Take backup if possible, check etcd health, identify growth, follow supported defrag/cleanup process, and expand disk if needed.

---

## 11.8 How do you design 500+ microservices?

Use namespaces/projects per team/app, RBAC, NetworkPolicies, GitOps, quotas, standard deployment templates, service mesh where needed, central observability, image governance, and multi-cluster strategy.

---

## 11.9 How do you handle drift with Jenkins?

Use Git as source of truth. Jenkins runs `kubectl diff`, `helm diff`, or Kustomize diff. Alert or apply changes after approval. For continuous reconciliation, prefer Argo CD or Flux.

---

## 11.10 Kubernetes vs OpenShift?

Kubernetes is the open-source orchestration engine. OpenShift is enterprise Kubernetes with additional security, operators, routes, registry, console, OAuth, SCC, monitoring, and support.

---

# 12. Category-Wise Question Index

## Foundations

1. Difference between Kubernetes and OpenShift  
2. Kubernetes control plane and data plane components  
3. OpenShift main components  
4. Project vs Namespace  
5. SCC in OpenShift  
6. VM support in OpenShift  

## Cluster Build and Architecture

1. Requirement gathering for Kubernetes cluster in AWS  
2. OpenShift installation steps  
3. Multi-region OpenShift design  
4. 500+ microservices design  

## Deployment

1. What happens during `kubectl apply`  
2. Staging succeeds but production fails  
3. Health checks pass but users get 500 errors  
4. Container crashes in production but works locally  
5. Dockerfile with `FROM scratch`  
6. Zero-downtime OpenShift upgrades  

## Troubleshooting

1. API down in production  
2. etcd consuming 95% disk  
3. OOMKilled despite low process memory  
4. Internal DNS resolution failure  
5. Kubernetes to OpenShift migration failure  
6. Latency spike RCA using logs, metrics, traces  

## Security

1. Secret management at scale  
2. Kubernetes cluster security approach  
3. Stolen service account token attack  
4. SCC troubleshooting  
5. RBAC and least privilege  

## Observability and Service Mesh

1. Experience with service mesh  
2. Service mesh vs load balancer  
3. Prometheus scaling for multi-cluster  
4. Logs, metrics, traces correlation  

## Backup and DR

1. etcd backup  
2. etcd restore  
3. Application data backup  
4. VM backup in OpenShift  
5. Control plane node recovery  

---

# 13. Final Interview Closing Statement

In OpenShift and Kubernetes operations, I focus on declarative infrastructure, reconciliation, security-by-default, least privilege, GitOps, observability, disaster recovery, automation, and production readiness. I troubleshoot systematically by checking desired state, actual state, events, logs, metrics, traces, policies, and recent changes. For OpenShift specifically, I pay close attention to SCC, operators, MachineConfigPools, cluster operators, etcd health, and upgrade readiness.

---

# 14. References

These official references are useful for deeper preparation:

- Kubernetes Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- Kubernetes DNS for Services and Pods: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
- Kubernetes Service Accounts: https://kubernetes.io/docs/concepts/security/service-accounts/
- Kubernetes RBAC Good Practices: https://kubernetes.io/docs/concepts/security/rbac-good-practices/
- Dockerfile Reference: https://docs.docker.com/reference/dockerfile/
- OpenShift Machine Config Operator: https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/machine_configuration/machine-config-index
- OpenShift MachineConfig objects: https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/machine_configuration/machine-configs-configure
- OpenShift etcd backup and restore: https://docs.redhat.com/en/documentation/openshift_container_platform/4.12/html/backup_and_restore/control-plane-backup-and-restore
- OpenShift Backup and Restore Overview: https://docs.redhat.com/en/documentation/openshift_container_platform/4.17/html/backup_and_restore/backup-restore-overview
- OpenShift Security Context Constraints: https://docs.redhat.com/en/documentation/openshift_container_platform/4.14/html/authentication_and_authorization/managing-pod-security-policies
- OpenShift Application Backup with OADP: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/backup_and_restore/oadp-application-backup-and-restore
- OpenShift Virtualization Backup and Restore: https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/virtualization/backup-and-restore
- OpenShift Multi-site / etcd guidance: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/etcd/guidance-for-clusters-that-span-data-centers
- OpenShift Data Foundation Regional DR: https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.18/html/configuring_openshift_data_foundation_disaster_recovery_for_openshift_workloads/rdr-solution
- Istio Traffic Management: https://istio.io/latest/docs/concepts/traffic-management/
- Istio Observability: https://istio.io/latest/docs/concepts/observability/
- Prometheus Federation: https://prometheus.io/docs/prometheus/latest/federation/
- Prometheus Remote Write: https://prometheus.io/docs/specs/prw/remote_write_spec/
- Prometheus Operator High Availability: https://prometheus-operator.dev/docs/platform/high-availability/
- Thanos Design: https://thanos.io/tip/thanos/design.md/
