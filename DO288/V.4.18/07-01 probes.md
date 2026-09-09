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


# OpenShift Practice Question Bank: Startup, Liveness, and Readiness Probes

> **Audience:** OpenShift learners preparing for hands-on administration and application-management exercises  
> **Format:** Eleven independent, original practice questions with solutions, explanations, and validation commands  
> **Workload type:** Kubernetes `Deployment`

---

## 🎯 Learning objectives

After completing these exercises, a student should be able to:

- Configure TCP, HTTP, and command-based probes.
- Select the correct probe for startup protection, container recovery, or traffic control.
- Configure probe timing and threshold values.
- Calculate an application's approximate startup-protection window.
- Identify the operational difference between liveness and readiness failures.
- Diagnose unhealthy Pods by checking status, restart counts, events, and Service endpoints.
- Verify probe configuration without depending only on the web console.



# 📋 Student questions

Attempt this section before reading the answer key. Humanity has already automated enough things without automating the learning part too.

---

## Question 1: Configure a TCP startup probe

Configure a startup probe on `deployment/web-gateway` with these requirements:

- Perform a TCP socket check on port `8080`.
- Wait `5` seconds before the first startup check.
- Perform a check every `6` seconds.
- Allow each check to run for at most `2` seconds.
- Restart the container after `15` consecutive startup failures.

After configuring the probe, verify the Deployment and wait for the rollout to finish.

---

## Question 2: Configure an exec startup probe and calculate its budget

Configure a startup probe that runs this command inside the container:

```bash
/bin/sh -c 'test -r /proc/1/status'
```

Use these settings:

- Perform the check every `4` seconds.
- Allow each command to run for at most `3` seconds.
- Allow `30` consecutive failures.
- Do not configure an initial delay.

Answer this additional question:

> Approximately how much startup time is provided by `failureThreshold × periodSeconds`?

---

## Question 3: Diagnose a startup probe that uses the wrong port

A colleague configured the following startup probe:

```bash
oc set probe deployment/web-gateway \
  --startup \
  --open-tcp=9090 \
  --period-seconds=5 \
  --timeout-seconds=2 \
  --failure-threshold=3
```

The application actually listens on port `8080`.

Complete these tasks:

1. Observe the Pod state and events.
2. Identify why the startup probe fails.
3. Correct the startup probe without deleting the Deployment.
4. Confirm that the new Pod becomes ready.

> **Practice environment only:** This question intentionally causes probe failures.

---

## Question 4: Configure a TCP liveness probe

Configure a liveness probe on `deployment/web-gateway` with these requirements:

- Perform a TCP socket check on port `8080`.
- Wait `20` seconds before beginning liveness checks.
- Perform a check every `12` seconds.
- Allow each check to run for at most `4` seconds.
- Restart the container after `4` consecutive failures.

Verify all liveness-probe fields after the rollout.

---

## Question 5: Configure an HTTP liveness probe

Configure a liveness probe with these requirements:

- Send an HTTP request to `/` on port `8080`.
- Wait `10` seconds before beginning the checks.
- Perform a check every `20` seconds.
- Allow each request to run for at most `3` seconds.
- Restart the container after `3` consecutive failures.

After the rollout, verify the HTTP path, port, scheme, and timing values.

---

## Question 6: Compare a liveness failure with container restarts

Configure an intentionally incorrect HTTP liveness probe:

- Request `/page-that-does-not-exist` on port `8080`.
- Initial delay: `3` seconds
- Period: `5` seconds
- Timeout: `2` seconds
- Failure threshold: `2`

Complete these tasks:

1. Observe the container restart count.
2. Review the Pod events for liveness failures.
3. Correct the path to `/`.
4. Confirm that the restart count stops increasing.

> **Practice environment only:** Do not run this failure simulation in a graded or shared environment unless instructed.

---

## Question 7: Configure an exec readiness probe with recovery protection

Configure a readiness probe that runs this command inside the container:

```bash
/bin/sh -c 'test -s /etc/hosts'
```

Use these settings:

- Wait `3` seconds before the first readiness check.
- Perform a check every `10` seconds.
- Allow each command to run for at most `2` seconds.
- Mark the container NotReady after `4` consecutive failures.
- After a failure, require `2` consecutive successful checks before marking it ready again.

