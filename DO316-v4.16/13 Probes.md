# Configure a liveness probe
- Configure a liveness probe for the `mariadb-server` VM in the `apple` project and make sure following conditions are true:
- The liveness probe tests the database server at TCP Port 3306
- The time (in seconds) after the VM instance starts before the liveness probe is initiated is 100
- The delay in seconds between performing probes is 5
- download the yum.repo file to `mariadb-server` VM from "sudo curl -o /etc/yum.repos.d/yum.repo-file.repo https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO316/yum.repo-file.repo"
---

## Solution.
# How to add Liveness Probe
## First, we can create a dummy deploy/test. Where the pods will be created or not, no worries.
```
oc create deployment test --image=nginx
oc set probe --help | grep url
```

### Now, you can search the parameters of probe command.
```
oc set probe  --help | grep tcp
oc set probe deployment test --liveness --open-tcp=3306 --initial-delay-seconds=100 --period-seconds=5
```

### Get the details of probe from deployment.
```
oc get deployment test -o  yaml | grep -iA 10 liveness
```

        livenessProbe:
          failureThreshold: 3
          initialDelaySeconds: 100
          periodSeconds: 5
          successThreshold: 1
          tcpSocket:
            port: 3306
          timeoutSeconds: 1


### Now, you need to edit these details on the VM `mariadb-server`. Search for `domain`.
```
oc edit vm mariadb-server
```
## Make sure the indentation is correct. architecture, livenessProbe and domain should be on same Indentation. See the below
![image](https://github.com/user-attachments/assets/65f04432-92cf-4448-8230-199e12d5eb00)



### Or you can use this command, if you have this file. 
```
[student@workstation ~]$ cat /tmp/liveness.yaml
spec:
  template:
    spec:
        livenessProbe:
          failureThreshold: 3
          initialDelaySeconds: 100
          periodSeconds: 5
          successThreshold: 1
          tcpSocket:
            port: 3306
          timeoutSeconds: 1
```

```
oc patch vm/mariadb-server --type=merge --patch-file=/tmp/liveness.yaml
```	


### Need to restart the VM.
```
virtctl restart mariadb-server
oc get vmi mariadb-server
```

### Once vm up, go to the console.
```
virtctl console mariadb-server
```
### Enter the credentials.

```
Credentials : root/redhat

systemctl stop mysql
```
### Logout.
## mariadb-server VM should be restarted due to liveness probe


### For More practice, you can also try to configure the readiness Probs. Only for increase your knowledge purpose.



MYROUTE_readiness=`oc get routes | awk '{print $2}' | grep -v HOST` ; echo $MYROUTE_readiness
for i in {1..20} ; do curl http://$MYROUTE_readiness ; done




oc set probe deploy/test --readiness --get-url=http://:8080/healthz --initial-delay-seconds=10
oc get deployment test -o yaml

Search for readiness probs and copy the contents and modify it as per your requirements

        readinessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 5
          successThreshold: 1
          timeoutSeconds: 2
          failureThreshold: 2


### Modify the Vm template and then restart the www1 VM.
oc edit vm www1
virtctl restart www1


### Post Cheks. 

```
oc get vm,vmi,endpoints
```

### If you can see the www1 IP in the endpoints and then proceed further. 
oc edit vm www2
virtctl restart www2

### Post Cheks for www2 VM

```
oc get vm,vmi,endpoints
```

### Final Post checks
```
for i in {1..20} ; do curl http://$MYROUTE_readiness ; done
```






oc edit vm/web1 
virtctl restart web1 

oc create service clusterip front --tcp=80:80 
oc create route edge front --service front --hostname front-review-cr3.apps.ocp4.example.com
curl https://front-review-cr3.apps.ocp4.example.com/?[1-3]
