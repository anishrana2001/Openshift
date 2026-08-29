# 🩺 OpenShift Lab: Configure Startup, Liveness, and Readiness Probes

## 📚 Lab overview

# 🧠 Probe concepts before you begin

| Probe | Main question | Failure result |
|---|---|---|
| **Startup** | Has the application finished starting? | The container is restarted if the startup probe reaches its failure threshold. |
| **Liveness** | Is the application still functioning? | The container is restarted after the configured consecutive failures. |
| **Readiness** | Can the application receive traffic now? | The Pod is marked unready and is removed from matching Service endpoints. |

## Easy memory aid

```text
Startup   → Can the application begin?
Liveness  → Should the container continue?
Readiness → Should the Pod receive traffic?
```

A startup probe protects a slow-starting application from premature liveness failures. After it succeeds, liveness and readiness checks can perform their normal jobs. Three probes, three responsibilities, because one health signal would apparently be far too peaceful.



In this lab, you configure three Kubernetes health probes on the running `todo-ssr` Deployment in the `deploy-probes` project.

The application listens on TCP port `8080`. You will use:

- a **TCP startup probe** to confirm that the application has started;
- a **TCP liveness probe** to detect an application that is no longer healthy;
- an **HTTP readiness probe** to determine whether the application can receive traffic.

> **Target resource:** `deployment/todo-ssr`  
> **Target project:** `deploy-probes`  
> **Application port:** `8080`

---

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

Configure startup, liveness, and readiness probes on the main container of the existing `todo-ssr` Deployment in the `deploy-probes` project.

## 1. Startup probe requirements

Configure a **startup probe** with the following settings:

| Setting | Required value |
|---|---:|
| Probe mechanism | TCP socket |
| TCP port | `8080` |
| Initial delay | `10` seconds |
| Timeout | `18` seconds |

The startup probe must determine whether the application has completed its startup process.

### Additional startup-probe tasks

After configuring the probe:

1. Identify the default values assigned to `periodSeconds`, `failureThreshold`, and `successThreshold`.
2. Calculate how many failed startup checks are allowed by the resulting configuration.
3. Explain why liveness and readiness checks do not take effect until the startup probe succeeds.
4. Use `oc explain` to identify the YAML field used for the TCP socket action.

---

## 2. Liveness probe requirements

Configure a **liveness probe** with the following settings:

| Setting | Required value |
|---|---:|
| Probe mechanism | TCP socket |
| TCP port | `8080` |
| Probe interval | `10` seconds |
| Timeout | `5` seconds |
| Failure threshold | `5` consecutive failures |

The liveness probe must restart the application container when the TCP check fails five consecutive times.

### Additional liveness-probe tasks

After configuring the probe:

1. Record the container restart count while the application is healthy.
2. Explain the difference between a probe failure and a container restart.
3. Determine the approximate probe interval represented by `periodSeconds`.
4. Use Pod events to confirm that no liveness failures are occurring.
5. Explain why a liveness probe should not be used merely to determine whether a Pod should receive traffic.

---

## 3. Readiness probe requirements

Configure a **readiness probe** with the following settings:

| Setting | Required value |
|---|---:|
| Probe mechanism | HTTP GET |
| URL path | `/` |
| Port | `8080` |
| Probe interval | `15` seconds |
| Timeout | `60` seconds |
| Failure threshold | `5` consecutive failures |

The readiness probe must prevent an unhealthy or temporarily unavailable Pod from receiving Service traffic.

### Additional readiness-probe tasks

After configuring the probe:

1. Verify that the HTTP request uses the Pod IP by leaving the host portion of the URL empty.
2. Create a Service for the Deployment and confirm that the ready Pod appears as an endpoint.
3. Scale the Deployment to two replicas and verify that both Pods become ready.
4. In a practice environment, temporarily configure an invalid readiness path and observe that the Pod becomes unready without being restarted.
5. Restore the correct `/` readiness path after the troubleshooting exercise.

---

# 🎯 Learning objectives

After completing this lab, you should be able to:

- distinguish startup, liveness, and readiness probes;
- configure TCP and HTTP probe actions with the `oc` command;
- explain `initialDelaySeconds`, `periodSeconds`, `timeoutSeconds`, and `failureThreshold`;
- inspect probe settings in a Deployment;
- monitor rollout status, Pod readiness, restart counts, and events;
- demonstrate the effect of a failed readiness probe on Service endpoints.

