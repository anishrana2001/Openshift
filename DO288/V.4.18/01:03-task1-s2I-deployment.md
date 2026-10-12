<div align="center">

# 🔴 EX288 Task 1

## Build and Deploy an Application using S2I

![OpenShift](https://img.shields.io/badge/OpenShift-4.18-EE0000?logo=redhatopenshift&logoColor=white)
![Build](https://img.shields.io/badge/Source2Image_Strategy-2496ED?logo=docker&logoColor=white)
![Project](https://img.shields.io/badge/Project-production1-7B42BC)
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
mkdir -p /home/student/ex288/
cd /home/student/ex288/
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/999-EX288-Task-1-lab.sh
chmod 775 999-EX288-Task-1-lab.sh
sh 999-EX288-Task-1-lab.sh
````

---

# Q1 — Build and Deploy `todo-ssr` on OpenShift

You are a developer working on an OpenShift cluster.

- The application must be built and deployed from the source code at:
  `https://git.ocp4.example.com/developer/task1-nodejs-helloworld.git`
- The application source code is located in the subdirectory: `apps/task1/helloworld`
- The Git Branch is **`secure-api`**
- The application must be deployed to the project `production1`
- The deployed application and its resources must be named `todo-ssr`
- The application must be based on the image stream tag `nodejs:18-ubi9`
- The application's dependencies are available at: `http://nexus-infra.apps.ocp4.example.com/repository/npm`
- The Git server requires authentication using the following credentials:
```
Username: developer
Password: d3v3lop3r
```
- The Git credentials must be stored as a secret and made available to the build process.
- The application must be accessible using both:
    - http://todo-ssr-production1.apps.ocp4.example.com
    - https://todo-ssr-production1.apps.ocp4.example.com

### Hint

- The npm dependency repository can be passed to the build environment using **`npm_config_registry`**

---
<details>
<summary><strong>✅ 🚀 Show the complete solution and explanation</strong></summary>


---

# 1. Login to OpenShift

Login using the developer account:

```bash
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

---

# 2. Switch to the Required Project

Change to the `production1` project:

```bash
oc project production1
```

---

# 🔐 3. Create Git Authentication Secret

The Git repository requires authentication. Create a secret containing the Git credentials.

```bash
oc create secret generic gitlab-secret \
--type=kubernetes.io/basic-auth \
--from-literal=username=developer \
--from-literal=password=d3v3lop3r
```


<img width="1842" height="1037" alt="Openshift Documentation" src="https://github.com/user-attachments/assets/b4ef4332-5507-4e54-b141-c2c5fdbc51f5" />


---

## Verify Secret Creation

```bash
oc get secrets
```

Expected:

```text
gitlab-secret
```

---

# 🔗 4. Add Git URL Matching Annotation

OpenShift uses the annotation below to automatically associate the secret with the matching Git repository URL.

```bash
oc annotate secret gitlab-secret \
"build.openshift.io/source-secret-match-uri-1=https://git.ocp4.example.com/*"
```

---

## Verify Annotation

```bash
oc describe secret gitlab-secret
```

Expected:

```text
Annotations:
  build.openshift.io/source-secret-match-uri-1: https://git.ocp4.example.com/*
```

---

# 🔑 5. Link Secret to Builder Service Account

The S2I build process runs using the `builder` service account.

Link the Git secret:

```bash
oc secrets link builder gitlab-secret
```

---

## Verify Builder Service Account

```bash
oc describe serviceaccount builder
```

Expected:

```text
Mountable secrets:
  builder-dockercfg-xxxxx
  gitlab-secret
```

---

# 🚀 6. Create the Application

Create the application using Source-to-Image (S2I).

```bash
oc new-app \
--name=todo-ssr \
--build-env npm_config_registry=http://nexus-infra.apps.ocp4.example.com/repository/npm \
nodejs:18-ubi9~https://git.ocp4.example.com/developer/task1-nodejs-helloworld.git#secure-api \
--context-dir=apps/task1/helloworld
```

### If you forget the command or syntax then use the Openshift documentation. 

<img width="1864" height="1037" alt="Openshift Doc for (--build-env) " src="https://github.com/user-attachments/assets/5b13bc76-9420-444b-ae72-0ee322dd9a8a" />


---

## Application Resources Created

The above command creates:

| Resource | Purpose |
|---|---|
| BuildConfig | Defines the source build process |
| ImageStream | Stores generated container images |
| Deployment | Runs application pods |
| Service | Provides internal application access |

---

# 📊 7. Monitor the Build

Check the build status:

```bash
oc get builds
```

# 🐞 Troubleshooting Build Failure

If the build fails, first check the build status:

```bash
oc get all
```

Example:

```text
NAME                   READY   STATUS
pod/todo-ssr-1-build   0/1     Error
```

---

# 🔍 Check Build Logs

View the build pod logs:

```bash
oc logs pods/todo-ssr-1-build
```

Example error:

```text
npm error code EJSONPARSE

npm error JSON.parse Unexpected string in JSON at position 271

npm error JSON.parse Failed to parse JSON data.
```

---

# 📝 Identify Application Issue

The above error indicates that the problem is inside the application source code.

In this example, the issue is with the `package.json` file.

### Clone the repository for validation:

```bash
git clone https://git.ocp4.example.com/developer/task1-nodejs-helloworld.git
```

Move into the repository:

```bash
cd task1-nodejs-helloworld/
```

```
ls -ltr
```

```
cd apps/task1/helloworld/
```

# ✅ Validate package.json

Run:

```bash
python3 -m json.tool package.json
```

If the JSON is invalid, you will see an error similar to:

```text
Expecting ':' delimiter:
line 12 column 15
```

---

# ❌ Incorrect package.json

Example:

```json
  "name": "nodejs-helloworld",
  "version": "1.0.0",
  "description": "Hello World!"
  "main": "devopswala.js",

{
  "dependencies": {
    "express" "^4.20.0"
  }
}
```
"description": "Hello World!"   ==> comma is missing at the end of line.
The problem is the missing `:` between the package name and version.

---

# ✅ Correct package.json

```json
{
  "dependencies": {
    "express": "^4.20.0"
  }
}
```

---

# 🔄 Commit and Push the Fix

After correcting the file:

```bash
# git add .   ==> If we add "-a" option with commit sub command than no need to run this command.

git commit -am "Fix package.json syntax"

git push
```

---

# ▶️ Start a New Build

Trigger a new build:

```bash
oc start-build bc/todo-ssr --follow
```

---

# 🔎 Verify Deployment

Check resources:

```bash
oc get all
```

Expected:

```text
pod/todo-ssr-xxxxx   1/1   Running

deployment.apps/todo-ssr   1/1

build.build.openshift.io/todo-ssr-2   Complete
```
## Fix Service Port

```
oc edit svc todo-ssr 
```

targetPort: 3000

---

# 🌐 Create Application Route

Create an HTTPS edge route:

```bash
oc create route edge \
--service=todo-ssr \
--hostname=todo-ssr-production1.apps.ocp4.example.com \
--insecure-policy=Allow
```

---

# ✅ Test Application

Test HTTPS:

```bash
curl https://todo-ssr-production1.apps.ocp4.example.com
```

Test HTTP:

```bash
curl http://todo-ssr-production1.apps.ocp4.example.com
```



Modify the service's port to 3000.

```
oc edit service/todo-ssr
```

Expected output:

```text
Hello World!
```


---

# 📋 Quick Command Reference

## Create Git Secret

```bash
oc create secret generic gitlab-secret \
--type=kubernetes.io/basic-auth \
--from-literal=username=developer \
--from-literal=password=d3v3lop3r
```

---

## Link Secret

```bash
oc secrets link builder gitlab-secret
```

---

## Create Application

```bash
oc new-app \
--name=todo-ssr \
--build-env npm_config_registry=http://nexus-infra.apps.ocp4.example.com/repository/npm \
nodejs:18-ubi9~https://git.ocp4.example.com/developer/task1-nodejs-helloworld.git#secure-api \
--context-dir=apps/task1/helloworld
```

---

## Check Application

```bash
oc get all
```

---

## Check Build Logs

```bash
oc logs pods/todo-ssr-1-build
```

---

## Start New Build

```bash
oc start-build bc/todo-ssr --follow
```

---

## Create Route

```bash
oc create route edge \
--service=todo-ssr \
--hostname=todo-ssr-production1.apps.ocp4.example.com \
--insecure-policy=Allow
```

| Your current working flow | The traffic flow is |
|---------------------------|---------------------|
| **Service:**<br><br>Port: 8080<br>TargetPort: 3000<br><br>**Pod:**<br><br>IP: 10.8.0.123<br>Application: Node.js Express<br>Port: 3000 | **1. curl request**<br><br>Command:<br>`curl http://todo-ssr-production1.apps.ocp4.example.com`<br><br>↓<br><br>**2. OpenShift Router**<br><br>• Entry point for external traffic<br>• Receives hostname from request<br><br>Host:<br>`todo-ssr-production1.apps.ocp4.example.com`<br><br>↓<br><br>**3. Route**<br><br>Route:<br>`todo-ssr-production1.apps.ocp4.example.com`<br><br>Router finds matching Route and forwards traffic to Service:<br>`todo-ssr`<br><br>↓<br><br>**4. Service**<br><br>Service:<br>`todo-ssr`<br><br>Port: `8080`<br><br>ClusterIP:<br>`172.30.86.59`<br><br>↓<br><br>**5. Service NAT Translation**<br><br>Service Port&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Pod Port<br><br>`8080` ------------> `3000`<br><br>Service receives traffic on 8080 and forwards it to application port 3000<br><br>↓<br><br>**6. Pod**<br><br>Pod IP:<br>`10.8.0.123`<br><br>Endpoint:<br>`10.8.0.123:3000`<br><br>Service selector:<br>`deployment=todo-ssr`<br><br>↓<br><br>**7. Node.js Express Application**<br><br>Application listens:<br>`app.listen(3000)`<br><br>Request:<br>`GET /`<br><br>Response:<br>`Hello World!` |

---

# 🧹 Lab Cleanup

Remove application resources:

```bash
oc delete all -l app=todo-ssr
rm -rf /home/student/ex288/task1/
oc delete project production1 
```

# Direct commands.

```bash
oc create secret generic gitlab-secret --type=kubernetes.io/basic-auth --from-literal=username=developer --from-literal=password=d3v3lop3r
oc annotate secret gitlab-secret "build.openshift.io/source-secret-match-uri-1=https://git.ocp4.example.com/*"
oc secrets link builder gitlab-secret
oc new-app --name=todo-ssr \
--build-env npm_config_registry=http://nexus-infra.apps.ocp4.example.com/repository/npm \
nodejs:18-ubi9~https://git.ocp4.example.com/developer/task1-nodejs-helloworld.git#secure-api \
--context-dir=apps/task1/helloworld 
oc get pods
oc get all
oc logs pods/todo-ssr-1-build 
git clone  https://git.ocp4.example.com/developer/task1-nodejs-helloworld.git
ls -ltr
cd task1-nodejs-helloworld/
python3 -m json.tool package.json 
cat -n package.json 
vim package.json 
python3 -m json.tool package.json 
git add . ; git commit -m "hi" ; git push 
oc start-build bc/todo-ssr --follow 
oc get all
oc create route edge --service=todo-ssr --hostname=todo-ssr-production1.apps.ocp4.example.com --insecure-policy=Allow
oc edit service/todo-ssr
curl https://todo-ssr-production1.apps.ocp4.example.com
curl http://todo-ssr-production1.apps.ocp4.example.com
```


# 🎓 End of Lab

</details>
