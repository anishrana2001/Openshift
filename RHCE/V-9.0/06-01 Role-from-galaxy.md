




### Solution:

### Pre-checks!!
```
ansible-galaxy role list | head
```

### Check the directory.
```
 cd /home/student/ansible/my-roles/
```

### Create a file with anyname 
```
cat role-from-galaxy.yaml 
---
- src: https://galaxy.ansible.com/download/zabbix-zabbix-1.0.6.tar.gz
  name: zabbix-anish
- src: https://galaxy.ansible.com/download/openafs_contrib-openafs-1.9.0.tar.gz
  name: openafs-devops-wala
```

### Install the role from galaxy.
```
ansible-galaxy install -r role-from-galaxy.yaml
```

### Perform the Post checks.

```
ansible-galaxy role list | head
```


### For your references..



```
student@workstation ~]$ cd ansible/
[student@workstation ansible]$ cd my-roles/

[student@workstation my-roles]$ vim role-from-galaxy.yaml

[student@workstation my-roles]$ cat role-from-galaxy.yaml 
---
- src: https://galaxy.ansible.com/download/zabbix-zabbix-1.0.6.tar.gz
  name: zabbix-anish
- src: https://galaxy.ansible.com/download/openafs_contrib-openafs-1.9.0.tar.gz
  name: openafs-devops-wala
[student@workstation my-roles]$

### Pre-checks.

[student@workstation ansible]$ ansible-galaxy role list | head
# /home/student/ansible/my-roles
# /usr/share/ansible/roles
- linux-system-roles.certificate, (unknown version)
- linux-system-roles.cockpit, (unknown version)
- linux-system-roles.crypto_policies, (unknown version)
- linux-system-roles.firewall, (unknown version)
- linux-system-roles.ha_cluster, (unknown version)
- linux-system-roles.kdump, (unknown version)
- linux-system-roles.kernel_settings, (unknown version)
- linux-system-roles.logging, (unknown version)
Exception ignored in: <_io.TextIOWrapper name='<stdout>' mode='w' encoding='utf-8'>
BrokenPipeError: [Errno 32] Broken pipe
[student@workstation ansible]$


[student@workstation my-roles]$ ansible-galaxy install -r role-from-galaxy.yaml 
Starting galaxy role install process
- downloading role from https://galaxy.ansible.com/download/zabbix-zabbix-1.0.6.tar.gz
- extracting zabbix-anish to /home/student/.ansible/roles/zabbix-anish
- zabbix-anish was installed successfully
- downloading role from https://galaxy.ansible.com/download/openafs_contrib-openafs-1.9.0.tar.gz
- extracting openafs-devops-wala to /home/student/.ansible/roles/openafs-devops-wala
- openafs-devops-wala was installed successfully
[student@workstation my-roles]$


## Post checks

[student@workstation my-roles]$ ansible-galaxy role list | head
# /home/student/.ansible/roles
- zabbix-anish, (unknown version)
- openafs-devops-wala, (unknown version)
# /usr/share/ansible/roles
- linux-system-roles.certificate, (unknown version)
- linux-system-roles.cockpit, (unknown version)
- linux-system-roles.crypto_policies, (unknown version)
- linux-system-roles.firewall, (unknown version)
- linux-system-roles.ha_cluster, (unknown version)
- linux-system-roles.kdump, (unknown version)


```
