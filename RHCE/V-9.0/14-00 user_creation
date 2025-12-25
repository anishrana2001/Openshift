## Question 1: Your task is to create 3 users on `lab` host group. Ansible playbook name must be `question1.yaml` under `/home/student/ansible` directory.
	- suraj
	- rajan
	- punit
---
	
## Solution:



| User creation                                    | User deletion             |
| -                                                | -                         |
|---                                               |---                |
|- name: Demo - Adding user list      |   
|  hosts: lab    |
|  tasks:   |
|    - name: Create user `suraj`       |
|      ansible.builtin.user:         |
|         name: suraj        |
|		     state: present        |
|        |
|    - name: Create user 'rajan'        |
|      ansible.builtin.user:        |
|          name: rajan        |
|		      state: present        |
|        |
|    - name: Create user ‘Punit’         |
|      ansible.builtin.user:        |
|          name: punit        |
|		      state: present        |
|...        |

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
