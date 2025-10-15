### Create a playbook file `/home/student/ansible/apps1.yaml`
- Install `php` and `httpd` packages on `lab`, `preprod` and `production` groups.
- Install `nginx` on `myprod` group.
- Update all packages to the latest version on group `myprod` and perform below tasks.
  - create user `rajan` on this server with UID 1330 , secondary group `devops-wala`, login shell should be `/bin/bash` and comment should be `OCP cluster`
  - Create a group called `devops-wala`.
  - Create a non login shell user `mon_ocp`
  - Password of both users should be `anishrana2001`
  - Install `RPM development Tools` package.
---


### Solution:

```
ansible-doc  -l | grep yum
ansible-doc yum
```
### You will observe below output.
```
EXAMPLES:

- name: Install the latest version of Apache
  ansible.builtin.yum:
    name: httpd
    state: latest
```

### Let's create our own ansible playbook.
```

---
- name: Managed Node Setup
  hosts: serverd
  become: true

  tasks:
    # First, fix the dependency issue
    - name: Install/Upgrade PyOpenSSL and Cryptography to compatible versions
      ansible.builtin.pip:
        name:
          - "pyopenssl==23.2.0"
          - "cryptography==41.0.7"
        state: present
        executable: pip3
- name: Install httpd,update,development tools,users and group
  hosts: myprod   ### Groups name added.
  become: yes
  tasks:
    - name: Install the latest version of nginx
      ansible.builtin.yum:
        name: nginx
        state: latest
    - name: Upgrade all packages, excluding kernel & foo related packages
      ansible.builtin.yum:
        name: '*'
        state: latest
    - name: Install the 'Development tools' package group
      ansible.builtin.yum:
        name: "@RPM Development Tools"
        state: present
    - name: Create a group called 'devops-wala'
      ansible.builtin.group:
          name: devops-wala
          state: present # Ensures the group exists
    - name: Create user 'rajan' and add to 'devops-wala' group
      ansible.builtin.user:
          name: rajan
          comment: "OCP cluster"
          password: "{{ 'anishrana2001' | password_hash('sha512') }}" # Hash the password securely
          groups: devops-wala
          append: true # Add to the group without removing from others
          state: present
          uid: 1330
          shell: /bin/bash # Specify the default shell
    - name: Create user 'mon_ocp' 
      ansible.builtin.user:
          name: mon_ocp
          password: "{{ 'anishrana2001' | password_hash('sha512') }}" # Hash the password securely
          state: present
          shell: /sbin/nologin # Specify the default shell


- name: Install php and http
  hosts: lab,preprod,production   ### Groups name separated by comma(,).
  tasks:
    - name: Install the latest version of Apache
      ansible.builtin.yum:
        name:
          - php
          - httpd
        state: present
```

### You can check the syntax error on this playbook.
```
[student@workstation ansible]$ ansible-navigator run apps1.yaml -m stdout --syntax-check
playbook: /home/student/ansible/apps1.yaml
```


### Dry-run 
```
[student@workstation ansible]$ ansible-navigator run apps1.yaml -m stdout --check

PLAY [Apps installation on multiple nodes.] ************************************

TASK [Gathering Facts] *********************************************************
ok: [serverd]
ok: [servera]
ok: [serverb]
ok: [serverc]

TASK [Install packages php and httpd] ******************************************
changed: [servera]
changed: [serverc]
changed: [serverd]
changed: [serverb]

PLAY [NGINX Apps installation on myprod] ***************************************

TASK [Gathering Facts] *********************************************************
ok: [serverd]

TASK [Install packages nginx] **************************************************
changed: [serverd]

TASK [Upgrade all packages] ****************************************************
changed: [serverd]

TASK [Install the 'Development tools' package group] ***************************
changed: [serverd]

TASK [Added a consultant whose account you want to expire] *********************
changed: [serverd]

PLAY RECAP *********************************************************************
servera                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverb                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverc                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverd                    : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
[student@workstation ansible]$ ansible-navigator run apps1.yaml -m stdout 
```

### Run the below command to apply this playbook.
```
ansible-navigator run apps1.yaml -m stdout
```


### Post checks!!

### Check the php and httpd pacakges are installed or not ?

```
ansible lab,preprod,production -a 'rpm -q php httpd' 
```

```
[student@workstation ansible]$ ansible lab,preprod,production -a 'rpm -q php httpd'
servera | CHANGED | rc=0 >>
php-8.0.13-1.el9.x86_64
httpd-2.4.51-7.el9_0.x86_64
serverd | CHANGED | rc=0 >>
php-8.0.13-1.el9.x86_64
httpd-2.4.51-7.el9_0.x86_64
serverc | CHANGED | rc=0 >>
php-8.0.13-1.el9.x86_64
httpd-2.4.51-7.el9_0.x86_64
serverb | CHANGED | rc=0 >>
php-8.0.13-1.el9.x86_64
httpd-2.4.51-7.el9_0.x86_64
[student@workstation ansible]$ 

```


####  Checking for RPM Depolyment Tools.
```
ansible myprod -a 'yum grouplist'
```

```
[student@workstation ansible]$ ansible myprod -a 'yum grouplist'
serverd | CHANGED | rc=0 >>
Last metadata expiration check: 0:20:58 ago on Sun 12 Oct 2025 02:27:46 AM EDT.
Available Environment Groups:
   Server with GUI
   Server
   Minimal Install
   Workstation
   Custom Operating System
   Virtualization Host
Installed Groups:
   RPM Development Tools
Available Groups:
   Legacy UNIX Compatibility
   Console Internet Tools
   Container Management
   Development Tools
   .NET Development
   Graphical Administration Tools
   Headless Management
   Network Servers
   Scientific Support
   Security Tools
   Smart Card Support
   System Tools
[student@workstation ansible]$ 
```


