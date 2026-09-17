# OpenShift Internal Registry and Podman Image Workflow Lab

## Create a Container Image from an OpenShift ImageStream and Push It to the Internal OpenShift Registry Using Podman


### How to create a lab?
```
oc new-project demo2
oc import-image devopswala-ubi-image --from=$(oc get images  | grep ubi | head -n 1 | awk '{print $2}' | cut -d "@" -f1) --confirm
oc get imagestream devopswala-ubi-image
oc patch configs.imageregistry.operator.openshift.io/cluster --type=merge -p '{"spec":{"defaultRoute":false}}'
```



# Task

## Create a Container Image from an Image in Project `demo2` and Push It into the Internal OpenShift Registry

------------------------------------------------------------------------

# Solution

## Step 1: Select OpenShift Project

``` bash
oc project demo2
```

------------------------------------------------------------------------

## Step 2: Verify ImageStream:

``` bash
oc get imagestream
```

Example:

``` text
NAME                   IMAGE REPOSITORY
devopswala-ubi-image   default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-ubi-image
```

------------------------------------------------------------------------

# Step 3: Expose OpenShift Internal Registry

Check existing routes:

``` bash
oc get route -n openshift-image-registry
```

If no route exists, enable the default route:

``` bash
oc patch configs.imageregistry.operator.openshift.io/cluster \
--type=merge \
-p '{"spec":{"defaultRoute":true}}'
```

Verify:

``` bash
oc get route -n openshift-image-registry
```

Example:

``` text
NAME            HOST/PORT

default-route   default-route-openshift-image-registry.apps.ocp4.example.com
```

------------------------------------------------------------------------

# Step 4: Create Containerfile

Create a file named:

``` text
Containerfile
```

Content:

``` dockerfile
FROM default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-ubi-image

CMD ["echo","Hello dear"]
```

Explanation:

-   `FROM` uses the imported OpenShift ImageStream image.
-   `CMD` defines the default command executed when the container
    starts.

------------------------------------------------------------------------

# Step 5: Build the Image Using Podman

Build the image:

``` bash
podman build -t devopswala-local-image .
```

Verify:

``` bash
podman images | grep devopswala
```

Example:

``` text
localhost/devopswala-local-image latest
```

------------------------------------------------------------------------

# Step 6: Tag Image for OpenShift Registry

Tag the image using the registry format:

``` bash
podman tag devopswala-local-image \
default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1
```

Image naming format:

``` text
<registry>/<project>/<image>:<tag>
```

Example:

``` text
default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1
```

------------------------------------------------------------------------

# Step 7: Authenticate with OpenShift Registry

Check current user:

``` bash
oc whoami
```

Get token:

``` bash
oc whoami -t
```

Login to registry:

``` bash
podman login \
-u $(oc whoami) \
-p $(oc whoami -t) \
default-route-openshift-image-registry.apps.ocp4.example.com
```

Expected:

``` text
Login Succeeded!
```

------------------------------------------------------------------------

# Step 8: Push Image to Internal Registry

Push the image:

``` bash
podman push \
default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1
```

Example output:

``` text
Writing manifest to image destination
```

------------------------------------------------------------------------

# Step 9: Verify ImageStream

Check images stored in OpenShift:

``` bash
oc get imagestream
```

Example:

``` text
NAME
devopswala-local-image

NAME
devopswala-ubi-image
```

Verify details:

``` bash
oc describe imagestream devopswala-local-image
```

------------------------------------------------------------------------

# Step 10: Remove Local Registry Tag

Remove the registry tagged image:

``` bash
podman rmi \
default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1
```

Verify:

``` bash
podman images | grep devopswala-local-image
```

------------------------------------------------------------------------

# Step 11: Pull Image Using Podman

Pull the image again from OpenShift registry:

``` bash
podman pull \
default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1
```

Verify:

``` bash
podman images | grep devopswala-local-image
```

------------------------------------------------------------------------

# Complete Workflow

``` text
        OpenShift ImageStream
                |
                |
                v
        Create Containerfile
                |
                |
                v
        Podman Build
                |
                |
                v
        Podman Tag
                |
                |
                v
        Podman Login
                |
                |
                v
        Podman Push
                |
                |
                v
     OpenShift Internal Registry
                |
                |
                v
        Podman Pull
```

------------------------------------------------------------------------



