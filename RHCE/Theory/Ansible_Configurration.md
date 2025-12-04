## What is Ansible Configuration file?

#### This ansible.cfg file tells Ansible how to behave for this project: where to find inventory, roles, collections, which user to use, and how to do sudo. Each line changes a default.


#### The file is INI-style and divided into sections, like [defaults], [privilege_escalation], [ssh_connection], etc. Each option tweaks how Ansible runs.

#### Key things you typically control:

#### Inventory: Which hosts file to use by default:

```
[defaults]
inventory = ./inventory
```


### Now `ansible all -m ping` automatically uses `./inventory`.

### Remote user: Default SSH user for all hosts:

```
remote_user = devops
```
### Equivalent to `remote_user: devops` in playbooks, unless overridden.

### Privilege escalation (become/sudo)
#### How to run commands as root (or another user):

```
[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
```
### This means: connect as devops (remote_user) and automatically use sudo to become root without asking for a sudo password (assuming NOPASSWD is set in the sudoer file).

### Security / SSH behavior
#### Control host key checking:

```
host_key_checking = False
```

#### This disables the “Are you sure you want to continue connecting?” host key prompt, which is convenient in labs but not recommended in production.

#### Roles and collections path
#### Where Ansible should look for roles and collections:

```
roles_path = ./my-roles:/usr/share/ansible/roles:/etc/ansible/roles
collections_path = ./my-collection:/usr/share/ansible/collections
```
#### This lets you keep project‑local roles/collections while still using system ones.

#### Performance and behavior : Things like forks, timeout, retry files, output style, etc.:

```
forks = 50
timeout = 10
retry_files_enabled = False
```
#### These tune speed and UX, especially in larger environments.

#### How it changes your day-to-day commands:
#### Without ansible.cfg, a full command can look like:

```
ansible-playbook -i ./inventory site.yml -u devops -b --become-method=sudo
```
#### With a good ansible.cfg in your project, you can just run:

```
ansible-playbook site.yml
```
	- Because Ansible already knows, from ansible.cfg: 
	- Which inventory to use (inventory=./inventory)
	- Which user to SSH as (remote_user=devops)
	- That it should use sudo and become root (become=True, become_user=root)
	- That it should not ask about host keys (host_key_checking=False)
	- Where to find roles/collections for your playbooks

#### This is why a clean project‑level ansible.cfg is considered best practice and is very helpful for RHCE labs.

#### Typical structure for an RHCE project
A common minimal ansible.cfg for EX294-style work looks like:
```
[defaults]
inventory = ./inventory
remote_user = devops
roles_path = ./roles:/usr/share/ansible/roles
host_key_checking = False
forks = 20

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
```

#### From there you can add more options as needed (callback plugins, stdout callback, logging, etc.), but the core idea stays the same:

#### The Ansible configuration file is the central place to define default behavior for your Ansible environment or project, so you write less in every command and playbook and keep behavior consistent.


### Is it possible to generate the Ansible's configuration file?
```
ansible-config init --disable > /home/student/ansible/ansible.cfg
```




## What is an inventory file?

### It is a file where you list:

	- Hostnames or IPs of the systems you will manage.
	- Groups of hosts (like web, db, dev, prod).
	- Optional variables (like SSH user, ports, custom settings).
	- Default path: /etc/ansible/hosts, but in projects you usually create your own, e.g. inventory.ini or hosts.yml.

Ansible reads this file to know where to run modules and playbooks.

### Step 1: The simplest inventory (single host)
#### Create a file called `inventory.ini`:

```
servera.lab.example.com
```

### Now run:

```
ansible -i inventory.ini servera.lab.example.com -m ping
```
   - -i inventory.ini → tell Ansible which inventory file to use.
   - servera.lab.example.com → host from the inventory.
   - -m ping → use the ping module.
   
   
### Step 2: Add multiple hosts and groups (INI format)
```
[web]
servera.lab.example.com
serverb.lab.example.com

[db]
serverc.lab.example.com

[all_servers]
servera.lab.example.com
serverb.lab.example.com
serverc.lab.example.com
```

#### Explanation:

	- [web] and [db] are group names.
	- Under each group, you list hosts belonging to that group.
	- A host can be in multiple groups.
	
```
ansible -i inventory.ini web -m ping      # ping only web servers
ansible -i inventory.ini db -m ping       # ping only db servers
ansible -i inventory.ini all_servers -m ping
```

### Step 3: Add connection details as host variables
#### Sometimes hostnames are different from SSH endpoints, or SSH uses different users/ports.
```
[web]
web1 ansible_host=10.0.0.11 ansible_user=student ansible_port=2222
web2 ansible_host=10.0.0.12 ansible_user=student ansible_port=2223

[db]
db1 ansible_host=10.0.0.21 ansible_user=student
```

### Explanation:

	- web1, web2, db1 are inventory names (logical names).
	- ansible_host is the real IP or DNS used for SSH.
	- ansible_user is the SSH username Ansible will use.
	- ansible_port is the SSH port (useful for NAT/VirtualBox).

### Now run:
```
ansible -i inventory.ini web -m ping
```


#### Ansible will SSH using these variables automatically.


### Step 4: Group variables (same for all hosts in a group)
#### You can set variables that apply to all hosts in a group:
```
[web]
web1 ansible_host=10.0.0.11
web2 ansible_host=10.0.0.12

[web:vars]
ansible_user=student
http_port=80
env=dev

[db]
db1 ansible_host=10.0.0.21

[db:vars]
ansible_user=student
env=prod
```

#### Explanation:

- [web:vars] defines variables for all web hosts.
- [db:vars] defines variables for all db hosts.


#### In a playbook:
```
- name: Show inventory variables
  hosts: web
  tasks:
    - ansible.builtin.debug:
        msg: "Host {{ inventory_hostname }} uses http_port={{ http_port }} env={{ env }}"

```


### Step 5: All group and global vars
#### Special groups:
	 - all --> all hosts in the inventory.
	 - You can use [all:vars] for global defaults.
```
[web]
web1 ansible_host=10.0.0.11
web2 ansible_host=10.0.0.12

[db]
db1 ansible_host=10.0.0.21

[all:vars]
ansible_user=student
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```


### Step 6: Where inventory fits in the whole Ansible flow
- Inventory → defines which hosts and how to reach them.
- Playbook → defines what to do on those hosts.
- ansible/ansible-playbook → uses -i to point to the inventory.
```
- name: Install httpd on web servers
  hosts: web
  become: yes
  tasks:
    - ansible.builtin.dnf:
        name: httpd
        state: present

```

#### Run
```
ansible-playbook -i inventory.ini install_httpd.yml
```
