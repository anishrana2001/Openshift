# 🚀 EX288 Practice Lab — Deploy `todo-app2` using Source-to-Image (S2I)


---

## 📚 Table of Contents

1. [🎯 Lab Objective](#-lab-objective)
2. [🧪 Prepare the Lab](#-prepare-the-lab)
3. [🧠 Understand What the Question Is Testing](#-understand-what-the-question-is-testing)
4. [✅ Step 1 — Select and Verify the Project](#-step-1--select-and-verify-the-project)
5. [🖼️ Step 2 — Inspect the Required Builder Image](#️-step-2--inspect-the-required-builder-image)
6. [🔐 Step 3 — Check Cross-Project Image Pull Permission](#-step-3--check-cross-project-image-pull-permission)
7. [🧩 Step 4 — Understand `system:image-puller`](#-step-4--understand-systemimage-puller)
8. [📥 Step 5 — Clone and Inspect the Source Repository](#-step-5--clone-and-inspect-the-source-repository)
9. [🛠️ Step 6 — Modify the Existing S2I `run` Script](#️-step-6--modify-the-existing-s2i-run-script)
10. [📤 Step 7 — Commit and Push the S2I Change](#-step-7--commit-and-push-the-s2i-change)
11. [🔑 Step 8 — Create the Git Source Secret](#-step-8--create-the-git-source-secret)
12. [🏗️ Step 9 — Build and Deploy `todo-app2`](#️-step-9--build-and-deploy-todo-app2)
13. [🔎 Step 10 — Verify the BuildConfig](#-step-10--verify-the-buildconfig)
14. [📦 Step 11 — Verify the Build and Pod](#-step-11--verify-the-build-and-pod)
15. [🌐 Step 12 — Configure HTTP and HTTPS Access](#-step-12--configure-http-and-https-access)
16. [🧪 Step 13 — Verify `SERVER_PORT=8081`](#-step-13--verify-server_port8081)
17. [🧾 Final Validation Checklist](#-final-validation-checklist)
18. [⚠️ Common Mistakes](#️-common-mistakes)
19. [🧠 Exam Memory Map](#-exam-memory-map)
20. [⚡ Fast Exam Runbook](#-fast-exam-runbook)

---

# 🎯 Lab Objective

You are a developer working on an OpenShift cluster.

Build and deploy an application with the following requirements:

# Q2 — Build and Deploy `todo-app2` on OpenShift

## Question: You are a developer working on an OpenShift cluster.

- The application must be built and deployed from the source code at: `https://git.ocp4.example.com/developer/DO288-apps`
- The application source code is located in the subdirectory: `labs/builds-s2i/s2i-scripts `
- The application must be deployed to the project `deploy-si`
- The deployed application and its resources must be named `todo-app2`
- The build **must modify the existing S2I scripts** of the `httpd:2.4-ubi9` builder image to set the `SERVER_PORT` **environment variable** with the value `8081`

- The application must be accessible using both:
    - http://todo-app2.apps.ocp4.example.com
    - https://todo-app2.apps.ocp4.example.com
---

> [!IMPORTANT]
> The wording **“must modify the existing S2I scripts”** is important.  
> This is **not the same** as simply adding `--build-env=SERVER_PORT=8081`.

| Requirement | Required Value |
|---|---|
| 📁 Project | `deploy-si` |
| 📦 Application/resource name | `todo-app2` |
| 🔗 Git repository | `https://git.ocp4.example.com/developer/DO288-apps` |
| 📂 Context directory | `labs/builds-s2i/s2i-scripts` |
| 🖼️ S2I builder | `httpd:2.4-ubi9` |
| 🌍 Builder namespace | `openshift` |
| ⚙️ Required S2I modification | `SERVER_PORT=8081` |
| 🔑 Git credentials | Must be stored in a Secret and used by the build |
| 🌐 HTTP URL | `http://todo-app2.apps.ocp4.example.com` |
| 🔒 HTTPS URL | `https://todo-app2.apps.ocp4.example.com` |


---

# 🧪 Prepare the Lab

Start the lab:

```bash
lab start deploy-introduction
```

Log in to OpenShift:

```bash
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

Create the project if it does not already exist:

```bash
oc new-project deploy-si
```

If you receive:

```text
Error from server (AlreadyExists): project.project.openshift.io "deploy-si" already exists
```

that is not a problem. Simply select it:

```bash
oc project deploy-si
```

Verify:

```bash
oc project
```

---

# 🧠 Understand What the Question Is Testing

The question is testing several OpenShift skills at once:

```text
Git source
   │
   ▼
Context directory
   │
   ▼
S2I builder: openshift/httpd:2.4-ubi9
   │
   ▼
Custom .s2i/bin/run
   │
   ├── existing httpd setup
   └── export SERVER_PORT=8081
   │
   ▼
BuildConfig
   │
   ▼
ImageStream: todo-app2
   │
   ▼
Deployment: todo-app2
   │
   ▼
Service: todo-app2
   │
   ▼
Route: todo-app2
   ├── HTTP
   └── HTTPS
```

### ❓ Why not just use `--build-env=SERVER_PORT=8081`?

This command:

```bash
--build-env=SERVER_PORT=8081
```

would place the variable in the BuildConfig approximately as:

```yaml
spec:
  strategy:
    sourceStrategy:
      env:
      - name: SERVER_PORT
        value: "8081"
```

That makes the variable available to the S2I build environment, but it does **not modify the provided S2I script**.

The requirement explicitly says:

> **The build must modify the existing S2I scripts.**

Therefore, for this lab, modify:

```text
labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

and add:

```bash
export SERVER_PORT=8081
```

---

# ✅ Step 1 — Select and Verify the Project

Select the required project:

```bash
oc project deploy-si
```

Verify the project exists:

```bash
oc get project deploy-si
```

Check the default service accounts:

```bash
oc get sa
```

Typical output:

```text
NAME       SECRETS   AGE
builder    1         ...
default    1         ...
deployer   1         ...
pipeline   1         ...
```

Inspect the `builder` service account:

```bash
oc describe sa builder
```

You should confirm:

```text
Name:        builder
Namespace:   deploy-si
```

> [!NOTE]
> OpenShift builds normally use the `builder` ServiceAccount unless another service account is explicitly configured.

---

# 🖼️ Step 2 — Inspect the Required Builder Image

The task requires:

```text
httpd:2.4-ubi9
```

Check that the ImageStreamTag exists:

```bash
oc get istag httpd:2.4-ubi9 -n openshift
```

Inspect it in detail:

```bash
oc describe istag httpd:2.4-ubi9 -n openshift
```

Look for these important values:

```text
io.openshift.s2i.scripts-url=image:///usr/libexec/s2i
io.s2i.scripts-url=image:///usr/libexec/s2i
STI_SCRIPTS_PATH=/usr/libexec/s2i
HTTPD_CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/httpd/
Exposes Ports: 8080/tcp, 8443/tcp
```

### 🧠 What does this tell us?

The builder's original embedded S2I scripts are located at:

```text
/usr/libexec/s2i
```

Typical S2I scripts include:

```text
/usr/libexec/s2i/assemble
/usr/libexec/s2i/run
/usr/libexec/s2i/save-artifacts
```

The source repository may override these scripts by providing files under:

```text
.s2i/bin/
```

For this lab, an existing custom `run` script is already provided.

---

# 🔐 Step 3 — Check Cross-Project Image Pull Permission

Your build runs in:

```text
deploy-si
```

but the builder ImageStreamTag is in:

```text
openshift
```

That is cross-project image access.

### 3.1 Check whether you can manage RoleBindings

```bash
oc auth can-i create rolebindings -n openshift
```

```bash
oc auth can-i update rolebindings -n openshift
```

Expected in the lab environment:

```text
yes
```

### 3.2 Check whether `deploy-si:builder` can pull image layers

```bash
oc auth can-i get imagestreams/layers \
  --as=system:serviceaccount:deploy-si:builder \
  -n openshift
```

If the result is:

```text
yes
```

the permission already exists.

If the result is:

```text
no
```

grant the permission:

```bash
oc policy add-role-to-user \
  system:image-puller \
  system:serviceaccount:deploy-si:builder \
  --namespace=openshift
```

Verify again:

```bash
oc auth can-i get imagestreams/layers \
  --as=system:serviceaccount:deploy-si:builder \
  -n openshift
```

Expected:

```text
yes
```

---

# 🧩 Step 4 — Understand `system:image-puller`

Check the built-in ClusterRole:

```bash
oc get clusterrole system:image-puller
```

Describe it:

```bash
oc describe clusterrole system:image-puller
```

The important permission is:

```text
Resources: imagestreams/layers
Verbs:     get
```

### 🔍 Command syntax

General syntax:

```bash
oc policy add-role-to-user <ROLE> <USER-OR-SA> --namespace=<TARGET_NAMESPACE>
```

For a ServiceAccount:

```bash
oc policy add-role-to-user <ROLE> \
  system:serviceaccount:<SA_NAMESPACE>:<SERVICE_ACCOUNT> \
  --namespace=<RESOURCE_NAMESPACE>
```

Your command:

```bash
oc policy add-role-to-user system:image-puller \
  system:serviceaccount:deploy-si:builder \
  --namespace=openshift
```

means:

```text
system:image-puller
        │
        └── ClusterRole being granted

system:serviceaccount:deploy-si:builder
                      │         │
                      │         └── ServiceAccount
                      └──────────── namespace where SA lives

--namespace=openshift
            │
            └── namespace containing the protected images
```

---

## 🤔 What about the existing `system:image-pullers` RoleBinding?

You may already see:

```bash
oc get rolebinding -n openshift
```

with:

```text
system:image-pullers    ClusterRole/system:image-puller
```

Inspect it:

```bash
oc get rolebinding system:image-pullers -n openshift -o yaml
```

It normally contains:

```yaml
subjects:
- kind: Group
  name: system:serviceaccounts:openshift
```

That means:

> All ServiceAccounts **inside the `openshift` namespace** can pull images from `openshift`.

It does **not** automatically include:

```text
system:serviceaccount:deploy-si:builder
```

because `builder` belongs to `deploy-si`.

Therefore a separate cross-project RoleBinding is valid.

### ⚠️ Do not casually edit `system:image-pullers`

Its annotation normally states that it is auto-managed by OpenShift.

Leave the platform-managed RoleBinding alone and grant the required external ServiceAccount its own access.

---

# 📥 Step 5 — Clone and Inspect the Source Repository

Move to your home directory:

```bash
cd ~
```

Clone the repository:

```bash
git clone https://git.ocp4.example.com/developer/DO288-apps
```

Enter the repository:

```bash
cd DO288-apps
```

Inspect the application directory:

```bash
ls -la labs/builds-s2i/s2i-scripts
```

Inspect the custom S2I scripts:

```bash
ls -la labs/builds-s2i/s2i-scripts/.s2i/bin
```

View the existing `run` script:

```bash
cat labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

Before modification, it may look similar to:

```bash
#!/bin/bash

source ${HTTPD_CONTAINER_SCRIPTS_PATH}/common.sh

export HTTPD_RUN_BY_S2I=1

# Make Apache show 'debug' level logs during start up
exec run-httpd -e debug $@
```

---

# 🛠️ Step 6 — Modify the Existing S2I `run` Script

Edit:

```bash
vi labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

Add:

```bash
export SERVER_PORT=8081
```

The completed file should be:

```bash
#!/bin/bash

source ${HTTPD_CONTAINER_SCRIPTS_PATH}/common.sh

export HTTPD_RUN_BY_S2I=1
export SERVER_PORT=8081

# Make Apache show 'debug' level logs during start up
exec run-httpd -e debug $@
```

Verify:

```bash
cat labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

### ✅ Quick verification

```bash
grep SERVER_PORT labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

Expected:

```text
export SERVER_PORT=8081
```

Check executable permissions:

```bash
ls -l labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

If required:

```bash
chmod +x labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

---

## 🧠 Why is this the correct solution?

The script already contains the existing HTTPD S2I startup logic:

```bash
source ${HTTPD_CONTAINER_SCRIPTS_PATH}/common.sh
export HTTPD_RUN_BY_S2I=1
exec run-httpd -e debug $@
```

You are not replacing this behavior with something unrelated.

You are adding:

```bash
export SERVER_PORT=8081
```

before Apache is launched.

Because `SERVER_PORT` is exported, the process started by:

```bash
exec run-httpd ...
```

inherits the variable.

> [!TIP]
> In production shell scripts, `"$@"` is safer than `$@`.  
> For this lab, however, avoid unnecessary changes to the supplied script unless the task requires them.

---

# 📤 Step 7 — Commit and Push the S2I Change

OpenShift builds from the **remote Git repository**, not from the copy sitting on your workstation.

If you edit locally but do not push, the build will happily clone the old code and ignore your masterpiece.

Check your change:

```bash
git status
```

```bash
git diff
```

You should see approximately:

```diff
 export HTTPD_RUN_BY_S2I=1
+export SERVER_PORT=8081
```

Stage the modified file:

```bash
git add labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

Commit:

```bash
git commit -m "Set SERVER_PORT in S2I run script"
```

Push:

```bash
git push
```

Verify:

```bash
git status
```

Ideally:

```text
nothing to commit, working tree clean
```

---

# 🔑 Step 8 — Create the Git Source Secret

The task explicitly says:

> **The Git credentials must be stored as a Secret and made available to the build process.**

Do not put a username/password directly into the Git URL.

> [!IMPORTANT]
> Use the Git credentials supplied by your lab.  
> Do **not** automatically assume that the OpenShift login (`developer/developer`) is also the Git credential unless the lab explicitly says so.

### 8.1 Create a Basic Authentication Secret

Example syntax:

```bash
oc create secret generic todo-app2-git \
  --type=kubernetes.io/basic-auth \
  --from-literal=username='<GIT_USERNAME>' \
  --from-literal=password='<GIT_PASSWORD>'
```

Verify:

```bash
oc get secret todo-app2-git
```

You can inspect metadata safely with:

```bash
oc describe secret todo-app2-git
```

Do not print secret values unnecessarily.

---

# 🏗️ Step 9 — Build and Deploy `todo-app2`

Because the source secret already exists, pass it directly to `oc new-app`:

```bash
oc new-app \
  openshift/httpd:2.4-ubi9~https://git.ocp4.example.com/developer/DO288-apps \
  --context-dir=labs/builds-s2i/s2i-scripts \
  --source-secret=todo-app2-git \
  --name=todo-app2 \
  --strategy=source \
  -n deploy-si
```

### 🧩 Break down the command

```text
openshift/httpd:2.4-ubi9
│         │     │
│         │     └── tag
│         └──────── ImageStream
└────────────────── namespace containing builder
```

The `~` connects:

```text
builder image ~ source repository
```

So:

```text
openshift/httpd:2.4-ubi9
             ~
https://git.ocp4.example.com/developer/DO288-apps
```

means:

> Build this Git source using this S2I builder.

The context directory:

```bash
--context-dir=labs/builds-s2i/s2i-scripts
```

tells OpenShift where the actual application is located inside the repository.

The name:

```bash
--name=todo-app2
```

ensures the generated application resources use the required name.

The source secret:

```bash
--source-secret=todo-app2-git
```

makes the Git credentials available to the BuildConfig for source cloning.

---

## 🔄 If `todo-app2` already exists

If you created the app before attaching the source secret, attach it afterward:

```bash
oc set build-secret --source bc/todo-app2 todo-app2-git
```

Then start a fresh build:

```bash
oc start-build todo-app2 --follow
```

Verify the secret reference:

```bash
oc get bc todo-app2 \
  -o jsonpath='{.spec.source.sourceSecret.name}{"\n"}'
```

Expected:

```text
todo-app2-git
```

---

# 🔎 Step 10 — Verify the BuildConfig

Check:

```bash
oc get bc todo-app2
```

Typical output:

```text
NAME        TYPE     FROM   LATEST
todo-app2   Source   Git    1
```

---

## 10.1 Verify Git repository

```bash
oc get bc todo-app2 \
  -o jsonpath='{.spec.source.git.uri}{"\n"}'
```

Expected:

```text
https://git.ocp4.example.com/developer/DO288-apps
```

---

## 10.2 Verify context directory

```bash
oc get bc todo-app2 \
  -o jsonpath='{.spec.source.contextDir}{"\n"}'
```

Expected:

```text
labs/builds-s2i/s2i-scripts
```

---

## 10.3 Verify source secret

```bash
oc get bc todo-app2 \
  -o jsonpath='{.spec.source.sourceSecret.name}{"\n"}'
```

Expected:

```text
todo-app2-git
```

---

## 10.4 Verify builder ImageStreamTag

```bash
oc get bc todo-app2 \
  -o jsonpath='{.spec.strategy.sourceStrategy.from.namespace}/{.spec.strategy.sourceStrategy.from.name}{"\n"}'
```

Expected:

```text
openshift/httpd:2.4-ubi9
```

---

## 10.5 Why `SERVER_PORT` may NOT appear in the BuildConfig

Do not expect this to return anything:

```bash
oc get bc todo-app2 -o yaml | grep SERVER_PORT
```

That is normal for **this solution**.

You did not configure:

```yaml
sourceStrategy:
  env:
```

Instead, you modified:

```text
.s2i/bin/run
```

with:

```bash
export SERVER_PORT=8081
```

### Remember

```text
SERVER_PORT=8081
      │
      └── check .s2i/bin/run

Builder/Git/context/sourceSecret
      │
      └── check BuildConfig
```

---

# 📦 Step 11 — Verify the Build and Pod

Check builds:

```bash
oc get builds
```

Expected:

```text
NAME          TYPE     FROM          STATUS
todo-app2-1   Source   Git@...       Complete
```

Follow build logs if needed:

```bash
oc logs -f bc/todo-app2
```

Check pods:

```bash
oc get pods
```

Typical result:

```text
NAME                         READY   STATUS      RESTARTS
todo-app2-1-build            0/1     Completed   0
todo-app2-xxxxxxxxxx-xxxxx   1/1     Running     0
```

Check all generated resources:

```bash
oc get all
```

You should normally see resources associated with:

```text
todo-app2
```

including the build, ImageStream, Deployment, Pod and Service.

---

# 🌐 Step 12 — Configure HTTP and HTTPS Access

The required hostname is:

```text
todo-app2.apps.ocp4.example.com
```

The application must work with both:

```text
http://todo-app2.apps.ocp4.example.com
https://todo-app2.apps.ocp4.example.com
```

Create an **edge TLS route** and allow insecure HTTP traffic:

```bash
oc create route edge todo-app2 \
  --service=todo-app2 \
  --hostname=todo-app2.apps.ocp4.example.com \
  --insecure-policy=Allow
```

### 🧠 Why `Allow`?

With edge TLS termination:

```text
Client --HTTPS--> OpenShift Router --HTTP--> Service/Pod
```

Setting:

```text
insecureEdgeTerminationPolicy: Allow
```

also permits HTTP requests rather than disabling or redirecting them.

Therefore the same route can satisfy:

```text
HTTP  ✅
HTTPS ✅
```

---

## 12.1 Verify the route

```bash
oc get route todo-app2
```

Check hostname:

```bash
oc get route todo-app2 \
  -o jsonpath='{.spec.host}{"\n"}'
```

Expected:

```text
todo-app2.apps.ocp4.example.com
```

Check TLS termination and HTTP policy:

```bash
oc get route todo-app2 \
  -o jsonpath='{.spec.tls.termination}{" "}{.spec.tls.insecureEdgeTerminationPolicy}{"\n"}'
```

Expected:

```text
edge Allow
```

---

## 12.2 Test HTTP

```bash
curl -I http://todo-app2.apps.ocp4.example.com
```

---

## 12.3 Test HTTPS

In a lab using a non-public or wildcard training certificate, you may need:

```bash
curl -k -I https://todo-app2.apps.ocp4.example.com
```

> [!NOTE]
> `-k` tells curl not to reject an untrusted training certificate.  
> It is useful for a controlled lab, not a habit to copy into production automation.

---

# 🧪 Step 13 — Verify `SERVER_PORT=8081`

There are **two levels of verification**.

---

## ✅ 13.1 Easiest source-level check

This is the simplest and most exam-friendly verification:

```bash
grep SERVER_PORT labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

Expected:

```text
export SERVER_PORT=8081
```

This proves that you made the required S2I script modification.

---

## ✅ 13.2 Runtime verification

Because the variable is exported by the startup script, a plain:

```bash
oc exec <pod> -- printenv | grep SERVER
```

may return nothing.

That command starts a new exec process whose environment comes from the container configuration; it is not the best way to prove an environment variable that was exported later by the startup script.

A shorter runtime check is:

```bash
oc exec deploy/todo-app2 -- \
  grep -ao 'SERVER_PORT=8081' /proc/1/environ
```

Expected:

```text
SERVER_PORT=8081
```

This checks the environment of the application's main process.

---

# 💡 About the `npm_config_registry` Hint

The question includes a hint:

> The npm dependency repository can be passed to the build environment using `npm_config_registry`.

For this specific `httpd` S2I exercise, do **not** blindly add an npm registry unless the application actually needs npm dependencies or the lab gives you a registry URL.

If a task explicitly provides an npm registry value, that is a **build environment variable**, for example:

```bash
oc set env bc/todo-app2 \
  npm_config_registry='<NPM_REGISTRY_URL>'
```

or it could be supplied while creating the app with the appropriate build-environment option.

This is different from the `SERVER_PORT` requirement.

```text
npm_config_registry
      │
      └── Build environment setting

SERVER_PORT=8081
      │
      └── Required modification inside .s2i/bin/run
```

Do not mix the two concepts merely because both happen to be environment variables. OpenShift already supplies enough nouns without us helping it create new confusion.

---

# 🧾 Final Validation Checklist

Before considering Q2 complete, verify every requirement.

- [ ] Logged in to the correct cluster
- [ ] Current project is `deploy-si`
- [ ] `httpd:2.4-ubi9` exists in namespace `openshift`
- [ ] `deploy-si:builder` can access image layers in `openshift`
- [ ] Git repository is `https://git.ocp4.example.com/developer/DO288-apps`
- [ ] Context directory is `labs/builds-s2i/s2i-scripts`
- [ ] `.s2i/bin/run` contains `export SERVER_PORT=8081`
- [ ] S2I script modification is committed and pushed
- [ ] Git credentials are stored in an OpenShift Secret
- [ ] BuildConfig references the Git source Secret
- [ ] Application/resources are named `todo-app2`
- [ ] Builder is `openshift/httpd:2.4-ubi9`
- [ ] Build status is `Complete`
- [ ] Application Pod is `Running`
- [ ] Route hostname is `todo-app2.apps.ocp4.example.com`
- [ ] Route uses edge TLS
- [ ] Route insecure policy is `Allow`
- [ ] HTTP URL works
- [ ] HTTPS URL works
- [ ] `SERVER_PORT=8081` can be verified in the S2I script
- [ ] Optional runtime verification shows `SERVER_PORT=8081`

---

# ⚠️ Common Mistakes

## ❌ Mistake 1 — Using only `--build-env=SERVER_PORT=8081`

Why it is wrong for this wording:

```text
Question says:
"modify the existing S2I scripts"
```

`--build-env` modifies BuildConfig environment settings, not the script file.

Correct approach:

```bash
vi labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

Add:

```bash
export SERVER_PORT=8081
```

---

## ❌ Mistake 2 — Editing the local file but forgetting `git push`

OpenShift clones:

```text
https://git.ocp4.example.com/developer/DO288-apps
```

It does not read the file directly from:

```text
~/DO288-apps
```

Always:

```bash
git status
git diff
git add ...
git commit ...
git push
```

---

## ❌ Mistake 3 — Modifying `system:image-pullers`

The existing:

```text
system:image-pullers
```

RoleBinding is normally platform managed and grants image pulling to:

```text
system:serviceaccounts:openshift
```

It does not represent `deploy-si:builder`.

Use the explicit cross-project grant when required:

```bash
oc policy add-role-to-user system:image-puller \
  system:serviceaccount:deploy-si:builder \
  --namespace=openshift
```

---

## ❌ Mistake 4 — Forgetting `--context-dir`

Without:

```bash
--context-dir=labs/builds-s2i/s2i-scripts
```

OpenShift builds from the repository root and may not find the correct application/S2I files.

---

## ❌ Mistake 5 — Checking `SERVER_PORT` only in BuildConfig

For this implementation:

```bash
oc get bc todo-app2 -o yaml | grep SERVER_PORT
```

may return nothing.

That does **not** prove the task is wrong.

Check:

```bash
grep SERVER_PORT labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

---

## ❌ Mistake 6 — Assuming `printenv` from `oc exec` must show the variable

This may be empty:

```bash
oc exec <pod> -- printenv | grep SERVER
```

because the variable was exported by the S2I startup script after container creation.

Use the source script as your simplest proof, or inspect the main process environment if runtime proof is required.

---

## ❌ Mistake 7 — Creating only an HTTP route

The task requires **both** schemes.

Use:

```bash
oc create route edge todo-app2 \
  --service=todo-app2 \
  --hostname=todo-app2.apps.ocp4.example.com \
  --insecure-policy=Allow
```

---

## ❌ Mistake 8 — Using `Redirect` when both URLs must remain directly usable

```text
Redirect
```

forces HTTP toward HTTPS.

If the requirement specifically expects both HTTP and HTTPS access, use:

```text
Allow
```

---

## ❌ Mistake 9 — Putting Git credentials in the URL

Avoid:

```text
https://username:password@git...
```

The task explicitly requires credentials to be stored as a Secret.

Use:

```text
Secret
   ↓
BuildConfig.spec.source.sourceSecret
```

---

# 🧠 Exam Memory Map

When you see:

> **Build must modify existing S2I scripts**

think:

```text
.s2i/bin/
```

When you see:

> **Use builder from another namespace**

think:

```text
system:image-puller
```

When you see:

> **Source is in a subdirectory**

think:

```text
--context-dir
```

When you see:

> **Private Git / Git credentials stored as Secret**

think:

```text
--source-secret
```

or:

```text
oc set build-secret --source
```

When you see:

> **Both HTTP and HTTPS**

think:

```text
edge route
+
insecureEdgeTerminationPolicy: Allow
```

---

# ⚡ Fast Exam Runbook

> Use this section only after you understand the full explanation above.

## 1️⃣ Prepare

```bash
lab start deploy-introduction

oc login -u developer -p developer \
  https://api.ocp4.example.com:6443

oc project deploy-si
```

---

## 2️⃣ Verify builder

```bash
oc get istag httpd:2.4-ubi9 -n openshift
```

```bash
oc describe istag httpd:2.4-ubi9 -n openshift
```

Look for:

```text
io.openshift.s2i.scripts-url=image:///usr/libexec/s2i
```

---

## 3️⃣ Verify/grant image pull permission

```bash
oc auth can-i get imagestreams/layers \
  --as=system:serviceaccount:deploy-si:builder \
  -n openshift
```

If `no`:

```bash
oc policy add-role-to-user system:image-puller \
  system:serviceaccount:deploy-si:builder \
  --namespace=openshift
```

---

## 4️⃣ Modify S2I script

```bash
cd ~/DO288-apps
```

```bash
vi labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

Required line:

```bash
export SERVER_PORT=8081
```

Verify:

```bash
grep SERVER_PORT labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

---

## 5️⃣ Commit and push

```bash
git status
git add labs/builds-s2i/s2i-scripts/.s2i/bin/run
git commit -m "Set SERVER_PORT in S2I run script"
git push
```

---

## 6️⃣ Create Git Secret

```bash
oc create secret generic todo-app2-git \
  --type=kubernetes.io/basic-auth \
  --from-literal=username='<GIT_USERNAME>' \
  --from-literal=password='<GIT_PASSWORD>'
```

---

## 7️⃣ Build and deploy

```bash
oc new-app \
  openshift/httpd:2.4-ubi9~https://git.ocp4.example.com/developer/DO288-apps \
  --context-dir=labs/builds-s2i/s2i-scripts \
  --source-secret=todo-app2-git \
  --name=todo-app2 \
  --strategy=source \
  -n deploy-si
```

---

## 8️⃣ Verify BuildConfig

```bash
oc get bc todo-app2
```

```bash
oc get bc todo-app2 \
  -o jsonpath='{.spec.source.git.uri}{"\n"}'
```

```bash
oc get bc todo-app2 \
  -o jsonpath='{.spec.source.contextDir}{"\n"}'
```

```bash
oc get bc todo-app2 \
  -o jsonpath='{.spec.source.sourceSecret.name}{"\n"}'
```

```bash
oc get bc todo-app2 \
  -o jsonpath='{.spec.strategy.sourceStrategy.from.namespace}/{.spec.strategy.sourceStrategy.from.name}{"\n"}'
```

Expected:

```text
https://git.ocp4.example.com/developer/DO288-apps
labs/builds-s2i/s2i-scripts
todo-app2-git
openshift/httpd:2.4-ubi9
```

---

## 9️⃣ Verify build/application

```bash
oc get builds
oc get pods
oc get all
```

Expected:

```text
Build: Complete
Pod:   Running
```

---

## 🔟 Create route

```bash
oc create route edge todo-app2 \
  --service=todo-app2 \
  --hostname=todo-app2.apps.ocp4.example.com \
  --insecure-policy=Allow
```

Verify:

```bash
oc get route todo-app2
```

```bash
oc get route todo-app2 \
  -o jsonpath='{.spec.tls.termination}{" "}{.spec.tls.insecureEdgeTerminationPolicy}{"\n"}'
```

Expected:

```text
edge Allow
```

---

## 1️⃣1️⃣ Test both URLs

```bash
curl -I http://todo-app2.apps.ocp4.example.com
```

```bash
curl -k -I https://todo-app2.apps.ocp4.example.com
```

---

## 1️⃣2️⃣ Verify S2I requirement

Fast source check:

```bash
grep SERVER_PORT labs/builds-s2i/s2i-scripts/.s2i/bin/run
```

Expected:

```text
export SERVER_PORT=8081
```

Optional runtime proof:

```bash
oc exec deploy/todo-app2 -- \
  grep -ao 'SERVER_PORT=8081' /proc/1/environ
```

Expected:

```text
SERVER_PORT=8081
```

---

# 🏁 Expected Final State

```text
Project:       deploy-si
Application:   todo-app2
Builder:       openshift/httpd:2.4-ubi9
Build Type:    Source / S2I
Git:           https://git.ocp4.example.com/developer/DO288-apps
Context:       labs/builds-s2i/s2i-scripts
Git Secret:    referenced by BuildConfig
S2I run:       export SERVER_PORT=8081
Build:         Complete
Pod:           Running
Route TLS:     edge
HTTP Policy:   Allow
HTTP:          working
HTTPS:         working
```

---

> ## 🎓 Instructor Takeaway
>
> The main lesson is not merely “how to deploy an httpd application.”  
> The task teaches you to separate **five different configuration layers**:
>
> 1. **RBAC** — Can the build ServiceAccount access the builder image?
> 2. **S2I customization** — What must the builder/runtime script do differently?
> 3. **Build source** — Which Git repo, context directory, and credentials are used?
> 4. **Build/deployment resources** — Are the correct image and resource names created?
> 5. **Networking** — Is the application exposed exactly as requested over HTTP and HTTPS?
>
> Once you learn to identify which layer owns each requirement, EX288 questions become much less mysterious. OpenShift itself remains fond of having six objects for what humans casually call “the app,” but at least now you know which one to inspect.
