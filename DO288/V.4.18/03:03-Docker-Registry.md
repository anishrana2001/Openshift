<div align="center">

# 🔴 EX288 Task 3

## Build and Deploy an HTTPD Application on OpenShift

![OpenShift](https://img.shields.io/badge/OpenShift-4.18-EE0000?logo=redhatopenshift&logoColor=white)
![Build](https://img.shields.io/badge/Docker_Strategy-2496ED?logo=docker&logoColor=white)
![Project](https://img.shields.io/badge/Project-task77-7B42BC)
![Guide](https://img.shields.io/badge/Guide-Student_Ready-2EA44F)

</div>

---

## 🧪 How to Prepare the Lab

Run these commands on the workstation as the `student` user. They download the
practice repository, initialize it as a Git repository, and push it to the lab
Git server.

> [!NOTE]
> Use these preparation commands on a fresh lab environment. Do not change the
> application files before attempting the task.

```bash
lab start deploy-introduction
oc login -u developer -p developer https://api.ocp4.example.com:6443
mkdir -p /home/student/ex288
cd /home/student/ex288

curl --fail --location \
  "https://raw.githubusercontent.com/anishrana2001/Openshift/main/DO288/V.4.18/devops-wala.tar" \
  --output /home/student/ex288/devops-wala.tar

tar -xf /home/student/ex288/devops-wala.tar
cd /home/student/ex288/devops-wala

git init -b main
git config user.name "Student"
git config user.email "student@ocp4.example.com"
git remote add origin \
  https://developer:d3v3lop3r@git.ocp4.example.com/developer/devops-wala.git

git add .
git commit -m "Add EX288 practice files"
git push -u origin main
rm -rf /home/student/ex288/devops-wala.tar
rm -rf /home/student/ex288/devops-wala/
oc new-project task77
oc create secret generic devops-git-secret --type=kubernetes.io/basic-auth --from-literal=username=developer --from-literal=password=d3v3lop3r
oc annotate secret devops-git-secret "build.openshift.io/source-secret-match-uri-1=https://git.ocp4.example.com/*"
oc secrets link builder devops-git-secret

```

Verify the repository:

```bash
git status
git remote -v
git log --oneline -1
```

Expected result: the current branch is `main`, the working tree is clean, and
`origin` points to the lab Git repository.

---

## 🎯 Original Question

Build and deploy the HTTPS application with the following requirements:

- The application must be built and deployed to the project `task77`.
- The deployed application and its resources must be named
  `ex288-docker-app`.
- The source code is available at `https://git.ocp4.example.com/developer/devops-wala/`
- The application source code directory is `apps/task77/`
- The Git reference is `main`.
- The `httpd:2.4-ubi9` base image stream must be used from the **`openshift`** namespace.
- The application binary is available at `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/Download-dir`
- The service must be publicly available on the default hostname.
- User **`student`** has only readonly privileges on Git.

> [!TIP]
> Attempt the task and inspect the build or runtime errors before opening the
> solution. The troubleshooting process is part of the exercise.

---

<details>
<summary><strong>✅ Show the complete solution and explanation</strong></summary>

## 🧠 Understand the Required Build

The source context contains a `Dockerfile`, so this task requires a **Docker
build strategy**.

The repository contains the following Dockerfile:

```dockerfile
FROM httpd:2.4-ubi9
ARG CodeBinary
RUN curl -fL "${CodeBinary}" -o /var/www/html/index.html
EXPOSE 8080
CMD ["run-httpd"]
```

### Task-to-resource mapping

| Task requirement | OpenShift field or resource |
|---|---|
| Git URL | `spec.source.git.uri` |
| Git reference | `spec.source.git.ref` |
| Context directory | `spec.source.contextDir` |
| Docker strategy | `spec.strategy.type` |
| Base image stream | `spec.strategy.dockerStrategy.from` |
| `CodeBinary` value | `spec.strategy.dockerStrategy.buildArgs` |
| Corrected Dockerfile | `spec.source.dockerfile` |
| Build output | `ImageStreamTag/ex288-docker-app:latest` |
| Workload | `Deployment/ex288-docker-app` |
| Internal access | `Service/ex288-docker-app` |
| External access | `Route/ex288-docker-app` |

---

## 🚀 Complete Solution

### Step 1: Confirm the OpenShift session

```bash
oc whoami
oc status
```

These commands must show the expected student account and a working cluster
connection.

### Step 2: Create and select the project

```bash
oc new-project task77
```

If the project already exists and belongs to you, select it instead:

```bash
oc project task77
```

Confirm the active project:

```bash
oc project -q
```

Expected output:

```text
task77
```

### Step 3: 

The `view` cluster role permits read-only access to most project resources and
does not grant permission to create, update, or delete them.

### Step 4: Verify the required base image stream

```bash
oc get istag/httpd:2.4-ubi9 -n openshift
```

The image stream tag must exist before the build is created.

> [!IMPORTANT]
> Do not try to grant permissions in the `openshift` namespace. A normal
> student account generally cannot change access in that shared namespace.

### Step 5: Inspect the supplied Dockerfile

```bash
git clone https://git.ocp4.example.com/developer/devops-wala/
```
```
[student@workstation devops-wala]$ git clone https://git.ocp4.example.com/developer/devops-wala/
Cloning into 'devops-wala'...
Username for 'https://git.ocp4.example.com': developer
Password for 'https://developer@git.ocp4.example.com':   d3v3lop3r
[student@workstation devops-wala]$
```


```bash
cd /home/student/ex288/devops-wala
cat apps/task77/Dockerfile
```

Compare its document root, exposed port, and runtime command with the required
UBI HTTPD values shown earlier.

### Step 6: Create the build with an inline Dockerfile override

```bash
oc new-build \
  openshift/httpd:2.4-ubi9~https://git.ocp4.example.com/developer/devops-wala/#main \
  --name=ex288-docker-app \
  --strategy=docker \
  --context-dir=apps/task77/ \
  --build-arg=CodeBinary=https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/Download-dir 
```

### Why this command is easier than memorizing a complete YAML file

- `IMAGE~GIT_URL#REF` supplies the required base image, Git repository, and
  branch.
- `--strategy=docker` selects a Docker build.
- `--context-dir` selects `apps/task77/` inside the repository.
- `--build-arg` passes the binary URL as `CodeBinary`.
- `--dockerfile=-` reads the corrected Dockerfile from the quoted here-document.
- `--name` creates the `BuildConfig` and output `ImageStream` with the required
  name.

> [!NOTE]
> `oc new-build` automatically starts the first build. Do not immediately run
> `oc start-build`, because that would unnecessarily create a second build.

### Step 7: Verify the generated BuildConfig

Check the Git source, branch, and context directory:

```bash
oc get bc/ex288-docker-app -n task77 \
  -o jsonpath='{.spec.source.git.uri}{"\n"}{.spec.source.git.ref}{"\n"}{.spec.source.contextDir}{"\n"}'
```

Expected output:

```text
https://git.ocp4.example.com/developer/devops-wala/
main
apps/task77/
```



### Step 8: Follow and verify the automatically triggered build

```bash
oc logs -f bc/ex288-docker-app -n task77
oc get builds -n task77
oc get istag/ex288-docker-app:latest -n task77
```

The latest build must show the phase `Complete`, and the output image stream tag must exist.

If you later change the `BuildConfig` and need another build, use:

```bash
oc start-build bc/ex288-docker-app --follow --wait -n task77
```

### Step 9: Deploy the built image

### Copy the ImageStreamTag name
```
oc get all
```

```bash
oc new-app task77/ex288-docker-app:latest

oc get all
```


### Step 10: Create the service

```bash
oc expose service ex288-docker-app 
```

The service provides stable internal access to the application pods.



### Step 11: Test the application
```
oc get all
curl ex288-docker-app-task77.apps.ocp4.example.com
```

---

## 🔍 Final Verification

### Check all required resources

```bash
oc get all
```

### How to delete this lab?

```bash
oc delete project task77
rm -rf /home/student/ex288/devops-wala/
```

---

## 📚 Official References

- [Creating build inputs in OpenShift Container Platform 4.18](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/builds_using_buildconfig/creating-build-inputs)
- [Using Docker build strategies in OpenShift Container Platform 4.18](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/builds_using_buildconfig/build-strategies)
- [BuildConfig API reference](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/workloads_apis/buildconfig-build-openshift-io-v1)
- [Configuring ingress cluster traffic](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/ingress_and_load_balancing/configuring-ingress-cluster-traffic)
- [Red Hat HTTPD container usage](https://github.com/sclorg/httpd-container/blob/master/2.4/root/usr/share/container-scripts/httpd/README.md)

</details>

---

<div align="center">

### ✅ EX288 Task 3 Flow

`Git source` ➜ `Docker build` ➜ `ImageStream` ➜ `Deployment` ➜ `Service` ➜ `Route`

</div>
