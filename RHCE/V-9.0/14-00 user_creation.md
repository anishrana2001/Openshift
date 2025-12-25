## Question 1: Your task is to create 3 users on `lab` host group. Ansible playbook name must be `question1.yaml` under `/home/student/ansible` directory.
	- suraj
	- rajan
	- punit
---
	
## Solution:

### Creating Users one bye one. 

```
---
- name: Demo - Looping through user list
  hosts: lab
  tasks:
    - name: Create user `suraj` 
      ansible.builtin.user:
          name: suraj
		  state: present

    - name: Create user 'rajan'
      ansible.builtin.user:
          name: rajan
		  state: present

    - name: Create user ‘Punit’ 
      ansible.builtin.user:
          name: punit
		  state: present
...
```
### Let's delete these users.
```
---
- name: Demo - Looping through user list
  hosts: lab
  tasks:
    - name: Create user `suraj` 
      ansible.builtin.user:
          name: suraj
		  state: absent
		  remove: yes  # This ensures the home directory is deleted

    - name: Create user 'rajan'
      ansible.builtin.user:
          name: rajan
		  state: absent
		  remove: yes  # This ensures the home directory is deleted

    - name: Create user ‘Punit’ 
      ansible.builtin.user:
          name: punit
		  state: absent
		  remove: yes  # This ensures the home directory is deleted
...
```

### This time, creating users from loop.
```
---
- name: Creating users
  hosts: lab
  tasks:
    - name: creating users from loop
      user:
        name: "{{ item }}"
        state: present
      loop: 
        - suraj
        - rajan
        - punit
```

### How we can delete these uses with loop ?
```
---
- name: Delete users and their home directories
  hosts: lab
  become: true
  tasks:
    - name: Remove users suraj, rajan, and punit
      ansible.builtin.user:
        name: "{{ item }}"
        state: absent
        remove: yes  # This ensures the home directory is deleted
      loop:
        - suraj
        - rajan
        - punit
```

### How to create users from file ?

```
---
- name: Create required users
  hosts: lab
  vars_files:
    - /home/student/ansible/user1.yaml

  tasks:
    - name: Create users suraj, rajan, and punit
      ansible.builtin.user:
        name: "{{ item }}"
        state: present
      loop: "{{ users }}"

```
