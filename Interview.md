# OpenShift / Kubernetes Interview Questions and Answers

## 1. What happens inside the cluster when you run `kubectl apply -f deployment.yaml`?

### Interview Answer

When I run:

```bash
kubectl apply -f deployment.yaml
```

`kubectl` sends the desired state to the Kubernetes API server. The API server authenticates the request, checks RBAC authorization, runs admission controllers, validates the object, and stores the final accepted object in `etcd`.

Admission controllers run after authentication and authorization but before the object is persisted.

After that, Kubernetes controllers start reconciling the desired state. The Deployment controller sees the new or updated Deployment and creates or updates a ReplicaSet. The ReplicaSet controller then ensures the required number of Pods are running.

The scheduler assigns pending Pods to suitable worker nodes. On each selected node, the kubelet pulls the container image, mounts ConfigMaps and Secrets, asks the container runtime to start the containers, and continuously reports Pod status back to the API server.

If the Deployment has a Service, EndpointSlices are updated so traffic can be routed to the new Pods. In OpenShift, additional platform controls such as Security Context Constraints, image policies, routes, and OpenShift admission policies may also be involved.

### Key Flow

| Step | Component | What Happens |
|---|---|---|
| 1 | `kubectl` | Sends YAML manifest to API server |
| 2 | API Server | Authenticates and authorizes request |
| 3 | Admission Controllers | Validate/mutate object before storage |
| 4 | etcd | Stores desired state |
| 5 | Deployment Controller | Creates/updates ReplicaSet |
| 6 | ReplicaSet Controller | Creates required Pods |
| 7 | Scheduler | Assigns Pods to nodes |
| 8 | Kubelet | Starts containers through container runtime |
| 9 | Service / EndpointSlice Controller | Updates service backends |

### Good Interview Line

> `kubectl apply` does not directly create containers. It updates the desired state in the API server, and Kubernetes controllers continuously reconcile the actual state to match that desired state.

---

## 2. What is your experience with service meshes?

### Interview Answer

I have worked with service mesh concepts such as Istio and OpenShift Service Mesh for managing microservice-to-microservice traffic. I use service mesh mainly for traffic management, mTLS, service-to-service authorization, observability, retries, timeouts, circuit breakers, and canary releases.

In a microservices environment, I do not want every application team to implement retries, TLS, tracing, and traffic splitting separately inside their application code. A service mesh provides these capabilities consistently at the platform layer.

In practice, I would start with critical namespaces or high-value services instead of enabling mesh for the entire cluster at once. I would measure sidecar overhead, define mTLS policy, standardize timeouts and retries, and train application teams on how to troubleshoot Envoy sidecars.

### Service Mesh Use Cases

| Use Case | Example |
|---|---|
| mTLS | Encrypt service-to-service traffic |
| Traffic splitting | Send 90% traffic to v1 and 10% to v2 |
| Canary releases | Gradually expose new versions |
| Retries and timeouts | Improve resilience |
| Circuit breaking | Avoid cascading failures |
| Observability | Metrics, traces, service graph |
| Authorization | Allow only selected services to call another service |
| Egress control | Control outbound access from services |

### Good Interview Line

> A service mesh is useful when the organization needs consistent traffic control, security, and observability for service-to-service communication without requiring every application to implement those features itself.

---

## 3. How do you handle secret management in Kubernetes at scale?

### Interview Answer

At scale, I avoid storing plain Kubernetes Secrets directly in Git or manually creating secrets with `kubectl create secret`. Instead, I use an external secret manager such as HashiCorp Vault, AWS Secrets Manager, Azure Key Vault, GCP Secret Manager, or another enterprise secret backend.

Inside Kubernetes or OpenShift, I use tools such as External Secrets Operator, Secrets Store CSI Driver, Sealed Secrets, or SOPS depending on the organization’s GitOps model.

Kubernetes Secrets are useful for injecting sensitive values into Pods, but they should not be treated as a full enterprise secret-management solution by themselves. At scale, I want centralized rotation, auditing, access control, encryption, and lifecycle management.

### Secret Management Strategy

