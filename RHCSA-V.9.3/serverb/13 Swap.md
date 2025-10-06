
# As a system admin of `devops-wala` firm, you need to add the swap partition so that server can manage the request more efficiently. Thus, you need to add 512M swap memory.


### Solution:

<img width="937" height="876" alt="Screenshot 2025-10-05 at 12 33 40 PM" src="https://github.com/user-attachments/assets/7b23c22c-b66e-4c18-bed5-8c4c8937c9f0" />

### Format the partition.
```
[root@servera ~]# mkswap /dev/sdb1
Setting up swapspace version 1, size = MiB (536866816 bytes)
no label, UUID=41d00f9f-d91f-492e-bbfe-0ec212a85829
[root@servera ~]#

```
```
[root@servera ~]# vi /etc/fstab 
[root@servera ~]# cat /etc/fstab 
UUID=15507695-22bb-4c65-94e6-a438e095983f       /       xfs     defaults        0       0
UUID=7B77-95E7  /boot/efi       vfat    defaults,uid=0,gid=0,umask=077,shortname=winnt  0       2
UUID=41d00f9f-d91f-492e-bbfe-0ec212a85829  swap swap defaults 0 0  

[root@servera ~]# swapon -a

[root@servera ~]# lsblk -fp
NAME        FSTYPE  FSVER            LABEL    UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
/dev/sda                                                                                          
├─/dev/sda1                                                                                       
├─/dev/sda2 vfat    FAT16                     7B77-95E7                             191.4M     4% /boot/efi
└─/dev/sda3 xfs                      root     15507695-22bb-4c65-94e6-a438e095983f    7.4G    24% /
/dev/sdb                                                                                          
└─/dev/sdb1 swap    1                         41d00f9f-d91f-492e-bbfe-0ec212a85829                [SWAP]
/dev/sdc                                                                                          
/dev/sdd                                                                                          
/dev/sr0    iso9660 Joliet Extension config-2 2025-10-05-06-40-12-00                              
[root@servera ~]# 

[root@servera ~]# free -h
               total        used        free      shared  buff/cache   available
Mem:           1.7Gi       379Mi       1.3Gi       9.2Mi       184Mi       1.3Gi
Swap:          511Mi          0B       511Mi
[root@servera ~]# 

[root@servera ~]# swapon --show 
NAME      TYPE      SIZE USED PRIO
/dev/sdb1 partition 512M   0B   -2
[root@servera ~]#

```

<img width="937" height="340" alt="Screenshot 2025-10-05 at 12 54 18 PM" src="https://github.com/user-attachments/assets/7e1af604-1846-43e7-81e0-24caf98d19fd" />
