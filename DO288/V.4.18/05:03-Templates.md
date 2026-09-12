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

Run these commands on the workstation as the `student` user. They download the
practice repository, initialize it as a Git repository, and push it to the lab
Git server.

> [!NOTE]
> Use these preparation commands on a fresh lab environment. Do not change the
> application files before attempting the task.

```bash
mkdir -p /home/student/ex288/template
cd /home/student/ex288/template
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/05-00-cdnweb-frontend-build-template.yaml

wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/05-00-cdnweb-frontend-deploy.template.yaml

git init -b main
git config user.name "Student"
git config user.email "student@ocp4.example.com"
git remote add origin \
  https://developer:d3v3lop3r@git.ocp4.example.com/developer/mycdn.git

git add .
git commit -m "Add EX288 practice files"
git push -u origin main
rm -rf /home/student/ex288/template/05-00-cdnweb-frontend-build-template.yaml
rm -rf /home/student/ex288/template/05-00-cdnweb-frontend-deploy.template.yaml
```
---

# Task : Build and Deploy cdnweb Frontend Application Using OpenShift Templates

- The cdnweb `frontend application` must be built and deployed in the project **`tiger`**
- Build the OpenShift `build template` for the `cdnweb` application located at **`task4/cdnweb-frontend-build.template.yaml`** with the following modification:

	- Define a new required parameter named **`REGISTRY_URL`** with the following description **`My CDN image registry`**
    - All objects must have the name **`cdnweb-ui`**
    - Use the default branch **`cdn-v4`** from the repository **`git.ocp4.example.com/developer/mycdn.git`** & credentails is **`Username: developer`** and **`Password: d3v3lop3r`**
    - The application's dependencies NPM repository to the corporate is **`http://nexus-infra.apps.ocp4.example.com/repository/npm`**
    - Set the container image registry as **`registry.ocp4.example.com**

- **Set the `backend`** service to the public exposed backend URL `https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/`

- To deploy the cdnweb **`frontend`** application, use the OpenShift deployment template located at **`task4/cdnweb-frontend-deploy.template.yaml`** with the following modification:

    - All objects must have the name **`cdnweb-ui`**
    - Set the public exposed frontend URL as **`https://cdnweb-ui-tiger.apps.docdn-v44.example.com/`**
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

This is not just a simple `oc new-app` task. This is a template-based deployment task. So blindly typing commands is how people summon YAML demons.

---

## Architecture 


         1. SOURCE CONTROL
              GitLab
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
             GitLab
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

# Correct Solution

## Step 1: Switch to the Required Project

```bash
oc project tiger
```

If the project does not exist, create it:

```bash
oc new-project tiger
```

### Explanation

The question clearly says the frontend application must be built and deployed in the `tiger` project.

The rough solution used:

```bash
oc new-project patrol
```

That is wrong.

Correct project name:

```text
tiger
```

Wrong project name:

```text
patrol
```

One letter difference, entire task ruined. Kubernetes does not care about your intentions. Charming system.

---

## Step 2: Clone the Git Repository

```bash
git clone 'http://developer:d3v3lop3r@git.docdn-v44.example.com:5000/filesmart/cdnweb-frontend.git'
```

Then move into the repository:

```bash
cd cdnweb-frontend
```

### Safer Method

If the shell gives trouble because of the `!` character in the password, clone without credentials and enter them when prompted:

```bash
git clone git.ocp4.example.com/developer/mycdn.git
```

When prompted:

```text
Username: developer
Password: d3v3lop3r
```

### Explanation

The password contains an exclamation mark:

```text
!
```

In some Linux shells, `!` can trigger history expansion. So wrapping the full Git URL in single quotes avoids unnecessary suffering.

---

## Step 3: Inspect the Template Parameters

Before editing or processing templates, check which parameters already exist.

```bash
oc process --parameters -f task4/cdnweb-frontend-build.template.yaml
```

Also check the deployment template:

```bash
oc process --parameters -f task4/cdnweb-frontend-deploy.template.yaml
```

### Explanation

This helps you identify the exact parameter names expected by the templates.

For example, the template may already contain parameters such as:

```text
NAME
SOURCE_REPOSITORY_URL
SOURCE_REPOSITORY_REF
NPM_REGISTRY
BACKEND_URL
FRONTEND_URL
```

The exact names depend on the template. Do not guess if the template already defines them. Guessing parameter names in OpenShift templates is basically gambling with extra indentation.

