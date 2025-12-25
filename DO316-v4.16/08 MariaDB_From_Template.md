# Create a VirtualMachine Template
  - Create a project `kiwi` and a VirtualMachine template according to the following requirements
  - The Template name is `tmprhl9small` in the `kiwi` project
  - The Template is clone of the build-in rhel9-server-small template
  - Flavor small, with 1 CPU and 2Gi RAM
  - Storage space is 10Gi
  - Disk source  `http://utility.lab.example.com:8080/openshift4/images/rhel9-helloworld.qcow2`
  - storageCLassName: `ocs-external-storagecluster-ceph-rbd-virtualization`
  - The user `rahul` can login to these VirtualMachines on the console with password `anishrana2001`
  - The user `rahul` should have SSH password less authication on VM  by using `/home/opsdam/.ssh/id_rsa_ex316.pub key` from the base machine.
  - When VM created from this template, it should have 2 packages, i.e. `netlabels` and `mtr`. You can download from the below links.
    - `https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/getPackage/netlabel_tools-0.30.0-13.el9.x86_64.rpm`
    - `https://yum.oracle.com/repo/OracleLinux/OL9/baseos/latest/x86_64/getPackage/mtr-0.94-4.el9.x86_64.rpm`
  ---

