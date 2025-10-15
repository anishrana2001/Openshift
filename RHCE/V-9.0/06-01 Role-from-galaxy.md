
### Question: You need to complete 2 tasks. 


### Task 1. You need to install 3 roles from `Ansible Galaxy` and these roles must be in the file `/home/student/ansible/my-roles/role-from-galaxy.yaml`
- Download the file `https://galaxy.ansible.com/download/zabbix-zabbix-1.0.6.tar.gz` and name it `zabbix-anish`
- Download the file `https://galaxy.ansible.com/download/openafs_contrib-openafs-1.9.0.tar.gz` and name it `openafs-devops-wala`
- Download the file `https://github.com/vcc-caeit/ansible-role.squid/archive/1.2.1.tar.gz` and name it `squid-anish`

### Task 2. Create a playbook called `/home/student/ansible/ansible-galaxy-role1.yaml`
 1. The playbook contains a play which run on `lab` host group and use the role `zabbix-anish`
 
    A Zabbix server is the core component of Zabbix, an open-source, enterprise-class monitoring system that tracks the performance and availability of various IT resources, including servers, network devices, virtual machines, and cloud services. 
    It collects, stores, and analyzes data, sending alerts to administrators via methods like email and SMS to help identify and resolve issues quickly, thereby reducing system downtime and the risk of failure. 

 2. This playbook also contains a play which run on `webserver` host group and use the role `squid-anish`
 
    A Squid server is a free, open-source caching and forwarding web proxy, primarily used to improve network performance by storing frequently accessed web content locally. 

    It speeds up response times and reduces bandwidth by serving cached copies of web pages, images, and other data to multiple users. Squid also acts as a security tool by filtering traffic and can be configured for load balancing
---


### Solution:
## Task 1: 

### Pre-checks!!
```
ansible-galaxy role list | head
```

### change the directory.
```
cd /home/student/ansible/my-roles/
```

### Create a file with `role-from-galaxy.yaml`. 
```
cat role-from-galaxy.yaml 
---
- src: https://galaxy.ansible.com/download/zabbix-zabbix-1.0.6.tar.gz
  name: zabbix-anish
- src: https://galaxy.ansible.com/download/openafs_contrib-openafs-1.9.0.tar.gz
  name: openafs-devops-wala
- src: https://galaxy.ansible.com/downlaod/mafalb-squid-0.2.0.tar.gz
  name: squid-anish
```

### Install the role from galaxy.
```
ansible-galaxy install -r /home/student/ansible/my-roles/role-from-galaxy.yaml -p /home/student/ansible/my-roles/
```

### Perform the Post checks.

```
ansible-galaxy role list | head
```


## Task 2: Create a playbook called `/home/student/ansible/ansible-galaxy-role1.yaml`
 1. The playbook contains a play which run on `lab` host group and use the role `zabbix-anish`
  2. This playbook also contains a play which run on `webserver` host group and use the role `squid-anish`

#### We just need to add 2 roles in the given file.

```
vim /home/student/ansible/ansible-galaxy-role1.yaml
```
```
---
- name: Install zabbix-anish role
  hosts: lab
  roles: 
    - zabbix-anish

- name: Install squid-anish role
  hosts: webserver
  roles: 
    - squid-anish
```

### Next, run this playbook.
```
ansible-navigator run ansible-galaxy-role1.yaml -m stdout
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
- src: https://github.com/vcc-caeit/ansible-role.squid/archive/1.2.1.tar.gz
  name: squid-anish
[student@workstation my-roles]$

### Pre-checks.

[student@workstation ansible]$ ansible-galaxy role list | head
# /home/student/ansible/my-roles   ⬅️ ⬅️ 👈👈👈👈 
# /usr/share/ansible/roles        ⬅️ ⬅️ 👈👈👈👈 
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
- downloading role from https://galaxy.ansible.com/downlaod/mafalb-squid-0.2.0.tar.gz
- extracting squid-anish to /home/student/.ansible/roles/squid-anish
- squid-anish  was installed successfully
[student@workstation my-roles]$


## Post checks

[student@workstation my-roles]$ ansible-galaxy role list | head
# /home/student/.ansible/roles
- zabbix-anish, (unknown version)         ⬅️ ⬅️ 👈👈👈👈 
- openafs-devops-wala, (unknown version)  ⬅️ ⬅️ 👈👈👈👈 
- squid-anish,  (unknown version)  ⬅️ ⬅️ 👈👈👈👈 
# /usr/share/ansible/roles
- linux-system-roles.certificate, (unknown version)
- linux-system-roles.cockpit, (unknown version)
- linux-system-roles.crypto_policies, (unknown version)
- linux-system-roles.firewall, (unknown version)
- linux-system-roles.ha_cluster, (unknown version)
- linux-system-roles.kdump, (unknown version)
```