Before adding the probe, test the command manually. Then verify the exec command and `successThreshold` in the Deployment.

---

## Question 8: Use readiness to control Service endpoints

Configure a TCP readiness probe with these requirements:

- Check port `8080`.
- Perform a check every `7` seconds.
- Use a timeout of `2` seconds.
- Mark the container NotReady after `3` consecutive failures.

Then:

1. Scale `deployment/web-gateway` to `3` replicas.
2. Confirm that all three Pods become ready.
3. Inspect the EndpointSlice or Endpoints object used by `service/web-gateway`.
4. Confirm that ready Pods are represented as Service backends.

---

## Question 9: Prove that readiness failure does not restart a container

Configure an intentionally incorrect TCP readiness probe on port `9090`:

- Initial delay: `2` seconds
- Period: `5` seconds
- Timeout: `2` seconds
- Failure threshold: `2`

Complete these tasks:

1. Confirm that the Pod remains in the `Running` phase but is not ready.
2. Confirm that the container restart count remains unchanged.
3. Check whether the Pod is available through the Service endpoints.
4. Change the readiness port to `8080` and confirm recovery.

> **Practice environment only:** This question intentionally makes the Pod unavailable to normal Service traffic.

---

## Question 10: Configure all three probes together

Configure all three probes on `deployment/web-gateway`.

### Startup probe

- HTTP request to `/` on port `8080`
- Initial delay: `8` seconds
- Period: `5` seconds
- Timeout: `2` seconds
- Failure threshold: `18`

### Liveness probe

- TCP socket check on port `8080`
- Period: `14` seconds
- Timeout: `4` seconds
- Failure threshold: `3`

### Readiness probe

- HTTP request to `/` on port `8080`
- Period: `9` seconds
- Timeout: `3` seconds
- Failure threshold: `4`
- Success threshold: `2`

After configuring the probes:

1. Wait for the rollout.
2. Display all three probes from the Deployment.
3. Confirm that the Pod is ready.
4. Explain the order in which the probes become operational.

---

## Question 11: Choose the correct probe

For each situation, identify whether the main solution is a **startup**, **liveness**, or **readiness** probe.

1. A Java application can require four minutes to initialize and must not be restarted by health checks during initialization.
2. A web process is running but can occasionally deadlock and stop responding permanently.
3. An application must temporarily stop receiving traffic while refreshing an in-memory cache, but its container should not be restarted.
4. A Pod must be removed from Service load balancing when its dependency is unavailable.
5. A container that never completes startup should eventually be restarted.

Explain each answer in one or two sentences.

---

# ✅ Solutions and explanations

---

## Solution 1: TCP startup probe

### Command

```bash
oc set probe deployment/web-gateway \
  --startup \
  --open-tcp=8080 \
  --initial-delay-seconds=5 \
  --period-seconds=6 \
  --timeout-seconds=2 \
  --failure-threshold=15
```

Wait for the rollout:

```bash
oc rollout status deployment/web-gateway
```

### Verification

```bash
oc get deployment/web-gateway -o json \
  | jq '.spec.template.spec.containers[0].startupProbe'
```

Expected relevant structure:

```json
{
  "tcpSocket": {
    "port": 8080
  },
  "initialDelaySeconds": 5,
  "timeoutSeconds": 2,
  "periodSeconds": 6,
  "failureThreshold": 15,
  "successThreshold": 1
}
```

### Explanation

`--open-tcp=8080` asks the kubelet to open a TCP connection to port `8080` on the Pod IP. A successful connection indicates that the application has reached the minimum startup state represented by that port.

The startup probe runs before liveness and readiness probes are allowed to operate. If it fails `15` times consecutively, the kubelet treats startup as failed and restarts the container according to the Pod restart policy.

---

## Solution 2: Exec startup probe and startup budget

### 1. Test the command manually

Get a running Pod:

```bash
POD=$(oc get pods \
  -l app=web-gateway \
  --field-selector=status.phase=Running \
  --sort-by=.metadata.creationTimestamp \
  -o name | tail -1)
```

Run the command and check its exit status:

```bash
oc exec "$POD" -- /bin/sh -c 'test -r /proc/1/status'
echo $?
```

Expected exit status:

```text
0
```

### 2. Configure the startup probe

