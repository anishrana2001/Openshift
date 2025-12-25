### Question 4-01: Create users.

- Your task is to create only a users who has description `manager` on `lab` host group from the file `user2.yaml`.
- Your task is to create only a users who has description `intern` on `myprod` host group from the file `user2.yaml`.
- user2.yaml 
```
users:
  - name: punit
    job: manager
  - name: rajan
    job: engineer
  - name: rajesh
    job: manager
  - name: sunil
    job: intern
```
---

### Solution:

```
vim question4-UserAdd.yaml
```
```
---
- name: Create Managers on Lab hosts
  hosts: lab
  become: true
  vars_files:
    - /home/student/ansible/user2.yaml

  tasks:
    - name: Create users with job 'manager'
      ansible.builtin.user:
        name: "{{ item.name }}"
        state: present
      loop: "{{ users }}"
      when: item.job == 'manager'

- name: Create Interns on Myprod hosts
  hosts: myprod
  become: true
  vars_files:
    - /home/student/ansible/user2.yaml

  tasks:
    - name: Create users with job 'intern'
      ansible.builtin.user:
        name: "{{ item.name }}"
        state: present
      loop: "{{ users }}"
      when: item.job == 'intern'

```

```
ansible-navigator run question4-UserAdd.yaml -m stdout
```
### Post checks
```
ansible lab -m shell -a 'tail -n 3 /etc/passwd'
```
```
ansible lab -m shell -a 'id suraj; id rajan; id punit'
```
```
ansible lab -m shell -a 'ls -l /home'
```

### Question 4-02: Delete users.

- Your task is to delete only a users who has description `manager` on `lab` host group from the file `user2.yaml`.
- Your task is to delete only a users who has description `intern` on `myprod` host group from the file `user2.yaml`.
---

### Solution:

```
vim question4-UserDelete.yaml
```

```
---
- name: Delete Managers on Lab hosts
  hosts: lab
  become: true
  vars_files:
    - /home/student/ansible/user2.yaml

  tasks:
    - name: Delete users with job 'manager'
      ansible.builtin.user:
        name: "{{ item.name }}"
        state: absent
        remove: yes   # This ensures the home directory is deleted
      loop: "{{ users }}"
      when: item.job == 'manager'

- name: Delete Interns on Myprod hosts
  hosts: myprod
  become: true
  vars_files:
    - /home/student/ansible/user2.yaml

  tasks:
    - name: Delete users with job 'intern'
      ansible.builtin.user:
        name: "{{ item.name }}"
        state: absent
        remove: yes   # This ensures the home directory is deleted
      loop: "{{ users }}"
      when: item.job == 'intern'
```

```
ansible-navigator run question4-UserDelete.yaml -m stdout
```
### Post checks
```
ansible lab -m shell -a 'tail -n 3 /etc/passwd'
```
```
ansible lab -m shell -a 'id suraj; id rajan; id punit'
```
```
ansible lab -m shell -a 'ls -l /home'
```

## How to clear the lab?
```
rm -rf question4-UserAdd.yaml question4-UserDelete.yaml  user2.yaml 
```