| Area | Practice |
|---|---|
| Source of truth | External secret manager |
| GitOps | Store only encrypted secrets or ExternalSecret manifests |
| Access control | Namespace-scoped RBAC and least privilege |
| Rotation | Automated rotation and refresh |
| Encryption | Enable encryption at rest for etcd |
| Audit | Track who reads, lists, or modifies secrets |
| Workload identity | Prefer short-lived identity-based access |
| OpenShift | Use External Secrets Operator, RBAC, SCCs, and namespace isolation |

### Common Tools

| Tool | Purpose |
|---|---|
| HashiCorp Vault | Enterprise secret backend |
| AWS Secrets Manager | AWS-native secret storage |
| Azure Key Vault | Azure-native secret storage |
| GCP Secret Manager | GCP-native secret storage |
| External Secrets Operator | Sync external secrets into Kubernetes |
| Secrets Store CSI Driver | Mount secrets directly from external stores |
| Sealed Secrets | Store encrypted secrets safely in Git |
| SOPS | Encrypt YAML/JSON files for GitOps |

### Good Interview Line

> Kubernetes Secrets are not a complete enterprise secret-management system. At scale, Kubernetes should consume secrets from a controlled external secret backend with rotation, auditing, encryption, and least-privilege access.

---

## 4. What is your approach to securing a Kubernetes/OpenShift cluster?

### Interview Answer

I secure a Kubernetes or OpenShift cluster in layers. I start with identity and access control, then workload security, network security, image security, secrets, runtime monitoring, audit logging, and backup.

In OpenShift, Security Context Constraints are very important because they control what Pods are allowed to do, such as whether they can run privileged, use host networking, mount host paths, or run as root.

My security model is based on default-deny, least privilege, strong identity, non-root workloads, network segmentation, secure image supply chain, and continuous monitoring.

### Security Layers

| Layer | Controls |
|---|---|
| Authentication | SSO, OAuth, MFA, short-lived credentials |
| Authorization | RBAC least privilege; avoid wildcard permissions |
| Pod security | OpenShift SCCs, Pod Security Standards, non-root containers |
| Network | Default-deny NetworkPolicies, controlled ingress and egress |
| Secrets | External secret manager, encryption, rotation |
| Images | Trusted registries, image scanning, image signing |
| Nodes | OS hardening, patching, restricted SSH, kubelet protection |
| API server | Audit logs, admission control, rate limits |
| Runtime | Monitor exec, privilege escalation, crypto mining, unknown processes |
| Backup/DR | etcd backups, Velero/OADP, tested restore process |

### Practical Controls

```bash
# Check who can access secrets
oc adm policy who-can get secrets -n my-namespace

# Check who can create privileged workloads
oc adm policy who-can use scc/privileged

# List network policies
oc get networkpolicy -A

# Check service accounts in a namespace
oc get sa -n my-namespace

# Check role bindings
oc get rolebinding,clusterrolebinding -A
```

### Good Interview Line

> My security model is default-deny, least privilege, non-root workloads, restricted SCC or Pod Security, network segmentation, externalized secrets, image governance, and continuous audit.

---

## 5. How do you design a multi-region OpenShift cluster?

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

## 6. What is a service mesh and what problems does it solve that a traditional load balancer does not?

### Interview Answer

A traditional load balancer mainly distributes traffic, usually for north-south traffic entering the cluster or application. A service mesh focuses on east-west traffic between microservices inside the cluster.

A service mesh solves problems that a basic load balancer does not solve well, such as service-to-service mTLS, workload identity, fine-grained authorization, canary traffic splitting, retries, timeouts, circuit breaking, distributed tracing, and service-level observability.

### Load Balancer vs Service Mesh

| Capability | Traditional Load Balancer | Service Mesh |
|---|---|---|
| North-south traffic | Yes | Yes, with ingress gateway |
| East-west traffic | Limited | Strong |
| mTLS between services | Usually no | Yes |
| Service identity | Limited | Yes |
| Canary traffic splitting | Limited | Yes |
| Retries/timeouts | Basic or limited | Advanced |
| Circuit breaking | Usually limited | Yes |
| Distributed tracing | No | Yes |
| Service graph | No | Yes |
| Fine-grained authorization | Limited | Yes |