---

# 🧠 Probe concepts before you begin

| Probe | Main question | Failure result |
|---|---|---|
| **Startup** | Has the application finished starting? | The container is restarted if the startup probe reaches its failure threshold. |
| **Liveness** | Is the application still functioning? | The container is restarted after the configured consecutive failures. |
| **Readiness** | Can the application receive traffic now? | The Pod is marked unready and is removed from matching Service endpoints. |

## Easy memory aid

```text
Startup   → Can the application begin?
Liveness  → Should the container continue?
Readiness → Should the Pod receive traffic?
```

A startup probe protects a slow-starting application from premature liveness failures. After it succeeds, liveness and readiness checks can perform their normal jobs. Three probes, three responsibilities, because one health signal would apparently be far too peaceful.

---

# ✅ Solution

## Step 1: Confirm the current project

```bash
oc project
```

Expected project:

```text
deploy-probes
```

If another project is selected, switch to the required project:

```bash
oc project deploy-probes
```

---

## Step 2: Confirm that the Deployment and Pod exist

```bash
oc get deployment/todo-ssr
oc get pods
```

Wait until the initial Pod is running:

```bash
oc rollout status deployment/todo-ssr
```

Inspect the Deployment:

```bash
oc describe deployment/todo-ssr
```

---

## Step 3: Identify the main container

Display the container name:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[*].name}{"\n"}'
```

Display the container image:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[*].image}{"\n"}'
```

The lab contains one application container, so `oc set probe` applies the probe configuration to that container.

---

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

Inspect the two probe mechanisms used in this lab:

```bash
oc explain deployment.spec.template.spec.containers.startupProbe.tcpSocket
oc explain deployment.spec.template.spec.containers.readinessProbe.httpGet
```

Inspect all fields recursively:

```bash
oc explain deployment.spec.template.spec.containers.startupProbe --recursive
```

---

## Step 5: Configure the startup probe

Run:

```bash
oc set probe deployment/todo-ssr \
  --startup \
  --open-tcp=8080 \
  --initial-delay-seconds=10 \
  --timeout-seconds=18
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
  --period-seconds=15 \
  --timeout-seconds=60 \
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
            timeoutSeconds: 18
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
            timeoutSeconds: 60
            periodSeconds: 15
            successThreshold: 1
            failureThreshold: 5
```

> The order of YAML fields can differ. Validate field names and values rather than expecting a particular display order.

---

## Validation 2: Check the startup probe

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].startupProbe.tcpSocket.port}{"\n"}'
```

Expected:

```text
8080
```

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].startupProbe.initialDelaySeconds}{"\n"}'
```

Expected:

```text
10
```

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].startupProbe.timeoutSeconds}{"\n"}'
```

Expected:

```text
18
```

Display the defaulted startup values:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='period={.spec.template.spec.containers[0].startupProbe.periodSeconds}{"\n"}failure={.spec.template.spec.containers[0].startupProbe.failureThreshold}{"\n"}success={.spec.template.spec.containers[0].startupProbe.successThreshold}{"\n"}'
```

Typical output:

```text
period=10
failure=3
success=1
```

---

## Validation 3: Check the liveness probe

```bash
oc get deployment/todo-ssr \
  -o jsonpath='port={.spec.template.spec.containers[0].livenessProbe.tcpSocket.port}{"\n"}period={.spec.template.spec.containers[0].livenessProbe.periodSeconds}{"\n"}timeout={.spec.template.spec.containers[0].livenessProbe.timeoutSeconds}{"\n"}failure={.spec.template.spec.containers[0].livenessProbe.failureThreshold}{"\n"}'
```

Expected:

```text
port=8080
period=10
timeout=5
failure=5
```

---

## Validation 4: Check the readiness probe

```bash
oc get deployment/todo-ssr \
  -o jsonpath='scheme={.spec.template.spec.containers[0].readinessProbe.httpGet.scheme}{"\n"}path={.spec.template.spec.containers[0].readinessProbe.httpGet.path}{"\n"}port={.spec.template.spec.containers[0].readinessProbe.httpGet.port}{"\n"}period={.spec.template.spec.containers[0].readinessProbe.periodSeconds}{"\n"}timeout={.spec.template.spec.containers[0].readinessProbe.timeoutSeconds}{"\n"}failure={.spec.template.spec.containers[0].readinessProbe.failureThreshold}{"\n"}'
```

