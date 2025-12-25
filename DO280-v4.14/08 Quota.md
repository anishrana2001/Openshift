## Note:
#### Each container running on a node **consumes compute resources**, which are measurable quantities that can be requested, allocated, and consumed.

#### When creating a pod configuration file, you can `optionally` specify how much CPU, memory (RAM), and local ephemeral storage each container needs in order to better schedule pods in the cluster and ensure satisfactory performance.

#### CPU is measured in units called millicores. Each node in a cluster inspects the operating system to determine the amount of CPU cores on the node, then multiplies that value by 1000 to express its total capacity. For example, if a node has 2 cores, the node’s CPU capacity would be represented as 2000m. If you wanted to use 1/10 of a single core, it would be represented as 100m.

#### Memory and ephemeral storage are measured in bytes. In addition, it may be used with SI suffixes (E, P, T, G, M, K) or their power-of-two-equivalents (Ei, Pi, Ti, Gi, Mi, Ki).


# Question: Create Resources Quota with below information for project `beta`
- Quota Name is `ex280-quota`
- Maximum  Pods `7` and Service ip `6` and Replication Controller `5` 
- Memory `1G` and cpu core is `1`
--- 
## Solution:

### Createa  project first.
```
oc new-project beta
```
### Check the quota.
```
oc get quota
```
## Not sure the command ?
```
oc create quota --help | head
```
### Now, create the quota.
```
oc create quota ex280-quota  --hard=memory=1Gi,cpu=1,pods=7,services=6,replicationcontrollers=5
```

### Post Check for quota.
```
oc get quota
```


### Question 2:   Create a quota with below details.

- cpu=1
- memory=1G
- pods=2
- services=3
- replicationcontrollers=2
- resourcequotas=1
- secrets=5
- persistentvolumeclaims=10
---

### Solution :
```
oc create quota my-quota --hard=cpu=1,memory=1G,pods=2,services=3,replicationcontrollers=2,resourcequotas=1,secrets=5,persistentvolumeclaims=10
```
