# What Happens During an MCO Change in OpenShift?

## 1. What is the MCO?

**MCO** stands for **Machine Config Operator**.

The MCO manages operating-system-level configuration on OpenShift nodes, including:

* Files under `/etc` and `/var`
* Systemd services and units
* Kubelet configuration
* CRI-O configuration
* Kernel arguments and kernel type
* RHCOS operating-system updates
* SSH keys
* Container registry configuration

The MCO does not normally modify nodes by running ad hoc shell commands. Instead, it maintains a **declarative desired state** through `MachineConfig` and `MachineConfigPool` resources. ([Red Hat Documentation][1])

> **Interview answer:**
> When a MachineConfig changes, the MCO renders all applicable MachineConfigs into one desired configuration for the MachineConfigPool. It then updates the nodes gradually, normally by cordoning, draining, applying the configuration, rebooting, validating the node, and uncordoning it.

---

# 2. Important MCO Components

## 2.1 MachineConfig

A `MachineConfig` describes an operating-system configuration that should exist on a set of nodes.

Example changes include:

```text
Create /etc/example.conf
Add kernel arguments
Enable a systemd service
Update SSH keys
Change CRI-O configuration
```

A MachineConfig targets nodes through a role label:

```yaml
metadata:
  labels:
    machineconfiguration.openshift.io/role: worker
```

This means the MachineConfig contributes to the configuration of the `worker` MachineConfigPool.

---

## 2.2 MachineConfigPool

A `MachineConfigPool`, or MCP, groups nodes that receive the same machine configuration.

Common pools are:

```text
master
worker
```

You can also create custom pools such as:

```text
infra
storage
gpu
worker-cnf
```

An MCP controls:

* Which MachineConfigs apply to the pool
* Which nodes belong to the pool
* The desired rendered configuration
* The number of nodes that can be unavailable during an update
* Whether the pool is paused

A node can be managed by only one primary MachineConfigPool. ([Red Hat Documentation][1])

---

## 2.3 Machine Config Controller

The Machine Config Controller runs on the control plane.

It contains several controller functions, including:

* Selecting applicable MachineConfigs
* Merging them into a rendered configuration
* Updating the MCP desired configuration
* Selecting nodes for rollout
* Coordinating updates with the Machine Config Daemon

The controller uses node annotations to tell each node which rendered configuration it should apply. ([GitHub][2])

---

## 2.4 Machine Config Daemon

The Machine Config Daemon, or MCD, runs as a DaemonSet on every managed node.

Its responsibilities include:

* Watching for a new desired configuration
* Comparing current and desired configurations
* Detecting configuration drift
* Cordoning and draining the node
* Writing files and systemd units
* Staging RHCOS updates
* Updating kernel arguments
* Rebooting the node when required
* Validating the node after the update
* Reporting success or failure

The MCD reports three commonly discussed states:

```text
Done
Working
Degraded
```

([GitHub][3])

---

## 2.5 Machine Config Server

The Machine Config Server provides Ignition configurations, primarily when nodes are initially joining the cluster.

For normal post-installation changes, the Machine Config Controller and Machine Config Daemon perform most of the visible work. ([Red Hat Documentation][1])

---

# 3. Complete Step-by-Step MCO Change Flow

Assume the worker pool currently uses:

```text
rendered-worker-AAAA
```

You create a new MachineConfig that adds a file to all worker nodes.

## Step 1: The administrator creates or changes a configuration

The change might come directly from a `MachineConfig`:

```bash
oc apply -f 99-worker-example.yaml
```

It can also originate from a higher-level resource such as:

```text
KubeletConfig
ContainerRuntimeConfig
ImageDigestMirrorSet
MachineOSConfig
MachineConfiguration
```

Some of these controllers generate MachineConfig objects automatically.

For example, a `KubeletConfig` can result in a generated MachineConfig similar to:

```text
99-worker-kubelet-managed
```

([GitHub][2])

---

## Step 2: The Render Controller identifies the affected pool

The Render Controller examines the MachineConfig label:

```yaml
machineconfiguration.openshift.io/role: worker
```

It then identifies that the MachineConfig belongs to the worker pool.

