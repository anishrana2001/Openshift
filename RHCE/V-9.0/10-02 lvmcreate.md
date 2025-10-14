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
- name: LVM for block and rescue mode
  hosts: all
  tasks:
    - debug:
        msg: Create a VG toto first, ha ha
      when: ansible_lvm.vgs.toto is not defined 
	  
    - block:
        - name: Create a logical volume of 512m
          community.general.lvol:
            vg: toto
            lv: redrose
            size: 1024

        - name: Create a ext2 filesystem on /dev/sdb1
          community.general.filesystem:
            fstype: ext4
            dev: /dev/toto/redrose
      rescue:
         - name: Generate error message -recue mode on
           debug:
              msg: Give size is high

         - name: Create a logical volume of 512m- rescue mode on
           community.general.lvol:
              vg: toto
              lv: redrose
              size: 512

         - name: Create a ext2 filesystem on /dev/sdb1 - rescue mode on
           community.general.filesystem:
            fstype: ext4
            dev: /dev/toto/redrose
      when: ansible_lvm.vgs.toto is defined
```


### Run the playbook.
```
 ansible-navigator run mylvm-q2.yaml -m stdout
```




### For your references....

```

[student@workstation ansible]$ cat mylvm-q2.yaml 
---
- name: LVM for block and rescue mode
  hosts: all
  tasks:
    - debug:
        msg: Create a VG toto first, ha ha
      when: ansible_lvm.vgs.toto is not defined 
	  
    - block:
        - name: Create a logical volume of 512m
          community.general.lvol:
            vg: toto
            lv: redrose
            size: 1024

        - name: Create a ext2 filesystem on /dev/sdb1
          community.general.filesystem:
            fstype: ext4
            dev: /dev/toto/redrose
      rescue:
         - name: Generate error message -recue mode on
           debug:
              msg: Give size is high

         - name: Create a logical volume of 512m- rescue mode on
           community.general.lvol:
              vg: toto
              lv: redrose
              size: 512

         - name: Create a ext2 filesystem on /dev/sdb1 - rescue mode on
           community.general.filesystem:
            fstype: ext4
            dev: /dev/toto/redrose
      when: ansible_lvm.vgs.toto is defined 
[student@workstation ansible]$



[student@workstation ansible]$ ansible-navigator run mylvm-q2.yaml -m stdout 

PLAY [LVM for block and rescue mode] *******************************************

TASK [Gathering Facts] *********************************************************
ok: [servera]
ok: [serverd]
ok: [serverb]
ok: [serverc]

TASK [Create a logical volume of 512m] *****************************************
skipping: [servera]
skipping: [serverb]
fatal: [serverd]: FAILED! => {"changed": false, "err": "  Volume group \"toto\" has insufficient free space (255 extents): 256 required.\n", "msg": "Creating logical volume 'redrose' failed", "rc": 5}
fatal: [serverc]: FAILED! => {"changed": false, "err": "  Volume group \"toto\" has insufficient free space (255 extents): 256 required.\n", "msg": "Creating logical volume 'redrose' failed", "rc": 5}

TASK [Create a ext2 filesystem on /dev/sdb1] ***********************************
skipping: [servera]
skipping: [serverb]

TASK [Generate error message -recue mode on] ***********************************
ok: [serverc] => {
    "msg": "Give size is high"
}
ok: [serverd] => {
    "msg": "Give size is high"
}

TASK [Create a logical volume of 512m- rescue mode on] *************************
changed: [serverc]
changed: [serverd]

TASK [Create a ext2 filesystem on /dev/sdb1 - rescue mode on] ******************
changed: [serverc]
changed: [serverd]

TASK [debug] *******************************************************************
ok: [servera] => {
    "msg": "Create a VG toto first, ha ha"
}
ok: [serverb] => {
    "msg": "Create a VG toto first, ha ha"
}
skipping: [serverc]
skipping: [serverd]

PLAY RECAP *********************************************************************
servera                    : ok=2    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
serverb                    : ok=2    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
serverc                    : ok=4    changed=2    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
serverd                    : ok=4    changed=2    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
[student@workstation ansible]$
```
