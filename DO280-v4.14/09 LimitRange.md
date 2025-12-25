# Question: Create LimitRange for project `orange`:
- Set the `pod memory limit` between `5Mi and 300Mi`
- Set the `container memory limit` between `5Mi and 300Mi` and container `default request limnit ` for memory is `100Mi`
- Set the `pod cpu limit` between `5m and 300m`
- Set the `container cpu limit` between `5m and 300m` and container `default request limit` for cpu is `100m`
---
### Solution. 
### In this question, we need to set the limit range at pod and container level.
### Set the `pod memory limit` between `5Mi and 300Mi`. 
- It means that POD memory limit: 
    - Minimum: 5Mi
    - Maximum: 300Mi
### Set the `container memory limit` between `5Mi and 300Mi` and container `default memory request` is `100Mi`
- Set the `container memory limit` between `5Mi and 300Mi`. It means, container Memory Limit :
	- Minimum: 5Mi
	- Maximum: 300Mi
- container `Default Memory Request` is `100Mi`
	- defaul: 100Mi

### Create a file.
```
vi limitrange.yaml
```

```
apiVersion: "v1"
kind: "LimitRange"
metadata:
  name: "ex280-limitrange" 
spec:
  limits:
    - type: "Pod"
      max:
        cpu: "300m"
        memory:  "300Mi"
      min:
        cpu: "5m"
        memory: "5Mi"
    - type: "Container"
      max:
        cpu:  "300m"
        memory: "300Mi"
      min:
        cpu: "5m"
        memory: "5Mi"
      default:
        cpu: "100m"
        memory: "100Mi"
```

### Create the limitRange.
```
oc apply -f limitrange.yaml
```
### Post Checks.
```
oc get limitrange
```
