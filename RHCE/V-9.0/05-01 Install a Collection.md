## Lab for this question
```
lab start role-collections
```




##  Question: Install the below collections available on `http://https://github.com/anishrana2001/Openshift/edit/main/RHCE/V-9.0/` 
- gls-utils-0.0.1.tar.gz
- community-general-5.5.0.tar.gz
- redhat-insights-1.0.7.tar.gz
- redhat-rhel_system_roles-1.19.3.tar.gz
## Please make sure that these collections must be installed on `/home/student/ansible/my-collection`

### Solution:
### Note:
### We already created a directory `/home/student/ansible/my-collection` in the first question. 

### Pre-checks!!!
```
ansible-galaxy collection list
```
### Create a file with any name `requirements.yml` so that we can remeber the option `-r`

```
vi requirements.yml
```
### For the practice purpose, you can follow like this.
```
student@workstation ansible]$ cat requirements.yml 
---
collections:
  - name: /home/student/role-collections/gls-utils-0.0.1.tar.gz
  - name: /home/student/role-collections/redhat-insights-1.0.7.tar.gz
  - name: /home/student/role-collections/redhat-rhel_system_roles-1.19.3.tar.gz
  - name: /home/student/role-collections/community-general-5.5.0.tar.gz
[student@workstation ansible]$

```
### But actually, it should be like this. If we need to download from the URL.
```
---
collections:
  - name: http://https://github.com/anishrana2001/Openshift/edit/main/RHCE/V-9.0/gls-utils-0.0.1.tar.gz
  - name: http://https://github.com/anishrana2001/Openshift/edit/main/RHCE/V-9.0/redhat-insights-1.0.7.tar.gz
  - name: http://https://github.com/anishrana2001/Openshift/edit/main/RHCE/V-9.0//redhat-rhel_system_roles-1.19.3.tar.gz
  - name: http://https://github.com/anishrana2001/Openshift/edit/main/RHCE/V-9.0//community-general-5.5.0.tar.gz
[student@workstation ansible]$
```

### Now, run the playbook with `galaxy` command.

```
ansible-galaxy collection install -r requirements.yml -p /home/student/ansible/my-collection/
```

### Post checks!!!
```
ansible-navigator collections
```

```
ansible-galaxy collection list
```
