# You task is to create a VolumeGroup (vg) named `vg_video` and then create a LVM named `lv_video` from the VG (vg_video).
- Please make sure you should have Physical extent 16M and you must use 30 extent for LVM.
- Filesystem should be vfat
- Mount point should be /mnt/video
---

### Solution:

### First, execute the command `lsblk -fp` to know which partition is free. In this question, it is not mentioned.
```
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
/dev/sr0    iso9660 Joliet Extension config-2 2025-10-05-13-34-41-00      
```

### From the above command, we can use `/dev/sdc/`
```
[root@servera ~]# fdisk /dev/sdc 

Welcome to fdisk (util-linux 2.40.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS (MBR) disklabel with disk identifier 0x7d997d7f.

Command (m for help): n      👈👈👈👈
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p     👈👈👈👈
Partition number (1-4, default 1): 1   👈👈👈👈
First sector (2048-10485759, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-10485759, default 10485759): +1G    👈👈👈👈

Created a new partition 1 of type 'Linux' and of size 1 GiB.

Command (m for help): t    👈👈👈👈
Selected partition 1     👈👈👈👈
Hex code or alias (type L to list all): L  👈👈👈👈

00 Empty            27 Hidden NTFS Win  82 Linux swap / So  c1 DRDOS/sec (FAT-
01 FAT12            39 Plan 9           83 Linux            c4 DRDOS/sec (FAT-
```
```
[root@servera ~]# lsblk -fp
NAME        FSTYPE  FSVER            LABEL    UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
/dev/sda                                                                                          
├─/dev/sda1                                                                                       
├─/dev/sda2 vfat    FAT16                     7B77-95E7                             191.4M     4% /boot/efi
└─/dev/sda3 xfs                      root     15507695-22bb-4c65-94e6-a438e095983f    7.4G    24% /
/dev/sdb                                                                                          
└─/dev/sdb1 swap    1                         41d00f9f-d91f-492e-bbfe-0ec212a85829                [SWAP]
/dev/sdc                                                                                          
└─/dev/sdc1                                                                                       
/dev/sdd                                                                                          
/dev/sr0    iso9660 Joliet Extension config-2 2025-10-05-13-34-41-00                              

[root@servera ~]# pvcreate /dev/sdc 
  Cannot use /dev/sdc: device is partitioned

[root@servera ~]# pvdisplay 
  "/dev/sdc1" is a new physical volume of "1.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdc1
  VG Name               
  PV Size               1.00 GiB    👈👈👈👈
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               6KzyCe-3Ycj-UywB-HehY-WiuK-U8QD-v1XYva
   
[root@servera ~]# vgcreate -s 16M vg_video /dev/sdc1 
  Volume group "vg_video" successfully created


[root@servera ~]# vgdisplay vg_video 
  --- Volume group ---
  VG Name               vg_video
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               1008.00 MiB
  PE Size               16.00 MiB     👈👈👈👈 ✅✅✅✅✅✅
  Total PE              63
  Alloc PE / Size       0 / 0   
  Free  PE / Size       63 / 1008.00 MiB
  VG UUID               B3LSRE-Cx5t-zNR3-rheb-78ei-2Daa-7NvEs4
[root@servera ~]# 


[root@servera ~]# lvcreate -n lv_video -l +30 vg_video /dev/sdc1 
  Logical volume "lv_video" created.
[root@servera ~]# lvdisplay 
  --- Logical volume ---
  LV Path                /dev/vg_video/lv_video
  LV Name                lv_video
  VG Name                vg_video
  LV UUID                dmkiWn-vyLs-Ue25-0FqY-21FY-khmJ-H9Wnh8
  LV Write Access        read/write
  LV Creation host, time servera, 2025-10-05 14:03:39 +0000
  LV Status              available
  # open                 0
  LV Size                480.00 MiB
  Current LE             30    👈👈👈👈 ✅✅✅✅✅✅
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:0
[root@servera ~]# 
```

### Filesystem should be vfat
```
[root@servera ~]# mkfs.vfat /dev/mapper/vg_video-lv_video
mkfs.fat 4.2 (2021-01-31)
```

### Mount point should be /mnt/video
```
[root@servera ~]# mkdir /mnt/video

[root@servera ~]# vi /etc/fstab 
```

```
[root@servera ~]# cat /etc/fstab 
UUID=15507695-22bb-4c65-94e6-a438e095983f       /            xfs     defaults        0       0
UUID=7B77-95E7                                  /boot/efi    vfat    defaults,uid=0,gid=0,umask=077,shortname=winnt  0       2
UUID=41d00f9f-d91f-492e-bbfe-0ec212a85829       swap         swap    defaults 0 0  
/dev/mapper/vg_video-lv_video                   /mnt/video   vfat    defaults 0 0     👈👈👈👈 ✅✅✅✅✅✅
[root@servera ~]# 
```


[root@servera ~]# mount -a
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
[root@servera ~]# systemctl daemon-reload

```
###  Post checks!!
```
[root@servera ~]# df -h | grep video
/dev/mapper/vg_video-lv_video  480M     0  480M   0% /mnt/video

[root@servera ~]# lsblk -fp
NAME                              FSTYPE      FSVER            LABEL    UUID                                   FSAVAIL FSUSE% MOUNTPOINTS
/dev/sda                                                                                                                      
├─/dev/sda1                                                                                                                   
├─/dev/sda2                       vfat        FAT16                     7B77-95E7                               191.4M     4% /boot/efi
└─/dev/sda3                       xfs                          root     15507695-22bb-4c65-94e6-a438e095983f      7.4G    24% /
/dev/sdb                                                                                                                      
└─/dev/sdb1                       swap        1                         41d00f9f-d91f-492e-bbfe-0ec212a85829                  [SWAP]
/dev/sdc                                                                                                                      
└─/dev/sdc1                       LVM2_member LVM2 001                  6KzyCe-3Ycj-UywB-HehY-WiuK-U8QD-v1XYva                
  └─/dev/mapper/vg_video-lv_video vfat        FAT16                     EA57-F2E6                               479.7M     0% /mnt/video
/dev/sdd                                                                                                                      
/dev/sr0                          iso9660     Joliet Extension config-2 2025-10-05-13-34-41-00                                
[root@servera ~]#
```
