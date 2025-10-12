
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


### Solution:



### For your references.
```
[student@workstation ansible]$ ansible-navigator run ansible-yum-repo.yaml -m stdout

PLAY [yum repo] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [serverb]
ok: [serverc]
ok: [serverd]
ok: [servera]

TASK [baseos] ******************************************************************
changed: [servera]
changed: [serverb]
changed: [serverd]
changed: [serverc]

TASK [appstream] ***************************************************************
changed: [servera]
changed: [serverb]
changed: [serverc]
changed: [serverd]

PLAY RECAP *********************************************************************
servera                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverb                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverc                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverd                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
[student@workstation ansible]$
```


### Post checks 


```
[student@workstation ansible]$ ansible all -m command -a 'dnf repolist all'
serverc | CHANGED | rc=0 >>
repo id                                                repo name         status
ansible-automation-platform-2.2-for-rhel-9-x86_64-rpms Red Hat Ansible A enabled
appstream                                              App Description   enabled
baseos                                                 Baseos Descriptio enabled
rhel-9-for-x86_64-appstream-rpms                       Red Hat Enterpris enabled
rhel-9-for-x86_64-appstream-rpms-updates               Red Hat Enterpris enabled
rhel-9-for-x86_64-baseos-rpms                          Red Hat Enterpris enabled
rhel-9-for-x86_64-baseos-rpms-updates                  Red Hat Enterpris enabled
serverd | CHANGED | rc=0 >>
repo id                                                repo name         status
ansible-automation-platform-2.2-for-rhel-9-x86_64-rpms Red Hat Ansible A enabled
appstream                                              App Description   enabled
baseos                                                 Baseos Descriptio enabled
rhel-9-for-x86_64-appstream-rpms                       Red Hat Enterpris enabled
rhel-9-for-x86_64-appstream-rpms-updates               Red Hat Enterpris enabled
rhel-9-for-x86_64-baseos-rpms                          Red Hat Enterpris enabled
rhel-9-for-x86_64-baseos-rpms-updates                  Red Hat Enterpris enabled
serverb | CHANGED | rc=0 >>
repo id                                                repo name         status
ansible-automation-platform-2.2-for-rhel-9-x86_64-rpms Red Hat Ansible A enabled
appstream                                              App Description   enabled
baseos                                                 Baseos Descriptio enabled
rhel-9-for-x86_64-appstream-rpms                       Red Hat Enterpris enabled
rhel-9-for-x86_64-appstream-rpms-updates               Red Hat Enterpris enabled
rhel-9-for-x86_64-baseos-rpms                          Red Hat Enterpris enabled
rhel-9-for-x86_64-baseos-rpms-updates                  Red Hat Enterpris enabled
servera | CHANGED | rc=0 >>
repo id                                                repo name         status
ansible-automation-platform-2.2-for-rhel-9-x86_64-rpms Red Hat Ansible A enabled
appstream                                              App Description   enabled
baseos                                                 Baseos Descriptio enabled
rhel-9-for-x86_64-appstream-rpms                       Red Hat Enterpris enabled
rhel-9-for-x86_64-appstream-rpms-updates               Red Hat Enterpris enabled
rhel-9-for-x86_64-baseos-rpms                          Red Hat Enterpris enabled
rhel-9-for-x86_64-baseos-rpms-updates                  Red Hat Enterpris enabled
[student@workstation ansible]$
```


### You can use the ansible-navigator run --syntax-check command to validate the syntax of a playbook. 


### You can use the `--check` option to run the playbook in check mode, which performs a "dry run" of the playbook. This causes Ansible to report what changes would have occurred if the playbook were executed, but does not make any changes.
