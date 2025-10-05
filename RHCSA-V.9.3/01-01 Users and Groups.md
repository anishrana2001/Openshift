# Question 1: You are the adminstrator of devops-wala company and you need to perform below tasks on `servera`

- Create a two groups called `admin` and `devops`
- Creata a users
    - `punit` users must be the part of `admin` group. Or you can say that Add `admin` group as a seconday group of these users.
    - User `punit` should have `1234` UID and Add the comment `For OCP Cluster`
    - User `punit` should have home directory `/home/ocp-cluster/`.
    - User `punit` should have login shell `/bin/bash`
    - User `rajan` shoudl have `1235` UID and Add the comment `For Database Cluster`
    - User `rajan` shoudl have home directory `/home/database-cluster`
    - User `rajan` should have login shell `/bin/sh`
     - `harry` users must be the part of `devops` group. Or you can say that Add `devops` group as a seconday group of these users.
    - User `harry` should have `1334` UID and Add the comment `For OCP Cluster`
    - User `harry` should have home directory `/home/harry/`.
    - User `harry` should have login shell `/bin/bash`
    - User `peter` shoudl have `1335` UID and Add the comment `For Database Cluster`
    - User `peter` shoudl have home directory `/home/peter`
    - User `peter` should have login shell `/bin/sh`
- Create a user `mon_ocp` and this user should have non=interactive shell and it should not the part of `devops` and `admin` groups
- All users must have password `devops-wala`.
---
### Solution:


### Login to `servera`
```
ssh root@servera
```
### Let's add the group first.
```
groupadd admin
groupadd devops
```
### Create punit user.
```
[root@servera yum.repos.d]# useradd -G admin  -u 1234 -s /bin/bash -d /home/ocp-cluster punit
```

### Post checks for `punit` user.
```
[root@servera yum.repos.d]# cat /etc/passwd | grep punit
punit:x:1234:1234::/home/ocp-cluster:/bin/bash
[root@servera yum.repos.d]# cat /etc/group | grep punit
admin:x:1003:punit
punit:x:1234:
[root@servera yum.repos.d]#
```
# Question 2: You need to set the password should be expired after `17 days` on server `servera`.

### Solutions:

### All the password information is stored in the file `/etc/login.defs ` and you just need to modify the value to `PASS_MAX_DAYS  17`.

### Open the file
```
vi /etc/login.defs
```


### For your references.
```
student@workstation:~$ ssh student@servera

[student@servera ~]$ sudo -i
[sudo] password for student: 

[root@servera ~]# vi /etc/login.defs 

[root@servera ~]# cat /etc/login.defs  | grep PASS_
#       PASS_MAX_DAYS   Maximum number of days a password may be used.
#       PASS_MIN_DAYS   Minimum number of days allowed between password changes.
#       PASS_MIN_LEN    Minimum acceptable password length.
#       PASS_WARN_AGE   Number of days warning given before a password expires.
PASS_MAX_DAYS   99999
PASS_MIN_DAYS   0
PASS_MIN_LEN    8
PASS_WARN_AGE   7
PASS_CHANGE_TRIES       5
PASS_ALWAYS_WARN        yes
#PASS_MAX_LEN           8
[root@servera ~]#

[root@servera ~]# vi /etc/login.defs 
[root@servera ~]# cat /etc/login.defs  | grep PASS_MAX_DAYS
#       PASS_MAX_DAYS   Maximum number of days a password may be used.
PASS_MAX_DAYS   17     ## ✅  Line modified
[root@servera ~]#
```