---

# Step 4: Edit the Build Template

Open the build template:

```bash
vim task4/cdnweb-frontend-build.template.yaml
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
Define on the build template a new required parameter named REGISTRY_URL
```

The hint says the variable is already defined in the build configuration.

That means somewhere inside the build template, the template likely already refers to:

```text
${REGISTRY_URL}
```

But the parameter is missing from the `parameters:` section.

So you do not need to invent a new variable inside the BuildConfig. You only need to declare the missing parameter.

---

## Example: Correct Build Template Parameter Section

Your build template should contain something like this:

```yaml
parameters:
- name: NAME
  description: Application name
  required: true

- name: SOURCE_REPOSITORY_URL
  description: Git source repository URL
  required: true

- name: SOURCE_REPOSITORY_REF
  description: Git branch or reference
  value: cdn-v4

- name: NPM_REGISTRY
  description: NPM registry URL
  required: true

- name: BACKEND_URL
  description: Backend service public URL
  required: true

- name: REGISTRY_URL
  description: My CDN image registry
  required: true
```

> The existing parameter names in your template may differ. Keep the existing names and only add the missing `REGISTRY_URL` parameter.

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
task4/cdnweb-frontend-build.template.yaml
task4/cdnweb-frontend-deploy.template.yaml
```

### Why Use `${NAME}`?

Because the task says all objects must have the name:

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
git add task4/cdnweb-frontend-build.template.yaml task4/cdnweb-frontend-deploy.template.yaml
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

The password is wrapped in single quotes because of the exclamation mark.

---

# Step 9: Process and Apply the Build Template

Run this command from inside the cloned repository:

```bash
oc process -f task4/cdnweb-frontend-build.template.yaml \
  -p NAME=cdnweb-ui \
  -p SOURCE_REPOSITORY_URL=git.ocp4.example.com/developer/mycdn.git \
  -p SOURCE_REPOSITORY_REF=cdn-v4 \
  -p NPM_REGISTRY=http://npm.docdn-v44.example.com:8081/repository/npm-reg/ \
  -p REGISTRY_URL=registry.docdn-v44.example.com \
  -p BACKEND_URL=https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/ \
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
| NPM registry | `http://npm.docdn-v44.example.com:8081/repository/npm-reg/` |
| Container registry | `registry.docdn-v44.example.com` |
| Backend URL | `https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/` |

---

## If Your Template Uses Different Parameter Names

First list the parameters:

```bash
oc process --parameters -f task4/cdnweb-frontend-build.template.yaml
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
| `NPM_REGISTRY` | `http://npm.docdn-v44.example.com:8081/repository/npm-reg/` |
| `NPM_MIRROR` | `http://npm.docdn-v44.example.com:8081/repository/npm-reg/` |
| `BACKEND_URL` | `https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/` |
| `APPLICATION_SERVICE` | `https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/` |
| `REGISTRY_URL` | `registry.docdn-v44.example.com` |

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
oc process --parameters -f task4/cdnweb-frontend-build.template.yaml
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
oc process -f task4/cdnweb-frontend-deploy.template.yaml \
  -p NAME=cdnweb-ui \
  -p FRONTEND_URL=https://cdnweb-ui-tiger.apps.docdn-v44.example.com/ \
  | oc apply -f -
```

### Explanation

This processes and applies the deployment template.

The cdn-v4 customizations are:

| Requirement | Value |
|---|---|
| Object name | `cdnweb-ui` |
| Public frontend URL | `https://cdnweb-ui-tiger.apps.docdn-v44.example.com/` |
| Labels | `app=cdnweb-ui,group=cdnweb` |

---

## If Deploy Template Uses a Route Host Parameter

Some templates expect only the hostname, not the full URL.

If your deployment template asks for `HOSTNAME`, `APPLICATION_DOcdn-v4`, or `ROUTE_HOST`, use this value:

```text
cdnweb-ui-tiger.apps.docdn-v44.example.com
```

not:

```text
https://cdnweb-ui-tiger.apps.docdn-v44.example.com/
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
cdnweb-ui-tiger.apps.docdn-v44.example.com
```

Use the full URL only if the template parameter specifically asks for the frontend public URL.

---

# Step 14: Create the Frontend Route If the Template Does Not Create It

If the deployment template does not create the route automatically, create it manually:

