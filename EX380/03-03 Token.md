

# Question: You need to give ReadOnly access of your OpenShift Container Platform (OCP) cluster to user so that user can monitor all the resources.
For this, you need to create a client certificate that allows the user to examine everything in the cluster but does not allow the user to make any changes.
 
- A client certificate must exists with the username: `mon-punit`
- A group name: `cluster-monitoring-app`
- Members of this group have access to the cluster role: `cluster-reader`
- The client certificate you can download from below link.
- The client certificate must not be able to create or delete projects
- The client certificate must be able to view all pods in the cluster
- kubeconfig file name must be `mykube.config` in the `/home/student` directory.

## Yuo can use the below command to generate the key and CSR.
`openssl req -newkey rsa:4096 -keyout /home/student/data/monitoing.key -nodes -subj "/O=cluster-monitoring-app/CN=mon-punit"  -out /home/student/data/mon.csr`

---
## Solution:

```
[student@workstation ~]$ oc adm groups new cluster-monitoring-app
group.user.openshift.io/cluster-monitoring-app created

[student@workstation ~]$ oc adm groups add-users cluster-monitoring-app  mon-punit
group.user.openshift.io/cluster-monitoring-app added: "mon-punit"


[student@workstation ~]$ oc get clusterrole cluster-reader
NAME             CREATED AT
cluster-reader   2024-03-05T20:06:28Z


[student@workstation ~]$ oc adm policy add-cluster-role-to-group cluster-reader cluster-monitoring-app
clusterrole.rbac.authorization.k8s.io/cluster-reader added: "cluster-monitoring-app"

[student@workstation ~]$ mkdir test
[student@workstation ~]$ cd test/
```



