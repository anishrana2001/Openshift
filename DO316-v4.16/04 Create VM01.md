## Preppare the lab for this question.

```
lab start accessing-guicreate
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
ssh-keygen -t rsa -q -f /home/student/.ssh/id_rsa  -N ""

```

# Create a VirtualMachine in the `banana` project with below requirements. 
- User `raja` should create a VirtualMachine named `myvm-lan1` from template "Red Hat Enterprise Linux 9 VM"
- Use PVC URL, `http://utility.lab.example.com:8080/openshift4/images/rhel9-helloworld.qcow2`
-  The StorageClassName is `ocs-external-storagecluster-ceph-rbd-virtualization`
-  The PVC size should be 30GiB
-  The Volume mode should be Block.
-  The workload type is the VirtualMachine is `server`
-  The flavor type of the VirtualMachine is `small`
-  The network interface name is `default`
-  The user `raja` with password `anishrana2001` exists in the cloud-init definition
-  The ssh Key "/home/student/.ssh/lab_rsa.pub" from user devops at workstation has been added as an authorized ssh key via the cloud-init definition
## Task: Configure Network interface.
- The first Network Interface configuration
	- The first Network interface name is `default`
	- The First Network ineterface is attached to the `pod networking` (default) network
	- The first network interface type is `masquerade`
	- The model for the first network interface is `virtio`

- The Second Network Interface Configuration
	- The second network interface name is `nic-0`
	- The second network interface is attached to the `banana/database-network` network
	- The second network interface type is `bridge`
	- The IP address of the second network interface is provided by OpenShift
	- The model for the second network interface is `virto`

## Task: Create a Readiness probs with below configuration.
      readinessProbe:
        httpGet:
          path: /health
          port: 80
        initialDelaySeconds: 10
        periodSeconds: 5
        timeoutSeconds: 2
        failureThreshold: 2
        successThreshold: 1
---

### Solution:

