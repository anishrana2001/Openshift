# RHCE-lab-setup
## If you are not using Redhad lab then one can build by its own.

#### Create 5 VMs.
  - workstation : 25 GB Harddisk, 2 GB RAM and 1 CPU.
  - 4 VMs : 20 GB Harddisk, 2 GB RAM, 1 CPU each vm.
  - username : student
  - password: redhat

#### If using 'NAT NETWORK' then execute the below command to make a port forwarding on MAC OS.
```
VBoxManage natnetwork modify --netname Airtel-network --port-forward-4 "ssh:tcp:[]:2222:[10.10.10.4]:22"
```
#### How you can check ?

```
VBoxManage natnetwork list Airtel-network
```
```
ssh -p 2222 student@127.0.0.1
```

#### How you can delete ?
```
VBoxManage natnetwork modify --netname Airtel-network --port-forward-4 delete ssh
```

#### On Workstation VM: 
```
cat > /etc/hosts
```

```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.10.10.11  workstation  workstation.lab.example.com
10.10.10.10  servera   servera.lab.example.com
10.10.10.13  serverb   serverb.lab.example.com
10.10.10.12  serverc   serverc.lab.example.com
10.10.10.14  serverd   serverd.lab.example.com
```

#### How to enable the passwordless authentication?

##### Generate the key on worstation VM:
```
ssh-keygen
```

##### Copy the key into the 4 VMs
```
ssh-copy-id student@servera
```
```
ssh-copy-id student@serverb
```
```
ssh-copy-id student@serverc
```
```
ssh-copy-id student@serverd
```

#### How to escalate the privileges to `student` user ?
#### 1. Login to `servera` and then execute the below command. Make sure, you switch to `root` user. Follow these steps for `serverb`, `serverc`, and `serverd`
```
sudo visudo -f /etc/sudoers.d/student
```
```
student ALL=(ALL) NOPASSWD: ALL
```
#### 2. Giving right permission to this newly created file.
```
sudo chmod 0440 /etc/sudoers.d/student
```
#### 3. Verify syntax
```
sudo visudo -c
```
```
su - student
sudo -l    # Lists rules - should show (ALL) NOPASSWD: ALL
sudo whoami # Should return "root" NO PASSWORD
```

##### For your references.
```
[student@serverd ~]$ su -
Password: 
Warning: your password will expire in 0 days.
Last login: Sat Nov 29 22:04:32 IST 2025 on pts/0
[root@serverd ~]# sudo visudo -f /etc/sudoers.d/student
[root@serverd ~]# sudo chmod 0440 /etc/sudoers.d/student
[root@serverd ~]# 
logout
[student@serverd ~]$ sudo whoami 
root
[student@serverd ~]$
```


### How to install the `Ansible` by `student` user?
```
sudo dnf config-manager --set-enabled crb
dnf repolist | grep crb
sudo dnf install -y oniguruma-devel python3-devel gcc
pip install onigurumacffi jinja2 ansible-runner ansible-lint ansible-builder ansible-navigator
```