```bash
oc set probe deployment/web-gateway \
  --startup \
  --period-seconds=4 \
  --timeout-seconds=3 \
  --failure-threshold=30 \
  -- /bin/sh -c 'test -r /proc/1/status'
```

Wait for the rollout:

```bash
oc rollout status deployment/web-gateway
```

### 3. Verify the exec action

```bash
oc get deployment/web-gateway \
  -o jsonpath='{.spec.template.spec.containers[0].startupProbe.exec.command}{"\n"}'
```

Expected output resembles:

```text
[/bin/sh -c test -r /proc/1/status]
```

Expected YAML structure:

```yaml
startupProbe:
  exec:
    command:
      - /bin/sh
      - -c
      - test -r /proc/1/status
  periodSeconds: 4
  timeoutSeconds: 3
  failureThreshold: 30
  successThreshold: 1
```

### Startup-budget calculation

```text
failureThreshold × periodSeconds
30 × 4 seconds = 120 seconds
```

The configured retry budget is therefore approximately **120 seconds after probing begins**. Exact wall-clock behavior can also be affected by individual probe execution time and kubelet scheduling, so this multiplication is best treated as the intended probe budget rather than a laboratory-grade stopwatch reading. Computers, like humans, become strangely interpretive around timing boundaries.

### Explanation

An exec probe succeeds when its command exits with status `0`; a nonzero exit status is a failure. In this exercise, the probe checks whether the process-status file for PID 1 is readable.

This command is deliberately simple so students can focus on startup-probe structure. A production startup command should test an application-specific condition that becomes true only after initialization has completed.

---

## Solution 3: Repair the startup probe

### 1. Observe the Pod

```bash
oc get pods -w
```

In another terminal, identify the newest Pod:

```bash
POD=$(oc get pods \
  -l app=web-gateway \
  --sort-by=.metadata.creationTimestamp \
  -o name | tail -1)

echo "$POD"
```

Review its events:

```bash
oc describe "$POD"
```

You should see startup-probe failures mentioning port `9090`, connection refusal, or an inability to connect.

### 2. Confirm the configured port

```bash
oc get deployment/web-gateway \
  -o jsonpath='{.spec.template.spec.containers[0].startupProbe.tcpSocket.port}{"\n"}'
```

Incorrect value:

```text
9090
```

### 3. Correct the probe

```bash
oc set probe deployment/web-gateway \
  --startup \
  --open-tcp=8080 \
  --period-seconds=5 \
  --timeout-seconds=2 \
  --failure-threshold=3
```

### 4. Verify recovery

```bash
oc rollout status deployment/web-gateway
oc get pods
```

Expected result:

```text
READY   STATUS
1/1     Running
```

### Explanation

The application listens on `8080`, but the startup probe attempted to connect to `9090`. Because startup never succeeded, the kubelet kept treating the container as unsuccessfully started and eventually restarted it after the failure threshold.

Correcting the Pod template creates a new ReplicaSet and replacement Pod. Deleting the Deployment is unnecessary and would be rather dramatic for a one-digit port mistake.

---

## Solution 4: TCP liveness probe

### Command

```bash
oc set probe deployment/web-gateway \
  --liveness \
  --open-tcp=8080 \
  --initial-delay-seconds=20 \
  --period-seconds=12 \
  --timeout-seconds=4 \
  --failure-threshold=4
```

Wait for completion:

```bash
oc rollout status deployment/web-gateway
```

### Verification

```bash
oc get deployment/web-gateway -o json \
  | jq '.spec.template.spec.containers[0].livenessProbe'
```

Or inspect individual fields:

```bash
oc get deployment/web-gateway \
  -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.tcpSocket.port}{"\n"}{.spec.template.spec.containers[0].livenessProbe.initialDelaySeconds}{"\n"}{.spec.template.spec.containers[0].livenessProbe.periodSeconds}{"\n"}{.spec.template.spec.containers[0].livenessProbe.timeoutSeconds}{"\n"}{.spec.template.spec.containers[0].livenessProbe.failureThreshold}{"\n"}'
```

Expected values:

```text
8080
20
12
4
4
```

### Explanation

A liveness probe answers whether the already-running application is still healthy enough to continue. After four consecutive TCP failures, the kubelet restarts the container.

