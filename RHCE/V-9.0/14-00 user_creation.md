## Question 1: Your task is to create 3 users on `lab` host group. Ansible playbook name must be `question1-UserAdd.yaml` under `/home/student/ansible` directory.

	- suraj
	- rajan
	- punit
---
	
## Solution:

### Creating Users one bye one. 

```
vim /home/student/ansible/question1-UserAdd.yaml
```

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
#### Execute the playbook on dryrun mode to create the user.
```
ansible-navigator run question1-UserAdd.yaml -m stdout -C
```
#### Execute the playbook to create the user.
```
ansible-navigator run question1-UserAdd.yaml -m stdout
```
### Post checks!
```
ansible lab -m shell -a 'tail -n 3 /etc/passwd'
```

```
ansible lab -m shell -a 'id suraj; id rajan; id punit'
```
```
ansible lab -m shell -a 'ls -l /home'
```
### Let's delete these users.
```
vim /home/student/ansible/question1-UserDelete.yaml
```
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
#### Execute the playbook on dryrun mode to delete the user.
```
ansible-navigator run question1-UserDelete.yaml -m stdout -C
```
#### Execute the playbook to delete the user.
```
ansible-navigator run question1-UserDelete.yaml -m stdout
```

### Post checks!
```
ansible lab -m shell -a 'tail -n 3 /etc/passwd'
```

```
ansible lab -m shell -a 'id suraj; id rajan; id punit'
```
```
ansible lab -m shell -a 'ls -l /home'
```
## Question 2: Your task is to create 3 users on `lab` host group. Ansible playbook name must be `question2-UserAdd.yaml` under `/home/student/ansible` directory. You must use the Loop.
	- suraj
	- rajan
	- punit
---
### Solution:

```
vim /home/student/ansible/question2-UserAdd.yaml
```
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
#### Execute the playbook on dryrun mode to delete the user.
```
ansible-navigator run question2-UserAdd.yaml -m stdout -C
```
#### Execute the playbook to delete the user.
```
ansible-navigator run question2-UserAdd.yaml -m stdout
```

### Post checks!
```
ansible lab -m shell -a 'tail -n 3 /etc/passwd'
```

```
ansible lab -m shell -a 'id suraj; id rajan; id punit'
```
```
ansible lab -m shell -a 'ls -l /home'
```


### How we can delete these uses with loop ?

```
vim /home/student/ansible/question2-UserDelete.yaml
```

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
#### Execute the playbook on dryrun mode to delete the user.
```
ansible-navigator run question2-UserDelete.yaml -m stdout -C
```
#### Execute the playbook to delete the user.
```
ansible-navigator run question2-UserDelete.yaml -m stdout
```
### Post checks!
```
ansible lab -m shell -a 'tail -n 3 /etc/passwd'
```

```
ansible lab -m shell -a 'id suraj; id rajan; id punit'
```
```
ansible lab -m shell -a 'ls -l /home'
```

## How to create users from file ?
#### Question 3: Your task is to create 3 users on `lab` host group from the file `/home/student/ansible/user1.yaml`. Ansible playbook name must be `question3-UserAdd.yaml` under `/home/student/ansible` directory.
	- suraj
	- rajan
	- punit
---
#### Create one file.
```
echo "---
users:
  - suraj
  - rajan
  - punit" > /home/student/ansible/user1.yaml
```

### Solution:
#### Open the File.
```
cat /home/student/ansible/user1.yaml
```
```
vim /home/student/ansible/question3-UserAdd.yaml
```
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
#### Execute the playbook on dryrun mode to delete the user.
```
ansible-navigator run question2-UserAdd.yaml -m stdout -C
```
#### Execute the playbook to delete the user.
```
ansible-navigator run question2-UserAdd.yaml -m stdout
```
### Post checks!
```
ansible lab -m shell -a 'tail -n 3 /etc/passwd'
```

```
ansible lab -m shell -a 'id suraj; id rajan; id punit'
```
```
ansible lab -m shell -a 'ls -l /home'
```

### How to delete users by using variables from File?

```
cat /home/student/ansible/user1.yaml
```
```
vim /home/student/ansible/question3-UserAdd.yaml
```
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
        state: absent
        remove: yes  # This ensures the home directory is deleted
      loop: "{{ users }}"
```
#### Execute the playbook on dryrun mode to delete the user.
```
ansible-navigator run question3-UserDelete.yaml -m stdout -C
```
#### Execute the playbook to delete the user.
```
ansible-navigator run question3-UserDelete.yaml -m stdout
```
### Post checks!
```
ansible lab -m shell -a 'tail -n 3 /etc/passwd'
```

```
ansible lab -m shell -a 'id suraj; id rajan; id punit'
```
```
ansible lab -m shell -a 'ls -l /home'
```
