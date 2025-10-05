# Question: You are the amdin of server `servera` and you need to create one shared directory named `/home/shared-dir`. 
- Group owner should be `admin` of this directory.
- People who create a files under this directory, the group name should be `admin` of that file.
- Member of `admin` group should have all rigths (rwx),  however other should not have a single rights.
--- 
### Solution



### Create a directory `/home/shared-dir`
```
[root@servera ~]# mkdir /home/shared-dir
```
### Group owner should be `admin` of this directory.
```
[root@servera ~]# chgrp admin /home/shared-dir/
```
## Post check.
```
[root@servera ~]# ls -ld /home/shared-dir/
drwxr-xr-x. root admin Oct  16:27 /home/shared-dir/
```
### Member of `admin` group should have all rigths (rwx),  however other should not have a single rights.
```
[root@servera ~]# chmod g+rwx,o-rwx /home/shared-dir/
```
### Post checks.
```
[root@servera ~]# ls -ld /home/shared-dir/
drwxrwx---. root admin Oct  16:27 /home/shared-dir/
```
### People who create a files under this directory, the group name should be `admin` of that file.
```
[root@servera ~]# chmod g+s /home/shared-dir/
```

### Post checks.
```
[root@servera ~]# touch /home/shared-dir/test.txt
[root@servera ~]# ls -ltr /home/shared-dir/test.txt 
-rw-r--r--. root admin Oct  16:29 /home/shared-dir/test.txt
[root@servera ~]#
```
