# Qeustion 1: The user `student` should create an image named `my_image:1.0` from the URL `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCSA-V.9.3/image_08-01.yaml`

- Registry URL: registry.lab.example.com:5000
- podman credentials are
- user name : `student` and password is `redhat`


### Solution, this question must be done on workernode in RedHat lab, if you are using.

```
ssh student@127.0.0.1
```
```
podman login registry.lab.example.com:5000
```
```
user: student
password: redhat
```
### download the file.
```
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCSA-V.9.3/image_08-01.yaml
```

### Create an image.
```
podman build -t my_image:1.0 -f image_08-01.yaml
```

### Post check
```
podman images
```
### For your references.
```
student@workstation:~$ ssh student@localhost
Web console: https://workstation.lab.example.com:9090/ or https://172.25.250.9:9090/


student@workstation:~$ wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCSA-V.9.3/image_08-01.yaml
--2025-10-06 04:29:58--  https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCSA-V.9.3/image_08-01.yaml
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.108.133, 185.199.110.133, 185.199.109.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.108.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 153 [text/plain]
Saving to: ‘image_08-01.yaml’

image_08-01.yaml                                        100%[============================================================================================================================>]     153  --.-KB/s    in 0s      

2025-10-06 04:29:59 (2.59 MB/s) - ‘image_08-01.yaml’ saved [153/153]




student@workstation:~$ podman login registry.lab.example.com:5000
Username: student
Password: 
Login Succeeded!


student@workstation:~$ podman build -t my_image:1.0 -f image_08-01.yaml
STEP 1/2: FROM registry.lab.example.com:5000/ubi8/ubi
Trying to pull registry.lab.example.com:5000/ubi8/ubi:latest...
Getting image source signatures
Copying blob a07f1c23e503 done   | 
Copying blob b21c13c5f3fd done   | 
Copying config fca12da1dc done   | 
Writing manifest to image destination
STEP 2/2: CMD echo "This container uses the ubi8/ubi image"
COMMIT my_image:1.0
--> a2756d7e4a40
Successfully tagged localhost/my_image:1.0
a2756d7e4a407e3e6aba75d60cabab49dab6f53464360ed777b9a848770e1fd4


student@workstation:~$ podman images
REPOSITORY                              TAG         IMAGE ID      CREATED         SIZE
localhost/my_image                      1.0         a2756d7e4a40  11 seconds ago  235 MB
registry.lab.example.com:5000/ubi8/ubi  latest      fca12da1dc30  3 years ago     235 MB
student@workstation:~$
```

# Question 2: Configure a container 
- a) Create the container named `mywebserverpod1` from user `student`.
- b) Run the container by using image that you created in question 1.
- c) Identify the IP address of this container and paste in the file /opt/container/question1.txt
---
# Question 3: Configure a container.
- a) Create the container `mywebserverpod3` as user `student`.
- b) Run the container by using image `registry.lab.example.com:5000/rhel10/httpd-24`
- c) The local directory /opt/dir11 should be persistently mount on container's /opt/audio1 directory.
- d) The local directory /opt/dir22 should be persistently mount on container's /opt/video2 directory.
---

# Question 4: Configure the Rootless container as a system start-up service and mount volumes persistently
- a) Create the container name `mycontainer2` as `student` user.
- b) Run the container by using image `registry.lab.example.com:5000/rhel10/httpd-24`
- c) The local directory /opt/dir10 should be persistently mount on container's /opt/audio directory.
- d) The local directory /opt/dir20 should be persistently mount on container's /opt/video directory.
- e) Make sure container will restart if node goes rebooted.
- f) The system service name should be `mywebserverpod-srv`.
---
### Solution 4: 
```
lab start containers-podman
```

## Terminal 1, switch to root user.
```
sudo -i
```
## Create a directories and give desired privileges
```
mkdir /opt/dir10 /opt/dir20
chown student:student /opt/dir10 /opt/dir20
ls -ld /opt/dir10 /opt/dir20

chmod 777 /opt/dir10 /opt/dir20
```
```
loginctl enable-linger student
```
---
### The command loginctl enable-linger student enables user lingering for the user student. By default, systemd terminates all user processes when the user logs out. Enabling lingering changes this behavior for a specified user. 
- What does this command do?
- Keeps user services running: It allows the user's background services and processes to continue running even after the user has logged out.
- Starts user manager at boot: With lingering enabled, a systemd --user instance is started for the user at boot time. This manager is responsible for running the user's services.
- Permits long-running tasks: This is useful for running services that need to operate continuously, such as a personal web server, database, or other background tasks, without requiring the user to be logged in.
---
### Make sure container will restart if node goes rebooted.


## From 2nd terminal: User = student
```
ssh student@127.0.0.1
```
```
podman login registry.lab.example.com:5000
```
```
user: student
password: redhat
```
## Run the container
```
podman run -d --name mycontainer12 -v /opt/dir10:/opt/audio:Z -v /opt/dir20:/opt/video:Z registry.lab.example.com:5000/rhel10/httpd-24
```
```
mkdir -p  .config/systemd/user
cd .config/systemd/user
podman generate systemd --name mycontainer12 --new  --files 
```
```
student@workstation:~/.config/systemd/user$ ls -ltr
total 4
-rw-r--r--. 1 student student 849 Oct  3 07:12 container-mycontainer12.service
student@workstation:~/.config/systemd/user$ 
```
```
systemctl --user daemon-reload 

```
```
systemctl --user enable container-mycontainer12.service
systemctl --user start container-mycontainer12.service
systemctl --user status container-mycontainer12.service
```
