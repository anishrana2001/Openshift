# From the below question, we get to know that how `block` and `rescue` work together.

### Question: Create a lvm and below tasks must be fullfill.

    - Create a play for this task with named `mylvm-q2.yaml` under `/home/student/ansible` directory.
    - Create a LVM with name `redrose` under the VolumeGroup named `toto`.
    - Size of LVM should be `1024 Mib`
    - Filesystem of this LVM should ext4.
	- If it fails then it should generate the error message `Give size is high`
	- Then it should create a lvm with `200 Mib`
	- If the volume group "toto" does not exist then generate the error `Create a VG toto first, ha ha` 
---


## Solution: 
### We can take the reference from the below documentation. 
```
ansible-doc community.general.lvol
ansible-doc community.general.filesystem
ansible-doc debug    <----- For debug the message.
```



### Login into your managed node and check which partition is free. For me, I can see that its `vdb` is free.
```
[root@workstation ~]# ssh servera -l root

[root@servera ~]# lsblk -fs
NAME  FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
vda1                                                                         
└─vda                                                                        
vda2  vfat   FAT16       7B77-95E7                             192.8M     3% /boot/efi
└─vda                                                                        
vda3  xfs          boot  5e75a2b9-1367-4cc8-bb38-4d6abc3964b8  334.7M    32% /boot
└─vda                                                                        
vda4  xfs          root  fb535add-9799-4a27-b8bc-e8259f39a767    7.6G    19% /
└─vda                                                                        
vdb   <-------  This partition is free.
[root@servera ~]# 
```

### Next, log off from the managed node, and login back to your Ansible host machine. For me, its workstation.



```
vim mylvm-q2.yaml
```
```
---
- name: Create LVM, volume group, and ext4 filesystem on /dev/vdb without command module
  hosts: all
  become: true
  gather_facts: true
  tasks:
    - name: Create volume group toto on /dev/vdb
      community.general.lvg:
        vg: toto
        pvs: /dev/vdb

    - name: Create logical volume redrose
      community.general.lvol:
        vg: toto
        lv: redrose
        size: 512m

    - name: Create ext4 filesystem on logical volume
      ansible.builtin.filesystem:
        fstype: ext4
        dev: /dev/toto/redrose
```


### Run the playbook.
```
 ansible-navigator run mylvm-q2.yaml -m stdout
```
