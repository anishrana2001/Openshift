<div align="center">

# 🔴 EX288 Task 2

## Build and Deploy an Application using Containerfile

![OpenShift](https://img.shields.io/badge/OpenShift-4.18-EE0000?logo=redhatopenshift&logoColor=white)
![Build](https://img.shields.io/badge/Containerfile-2496ED?logo=docker&logoColor=white)
![Project](https://img.shields.io/badge/Project-production2-7B42BC)
![Guide](https://img.shields.io/badge/Guide-Student_Ready-2EA44F)

</div>

---

## 🧪 How to Prepare the Lab?

Run these commands on the workstation as the `student` user. They download the
practice repository, initialize it as a Git repository, and push it to the lab
Git server.

> [!NOTE]
> Use these preparation commands on a fresh lab environment. Do not change the
> application files before attempting the task.

```bash
lab start deploy-introduction
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
mkdir -p /home/student/ex288/task2/apps/task2/python-webserver

cd /home/student/ex288/task2/apps/task2/python-webserver

cat <<EOF >  /tmp/git.txt 
Username: developer
Password: d3v3lop3r
EOF
cat <<EOF > Dockerfile
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL org.opencontainers.image.title="Devopswala Task2 Web Server"
LABEL org.opencontainers.image.description="Simple Python HTTP Server running on OpenShift"
LABEL org.opencontainers.image.version="2.0"
LABEL org.opencontainers.image.vendor="Devopswala.com Training"
LABEL org.opencontainers.image.author="training@devopswala.com"

USER root

# Install Python and clean package cache
RUN microdnf install -y python3 && \
    microdnf clean all && \
    mkdir -p /devopswala

# Create custom application page
RUN echo '🚀 EX288 Task2 Application Running on OpenShiftCreated by: Devopswala.com Training' > /devopswala/index.html


ENV DOCROOT=/devopswala
ENV APPLICATION="EX288-Task2"

EXPOSE 8080

# OpenShift compatible non-root user
USER 1001

WORKDIR /devopswala

CMD ["python3", "-m", "http.server", "8080"]
EOF


mkdir src
cat <<EOF > src/index.html
<!DOCTYPE html>
<html>
<head>
  <title>2nd Image overriding</title>
</head>
<body>
  <h1>Task 2 Python Webserver </h1>
  <p>If you see this webpage then "COPY" worked correctly!</p>
</body>
</html>
EOF


cd /home/student/ex288/task2/


git init -b main
git checkout -b lab-pythonv3
git config user.name "Student"
git config user.email "student@ocp4.example.com"
git remote add origin https://developer:d3v3lop3r@git.ocp4.example.com/developer/task2-build.git

git add .
git commit -m "Add EX288 practice files for Task2"
git push -u origin lab-pythonv3
rm -rf /home/student/ex288/task2/apps/
```


## Question : 

Your task is to optimize the Dockerfile available at:
	`https://git.ocp4.example.com/developer/task2-build.git` on branch **`lab-pythonv3`** 
- The Containerfile is located under: `apps/task2/python-webserver` 

- The final solution must satisfy the following requirements:

	- Deploy an application in the **`production2`** project and make it accessible through:

	`http://task2-webserver-production2.apps.ocp4.example.com`


	- The generated Docker image must support **image inheritance**, allowing it to be used as a parent image for child images.
	- Child images must be able to override the default application content by providing their own files from the `src/` directory.
	- The optimized Dockerfile must produce an image that:
	  - Contains no more than **10 image layers**
	  - Has a final image size of less than or equal to **256 MiB**
	- The application must be successfully built, deployed, and accessible using the created container image.


<details>
<summary><strong>✅ 🚀 Show the complete solution and explanation</strong></summary>


---

# ✅ Solution

## Step 1: Create Project

Create the OpenShift project where the application will be deployed.

```bash
oc new-project production2
```

Verify:

```bash
oc project
```

Expected:

```
Using project "production2"
```

---

# Step 2: Clone Application Repository

Clone the Git repository containing the Dockerfile.

```bash
git clone https://git.ocp4.example.com/developer/task2-build.git

cd task2-build/apps/task2/python-webserver/
```

Verify files:

```bash
ls -l
```

Expected:

```
Dockerfile
src/
```

---

# Step 3: Optimize Dockerfile

The goal is:

- Image size <= 256 MiB
- Maximum 7 layers
- Support parent-child image inheritance

The optimized Dockerfile:


```dockerfile
cat <<EOF >  Dockerfile
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL org.opencontainers.image.title="Devopswala Task2 Web Server" \
      org.opencontainers.image.description="Reusable Python HTTP Server Parent Image" \
      org.opencontainers.image.version="2.0" \
      org.opencontainers.image.vendor="Devopswala.com Training"

USER root

RUN microdnf install -y python3 && \
    microdnf clean all && \
    mkdir -p /devopswala && \
    echo "🚀 EX288 Task2 Application Running on OpenShiftCreated by: Devopswala.com Training" > /devopswala/index.html

ENV DOCROOT=/devopswala \
    APPLICATION="EX288-Task2"

EXPOSE 8080

USER 1001

WORKDIR /devopswala

# Child images will execute this instruction
# when they inherit this image.
ONBUILD COPY src/ /devopswala/

CMD ["python3", "-m", "http.server", "8080"]
EOF
```

---

# Understanding ONBUILD COPY

`ONBUILD` stores an instruction inside the parent image.

The instruction does **not execute while building the parent image**.

It executes when another image uses:

```dockerfile
FROM parent-image
```

Example:

```
Parent Image
     |
     |
     +---- ONBUILD COPY src/
                  |
                  |
                  v
          Child Image Build
```

Memory:

```
COPY = Execute now

ONBUILD COPY = Execute when child image is created
```

---

# Step 4: Build and Validate Parent Image Locally

Podman login:

```bash
podman login  -u admin -p redhatocp
```

Build the image:

```bash
podman build --format docker -t test-image .
```

Check image:

```bash
podman image ls
```

Example:

```
REPOSITORY          TAG       SIZE
test-image          latest    <256MB
```

## Verify Image History

```bash
podman history test-image:latest
```


# Step 5: Commit Optimized Dockerfile to Git

After modifying the Dockerfile, push the changes to the Git repository.

Check status:

```bash
git status
```

### Check the Git credentials. 
```bash
cat /tmp/git.txt
```

Add changes:

```bash
git add . ; git commit -m "Optimize Dockerfile with ONBUILD COPY support" ; git push origin lab-pythonv3
```


Verify:

```bash
git log --oneline
```

---

# Step 6: Configure Git Authentication Secret

OpenShift requires Git credentials to clone the private repository.

Create a secret:

```bash
oc create secret generic git-secret \
--type=kubernetes.io/basic-auth \
--from-literal=username=developer \
--from-literal=password=d3v3lop3r
```

Verify:

```bash
oc get secret git-secret
```

---

## Add Git Secret Annotation

The annotation allows OpenShift builds to automatically select this secret for matching Git repositories.

```bash
oc annotate secret git-secret \
build.openshift.io/source-secret-match-uri=https://git.ocp4.example.com/*
```

Verify:

```bash
oc describe secret git-secret
```

Expected:

```text
Annotations:
  build.openshift.io/source-secret-match-uri=https://git.ocp4.example.com/*
```

---

## Link Secret with Builder Service Account

The builder service account must have access to the Git secret.

```bash
oc secrets link builder git-secret
```

Verify:

```bash
oc describe sa builder
```

Expected:

```text
Mountable secrets:
  git-secret
```

---

# Step 7: Create Parent Image Build

The first build creates the reusable parent image.

The parent image contains:

- Python runtime
- HTTP server
- Default application content
- ONBUILD trigger

### Check the Git credentials. 
```bash
cat /tmp/git.txt
```

Create the build configuration:

```bash
oc new-build \
--name=parent-image \
--strategy=docker \
--source-secret=git-secret \
--code=https://git.ocp4.example.com/developer/task2-build.git#lab-pythonv3 \
--context-dir=apps/task2/python-webserver
```

> Note:
> The Git credentials are included in the URL because `oc new-build` validates the source repository before creating the BuildConfig. The `source-secret` is still used by the build process.

---

# Step 8: Verify Parent Image

Check ImageStream:

```bash
oc get imagestream
```

Expected:

```text
NAME
parent-image
```

Inspect:

```bash
oc describe imagestream parent-image
```

You should see the generated image reference.

---

# Step 9: Deploy Parent Image (Validation)

Create deployment:

```bash
oc new-app parent-image:latest
```

Verify:

```bash
oc get pods
```

Expected:

```text
NAME                              READY   STATUS
parent-image-xxxxxx               1/1     Running
```

---

# Step 10: Create service route:

```bash
oc expose service parent-image \
--hostname parent-image-production2.apps.ocp4.example.com
```

Test:

```bash
curl http://parent-image-production2.apps.ocp4.example.com
```

Expected output:

```text
🚀 EX288 Task2 Application Running on OpenShiftCreated by: Devopswala.com Training
```

---

# Step 11: Create Child Image

The purpose of this step is to prove that the parent image can be reused.

The child image uses:

```dockerfile
FROM parent-image
```

The child image does not install Python again.

It only provides new application content.

---

Create a child Dockerfile:

```bash
cat <<EOF > Dockerfile
FROM image-registry.openshift-image-registry.svc:5000/production2/parent-image
EOF
```
---
#### Just for your information: The parent image contains:

```dockerfile
ONBUILD COPY src/ /devopswala/
```

Therefore during the child image build:

```text
Child Build ==> FROM parent-image ==> ONBUILD COPY executes ==> src/index.html replaces default content
```

---

### Check the Git credentials. 
```bash
cat /tmp/git.txt
```


# Step 12: Commit Child Image Changes

```bash
git add . ; git commit -m "Create child image using parent image inheritance" ; git push origin lab-pythonv3
```

---

# Step 13: Create Child Image Build

Create the final application image:

```bash
oc new-build \
--name=task2-webserver \
--strategy=docker \
--source-secret=git-secret \
--code=https://git.ocp4.example.com/developer/task2-build.git#lab-pythonv3 \
--context-dir=apps/task2/python-webserver
```

Verify ImageStream Name:

```
oc get all
```

# Step 14: Verify Child Image Deployment

Deploy the final application image:

```bash
oc new-app task2-webserver:latest
```

Verify resources:

```bash
oc get all
```



---

# Step 15: Create Application Route

Expose the application using the required hostname:

```bash
oc expose service task2-webserver \
--hostname task2-webserver-production2.apps.ocp4.example.com
```

Verify route:

```bash
oc get route
```

Expected:

```text
NAME                HOST/PORT
task2-webserver     task2-webserver-production2.apps.ocp4.example.com
```

---

# Step 16: Test Application

Access the application:

```bash
curl http://task2-webserver-production2.apps.ocp4.example.com
```



---

# Step 17: Validate Final Image Requirements

## Check Image Size

### How to clear the lab ?
```
oc delete project production2
rm -rf /home/student/ex288/task2/
podman login  -u admin -p redhatocp
podman image rm localhost/test-image
podman image  rm registry.access.redhat.com/ubi8/ubi-minimal
https://git.ocp4.example.com/developer/task2-build/edit#js-project-advanced-settings
developer/task2-build
```
# 🎓 End of Lab

</details>
