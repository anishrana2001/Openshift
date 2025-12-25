### Question 4-01: Create users.

- Your task is to create only a users who has description `manager` on `lab` host group from the file `user2.yaml`.
- Your task is to create only a users who has description `intern` on `myprod` host group from the file `user2.yaml`.

---

### Solution:


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



### Question 4-02: Delete users.

- Your task is to delete only a users who has description `manager` on `lab` host group from the file `user2.yaml`.
- Your task is to delete only a users who has description `intern` on `myprod` host group from the file `user2.yaml`.
---

### Solution:


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
