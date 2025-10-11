
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
