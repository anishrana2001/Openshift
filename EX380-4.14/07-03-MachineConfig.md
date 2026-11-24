# **OpenShift MachineConfig (MC) and MachineConfigPool (MCP) – Complete Instructor Guide**

In this practical lesson, we'll understand **MachineConfig (MC)** and **MachineConfigPool (MCP)** from an OpenShift administrator's perspective and then build a working example using your `61-datacenter-swissre.yaml` requirement.

The objective is to configure a specific group of OpenShift worker nodes with a file called `/etc/datacenter-swissre`, populate it with content from your GitHub README, and ensure that the configuration is applied only to nodes assigned the `datacenter` role.

By the end, you should understand:

1. What MachineConfig and MachineConfigPool are.
2. Why OpenShift provides these resources.
3. Where administrators use them in real production environments.
4. How MC and MCP work together.
5. How to create and apply your YAML configuration.
6. How to validate, troubleshoot, and roll back the configuration.

## **1. What is MachineConfig (MC)?**

A **MachineConfig (MC)** is an OpenShift custom resource that defines operating-system-level configuration for cluster nodes.

In simple terms:

> MachineConfig tells OpenShift how the underlying operating system of a node should be configured.

OpenShift uses the Machine Config Operator (MCO) to manage these configurations.

An MC can configure things such as:

- Files and directories on the host OS.
- File permissions and ownership.
- Systemd services and service configurations.
- Kernel arguments.
- Kernel modules.
- SSH authorized keys.
- OS-level configuration files.
- Ignition-based provisioning settings.

For example, suppose your organization wants every node in a particular data center to have a file:

```
/etc/datacenter-swissre
```

Instead of logging into each node and creating the file manually, an OpenShift administrator can create a MachineConfig.

The MCO takes responsibility for applying the configuration.

### **How does it work?**

**MachineConfig YAML**

Defines the desired OS configuration

**Machine Config Operator (MCO)**

Processes and manages the configuration

**Machine Config Daemon (MCD)**

Applies and verifies node-level changes

**OpenShift Node**

Desired configuration is applied to the host

## **2. What is MachineConfigPool (MCP)?**

A **MachineConfigPool (MCP)** is a resource that groups nodes and manages the MachineConfigs that should apply to those nodes.

In simple terms:

> MachineConfig defines WHAT configuration should be applied. MachineConfigPool determines WHICH group of nodes receives that configuration and manages its rollout.

For example, consider an OpenShift cluster with these nodes:

| Node     | Role       |
| -------- | ---------- |
| master-0 | master     |
| master-1 | master     |
| master-2 | master     |
| worker-0 | worker     |
| worker-1 | worker     |
| worker-2 | datacenter |
| worker-3 | datacenter |

You can create a custom MCP named `datacenter` that selects nodes with this label:

```
machineconfiguration.openshift.io/role: datacenter
```

Then you can create a MachineConfig that targets the `datacenter` role.

The MCO applies that configuration to the nodes belonging to the corresponding pool.

## **3. MC vs MCP – Understand the difference**

| Feature             | MachineConfig (MC)               | MachineConfigPool (MCP)                   |
| ------------------- | -------------------------------- | ----------------------------------------- |
| Purpose             | Defines node OS configuration    | Groups nodes for configuration management |
| Main responsibility | What to configure                | Which nodes receive it                    |
| Example             | Create `/etc/datacenter-swissre` | Manage datacenter nodes                   |
| Resource            | `MachineConfig`                  | `MachineConfigPool`                       |
| Managed by          | MCO                              | MCO                                       |
| Typical changes     | Files, services, kernel settings | Node selection and rollout status         |

### **Why do we need MC and MCP?**

Imagine an enterprise OpenShift cluster with 100 nodes.

- 20 nodes run application workloads.
- 10 nodes run infrastructure workloads.
- 30 nodes run database workloads.
- 40 nodes are dedicated to a particular data center workload.

Your organization might have different OS-level requirements for each group.

Without MC and MCP, administrators might manually SSH into every node and configure files, services, and settings.

