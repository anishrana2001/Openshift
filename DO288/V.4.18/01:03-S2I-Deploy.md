
# EX288 Practice Lab - Deploy Application using S2I

## How to Prepare the Lab?

Start the lab environment:

```bash
lab start deploy-introduction
oc login -u developer -p developer https://api.ocp4.example.com:6443
oc new-project deploy-cli
````

---

# Q1 — Build and Deploy `todo-ssr` on OpenShift

## Question

You are a developer working on an OpenShift cluster.

- The application must be built and deployed from the source code at: `https://git.ocp4.example.com/developer/DO288-apps`
- The application source code is located in the subdirectory: `apps/compreview-todo/todo-ssr`
- The application must be deployed to the project `deploy-cli`
- The deployed application and its resources must be named `todo-ssr`
- The application must be based on the image stream tag `httpd:2.4-ubi9`
- The application's dependencies are available at: `http://nexus-infra.apps.ocp4.example.com/repository/npm`
- The Git server requires authentication using the following credentials:
```
Username: developer
Password: d3v3lop3r
```
- The Git credentials must be stored as a secret and made available to the build process.
- The application must be accessible using both:
    - http://todo-ssr.apps.ocp4.example.com
    - https://todo-ssr.apps.ocp4.example.com

### Hint

- The npm dependency repository can be passed to the build environment using `npm_config_registry`

---

# Solution

## 1. Login to OpenShift

Login using the developer account:

```bash
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

---

# 2. Switch to the Required Project

Change to the `deploy-cli` project:

```bash
oc project deploy-cli
```

---

# 3. Create Git Authentication Secret

Create a secret containing Git credentials:

```bash
oc create secret generic gitlab-secret \
--type=kubernetes.io/basic-auth \
--from-literal=username=developer \
--from-literal=password=d3v3lop3r
```

Verify:

```bash
oc get secrets
```

Expected:

```
gitlab-secret
```

---

# 4. Add Git URL Matching Annotation

Annotate the secret so OpenShift can automatically associate it with the Git repository.

```bash
oc annotate secret gitlab-secret \
"build.openshift.io/source-secret-match-uri-1=https://git.ocp4.example.com/*"
```

Verify:

```bash
oc describe secret gitlab-secret
```

Expected:

```
Annotations:
  build.openshift.io/source-secret-match-uri-1: https://git.ocp4.example.com/*
```

---

# 5. Link Secret to Builder Service Account

The S2I build runs using the `builder` service account.

Link the secret:

```bash
oc secrets link builder gitlab-secret
```

Verify:

```bash
oc describe serviceaccount builder
```

Expected:

```
Mountable secrets:
  builder-dockercfg-xxxxx
  gitlab-secret
```

---

# 6. Create the Application

Create the application using S2I:

```bash
oc new-app \
--name=todo-ssr \
--build-env npm_config_registry=http://nexus-infra.apps.ocp4.example.com/repository/npm \
httpd:2.4-ubi9~https://git.ocp4.example.com/developer/DO288-apps \
--context-dir=apps/compreview-todo/todo-ssr
```

This command creates:

* BuildConfig
* ImageStream
* Deployment
* Service

---

# 7. Monitor the Build

Check build status:

```bash
oc get builds
```

Example:

```
NAME          TYPE      STATUS
todo-ssr-1    Source    Complete
```

Follow build logs:

```bash
oc start-build todo-ssr --follow
```

---

# 8. Create HTTP + HTTPS Route

The application must support both HTTP and HTTPS.

Create an edge route:

```bash
oc create route edge \
--service=todo-ssr \
--hostname=todo-ssr.apps.ocp4.example.com \
--insecure-policy=Allow
```

Explanation:

## Edge Route

TLS terminates at the OpenShift router.

Traffic flow:

```
Client
 |
 | HTTPS
 |
OpenShift Router
 |
 | HTTP
 |
Service
 |
Application Pod
```

## insecure-policy=Allow

Allows both:

```
HTTP  --> Application
HTTPS --> Application
```

---

# 9. Verify Deployment

## Check Pods

```bash
oc get pods
```

Expected:

```
todo-ssr-xxxxx   Running
```

---

## Check BuildConfig

```bash
oc get bc
```

Expected:

```
todo-ssr
```

---

## Check Deployment

```bash
oc get deployment
```

Expected:

```
todo-ssr
```

---

## Check Service

```bash
oc get svc
```

Expected:

```
service/todo-ssr
```

---

## Check Route

```bash
oc get routes
```

Expected:

```
NAME       HOST/PORT                         TERMINATION

todo-ssr   todo-ssr.apps.ocp4.example.com    edge
```

---

# 10. Access Application

HTTP:

```
http://todo-ssr.apps.ocp4.example.com
```

HTTPS:

```
https://todo-ssr.apps.ocp4.example.com
```

Both should open successfully.

---

# Web Console Verification

Open:

```
https://console-openshift-console.apps.ocp4.example.com
```

Login:

```
Username: developer
Password: developer
```

Navigate to:

```
Project → deploy-cli
```

Verify:

* Builds
* Deployments
* Pods
* Services
* Routes

---

# Troubleshooting Commands

## Check Build Logs

```bash
oc logs build/todo-ssr-1
```

---

## Check BuildConfig

```bash
oc describe bc todo-ssr
```

---

## Check Route Details

```bash
oc describe route todo-ssr
```

---

## Check Application Logs

```bash
oc logs deployment/todo-ssr
```

---

# EX288 Key Learning Points

## S2I Deployment Flow

```
Git Repository
       |
       |
       v
BuildConfig
       |
       |
       v
S2I Builder Image
(httpd:2.4-ubi9)
       |
       |
       v
ImageStream
       |
       |
       v
Deployment
       |
       |
       v
Service
       |
       |
       v
Route
```

---

## Important Commands to Remember

Create application:

```bash
oc new-app builder~git-repository
```

Create secret:

```bash
oc create secret generic
```

Link build secret:

```bash
oc secrets link builder secret-name
```

Create HTTPS route:

```bash
oc create route edge
```

Allow HTTP + HTTPS:

```bash
--insecure-policy=Allow
```

---

# End of Lab

```
```
