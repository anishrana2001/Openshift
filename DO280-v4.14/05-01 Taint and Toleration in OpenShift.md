# 05. Taint and Toleration in OpenShift

## What is Taint and Toleration?

### Taint
A **taint** is applied on a **node**.

It tells the scheduler:

> Do not schedule normal pods on this node unless the pod has a matching toleration.

### Toleration
A **toleration** is applied on a **pod**.

It tells the scheduler:

> This pod can tolerate the taint and can be scheduled on that tainted node.

---

## Important Taint Effects

| Effect | Meaning |
|---|---|
| `NoSchedule` | New pods will not be scheduled unless they have matching toleration |
| `PreferNoSchedule` | Scheduler will try to avoid scheduling pod on this node |
| `NoExecute` | Existing pods without matching toleration can be evicted |

---

## Basic Syntax

### Apply taint on node

```bash
oc adm taint node node_name key=value:effect
```

### Example

```bash
oc adm taint node master01 datacenter=delhi:NoSchedule
```

### Remove taint from node

```bash
oc adm taint node master01 datacenter-
```

---

# Lab: Taint and Toleration in OpenShift

## Prepare the lab for this question

```bash
oc new-project chapter1

oc new-app --name webserver-app1 \
  --image registry.ocp4.example.com:8443/redhattraining/hello-world-nginx:v1.0
```

### Get the node name

```bash
oc get nodes
```

### Apply taint on node

> Replace `master01` with your node name.

```bash
oc adm taint node master01 datacenter=delhi:NoSchedule
```

---

# Question 1. An application is running in the `chapter1` project. There is one pod created, but it is not running. Your task is to troubleshoot and make the application generate the output.

## Solution

### Go to the project

```bash
oc project chapter1
```

### Pre-check resources

```bash
oc get all
```

### Check pod status

```bash
oc get pods
```

You may observe that the pod is in `Pending` state.

Example:

```bash
NAME                              READY   STATUS    RESTARTS   AGE
webserver-app1-65cc9f8b7d-k9x9p   0/1     Pending   0          2m
```

---

## Identify the issue

### Check pod with node details

```bash
oc get pods -o wide
```

### Check events

```bash
oc events
```

or

```bash
oc describe pod pod_name
```

### You may observe the below error

```bash
Warning  FailedScheduling  default-scheduler  0/1 nodes are available:
1 node(s) had untolerated taint {datacenter: delhi}.
preemption: 0/1 nodes are available: 1 Preemption is not helpful for scheduling.
```

---

## Meaning of the error

If you observe the `untolerated taint` error, it means:

- Taint is applied on the node.
- Pod does not have matching toleration.
- Scheduler cannot place the pod on that node.
- Pod will remain in `Pending` state.

---

## Check taint on node

```bash
oc describe node master01 | grep -i taint
```

Expected output:

```bash
Taints:             datacenter=delhi:NoSchedule
```

---

# Method 1: Fix by removing taint from node

> Use this method only if you want normal pods to run on this node.

```bash
oc adm taint node master01 datacenter-
```

### Verify taint removed

```bash
oc describe node master01 | grep -i taint
```

Expected output:

```bash
Taints:             <none>
```

### Post-check pod

```bash
oc get pods
```

Expected output:

```bash
NAME                              READY   STATUS    RESTARTS   AGE
webserver-app1-65cc9f8b7d-k9x9p   1/1     Running   0          4m
```

---

# Method 2: Fix by adding toleration to deployment

> This is the recommended method when the node must remain tainted and only selected pods should run on it.

## Apply taint again if you removed it

```bash
oc adm taint node master01 datacenter=delhi:NoSchedule
```

## Add toleration using patch command

```bash
oc patch deployment webserver-app1 \
  --type='merge' \
  -p '{"spec":{"template":{"spec":{"tolerations":[{"key":"datacenter","operator":"Equal","value":"delhi","effect":"NoSchedule"}]}}}}'
```

### Check rollout

```bash
oc rollout status deployment/webserver-app1
```

### Check pod status

```bash
oc get pods -o wide
```

Expected output:

```bash
NAME                              READY   STATUS    RESTARTS   AGE   IP            NODE
webserver-app1-76f8d9c58d-qw2pl   1/1     Running   0          1m    10.128.2.15   master01
```

---

## Verify toleration in deployment YAML

```bash
oc get deployment webserver-app1 -o yaml | grep -iA 8 tolerations
```

Expected output:

```yaml
tolerations:
- effect: NoSchedule
  key: datacenter
  operator: Equal
  value: delhi
```

---

# YAML Example: Deployment with Toleration

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webserver-app1
  namespace: chapter1
spec:
  replicas: 1
  selector:
    matchLabels:
      deployment: webserver-app1
  template:
    metadata:
      labels:
        deployment: webserver-app1
    spec:
      tolerations:
      - key: "datacenter"
        operator: "Equal"
        value: "delhi"
        effect: "NoSchedule"
      containers:
      - name: webserver-app1
        image: registry.ocp4.example.com:8443/redhattraining/hello-world-nginx:v1.0
        ports:
        - containerPort: 8080