Expected:

```text
scheme=HTTP
path=/
port=8080
period=15
timeout=60
failure=5
```

---

## Validation 5: Check Pod readiness and restart count

Select the newest running Pod dynamically:

```bash
POD=$(oc get pods \
  -l app=todo-ssr \
  --field-selector=status.phase=Running \
  --sort-by=.metadata.creationTimestamp \
  -o jsonpath='{.items[-1:].metadata.name}')
```

Display the selected Pod:

```bash
echo "$POD"
```

Check whether its application container is ready:

```bash
oc get pod "$POD" \
  -o jsonpath='ready={.status.containerStatuses[0].ready}{"\n"}restarts={.status.containerStatuses[0].restartCount}{"\n"}'
```

Expected healthy result:

```text
ready=true
restarts=0
```

A restart count greater than zero is not automatically a configuration failure, but it requires investigation.

---

## Validation 6: Review Pod events

```bash
oc describe pod "$POD"
```

Review the `Events` section for messages such as:

```text
Startup probe failed
Liveness probe failed
Readiness probe failed
```

A healthy Pod should not continuously produce probe failure events.

You can also sort project events by creation time:

```bash
oc get events --sort-by=.metadata.creationTimestamp
```

---

# 🧪 Additional practice exercises

These exercises make the lab more practical and provide original troubleshooting work beyond merely entering three commands.

## Exercise A: Observe a Deployment rollout

1. Display the active ReplicaSet:

   ```bash
   oc get replicasets
   ```

2. Change one readiness value:

   ```bash
   oc set probe deployment/todo-ssr \
     --readiness \
     --get-url=http://:8080/ \
     --period-seconds=12 \
     --timeout-seconds=60 \
     --failure-threshold=5
   ```

3. Observe the new rollout:

   ```bash
   oc rollout status deployment/todo-ssr
   oc get replicasets
   ```

4. Restore the required value:

   ```bash
   oc set probe deployment/todo-ssr \
     --readiness \
     --get-url=http://:8080/ \
     --period-seconds=15 \
     --timeout-seconds=60 \
     --failure-threshold=5
   ```

---

## Exercise B: Create a Service and inspect readiness endpoints

Create a Service:

```bash
oc expose deployment/todo-ssr --port=8080
```

Verify it:

```bash
oc get service/todo-ssr
```

Inspect the endpoints:

```bash
oc get endpoints/todo-ssr
```

A ready Pod should appear as a Service endpoint. An unready Pod is not used as a normal ready endpoint.

---

## Exercise C: Scale the application

Scale to two replicas:

```bash
oc scale deployment/todo-ssr --replicas=2
```

Monitor the rollout:

```bash
oc rollout status deployment/todo-ssr
```

Verify that both Pods become ready:

```bash
oc get pods -l app=todo-ssr
```

Expected `READY` values:

```text
1/1
1/1
```

Inspect Service endpoints again:

```bash
oc get endpoints/todo-ssr
```

Restore the original replica count when finished:

```bash
oc scale deployment/todo-ssr --replicas=1
```

---

## Exercise D: Demonstrate a readiness failure safely

> ⚠️ Run this only in a practice environment. Do not perform extra changes in a graded or closed exam environment unless instructed.

Temporarily configure an endpoint that does not exist:

```bash
oc set probe deployment/todo-ssr \
  --readiness \
  --get-url=http://:8080/this-path-does-not-exist \
  --period-seconds=5 \
  --timeout-seconds=2 \
  --failure-threshold=1
```

Watch the Pods:

```bash
oc get pods -w
```

Stop the watch with `Ctrl+C`.

Inspect events:

```bash
oc get events --sort-by=.metadata.creationTimestamp
```

Observe these expected behaviors:

- the new container can remain running;
- the new Pod can show `0/1` readiness;
- the readiness failure does not require a container restart;
- the Deployment rollout can pause because the replacement Pod is not ready;
- a matching Service does not treat the failed Pod as a normal ready endpoint.

Restore the required readiness probe:

