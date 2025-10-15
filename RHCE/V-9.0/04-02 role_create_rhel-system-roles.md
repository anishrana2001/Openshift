## Question: Create a palybook called `/home/student/ansible/ansible-role-selinux.yaml` and below tasks must be completed.
- hosts: all 
- Must use `rhel-system-roles.selinux`
- selinux_policy: targeted
- selinux_state: enforcing
---



## Solution: 
```
cp /usr/share/doc/rhel-system-roles/selinux/example-selinux-playbook.yml example-ansible-role-selinux.yaml
```
### Remove the unwanted lines and make it like below.
```
[student@workstation ansible]$ cat ansible-role-selinux.yaml
---
- hosts: all
  become: true
  become_method: sudo
  become_user: root
  vars:
    # Use "targeted" SELinux policy type
    selinux_policy: targeted     # ⬅️ ⬅️ 👈👈👈👈 
    # Set "enforcing" mode       # ⬅️ ⬅️ 👈👈👈👈 
    selinux_state: enforcing
  tasks:
    - name: execute the role and catch errors
      block:
        - name: Include selinux role
          include_role:
            name: rhel-system-roles.selinux
      rescue:
        # Fail if failed for a different reason than selinux_reboot_required.
        - name: handle errors
          fail:
            msg: "role failed"
          when: not selinux_reboot_required

        - name: restart managed host
          reboot:

        - name: wait for managed host to come back
          wait_for_connection:
            delay: 10
            timeout: 300

        - name: reapply the role
          include_role:
            name: rhel-system-roles.selinux    #  ⬅️ ⬅️ 👈👈👈👈 
[student@workstation ansible]$
```

### Once file created, apply this playbook.
```
ansible-playbook ansible-role-selinux.yaml
```

### Post checks!!!
```
ansible all -m shell -a 'grep ^SELINUX /etc/selinux/config; getenforce'
```

```
[student@workstation ansible]$ ansible all -m shell -a 'grep ^SELINUX /etc/selinux/config; getenforce'
serverb | CHANGED | rc=0 >>
SELINUX=enforcing       ⬅️ ⬅️ 👈👈👈👈
SELINUXTYPE=targeted    ⬅️ ⬅️ 👈👈👈👈
Enforcing               ⬅️ ⬅️ 👈👈👈👈
servera | CHANGED | rc=0 >>
SELINUX=enforcing
SELINUXTYPE=targeted
Enforcing
serverc | CHANGED | rc=0 >>
SELINUX=enforcing
SELINUXTYPE=targeted
Enforcing
serverd | CHANGED | rc=0 >>
SELINUX=enforcing
SELINUXTYPE=targeted
Enforcing
[student@workstation ansible]$
```