### Problems Solved by Service Mesh

| Problem | Service Mesh Capability |
|---|---|
| Unencrypted internal traffic | mTLS |
| No service identity | Workload identity |
| Manual canary releases | Percentage-based traffic routing |
| Cascading failures | Timeouts, retries, circuit breakers |
| Poor visibility | Metrics, logs, traces |
| Weak internal authorization | Service-to-service authorization policies |
| Uncontrolled egress | Egress policy and gateway |

### Good Interview Line

> A load balancer distributes traffic. A service mesh controls, secures, observes, and governs service-to-service communication.

---

## 7. A microservice in Kubernetes can reach the internet but cannot resolve internal DNS for other services. What do you check?

### Interview Answer

If a microservice can reach the internet but cannot resolve internal Kubernetes service names, I would troubleshoot DNS from the Pod outward.

First, I check whether the application is using the correct service name. A short service name works inside the same namespace, but for another namespace the application should use the fully qualified service name:

```text
service-name.namespace.svc.cluster.local
```

Then I check the Pod’s DNS configuration, CoreDNS or OpenShift DNS health, NetworkPolicies, and whether the target Service and endpoints exist.

### Troubleshooting Steps

#### 1. Test DNS from inside the Pod

```bash
oc exec -n app-ns pod-name -- nslookup service-name
oc exec -n app-ns pod-name -- nslookup service-name.target-ns.svc.cluster.local
oc exec -n app-ns pod-name -- cat /etc/resolv.conf
```

#### 2. Check Pod DNS policy

```bash
oc get pod pod-name -n app-ns -o yaml | grep dnsPolicy -A5
```

Expected value is usually:

```yaml
dnsPolicy: ClusterFirst
```

If the Pod uses `hostNetwork: true`, it may need:

```yaml
dnsPolicy: ClusterFirstWithHostNet
```

#### 3. Check OpenShift DNS / CoreDNS

```bash
oc get pods -n openshift-dns
oc get svc -n openshift-dns
oc logs -n openshift-dns -l dns.operator.openshift.io/daemonset-dns=default
```

#### 4. Check Service and endpoints

```bash
oc get svc -n target-ns
oc get endpoints -n target-ns
oc get endpointslice -n target-ns
oc describe svc service-name -n target-ns
```

If DNS resolves but traffic fails, the Service may have no endpoints or NetworkPolicy may block traffic.

#### 5. Check NetworkPolicy

```bash
oc get networkpolicy -A
oc describe networkpolicy -n app-ns
```

A common issue is that egress to the internet is allowed but DNS traffic to cluster DNS is blocked on UDP/TCP port 53.

#### 6. Check node or DNS operator issues

```bash
oc get co dns
oc describe co dns
oc get events -n openshift-dns --sort-by=.lastTimestamp
```

### Possible Root Causes

| Symptom | Possible Cause |
|---|---|
| Short name fails | Service is in another namespace |
| FQDN fails | DNS/CoreDNS issue |
| `/etc/resolv.conf` wrong | Incorrect Pod DNS policy |
| DNS times out | NetworkPolicy blocking port 53 |
| DNS resolves but connection fails | Service has no endpoints |
| Only one node affected | Node-level DNS or CNI issue |
| Host-network Pod affected | Wrong DNS policy |

### Good Interview Line

> Since internet connectivity works but internal DNS fails, I focus on service FQDN, Pod `dnsPolicy`, CoreDNS/OpenShift DNS health, NetworkPolicy blocking DNS, and whether the target Service actually has endpoints.

---

## 8. How would you scale Prometheus for a multi-cluster Kubernetes environment?

### Interview Answer

For a multi-cluster Kubernetes or OpenShift environment, I would not use one central Prometheus server to scrape every target in every cluster. That design does not scale well and creates dependency on network connectivity between clusters.

I would run Prometheus locally in each cluster and aggregate metrics centrally using Thanos, Cortex, Mimir, Prometheus remote write, federation, or Red Hat Advanced Cluster Management Observability.

Each cluster should scrape local workloads. Then metrics are labeled with cluster, region, environment, and tenant labels before being sent to a central query or storage layer.

### Scalable Design

