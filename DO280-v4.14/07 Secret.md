## Prepare the lab for this question.
```
oc new-project cloud
oc create deployment mysql-app --image registry.ocp4.example.com:8443/redhattraining/mysql-app:v1
oc create secret generic ex280-root --from-literal=MYSQL_USER=redhat --from-literal=MYSQL_DATABASE=world_x
oc set env --from=secret/ex280-root deployment mysql-app
```


# Question: Create secret with named `ex280-secret` in `cloud` project. The key name should be `MYSQL_PASSWORD` and the value of key should be `redhat123`
### Solution
### Go to the project first.
```
oc project cloud
```
### Create a generic secret with name `ex280-secret` with option `--from-literal=MYSQL_PASSWORD=redhat123`
```
oc create  secret generic ex280-secret --from-literal=MYSQL_PASSWORD=redhat123
```
### Once secret created, you can verify it.
```
oc describe secret ex280-secret
```
---

# Question: Use the secret `ex280-secret` in project `cloud`
- There is one pod already exist
- It should use ex280-secret secret previously created.
- Application should produce output.
---
### Solution:
### Go to the project first.
```
oc project cloud
```
```
oc get all
```
### Due to env variable the application is not running. 
### Verify that the subjective pod is a part of Deployment or StatefulSet or DeploymentConfig (dc). If it is belongs to deploymentConfig then run 

```
oc set env dc/mysql --prefix MYSQL_PASSWORD --from secret/ex280-secret
```

### If it is deployment, then run the below commmand.
```
oc set env --from=secret/ex280-secret deployment mysql-app
```

### check the logs or events.
```
oc logs POD_NAME
oc get events
```

### Once you set the environment variable and after that application is not working than you can see the logs and events for further reasons. May be on worker node taint is applied. if it is than remove the taint from worker node only.
### If this is an issue with taint then, go to this page 
https://github.com/anishrana2001/Openshift/blob/main/DO280/05.%20taint%20and%20toleration.md
