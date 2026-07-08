
## Prepare the lab.

```
mkdir -p /home/student/task1/building-container/
cd /home/student/task1/building-container/
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-index.js -O index.js
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-LocalizationService.js -O LocalizationService.js 
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-package-lock.json  -O package-lock.json 
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-package.json  -O package.json 
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-Containerfile  -O Containerfile 
```


## Check the directory.
```
pwd
```

```
cat task1-files-Containerfile 
```

## Login into the registry first.
```
podman login -u developer -p developer registry.ocp4.example.com:8443
```

## Create an image from the file **`task1-files-Containerfile`** with tag 1.0.0
```
podman build  -f task1-files-Containerfile  -t registry.ocp4.example.com:8443/developer/building-container:1.0.0
```

## Before pushing to registroy, it would be good to check if this image is good or not?
```
podman run --rm registry.ocp4.example.com:8443/developer/images-ubi-greetings:1.0.0
```

## Let's push the image.
```
podman push registry.ocp4.example.com:8443/developer/building-container:1.0.0
```

## It's time to jump into our Openshift Cluster.
### Login via **developer** user
```
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

## Create a new project.
```
oc new-project building-container
```

### Create an application in the cluster by using the image that you just built. Call the application greetings.
```
oc new-app --name greetings --image=registry.ocp4.example.com:8443/developer/building-container:1.0.0
```
## Post checks!
```
oc get all 
```

### You will observe that container is not running. Check the logs.
```
oc logs deployments/greetings
```

- Running with user ID: **1000690000**, group ID: 0
    - The cluster runs the container with a non-root user and the root group. The container runs successfully with Podman as it is honoring the USER root instruction. Red Hat OpenShift does not honor the USER instruction and runs containers by using an arbitrary non-root user.
- File cache does not work due to [Error: EACCES: permission denied, open '/var/cache/...'] { 
    - The application does not have the right access to the /var/cache directory.
- Error: listen EACCES: permission denied 0.0.0.0:80
    - The application cannot use the privileged port 80. The privileged ports between 1 to 1024

## Check the labels.
```
oc get all --show-labels
```

```
oc delete all --selector app=greetings
```

### It means that we need to remove the "USER root" entry. 
vi task1-files-Containerfile 
```
FROM registry.ocp4.example.com:8443/ubi10/nodejs-22-minimal:10.0

ENV PORT=80
EXPOSE ${PORT}

ADD . $HOME

RUN npm ci --omit=dev && rm -rf .npm

CMD npm start
```

## Create image with build tag 1.0.1
```
podman build . -t --image=registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

## Run the new container image. Verify that the application runs by using the 1001 user ID. By running as a non-root user locally, this container exhibits the same problems as a container that runs on the cluster.
```
podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

## Fix the port error and rebuild the container image.
vi task1-files-Containerfile 
```
FROM registry.ocp4.example.com:8443/ubi10/nodejs-22-minimal:10.0

ENV PORT=8080   ## Modify this line.
EXPOSE ${PORT}

ADD . $HOME

RUN npm ci --omit=dev && rm -rf .npm

CMD npm start
```


## Create image with old build tag 1.0.1 as we haven't push this image to our regsistary.
```
podman build . -t --image=registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

## Re-run the container image. The port problem is solved, and the application now listens on port 8080. The /var/cache/ permission error still persists.
```
podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.1
```
## Stop the container by pressing Ctrl+C.

## Remember our 3rd Problem that group assigned to the /var/cache directory is the root group (0).


### Fix the Group permission and rebuild the container image.
vi task1-files-Containerfile 
```
FROM registry.ocp4.example.com:8443/ubi10/nodejs-22-minimal:10.0

ENV PORT=8080
EXPOSE ${PORT}

ADD . $HOME

RUN npm ci --omit=dev && rm -rf .npm

USER root    ## Add this line
## Add below line
RUN chgrp -R 0 /var/cache && \
    chmod -R g=u /var/cache
USER 1001             ## Add this line

CMD npm start
```

### Rebuild the application image as version 1.0.1

```
podman build . -t --image=registry.ocp4.example.com:8443/developer/building-container:1.0.1
```
## All should be good, now.

```
podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.1
```
### Press Ctrl+C to stop the application.

## Push the 1.0.1 tag to the registry.
```
podman push registry.ocp4.example.com:8443/developer/building-container:1.0.1
```


## Create an aplication again.

```
oc new-app --name greetings --image=registry.ocp4.example.com:8443/developer/building-container:1.0.0
```
## Post checks!
```
oc get all 
```
```
oc logs deployments/greetings
```

## Create a route by exposing the service.
- It will follow the naming convention "service_name-Project_name-Domain_name"

```
oc expose svc/greetings
```

### Post checks.
```
curl -s http://greetings-building-container.apps.ocp4.example.com | jq
```

## 📌 Key Insight
Even with **`oc new-app --image`**, OpenShift still creates an ImageStream behind the scenes. However, you have less control over how that ImageStream is configured compared to creating it manually.

Next chapter, we will going to create our own ImageStream.
```
oc get is
```

```
oc get all
```