```bash
oc set probe deployment/todo-ssr \
  --readiness \
  --get-url=http://:8080/ \
  --period-seconds=15 \
  --timeout-seconds=60 \
  --failure-threshold=5
```

Confirm recovery:

```bash
oc rollout status deployment/todo-ssr
oc get pods
oc get endpoints/todo-ssr
```

---

## Exercise E: Compare readiness and liveness outcomes

Answer the following without deliberately breaking the liveness probe:

1. What happens to Service traffic when readiness fails?
2. What happens to the container when liveness reaches its failure threshold?
3. Why can a readiness failure be appropriate during a temporary dependency outage?
4. Why can an overly aggressive liveness probe make an outage worse?
5. Why is the startup probe useful for an application that takes a long time to initialize?

Suggested comparison:

| Situation | Readiness result | Liveness result |
|---|---|---|
| Application is warming its cache | Temporarily stop traffic | Usually do not restart |
| Application is deadlocked | Not ready | Restart after threshold |
| External dependency is briefly unavailable | Often mark unready | Avoid unnecessary restart |
| Application has not completed startup | Startup probe remains active | Liveness waits for startup success |

---

## Exercise F: Inspect probe YAML with `oc explain`

Run:

```bash
oc explain deployment.spec.template.spec.containers.startupProbe
oc explain deployment.spec.template.spec.containers.livenessProbe
oc explain deployment.spec.template.spec.containers.readinessProbe
```

Then answer:

1. Which field controls how often a probe runs?
2. Which field controls an individual probe's timeout?
3. Which field controls the number of consecutive failures?
4. Which probe types require `successThreshold` to remain `1`?
5. Which action field represents a TCP probe?
6. Which action field represents an HTTP probe?

---

# 🧩 Five additional probe questions

The following questions are original practice scenarios based on the same OpenShift probe concepts. Complete them one at a time in a practice environment.

> ⚠️ **Practice note:** Each question changes the probe configuration. Use the provided restore command before moving to the next question, or recreate the lab. In a graded environment, perform only the changes explicitly requested by the task. Automated graders are famously unmoved by creative experimentation.

## Quick question map

| Question | Main skill |
|---|---|
| 1 | Configure an HTTP startup probe and calculate its startup budget |
| 2 | Configure an exec-based liveness probe |
| 3 | Control readiness recovery with `successThreshold` |
| 4 | Remove only one probe and restore it |
| 5 | Use a named container port in HTTP and TCP probes |

---

## Question 1: Configure an HTTP startup probe

### 📋 Question

Reconfigure the startup probe on `deployment/todo-ssr` with the following requirements:

| Setting | Required value |
|---|---:|
| Probe mechanism | HTTP GET |
| Path | `/` |
| Port | `8080` |
| Initial delay | `6` seconds |
| Probe interval | `5` seconds |
| Timeout | `2` seconds |
| Failure threshold | `12` consecutive failures |

After configuring the probe, determine the approximate startup-check budget available after probing begins.

### ✅ Solution

```bash
oc project deploy-probes

oc set probe deployment/todo-ssr \
  --startup \
  --get-url=http://:8080/ \
  --initial-delay-seconds=6 \
  --period-seconds=5 \
  --timeout-seconds=2 \
  --failure-threshold=12
```

Monitor the rollout:

```bash
oc rollout status deployment/todo-ssr
```

Validate the probe:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].startupProbe}{"\n"}'
```

Expected relevant configuration:

```yaml
startupProbe:
  httpGet:
    scheme: HTTP
    path: /
    port: 8080
  initialDelaySeconds: 6
  periodSeconds: 5
  timeoutSeconds: 2
  failureThreshold: 12
  successThreshold: 1
```

### 🧠 Explanation

The URL:

```text
http://:8080/
```

leaves the host empty, so the kubelet sends the request to the Pod IP. The probe succeeds when the endpoint returns a successful HTTP response code.

The configured startup-check budget is approximately:

```text
failureThreshold × periodSeconds
12 × 5 seconds = 60 seconds
```

Therefore, probing starts after the initial `6`-second delay, and the application then has roughly another `60` seconds of failed checks before the startup probe reaches its failure threshold. Probe scheduling and individual timeouts can affect the exact wall-clock moment, so this is a planning estimate rather than a railway timetable.

While the startup probe has not succeeded, the liveness and readiness probes are held back. This prevents a slow-starting application from being restarted or marked ready too early.

### 🔄 Restore the original startup probe

```bash
oc set probe deployment/todo-ssr \
  --startup \
  --open-tcp=8080 \
  --initial-delay-seconds=10 \
  --period-seconds=10 \
  --timeout-seconds=18 \
  --failure-threshold=3 \
  --success-threshold=1