A liveness probe should not be used merely because a temporary dependency is unavailable. Restarting a healthy application every time a database blinks is one of those operational ideas that sounds energetic while accomplishing very little.

---

## Solution 5: HTTP liveness probe

### Command

```bash
oc set probe deployment/web-gateway \
  --liveness \
  --get-url=http://:8080/ \
  --initial-delay-seconds=10 \
  --period-seconds=20 \
  --timeout-seconds=3 \
  --failure-threshold=3
```

Wait for the rollout:

```bash
oc rollout status deployment/web-gateway
```

### Verification

```bash
oc get deployment/web-gateway -o json \
  | jq '.spec.template.spec.containers[0].livenessProbe'
```

Without `jq`, inspect the important fields directly:

```bash
oc get deployment/web-gateway \
  -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.path}{"\n"}{.spec.template.spec.containers[0].livenessProbe.httpGet.port}{"\n"}{.spec.template.spec.containers[0].livenessProbe.httpGet.scheme}{"\n"}{.spec.template.spec.containers[0].livenessProbe.initialDelaySeconds}{"\n"}{.spec.template.spec.containers[0].livenessProbe.periodSeconds}{"\n"}{.spec.template.spec.containers[0].livenessProbe.timeoutSeconds}{"\n"}{.spec.template.spec.containers[0].livenessProbe.failureThreshold}{"\n"}'
```

Expected values:

```text
/
8080
HTTP
10
20
3
3
```

Expected YAML structure:

```yaml
livenessProbe:
  httpGet:
    path: /
    port: 8080
    scheme: HTTP
  initialDelaySeconds: 10
  periodSeconds: 20
  timeoutSeconds: 3
  failureThreshold: 3
  successThreshold: 1
```

### Explanation

The empty host in `http://:8080/` tells `oc set probe` to check the Pod IP. The kubelet sends an HTTP request to `/` on port `8080`. HTTP response codes from `200` through `399` count as success.

After three consecutive failures, the kubelet restarts the container. The initial delay gives the application ten seconds before liveness monitoring begins when no startup probe is protecting the initialization phase.

---

## Solution 6: Observe and repair a liveness failure

### 1. Configure the intentionally incorrect probe

```bash
oc set probe deployment/web-gateway \
  --liveness \
  --get-url=http://:8080/page-that-does-not-exist \
  --initial-delay-seconds=3 \
  --period-seconds=5 \
  --timeout-seconds=2 \
  --failure-threshold=2
```

Wait for the new Pod to appear:

```bash
oc get pods -w
```

### 2. Observe restart count

```bash
POD=$(oc get pods \
  -l app=web-gateway \
  --sort-by=.metadata.creationTimestamp \
  -o name | tail -1)

oc get "$POD" \
  -o custom-columns=NAME:.metadata.name,READY:.status.containerStatuses[0].ready,RESTARTS:.status.containerStatuses[0].restartCount
```

Repeat the preceding command after several probe periods. The restart count should increase if the nonexistent path returns a failing HTTP status. Most nginx configurations return `404` for this path. If this particular training image returns a successful `2xx` or `3xx` response for unknown paths, repeat the exercise with `--get-url=http://:9090/` to produce a definite connection failure.

### 3. Review events

```bash
oc describe "$POD" | sed -n '/Events:/,$p'
```

Look for messages similar to:

```text
Liveness probe failed: HTTP probe failed with statuscode: 404
Killing container ... failed liveness probe, will be restarted
```

### 4. Correct the path

```bash
oc set probe deployment/web-gateway \
  --liveness \
  --get-url=http://:8080/ \
  --initial-delay-seconds=3 \
  --period-seconds=5 \
  --timeout-seconds=2 \
  --failure-threshold=2
```

Wait for the rollout:

```bash
oc rollout status deployment/web-gateway
```

### 5. Confirm stability

```bash
POD=$(oc get pods \
  -l app=web-gateway \
  --field-selector=status.phase=Running \
  --sort-by=.metadata.creationTimestamp \
  -o name | tail -1)

oc get "$POD" \
  -o custom-columns=NAME:.metadata.name,READY:.status.containerStatuses[0].ready,RESTARTS:.status.containerStatuses[0].restartCount
```

### Explanation

