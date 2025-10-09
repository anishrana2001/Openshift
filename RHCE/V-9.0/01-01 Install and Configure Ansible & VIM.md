## Q.1. Installation and configuring Ansible and vim for yaml files on `workstation` node. 
- a)	Install required packages
- b)	Create a static inventory file -> `/home/student/ansible/inventory`
	- i)	`servera` member of `lab` host group.
	- ii)	`serverb` member of `preprod` host group.
	- iii)	`serverc` and `serverd` are the members of `production` host group.
	- iv)	`serverd` should also be the member of `myprod` host group.
	- v)	`production` and  `myprod` groups should  be the member of `webserver` host group.
- c)	Create an ansible.cfg file -> `/home/student/ansible/ansible.cfg`
	- i)	Specify inventory file -> `/home/student/ansible/inventory`
	- ii)	Specify Roles directory -> `/home/student/ansible/my-role`
	- iii)	privilege escalation
	- iv)   Specify collection    -> `/home/student/ansible/my-collection`
--- 

## Solution 

### Step 1. Login into the `workstation` node.

```
ssh student@workstation
```

### Step 2. Install the `ansible-core` ,`ansible-automation-platform-common`,  `python3-pip` & `vim` packages. 
```
sudo dnf install -y ansible-core python3-pip vim ansible-automation-platform-common
```

### Step 3. Create the mentioned directories.
```
mkdir -p /home/student/ansible/my-role
mkdir /home/student/ansible/my-collection
```

### Configure the `vim`.
```
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab 
```


### Step 4. Configure the `ansible.cfg` file.

```
[defaults]
inventory = /home/student/ansible/inventory
role_path = /home/student/ansible/my-role:/usr/share/ansible/roles
collections_path:./my-collection/:.ansible/collections:/usr/share/ansible/collections
remote_user = student
host_key_checking = False

[privilege_escalation]
become = true
```

### See the below file content for your references. 

```
[student@workstation ansible]$ cat ansible.cfg 
[defaults]
inventory = /home/student/ansible/inventory
role_path = /home/student/ansible/my-role:/usr/share/ansible/roles
collections_path:./my-collection/:.ansible/collections:/usr/share/ansible/collections
remote_user = student
host_key_checking = False

[privilege_escalation]
become = true
```

### Now, create inventory file.
#### What we knows from question : 
	- lab ---------> servera
	- preprod ----> serverb
	- production --> serverc, serverd
	- myprod -----> serverd
	- webserver ---> production,my-prod

```
[student@workstation ansible]$ cat inventory 
[lab]
servera.lab.example.com
[preprod]
serverb.lab.example.com
[production]
serverc.lab.example.com
serverd.lab.example.com
[myprod]
serverd.lab.example.com
[webserver:children]
production
myprod
[student@workstation ansible]$
```


```
[student@workstation ansible]$ ansible-inventory --graph
@all:
  |--@lab:
  |  |--servera.lab.example.com
  |--@preprod:
  |  |--serverb.lab.example.com
  |--@ungrouped:
  |--@webserver:
  |  |--@myprod:
  |  |  |--serverd.lab.example.com
  |  |--@production:
  |  |  |--serverc.lab.example.com
  |  |  |--serverd.lab.example.com
[student@workstation ansible]$ 
```