```

---

## Question 2: Configure an exec-based liveness probe

### 📋 Question

Configure a liveness probe that verifies that the NGINX index file exists and is not empty.

Use these settings:

| Setting | Required value |
|---|---:|
| Probe mechanism | Container command (`exec`) |
| Command | `/bin/sh -c 'test -s /usr/share/nginx/html/index.html'` |
| Initial delay | `15` seconds |
| Probe interval | `20` seconds |
| Timeout | `3` seconds |
| Failure threshold | `3` consecutive failures |

### 🔍 Pre-check

Obtain the running Pod dynamically:

```bash
POD=$(oc get pods \
  -l app=todo-ssr \
  --field-selector=status.phase=Running \
  -o name | head -1)

echo "$POD"
```

Confirm that the file exists before making it the liveness condition:

```bash
oc exec "$POD" -- \
  /bin/sh -c 'test -s /usr/share/nginx/html/index.html && echo "index file is present"'
```

If the file path is different in a modified image, identify a stable application file first. A liveness probe should test a condition that is meaningful for the actual container, not a path selected through spiritual intuition.

### ✅ Solution

```bash
oc set probe deployment/todo-ssr \
  --liveness \
  --initial-delay-seconds=15 \
  --period-seconds=20 \
  --timeout-seconds=3 \
  --failure-threshold=3 \
  -- /bin/sh -c 'test -s /usr/share/nginx/html/index.html'
```

Monitor the rollout:

```bash
oc rollout status deployment/todo-ssr
```

Validate the command stored in the probe:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.exec.command}{"\n"}'
```

Expected output resembles:

```text
[/bin/sh -c test -s /usr/share/nginx/html/index.html]
```

Display the complete liveness probe:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].livenessProbe}{"\n"}'
```

### 🧠 Explanation

An exec probe runs a command inside the container:

- exit status `0` means success;
- a non-zero exit status means failure;
- reaching the liveness failure threshold causes the container to be restarted.

The command:

```bash
test -s /usr/share/nginx/html/index.html
```

succeeds only when the file exists and has a size greater than zero.

Exec probes are useful when application health can only be determined from inside the container. For a web application, however, HTTP or TCP checks are often simpler and use fewer container-side resources.

### 🔄 Restore the original TCP liveness probe

```bash
oc set probe deployment/todo-ssr \
  --liveness \
  --open-tcp=8080 \
  --initial-delay-seconds=0 \
  --period-seconds=10 \
  --timeout-seconds=5 \
  --failure-threshold=5 \
  --success-threshold=1
```

---

## Question 3: Require repeated readiness successes after failure

### 📋 Question

Reconfigure the readiness probe so that a failed Pod must pass three consecutive checks before it becomes ready again.

Use these settings:

| Setting | Required value |
|---|---:|
| Probe mechanism | HTTP GET |
| Path | `/` |
| Port | `8080` |
| Probe interval | `5` seconds |
| Timeout | `2` seconds |
| Failure threshold | `2` consecutive failures |
| Success threshold | `3` consecutive successes |

### ✅ Solution

First inspect the field:

```bash
oc explain deployment.spec.template.spec.containers.readinessProbe.successThreshold
```

Configure the probe:

```bash
oc set probe deployment/todo-ssr \
  --readiness \
  --get-url=http://:8080/ \
  --period-seconds=5 \
  --timeout-seconds=2 \
  --failure-threshold=2 \
  --success-threshold=3
```

The resulting relevant YAML is:

```yaml
readinessProbe:
  httpGet:
    scheme: HTTP
    path: /
    port: 8080
  periodSeconds: 5
  timeoutSeconds: 2
  failureThreshold: 2
  successThreshold: 3