A failed liveness probe causes the kubelet to restart the container. It does not normally replace the Pod object immediately; therefore, the same Pod name can remain while its container restart count rises.

Correcting the Deployment creates a new rollout whose Pods use the healthy `/` endpoint.

---

## Solution 7: Exec readiness probe with `successThreshold`

### 1. Test the command manually

Get a running Pod and run the check:

```bash
POD=$(oc get pods \
  -l app=web-gateway \
  --field-selector=status.phase=Running \
  --sort-by=.metadata.creationTimestamp \
  -o name | tail -1)

oc exec "$POD" -- /bin/sh -c 'test -s /etc/hosts'
echo $?
```

Expected exit status:

```text
0
```

### 2. Configure the readiness probe

```bash
oc set probe deployment/web-gateway \
  --readiness \
  --initial-delay-seconds=3 \
  --period-seconds=10 \
  --timeout-seconds=2 \
  --failure-threshold=4 \
  --success-threshold=2 \
  -- /bin/sh -c 'test -s /etc/hosts'
```

Wait for the rollout:

```bash
oc rollout status deployment/web-gateway
```

### 3. Verify the command and threshold

```bash
oc get deployment/web-gateway \
  -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.exec.command}{"\n"}{.spec.template.spec.containers[0].readinessProbe.successThreshold}{"\n"}'
```

Expected output resembles:

```text
[/bin/sh -c test -s /etc/hosts]
2
```

Expected YAML structure:

```yaml
readinessProbe:
  exec:
    command:
      - /bin/sh
      - -c
      - test -s /etc/hosts
  initialDelaySeconds: 3
  periodSeconds: 10
  timeoutSeconds: 2
  failureThreshold: 4
  successThreshold: 2
```

### Explanation

The command succeeds when `/etc/hosts` exists and contains data. This is a portable syntax exercise, not a recommended production readiness condition; a real application should report whether it can actually serve its intended traffic.

`failureThreshold: 4` allows four consecutive failures before the container is treated as not ready. `successThreshold: 2` then requires two consecutive successes before readiness is restored, reducing rapid ready/not-ready oscillation.

For liveness and startup probes, Kubernetes requires `successThreshold` to remain `1`. A value greater than `1` is meaningful only for readiness probes.

---

## Solution 8: TCP readiness and Service endpoints

### 1. Configure readiness

```bash
oc set probe deployment/web-gateway \
  --readiness \
  --open-tcp=8080 \
  --period-seconds=7 \
  --timeout-seconds=2 \
  --failure-threshold=3
```

Wait for the rollout:

```bash
oc rollout status deployment/web-gateway
```

### 2. Scale to three replicas

```bash
oc scale deployment/web-gateway --replicas=3
oc rollout status deployment/web-gateway
```

### 3. Confirm readiness

```bash
oc get pods -l app=web-gateway
```

Expected relevant result:

```text
READY   STATUS
1/1     Running
1/1     Running
1/1     Running
```

### 4. Inspect Service backends

Preferred modern resource:

```bash
oc get endpointslice \
  -l kubernetes.io/service-name=web-gateway \
  -o wide
```

You can also inspect the compatibility Endpoints object:

```bash
oc get endpoints/web-gateway -o wide
```

### Explanation

A successful readiness probe sets the container's ready condition to true. Ready Pods selected by the Service can then appear as usable backends in EndpointSlice data.

If one Pod becomes unready, the workload can remain running while that Pod is excluded from normal Service traffic. This is why readiness is the traffic gate, not the container restart lever.

---

## Solution 9: Readiness failure without a restart

### 1. Configure the incorrect readiness port

```bash
oc set probe deployment/web-gateway \
  --readiness \
  --open-tcp=9090 \
  --initial-delay-seconds=2 \
  --period-seconds=5 \
  --timeout-seconds=2 \
  --failure-threshold=2
```

Observe the rollout for a limited period:

```bash
oc rollout status deployment/web-gateway --timeout=30s || true
```

A timeout is expected because the new Pod cannot become ready. Inspect the Pod directly rather than staring at the terminal until mutual resentment develops.

### 2. Check phase, readiness, and restarts