```

---

# Expose the application

### Check service

```bash
oc get svc
```

### If route is not created, create route

```bash
oc expose svc webserver-app1
```

### Check route

```bash
oc get route
```

### Open the website

```bash
curl http://webserver-app1-chapter1.apps.ocp4.example.com | head
```

> Replace the route URL as per your lab output.

---

# Question 2. Create a dedicated node using taint and run only selected application pods on it.

## Requirement

- Apply taint on node: `environment=production:NoSchedule`
- Create project: `chapter2`
- Deploy application: `webserver-app2`
- Add matching toleration to the deployment
- Pod must run successfully

---

## Prepare the lab

```bash
oc new-project chapter2

oc new-app --name webserver-app2 \
  --image registry.ocp4.example.com:8443/redhattraining/hello-world-nginx:v1.0
```

### Apply taint on node

```bash
oc adm taint node master01 environment=production:NoSchedule
```

---

## Solution

### Check pod status

```bash
oc get pods
```

You may observe:

```bash
NAME                              READY   STATUS    RESTARTS   AGE
webserver-app2-7459cf5d97-p9sx8   0/1     Pending   0          1m
```

### Check events

```bash
oc events
```

Expected error:

```bash
0/1 nodes are available: 1 node(s) had untolerated taint {environment: production}.
```

---

## Add toleration

```bash
oc patch deployment webserver-app2 \
  --type='merge' \
  -p '{"spec":{"template":{"spec":{"tolerations":[{"key":"environment","operator":"Equal","value":"production","effect":"NoSchedule"}]}}}}'
```

### Check deployment rollout

```bash
oc rollout status deployment/webserver-app2
```

### Post-check

```bash
oc get pods -o wide
```

Expected output:

```bash
NAME                              READY   STATUS    RESTARTS   AGE   NODE
webserver-app2-6bd78c9c55-hx8kp   1/1     Running   0          1m    master01
```

---

# Question 3. Understand `NoExecute` taint effect.

## Important Note

`NoExecute` is stronger than `NoSchedule`.

- New pods without matching toleration will not be scheduled.
- Existing pods without matching toleration can be evicted from the node.

---

## Apply `NoExecute` taint

```bash
oc adm taint node master01 app=critical:NoExecute
```

### Check pods

```bash
oc get pods -A -o wide
```

### Check events

```bash
oc events
```

You may observe pod eviction or scheduling failure if toleration is missing.

---

## Add `NoExecute` toleration with tolerationSeconds

```bash
oc patch deployment webserver-app2 \
  --type='merge' \
  -p '{"spec":{"template":{"spec":{"tolerations":[{"key":"app","operator":"Equal","value":"critical","effect":"NoExecute","tolerationSeconds":3600}]}}}}'
```

### Verify

```bash
oc get deployment webserver-app2 -o yaml | grep -iA 10 tolerations
```

Expected output:

```yaml
tolerations:
- effect: NoExecute
  key: app
  operator: Equal
  tolerationSeconds: 3600
  value: critical
```

---

# Important Commands Summary

| Task | Command |
|---|---|
| Check nodes | `oc get nodes` |
| Apply taint | `oc adm taint node master01 key=value:NoSchedule` |
| Remove taint | `oc adm taint node master01 key-` |
| Check taints | `oc describe node master01 \| grep -i taint` |
| Check pending pod issue | `oc describe pod pod_name` |
| Check events | `oc events` |
| Add toleration | `oc patch deployment deployment_name --type='merge' -p '...'` |
| Check toleration | `oc get deployment deployment_name -o yaml` |

---

# Troubleshooting Tips

## 1. Pod is Pending

Check events:

```bash
oc events
```

or

```bash
oc describe pod pod_name
```

If you see:

```bash
untolerated taint
```

then check the node taints.

---

## 2. Check node taint

```bash
oc describe node master01 | grep -i taint
```

---

## 3. Check pod toleration

```bash
oc get pod pod_name -o yaml | grep -iA 8 tolerations
```

---

## 4. Check deployment toleration

```bash
oc get deployment deployment_name -o yaml | grep -iA 8 tolerations
```

---

# Cleanup

## Remove taints

```bash
oc adm taint node master01 datacenter-
oc adm taint node master01 environment-
oc adm taint node master01 app-
```

## Delete projects

```bash
oc delete project chapter1
oc delete project chapter2
```

---

# Exam Notes

- **Taint** is applied on **node**.
- **Toleration** is applied on **pod**.
- Taint and toleration do not guarantee scheduling.
- They only allow pod to be scheduled on tainted node.
- Scheduler also checks node selector, affinity, resources, and other scheduling rules.
- `NoSchedule` blocks new pods.
- `PreferNoSchedule` tries to avoid scheduling.
- `NoExecute` can evict existing pods.
- Error message `untolerated taint` means pod needs matching toleration or node taint must be removed.

---

# One-line Memory Trick

```text
Taint = Node says NO
Toleration = Pod says I can tolerate it
```