The controller collects all MachineConfigs applicable to that pool, such as:

```text
00-worker
01-worker-container-runtime
01-worker-kubelet
99-worker-generated-registries
99-worker-ssh
99-worker-example
```

---

## Step 3: MachineConfigs are ordered and merged

The MachineConfigs are sorted lexicographically by name.

For example:

```text
00-worker
01-worker-kubelet
50-worker-company-settings
99-worker-example
```

The render controller combines them into a single rendered MachineConfig. ([GitHub][2])

This is why names such as `98-...` and `99-...` are commonly used for administrator-created configurations: they are processed after many built-in configurations.

Do not edit objects such as the following directly:

```text
rendered-worker-...
```

They are generated and managed by the MCO.

---

## Step 4: A new rendered MachineConfig is created

The MCO creates a new object similar to:

```text
rendered-worker-BBBB
```

The old state was:

```text
Current: rendered-worker-AAAA
```

The new desired state becomes:

```text
Desired: rendered-worker-BBBB
```

A rendered MachineConfig contains the combined desired configuration for that pool, not only the single change you created.

You can see rendered configurations with:

```bash
oc get machineconfig | grep rendered-worker
```

Example:

```text
rendered-worker-01f27f752eb84eba917450e43636b210
rendered-worker-f351f6947f15cd0380514f4b1c89f8f2
```

([Red Hat Documentation][1])

---

## Step 5: The MachineConfigPool enters Updating state

Check the pool:

```bash
oc get mcp worker
```

During the rollout, you might see:

```text
NAME     CONFIG                  UPDATED   UPDATING   DEGRADED
worker   rendered-worker-BBBB    False     True       False
```

Interpretation:

* `UPDATED=False`: Not all nodes have the desired configuration.
* `UPDATING=True`: At least one node is being moved to the desired configuration.
* `DEGRADED=False`: No update failure is currently blocking the pool.

The MCP also reports:

```text
MACHINECOUNT
READYMACHINECOUNT
UPDATEDMACHINECOUNT
DEGRADEDMACHINECOUNT
```

([Red Hat Documentation][1])

---

## Step 6: The Update Controller selects nodes

The MCO does not normally update all nodes in the pool simultaneously.

It respects the MCP's `maxUnavailable` value.

Check it with:

```bash
oc get mcp worker \
  -o jsonpath='{.spec.maxUnavailable}{"\n"}'
```

For example:

```text
1
```

This generally means that only one worker node should be made unavailable by this rollout at a time.

The MCO also considers node availability and update ordering. Current OpenShift documentation describes ordering by zone and then node age, while respecting the MCP's `maxUnavailable` setting. Different pools can update independently and therefore might update in parallel. ([Red Hat Documentation][1])

---

## Step 7: The desired configuration is assigned to a node

The update controller changes the node's desired configuration.

The important annotations are:

```text
machine-config-daemon.v1.openshift.com/currentConfig
machine-config-daemon.v1.openshift.com/desiredConfig
machine-config-daemon.v1.openshift.com/state
```

Before the update:

```text
currentConfig = rendered-worker-AAAA
desiredConfig = rendered-worker-AAAA
state = Done
```

When the update starts:

```text
currentConfig = rendered-worker-AAAA
desiredConfig = rendered-worker-BBBB
state = Working
```

After successful completion:

```text
currentConfig = rendered-worker-BBBB
desiredConfig = rendered-worker-BBBB
state = Done
```

([GitHub][2])

You can inspect these values with:

```bash
oc get node <node-name> -o json | jq '
  .metadata.annotations |
  {
    currentConfig:
      .["machine-config-daemon.v1.openshift.com/currentConfig"],
    desiredConfig:
      .["machine-config-daemon.v1.openshift.com/desiredConfig"],
    state:
      .["machine-config-daemon.v1.openshift.com/state"]
  }'
```

---

## Step 8: The MCD validates the current node state

Before applying the new configuration, the MCD verifies that the existing node configuration matches the current rendered MachineConfig.

It checks managed items such as:

* File content
* File permissions
* Managed systemd units
* Existing operating-system deployment

