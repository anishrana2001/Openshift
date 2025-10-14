## Question: Create an Ansible playbook with the following requirements:
- Name the playbook `myfile-q2.yaml` and place it in `/home/student/ansible`.
- Create a directory named `/secured_data`.
- Create a file named `/secured_data/secret.txt`.
- Set the permissions of the `directory` to `0700` and the `file` to `0600`.
- If setting permissions to the file or directory fails, print the error message `Could not set strict permissions!`
- If the directory `/secured_data` does not exist and cannot be created, print the error message `Directory /secured_data could not be created, please check!`
- After any failure, ensure no leftover file is present at /secured_data/secret.txt.

---

### Solution: 

### Create a file.

```
---
- name: Secure file and directory creation with error handling
  hosts: all
  become: true
  tasks:

    - block:
        - name: Create /secured_data directory
          ansible.builtin.file:
            path: /secured_data
            state: directory
            mode: '0700'

        - name: Create /secured_data/secret.txt file
          ansible.builtin.file:
            path: /secured_data/secret.txt
            state: touch
            mode: '0600'

      rescue:
        - name: Print error if directory or file cannot be created with strict permissions
          ansible.builtin.debug:
            msg: "Could not set strict permissions!"
        - name: Cleanup possible leftover file if error occurs
          ansible.builtin.file:
            path: /secured_data/secret.txt
            state: absent

    - name: Fail if directory creation failed entirely
      ansible.builtin.fail:
        msg: "Directory /secured_data could not be created, please check!"
      when: not (ansible_facts['files']['/secured_data'] is defined and ansible_facts['files']['/secured_data']['exists'])

````
