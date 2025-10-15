# Question: Your task is to create a role named `mywebserver` and this role must complet the below jobs.
1. `Install` and `start` the `httpd` web server.
2. Make sure `firewall` is `enabled` and `firewall should allow to listing web traffic.`
3. create a `index.html` file with below content under `/var/www/html/` directory on `webserver` host group.
    - Welcome to devops-wala web page hosted on `HOSTNAME` having ip `IP` and runing on OS `OS NAME` with architecture `Architecture details`
    - HOSTNAME = Managed node fully qulified domain name.
    - IP = Managed node IP address.
    - OS NAME = Managed node OS name.
    - Architecture details = Managed node Architecture details like x86_64
4. Create a playbook with named `mywebserver.yaml`
---

## Solution: 
  
### For the lab environment, you need to upgrade the ansible.
```
pip install --user --upgrade ansible
```

#### As we know that we can create a role from `ansible-galaxy` command. The dot "." is for current directory. `mywebserver` is the role name.
```
ansible-galaxy role init mywebserver
```
### Step 1. Let's create a file first to complete 3rd point.
3. create a `index.html` file with below content under `/var/www/html/` directory on `webserver` host group.
    - Welcome to devops-wala web page hosted on `HOSTNAME` having ip `IP` and runing on OS `OS NAME` with architecture `Architecture details`
    - HOSTNAME = Managed node fully qulified domain name.
    - IP = Managed node IP address.
    - OS NAME = Managed node OS name.
    - Architecture details = Managed node Architecture details like x86_64

### How we can get the variable name?
```
ansible servera -m setup | egrep -i "hostname|ipv4|family|architecture"
```

### As per the question demand, adjust the variables.
```
vim /home/student/ansible/my-roles/mywebserver/templates/devops-wala-template.txt 
```
### Like below.
```
[student@workstation ansible]$ cat /home/student/ansible/my-roles/mywebserver/templates/devops-wala-template.txt 
Welcome to devops-wala web page hosted on {{ ansible_fqdn }} having IP {{ ansible_default_ipv4.address }} and runing on OS {{ ansible_os_family }} with architecture  {{ ansible_architecture }}
[student@workstation ansible]$ 
```

### Next, we can create a file `mywebserver/tasks/main.yml` to complete below 2 tasks.

1. Install and start the httpd web server.
2. Make sure firewall is `enabled` and firewall should allow to listing web traffic.

```
vim mywebserver/tasks/main.yml 
```

```
---
# tasks file for mywebserver
- name: Install the httpd package
  ansible.builtin.yum:
    name: httpd
    state: present

- name: Make sure a service httpd unit is running
  ansible.builtin.systemd:
    state: started
    name: httpd
    enabled: yes

- name: Enable service firewalld
  ansible.builtin.systemd:
    name: firewalld
    enabled: yes
    state: started


- name: Enable Web service for firewalld  
  ansible.builtin.firewalld:
    service: http.   ### Make sure it is http not httpd
    state: enabled
    permanent: true
    immediate: yes

- name: Createing a file.  ### we created this file in step 1.
  template:
    src: devops-wala-template.txt
    dest: /var/www/html/index.html
```


### In Step 3, we will going to complete task "4. Create a playbook with named `mywebserver.yaml`"
```
vim /home/student/ansible/mywebserver.yaml
```
```
---
- name: Deploying role
  hosts: webserver
  roles:
    - mywebserver
```
### Now, run the playbook.
```
ansible-navigator run mywebserver.yaml -m stdout
```

### Post checks.
```
ansible webserver -m shell -a 'cat /var/www/html/index.html'
```