This is called **configuration drift detection**.

For example, suppose a MachineConfig owns:

```text
/etc/company/security.conf
```

An administrator manually edits that file directly on one worker.

The MCD can detect that the on-disk content does not match the MachineConfig. The node and MCP can then become `Degraded`, and the node cannot receive another update until the drift is corrected. ([Red Hat Documentation][1])

> **Interview point:**
> Do not manually modify files managed by a MachineConfig. Modify the MachineConfig instead.

---

## Step 9: The MCD calculates the difference

The MCD compares:

```text
Current rendered MachineConfig
             versus
Desired rendered MachineConfig
```

It determines what changed:

```text
File content?
Systemd unit?
SSH key?
Kernel argument?
OS image?
CRI-O registry configuration?
Kernel type?
```

It then determines the disruption action.

The result might be:

```text
Reboot
None
Drain
Reload
Restart
DaemonReload
Special
```

([GitHub][3])

---

# 4. Normal Disruptive Update Flow

For a normal change that requires a reboot, the sequence is:

```text
Cordon
  ↓
Drain
  ↓
Apply configuration
  ↓
Reboot
  ↓
Validate
  ↓
Uncordon
```

This is the most important interview sequence. ([Red Hat Documentation][1])

---

## Step 10: Cordon the node

The node becomes unschedulable.

You might see:

```bash
oc get nodes
```

```text
worker-0   Ready
worker-1   Ready,SchedulingDisabled
worker-2   Ready
```

During this state:

* Existing pods may still be running temporarily.
* The scheduler will not place new workloads on the node.
* The node has not necessarily rebooted yet.

Cordon alone does not remove existing pods.

---

## Step 11: Drain the node

The MCO asks Kubernetes to evict applicable workloads.

For ordinary application pods:

* Pods are evicted.
* Deployment, ReplicaSet, StatefulSet, or other controllers recreate or move them.
* PodDisruptionBudgets are respected.
* Static pods are not drained.
* The Machine Config Daemon does not evict itself.
* Critical workloads receive special treatment.

The MCD's drain behavior is intended to avoid removing static pods such as the etcd static pods on control-plane nodes. ([GitHub][3])

### Why can a drain fail?

Suppose an application has:

```yaml
minAvailable: 2
```

But it has only two healthy replicas.

Evicting one replica would violate the PodDisruptionBudget, so the node cannot be completely drained.

The MCO will not continue to the normal reboot stage until the drain succeeds. A terminal drain failure can block the rollout and lead to an `MCCDrainError`. ([Red Hat Documentation][1])

---

## Step 12: Apply the configuration

The MCD applies the required node-level changes.

Depending on the MachineConfig, this can include:

### Writing files

```text
/etc/chrony.conf
/etc/sysctl.d/99-company.conf
/etc/systemd/system/example.service
```

### Changing permissions

```text
0644
0600
0755
```

### Updating systemd units

The MCD writes or removes managed unit files and enables or disables services as defined.

### Updating kernel arguments

For example:

```text
intel_iommu=on
rd.multipath=default
```

### Updating the operating system

During an OpenShift version update, the rendered MachineConfig can reference a new RHCOS operating-system image.

The MCD stages the OSTree deployment through the RHCOS update mechanism and prepares the system to boot into the new deployment. ([GitHub][3])

---

## Step 13: Reboot or perform a rebootless action

### Default behavior

A general MachineConfig change normally results in:

```text
Drain → Apply → Reboot
```

### Rebootless exceptions

Some changes can be made without a reboot.

Default optimized examples include:

* SSH key updates
* Global pull-secret updates
* Automatic kubelet CA rotation
* Certain container registry changes that can use a CRI-O reload

([Red Hat Documentation][1])

### NodeDisruptionPolicy

Modern OpenShift releases support a `NodeDisruptionPolicy`.

Possible actions include:

| Action         | Result                                                  |
| -------------- | ------------------------------------------------------- |
| `Reboot`       | Drain and reboot the node                               |
| `None`         | Apply change without drain or reboot                    |
| `Drain`        | Cordon and drain                                        |
| `Reload`       | Reload a service                                        |
| `Restart`      | Restart a service                                       |
| `DaemonReload` | Run systemd manager reload                              |
| `Special`      | Internal handling, primarily for registry configuration |