| Layer | Design |
|---|---|
| Per cluster | Local Prometheus scrapes local workloads |
| High availability | Prometheus HA pairs |
| Large target volume | Prometheus sharding |
| Labeling | Add cluster, region, environment, tenant labels |
| Central query | Thanos Query, Cortex, Mimir, or ACM Observability |
| Long-term storage | Object storage such as S3, GCS, Azure Blob, or compatible storage |
| Federation | Use for selected aggregate metrics |
| Remote write | Send metrics to central backend |
| Alerting | Local critical alerts plus global SLO alerts |
| Cardinality | Strict control of labels, retention, and scrape intervals |

### Architecture

```text
Cluster A Prometheus ----\
Cluster B Prometheus -----\ 
Cluster C Prometheus ------> Central Metrics Layer
Cluster D Prometheus -----/       |
Cluster E Prometheus ----/        |
                              Dashboards
                              Alerts
                              Long-term Storage
```

### Prometheus Scaling Techniques

| Technique | Purpose |
|---|---|
| HA pairs | Avoid single point of failure |
| Sharding | Split scrape targets across Prometheus instances |
| Remote write | Push samples to central backend |
| Federation | Pull selected metrics from lower-level Prometheus |
| Thanos sidecar | Store blocks in object storage |
| Retention tuning | Avoid local disk overload |
| Label control | Prevent high cardinality |
| Recording rules | Precompute expensive queries |

### Common Problems

| Problem | Solution |
|---|---|
| Too many metrics | Drop unnecessary metrics |
| High cardinality | Remove dynamic labels such as request ID or user ID |
| Slow dashboards | Use recording rules |
| Local disk pressure | Reduce retention or use object storage |
| Central bottleneck | Use Thanos/Cortex/Mimir |
| Alert noise | Use SLO-based alerting |

### Good Interview Line

> Keep scraping local and aggregate globally. Use per-cluster Prometheus, HA pairs, sharding, remote write or Thanos, strict cardinality control, and global dashboards with cluster and region labels.

---

## 9. You are seeing a latency spike in production. Walk me through how you would use logs, metrics, and traces together to find the root cause in under 15 minutes.

### Interview Answer

I use a fast correlation approach: metrics tell me where the issue is, traces tell me why it is slow, and logs confirm the exact error.

I do not start by randomly searching logs. I first check dashboards to identify the affected service, route, namespace, cluster, or region. Then I use traces to find the slow span or dependency. Finally, I use logs filtered by trace ID, request ID, Pod, and time window to confirm the root cause.

### 0–2 Minutes: Confirm Blast Radius

I check:

```text
p95 and p99 latency
error rate
request rate
affected service
affected namespace
affected region or cluster
recent deployment
node health
```

I want to know whether the spike affects:

| Scope | Meaning |
|---|---|
| One Pod | Pod-level issue |
| One node | Node or CNI issue |
| One service | Application or dependency issue |
| One namespace | Policy/resource issue |
| One region | Regional dependency or infrastructure issue |
| All services | Platform, ingress, DNS, or shared dependency issue |

### 2–5 Minutes: Metrics

I check RED metrics:

| Metric | Question |
|---|---|
| Rate | Did traffic suddenly increase? |
| Errors | Are 5xx or 4xx errors increasing? |
| Duration | Which service has high p95/p99 latency? |

Then I check resource and platform metrics:

```text
CPU throttling
memory pressure
Pod restarts
OOMKilled events
HPA scaling events
node pressure
ingress/router latency
database connection pool
queue lag
service mesh sidecar metrics
DNS latency
```

Useful commands:

```bash
oc get pods -n app-ns
oc top pods -n app-ns
oc top nodes
oc get events -n app-ns --sort-by=.lastTimestamp
oc rollout history deployment/service-name -n app-ns
```

### 5–10 Minutes: Traces

I open slow traces for the affected service and look for the longest span.

I check whether the delay is in:

```text
API service
database
external dependency
authentication service
DNS lookup
queue processing
downstream microservice
service mesh sidecar
ingress gateway
```

If a trace shows that 90% of time is spent in a database call, then I focus on DB metrics and logs. If it shows delay in another microservice, I move to that service’s metrics and logs.

