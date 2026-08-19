# Module 02 - Container Images Fundamentals

## EX288 / DO288 OpenShift 4.18

Container images are the foundation of modern application deployment.

Before learning OpenShift ImageStreams, BuildConfigs, and S2I,
developers must understand how application code becomes a runnable
container image.

This module explains the complete image lifecycle:

    Application Code
            |
            v
    Dockerfile
            |
            v
    Container Image Build
            |
            v
    Image Registry
            |
            v
    OpenShift Deployment
            |
            v
    Application Pod

------------------------------------------------------------------------

# Learning Objectives

After completing this module, students will understand:

-   What is a container image
-   Difference between containers and images
-   Container image layers
-   Dockerfile structure
-   Base images
-   Building images using Podman
-   Image registries
-   Pushing images
-   How OpenShift consumes images
-   Image security basics

------------------------------------------------------------------------

# 1. What is a Container Image?

A container image is a lightweight package containing everything
required to run an application.

An image contains:

-   Application code
-   Runtime environment
-   Libraries
-   Dependencies
-   Configuration files
-   Startup instructions

Example:

A Python application image contains:

    Python Runtime

    +

    Application Code

    +

    Required Libraries

    +

    Startup Command

------------------------------------------------------------------------

# Container Image vs Container

  Container Image               Container
  ----------------------------- ----------------------------
  Static package                Running instance
  Stored in registry            Runs on a node
  Template for execution        Actual application process
  Cannot change while running   Has runtime state

Example:

    Image

    nginx:latest


            |

            v


    Container

    nginx application running

------------------------------------------------------------------------

# 2. Container Image Architecture

Images are built using multiple layers.

Example:

    Application Image

    Layer 5
    Application Code

    Layer 4
    Python Dependencies

    Layer 3
    Python Runtime

    Layer 2
    Operating System Packages

    Layer 1
    Base Image

Each layer is cached during builds.

Benefits:

-   Faster builds
-   Less storage usage
-   Better image management

------------------------------------------------------------------------

# 3. Container Registries

A container registry stores container images.

Examples:

-   Red Hat Registry
-   Quay.io
-   Docker Hub
-   Private enterprise registry
-   OpenShift Internal Registry

Image naming format:

    registry/repository/image:tag

Example:

    quay.io/example/python-app:v1

Meaning:

    Registry:
    quay.io

    Repository:
    example

    Image:
    python-app

    Tag:
    v1

------------------------------------------------------------------------

# 4. Dockerfile Fundamentals

A Dockerfile contains instructions used to build an image.

Example:

``` dockerfile
FROM python:3.12

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY app.py .

EXPOSE 8080

CMD ["python","app.py"]
```

------------------------------------------------------------------------

# Dockerfile Explanation

## FROM

Defines the base image.

Example:

``` dockerfile
FROM python:3.12
```

------------------------------------------------------------------------

## WORKDIR

Creates application working directory.

Example:

``` dockerfile
WORKDIR /app
```

------------------------------------------------------------------------

## COPY

Copies files into image.

Example:

``` dockerfile
COPY app.py .
```

------------------------------------------------------------------------

## RUN

Executes commands during image build.

Example:

``` dockerfile
RUN pip install flask
```

------------------------------------------------------------------------

## CMD

Defines container startup command.

Example:

``` dockerfile
CMD ["python","app.py"]
```

------------------------------------------------------------------------

# 5. Building Container Images Using Podman

OpenShift environments commonly use Podman for container image
management.

Check Podman:

``` bash
podman version
```

------------------------------------------------------------------------

## Build Image

Example:

``` bash
podman build -t python-demo:v1 .
```

Explanation:

    -t

    Creates image name and tag

------------------------------------------------------------------------

View images:

``` bash
podman images
```

Example output:

    REPOSITORY
    python-demo

    TAG
    v1

------------------------------------------------------------------------

# 6. Running Container Locally

Run image:

