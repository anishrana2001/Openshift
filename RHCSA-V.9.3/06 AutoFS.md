# AutoFS:

## First terminal:
```
lab start compreview-review3
```
```
ssh student@servera
sudo -i
```
### `student` is the password.

### Install the autofs 
```
dnf install autofs -y
```
## Start and enable the service.
```
systemctl enable autofs.service 
systemctl start autofs.service 
```

## Check the already shared directory
```
showmount -e 
```
```
ls -ltr /home/guest
```
## Edit the `auto.master` file.
```
vi /etc/auto.master
```
```
cat /etc/auto.master | grep guest
/home/guest /etc/auto.misc
```
```
vi /etc/auto.misc
```
```
 cat  /etc/auto.misc | grep produ
production5 -fstype=nfs,rw,sync serverb.lab.example.com:/user-homes/production5
```

```
systemctl restart autofs.service
```
```
ls -ltr /home/guest
```



### For your refernces.

```
[root@servera ~]# showmount -e 
Export list for servera:
/user-homes/production5 serverb.lab.example.com
[root@servera ~]# 

[root@servera ~]# dnf install autofs -y

[root@servera ~]# systemctl enable autofs.service 
Created symlink '/etc/systemd/system/multi-user.target.wants/autofs.service' → '/usr/lib/systemd/system/autofs.service'.

[root@servera ~]# systemctl start autofs.service 
[root@servera ~]# 

[root@servera ~]# ls -ltr /home/guest
ls: cannot access '/home/guest': No such file or directory

[root@servera ~]# vi /etc/auto.master
[root@servera ~]# cat /etc/auto.master | grep guest
/home/guest /etc/auto.misc

[root@servera ~]# vi /etc/auto.misc 
[root@servera ~]# cat  /etc/auto.misc | grep produ
production5 -fstype=nfs,rw,sync serverb.lab.example.com:/user-homes/production5

[root@servera ~]# systemctl restart autofs.service
[root@servera ~]# ls -ltr /home/guest
total 0
[root@servera ~]# 


```
