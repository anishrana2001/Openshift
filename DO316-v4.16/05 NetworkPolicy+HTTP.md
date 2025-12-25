
# Configure a Web Server in a VirtualMachine `myvm-lan1` in a `banana` project
- Install the httpd package.
- One can download the yum.repo file from `sudo curl -o /etc/yum.repos.d/yum.repo-file.repo  https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO316/yum.repo-file.repo`
- httpd services must be enabled after the reboot.
- Download the anish.html file from `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO316/anish.html` and upload on `/var/www/html` on the VM.
- A Network Policy named `netpol-http` should exists in the `banana` Project
- A `Clusterlp Service` allows Web Traffic into the `myvm-lan1` VirtualMachine
- The Network Policy Restricts access to the VirtualMachine `myvm-lan1` and allowing only the member of Project `banana` to access TCP port `80` 
- Other Project cannot Reach the VirtualMachine `myvm-lan1` at TCP Port `80`

## Task Create a Network policy named `apple-access-netpol` in the `banana` project. Only the member of `apple` project should able to access the VM `myvm-lan2`
## Task Create a Network policy named `kiwi-access-netpol` in the `banana` project. It should allow only the request coming from `kiwi` project.
---



### Solution: 
### Go to the project first.
```
oc project banana
```
### Login to VM , user name is `raja` and password is `anishrana2001`
```
virtctl console myvm-lan1
```
### Switch to root user
```
sudo su -
```
- One can download the yum.repo file from "sudo curl -o /etc/yum.repos.d/yum.repo-file.repo  https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO316/yum.repo-file.repo"
```
sudo curl -o /etc/yum.repos.d/yum.repo-file.repo  https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO316/yum.repo-file.repo
```
- Install the httpd package.
```
sudo yum install httpd -y
```
- httpd services must be enabled after the reboot.
```
systemctl enable httpd
systemctl start httpd
```

- Download the service.html file from "https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO316/service.html" and upload on `/var/www/html` on the VM.
```
cd /var/www/html/  
curl -o anish.html  https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO316/anish.html

systemctl restart httpd
curl localhost/anish.html
```
- A Network Policy named `netpol-http` exists in the `banana` Project
### Check the NetworkPolicy in the banana project.
```
oc get netpol
```
```
oc describe netpol netpol-http
```

### Based upon the above output, we need to modify the labels on namespace and VM.
### Add the label on Namespace ==> `name=client-ns`   👈👈👈
```
oc get namespaces banana --show-labels 
```

### Add the label on VM under the "/spec/template/metadata/labels/" to "env: production". Based upon the network policy  👈👈👈
```
oc edit vm myvm-lan1
```

## OR you can use this command.
```
oc patch vm myvm-lan1 --type='json' -p='[{"op": "add", "path": "/spec/template/metadata/labels/env", "value": "production"}]'
```

- A `Clusterlp Service` allows Web Traffic into the `myvm-lan1` VirtualMachine
### It's time to create service and expose it. Please bear in mind that we must use "virtctl" command to expose the VMi.
```
virtctl expose vmi myvm-lan1 --name svc-netpol --type=ClusterIP --port 80 --target-port=80
```
### you should see the endpoints.
```
oc get endpoints/svc-netpol 
```

- The Network Policy Restricts access to the VirtualMachine `myvm-lan1` and allowing only the member of Project `banana` to access TCP port `80` 
- Other Project cannot Reach the VirtualMachine `myvm-lan1` at TCP Port `80`
### Post checks!!!
### Let's create one deployment in the `banana` proejct and check if we can access to our VM / VMI or Web server. It should return the page. 

### Open the web console and create a dummy deployment

![image](https://github.com/user-attachments/assets/5f70181f-edc2-4bb4-a319-e0c1903f264a)

```
oc get pods 
oc rsh pod/test-7d674b5dc9-t65jx   curl svc-netpol.banana.svc.cluster.local
```

### Let's create one project and then create a dummy deployment with default image after that try it, if we can access to VM/VMi or webserver. Ideally, it should not.
```
oc new-project test
```
![image](https://github.com/user-attachments/assets/b88bf594-6c60-40f5-b387-255b379b80dd)


### It should not work. 
```
oc rsh pods/webserver-app5-6848fd96fc-8nk9n curl svc-netpol.banana.svc.cluster.local
```