``` bash
podman run -d \
-p 8080:8080 \
python-demo:v1
```

Check running containers:

``` bash
podman ps
```

View logs:

``` bash
podman logs <container-id>
```

------------------------------------------------------------------------

# 7. Tagging Images

Before pushing an image, create a registry tag.

Example:

``` bash
podman tag \
python-demo:v1 \
quay.io/user/python-demo:v1
```

Result:

    Local Image

    python-demo:v1


            |

            v


    Registry Image

    quay.io/user/python-demo:v1

------------------------------------------------------------------------

# 8. Pushing Images to Registry

Login:

``` bash
podman login quay.io
```

Push:

``` bash
podman push quay.io/user/python-demo:v1
```

Verify:

``` bash
podman images
```

------------------------------------------------------------------------

# 9. How OpenShift Uses Container Images

OpenShift deployment flow:

``` mermaid
flowchart LR

A[Container Image]
-->B[Image Registry]

B-->C[Deployment]

C-->D[ReplicaSet]

D-->E[Pod]

E-->F[Running Container]
```

When a Deployment is created:

1.  OpenShift reads image information
2.  Kubernetes creates a Pod specification
3.  Scheduler selects worker node
4.  Node pulls image
5.  Container starts

------------------------------------------------------------------------

# 10. Image Pull Process

Example:

Deployment YAML:

``` yaml
containers:
- name: app
  image: quay.io/example/app:v1
```

Workflow:

    Deployment

         |

         v

    Pod Creation

         |

         v

    Worker Node

         |

         v

    Pull Image

         |

         v

    Start Container

------------------------------------------------------------------------

# 11. Image Security Basics

Important practices:

## Use Trusted Base Images

Avoid:

    unknown/random-image

Prefer:

    registry.access.redhat.com
    quay.io

------------------------------------------------------------------------

## Scan Images

Check:

-   Vulnerabilities
-   Outdated packages
-   Security issues

------------------------------------------------------------------------

## Keep Images Small

Benefits:

-   Faster deployment
-   Smaller attack surface
-   Faster builds

------------------------------------------------------------------------

# Hands-On Lab 02

## Build Your First Container Image

## Objective

Create a Python application image and run it locally.

------------------------------------------------------------------------

# Step 1: Create Application

Create:

    app.py

Example:

``` python
print("Hello OpenShift EX288")
```

------------------------------------------------------------------------

# Step 2: Create Dockerfile

Create:

    Dockerfile

Example:

``` dockerfile
FROM python:3.12

WORKDIR /app

COPY app.py .

CMD ["python","app.py"]
```

------------------------------------------------------------------------

# Step 3: Build Image

Run:

``` bash
podman build -t ex288-python:v1 .
```

------------------------------------------------------------------------

# Step 4: Verify Image

``` bash
podman images
```

------------------------------------------------------------------------

# Step 5: Run Container

``` bash
podman run ex288-python:v1
```

Expected output:

    Hello OpenShift EX288

------------------------------------------------------------------------

# EX288 Exam Tips

Remember:

-   Image is not a running application
-   Container is created from image
-   Deployment uses image
-   Pod runs container
-   Image registry stores images

------------------------------------------------------------------------

# Common Mistakes

## Mistake 1

Using incorrect image name.

Solution:

Always verify:

``` bash
podman images
```

------------------------------------------------------------------------

## Mistake 2

Forgetting image tag.

Wrong:

    python-demo

Better:

    python-demo:v1

------------------------------------------------------------------------

## Mistake 3

Building large images.

Solution:

Use:

-   Smaller base images
-   Multi-stage builds
-   Minimal dependencies

------------------------------------------------------------------------

# Module Summary

In this module, we learned:

-   Container image concepts
-   Dockerfile
-   Image layers
-   Podman commands
-   Registry workflow
-   Image deployment process
-   Image security

Next Module:

➡️ Module 03 - OpenShift ImageStreams