`Reboot` is the default for changes not covered by a safer policy. A more disruptive change in the same rendered configuration overrides less disruptive actions. ([Red Hat Documentation][1])

---

## Step 14: Node boots and the MCD validates the result

After reboot:

1. Kubelet starts.
2. CRI-O starts.
3. The Machine Config Daemon starts.
4. The MCD checks the booted OS deployment if an OS update occurred.
5. It validates managed files and systemd units.
6. It verifies that the node matches the desired rendered configuration.
7. It sets the current configuration to the desired configuration.

The expected final annotation state is:

```text
currentConfig = rendered-worker-BBBB
desiredConfig = rendered-worker-BBBB
state = Done
```

The MCO only considers the node successfully updated when the configuration matches and the kubelet reports the node as ready. ([GitHub][2])

---

## Step 15: The node is uncordoned

The node becomes schedulable again:

```text
worker-1   Ready
```

Application pods can now be scheduled onto it.

The update controller can then select the next eligible node, provided doing so does not violate `maxUnavailable`.

---

## Step 16: The pool completes

After all nodes are updated:

```bash
oc get mcp worker
```

Expected result:

```text
NAME     CONFIG                  UPDATED   UPDATING   DEGRADED
worker   rendered-worker-BBBB    True      False      False
```

Also:

```text
MACHINECOUNT        = 3
READYMACHINECOUNT   = 3
UPDATEDMACHINECOUNT = 3
DEGRADEDMACHINECOUNT = 0
```

([Red Hat Documentation][1])

---

# 5. Practical Example

The following example creates a file on worker nodes.

This sample uses Ignition `3.5.0`, as used by OpenShift 4.20 documentation. Use an Ignition or Butane version compatible with your actual OpenShift release.

```yaml
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  name: 99-worker-mco-demo
  labels:
    machineconfiguration.openshift.io/role: worker
spec:
  config:
    ignition:
      version: 3.5.0
    storage:
      files:
        - path: /etc/mco-demo.conf
          overwrite: true
          mode: 420
          contents:
            source: data:text/plain;charset=utf-8;base64,TUNPIGRlbW8K
```

The Base64 content:

```text
TUNPIGRlbW8K
```

represents:

```text
MCO demo
```

Apply it:

```bash
oc apply -f 99-worker-mco-demo.yaml
```

## What happens internally?

Assume the old configuration is:

```text
rendered-worker-1111
```

The sequence is:

```text
1. 99-worker-mco-demo is created.

2. Render Controller selects it for the worker MCP.

3. It merges the new MachineConfig with all existing worker MachineConfigs.

4. A new rendered config is created:
   rendered-worker-2222

5. Worker MCP becomes:
   UPDATED=False
   UPDATING=True
   DEGRADED=False

6. The first worker receives:
   desiredConfig=rendered-worker-2222

7. Its MCD changes state:
   Done → Working

8. Under the default policy for an arbitrary file, the node is normally:
   cordoned → drained → updated → rebooted

9. /etc/mco-demo.conf is written.

10. The node reboots.

11. The MCD validates the file.

12. The node reports:
    currentConfig=rendered-worker-2222
    desiredConfig=rendered-worker-2222
    state=Done

13. The node is uncordoned.

14. The next worker is updated.

15. When all workers finish:
    UPDATED=True
    UPDATING=False
    DEGRADED=False
```

---

# 6. Monitoring the Change

## Watch the MCP

```bash
oc get mcp worker -w
```

This is usually the first monitoring command.

---

## Check the cluster operator

```bash
oc get clusteroperator machine-config
```

Healthy output should eventually show:

```text
AVAILABLE=True
PROGRESSING=False
DEGRADED=False
```

---

## List MachineConfigs

```bash
oc get mc
```

Or:

```bash
oc get mc | grep -E '99-worker-mco-demo|rendered-worker'
```

---

## Check nodes

```bash
oc get nodes
```

Look for:

```text
Ready,SchedulingDisabled
NotReady
Ready
```

