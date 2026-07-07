# Create a deployment from Image Steam

## Publish an image from an external registry as an image stream in OpenShift.
## Deploy an application using the image stream.


## 1. Log in to OpenShift using the developer user account.
```
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

## Create a Image Steams.
```
oc new-project images-streams
```

## Login into the Docker Registry.
```
skopeo login registry.ocp4.example.com:8443 -u developer -p developer
```

```
skopeo inspect docker://registry.ocp4.example.com:8443/redhattraining/hello-world-nginx
```

## Or you can login through PODMAN -
```
podman login registry.ocp4.example.com:8443 -u developer -p developer
```

```
podman inspect docker://registry.ocp4.example.com:8443/redhattraining/hello-world-nginx
```

## Create the hello-world image stream.
```
oc import-image is-hello-world --confirm --from registry.ocp4.example.com:8443/redhattraining/hello-world-nginx
```

### Verify that the hello-world:latest image stream tag is created.
```
oc get istag
```
### Verify that the image stream and its tag contain metadata 
```
oc describe is is-hello-world
```
 -  The asterisk (*) indicates that the latest image stream tag references only the particular image with the given SHA-256 identifier.

## 📌 Key Insight — Why ImageStream is Powerful


| Scenario | Without ImageStream | With ImageStream |
| :--- | :--- | :--- |
| **Image updated in registry** | ❌ Pod keeps old image | ✅ Triggers automatic redeployment |
| **Rollback to previous version** | ❌ Manual & complex | ✅ Easy — just tag previous IS version |
| **Multiple environments (dev/prod)** | ❌ Hard to manage | ✅ Use IS tags per environment |
| **Audit trail of image versions** | ❌ Not available | ✅ IS keeps full history |

## 2. Create a project
```
oc new-project images-streams
```
### Deploy an application from the image stream.
```
oc new-app --name image-steam-deploy -i images-streams/is-hello-world
```

### Check the pods are working !!
```
oc get all
```

### Create a route to expose the application.
```
oc expose svc hello
```

### Check the routes
```
oc get route
```

```
curl http://hello-images-streams-app.apps.ocp4.example.com
```

```
oc -n images-streams tag registry.ocp4.example.com:8443/redhattraining/php-hello-dockerfile:latest hello-world:latest
```

#### Verify the change to the hello-world:latest image stream tag.
```
oc -n images-streams get istag
```

```
oc -n images-streams describe is
```

```
curl http://image-steam-deploy-images-streams-app.apps.ocp4.example.com
```

