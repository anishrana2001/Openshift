### From the below task, we get to know that how to call the variables from multipl files. For an example, let's add the users.

### Question: Your task is to create a user and then add a secondary group. Perform the below tasks
- Download the user list from `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCE/V-9.0/user_list-14-01.yaml`
- Use the Vault password file `/home/student/ansible/pass-vault.yml` that you created on task 12-01.
- Use the job description `manager`
  -   create a user on `lab` host managed group.
  -   use the password `pw_punit` variable.
  -   It should be the part of `devops` group.
- Use the job description `engineer`.
  - Create a user on `myprod` and `prodcution` host managed group.
  - Assign the password `pw_rajan`
  - The secondary group should be `mon_agent`.
- Password should use `SHA512` hash format.
- Create a playbook called `myuser-list.yaml` under `/home/student/ansible` directory.
---

## Solution:
### Step 1: Download the User List
#### First, download the required variable file to your directory.

```
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCE/V-9.0/user_list-14-01.yaml -O /home/student/ansible/user_list-14-01.yaml
```
### Step 2: Create the Playbook
#### Create the file `/home/student/ansible/myuser-list.yaml` with the content below.

### Explanation of the logic:

- Vars Files: We load both the vault file (for passwords) and the downloaded user list.
- Conditionals (when): We loop through the users list and check the job attribute to decide which users to create.
- Password Hashing: We use | password_hash('sha512') on the variable keys (pw_punit, pw_rajan) loaded from the vault.
- Target Groups: lab for managers; myprod and prodcution for engineers.



```
---
- name: Create Managers on Lab hosts
  hosts: lab
  become: true
  vars_files:
    - /home/student/ansible/pass-vault.yml
    - /home/student/ansible/user_list-14-01.yaml

  tasks:
    - name: Ensure secondary group 'devops' exists
      ansible.builtin.group:
        name: devops
        state: present

    - name: Create Manager users
      ansible.builtin.user:
        name: "{{ item.name }}"
        password: "{{ pw_punit | password_hash('sha512') }}"
        groups: devops
        append: yes
        state: present
        shell: /bin/bash
      loop: "{{ users }}"
      when: item.job == 'manager'

- name: Create Engineers on Production hosts
  hosts: myprod, prodcution
  become: true
  vars_files:
    - /home/student/ansible/pass-vault.yml
    - /home/student/ansible/user_list-14-01.yaml

  tasks:
    - name: Ensure secondary group 'mon_agent' exists
      ansible.builtin.group:
        name: mon_agent
        state: present

    - name: Create Engineer users
      ansible.builtin.user:
        name: "{{ item.name }}"
        password: "{{ pw_rajan | password_hash('sha512') }}"
        groups: mon_agent
        append: yes
        state: present
        shell: /bin/bash
      loop: "{{ users }}"
      when: item.job == 'engineer'

```

#### Step 3: Run the Playbook
#### Run the playbook providing the vault password (or using the password file if configured).
```
ansible-playbook myuser-list.yaml --ask-vault-pass
```
