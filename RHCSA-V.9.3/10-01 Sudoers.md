# Question 1. In task1, you have created one group `devops`. Your task is to add Sudo privileges to this group and it must write the password during the execution of commands. This group's users can restart the chronyd service and update or upgrade the packages only.  

### Solution:
### Please be noted that whenever you are editing the `/etc/sudoers` file, you have to use `:wq!` to forcefully write in this file.
```
[root@servera ~]# vi /etc/sudoers.d/limited_admins_rules1
[
root@servera ~]# cat /etc/sudoers.d/limited_admins_rules1
Cmnd_Alias RESTART_APACHE = /usr/bin/systemctl restart chronyd.service
Cmnd_Alias UPDATE_PACKAGES = /usr/bin/apt update, /usr/bin/apt upgrade
[root@servera ~]#


[root@servera ~]# vi /etc/sudoers

[root@servera ~]# cat /etc/sudoers | grep devops
%devops ALL = RESTART_APACHE, UPDATE_PACKAGES
[root@servera ~]# 


```





# Question 2. In task1, you have created one group `admin`. Your task is to add Sudo privileges to this group so that this group's members can perform administrative tasks with promting the password.

### Solutions:

### Please be noted that whenever you are editing the `/etc/sudoers` file, you have to use `:wq!` to forcefully write in this file.
```
[root@servera ~]# vi /etc/sudoers
[root@servera ~]# cat /etc/sudoers | grep admin
%admin  ALL=(ALL)       NOPASSWD: ALL
[root@servera ~]
```