```bash
POD=$(oc get pods \
  -l app=web-gateway \
  --sort-by=.metadata.creationTimestamp \
  -o name | tail -1)

oc get "$POD" \
  -o custom-columns=NAME:.metadata.name,PHASE:.status.phase,READY:.status.containerStatuses[0].ready,RESTARTS:.status.containerStatuses[0].restartCount
```

Expected behavior:

```text
PHASE     READY   RESTARTS
Running   false   0
```

### 3. Review readiness events

```bash
oc describe "$POD" | sed -n '/Events:/,$p'
```

Look for readiness-probe connection failures on port `9090`.

### 4. Inspect Service endpoints

```bash
oc get endpointslice \
  -l kubernetes.io/service-name=web-gateway \
  -o yaml
```

The unready Pod should not be treated as a normal ready Service backend.

### 5. Correct the port

```bash
oc set probe deployment/web-gateway \
  --readiness \
  --open-tcp=8080 \
  --initial-delay-seconds=2 \
  --period-seconds=5 \
  --timeout-seconds=2 \
  --failure-threshold=2
```

Wait for recovery:

```bash
oc rollout status deployment/web-gateway
oc get pods -l app=web-gateway
```

### Explanation

Readiness failure changes traffic eligibility. It does not instruct the kubelet to restart the container. Therefore, the Pod can remain `Running` while showing `0/1` in the READY column and a restart count of zero.

This is the most important operational distinction between readiness and liveness:

```text
Readiness failure → stop traffic
Liveness failure  → restart container
```

---

## Solution 10: Configure all three probes

Reset first so older probes and replica changes do not interfere:

```bash
oc set probe deployment/web-gateway \
  --remove \
  --startup \
  --liveness \
  --readiness

oc scale deployment/web-gateway --replicas=1
```

### 1. Configure startup

```bash
oc set probe deployment/web-gateway \
  --startup \
  --get-url=http://:8080/ \
  --initial-delay-seconds=8 \
  --period-seconds=5 \
  --timeout-seconds=2 \
  --failure-threshold=18
```

### 2. Configure liveness

```bash
oc set probe deployment/web-gateway \
  --liveness \
  --open-tcp=8080 \
  --period-seconds=14 \
  --timeout-seconds=4 \
  --failure-threshold=3
```

### 3. Configure readiness

```bash
oc set probe deployment/web-gateway \
  --readiness \
  --get-url=http://:8080/ \
  --period-seconds=9 \
  --timeout-seconds=3 \
  --failure-threshold=4 \
  --success-threshold=2
```

### 4. Wait for the rollout

```bash
oc rollout status deployment/web-gateway
```

### 5. Display all probes

```bash
oc get deployment/web-gateway -o json \
  | jq '.spec.template.spec.containers[0] | {
      startupProbe,
      livenessProbe,
      readinessProbe
    }'
```

Without `jq`, display the Deployment YAML and inspect the container section:

```bash
oc get deployment/web-gateway -o yaml
```

### 6. Confirm Pod status

```bash
oc get pods -l app=web-gateway
```

### Expected YAML structure

```yaml
startupProbe:
  httpGet:
    path: /
    port: 8080
    scheme: HTTP
  initialDelaySeconds: 8
  periodSeconds: 5
  timeoutSeconds: 2
  failureThreshold: 18
  successThreshold: 1

livenessProbe:
  tcpSocket:
    port: 8080
  periodSeconds: 14
  timeoutSeconds: 4
  failureThreshold: 3
  successThreshold: 1

readinessProbe:
  httpGet:
    path: /
    port: 8080
    scheme: HTTP
  periodSeconds: 9
  timeoutSeconds: 3
  failureThreshold: 4
  successThreshold: 2
```

### Probe activation order

1. The startup probe begins after its eight-second initial delay.
2. Until startup succeeds, liveness and readiness checks are suppressed.
3. After startup succeeds, the startup probe has completed its purpose.
4. Liveness begins monitoring whether the application should be restarted.
5. Readiness begins controlling whether the Pod should receive Service traffic.

### Explanation

Each probe solves a separate problem:

- Startup protects a slow initialization phase.
- Liveness recovers from a permanently unhealthy running process.
- Readiness protects users and upstream services from traffic being sent to an unavailable instance.

Using all three does not mean checking the same thing three times with different labels. Their endpoints and thresholds should represent the distinct states the application can actually report.

---

## Solution 11: Select the correct probe

