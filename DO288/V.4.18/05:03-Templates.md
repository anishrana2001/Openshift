
# EX288 Task 5 - Build and Deploy cdnweb Frontend Application Using OpenShift Templates

![OpenShift](https://img.shields.io/badge/OpenShift-4.18-EE0000?logo=redhatopenshift)
![Exam](https://img.shields.io/badge/EX288-Practice_Lab-blue)

---

# Task

## Build and Deploy cdnweb Frontend Application Using OpenShift Templates

The `cdnweb frontend application` must be built and deployed in the project:

```

tiger

```

---

# Requirements

## 1. Build Template

Modify the OpenShift build template:

```

task4/cdnweb-frontend-build.template.yaml

````

with the following changes.

### Required Parameter

Add a new required parameter:

```yaml
- name: REGISTRY_URL
  description: My CDN image registry
  required: true
````

---

### Object Names

All objects created from the template must have the name:

```
cdnweb-ui
```

---

### Source Repository

Use:

```
git.ocp4.example.com/developer/mycdn.git
```

Branch:

```
cdn-v4
```

Git credentials:

```
Username: developer
Password: d3v3lop3r
```

---

### NPM Repository

Configure application dependencies to use:

```
http://nexus-infra.apps.ocp4.example.com/repository/npm
```

---

### Container Registry

Set container image registry:

```
registry.ocp4.example.com
```

---

## 2. Backend URL

Set backend service URL:

```
https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/
```

---

## 3. Deployment Template

Modify:

```
task4/cdnweb-frontend-deploy.template.yaml
```

Requirements:

### Object Name

All objects must have:

```
cdnweb-ui
```

---

### Frontend URL

Expose frontend application using:

```
https://cdnweb-ui-tiger.apps.docdn-v44.example.com/
```

---

### Resource Labels

All resources created from the template must be selectable using:

```bash
app=cdnweb-ui,group=cdnweb
```

Required labels:

```yaml
labels:
  app: cdnweb-ui
  group: cdnweb
```

---

# Lab Preparation

## Clone Git Repository

Use:

```bash
git clone 'https://developer:d3v3lop3r@git.ocp4.example.com/developer/mycdn.git'

cd mycdn
```

---

# Step 1 - Switch to Project

```bash
oc project tiger
```

If the project does not exist:

```bash
oc new-project tiger
```

---

# Step 2 - Check Existing Template Parameters

Before modifying templates, check existing parameters.

Build template:

```bash
oc process --parameters \
-f task4/cdnweb-frontend-build.template.yaml
```

Deployment template:

```bash
oc process --parameters \
-f task4/cdnweb-frontend-deploy.template.yaml
```

---

# Step 3 - Modify Build Template

Edit:

```bash
vim task4/cdnweb-frontend-build.template.yaml
```

Add:

```yaml
parameters:

- name: REGISTRY_URL
  description: My CDN image registry
  required: true
```

Verify that the BuildConfig contains:

Repository:

```text
git.ocp4.example.com/developer/mycdn.git
```

Branch:

```text
cdn-v4
```

NPM registry:

```text
http://nexus-infra.apps.ocp4.example.com/repository/npm
```

Image registry:

```text
registry.ocp4.example.com
```

---

# Step 4 - Modify Deployment Template

Edit:

```bash
vim task4/cdnweb-frontend-deploy.template.yaml
```

Ensure resources have:

```yaml
labels:
  app: cdnweb-ui
  group: cdnweb
```

Deployment selector:

```yaml
selector:
  matchLabels:
    app: cdnweb-ui
    group: cdnweb
```

Pod template labels:

```yaml
template:
  metadata:
    labels:
      app: cdnweb-ui
      group: cdnweb
```

---

# Step 5 - Commit and Push Changes

Check changes:

```bash
git status
```

Add files:

```bash
git add task4/cdnweb-frontend-build.template.yaml \
task4/cdnweb-frontend-deploy.template.yaml
```

Commit:

```bash
git commit -m "Update cdnweb frontend templates"
```

Push:

```bash
git push
```

---

# Step 6 - Create Git Authentication Secret

Create secret:

```bash
oc create secret generic cdnweb-ui-git-auth \
--type=kubernetes.io/basic-auth \
--from-literal=username=developer \
--from-literal=password=d3v3lop3r
```

---

# Step 7 - Process Build Template

Example:

```bash
oc process \
-f task4/cdnweb-frontend-build.template.yaml \
-p NAME=cdnweb-ui \
-p SOURCE_REPOSITORY_URL=git.ocp4.example.com/developer/mycdn.git \
-p SOURCE_REPOSITORY_REF=cdn-v4 \
-p NPM_REGISTRY=http://nexus-infra.apps.ocp4.example.com/repository/npm \
-p REGISTRY_URL=registry.ocp4.example.com \
-p BACKEND_URL=https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/ \
| oc apply -f -
```

---

# Step 8 - Attach Git Secret

If the template does not already configure the source secret:

```bash
oc set build-secret \
--source bc/cdnweb-ui cdnweb-ui-git-auth
```

---

# Step 9 - Start Build

Start build:

```bash
oc start-build cdnweb-ui --follow
```

Check:

```bash
oc get builds

oc get bc

oc get is
```

---

# Step 10 - Deploy Frontend Application

Process deployment template:

```bash
oc process \
-f task4/cdnweb-frontend-deploy.template.yaml \
-p NAME=cdnweb-ui \
-p FRONTEND_URL=https://cdnweb-ui-tiger.apps.docdn-v44.example.com/ \
| oc apply -f -
```

---

# Verification

## Check Application Resources

```bash
oc get all -l app=cdnweb-ui,group=cdnweb
```

Expected resources:

```
deployment
pod
service
route
```

---

## Check Route

```bash
oc get route cdnweb-ui
```

Expected hostname:

```
cdnweb-ui-tiger.apps.docdn-v44.example.com
```

---

## Test Application

```bash
curl -k https://cdnweb-ui-tiger.apps.docdn-v44.example.com/
```

---

# EX288 Concepts Covered

This task covers:

* OpenShift Templates
* Template parameters
* BuildConfig
* ImageStream
* Git authentication
* Source-to-Image builds
* NPM registry configuration
* Deployment templates
* Labels and selectors
* Routes
* `oc process`
* Git workflow

---

# Important EX288 Notes

## Template Workflow

Typical workflow:

```text
Template
   |
   v
oc process
   |
   v
Generated YAML
   |
   v
oc apply
   |
   v
OpenShift Resources
```

---

## Common Mistakes

### Wrong Project

Incorrect:

```bash
oc new-project patrol
```

Correct:

```bash
oc project tiger
```

---

### Wrong Registry

Incorrect:

```
registry.docdn-v44.example.com
```

Correct:

```
registry.ocp4.example.com
```

---

### Wrong NPM Repository

Incorrect:

```
npm.docdn-v44.example.com
```

Correct:

```
http://nexus-infra.apps.ocp4.example.com/repository/npm
```

---

### Wrong Label

Incorrect:

```yaml
groups: cdnweb
```

Correct:

```yaml
group: cdnweb
```

---

# Final Validation Command

Run:

```bash
oc get all -l app=cdnweb-ui,group=cdnweb
```

If all resources appear, the template deployment is successful.



```

This version avoids the file attachment issue and keeps the content aligned with the task requirements.
```