during different stages.

---

## Check MachineConfigNode resources

On newer OpenShift releases:

```bash
oc get machineconfignodes
```

For one node:

```bash
oc describe machineconfignode/<node-name>
```

This can show detailed phases such as:

```text
UpdatePrepared
Cordoned
Drained
Rebooted
NodeDegraded
```

([Red Hat Documentation][1])

---

## Check MCD pods

```bash
oc get pods \
  -n openshift-machine-config-operator \
  -o wide
```

Find the `machine-config-daemon` pod running on the affected node.

Then:

```bash
oc logs \
  -n openshift-machine-config-operator \
  <machine-config-daemon-pod> \
  -c machine-config-daemon
```

Follow logs:

```bash
oc logs -f \
  -n openshift-machine-config-operator \
  <machine-config-daemon-pod> \
  -c machine-config-daemon
```

---

## Verify the file

```bash
oc debug node/<worker-node>
```

Inside the debug pod:

```bash
chroot /host
cat /etc/mco-demo.conf
exit
exit
```

Expected output:

```text
MCO demo
```

---

# 7. Rolling Back the Example

Delete the original MachineConfig:

```bash
oc delete mc 99-worker-mco-demo
```

Deleting it does not simply tell nodes to return to an old object.

Instead:

1. The render controller recalculates the worker configuration without that MachineConfig.
2. It creates another rendered MachineConfig.
3. The worker MCP receives that as its new desired state.
4. Nodes roll through another update.
5. The managed file is removed if it existed only because of the deleted MachineConfig.
6. Nodes might reboot again depending on the resulting configuration and disruption policy.

> **Interview answer:**
> Deleting a MachineConfig is itself another MachineConfigPool rollout.

---

# 8. What Can Cause an MCO Change to Fail?

## 8.1 Drain blocked by a PodDisruptionBudget

Symptoms:

```text
Node remains SchedulingDisabled
MCP remains Updating
MCCDrainError appears
```

Check:

```bash
oc get pdb -A
```

Then inspect application replica counts and PDB constraints.

Do not immediately delete a production PDB. Determine why no safe eviction is possible.

---

## 8.2 Configuration drift

Example:

```text
content mismatch for file "/etc/mco-demo.conf"
```

Check:

```bash
oc describe mcp worker
oc describe node/<node>
```

Correct the file so it matches the MachineConfig, or correct the MachineConfig itself.

A drifted node can remain online but cannot accept further MachineConfig updates until remediated. ([Red Hat Documentation][1])

---

## 8.3 Invalid or unsupported MachineConfig

Possible causes:

* Invalid Ignition syntax
* Unsupported Ignition section
* Invalid file URL
* Conflicting configuration
* Invalid kernel argument
* Bad systemd unit
* Incorrect file ownership or permissions
* Incompatible operating-system image

The MCD can set:

```text
state=Degraded
```

The MCP then reports a non-zero:

```text
DEGRADEDMACHINECOUNT
```

---

## 8.4 Node does not become Ready after reboot

Possible causes include:

* Kubelet failed
* CRI-O failed
* Network configuration broke
* Invalid kernel arguments
* Storage problem
* Node boot failure
* New OS deployment failed

Useful commands:

```bash
oc describe node/<node>
```

```bash
oc debug node/<node>
```

Then:

```bash
chroot /host
journalctl -b -u kubelet
journalctl -b -u crio
journalctl -b -u machine-config-daemon
```

When the node cannot join the API, console or infrastructure-level access might be required.

---

## 8.5 MachineConfigPool is paused

Check:

```bash
oc get mcp worker -o jsonpath='{.spec.paused}{"\n"}'
```

If the value is:

```text
true
```

the MCO can generate a new rendered configuration but will not roll it out to the nodes until the pool is unpaused.

Unpause:

```bash
oc patch mcp worker \
  --type=merge \
  -p '{"spec":{"paused":false}}'
```

A paused pool can accumulate pending configuration changes. ([Red Hat Documentation][1])

---

# 9. Recommended Troubleshooting Order

Use this order during an incident or interview scenario.

## 1. Check the Machine Config ClusterOperator

