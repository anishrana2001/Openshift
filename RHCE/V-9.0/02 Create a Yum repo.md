
### Question: You need to create a yum repo file with the help of Ansible on all the nodes. 

### Solution: 

### A good thing is that, we can take the help of Ansible documentation for creating a Ansible playbook. 
### Modify the values as per the question demands. 
```
[student@workstation ~]$ ansible-doc -l | grep yum
yum                                            Manages packages with the `y...
yum_repository                                 Add or remove YUM repositori...
[student@workstation ~]$ 

[student@workstation ~]$ ansible-doc yum_repository  

```


### Lets' create our own ansible playbook.
```
---
- name: Config yum repo
  hosts: all
  tasks:
  - name: first repo
    ansible.builtin.yum_repository:
       name: rpmforge
       description: RPMforge YUM repo
       file: external_repos
       baseurl: http://content.example.com/rhel9.0/x86_64/dvd/BaseOS
       enabled: yes
       gpgcheck: no
```
