### Question 4-01: Create users.
- Download the user list from https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCE/V-9.0/user_list-14-01.yaml
- Use the Vault password file /home/student/ansible/pass-vault.yml that you created on task 12-01.
- Your task is to create only a users who has description `manager` on `lab` host group from the file `user_list-14-01.yaml`. Use the password pw_punit variable.
- Your task is to create only a users who has description `intern` on `myprod` host group from the file `user_list-14-01.yaml`. Assign the password pw_rajan
---

### Solution:

```
vim create_users_role.yaml
```
```
---
- name: Create Managers on Lab hosts
  hosts: lab
  become: true
  vars_files:
    - /home/student/ansible/pass-vault.yml
    - /home/student/ansible/user2.yaml

  tasks:
    - name: Create users with job 'manager'
      ansible.builtin.user:
        name: "{{ item.name }}"
        state: present
		password: "{{ pw_punit | password_hash('sha512') }}"
      loop: "{{ users }}"
      when: item.job == 'manager'

- name: Create Interns on Myprod hosts
  hosts: myprod
  become: true
  vars_files:
    - /home/student/ansible/pass-vault.yml
    - /home/student/ansible/user2.yaml

  tasks:
    - name: Create users with job 'intern'
      ansible.builtin.user:
        name: "{{ item.name }}"
        state: present
		password: "{{ pw_rajan | password_hash('sha512') }}"
      loop: "{{ users }}"
      when: item.job == 'intern'

```

```
ansible-navigator  run create_users_role.yaml -m stdout
```


### Question 4-02: Delete users.

- Your task is to delete only a users who has description `manager` on `lab` host group from the file `user2.yaml`.
- Your task is to delete only a users who has description `intern` on `myprod` host group from the file `user2.yaml`.
---

### Solution:

```
vim create_users_del_role.yaml
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
ansible-navigator  run create_users_del_role.yaml -m stdout
```
