## Prepare the lab for this question.
```

```
# Find Command.


## Prepare the lab for this question.
```

```
## Question 1. Locate all the files with name `devops.txt` in the `/home/student` directory.
```

```

## Question 2. Locate all the files with name `devops.txt` in the `/home/student` directory and save in the /data/question2.txt
```

```

## Question 3. Locate all the files with name `devops.txt` in the `/home/student` directory but owned by user `punit` and copy it under `/data/question3-files`.
```

```

## Question 4. Locate all the files which are owned by user `punit` and copy it under `/data/question4-files/flower`.
```
mkdir -p /data/question4-files/flower 
find / -user punit 
find / -user punit -exec cp -rvf {} /data/question4-files/flower/ \;
ls -latr /data/question4-files/flower/

```

## Qestion 5. Create a script named `question5-find.sh` under `/usr/local/bin` directory and this script must locate all the regular files which are less than `1M` under `/usr/share` directory and save the searched file paths under `/root/question5-find-output.txt` file.

### Solution:
### Create a command.

- path-to-find : /usr/share/
- Regular file: `-type f`
- Size : Less than 1M = `-1M`
- Save Searched files path to `/root/question5-find-output.txt`

### syntax
```
find /path-to-find -type f -size 1M > /root/question5-find-output.txt
```

```
echo "find /path-to-find -type f -size 1M > /root/question5-find-output.txt"
```
### Save the content on mentioned file `/usr/local/bin/question5-find.sh`
```
echo "find /usr/share/ -type f -size -1M > /root/question5-find-output.txt" > /usr/local/bin/question5-find.sh
```
### Give the execute permission.
```
chmod +x /usr/local/bin/question5-find.sh
```
## Run the script. Since the path is `/usr/local/bin` directory. You can execute this command without absolute path. 
## You can also verify it.
```
echo $PATH
```
```
question5-find.sh
```
### Post check!
```
cat /root/question5-find-output.txt
```




## Qestion 6. Create a script named `question6-find.sh` under `/usr/local/bin` directory and this script must locate all the regular files which are less than `900k` and more than `30K` under `/var` directory and these files must set SUID permission. You need to save the searched file paths under `/root/question6-find-output`.


### Solution.

### Create a directory.
```
mdkir -p /root/question6-find-output
```

```
echo "find /var -type f -size +30k -size -900k -perm -u+s > /root/question6-find-output" > /usr/bin/question6-find.sh
```

### Giving execute permission.
```
chmod +x /usr/bin/question6-find.sh
```


## Post checks
```
cat /root/question6-find-output
```

```
[root@servera ~]# cat question6-find-output 
/var/cache/swcatalog/cache/C-local-metainfo.xb
/var/cache/dnf/packages.db
/var/cache/dnf/BaseOs-9e7683640d492933/repodata/9c5fdcf39b56c9ac62d42deaf7ee8adba1a8590fc7294da57b0cdd1e90d1b753-comps-BaseOS.x86_64.xml.gz
/var/cache/dnf/Apps-b8b87d9e3b38f394/repodata/c5d38adcebf7c0b655635a4994297303244516b2e01120811ca4e0d23330a036-comps-AppStream.x86_64.xml.gz
/var/cache/fwupd/quirks.xmlb
/var/lib/fwupd/pending.db
/var/lib/systemd/catalog/database
/var/lib/PackageKit/transactions.db
/var/lib/selinux/targeted/active/file_contexts
/var/lib/selinux/targeted/active/modules/100/unprivuser/hll
/var/lib/selinux/targeted/active/modules/100/init/hll
/var/lib/selinux/targeted/active/modules/100/staff/hll
/var/lib/selinux/targeted/active/modules/100/virt/cil
/var/lib/selinux/targeted/active/modules/100/virt/hll
/var/lib/selinux/targeted/active/modules/100/sysadm/cil
/var/lib/selinux/targeted/active/modules/100/sysadm/hll
/var/lib/selinux/targeted/active/modules/100/xserver/hll
/var/lib/selinux/targeted/active/modules/100/base/cil
/var/lib/selinux/targeted/active/modules/100/base/hll
/var/lib/dnf/history.sqlite
/var/lib/dnf/history.sqlite-shm
/var/log/wtmp
/var/log/lastlog
/var/log/dnf.log
/var/log/dnf.librepo.log
/var/log/cloud-init.log
/var/log/boot.log-20251006
/var/log/messages-20251006
/var/log/messages
/var/log/secure-20251006
[root@servera ~]# cat /usr/local/bin/question6-find.sh 
find /var -type f -size +30k -size -900k > /root/question6-find-output
[root@servera ~]# 
```

