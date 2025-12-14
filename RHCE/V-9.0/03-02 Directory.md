
### Create a directory called `/webserver` for nginx server on `lab` host group.
- Owner and Group of this directory should be `root` user.
- Permission 775
- Set GID (Sticky bit for group)
- Create sybmolic link of directory `/webserver` to `/var/www/html/webserver`
- Create a `index.html` file with content below under `/webserver` directory.
    - `Welcome to devops-wala`
- Create a playbook with name `/home/student/ansible/webserver.yaml`

### Solution: 

[student@workstation ansible]$ cat webserver.yaml 

```
cat > webserver.yaml
```
```
---
- name: Creating directory
  hosts: lab
  tasks:
    - name: create a webserver directory
      ansible.builtin.file:
        path: /webserver
        state: directory
        owner: root
        group: root
        mode: '2775'

    - name: Create a symbolic link
      ansible.builtin.file:
        src: /webserver
        dest: /var/www/html/webserver
        state: link

    - name: File creation
      ansible.builtin.copy:
        content: 'Welcome to devops-wala'
        dest: /webserver/index.html
        setype: httpd_sys_content_t
```

### Run the playbook
```
ansible-navigator run webserver.yaml -m stdout
```
#### Post checks.
##### Post checks selinx image.
```
ansible myprod -m shell -a 'ls -ldZ /var/www/html/'
```
##### Post checks for symbolic link 
```
ansible myprod -m shell -a 'ls -l /var/www/html/'
```
##### Post checks for index.html file content.
```
ansible myprod -m shell -a 'cat /var/www/html/webserver/index.html'
```
```
ansible myprod -m shell -a 'ls -ldZ  /var/www/html/webserver/index.html'
```
```
ansible myprod -m shell -a 'ls -ldZ  /webserver/index.html'
```
##### Post checks for Stickybit.
```
ansible myprod -m shell -a 'ls -ld /webserver/'
```



##### Post checks for webserver web page opening.
```
[student@workstation ansible]$ curl http://172.25.250.13/webserver/index.html ; echo
Welcome to devops-wala
[student@workstation ansible]$
```