```bash
oc create route edge cdnweb-ui \
  --service=cdnweb-ui \
  --hostname=cdnweb-ui-tiger.apps.docdn-v44.example.com
```

### Explanation

This exposes the frontend service publicly over HTTPS.

Do not use this as the hostname:

```text
https://cdnweb-ui-tiger.apps.docdn-v44.example.com/
```

Use only:

```text
cdnweb-ui-tiger.apps.docdn-v44.example.com
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
curl -k https://cdnweb-ui-tiger.apps.docdn-v44.example.com/
```

If the frontend loads but cannot communicate with the backend, check that the backend URL parameter was set correctly:

```text
https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/
```

---

# Complete Final Command Set

Use this clean sequence.

```bash
# 1. Switch to the correct project
oc project tiger || oc new-project tiger

# 2. Clone the source repository
git clone 'http://developer:d3v3lop3r@git.docdn-v44.example.com:5000/filesmart/cdnweb-frontend.git'

# 3. Enter the repository
cd cdnweb-frontend

# 4. Inspect template parameters
oc process --parameters -f task4/cdnweb-frontend-build.template.yaml
oc process --parameters -f task4/cdnweb-frontend-deploy.template.yaml

# 5. Edit the build template and add REGISTRY_URL parameter
vim task4/cdnweb-frontend-build.template.yaml

# 6. Edit labels in both templates
vim task4/cdnweb-frontend-build.template.yaml
vim task4/cdnweb-frontend-deploy.template.yaml

# 7. Commit and push template changes
git status
git add task4/cdnweb-frontend-build.template.yaml task4/cdnweb-frontend-deploy.template.yaml
git commit -m "Add registry parameter and cdnweb labels to frontend templates"
git push origin cdn-v4

# 8. Create Git authentication secret
oc create secret generic cdnweb-ui-git-auth \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=developer \
  --from-literal=password='d3v3lop3r'

# 9. Process and apply build template
oc process -f task4/cdnweb-frontend-build.template.yaml \
  -p NAME=cdnweb-ui \
  -p SOURCE_REPOSITORY_URL=git.ocp4.example.com/developer/mycdn.git \
  -p SOURCE_REPOSITORY_REF=cdn-v4 \
  -p NPM_REGISTRY=http://npm.docdn-v44.example.com:8081/repository/npm-reg/ \
  -p REGISTRY_URL=registry.docdn-v44.example.com \
  -p BACKEND_URL=https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/ \
  | oc apply -f -

# 10. Attach Git source secret to BuildConfig
oc set build-secret --source bc/cdnweb-ui cdnweb-ui-git-auth

# 11. Start build
oc start-build cdnweb-ui --follow

# 12. Process and apply deployment template
oc process -f task4/cdnweb-frontend-deploy.template.yaml \
  -p NAME=cdnweb-ui \
  -p FRONTEND_URL=https://cdnweb-ui-tiger.apps.docdn-v44.example.com/ \
  | oc apply -f -

# 13. Create route manually if template does not create it
oc create route edge cdnweb-ui \
  --service=cdnweb-ui \
  --hostname=cdnweb-ui-tiger.apps.docdn-v44.example.com

# 14. Verify resources
oc get all
oc get all -l app=cdnweb-ui,group=cdnweb
oc get route cdnweb-ui
oc get pods
```

---

# Errors in the Given Rough Solution

The rough solution was:

```bash
oc new-project patrol

Git clone git.ocp4.example.com/developer/mycdn.git
Cd cdnweb-frontend

Add parameters description and labels in both yaml

Vim build.yaml

Add parameters:
-
name: REGISTRY
URL
_
description: container registry url
required: true

- name: NAME
description: app name
required: true
-
name: APPLICATION
SERVICE
_
description: container registry url
required: true

labels:
app: cdnweb-ui
groups: cdnweb

Same as deploy.yaml as required

git status
git add .
git commit -m 'add param and desc'
git push

oc apply -f template
_
oc apply -f template
_
build.yaml
deploy.yaml

oc new-app --template TEMPLATE
_
NAME -p PARAM
NAME=PARAM
_
_
"app=label,group=groupLabel"
VALUE -l

oc new-app --template TEMPLATE
_
NAME2 -p PARAM
NAME=PARAM
_
_
"app=label,group=groupLabel"
VALUE -l

oc create route edge --service custom-u
```

---

## Error 1: Wrong project name

Wrong:

```bash
oc new-project patrol
```

Correct:

```bash
oc project tiger
```