```

Monitor the rollout:

```bash
oc rollout status deployment/todo-ssr
```

Validate the thresholds:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='failureThreshold={.spec.template.spec.containers[0].readinessProbe.failureThreshold}{"\n"}successThreshold={.spec.template.spec.containers[0].readinessProbe.successThreshold}{"\n"}'
```

Expected output:

```text
failureThreshold=2
successThreshold=3
```

### 🧠 Explanation

`failureThreshold: 2` means that two consecutive failed checks are required before the readiness probe is considered failed.

`successThreshold: 3` means that, after an unsuccessful condition, three consecutive successful checks are required before the container is considered ready again. With a `5`-second period, recovery generally requires several successful checks over roughly `15` seconds.

A success threshold greater than `1` is valid for readiness probes. Startup and liveness probes must keep `successThreshold` at `1`, because their purpose is not to provide gradual traffic re-entry.

This configuration is useful when a dependency is unstable and you do not want a Pod repeatedly entering and leaving Service endpoints after a single successful check.

### 🔄 Restore the original readiness probe

```bash
oc set probe deployment/todo-ssr \
  --readiness \
  --get-url=http://:8080/ \
  --period-seconds=15 \
  --timeout-seconds=60 \
  --failure-threshold=5 \
  --success-threshold=1
```

After restoring it, confirm that `successThreshold` has returned to `1`:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.successThreshold}{"\n"}'
```

---

## Question 4: Remove only the liveness probe

### 📋 Question

Temporarily remove the liveness probe from `deployment/todo-ssr` while keeping the startup and readiness probes configured.

Then:

1. verify that only the liveness probe was removed;
2. confirm that a new rollout occurred;
3. restore the original liveness probe.

### ✅ Solution

Remove only the liveness probe:

```bash
oc set probe deployment/todo-ssr \
  --remove \
  --liveness
```

Monitor the rollout:

```bash
oc rollout status deployment/todo-ssr
```

Verify that the liveness probe is absent:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].livenessProbe}{"\n"}'
```

An empty line is expected.

Confirm that the startup probe still exists:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].startupProbe.tcpSocket.port}{"\n"}'
```

Expected:

```text
8080
```

Confirm that the readiness probe still exists:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.path}{"\n"}'
```

Expected:

```text
/
```

Restore the original liveness probe:

```bash
oc set probe deployment/todo-ssr \
  --liveness \
  --open-tcp=8080 \
  --initial-delay-seconds=0 \
  --period-seconds=10 \
  --timeout-seconds=5 \
  --failure-threshold=5 \
  --success-threshold=1
```

Verify the restored configuration:

```bash
oc rollout status deployment/todo-ssr

oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].livenessProbe}{"\n"}'
```

### 🧠 Explanation

The `--remove` option removes only the probe types selected on the same command line. In this question, `--liveness` is selected, so startup and readiness remain unchanged.

Removing or restoring a probe changes the Deployment's Pod template. Kubernetes therefore creates a new ReplicaSet and rolls out replacement Pods. Existing Pods are not edited in place, because immutable Pod templates remain one of the few boundaries the platform enforces consistently.

This technique is useful during troubleshooting, but running without a required liveness probe should be temporary and deliberate.

---

## Question 5: Use a named port in the probes

### 📋 Question

Configure the application container so that port `8080` is named `web`. Then use that named port in both:

- a TCP startup probe; and
- an HTTP readiness probe.

Use the following probe settings:

#### Startup probe

| Setting | Required value |
|---|---:|
| Mechanism | TCP socket |
| Port | `web` |
| Probe interval | `4` seconds |
| Timeout | `2` seconds |
| Failure threshold | `15` consecutive failures |

#### Readiness probe

| Setting | Required value |
|---|---:|
| Mechanism | HTTP GET |
| Path | `/` |
| Port | `web` |
| Probe interval | `10` seconds |
| Timeout | `3` seconds |
| Failure threshold | `3` consecutive failures |

### ✅ Solution

Display the actual container name:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].name}{"\n"}'
```

Edit the Deployment:

```bash
oc edit deployment/todo-ssr
```

Under the existing container, configure the following relevant fields:

```yaml
ports:
  - name: web
    containerPort: 8080
    protocol: TCP

startupProbe:
  tcpSocket:
    port: web
  periodSeconds: 4
  timeoutSeconds: 2
  failureThreshold: 15
  successThreshold: 1

