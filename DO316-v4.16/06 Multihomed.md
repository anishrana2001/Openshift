### Prepare the lab for this question.
```
 lab start multihomed-nmstate
```

# Deploy a Multihomed VirtualMachine
- Create a VM called `mariadb-server` from template `Red Hat Enterprise Linux 9 VM` with 2 Network interfaces in `apple` project.
- The Workload type of the VirtualMachine is `server` and flavor is `small`.
- The user `suraj` creates the VirtualMachine `mariadb-server`
- The user `suraj` with password "anishrana2001" should exists in the cloud-init definition.
- The ssh Key `/home/opsadm/.ssh/id_rsa_ex316.pub` from user opsadm at workbench.lab.example.com has been added as an authorized ssh key via the cloud-init definition

## Storage Configuration
- The Image used to Create the Persistemt volume claim for the VirtualMachine boot source is `http://utility.lab.example.com:8080/openshift4/images/rhel9-helloworld.qcow2`
- The StorageClassName is `ocs-external-storagecluster-ceph-rbd-virtualization`
- The PVC size is `10Gi`

## The first Network Interface configuration
- The first Network interface name is `default`
- The First Network ineterface is attached to the pod networking (default) network
- The first network interface type is `masquerade`
- The model for the first network interface is `virtio`

## The Second Network Interface Configuration
- The second network interface name is `nic-0`
- The second network interface is attached to the `apple/database-network` network
- The second network interface type is `bridge`
- The IP address of the second network interface is provided by OpenShift
- The model for the second network interface is virto
---
---

### Solution:
### Step 1. As per question, we need to add the 2nd interface, it means that first, we need to install the operator ""
### Step 2. Suraj user must able to create the VM "mariadb-server", In Question 3, we have already gave the rights to this user.
### Step 3. Switch to `suraj` user on console and create a VM from "RHEL 9.2, server, small" template with using mentioned PVC URL.


### Step 1. As per question, we need to add the 2nd interface, it means that first, we need to install the operator ""
### Before that, let's add the label on workernodes so that we can create a extra interface.
```
oc label nodes worker01 external-network=true
```
```
oc label nodes worker01 external-network=true
```

### Create `NodeNetworkConfigurationPolicy`
![image](https://github.com/user-attachments/assets/17f0a830-4a22-4612-8f51-bc9df9318af2)
## Create a `NetworkAttachmentDefinitions` in a `apple` project.
![image](https://github.com/user-attachments/assets/47e60967-b9d7-455e-8703-b3306ca1bf5c)


## Loing through `suraj` user.

![image](https://github.com/user-attachments/assets/c2585076-fed2-4251-a3a9-01083fed55e5)

## Select the `apple` project and go to the virtuallization.

![image](https://github.com/user-attachments/assets/5bd8de74-8dbf-4c8c-b248-b3abcd69ae2e)

### Select the right template as per question.

![image](https://github.com/user-attachments/assets/76f5cf2b-5c2e-46ea-abd1-09d5c7adc237)

## Fill the details, like name of `virtual server` and `disk size` and then click on `customize VirtualMachine`

![image](https://github.com/user-attachments/assets/ef03bf68-07ea-4f81-965f-5e5f044ad79d)


## Click on `Network Interfaces` and add the 2nd interface by click on `Add Network Interface`.

![image](https://github.com/user-attachments/assets/883c990a-1546-4216-b0d3-514aade4d924)

## Fill the details as per question.

![image](https://github.com/user-attachments/assets/87c30c1c-4f83-490b-bdcd-8738d030e72e)

## Click on `Disk` and modify the details.

![image](https://github.com/user-attachments/assets/e05621d0-5c00-4562-a865-f417103b4b62)


### Modify the storageClass name to `ocs-external-storagecluster-ceph-rbd-virtualization`

![image](https://github.com/user-attachments/assets/af2653e5-f81c-4631-8d5e-c0963a38dbcd)

### Click on `Script` tab.

![image](https://github.com/user-attachments/assets/3318f7b3-8fa7-4442-8635-24114432d0c1)

## Add the user name `suraj` and its credentials.

![image](https://github.com/user-attachments/assets/b5becfd7-4764-419a-ad7f-67dda0a43c90)

## Add the id_rsa,key file




