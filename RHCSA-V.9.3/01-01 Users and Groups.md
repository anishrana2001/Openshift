# Question 1: You are the adminstrator of devops-wala company and you need to perform below tasks on `servera`

- Create a two groups called `admin` and `devops-wala`
- Creata a users
    - `punit` users must be the part of `admin` group. Or you can say that Add `admin` group as a seconday group of these users.
    - User `punit` should have `1234` UID and Add the comment `For OCP Cluster`
    - User `punit` should have home directory `/home/ocp-cluster/`.
    - User `punit` should have login shell `/bin/bash`
    - User `rajan` shoudl have `1235` UID and Add the comment `For Database Cluster`
    - User `rajan` shoudl have home directory `/home/database-cluster`
    - User `rajan` should have login shell `/bin/sh`
     - `harry` users must be the part of `devops-wala` group. Or you can say that Add `devops` group as a seconday group of these users.
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

#### Create `admin` group.
```
groupadd admin
```
### Create a group for `devops-wala`.
```
root@servera yum.repos.d]# groupadd devops-wala
```

### Create punit user.
```
useradd -G admin  -u 1234 -s /bin/bash -d /home/ocp-cluster -c "For OCP Cluster"  punit
```

### Post checks for `punit` user.
```
[root@servera yum.repos.d]# cat /etc/passwd | grep punit
punit:x:1234:1234:For OCP Cluster:/home/ocp-cluster:/bin/bash
[root@servera yum.repos.d]# cat /etc/group | grep punit
admin:x:1003:punit
punit:x:1234:
[root@servera yum.repos.d]#
```


### Create a user `harry`.
```
useradd -G devops-wala -u 1334 -d /home/harry -s /bin/bash -c "For OCP Cluster" harry
```

### Post checks for `harry` user.

```
[root@servera ~]# cat /etc/passwd | grep harry
harry:x:1334:1334:For OCP Cluster:/home/harry:/bin/bash
[root@servera ~]# cat /etc/group | grep harry
devops-wala:x:1235:harry
harry:x:1334:
[root@servera yum.repos.d]# 
```
### Create a user `peter`.
```
useradd -G devops-wala -u 1335 -d /home/peter -s /bin/sh -c "For Database Cluster" peter
```

### Post checks for `peter` user.
```
[root@servera ~]# cat /etc/passwd | grep peter
peter:x:1335:1335:For Database Cluster:/home/peter:/bin/sh
[root@servera ~]# cat /etc/group | grep peter
devops-wala:x:1235:harry,peter
peter:x:1335:
[root@servera ~]#
```

### Create a user `mon_ocp` with no interactive shell.
```
[root@servera yum.repos.d]# cat /etc/passwd | grep no | head -n 1
bin:x:1:1:bin:/bin:/usr/sbin/nologin

[root@servera yum.repos.d]# useradd -s /usr/sbin/nologin mon_ocp 
```

### Post checks.
```
[root@servera yum.repos.d]# cat /etc/passwd | grep mon_ocp
mon_ocp:x:1336:1336::/home/mon_ocp:/usr/sbin/nologin
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
```


### You can exclude the lines with are start by "#", we can use "^# and also remove the blank lines =(^$)
```
[root@servera ~]# cat /etc/login.defs | grep -v "^#" | grep -v "^$"
MAIL_DIR        /var/spool/mail
UMASK           022
HOME_MODE       0700
PASS_MAX_DAYS   99999   ## ✅  This line we need to modify
PASS_MIN_DAYS   0
PASS_MIN_LEN    8
PASS_WARN_AGE   7
UID_MIN                  1000
UID_MAX                 60000
SYS_UID_MIN               201
SYS_UID_MAX               999
SUB_UID_MIN                524288
SUB_UID_MAX             600100000
SUB_UID_COUNT               65536
GID_MIN                  1000
GID_MAX                 60000
SYS_GID_MIN               201
SYS_GID_MAX               999
SUB_GID_MIN                524288
SUB_GID_MAX             600100000
SUB_GID_COUNT               65536
PASS_CHANGE_TRIES       5
PASS_ALWAYS_WARN        yes
ENCRYPT_METHOD YESCRYPT
USERGROUPS_ENAB yes
CREATE_HOME     yes
HMAC_CRYPTO_ALGO SHA512


[root@servera ~]# vi /etc/login.defs 

[root@servera ~]# cat /etc/login.defs | grep "PASS_MAX_DAYS"
#       PASS_MAX_DAYS   Maximum number of days a password may be used.
PASS_MAX_DAYS   17  ## ✅  Line modified
[root@servera ~]# 



```
