# Question: Install RHEL role and create a playbook for ntp server with name `ntp-ploybook1.yaml`
- ntp should be installed on all the nodes
- timesync role should be used.
- ntp IP should be used `0.rhel.pool.ntp.org`
---


### Solution: 

### Install RHEL role
```
sudo yum install rhel-system-roles -y
```

### copy the file from role documentation as a reference and update the ntp IP address. 

```
cp /usr/share/doc/rhel-system-roles/timesync/example-single-pool-playbook.yml ntp-ploybook1.yaml

```

```
vi ntp-ploybook1.yaml
```

### For your references. 
```
[student@workstation playbook-manage]$ cp /usr/share/doc/rhel-system-roles/timesync/example-single-pool-playbook.yml ntp-ploybook1.yaml
[student@workstation playbook-manage]$ vi ntp-ploybook1.yaml
[student@workstation playbook-manage]$ cat ntp-ploybook1.yaml 
- name: chronyd service
- hosts: all
  vars:
    timesync_ntp_servers:
      - hostname: 0.rhel.pool.ntp.org
        pool: yes
        iburst: yes
  roles:
    - rhel-system-roles.timesync
[student@workstation playbook-manage]$
```
### Roles installed via RPM packages should be executed using ansible-playbook. while roles installed as collections should be executed using-navigator.
```
ansible-playbook ntp-ploybook1.yaml
```

### Post checks.....
```
ansible all -m shell -a 'grep 0.rhel.pool.ntp.org /etc/chrony.conf'
```

### For your references.
```
[student@workstation ansible]$ ansible all -m shell -a 'grep 0.rhel.pool.ntp.org /etc/chrony.conf'
serverc | CHANGED | rc=0 >>
pool 0.rhel.pool.ntp.org iburst
serverd | CHANGED | rc=0 >>
pool 0.rhel.pool.ntp.org iburst
serverb | CHANGED | rc=0 >>
pool 0.rhel.pool.ntp.org iburst
servera | CHANGED | rc=0 >>
pool 0.rhel.pool.ntp.org iburst
[student@workstation ansible]$
```
---

---

---

# Question 2: Install RHEL role and create a playbook for ntp server with name `ntp-ploybook2.yaml`
- ntp should be installed only on the lab group.
- timesync role should be used.
- ntp IP should be used `0.rhel.pool.ntp.org` , `1.rhel.pool.ntp.org` and `2.rhel.pool.ntp.org`
--- 

### Solution:

### Install RHEL role
```
sudo yum install rhel-system-roles -y
```

### copy the file from role documentation as a reference and update the ntp IP address. 

```
cp /usr/share/doc/rhel-system-roles/timesync/example-multiple-ntp-servers-playbook.yml ntp-ploybook2.yaml

```

```
vi ntp-ploybook2.yaml
```

```
[student@workstation playbook-manage]$ cat  ntp-ploybook2.yaml
- hosts: lab
  name: ntp server for group lab only
  vars:
    timesync_ntp_servers:
      - hostname: 0.rhel.pool.ntp.org
        iburst: yes
      - hostname: 1.rhel.pool.ntp.org
        iburst: yes
      - hostname: 2.rhel.pool.ntp.org
        iburst: yes
  roles:
    - rhel-system-roles.timesync
[student@workstation playbook-manage]$
```


### Roles installed via RPM packages should be executed using ansible-playbook. while roles installed as collections should be executed using-navigator.
```
ansible-playbook ntp-ploybook2.yaml
```

### Post checks.....
```
ansible all -m shell -a 'grep 0.rhel.pool.ntp.org /etc/chrony.conf'
```
