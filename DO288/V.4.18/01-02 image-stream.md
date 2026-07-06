## Prepare the lab.
```
mkdir -p /home/student/task2/building-container/
cd /home/student/task2/building-container/
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-index.js
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-LocalizationService.js
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-package-lock.json
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-package.json
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task2-files-containerfile
podman login -u developer -p developer registry.ocp4.example.com:8443
podman build  -f task2-files-containerfile  -t registry.ocp4.example.com:8443/developer/task2-building-container:1.0.0
podman push  registry.ocp4.example.com:8443/developer/task2-building-container:1.0.0
```

oc login -u developer -p developer https://api.ocp4.example.com:6443

oc new-project images-registry

## 1. Create the `registry-credentials` secret of the docker-registry type that contains the credentials.
```
oc create secret docker-registry \
registry-credentials \
--docker-server=registry.ocp4.example.com:8443 \
--docker-username=developer \
--docker-password=developer \
--docker-email=developer@example.org
```
### Link the secret to the default service account.
```
oc secrets link default registry-credentials --for=pull
```

## 2. Create a deployment that uses the `registry.ocp4.example.com:8443/developer/task2-building-container:1.0.0` container image.

```
oc create deployment greeting1  --image=registry.ocp4.example.com:8443/developer/task2-building-container:1.0.0
```

### Verify that the application pod is running?
```
oc get pods
```
```
oc get all
```

### Search for events, if you observe any issue.
```
oc get event --field-selector type=Warning -o jsonpath='{range .items[]}{.message}{"\n"}{end}'
```
### If you want to learn more about jsonpath then explore this URL.
```
https://kubernetes.io/docs/reference/kubectl/jsonpath/
```

### Or you can use this command.
```
oc get event 
```

```
oc get events --sort-by='.lastTimestamp'
```

## Problem / Issue.
### Anyone who has access to this project can see the password of registry.
```
oc get secret registry-credentials -o jsonpath='{.data.\.dockerconfigjson}' | base64 --decode
```
### The output would be 
```
{
  "auths": {
    "registry.ocp4.example.com:8443": {
      "username": "developer",
      "password": "developer",
      "email": "developer@example.org",
      "auth": "ZGV2ZWxvcGVyOmRldmVsb3Blcg=="
    }
  }
}
```

## Let's clear this lab so that we can continue further.
```
## Unlink the previous credentials from the default service account.
oc secrets unlink default wrong-registry-credentials

## Delete this secret
oc delete secret/registry-credentials 

## Delete the deployment.
oc delete deployment greeting1

```

##  Solution of this issue is to Create a robot account for your user in the internal container registry.
### 1. Create a robot account.
- Go to https://registry.ocp4.example.com:8443 and log in using the user developer with the password developer.
- Click develop…> Account Settings to open the developer account settings.
- Click the robot icon in the left sidebar to open the Robot Accounts page.
- Click Create Robot Account.
- Use ocprobot as the username for the new robot account.
- Click Create robot account to finish the process. You can safely skip the Add permissions for developer+ocprobot step by clicking Close.
- Click developer+ocprobot to open the robot credentials page.
- Copy the authentication token within the Username & Robot Account section.
- Create the registry-credentials secret of the docker-registry type that uses the robot account you created.
---
```
oc create secret docker-registry registry-credentials \
--docker-server=registry.ocp4.example.com:8443 \
--docker-username=developer+ocprobot \
--docker-password=VTYSH... \
--docker-email=devops-wala@example.org
```

### Link the correct secret to the default service account.
```
oc secrets link default registry-credentials --for=pull
```

## 2. Create a deployment that uses the `registry.ocp4.example.com:8443/developer/task2-building-container:1.0.0` container image.

```
oc create deployment greeting2  --image=registry.ocp4.example.com:8443/developer/task2-building-container:1.0.0
```

## 3. Verify the application pod is running?
```
oc get pods
```
```
oc get all
```

### Search for events, if you observe any issue.
```
oc get event --field-selector type=Warning -o jsonpath='{range .items[]}{.message}{"\n"}{end}'
```
### If you want to learn more about jsonpath then explore this URL.
```
https://kubernetes.io/docs/reference/kubectl/jsonpath/
```

### Or you can use this command.
```
oc get event 
```

```
oc get events --sort-by='.lastTimestamp'
```

## Finish the lab.
```
## Unlink the previous credentials from the default service account.
oc secrets unlink default wrong-registry-credentials

## Delete the secret
oc delete secret/registry-credentials 

## Delete the deployment.
oc delete deployment greeting2

## delete the directory.
rm -rf /home/student/task2/
```