or:

```bash
oc new-project tiger
```

The task says `tiger`, not `patrol`.

---

## Error 2: Git authentication is missing

The rough solution clones the repository without configuring credentials.

The task requires:

```text
Username: developer
Password: d3v3lop3r
```

Correct clone command:

```bash
git clone 'http://developer:d3v3lop3r@git.docdn-v44.example.com:5000/filesmart/cdnweb-frontend.git'
```

Also create an OpenShift source secret:

```bash
oc create secret generic cdnweb-ui-git-auth \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=developer \
  --from-literal=password='d3v3lop3r'
```

---

## Error 3: Wrong or broken parameter name

Wrong rough form:

```yaml
name: REGISTRY
URL
_
```

Correct:

```yaml
- name: REGISTRY_URL
  description: My CDN image registry
  required: true
```

The question formatting is broken, but the intended parameter name is `REGISTRY_URL`.

---

## Error 4: Wrong label key

Wrong:

```yaml
groups: cdnweb
```

Correct:

```yaml
group: cdnweb
```

The selector must be:

```text
app=cdnweb-ui,group=cdnweb
```

not:

```text
app=cdnweb-ui,groups=cdnweb
```

---

## Error 5: Template file names are wrong

The rough solution says:

```text
build.yaml
deploy.yaml
```

But the question gives exact file paths:

```text
task4/cdnweb-frontend-build.template.yaml
task4/cdnweb-frontend-deploy.template.yaml
```

Use the exact files given in the task.

---

## Error 6: Template application method is unclear

The rough solution mixes:

```bash
oc apply -f template
```

and:

```bash
oc new-app --template TEMPLATE_NAME
```

A clean way is:

```bash
oc process -f template.yaml -p KEY=VALUE | oc apply -f -
```

This processes the template with custom parameters and applies the generated resources.

---

## Error 7: Missing NPM registry value

The task requires the NPM registry to be:

```text
http://npm.docdn-v44.example.com:8081/repository/npm-reg/
```

The rough solution does not clearly set it.

Correct parameter example:

```bash
-p NPM_REGISTRY=http://npm.docdn-v44.example.com:8081/repository/npm-reg/
```

---

## Error 8: Missing backend URL value

The task requires the backend URL to be:

```text
https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/
```

Correct parameter example:

```bash
-p BACKEND_URL=https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/
```

---

## Error 9: Missing frontend URL value

The task requires the frontend URL to be:

```text
https://cdnweb-ui-tiger.apps.docdn-v44.example.com/
```

Correct parameter example:

```bash
-p FRONTEND_URL=https://cdnweb-ui-tiger.apps.docdn-v44.example.com/
```

---

## Error 10: Route command is incomplete

Wrong:

```bash
oc create route edge --service custom-u
```

Correct:

```bash
oc create route edge cdnweb-ui \
  --service=cdnweb-ui \
  --hostname=cdnweb-ui-tiger.apps.docdn-v44.example.com
```

---

# Expected Template Snippets

## Build Template Parameter Snippet

Inside:

```text
task4/cdnweb-frontend-build.template.yaml
```

add:

```yaml
parameters:
- name: REGISTRY_URL
  description: My CDN image registry
  required: true
```

---

## Template Label Snippet

Inside both templates:

```yaml
labels:
  app: ${NAME}
  group: cdnweb
```

---

## Deployment Template Pod Label Snippet

Inside the deployment object:

```yaml
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
oc process --parameters -f task4/cdnweb-frontend-build.template.yaml
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
cdnweb-ui-tiger.apps.docdn-v44.example.com
```

---

## 7. Verify application

```bash
curl -k https://cdnweb-ui-tiger.apps.docdn-v44.example.com/
```

---

# Troubleshooting

## Problem 1: `REGISTRY_URL` parameter not found

If you see:

```text
unknown parameter name "REGISTRY_URL"
```

Then the parameter was not added correctly to:

```text
task4/cdnweb-frontend-build.template.yaml
```

Fix the `parameters:` section and apply again.

---

## Problem 2: Build cannot clone Git repository

If the build fails with authentication errors, verify the secret:

```bash
oc get secret cdnweb-ui-git-auth
```

Check BuildConfig:

```bash
oc get bc cdnweb-ui -o yaml
```

Look for:

```yaml
sourceSecret:
  name: cdnweb-ui-git-auth
```

If missing, run:

```bash
oc set build-secret --source bc/cdnweb-ui cdnweb-ui-git-auth
```

Then rebuild:

```bash
oc start-build cdnweb-ui --follow
```

---

## Problem 3: NPM install fails

Check whether the NPM registry parameter was passed correctly:

```bash
oc logs -f bc/cdnweb-ui
```

The registry should be:

```text
http://npm.docdn-v44.example.com:8081/repository/npm-reg/
```

If the app tries to download from the public npm registry, the NPM registry parameter was not passed correctly or the template does not use it properly.

---

## Problem 4: Route already exists

If you see:

```text
Error from server (AlreadyExists): routes.route.openshift.io "cdnweb-ui" already exists
```

That means the deploy template already created the route.

Check it:

```bash
oc get route cdnweb-ui
```

If the hostname is wrong, edit or replace it:

```bash
oc edit route cdnweb-ui
```

---

## Problem 5: Route hostname contains `https://`

If the route host is set like this:

```text
https://cdnweb-ui-tiger.apps.docdn-v44.example.com/
```

that is wrong for a Route host.

Correct Route host:

```text
cdnweb-ui-tiger.apps.docdn-v44.example.com
```

The URL has `https://`, but the OpenShift route hostname does not.

---

# Important Teaching Notes

## Build Template vs Deploy Template

The build template usually creates resources like:

```text
BuildConfig
ImageStream
Secret
```

The deploy template usually creates resources like:

```text
Deployment
Service
Route
ConfigMap
```

That is why the task gives two separate templates.

---

## Why `REGISTRY_URL` Is Added Only to the Build Template

The requirement says:

```text
Define on the build template a new required parameter named REGISTRY_URL
```

This is because the build process needs to know where the resulting image should be stored or referenced.

The deploy template may consume the image later, but the missing parameter is specifically required in the build template.

---

## Why Git Push Is Mandatory

The question says the template changes must be pushed into the Git repository.

That means:

```bash
git commit
git push
```

are part of the actual answer, not optional decoration.

---

## Why Labels Matter

This selector must work:

```bash
oc get all -l app=cdnweb-ui,group=cdnweb
```

So every resource from the templates should have:

```yaml
app: cdnweb-ui
group: cdnweb
```

If this selector does not return the created resources, the label requirement is not satisfied.

---

# Final Exam-Ready Answer

```bash
oc project tiger || oc new-project tiger

git clone 'http://developer:d3v3lop3r@git.docdn-v44.example.com:5000/filesmart/cdnweb-frontend.git'
cd cdnweb-frontend

oc process --parameters -f task4/cdnweb-frontend-build.template.yaml
oc process --parameters -f task4/cdnweb-frontend-deploy.template.yaml

vim task4/cdnweb-frontend-build.template.yaml
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
git add task4/cdnweb-frontend-build.template.yaml task4/cdnweb-frontend-deploy.template.yaml
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
oc process -f task4/cdnweb-frontend-build.template.yaml \
  -p NAME=cdnweb-ui \
  -p SOURCE_REPOSITORY_URL=git.ocp4.example.com/developer/mycdn.git \
  -p SOURCE_REPOSITORY_REF=cdn-v4 \
  -p NPM_REGISTRY=http://npm.docdn-v44.example.com:8081/repository/npm-reg/ \
  -p REGISTRY_URL=registry.docdn-v44.example.com \
  -p BACKEND_URL=https://cdnweb-be-tiger-db.apps.docdn-v44.example.com/ \
  | oc apply -f -
```

Attach source secret and start build:

```bash
oc set build-secret --source bc/cdnweb-ui cdnweb-ui-git-auth
oc start-build cdnweb-ui --follow
```

Process deploy template:

```bash
oc process -f task4/cdnweb-frontend-deploy.template.yaml \
  -p NAME=cdnweb-ui \
  -p FRONTEND_URL=https://cdnweb-ui-tiger.apps.docdn-v44.example.com/ \
  | oc apply -f -
```

Create route if needed:

```bash
oc create route edge cdnweb-ui \
  --service=cdnweb-ui \
  --hostname=cdnweb-ui-tiger.apps.docdn-v44.example.com
```

Verify:

```bash
oc get all -l app=cdnweb-ui,group=cdnweb
oc get route cdnweb-ui
curl -k https://cdnweb-ui-tiger.apps.docdn-v44.example.com/
```

---

# Final Summary

To solve Task 6 correctly:

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
