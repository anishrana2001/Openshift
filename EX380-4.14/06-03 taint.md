## Prepare the lab.
```
oc adm taint  nodes worker01 dedicated=app1:NoSchedule
oc adm taint  nodes worker02 dedicated=app1:NoSchedule
oc adm taint  nodes worker03 dedicated=app1:NoSchedule
```

### Just for your information: You can also use `kubeclt` command, `kubectl taint node worker03 dedicated=app1:NoSchedule`

# Qestion: You need to check why new pods are not being created on the OCP cluster. 

## Solution:

```
oc get nodes
```
```
oc get nodes worker01 -o yaml| grep -i taint -A 4
```

```
oc adm taint node worker01 dedicated-
oc adm taint node worker02 dedicated-
oc adm taint node worker03 dedicated-
```

### With the help of FORLOOP command.


```
for i in {01..03} ; do echo $i ; done
```


```
for i in {01..03} ; do oc get nodes worker$i ; done
```

```
for i in {01..03} ; do oc get nodes worker$i -o yaml ; done
```

```
for i in {01..03} ; do oc get nodes worker$i -o yaml | grep -i taint ; done
```

```
for i in {01..03} ; do oc get nodes worker$i -o yaml | grep -i taint -A 4; done
```


### Below is the references.

```
[student@workstation test]$ oc get nodes worker01 -o yaml| grep -i taint -A 4
  taints:
  - effect: NoSchedule
    key: dedicated
    value: app1
status:
[student@workstation test]$ oc adm taint node worker01 dedicated-
node/worker01 untainted
[student@workstation test]$
[student@workstation test]$ oc adm taint node worker02 dedicated-
node/worker02 untainted
[student@workstation test]$ oc adm taint node worker03 dedicated-
node/worker03 untainted
[student@workstation test]$ 
```