### 1. Four-minute Java initialization

**Answer: Startup probe**

A startup probe gives the application time to initialize and prevents liveness and readiness checks from interfering until startup succeeds.

### 2. Permanently deadlocked web process

**Answer: Liveness probe**

A liveness failure causes the kubelet to restart the container, which can recover an application that is alive as a process but unable to make progress.

### 3. Temporary cache refresh

**Answer: Readiness probe**

The container does not need to be restarted. It only needs to stop receiving traffic until the cache is usable again.

### 4. Dependency outage should remove a Pod from load balancing

**Answer: Readiness probe**

The Pod should become NotReady so that normal Service traffic is not sent to it. Whether dependency health belongs in readiness depends on the application's actual ability to serve requests, but liveness should not generally restart an otherwise healthy process for a temporary external outage.

### 5. Application never completes startup

**Answer: Startup probe**

After the startup probe reaches its failure threshold, the kubelet restarts the container according to its restart policy.

---

# 🔍 General verification commands

## Display every configured probe

```bash
oc get deployment/web-gateway -o json \
  | jq '.spec.template.spec.containers[] | {
      name,
      startupProbe,
      livenessProbe,
      readinessProbe
    }'
```

## Use built-in API documentation

```bash
oc explain deployment.spec.template.spec.containers.startupProbe
oc explain deployment.spec.template.spec.containers.livenessProbe
oc explain deployment.spec.template.spec.containers.readinessProbe
```

Inspect probe fields recursively:

```bash
oc explain deployment.spec.template.spec.containers.readinessProbe --recursive
```

## Check Pods, readiness, and restart counts

```bash
oc get pods \
  -l app=web-gateway \
  -o custom-columns=NAME:.metadata.name,PHASE:.status.phase,READY:.status.containerStatuses[0].ready,RESTARTS:.status.containerStatuses[0].restartCount
```

## Review recent events

```bash
oc get events --sort-by=.lastTimestamp | tail -20
```

## Follow rollout status

```bash
oc rollout status deployment/web-gateway
```

---

# ⚠️ Common mistakes

## 1. Using liveness for temporary dependency problems

A temporary database or API outage often calls for readiness behavior, not repeated container restarts.

## 2. Using an endpoint that does too much work

Health endpoints should be lightweight. A probe that performs expensive database reports every few seconds can become its own denial-of-service hobby project.

## 3. Making liveness too aggressive

Very short periods and low failure thresholds can restart a healthy application during a brief CPU pause or network delay.

## 4. Forgetting that probe changes trigger a rollout

Probes live in the Pod template. Changing that template creates replacement Pods through the Deployment rollout process.

## 5. Assuming `Running` means ready

A Pod can be in the `Running` phase while its readiness condition is false. Check the READY column and container status, not only the phase.

## 6. Setting `successThreshold` above `1` for startup or liveness

Kubernetes requires `successThreshold: 1` for startup and liveness probes. Readiness probes can use a higher value.

---

# 🧾 Quick command patterns

## TCP probe

```bash
oc set probe deployment/NAME \
  --startup|--liveness|--readiness \
  --open-tcp=PORT
```

## HTTP probe

```bash
oc set probe deployment/NAME \
  --startup|--liveness|--readiness \
  --get-url=http://:PORT/PATH
```

## Command probe

```bash
oc set probe deployment/NAME \
  --startup|--liveness|--readiness \
  -- COMMAND ARGUMENTS
```

## Remove a probe

```bash
oc set probe deployment/NAME --remove --startup
oc set probe deployment/NAME --remove --liveness
oc set probe deployment/NAME --remove --readiness
```

---

# 🧹 Cleanup

Delete the practice project after completing the exercises:

```bash
oc delete project probe-practice
```

---

# 📚 Official references

- Kubernetes documentation: **Configure Liveness, Readiness and Startup Probes**  
  <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/>

- Kubernetes concepts: **Liveness, Readiness, and Startup Probes**  
  <https://kubernetes.io/docs/concepts/workloads/pods/probes/>

- OKD CLI reference: **`oc set probe`**  
  <https://docs.okd.io/4.18/cli_reference/openshift_cli/developer-cli-commands.html>

- OKD application health documentation  
  <https://docs.okd.io/latest/applications/application-health.html>