```bash
oc get co machine-config
```

## 2. Check all pools

```bash
oc get mcp
```

## 3. Describe the affected pool

```bash
oc describe mcp worker
```

## 4. Identify the affected node

```bash
oc get nodes
oc get machineconfignodes
```

## 5. Compare current and desired configuration

```bash
oc get node <node> -o json | jq '
  .metadata.annotations |
  {
    current:
      .["machine-config-daemon.v1.openshift.com/currentConfig"],
    desired:
      .["machine-config-daemon.v1.openshift.com/desiredConfig"],
    state:
      .["machine-config-daemon.v1.openshift.com/state"],
    reason:
      .["machine-config-daemon.v1.openshift.com/reason"]
  }'
```

## 6. Check events

```bash
oc get events -A --sort-by=.lastTimestamp
```

## 7. Check MCD logs

```bash
oc logs -n openshift-machine-config-operator \
  <mcd-pod> -c machine-config-daemon
```

## 8. Check PDBs if drain is stuck

```bash
oc get pdb -A
```

## 9. Check node services

```bash
oc debug node/<node>
chroot /host
journalctl -b -u kubelet
journalctl -b -u crio
```

## 10. Check for drift

Look for messages such as:

```text
content mismatch
unexpected on-disk state
failed to validate on-disk state
```

---

# 10. Interview Questions and Model Answers

## Question 1: What is the MCO?

**Answer:**

The Machine Config Operator manages the operating-system configuration and lifecycle of OpenShift nodes. It handles files, systemd units, kubelet and CRI-O configuration, kernel settings, SSH keys, and RHCOS operating-system updates through declarative MachineConfig resources.

---

## Question 2: What happens when a MachineConfig is created?

**Answer:**

The render controller selects all MachineConfigs applicable to the target MachineConfigPool, orders and merges them into a new rendered MachineConfig, and sets that rendered configuration as the desired state of the pool. The update controller then rolls the configuration across eligible nodes under `maxUnavailable` control.

---

## Question 3: Does the MCO reboot all nodes at once?

**Answer:**

No. It performs a controlled rolling update within each MachineConfigPool and respects `spec.maxUnavailable`. Different pools can update independently, so a master pool and worker pool might progress at the same time.

---

## Question 4: What is a rendered MachineConfig?

**Answer:**

A rendered MachineConfig is the combined desired node configuration generated from all MachineConfigs applicable to a MachineConfigPool. Nodes apply the rendered configuration, rather than independently applying each source MachineConfig.

---

## Question 5: Why does OpenShift use rendered MachineConfigs?

**Answer:**

They provide one deterministic desired state for each pool. This allows the MCO to compare current and desired configurations, coordinate rolling updates, validate nodes consistently, and report pool-level status.

---

## Question 6: What is the normal node update sequence?

**Answer:**

```text
Cordon → Drain → Apply → Reboot → Validate → Uncordon
```

Some updates can avoid the drain or reboot through built-in optimized behavior or a NodeDisruptionPolicy.

---

## Question 7: What do currentConfig and desiredConfig mean?

**Answer:**

`currentConfig` is the rendered MachineConfig currently applied to the node. `desiredConfig` is the rendered MachineConfig the node should reach.

```text
current == desired → node is up to date
current != desired and state=Working → update is in progress
current != desired and state=Degraded → update failed
```

---

## Question 8: What is the difference between an MCP and a MachineSet?

**Answer:**

A MachineSet manages the lifecycle and quantity of infrastructure machines, such as creating or deleting virtual machines. A MachineConfigPool groups nodes for operating-system configuration and update rollout. MachineSet is primarily infrastructure provisioning; MCP is node configuration management. ([GitHub][2])

---

## Question 9: Why might an MCP remain Updating?

**Answer:**

Common reasons include:

* A node drain is blocked by a PodDisruptionBudget.
* A node is not returning to `Ready`.
* The MCD is failing to apply the configuration.
* A node has configuration drift.
* `maxUnavailable` has been reached.
* The pool is paused.
* Kubelet, CRI-O, networking, storage, or boot failed after reboot.

---

