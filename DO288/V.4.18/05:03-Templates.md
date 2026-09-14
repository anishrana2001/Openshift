<div align="center">

# 🔴 EX288 Task 5

## Build and Deploy cdnweb Frontend Application Using OpenShift Templates

![OpenShift](https://img.shields.io/badge/OpenShift-4.18-EE0000?logo=redhatopenshift&logoColor=white)
![Build](https://img.shields.io/badge/Templates_Strategy-2496ED?logo=docker&logoColor=white)
![Project](https://img.shields.io/badge/Project-tiger-7B42BC)
![Guide](https://img.shields.io/badge/Guide-Student_Ready-2EA44F)

</div>

---

## 🧪 How to Prepare the Lab?

Run these commands on the workstation as the `student` user. They download 
the required template files, initialize them as a Git repository,
and push the templates to the lab GitLab repository.

> [!NOTE]
> Use these preparation commands on a fresh lab environment. Do not change the
> application files before attempting the task.

```bash
mkdir -p /home/student/ex288/template
cd /home/student/ex288/template
wget https://github.com/anishrana2001/Openshift/raw/refs/heads/main/DO288/V.4.18/05-00-cdnweb-frontend-lab.tar
tar xvf /home/student/ex288/template/05-00-cdnweb-frontend-lab.tar
rm -rf /home/student/ex288/template/05-00-cdnweb-frontend-lab.tar
## Creation of git project.
git init -b cdn-v4
git config user.name "Student"
git config user.email "student@ocp4.example.com"
git remote add origin https://developer:d3v3lop3r@git.ocp4.example.com/developer/mycdn.git
git add .
git commit -m "Add EX288 practice files"
git push -u origin cdn-v4
## cleaning the files.
cd /home/student/ex288/template/
rm -rf /home/student/ex288/template/*
```
---

# Task : Build and Deploy cdnweb Frontend Application Using OpenShift Templates

- The **`cdnweb`** **frontend application** must be built and deployed in the project **`tiger`**
	- Build the OpenShift **`build template`** for the `cdnweb` application from the  template  located at **`05-00-cdnweb-frontend-build-template.yaml`** with the following modification:
		- Define a new required parameter named **`REGISTRY_URL`** with the following description **`My CDN image registry`**
		- All created resources should use the name **cdnweb-ui**.
		- Use the default branch **`cdn-v4`** from the repository **`git.ocp4.example.com/developer/mycdn.git`** & credentials are **`Username: developer`** and **`Password: d3v3lop3r`**
		- The application's dependencies NPM repository to the corporate is **`http://nexus-infra.apps.ocp4.example.com/repository/npm`**
		- Set the container image registry as **`registry.ocp4.example.com`**

- **Set the `backend`** service to the public exposed backend URL `https://cdnweb-be-tiger-db.apps.ocp4.example.com/`

	- To deploy the **`cdnweb`** **frontend application**, use the OpenShift deployment template located at **`05-00-cdnweb-frontend-deploy.template.yaml`** with the following modification:
		- All created resources should use the name **`cdnweb-ui`**
		- Set the public exposed frontend URL as **`https://cdnweb-ui-tiger.apps.ocp4.example.com/`**
		- All resources created from the template must be selectable using the selector **`app=cdnweb-ui,group=cdnweb`**

> **Important Note:** You must push the template changes into the Git code repository.
---

# Goal of the Task

In this task, you must:

1. Work in the correct OpenShift project: `tiger`.
2. Clone the frontend application Git repository.
3. Edit the build template and add the missing required parameter `REGISTRY_URL`.
4. Make sure template-created resources are labelled correctly.
5. Commit and push the template changes back to Git.
6. Process and apply the build template.
7. Process and apply the deploy template.
8. Start and verify the build.
9. Verify the deployment, service, route, and labels.

This is not just a simple oc new-app task. This is a template-based deployment task, so understanding the template workflow is important.

---

## Architecture 


         1. SOURCE CONTROL
              GitLab (git.ocp4.example.com/developer/mycdn.git)
                │
                │ clone
                ▼
        Local Repository
                │
                │ edit templates
                │
                ├──────── git push ───────► GitLab
                │
                │
                ▼
         2. TEMPLATE PROCESSING      
         
      oc process template.yaml -p NAME=... -p REGISTRY_URL=...
                │
                ▼
      Final Kubernetes/OpenShift YAML
                │
                ▼
           oc apply -f -
                │
                ▼
             Cluster

         3. APPLICATION BUILD

          BuildConfig
                │
                │ git clone source
                ▼
             GitLab (git.ocp4.example.com/developer/mycdn.git)
                │
                ▼
        Application source
                │
                ▼
             Build
                │
                ▼
          Container Image
---


---

# Solution

## Step 1: Switch to the Required Project

```bash
oc project tiger
```

If the project does not exist, create it:

```bash
oc new-project tiger
```


---

## Step 2: Clone the Git Repository


```bash
git clone https://git.ocp4.example.com/developer/mycdn.git
```

When prompted:


```text
Username: developer
Password: d3v3lop3r
```

---

## Step 3: Inspect the Template Parameters

Before editing or processing templates, check which parameters already exist.

```bash
oc process --parameters -f 05-00-cdnweb-frontend-build-template.yaml
```

Also check the deployment template:

```bash
oc process --parameters -f 05-00-cdnweb-frontend-deploy.template.yaml
```

### Explanation

This helps you identify the exact parameter names expected by the templates.

For example, the template may already contain parameters such as:

```text
NAME
REGISTRY_URL
FRONTEND_HOST
```

The exact names depend on the template. Do not guess if the template already defines them.
---

# Step 4: Edit the Build Template

Open the build template:

```bash
vim 05-00-cdnweb-frontend-build-template.yaml
```

Find the `parameters:` section.

Add this missing parameter:

```yaml
- name: REGISTRY_URL
  description: My CDN image registry
  required: true
```

### Explanation

The question says:

```text
Define on the build template a new required parameter named **`REGISTRY_URL`**
```

The hint says the variable is already defined in the build configuration.

That means somewhere inside the build template, the template likely already refers to:

```text
${REGISTRY_URL}
```

But the parameter is missing from the `parameters:` section.

So you do not need to invent a new variable inside the BuildConfig. You only need to declare the missing parameter.

---


# Step 5: Add Labels to the Templates

The question says all resources created from the template must be selectable with:

```text
app=cdnweb-ui,group=cdnweb
```

The best way is to define template-level labels.

In both templates, add or update the top-level `labels:` section like this:

```yaml
labels:
  app: ${NAME}
  group: cdnweb
```

Do this in both files:

```text
05-00-cdnweb-frontend-build-template.yaml
05-00-cdnweb-frontend-deploy.template.yaml
```

### Why Use `${NAME}`?

Because the task says all created resources must use the name:

```text
cdnweb-ui
```

When we process the template with:

```bash
-p NAME=cdnweb-ui
```

this label:

```yaml
app: ${NAME}
```

becomes:

```yaml
app: cdnweb-ui
```

So the final selector becomes:

```text
app=cdnweb-ui,group=cdnweb
```

---



# Step 6: Make Sure Pod Template Labels Are Also Correct

For deployment resources, labels should also be present in the pod template.

Inside the deployment template, check the deployment object and ensure it has labels like this:

```yaml
metadata:
  labels:
    app: ${NAME}
    group: cdnweb
spec:
  selector:
    matchLabels:
      app: ${NAME}
      group: cdnweb
  template:
    metadata:
      labels:
        app: ${NAME}
        group: cdnweb
```

### Explanation

A top-level template label helps label created objects.

But for Deployments, the pod labels and selector labels must also match. Otherwise, the Deployment may not correctly manage its pods.

---

# Step 7: Save, Commit, and Push Template Changes

Check the modified files:

```bash
git status
```

Add the changed template files:

```bash
git add 05-00-cdnweb-frontend-build-template.yaml 05-00-cdnweb-frontend-deploy.template.yaml
```

Commit the changes:

```bash
git commit -m "Add registry parameter and cdnweb labels to frontend templates"
```

Push the changes:

```bash
git push origin cdn-v4
```

### Explanation

The question clearly says:

```text
You must push the changes in the templates into the Git code repository
```

So editing locally is not enough. You must commit and push.

---

# Step 8: Create a Git Authentication Secret in OpenShift

Because the build must access the Git repository using `developer` and `d3v3lop3r`, create a basic authentication secret.

```bash
oc create secret generic cdnweb-ui-git-auth \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=developer \
  --from-literal=password='d3v3lop3r'
```

### Explanation

This creates a secret that can be attached to the BuildConfig as a source secret.



---

# Step 9: Process and Apply the Build Template

Run this command from inside the cloned repository:

```bash
oc process -f 05-00-cdnweb-frontend-build-template.yaml \
  -p NAME=cdnweb-ui \
  -p SOURCE_REPOSITORY_URL=https://git.ocp4.example.com/developer/mycdn.git \
  -p SOURCE_REPOSITORY_REF=cdn-v4 \
  -p NPM_REGISTRY=http://nexus-infra.apps.ocp4.example.com/repository/npm \
  -p REGISTRY_URL=registry.ocp4.example.com \
  -p BACKEND_URL=https://cdnweb-be-tiger-db.apps.ocp4.example.com/ \
  | oc apply -f -
```

### Explanation

This command processes the build template and creates the build-related resources.

The important values are:

| Requirement | Value |
|---|---|
| Application name | `cdnweb-ui` |
| Git repository | `git.ocp4.example.com/developer/mycdn.git` |
| Git branch | `cdn-v4` |
| NPM registry | `http://nexus-infra.apps.ocp4.example.com/repository/npm` |
| Container registry | `registry.ocp4.example.com` |
| Backend URL | `https://cdnweb-be-tiger-db.apps.ocp4.example.com/` |

---

## If Your Template Uses Different Parameter Names

First list the parameters:

```bash
oc process --parameters -f 05-00-cdnweb-frontend-build-template.yaml
```

Then map the values correctly.

For example:

| If Template Parameter Is | Use This Value |
|---|---|
| `NAME` | `cdnweb-ui` |
| `APP_NAME` | `cdnweb-ui` |
| `SOURCE_REPOSITORY_URL` | `git.ocp4.example.com/developer/mycdn.git` |
| `GIT_URI` | `git.ocp4.example.com/developer/mycdn.git` |
| `SOURCE_REPOSITORY_REF` | `cdn-v4` |
| `GIT_REF` | `cdn-v4` |
| `NPM_REGISTRY` | `http://nexus-infra.apps.ocp4.example.com/repository/npm` |
| `NPM_MIRROR` | `http://nexus-infra.apps.ocp4.example.com/repository/npm` |
| `BACKEND_URL` | `https://cdnweb-be-tiger-db.apps.ocp4.example.com/` |
| `APPLICATION_SERVICE` | `https://cdnweb-be-tiger-db.apps.ocp4.example.com/` |
| `REGISTRY_URL` | `registry.ocp4.example.com` |

Do not blindly copy parameter names if your template uses different names. The template output is the boss here, because apparently files are allowed to have opinions.

---

# Step 10: Attach the Git Secret to the BuildConfig

After the BuildConfig is created, attach the Git source secret:

```bash
oc set build-secret --source bc/cdnweb-ui cdnweb-ui-git-auth
```

### Explanation

This allows the BuildConfig to authenticate to the Git repository.

If the build template already has a parameter for source secret, such as `SOURCE_SECRET`, `GIT_SECRET`, or `SOURCE_SECRET_NAME`, you can pass it during template processing instead.

Example:

```bash
-p SOURCE_SECRET_NAME=cdnweb-ui-git-auth
```

Use the exact parameter name shown by:

```bash
oc process --parameters -f 05-00-cdnweb-frontend-build-template.yaml
```

---

# Step 11: Start the Build

```bash
oc start-build cdnweb-ui --follow
```

### Explanation

This starts the frontend build and follows the logs.

If the build starts automatically after BuildConfig creation, this command may not be needed. But it is useful in exams and labs to force and verify the build.

---

# Step 12: Verify Build Resources

Check the build:

```bash
oc get builds
```

Check BuildConfig:

```bash
oc get bc cdnweb-ui
```

Check image stream:

```bash
oc get is cdnweb-ui
```

Check build logs if needed:

```bash
oc logs -f bc/cdnweb-ui
```

---

# Step 13: Process and Apply the Deploy Template

```bash
oc process -f 05-00-cdnweb-frontend-deploy.template.yaml \
  -p NAME=cdnweb-ui \
  -p REGISTRY_URL=registry.ocp4.example.com \
  -p FRONTEND_HOST=cdnweb-ui-tiger.apps.ocp4.example.com \
  | oc apply -f -
```

### Explanation

This processes and applies the deployment template.

The cdn-v4 customizations are:

| Requirement | Value |
|---|---|
| Object name | `cdnweb-ui` |
| Public frontend URL | `https://cdnweb-ui-tiger.apps.ocp4.example.com/` |
| Labels | `app=cdnweb-ui,group=cdnweb` |

---

## If Deploy Template Uses a Route Host Parameter

Some templates expect only the hostname, not the full URL.

If your deployment template asks for `HOSTNAME`, or `ROUTE_HOST`, use this value:

```text
cdnweb-ui-tiger.apps.ocp4.example.com
```

not:

```text
https://cdnweb-ui-tiger.apps.ocp4.example.com/
```

### Why?

A route hostname should not include:

```text
https://
```

or a trailing slash:

```text
/
```

The route host should only be:

```text
cdnweb-ui-tiger.apps.ocp4.example.com
```

Use the full URL only if the template parameter specifically asks for the frontend public URL.

---

# Step 14: Create the Frontend Route If the Template Does Not Create It

If the deployment template does not create the route automatically, create it manually:

Check the route before creating it.

```bash
oc get route cdnweb-ui
```

If route is not created then execute the below command. 

```bash
oc create route edge cdnweb-ui \
  --service=cdnweb-ui \
  --hostname=cdnweb-ui-tiger.apps.ocp4.example.com
```

### Explanation

This exposes the frontend service publicly over HTTPS.

Do not use this as the hostname:

```text
https://cdnweb-ui-tiger.apps.ocp4.example.com/
```

Use only:

```text
cdnweb-ui-tiger.apps.ocp4.example.com
```

OpenShift route hostnames do not include the URL scheme.

---

# Step 15: Verify All Resources

Check all resources:

```bash
oc get all
```

Check the route:

```bash
oc get route cdnweb-ui
```

Check pods:

```bash
oc get pods
```

Check logs:

```bash
oc logs deployment/cdnweb-ui
```

Check labels:

```bash
oc get all -l app=cdnweb-ui,group=cdnweb
```

Expected result:

```text
Resources related to cdnweb-ui should be listed.
```

---

# Step 16: Test the Application

Test the frontend URL:

```bash
curl -k https://cdnweb-ui-tiger.apps.ocp4.example.com/
```

If the frontend loads but cannot communicate with the backend, check that the backend URL parameter was set correctly:

```text
https://cdnweb-be-tiger-db.apps.ocp4.example.com/
```

---

# Complete Final Command Set

Use this clean sequence.

```bash
# 1. Switch to the correct project
oc project tiger || oc new-project tiger

# 2. Clone the source repository
git clone https://git.ocp4.example.com/developer/mycdn.git

# 3. Enter the repository
cd mycdn/

# 4. Inspect template parameters
oc process --parameters -f 05-00-cdnweb-frontend-build-template.yaml
oc process --parameters -f 05-00-cdnweb-frontend-deploy.template.yaml

# 5. Edit the build template and add REGISTRY_URL parameter
vim 05-00-cdnweb-frontend-build-template.yaml

# 6. Edit labels in both templates
vim 05-00-cdnweb-frontend-build-template.yaml
vim 05-00-cdnweb-frontend-deploy.template.yaml

# 7. Commit and push template changes
git status
git add 05-00-cdnweb-frontend-build-template.yaml 05-00-cdnweb-frontend-deploy.template.yaml
git commit -m "Add registry parameter and cdnweb labels to frontend templates"
git push origin cdn-v4

# 8. Create Git authentication secret
oc create secret generic cdnweb-ui-git-auth \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=developer \
  --from-literal=password='d3v3lop3r'

# 9. Process and apply build template
oc process -f 05-00-cdnweb-frontend-build-template.yaml \
  -p NAME=cdnweb-ui \
  -p SOURCE_REPOSITORY_URL=https://git.ocp4.example.com/developer/mycdn.git \
  -p SOURCE_REPOSITORY_REF=cdn-v4 \
  -p NPM_REGISTRY=http://nexus-infra.apps.ocp4.example.com/repository/npm \
  -p REGISTRY_URL=registry.ocp4.example.com \
  -p BACKEND_URL=https://cdnweb-be-tiger-db.apps.ocp4.example.com/ \
  | oc apply -f -

# 10. Attach Git source secret to BuildConfig
oc set build-secret --source bc/cdnweb-ui cdnweb-ui-git-auth

# 11. Start build
oc start-build cdnweb-ui --follow

# 12. Process and apply deployment template
oc process -f 05-00-cdnweb-frontend-deploy.template.yaml \
  -p NAME=cdnweb-ui \
  -p REGISTRY_URL=registry.ocp4.example.com \
  -p FRONTEND_HOST=cdnweb-ui-tiger.apps.ocp4.example.com \
  | oc apply -f -

# 13. Create route manually if template does not create it
oc create route edge cdnweb-ui \
  --service=cdnweb-ui \
  --hostname=cdnweb-ui-tiger.apps.ocp4.example.com

# 14. Verify resources
oc get all
oc get all -l app=cdnweb-ui,group=cdnweb
oc get route cdnweb-ui
oc get pods
```

---


# Verification Checklist

## 1. Verify project

```bash
oc project
```

Expected:

```text
tiger
```

---

## 2. Verify template parameters

```bash
oc process --parameters -f 05-00-cdnweb-frontend-build-template.yaml
```

Expected parameter should include:

```text
REGISTRY_URL
```

---

## 3. Verify Git commit

```bash
git log --oneline -1
```

Expected latest commit message:

```text
Add registry parameter and cdnweb labels to frontend templates
```

---

## 4. Verify BuildConfig

```bash
oc get bc cdnweb-ui -o yaml
```

Check for:

```yaml
source:
  git:
    uri: git.ocp4.example.com/developer/mycdn.git
    ref: cdn-v4
```

Also check for source secret:

```yaml
sourceSecret:
  name: cdnweb-ui-git-auth
```

---

## 5. Verify labels

```bash
oc get all -l app=cdnweb-ui,group=cdnweb
```

This should return the resources created for the frontend application.

---

## 6. Verify route

```bash
oc get route cdnweb-ui
```

Expected host:

```text
cdnweb-ui-tiger.apps.ocp4.example.com
```

---

## 7. Verify application

```bash
curl -k https://cdnweb-ui-tiger.apps.ocp4.example.com/
```

---

# Final Exam-Ready Answer

```bash
oc project tiger || oc new-project tiger

git clone https://git.ocp4.example.com/developer/mycdn.git
cd mycdn/

oc process --parameters -f 05-00-cdnweb-frontend-build-template.yaml
oc process --parameters -f 05-00-cdnweb-frontend-deploy.template.yaml

vim 05-00-cdnweb-frontend-build-template.yaml
```

Add the missing build parameter:

```yaml
- name: REGISTRY_URL
  description: My CDN image registry
  required: true
```

Add labels in both templates:

```yaml
labels:
  app: ${NAME}
  group: cdnweb
```

Then commit and push:

```bash
git status
git add 05-00-cdnweb-frontend-build-template.yaml 05-00-cdnweb-frontend-deploy.template.yaml
git commit -m "Add registry parameter and cdnweb labels to frontend templates"
git push origin cdn-v4
```

Create Git auth secret:

```bash
oc create secret generic cdnweb-ui-git-auth \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=developer \
  --from-literal=password='d3v3lop3r'
```

Process build template:

```bash
oc process -f 05-00-cdnweb-frontend-build-template.yaml \
  -p NAME=cdnweb-ui \
  -p SOURCE_REPOSITORY_URL=https://git.ocp4.example.com/developer/mycdn.git \
  -p SOURCE_REPOSITORY_REF=cdn-v4 \
  -p NPM_REGISTRY=http://nexus-infra.apps.ocp4.example.com/repository/npm \
  -p REGISTRY_URL=registry.ocp4.example.com \
  -p BACKEND_URL=https://cdnweb-be-tiger-db.apps.ocp4.example.com/ \
  | oc apply -f -
```

Attach source secret and start build:

```bash
oc set build-secret --source bc/cdnweb-ui cdnweb-ui-git-auth
oc start-build cdnweb-ui --follow
```

Process deploy template:

```bash
oc process -f 05-00-cdnweb-frontend-deploy.template.yaml \
  -p NAME=cdnweb-ui \
  -p REGISTRY_URL=registry.ocp4.example.com \
  -p FRONTEND_HOST=cdnweb-ui-tiger.apps.ocp4.example.com \
  | oc apply -f -
```

Create route if needed:

```bash
oc create route edge cdnweb-ui \
  --service=cdnweb-ui \
  --hostname=cdnweb-ui-tiger.apps.ocp4.example.com
```

Verify:

```bash
oc get all -l app=cdnweb-ui,group=cdnweb
oc get route cdnweb-ui
curl -k https://cdnweb-ui-tiger.apps.ocp4.example.com/
```

---

# Final Summary

To solve Task 5 correctly:

- Use project `tiger`, not `patrol`.
- Clone the correct repository.
- Add the missing required parameter `REGISTRY_URL` to the build template.
- Add labels using `app: ${NAME}` and `group: cdnweb`.
- Push template changes back to Git.
- Create a Git authentication secret using `developer` and `d3v3lop3r`.
- Process the build template with the required custom values.
- Process the deployment template with the frontend URL.
- Create the route manually only if the deploy template does not create it.
- Verify all created resources using:

```bash
oc get all -l app=cdnweb-ui,group=cdnweb
```

This completes the build and deployment of the cdnweb frontend application using OpenShift templates.