This creates problems:

- Configuration inconsistency.
- Human errors.
- Difficult maintenance.
- No centralized configuration management.
- New nodes may not receive the same configuration.
- Difficult auditing and troubleshooting.

With MC and MCP, administrators define the desired configuration once and let OpenShift manage its distribution.

## **4. Where does an OpenShift administrator use MC and MCP?**

Here are some practical production scenarios.

| Scenario               | MachineConfig use                          | MCP use                           |
| ---------------------- | ------------------------------------------ | --------------------------------- |
| Infrastructure nodes   | Configure system files                     | Separate infra nodes              |
| Datacenter nodes       | Create data-center-specific files          | Separate datacenter nodes         |
| Security hardening     | Configure SSH and OS settings              | Apply to selected worker groups   |
| Kernel tuning          | Configure kernel arguments                 | Apply to specialized nodes        |
| Storage nodes          | Configure host-level services              | Isolate storage nodes             |
| Network workloads      | Configure host networking-related settings | Separate specialized worker nodes |
| Logging infrastructure | Configure OS-level requirements            | Dedicated logging node pool       |

### **What, when, and why?**

**What:** An administrator wants to change an operating-system setting on OpenShift nodes.

**When:** When deploying new nodes, hardening the operating system, configuring specialized workloads, or maintaining consistent host configurations.

**Why:** To automate configuration, maintain consistency, reduce manual administration, and make node configuration repeatable.

One important production consideration: MachineConfig changes can trigger node updates, draining, and reboots. Therefore, administrators should plan changes around workload availability and maintenance windows.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://docs.redhat.com\&sz=32)

Red Hat Documentation+1



# **5. Practical scenario – Swiss Re Datacenter configuration**

Let's implement your requirement.

## **Expected architecture**

**OpenShift Cluster**

Machine Config Operator

**Worker MCP**

Normal worker nodes

**Datacenter MCP**

Our target

Nodes with datacenter role

**61-datacenter-swissre MachineConfig**

Creates and manages the required host file

`/etc/datacenter-swissre`

Permissions: 0764 (rwxrw-r--)

### **Important: Understand the two labels**

There are two different labels involved.

**1. Node role label**

This label identifies which nodes belong to the custom MCP:

```
node-role.kubernetes.io/datacenter: ""
```

**2. MachineConfig role label**

This label identifies which MachineConfigs should be selected by the datacenter MCP:

```
machineconfiguration.openshift.io/role: datacenter
```

These labels serve different purposes. Do not confuse them.

The custom MCP also needs to inherit the worker pool configuration by selecting both `worker` and `datacenter` MachineConfig roles. Custom pools are designed to inherit worker configurations.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://docs.redhat.com\&sz=32)

Red Hat Documentation+1


## **6. Downloaded file content**

I retrieved your supplied GitHub README successfully.