readinessProbe:
  httpGet:
    scheme: HTTP
    path: /
    port: web
  periodSeconds: 10
  timeoutSeconds: 3
  failureThreshold: 3
  successThreshold: 1
```

> If a `containerPort: 8080` entry already exists, add `name: web` to that entry instead of creating a duplicate port definition.

Save and monitor the rollout:

```bash
oc rollout status deployment/todo-ssr
```

Validate the named container port:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].ports[?(@.name=="web")].containerPort}{"\n"}'
```

Expected:

```text
8080
```

Validate the startup probe port:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].startupProbe.tcpSocket.port}{"\n"}'
```

Expected:

```text
web
```

Validate the readiness probe port:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.port}{"\n"}'
```

Expected:

```text
web
```

### 🧠 Explanation

HTTP and TCP probes can refer to a container port by name rather than by number. The probe resolves `web` to the container port definition:

```yaml
- name: web
  containerPort: 8080
```

Named ports improve readability and reduce repeated numeric values. If the application port later changes, the container port definition and application configuration still need to be updated, but every probe that refers to `web` does not need its own numeric port edited separately.

A named port must exist in the same container that owns the probe. Misspelling `web` creates a probe that cannot resolve its target, which is the sort of tiny configuration defect that can consume an impressively adult portion of an afternoon.

### 🔄 Optional restore to the original numeric probe configuration

```bash
oc set probe deployment/todo-ssr \
  --startup \
  --open-tcp=8080 \
  --initial-delay-seconds=10 \
  --period-seconds=10 \
  --timeout-seconds=18 \
  --failure-threshold=3 \
  --success-threshold=1

oc set probe deployment/todo-ssr \
  --readiness \
  --get-url=http://:8080/ \
  --period-seconds=15 \
  --timeout-seconds=60 \
  --failure-threshold=5 \
  --success-threshold=1
```

The named `web` port can remain on the container; it does not interfere with numeric probe references.

---

# ✅ Additional-question completion checklist

- [ ] Question 1 used an HTTP startup probe and calculated its startup budget.
- [ ] Question 2 demonstrated how an exec probe interprets command exit status.
- [ ] Question 3 used `successThreshold` to make readiness recovery less sensitive to a single success.
- [ ] Question 4 removed only the liveness probe and preserved the other probes.
- [ ] Question 5 configured and validated a named container port.
- [ ] The required baseline probes were restored after each temporary exercise.
- [ ] The Deployment completed its latest rollout.
- [ ] The running Pod returned to the `1/1` ready state.

# 🛠️ Troubleshooting guide

## Problem 1: The Pod never becomes ready

Check:

```bash
oc get pods
oc describe pod "$POD"
oc get events --sort-by=.metadata.creationTimestamp
```

Common causes include:

- incorrect HTTP path;
- incorrect port;
- application not listening on the Pod IP;
- application returning an unsuccessful HTTP status;
- startup probe not succeeding.

---

## Problem 2: The container keeps restarting

Check restart count:

```bash
oc get pod "$POD" \
  -o jsonpath='{.status.containerStatuses[0].restartCount}{"\n"}'
```

Check the previous container log:

```bash
oc logs "$POD" --previous
```

Inspect events:

```bash
oc describe pod "$POD"
```

Common causes include:

- liveness port is incorrect;
- startup probe does not allow enough startup time;
- application stops listening on port `8080`;
- probe thresholds are too aggressive.

---

## Problem 3: The HTTP readiness URL looks unusual

This command is intentional:

```bash
--get-url=http://:8080/
```

It means:

```yaml
httpGet:
  scheme: HTTP
  port: 8080
  path: /
```

The empty host tells the probe to use the Pod IP.

---

## Problem 4: A probe was added to the wrong project

Verify:

```bash
oc project
```

Switch projects:

```bash
oc project deploy-probes
```

Then inspect:

```bash
oc get deployment/todo-ssr
```

---

## Problem 5: The label selector returns no Pod

Inspect the Deployment selector:

```bash
oc get deployment/todo-ssr \
  -o jsonpath='{.spec.selector.matchLabels}{"\n"}'
```

List labels:

```bash
oc get pods --show-labels
```

Then select the Pod using the labels displayed by your cluster.

---