## Question 10: What is configuration drift?

**Answer:**

Configuration drift occurs when a managed file or setting on the node no longer matches the current rendered MachineConfig, commonly because someone edited the node manually. The MCD detects the mismatch and marks the node and pool degraded until the mismatch is corrected.

---

## Question 11: Are all MachineConfig changes rebooting changes?

**Answer:**

No. The default for general changes is a reboot, but OpenShift supports rebootless handling for selected updates. A NodeDisruptionPolicy can also define actions such as `None`, `Drain`, `Reload`, `Restart`, or `DaemonReload`. Kernel, OS-image, and other incompatible changes still require a reboot.

---

## Question 12: What happens if a PDB prevents drain?

**Answer:**

The MCO cannot safely evict the pod, so the drain does not complete. The node cannot proceed through the normal reboot flow. The administrator should examine the PDB, application replicas, unhealthy pods, and available capacity rather than blindly forcing the drain.

---

## Question 13: What happens when you delete a MachineConfig?

**Answer:**

The MCO produces a new rendered configuration without the deleted MachineConfig and rolls that new desired state through the pool. The deletion can therefore trigger another drain and reboot cycle.

---

## Question 14: Should you edit a rendered MachineConfig?

**Answer:**

No. Rendered MachineConfigs are generated objects. Modify or delete the source MachineConfig, `KubeletConfig`, `ContainerRuntimeConfig`, or other owning resource.

---

## Question 15: What does the MCO do during an OpenShift cluster upgrade?

**Answer:**

As part of the upgrade, the desired rendered configurations can reference the new RHCOS operating-system image and updated node configuration. The MCD stages the new OS deployment, drains and reboots nodes as required, validates the booted version, and moves through the pool gradually.

---

# 11. Important Special Cases

## Control-plane nodes

When control-plane nodes update:

* They are handled through the `master` MCP.
* Static pods such as etcd are not drained like ordinary application pods.
* Control-plane availability must be preserved.
* `maxUnavailable` limits the rollout.

## Single-node OpenShift

On a Single Node OpenShift cluster, normal drain behavior is different because there is no other node to receive the workloads. Current OpenShift documentation notes that the MCO skips the drain operation for SNO. ([Red Hat Documentation][1])

## Custom MachineConfigPools

Worker MachineConfigs are generally inherited by custom worker pools, while custom role MachineConfigs can add configuration specific to that custom pool.

For example, an infra node might receive:

```text
Base worker MachineConfigs
+
Infra-specific MachineConfigs
```

The node still belongs to one primary MCP for rollout and status purposes.

---

# 12. Final Mental Model

Remember this flow:

```text
Administrator creates a change
              ↓
MachineConfig is created or generated
              ↓
Render Controller merges configurations
              ↓
New rendered-<pool>-<id> is created
              ↓
MCP desired configuration changes
              ↓
Update Controller selects a node
              ↓
MCD compares current and desired state
              ↓
Cordon and drain, when required
              ↓
Apply files, units, OS or kernel changes
              ↓
Reboot or perform rebootless action
              ↓
Validate the node
              ↓
currentConfig = desiredConfig
              ↓
State becomes Done
              ↓
Uncordon
              ↓
Repeat for remaining nodes
              ↓
MCP: UPDATED=True, UPDATING=False, DEGRADED=False
```

The strongest interview response is:

> The MCO converts multiple node-level configurations into a single rendered desired state for each MachineConfigPool. It then safely reconciles every node to that state through a controlled rolling process, using the Machine Config Daemon for cordon, drain, apply, reboot or service action, validation, and uncordon.

[1]: https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html-single/machine_configuration/index "Machine configuration | OpenShift Container Platform | 4.20 | Red Hat Documentation"
[2]: https://github.com/openshift/machine-config-operator/blob/master/docs/MachineConfigController.md "machine-config-operator/docs/MachineConfigController.md at main · openshift/machine-config-operator · GitHub"
[3]: https://github.com/openshift/machine-config-operator/blob/main/docs/MachineConfigDaemon.md "machine-config-operator/docs/MachineConfigDaemon.md at main · openshift/machine-config-operator · GitHub"
