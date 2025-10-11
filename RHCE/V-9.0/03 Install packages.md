### Create a playbook file `/home/student/ansible/apps1.yaml`
- Install `php` and `httpd` packages on `lab`, `preprod` and `production` groups.
- Install `nginx` on `myprod` group.
- Update all packages to the latest version on group `myprod` and perform below tasks.
  - create user `rajan` on this server with UID 1330 , secondary group `devops-wala`, login shell should be `/bin/bash` and comment should be `OCP cluster`
  - Create a group called `devops-wala`.
  - Create a non login shell user `mon_ocp`
  - Password of both users should be `anishrana2001`
  - Install `RPM developement Tools` package.
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
- name: Install php and http
  hosts: myprod   ### Groups name added.
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
      name: "@Development tools"
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
        - nginx
        - http
      state: present