### 10–15 Minutes: Logs

I filter logs by:

```text
trace ID
request ID
correlation ID
affected Pod
affected namespace
last 15 minutes
```

Example commands:

```bash
oc logs -n app-ns deploy/service-name --since=15m
oc logs -n app-ns pod-name --since=15m
oc describe pod pod-name -n app-ns
```

I look for:

```text
timeouts
connection refused
database slow queries
TLS errors
DNS failures
OOMKilled
rate limiting
retry storms
thread pool exhaustion
connection pool exhaustion
new deployment errors
```

### Decision and Action

| Root Cause | Action |
|---|---|
| Bad deployment | Roll back deployment |
| CPU/memory saturation | Scale Pods or tune requests/limits |
| HPA not scaling | Fix HPA metrics or thresholds |
| DB slowness | Check locks, slow queries, connection pool |
| External dependency slow | Apply timeout, circuit breaker, fallback |
| One bad node | Cordon/drain node |
| DNS problem | Check CoreDNS/OpenShift DNS and NetworkPolicy |
| Retry storm | Reduce retries and add circuit breaker |
| Ingress issue | Check router/ingress metrics and logs |

### Example Response in an Interview

> I would first check the latency dashboard to confirm whether the issue is global or limited to one service. Then I would use RED metrics to identify the service with high p95 or p99 latency. After that, I would open distributed traces and find the slowest span. Once I know the slow dependency, I would search logs using the trace ID and the last 15-minute time window. This avoids random log searching and gives me a metrics-to-traces-to-logs path to root cause.

### Good Interview Line

> I do not look at logs blindly. I start with metrics to identify the failing service, use traces to identify the slow dependency, then use logs with the trace ID to prove the exact failure.

---

## 10. An attacker gains access to a Kubernetes cluster using a stolen service account token. What can they do, and how do you limit the blast radius?

### Interview Answer

A stolen service account token gives the attacker the permissions of that ServiceAccount. What they can do depends on RBAC, Security Context Constraints, NetworkPolicies, and admission controls.

If the ServiceAccount has low privileges, the attacker may only read limited resources in one namespace. But if it has broad permissions, the attacker may read secrets, create Pods, exec into containers, patch deployments, create RoleBindings, or try to escalate privileges.

### What the Attacker Can Do

| If RBAC Allows | Attacker Can |
|---|---|
| `get/list secrets` | Steal secrets |
| `create pods` | Run malicious containers |
| `exec pods` | Access running workloads |
| `create rolebindings` | Escalate privileges |
| `patch deployments` | Inject malicious image |
| `get configmaps` | Read application configuration |
| `list services/endpoints` | Map internal network |
| `create jobs/cronjobs` | Establish persistence |
| `use privileged SCC` | Attempt node compromise |
| `hostPath` access | Read host files |
| `hostNetwork` access | Bypass some network controls |

### How to Limit Blast Radius

| Control | Action |
|---|---|
| RBAC | Least privilege; avoid wildcard `*` permissions |
| Namespace scope | Use Roles instead of ClusterRoles where possible |
| Tokens | Use short-lived projected tokens |
| Automount | Disable service account token automount where not needed |
| SCC/PSS | Prevent privileged Pods, hostPath, hostNetwork, hostPID |
| NetworkPolicy | Restrict egress and namespace-to-namespace movement |
| Secrets | Do not allow workloads to list all secrets |
| Admission control | Block unsafe Pod specs |
| Audit | Alert on suspicious API calls from service accounts |
| Rotation | Rotate affected credentials and redeploy Pods |
| Isolation | Separate namespaces, service accounts, and roles per app |

### Important Hardening Examples

#### Disable automatic token mount where not needed

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
automountServiceAccountToken: false
```

#### Use least-privilege RBAC

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: app-ns
  name: app-reader
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get"]
```

#### Avoid dangerous permissions

Avoid giving service accounts permissions like:

```text
* on *
create pods
create rolebindings
get/list secrets
use privileged SCC
patch deployments
impersonate users/groups
```

### Incident Response Commands

