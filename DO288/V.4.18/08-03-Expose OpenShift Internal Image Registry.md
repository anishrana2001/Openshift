# Task: Expose OpenShift Internal Image Registry, Push a Sample Image, and Pull It Using Podman

## Objective

Learn how to:

1.  Expose the OpenShift internal image registry.
2.  Build a sample container image.
3.  Push the image into the OpenShift internal registry.
4.  Pull the image back using Podman.

------------------------------------------------------------------------

# Environment

Assumptions:

-   OpenShift 4.x cluster is available.
-   User has `oc` and `podman` installed.
-   User is logged into OpenShift.

Example login:

``` bash
oc login https://api.<cluster-domain>:6443
```

------------------------------------------------------------------------

# Task Steps

## Step 1: Verify the Image Registry Operator

Check the registry status:

``` bash
oc get clusteroperator image-registry
```

The registry should be available.

------------------------------------------------------------------------

## Step 2: Expose the Internal Registry

Enable the default route:

``` bash
oc patch configs.imageregistry.operator.openshift.io/cluster \
--type=merge \
-p '{"spec":{"defaultRoute":true}}'
```

Verify the route:

``` bash
oc get route -n openshift-image-registry
```

Example output:

    NAME            HOST/PORT
    default-route   default-route-openshift-image-registry.apps.ocp4.example.com

The registry URL is:

    default-route-openshift-image-registry.apps.ocp4.example.com

------------------------------------------------------------------------

## Step 3: Create a Project

Create a project for storing the image:

``` bash
oc new-project demo
```


------------------------------------------------------------------------

## Step 4: Create a Sample Image

Create a working directory:

``` bash
mkdir sample-image
cd sample-image
```

Create a Containerfile:

```bash
vi Containerfile
```

``` dockerfile
FROM registry.access.redhat.com/ubi9/ubi
CMD ["echo","Hello from OpenShift registry"]
```

Build the image:

``` bash
podman build -t sample-image:v1 .
```

Verify:

``` bash
podman images
```

```
[student@workstation sample-image]$ podman images
REPOSITORY                                                                      TAG               IMAGE ID      CREATED         SIZE
localhost/sample-image                                                          v1                29e125a97a4e  15 minutes ago  219 MB
```
------------------------------------------------------------------------

## Step 5: Tag the Image for OpenShift Registry

Use the exposed registry hostname:

``` bash
podman tag sample-image:v1 \
default-route-openshift-image-registry.apps.ocp4.example.com/demo/sample-image:v1
```

Verify:

``` bash
podman images | grep sample-image
```

------------------------------------------------------------------------

## Step 6: Login to the Registry

Get the OpenShift token:

``` bash
oc whoami -t
```

Login:

``` bash
podman login \
-u $(oc whoami) \
-p $(oc whoami -t) \
default-route-openshift-image-registry.apps.ocp4.example.com
```

Expected:

    Login Succeeded!

------------------------------------------------------------------------

## Step 7: Push the Image

Push the image:

``` bash
podman push \
default-route-openshift-image-registry.apps.ocp4.example.com/demo/sample-image:v1
```

------------------------------------------------------------------------

## Step 8: Verify Image in OpenShift

Check image streams:

``` bash
oc get imagestream -n demo
```

Expected:

    NAME            IMAGE REPOSITORY
    sample-image    image-registry.openshift-image-registry.svc:5000/demo/sample-image

------------------------------------------------------------------------

## Step 9: Pull the Image Using Podman

Pull the image:

``` bash
podman pull \
default-route-openshift-image-registry.apps.ocp4.example.com/demo/sample-image:v1
```

Run the image:

``` bash
podman run --rm \
default-route-openshift-image-registry.apps.ocp4.example.com/demo/sample-image:v1
```

Expected output:

    Hello from OpenShift registry

------------------------------------------------------------------------

# Troubleshooting

## Error: DNS lookup failed

Example:

    lookup default-route-openshift-image-registry.apps.example.com: no such host

Cause:

The registry hostname is incorrect.

Find the correct hostname:

``` bash
oc get route -n openshift-image-registry
```

Example:

    default-route-openshift-image-registry.apps.ocp4.example.com

Use the exact hostname returned by OpenShift.

------------------------------------------------------------------------

# Final Workflow

    Build Image
         |
         v
    Podman Image
         |
         v
    Tag with OpenShift Registry Route
         |
         v
    podman push
         |
         v
    OpenShift Internal Registry
         |
         v
    podman pull
         |
         v
    Run Container