# 🧹 Optional reset

Remove all three probes:

```bash
oc set probe deployment/todo-ssr \
  --remove \
  --startup \
  --liveness \
  --readiness
```

Confirm removal:

```bash
oc get deployment/todo-ssr -o yaml
```

Reapply the required configuration:

```bash
oc set probe deployment/todo-ssr --startup --open-tcp=8080 --initial-delay-seconds=10 --timeout-seconds=18
oc set probe deployment/todo-ssr --liveness --open-tcp=8080 --period-seconds=10 --timeout-seconds=5 --failure-threshold=5
oc set probe deployment/todo-ssr --readiness --get-url=http://:8080/ --period-seconds=15 --timeout-seconds=60 --failure-threshold=5
```

---

# 📝 Instructor explanation

## Why use a startup probe?

A startup probe is useful when an application needs time to initialize. Until it succeeds, the platform does not allow the liveness and readiness probes to interfere with startup.

For this lab:

```text
Initial delay: 10 seconds
TCP target:    port 8080
Timeout:       18 seconds
```

The probe succeeds when a TCP connection to port `8080` can be established.

---

## Why use a liveness probe?

A liveness probe detects a container that remains running but can no longer perform useful work. After five consecutive TCP failures, the container is considered unhealthy and is restarted according to the Pod restart policy.

For this lab:

```text
TCP target:       port 8080
Check interval:   10 seconds
Timeout:          5 seconds
Failure threshold: 5
```

---

## Why use a readiness probe?

A readiness probe controls whether the Pod is eligible to receive traffic. An application can be alive but not ready, such as while loading data or waiting for a dependency.

For this lab:

```text
HTTP path:         /
HTTP port:         8080
Check interval:    15 seconds
Timeout:           60 seconds
Failure threshold: 5
```

Five consecutive failures mark the container unready. The process remains running while readiness checks continue.

---

# 🧾 Exam-ready command summary

```bash
oc project deploy-probes

oc set probe deployment/todo-ssr \
  --startup \
  --open-tcp=8080 \
  --initial-delay-seconds=10 \
  --timeout-seconds=18

oc set probe deployment/todo-ssr \
  --liveness \
  --open-tcp=8080 \
  --period-seconds=10 \
  --timeout-seconds=5 \
  --failure-threshold=5

oc set probe deployment/todo-ssr \
  --readiness \
  --get-url=http://:8080/ \
  --period-seconds=15 \
  --timeout-seconds=60 \
  --failure-threshold=5

oc rollout status deployment/todo-ssr
oc get deployment/todo-ssr -o yaml
oc get pods
```

---

# ✅ Completion checklist

Confirm each item before finishing:

- [ ] Current project is `deploy-probes`.
- [ ] `deployment/todo-ssr` exists.
- [ ] Startup probe uses TCP port `8080`.
- [ ] Startup initial delay is `10`.
- [ ] Startup timeout is `18`.
- [ ] Liveness probe uses TCP port `8080`.
- [ ] Liveness period is `10`.
- [ ] Liveness timeout is `5`.
- [ ] Liveness failure threshold is `5`.
- [ ] Readiness probe uses HTTP GET.
- [ ] Readiness path is `/`.
- [ ] Readiness port is `8080`.
- [ ] Readiness period is `15`.
- [ ] Readiness timeout is `60`.
- [ ] Readiness failure threshold is `5`.
- [ ] The latest rollout completes.
- [ ] The running Pod reports `1/1` in the `READY` column.
- [ ] Pod events do not show recurring probe failures.

---

# 📌 Final expected probe configuration

```yaml
startupProbe:
  tcpSocket:
    port: 8080
  initialDelaySeconds: 10
  timeoutSeconds: 18
  periodSeconds: 10
  successThreshold: 1
  failureThreshold: 3

livenessProbe:
  tcpSocket:
    port: 8080
  periodSeconds: 10
  timeoutSeconds: 5
  successThreshold: 1
  failureThreshold: 5

readinessProbe:
  httpGet:
    scheme: HTTP
    path: /
    port: 8080
  periodSeconds: 15
  timeoutSeconds: 60
  successThreshold: 1
  failureThreshold: 5
```

> Defaulted fields can be displayed in a different order. The values, not the order, determine whether the configuration is correct.
