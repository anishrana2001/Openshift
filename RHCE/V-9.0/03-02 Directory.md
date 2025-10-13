
### Create a directory called `/webserver` for nginx server on `myprod` host group.
- Owner and Group of this directory should be `root` user.
- Permission 775
- Set GID (Sticky bit for group)
- Create sybmolic link with `/var/www/html/webserver`
- Create a `index.html` file with content below under `/webserver` directory.
    - `Welcome to devops-wala`
- Create a playbook with name `/home/student/ansible/webserver.yaml`

### Solution: 

[student@workstation ansible]$ cat webserver.yaml 
```
---
- name: Creating directory
  hosts: all
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
[student@workstation ansible]$



[student@workstation ansible]$ ansible-navigator run webserver.yaml -m stdout

PLAY [Creating directory] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [serverb]
ok: [serverc]
ok: [serverd]
ok: [servera]

TASK [create a webserver directory] ********************************************
changed: [serverc]
changed: [serverd]
changed: [serverb]
changed: [servera]

TASK [Create a symbolic link] **************************************************
changed: [serverb]
changed: [serverc]
ok: [serverd]
changed: [servera]

TASK [File creation] ***********************************************************
ok: [serverd]
changed: [serverb]
changed: [serverc]
changed: [servera]

PLAY RECAP *********************************************************************
servera                    : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverb                    : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverc                    : ok=4    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverd                    : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
[student@workstation ansible]$


#### Post checks.
##### Post checks selinx image.
[student@workstation ansible]$ ansible myprod -m shell -a 'ls -ldZ /var/www/html/'
serverd | CHANGED | rc=0 >>
drwxr-xr-x. 2 root root system_u:object_r:httpd_sys_content_t:s0 41 Oct 13 10:02 /var/www/html/


##### Post checks for symbolic link 
[student@workstation ansible]$ ansible myprod -m shell -a 'ls -l /var/www/html/'
serverd | CHANGED | rc=0 >>
total 4
-rw-r--r--. 1 root root 140 Oct 12 12:34 index.html
lrwxrwxrwx. 1 root root  10 Oct 13 10:02 webserver -> /webserver


##### Post checks for index.html file content.
[student@workstation ansible]$ ansible myprod -m shell -a 'cat /var/www/html/webserver/index.html'
serverd | CHANGED | rc=0 >>
Welcome to devops-wala


##### Post checks for Stickybit.
[student@workstation ansible]$ ansible myprod -m shell -a 'ls -ld /webserver/'
serverd | CHANGED | rc=0 >>
drwxrwsr-x. 2 root root 24 Oct 13 10:02 /webserver/
[student@workstation ansible]$ 


##### Post checks for webserver web page opening.
[student@workstation ansible]$ curl http://172.25.250.13/webserver/index.html ; echo
Welcome to devops-wala
[student@workstation ansible]$
```