```

[student@workstation sample-image]$ oc get route -n openshift-image-registry
No resources found in openshift-image-registry namespace.

[student@workstation sample-image]$ oc patch configs.imageregistry.operator.openshift.io/cluster \
--type=merge \
-p '{"spec":{"defaultRoute":true}}'
config.imageregistry.operator.openshift.io/cluster patched

[student@workstation sample-image]$ oc get route -n openshift-image-registry
NAME            HOST/PORT                                                      PATH   SERVICES         PORT    TERMINATION   WILDCARD
default-route   default-route-openshift-image-registry.apps.ocp4.example.com          image-registry   <all>   reencrypt     None
[student@workstation sample-image]$ 

[student@workstation sample-image]$ oc get imagestream devopswala-ubi-image
NAME                   IMAGE REPOSITORY                                                                          TAGS     UPDATED
devopswala-ubi-image   default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-ubi-image   latest   6 seconds ago

[student@workstation sample-image]$ cat > Containerfile 
FROM default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-ubi-image
CMD ["echo","Hello dear"]
^C

[student@workstation sample-image]$ podman build -t devopswala-local-image .
STEP 1/2: FROM default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-ubi-image
Trying to pull default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-ubi-image:latest...
Getting image source signatures
Copying blob e06f95ed90f3 done   | 
Copying blob 71c47bd95267 done   | 
Copying config f85d4087a0 done   | 
Writing manifest to image destination
STEP 2/2: CMD ["echo","Hello dear"]
COMMIT devopswala-local-image
--> ab8890a5e5d1
Successfully tagged localhost/devopswala-local-image:latest
ab8890a5e5d1735efb3c1e8b11922ac97a8d2649fabff214d5fec31514590544


[student@workstation sample-image]$ podman images | grep devopswala
localhost/devopswala-local-image                                                         latest            ab8890a5e5d1  28 seconds ago  314 MB
default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-ubi-image  latest            f85d4087a09a  6 days ago      314 MB
[student@workstation sample-image]$ 


[student@workstation sample-image]$ podman tag devopswala-local-image default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1

[student@workstation sample-image]$ podman images | grep devopswala
default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image  v1                ab8890a5e5d1  2 minutes ago   314 MB
localhost/devopswala-local-image                                                           latest            ab8890a5e5d1  2 minutes ago   314 MB
default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-ubi-image    latest            f85d4087a09a  6 days ago      314 MB
[student@workstation sample-image]$ 


[student@workstation sample-image]$ oc whoami 
admin
[student@workstation sample-image]$ oc whoami -t
sha256~62kF5twF8IaGGn7Y_MR0Foy0VE0hw4suNLefSX_CzB4

[student@workstation sample-image]$ podman login \
-u $(oc whoami) \
-p $(oc whoami -t) \
registry-url


podman push registry/project/image:tag


[student@workstation sample-image]$ podman push default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1 
Getting image source signatures
Copying blob e06f95ed90f3 skipped: already exists  
Copying blob 71c47bd95267 skipped: already exists  
Copying config ab8890a5e5 done   | 
Writing manifest to image destination
[student@workstation sample-image]$ 


[student@workstation sample-image]$ podman rmi default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1 
Untagged: default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1


[student@workstation sample-image]$ podman images | grep devopswala-local-image
localhost/devopswala-local-image                                                         latest            ab8890a5e5d1  10 minutes ago  314 MB

[student@workstation sample-image]$ oc get imagestream
NAME                     IMAGE REPOSITORY                                                                            TAGS     UPDATED
devopswala-local-image   default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image   v1       3 minutes ago
devopswala-ubi-image     default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-ubi-image     latest   9 minutes ago



[student@workstation sample-image]$ podman pull default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1
Trying to pull default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image:v1...
Getting image source signatures
Copying blob e06f95ed90f3 skipped: already exists  
Copying blob 71c47bd95267 skipped: already exists  
Copying config ab8890a5e5 done   | 
Writing manifest to image destination
ab8890a5e5d1735efb3c1e8b11922ac97a8d2649fabff214d5fec31514590544

[student@workstation sample-image]$ podman images | grep devopswala-local-image
default-route-openshift-image-registry.apps.ocp4.example.com/demo2/devopswala-local-image  v1                ab8890a5e5d1  10 minutes ago  314 MB
localhost/devopswala-local-image                                                           latest            ab8890a5e5d1  10 minutes ago  314 MB
[student@workstation sample-image]$
```