```bash
# Check what the service account can do
oc auth can-i --as=system:serviceaccount:app-ns:app-sa --list -n app-ns

# Check who can read secrets
oc adm policy who-can get secrets -n app-ns

# Check who can create pods
oc adm policy who-can create pods -n app-ns

# Check who can use privileged SCC
oc adm policy who-can use scc/privileged

# Find Pods using a service account
oc get pods -A --field-selector spec.serviceAccountName=app-sa

# Check role bindings
oc get rolebinding,clusterrolebinding -A | grep app-sa

# Review recent events
oc get events -A --sort-by=.lastTimestamp
```

### Response Steps

| Step | Action |
|---|---|
| 1 | Identify compromised service account |
| 2 | Check RBAC permissions |
| 3 | Check Pods using that service account |
| 4 | Remove excessive RoleBindings or ClusterRoleBindings |
| 5 | Rotate tokens and restart affected Pods |
| 6 | Check audit logs for malicious API calls |
| 7 | Check for malicious Pods, Jobs, CronJobs, or modified Deployments |
| 8 | Review secrets accessed by that identity |
| 9 | Add NetworkPolicy and admission guardrails |
| 10 | Strengthen least privilege and monitoring |

### Good Interview Line

> A stolen service account token is only as dangerous as the RBAC, SCC, network access, and secret access attached to it. My goal is to make every service account low-privilege, namespace-scoped, short-lived, and heavily audited.

---

# Quick Revision Sheet

## Core Concepts to Remember

| Topic | Key Point |
|---|---|
| `kubectl apply` | Updates desired state; controllers reconcile actual state |
| Service mesh | Secures, observes, and controls service-to-service traffic |
| Secrets | Use external secret manager at scale |
| Cluster security | Identity, RBAC, SCC/PSS, NetworkPolicy, image security, audit |
| Multi-region OCP | Prefer one cluster per region, managed by ACM/GitOps |
| DNS issue | Check FQDN, DNS policy, CoreDNS/OpenShift DNS, NetworkPolicy |
| Prometheus scaling | Local scrape, global aggregate |
| Latency RCA | Metrics → traces → logs |
| Stolen SA token | Damage depends on RBAC and runtime permissions |

---

# Strong Interview Closing Statement

For OpenShift and Kubernetes operations, I focus on declarative desired state, controller reconciliation, least-privilege security, GitOps, observability, automation, and production resilience. My approach is to design clusters and platforms that are secure by default, observable by design, scalable across teams, and recoverable during failures.

---

# References

- Kubernetes Admission Controllers: https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/
- Kubernetes Deployments: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- Kubernetes Components: https://kubernetes.io/docs/concepts/overview/components/
- Kubernetes DNS for Services and Pods: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
- Kubernetes Service Accounts: https://kubernetes.io/docs/concepts/security/service-accounts/
- Kubernetes RBAC Good Practices: https://kubernetes.io/docs/concepts/security/rbac-good-practices/
- Istio Traffic Management: https://istio.io/latest/docs/concepts/traffic-management/
- Istio Observability: https://istio.io/latest/docs/concepts/observability/
- Prometheus Federation: https://prometheus.io/docs/prometheus/latest/federation/
- Prometheus Remote Write Specification: https://prometheus.io/docs/specs/prw/remote_write_spec/
- Prometheus Operator High Availability: https://prometheus-operator.dev/docs/platform/high-availability/
- Thanos Design: https://thanos.io/tip/thanos/design.md/
- Red Hat OpenShift External Secrets Operator: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/security_and_compliance/external-secrets-operator-for-red-hat-openshift
- Red Hat OpenShift SCC Documentation: https://docs.redhat.com/en/documentation/openshift_container_platform/4.14/html/authentication_and_authorization/managing-pod-security-policies
- Red Hat OpenShift Guidance for Clusters Spanning Data Centers: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/etcd/guidance-for-clusters-that-span-data-centers
- Red Hat OpenShift Data Foundation Regional DR: https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.18/html/configuring_openshift_data_foundation_disaster_recovery_for_openshift_workloads/rdr-solution
- Red Hat Advanced Cluster Management Observability: https://docs.redhat.com/en/documentation/red_hat_advanced_cluster_management_for_kubernetes/2.9/html/observability/enabling-observability-service