```
ansible webserver - a 'systemctl status httpd'
ansible webserver - a 'firewall -cmd --list-all'
ansible webserver  --list -hosts
curl http://serverc
curl http://serverd
```
### For your refrences.
```
ansible-galaxy role init --init-path . mywebserver

[student@workstation ansible]$ ansible servera -m setup | egrep -i "hostname|ipv4|ansible_os_family|ansible_architecture"
        "ansible_all_ipv4_addresses": [
        "ansible_architecture": "x86_64",
        "ansible_default_ipv4": {
                "tx_checksum_ipv4": "off [fixed]",
            "ipv4": {
                "tx_checksum_ipv4": "off [fixed]",
        "ansible_hostname": "servera",
                "tx_checksum_ipv4": "off [fixed]",
            "ipv4": {
        "ansible_os_family": "RedHat",
[student@workstation ansible]$ 


[student@workstation ansible]$ cat /home/student/ansible/my-roles/mywebserver/templates/devops-wala-template.txt 
Welcome to devops-wala web page hosted on {{ ansible_fqdn }} having IP {{ ansible_default_ipv4.address }} and runing on OS {{ ansible_os_family }} with architecture  {{ ansible_architecture }}
[student@workstation ansible]$ 


vim mywebserver/tasks/main.yml 

[student@workstation ansible]$ cat my-roles/mywebserver/tasks/main.yml 
---
# tasks file for mywebserver
- name: Install the httpd package
  ansible.builtin.yum:
    name: httpd
    state: present

- name: Make sure a service unit is running
  ansible.builtin.systemd:
    state: started
    name: httpd
    enabled: yes

- name: Enable service firewalld
  ansible.builtin.systemd:
    name: firewalld
    enabled: yes
    state: started


- name: Enable Web service for firewalld  
  ansible.builtin.firewalld:
    service: http
    state: enabled
    permanent: true
    immediate: yes

- name: Createing a file
  template:
    src: devops-wala-template.txt
    dest: /var/www/html/index.html
[student@workstation ansible]$


[student@workstation ansible]$ cat /home/student/ansible/mywebserver.yaml
---
- name: Deploying role
  hosts: webserver
  roles:
    - mywebserver
[student@workstation ansible]$ 


[student@workstation my-roles]$ tree mywebserver/
mywebserver/
├── defaults
│   └── main.yml
├── files
├── handlers
│   └── main.yml
├── meta
│   └── main.yml
├── README.md
├── tasks
│   └── main.yml
├── templates
│   └── devops-wala-template.txt
├── tests
│   ├── inventory
│   └── test.yml
└── vars
    └── main.yml

8 directories, 9 files
[student@workstation my-roles]$ 


[student@workstation ansible]$ ansible-navigator run mywebserver.yaml -m stdout

PLAY [Deploying role] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [serverc]
ok: [serverd]

TASK [mywebserver : Install the httpd package] *********************************
ok: [serverd]
ok: [serverc]

TASK [mywebserver : Make sure a service unit is running] ***********************
ok: [serverc]
ok: [serverd]

TASK [mywebserver : Enable service firewalld] **********************************
ok: [serverc]
ok: [serverd]

TASK [mywebserver : Enable Web service for firewalld] **************************
changed: [serverc]
changed: [serverd]

TASK [mywebserver : Createing a file] ******************************************
changed: [serverc]
changed: [serverd]

PLAY RECAP *********************************************************************
serverc                    : ok=6    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
serverd                    : ok=6    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
[student@workstation ansible]$ 

[student@workstation ansible]$ ansible webserver -m shell -a 'cat /var/www/html/index.html'
serverd | CHANGED | rc=0 >>
Welcome to devops-wala web page hosted on serverd.lab.example.com having IP 172.25.250.13 and runing on OS RedHat with architecture x86_64
serverc | CHANGED | rc=0 >>
Welcome to devops-wala web page hosted on serverc.lab.example.com having IP 172.25.250.12 and runing on OS RedHat with architecture x86_64
[student@workstation ansible]$ 


[student@workstation ansible]$ curl http://172.25.250.13
Welcome to devops-wala web page hosted on serverd.lab.example.com having ip 172.25.250.13 and runing on OS RedHat with architecture x86_64
[student@workstation ansible]$ curl http://172.25.250.12
Welcome to devops-wala web page hosted on serverc.lab.example.com having ip 172.25.250.12 and runing on OS RedHat with architecture x86_64
[student@workstation ansible]$


```
