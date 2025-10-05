# Question 1: Configure a container 
- a) Create the container as `student` user with `mywebserverpod1`
- b) Run the container by using image `registry.lab.example.com:5000/rhel10/httpd-24`
- c) Identify the IP address of this container and paste in the file /opt/container/question1.txt
---
# Question 2: Configure a container.
- a) Create the container as `student` user user with `mywebserverpod2`
- b) Run the container by using image `registry.lab.example.com:5000/rhel10/httpd-24`
- c) The local directory /opt/dir11 should be persistently mount on container's /opt/audio1 directory.
- d) The local directory /opt/dir22 should be persistently mount on container's /opt/video2 directory.
---

# Question 3: Configure the Rootless container as a system start-up service and mount volumes persistently
- a) Create the container name `mycontainer12` as `student` user.
- b) Run the container by using image `registry.lab.example.com:5000/rhel10/httpd-24`
- c) The local directory /opt/dir10 should be persistently mount on container's /opt/audio directory.
- d) The local directory /opt/dir20 should be persistently mount on container's /opt/video directory.
- e) Make sure container will restart if node goes rebooted.
- f) The system service name should be `mywebserverpod-srv`.
---
### Solution 3: 
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
systemctl --user daemon-reload container-mycontainer12.service
```
