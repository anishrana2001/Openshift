

## Your task is to uninstall the `httpd` package from `webserver` host group. You also need to stop and disable the `httpd` service. 
  - Make sure `http` service is not allowed on firewalld.
  - Custom file `/var/www/html/index.html` should also be removed.
  - Create a playbook with name `remove-mywebserver.yaml` under `/home/student/ansible` directory.
---

### Solution:

### Create a playbook. 

```
vim remove-mywebserver.yaml
```
```
---
- name: remove mywebserver configuration
  hosts: webserver
  become: true

  tasks:
    - name: Remove custom index.html
      ansible.builtin.file:
        path: /var/www/html/index.html
        state: absent

    - name: Disable http service in firewalld
      ansible.posix.firewalld:
        service: http
        state: disabled
        permanent: true
        immediate: true

    - name: Stop and disable httpd service
      ansible.builtin.systemd:
        name: httpd
        state: stopped
        enabled: false

    - name: Remove httpd package
      ansible.builtin.yum:
        name: httpd
        state: absent
```

### Run the playbook.
```
ansible-navigator run remove-mywebserver.yaml -m stdout
```