Source: [anishrana2001/Openshift – README.md](https://github.com/anishrana2001/Openshift/blob/main/README.md?utm_source=chatgpt.com).

The file currently contains:

```
Thanks for watching my content from "devops-wala" Youtube Channel.
Email ID: anishrana2001@rediffmail.com
```

We will place this content inside:

```
/etc/datacenter-swissre
```

**Important distinction:** Your requirement describes `/etc/datacenter-swissre` as a file because it says the text-file content must be visible at that exact path. It will therefore be a regular file, not a directory.

## **7. Create the MachineConfig YAML**

Recommended configuration

File name: `61-datacenter-swissre.yaml`

The current OpenShift 4.20 documentation recommends Ignition specification `3.5.0`. We will use that version. If your cluster is on an older OpenShift release, verify its supported Ignition version before applying this manifest.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://docs.redhat.com\&sz=32)

Red Hat Documentation+1



```

apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig

metadata:
  name: 61-datacenter-swissre
  labels:
    machineconfiguration.openshift.io/role: datacenter

spec:
  config:
    ignition:
      version: 3.5.0

    storage:
      files:
        - path: /etc/datacenter-swissre
          mode: 500 # Decimal 500 = octal 0764
          overwrite: true
          contents:
            source: "data:,Thanks%20for%20watching%20my%20content%20from%20%22devops-wala%22%20Youtube%20Channel.%0AEmail%20ID%3A%20anishrana2001%40rediffmail.com%0A"

```

### **Explanation of each field**

| YAML field         | Purpose                             |
| ------------------ | ----------------------------------- |
| `apiVersion`       | Identifies the MachineConfig API    |
| `kind`             | Creates a MachineConfig resource    |
| `metadata.name`    | Name of our MC                      |
| `metadata.labels`  | Associates MC with datacenter role  |
| `ignition.version` | Uses Ignition 3.5.0                 |
| `storage.files`    | Defines files to create on nodes    |
| `path`             | Target host file                    |
| `mode`             | Sets file permissions               |
| `overwrite`        | Allows replacement of existing file |
| `contents.source`  | Provides the encoded README content |

### **Understanding file permissions**

Your requested permission is:

```
rwx rw- r--
```

This translates into:

| Owner   | Group | Others |
| ------- | ----- | ------ |
| Read    | Read  | Read   |
| Write   | Write | -      |
| Execute | -     | -      |

The numeric representation is:

```
0764
```

Ignition expects the permission mode as a decimal integer. Therefore:

\\[ 0764\_{\text{octal}} = 500\_{\text{decimal}} \\]

That is why the YAML contains:

```
mode: 500
```

### **Important note about filesystem: root**

You mentioned:

```
filesystem: root
```

In the current Ignition 3.5 file schema, `storage.files` entries use an absolute `path`; they do not have a `filesystem: root` field. The path `/etc/datacenter-swissre` is written to the host's root filesystem through Ignition's normal file handling.

Do not add `filesystem: root` to this manifest, because it is not a valid field for this Ignition file definition.

## **8. Create the MachineConfigPool YAML**

Now we need a custom MCP named `datacenter`.

File name: `datacenter-mcp.yaml`

```

apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfigPool

metadata:
  name: datacenter

spec:
  machineConfigSelector:
    matchExpressions:
      - key: machineconfiguration.openshift.io/role
        operator: In
        values:
          - worker
          - datacenter

  nodeSelector:
    matchLabels:
      node-role.kubernetes.io/datacenter: ""

```

### **Understand this MCP configuration**

**1. metadata.name**

```
name: datacenter
```

Creates a custom MachineConfigPool called `datacenter`.

**2. machineConfigSelector**

```
machineConfigSelector:
  matchExpressions:
    - key: machineconfiguration.openshift.io/role
      operator: In
      values:
        - worker
        - datacenter
```

This tells the pool to select MachineConfigs carrying either the worker role or the datacenter role.

Why both?

Because custom pools inherit worker configurations. Selecting both roles ensures the datacenter nodes receive the normal worker configurations plus our custom datacenter configuration.

**3. nodeSelector**

```
nodeSelector:
  matchLabels:
    node-role.kubernetes.io/datacenter: ""
```

This tells OpenShift:

Only select nodes that have the `datacenter` node-role label.

This is how we isolate the target nodes.

[image](https://www.google.com/s2/favicons?domain=https://docs.redhat.com\&sz=32)

docs.redhat.com+1

## **9. Prepare the nodes for the datacenter role**

Before applying the configuration, identify which worker nodes should belong to the datacenter pool.

Check existing nodes:

```
oc get nodes
```

Check existing node labels:

```
oc get nodes --show-labels
```

Suppose you want these two nodes to become datacenter nodes:

- worker-2
- worker-3

Apply the custom node-role label:

```
oc label node worker-2 node-role.kubernetes.io/datacenter=""

oc label node worker-3 node-role.kubernetes.io/datacenter=""
```

Verify:

```
oc get nodes --show-labels | grep datacenter
```

Expected result: Both nodes should have the `node-role.kubernetes.io/datacenter` label.

**Instructor note:** The custom MCP selects nodes using this label. The MachineConfig itself selects the `datacenter` role through its MachineConfig label. These are separate selection mechanisms.

## **10. Apply the configuration**

Apply the MCP first:

```
oc apply -f datacenter-mcp.yaml
```

Then apply the MachineConfig:

```
oc apply -f 61-datacenter-swissre.yaml
```

Check the resources:

```
oc get mcp
```

```
oc get mc
```

You should see:

- `datacenter` in the MCP list.
- `61-datacenter-swissre` in the MC list.
- A new rendered MachineConfig for the datacenter pool.

The rendered configuration is automatically generated by the MCO. Do not edit rendered MachineConfigs manually.

## **11. Monitor the MachineConfigPool rollout**

This is one of the most important responsibilities of an OpenShift administrator.

Run:

```
oc get mcp datacenter -w
```

Understand these important fields:

| Field                | Meaning                                    |
| -------------------- | ------------------------------------------ |
| UPDATED              | Desired configuration successfully applied |
| UPDATING             | Configuration rollout is in progress       |
| DEGRADED             | An error occurred during configuration     |
| MACHINECOUNT         | Total nodes in the pool                    |
| READYMACHINECOUNT    | Ready nodes                                |
| UPDATEDMACHINECOUNT  | Nodes using the desired configuration      |
| DEGRADEDMACHINECOUNT | Nodes in degraded state                    |

**Expected final MCP status**

True

UPDATED

False

UPDATING

False

DEGRADED

0

DEGRADEDMACHINECOUNT

Illustrative healthy state, assuming all selected nodes are updated and ready.

Note that machine configuration changes can cause node draining and rebooting. Plan the rollout carefully, especially in production clusters.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://docs.redhat.com\&sz=32)

Red Hat Documentation+1



## **12. Verify the file on the nodes**

Once the MCP reports:

```
UPDATED=True
UPDATING=False
DEGRADED=False
```

Verify the file on a datacenter node.

First, identify the nodes:

```
oc get nodes -l node-role.kubernetes.io/datacenter
```

Start a debug session:

```
oc debug node/worker-2
```

Access the host filesystem:

```
chroot /host
```

Check whether the file exists:

```
ls -l /etc/datacenter-swissre
```

Check the content:

```
cat /etc/datacenter-swissre
```

Expected output:

```
Thanks for watching my content from "devops-wala" Youtube Channel.
Email ID: anishrana2001@rediffmail.com
```

Verify the permission:

```
stat -c '%a' /etc/datacenter-swissre
```

Expected:

```
764
```

Repeat on the second datacenter node.

You can exit the debug session using:

```
exit
```

## **13. How does the complete process work internally?**

Let's understand what happens after you execute `oc apply`.

1. **Administrator creates MachineConfig**

   `61-datacenter-swissre.yaml` is submitted to the Kubernetes API server.
2. **MCO detects the new MachineConfig**

   It identifies the role label `datacenter`.
3. **MCO identifies the matching MCP**

   The datacenter MCP selects the MachineConfig and datacenter nodes.
4. **Rendered MachineConfig is generated**

   MCO combines applicable worker and datacenter configurations.
5. **Machine Config Daemon applies changes**

   The MCD on each node applies the desired host configuration and verifies it.
6. **MCP status gets updated**

   The pool reports whether the nodes are updated, updating, or degraded.

## **14. Troubleshooting – What if the configuration fails?**

These are commands an OpenShift administrator should know.

| Problem                   | Command                                                                         |
| ------------------------- | ------------------------------------------------------------------------------- |
| MCP not updating          | `oc describe mcp datacenter`                                                    |
| MachineConfig not created | `oc get mc`                                                                     |
| Wrong node selection      | `oc get nodes --show-labels`                                                    |
| Node degraded             | `oc describe node worker-2`                                                     |
| MCO problems              | `oc get co machine-config`                                                      |
| MCO operator logs         | `oc logs -n openshift-machine-config-operator deploy/machine-config-controller` |
| MCD logs                  | `oc get pods -n openshift-machine-config-operator -o wide`                      |

For a degraded node, inspect its Machine Config Daemon logs:

```
oc logs -n openshift-machine-config-operator \
  <machine-config-daemon-pod-name>
```

You can also inspect the node's annotations and current configuration:

```
oc describe node worker-2
```

Look for:

```
machineconfiguration.openshift.io/currentConfig
machineconfiguration.openshift.io/desiredConfig
machineconfiguration.openshift.io/state
```

If the current and desired configurations differ, the node may still be processing the update.

## **15. How to roll back the configuration**

Suppose the administrator wants to remove the Swiss Re file configuration.

Delete the custom MachineConfig:

```
oc delete mc 61-datacenter-swissre
```

The MCO recalculates the desired rendered configuration for the pool.

The file created by that MachineConfig will no longer be part of the desired configuration. The MCD reconciles the node accordingly.

Monitor:

```
oc get mcp datacenter -w
```

If you also want to remove the custom pool, first remove its node-role labels:

```
oc label node worker-2 node-role.kubernetes.io/datacenter-
oc label node worker-3 node-role.kubernetes.io/datacenter-
```

Then delete the MCP:

```
oc delete mcp datacenter
```

Do not manually delete rendered MachineConfigs.

## **16. Important interview questions**

**Q1. What is the difference between MC and MCP?**

MC defines the operating-system configuration. MCP defines the node group that receives and manages that configuration.

**Q2. What is the MCO?**

The Machine Config Operator manages node-level configuration and operating-system updates in OpenShift.

**Q3. What is MCD?**

The Machine Config Daemon runs on individual nodes and applies and verifies the desired machine configuration.

**Q4. Why do custom MCPs inherit worker configurations?**

Because custom pools are generally specialized worker pools. They need the standard worker configuration in addition to their own specialized settings.

**Q5. What happens when you create a new MachineConfig?**

MCO detects it, generates a new rendered configuration for matching pools, and coordinates applying that configuration to their nodes.

**Q6. What happens if someone manually changes an MC-managed file?**

The Machine Config Daemon can detect the configuration drift and mark the node as degraded.

**Q7. Does creating an MC always reboot a node?**

Not necessarily. Some configuration changes do not require a reboot, while others do. The MCO determines the necessary update behavior.

**Q8. Why should we use&#x20;**`overwrite: true`**?**

It allows Ignition to replace an existing file rather than failing because the file already exists.

**Q9. What is the purpose of&#x20;**`rendered-worker-*`**&#x20;or&#x20;**`rendered-datacenter-*`**?**

These are automatically generated configurations containing the combined desired configuration for their respective pools.

**Q10. How do you know that your MachineConfig has been successfully applied?**

Check that the relevant MCP reports `UPDATED=True`, `UPDATING=False`, and `DEGRADED=False`, then verify the actual file on the host.

## **17. Final revision – Remember these five commands**

| Command                      | Why you use it                   |
| ---------------------------- | -------------------------------- |
| `oc get mc`                  | List MachineConfigs              |
| `oc get mcp`                 | List MachineConfigPools          |
| `oc describe mcp datacenter` | Investigate pool status          |
| `oc get nodes --show-labels` | Verify node roles                |
| `oc debug node/worker-2`     | Inspect host-level configuration |

**My recommendation as an OpenShift instructor:** Practice this scenario in a non-production cluster with two worker nodes. Create the custom role, label the nodes, create the MCP, apply the MC, observe the rendered configuration, and verify the file on both nodes. Then delete the MC and observe the reconciliation process.

For additional learning, use the official Red Hat documentation:

- [OpenShift 4.20 – Machine Configuration](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/machine_configuration/?utm_source=chatgpt.com)
- [OpenShift 4.20 – Machine Management](https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/machine_management/?utm_source=chatgpt.com)

**The key concept to remember: MachineConfig defines WHAT needs to change on a node; MachineConfigPool defines WHICH nodes receive that configuration and manages the rollout.**
