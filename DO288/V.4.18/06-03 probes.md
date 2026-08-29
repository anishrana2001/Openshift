# 🩺 OpenShift Lab: Configure Startup, Liveness, and Readiness Probes

## How to create lab for this task?
```
oc login -u developer -p developer https://api.ocp4.example.com:6443
oc new-project deploy-probes
oc create deployment todo-ssr --image registry.ocp4.example.com:8443/redhattraining/hello-world-nginx:v1.0 
clear
oc get all
```

---

# 🧩 Student task

Configure startup, liveness, and readiness probes on the container **`hello-world-nginx`** of the existing `todo-ssr` Deployment in the `deploy-probes` project.

## 1. Startup probe requirements

Configure a **startup probe** with the following settings:

- The probe monitors startup by performing a **TCP socket check** on port **`8080`**.
- The startup probe waits an initial delay of `10 seconds` before probe checks are started.
- The startup probe waits **`21 seconds`** before every probe check times out.
- The startup probe can have a minimum of **`5 consecutive failures`** before the probe is considered failed after having succeeded.

## 2. Liveness probe requirements

Configure a **liveness probe** with the following settings:

- The probe monitors liveness by performing a **TCP socket check** on port **`8080`**.
- The liveness probe must perform the probe every **`10 seconds`**.
- The liveness probe waits a timeout of **`5 seconds`**.
- The liveness probe can have a minimum of **`5 consecutive failures`** before the probe is considered failed after having succeeded.

## 3. Readiness probe requirements

Configure a **readiness probe** with the following settings:

- The readiness checks are done by performing an **HTTP request** to the `/` endpoint on port 8080
- The readiness probe must perform the probe every **`17 seconds`**.
- The readiness probe waits a timeout of **`40 seconds`**.
- The readiness probe can have a minimum of **`5 consecutive failures`** before the probe is considered failed after having succeeded.

# 🎯 Learning objectives

After completing this lab, you should be able to:

- distinguish startup, liveness, and readiness probes;
- configure TCP and HTTP probe actions with the `oc` command;
- explain `initialDelaySeconds`, `periodSeconds`, `timeoutSeconds`, and `failureThreshold`;
- inspect probe settings in a Deployment;
- monitor rollout status, Pod readiness, restart counts, and events;
- demonstrate the effect of a failed readiness probe on Service endpoints.

---

# ✅ Solution

## Step 1: Go to the desired project.

```bash
oc project deploy-probes
```

## Step 2: Confirm that the Deployment and Pod exist

```bash
oc get deployment/todo-ssr
oc get pods
```

## Step 3: Identify the main container, it should be `hello-world-nginx`


```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[*].name}{"\n"}'
```

## Step 4: Use built-in command help

Inspect the probe command:

```bash
oc set probe --help
```

Inspect the Deployment probe fields:

```bash
oc explain deployment.spec.template.spec.containers.startupProbe
oc explain deployment.spec.template.spec.containers.livenessProbe
oc explain deployment.spec.template.spec.containers.readinessProbe
```

## Step 5: Configure the startup probe

Run:

```bash
oc set probe deployment/todo-ssr \
  --startup \
  --open-tcp=8080 \
  --initial-delay-seconds=10 \
  --timeout-seconds=21
```

### Command explanation

| Option | Meaning |
|---|---|
| `deployment/todo-ssr` | Updates the Pod template in the `todo-ssr` Deployment. |
| `--startup` | Selects the startup probe. |
| `--open-tcp=8080` | Attempts to open a TCP connection to port `8080`. |
| `--initial-delay-seconds=10` | Waits 10 seconds after container startup before initiating the probe. |
| `--timeout-seconds=18` | Allows one probe attempt up to 18 seconds before timing out. |

Because `periodSeconds`, `failureThreshold`, and `successThreshold` are not specified, their platform defaults are retained.

---

## Step 6: Configure the liveness probe

Run:

```bash
oc set probe deployment/todo-ssr \
  --liveness \
  --open-tcp=8080 \
  --period-seconds=10 \
  --timeout-seconds=5 \
  --failure-threshold=5
```

### Command explanation

| Option | Meaning |
|---|---|
| `--liveness` | Selects the liveness probe. |
| `--open-tcp=8080` | Checks whether the application accepts a TCP connection on port `8080`. |
| `--period-seconds=10` | Performs the probe approximately every 10 seconds. |
| `--timeout-seconds=5` | Treats an individual probe attempt as failed if it does not complete in 5 seconds. |
| `--failure-threshold=5` | Requires five consecutive failures before the container is treated as unhealthy. |

A liveness failure can restart the container. It does not merely remove the Pod from Service traffic.

---

## Step 7: Configure the readiness probe

Run:

```bash
oc set probe deployment/todo-ssr \
  --readiness \
  --get-url=http://:8080/ \
  --period-seconds=17 \
  --timeout-seconds=40 \
  --failure-threshold=5
```

### Understanding the URL

```text
http://:8080/
       │    └── path: /
       └─────── port: 8080
```

The host is intentionally empty. The platform performs the request against the Pod IP.

### Command explanation

| Option | Meaning |
|---|---|
| `--readiness` | Selects the readiness probe. |
| `--get-url=http://:8080/` | Sends an HTTP GET request to `/` on port `8080` of the Pod. |
| `--period-seconds=15` | Performs the readiness check approximately every 15 seconds. |
| `--timeout-seconds=60` | Allows an individual HTTP check up to 60 seconds before timing out. |
| `--failure-threshold=5` | Marks the container unready after five consecutive failed checks. |

A failed readiness probe does not normally restart the container. It changes the Pod's ready state so that matching Services stop sending it normal traffic.

---

## Step 8: Monitor the Deployment rollout

Each `oc set probe` command changes the Deployment's Pod template. The Deployment therefore creates a new ReplicaSet and replaces the old Pod.

Monitor the final rollout:

```bash
oc rollout status deployment/todo-ssr
```

List ReplicaSets:

```bash
oc get replicasets
```

List Pods with labels:

```bash
oc get pods --show-labels
```

---

# 🔍 Validate the configuration

## Validation 1: Display all probe configuration

```bash
oc get deployment/todo-ssr -o yaml
```

Locate the following sections beneath the application container:

```yaml
startupProbe:
livenessProbe:
readinessProbe:
```

A relevant result should resemble:

```yaml
spec:
  template:
    spec:
      containers:
        - name: todo-ssr
          startupProbe:
            tcpSocket:
              port: 8080
            initialDelaySeconds: 10
            timeoutSeconds: 21
            periodSeconds: 10
            successThreshold: 1
            failureThreshold: 3

          livenessProbe:
            tcpSocket:
              port: 8080
            timeoutSeconds: 5
            periodSeconds: 10
            successThreshold: 1
            failureThreshold: 5

          readinessProbe:
            httpGet:
              path: /
              port: 8080
              scheme: HTTP
            timeoutSeconds: 40
            periodSeconds: 17
            successThreshold: 1
            failureThreshold: 5
```

> The order of YAML fields can differ. Validate field names and values rather than expecting a particular display order.

---

