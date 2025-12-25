### Prepare the lab.
```
oc new-project vm-image
oc apply -f https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO316/replicated-template.yaml
oc apply -f https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO316/web1.template.yaml
```

# Manage Storage for VirtualMachines
- Create two VirtualMachines in project `vm-image` in the following way:
  - Create a VirtualMachine named `replicated` using `replicated-template` template
  - Create a VirtualMachine named `web1` using `web1-template` template, do not change the template
  - Make sure the following conditions are met:
    - Move the disk `goldimg` from the VirtualMachine `replicated` to VirtualMachine `web1`
    - The disk uses the same setting as the original `goldimg` on replicated, such as storageClass, acessMode,etc
    - The disk is a block device and is accessible via /dev/vdc
    - The disk is mounted at /var/www/html of `web1` permanently
- Ensure the VirtualMachine `replicated` has a disk named `gori`
    - User name is `raja` and password is `anishrana2001`
    - The disk uses `http://utility.lab.example.com:8080/openshift4/images/rhel9-helloworld.qcow2` as a source
    - The disk size is `10Gi`
    - The disk support shared access
    - The disk is a block device and is accessible via `/dev/vdc`
    - The disk is mounted at `/var/www/html` on `replicated` permanently
    - Ensure the exiting data on these disk is preserved

Both VirtualMachine are running normally
