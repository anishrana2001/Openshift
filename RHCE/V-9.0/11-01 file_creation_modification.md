### Download and then modify the file.
  - Create a playbook named `gather-information1.yaml` in the `/home/student/ansible` directory.
  - playbook should download the file and name it `node_information.yaml` in the `/root` directory.
  - `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCE/V-9.0/gather_information-11.yaml`
  - Modify this file `node_information.yaml` with inventory hostname.
  - Should run on all hosts in the inventory file.

### Solution:

### Get the help for "how to download the file in the playbook?"

```
ansible-doc get_url
```
```
EXAMPLES:

- name: Download foo.conf
  ansible.builtin.get_url:
    url: http://example.com/path/file.conf
    dest: /etc/foo.conf
    mode: '0440'
```

### Get the help for "how to modify the file. 
```
ansible-doc -l | grep lineinfile
```
```
ansible-doc ansible.builtin.lineinfile
```
### you will find.
```
EXAMPLES:

# NOTE: Before 2.3, option 'dest', 'destfile' or 'name' was used instead of 'path'
- name: Ensure SELinux is set to enforcing mode
  ansible.builtin.lineinfile:
    path: /etc/selinux/config
    regexp: '^SELINUX='
    line: SELINUX=enforcing
```


### Now, let's create an ansible playbook
```
---
- name: Gather information
  hosts: all
  tasks:
    - name: Download foo.conf
      ansible.builtin.get_url:
        url: https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCE/V-9.0/gather_information-11.yaml
        dest: /root/node_information.yaml

    - name: Ensure SELinux is set to enforcing mode
      ansible.builtin.lineinfile:
        path: /root/node_information.yaml
        regexp: '^HOST='
        line: "HOST={{ inventory_hostname }}"
```

### Run the playbook.
```
ansible-navigator run gather-information1.yaml -m stdout
```

### Post checks.
```
ansible servera -m shell -a "cat /root/node_information.yaml"
```

### For your reference.
```

student@workstation ansible]$ cat  gather-information1.yaml
---
- name: Gather information
  hosts: all
  tasks:
    - name: Download foo.conf
      ansible.builtin.get_url:
        url: https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCE/V-9.0/gather_information-11.yaml
        dest: /root/node_information.yaml

    - name: Ensure SELinux is set to enforcing mode
      ansible.builtin.lineinfile:
        path: /root/node_information.yaml
        regexp: '^HOST='
        line: "HOST={{ inventory_hostname }}"
[student@workstation ansible]$


[student@workstation ansible]$ ansible-navigator run gather-information1.yaml -m stdout

PLAY [Gather information] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [serverc]
ok: [serverb]
ok: [servera]
ok: [serverd]

TASK [Download foo.conf] *******************************************************
changed: [servera]
changed: [serverb]
changed: [serverd]
changed: [serverc]

TASK [Ensure SELinux is set to enforcing mode] *********************************
changed: [serverc]
changed: [serverb]
changed: [servera]
changed: [serverd]

PLAY RECAP *********************************************************************
servera                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverb                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverc                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverd                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
[student@workstation ansible]$ 


[student@workstation ansible]$ ansible servera -m shell -a "cat /root/node_information.yaml"
servera | CHANGED | rc=0 >>
### Below are the details of nodes.
HOST=servera
[student@workstation ansible]$ 

```
