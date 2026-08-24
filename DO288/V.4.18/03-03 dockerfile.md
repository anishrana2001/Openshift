<div align="center">

# 🔴 EX288 Task 3

### Build and Deploy an HTTPD Application on OpenShift

![OpenShift](https://img.shields.io/badge/OpenShift-4.18-EE0000?logo=redhatopenshift&logoColor=white)
![Build](https://img.shields.io/badge/Build-Docker_Strategy-2496ED?logo=docker&logoColor=white)
![Project](https://img.shields.io/badge/Project-task77-7B42BC)
![Status](https://img.shields.io/badge/Guide-Student_Ready-2EA44F)

</div>


---
How to Create a lab ?
```
mkdir -p /home/student/ex288/
cd /home/student/ex288/
curl -L "https://raw.githubusercontent.com/anishrana2001/Openshift/main/DO288/V.4.18/devops-wala.tar" -o /home/student/ex288/devops-wala.tar
tar -xf /home/student/ex288/devops-wala.tar
cd /home/student/ex288/devops-wala/
git init -b main
git remote add origin https://git.ocp4.example.com/developer/devops-wala.git
git remote set-url origin https://developer:d3v3lop3r@git.ocp4.example.com/developer/devops-wala.git
git add . && git commit -m "adding files"
git push -u origin main
```


## 🎯 Task Requirements

- The application must be built and deployed to the project `task77`
- The deployed application and its resources must be named `ex288-docker-app`
- The source code is available at URL `https://git.ocp4.example.com/developer/devops-wala/`
- The application source code directory `apps/task77/`
- Git reference `main`
- The base image stream `httpd:2.4-ubi9` must be used from the `openshift` namespace.
- The application binary is available at `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/Download-dir`
- The service has to be publicly available on the default hostname.
---


## Solution: 

---

What is Given ?

| Requirement | Required value |
|---|---|
| Project | `task77` |
| Resource name | `ex288-docker-app` |
| Git repository | `https://git.ocp4.example.com/developer/devops-wala/` |
| Git reference | `main` |
| Context directory | `apps/task77/` |
| Build strategy | Docker build |
| Base image stream | `httpd:2.4-ubi9` |
| Base image namespace | `openshift` |
| Application binary | `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/Download-dir` |
| External access | Route with the default hostname |

---

## 🧭 Learning Path

```mermaid
flowchart TD
    A["📁 Git source"] --> B["🏗️ Docker BuildConfig"]
    B --> C["📦 Application image"]
    C --> D["🚀 Deployment and Service"]
    D --> E["🌐 Public Route"]
```


## 🧰 Part 1: Prepare the Lab Repository

> [!IMPORTANT]
> This section is for the person preparing the lab. A student solving the OpenShift task can start from [Part 2](#-part-2-understand-the-build).

### 1. Download and extract the source archive

```bash
mkdir -p /home/student/ex288
cd /home/student/ex288

curl -fL \
  "https://raw.githubusercontent.com/anishrana2001/Openshift/main/DO288/V.4.18/devops-wala.tar" \
  -o devops-wala.tar

tar -xf devops-wala.tar
cd /home/student/ex288/devops-wala

# Initialize the extracted directory as a Git repository
# The TAR archive contains project files, but it does not contain Git metadata. Therefore, initialize it before using commands such as `git remote`, `git commit`, or `git push`.
git init -b main
git init
git branch -M main
```

### 3. Commit and push the files

```bash
git remote add origin \
  https://developer@git.ocp4.example.com/developer/devops-wala.git

git add . && git commit -m "Add EX288 lab files"
git push -u origin main


git remote add origin https://git.ocp4.example.com/developer/devops-wala.git
git remote set-url origin https://developer:d3v3lop3r@git.ocp4.example.com/developer/devops-wala.git
git add . && git commit -m "adding files"
git push -u origin main
```

---

## 🧠 Part 2: Understand the Build

The context directory contains a `Dockerfile`, so OpenShift must use the Docker build strategy.

The supplied file contains this design:

```dockerfile
FROM httpd:2.4-ubi9

ARG CodeBinary

RUN curl -fL ${CodeBinary} -o /usr/local/apache2/htdocs/index.html

EXPOSE 80

CMD ["httpd-foreground"]
```

### Why the Dockerfile needs an override

The task requires the Red Hat `httpd:2.4-ubi9` image stream from the `openshift` namespace. That image uses the OpenShift-compatible HTTPD layout:

| Setting | Required value |
|---|---|
| Document root | `/var/www/html` |
| Runtime command | `run-httpd` |
| HTTP port | `8080` |

The supplied Dockerfile instead uses the layout of the Docker Hub HTTPD image. Because the Git repository is read-only for `devuser`, the solution overrides the Dockerfile inside the `BuildConfig` rather than modifying and pushing the repository.

### How each task value is represented

| Task instruction | OpenShift field or resource |
|---|---|
| Git URL | `spec.source.git.uri` |
| Git reference `main` | `spec.source.git.ref` |
| `apps/task77/` | `spec.source.contextDir` |
| Docker build | `spec.strategy.type: Docker` |
| Required base image | `spec.strategy.dockerStrategy.from` |
| Binary URL | Docker `buildArgs` entry named `CodeBinary` |
| Built image | `ImageStreamTag/ex288-docker-app:latest` |
| Running workload | `Deployment/ex288-docker-app` |
| Internal access | `Service/ex288-docker-app` |
| External access | `Route/ex288-docker-app` |

---

## 🚀 Part 3: Complete Solution

### Step 1: Confirm the OpenShift login

```bash
oc whoami
oc status
```

The commands must show the expected student account and a working cluster connection.

### Step 2: Create and select the project

```bash
oc new-project task77
```

If the project already exists and belongs to you, select it:

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

### Step 3: Confirm the required base image stream

```bash
oc get imagestreamtag httpd:2.4-ubi9 -n openshift
```

This confirms that the required image stream tag exists before the build is created.

### Step 4: Create the output ImageStream and BuildConfig

Copy and run the complete block:

```bash
oc apply -f - <<'EOF'
apiVersion: image.openshift.io/v1
kind: ImageStream
metadata:
  name: ex288-docker-app
  namespace: task77
---
apiVersion: build.openshift.io/v1
kind: BuildConfig
metadata:
  name: ex288-docker-app
  namespace: task77
spec:
  runPolicy: Serial
  source:
    type: Git
    git:
      uri: https://git.ocp4.example.com/developer/devops-wala/
      ref: main
    contextDir: apps/task77/
    dockerfile: |-
      FROM httpd:2.4-ubi9
      ARG CodeBinary
      RUN curl -fL "${CodeBinary}" -o /var/www/html/index.html
      EXPOSE 8080
      CMD ["run-httpd"]
  strategy:
    type: Docker
    dockerStrategy:
      from:
        kind: ImageStreamTag
        namespace: openshift
        name: httpd:2.4-ubi9
      buildArgs:
        - name: CodeBinary
          value: https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/Download-dir
  output:
    to:
      kind: ImageStreamTag
      name: ex288-docker-app:latest
  triggers: []
EOF
```

### Why this configuration is correct

- `source.git` makes OpenShift clone the required read-only repository.
- `ref: main` selects the required Git branch.
- `contextDir` makes `apps/task77/` the build context.
- `type: Docker` selects the Docker build strategy.
- `dockerStrategy.from` explicitly resolves the base image from the `openshift` namespace.
- `buildArgs` supplies the binary URL to `ARG CodeBinary`.
- The inline `dockerfile` overrides the incompatible Dockerfile without changing the read-only repository.
- `output.to` stores the completed image as `ex288-docker-app:latest`.
- `triggers: []` prevents an incomplete automatic build and lets the student start the configured build explicitly.

### Step 5: Verify the BuildConfig before building

```bash
oc get bc/ex288-docker-app -o jsonpath='Git URI: {.spec.source.git.uri}{"\n"}Git ref: {.spec.source.git.ref}{"\n"}Context: {.spec.source.contextDir}{"\n"}Strategy: {.spec.strategy.type}{"\n"}Base image: {.spec.strategy.dockerStrategy.from.namespace}/{.spec.strategy.dockerStrategy.from.name}{"\n"}'
```

Expected values include:

```text
Git URI: https://git.ocp4.example.com/developer/devops-wala/
Git ref: main
Context: apps/task77/
Strategy: Docker
Base image: openshift/httpd:2.4-ubi9
```

Verify the Docker build argument:

```bash
oc get bc/ex288-docker-app \
  -o jsonpath='{range .spec.strategy.dockerStrategy.buildArgs[*]}{.name}={.value}{"\n"}{end}'
```

The output must begin with:

```text
CodeBinary=https://raw.githubusercontent.com/
```

### Step 6: Start and follow the build

```bash
oc start-build bc/ex288-docker-app --follow
```

Confirm that the latest build completed successfully:

```bash
oc get builds
oc get istag/ex288-docker-app:latest
```

Expected build phase:

```text
Complete
```

### Step 7: Deploy the built image

```bash
oc create deployment ex288-docker-app \
  --image=image-registry.openshift-image-registry.svc:5000/task77/ex288-docker-app:latest

oc rollout status deployment/ex288-docker-app
```

The internal registry address points the deployment to the image produced by the BuildConfig in the `task77` project.

### Step 8: Create the service

```bash
oc expose deployment ex288-docker-app \
  --name=ex288-docker-app \
  --port=8080 \
  --target-port=8080
```

The service provides stable internal access to the application pods.

### Step 9: Create the public route

```bash
oc expose service ex288-docker-app
```

No hostname is supplied. Therefore, the OpenShift Ingress Controller assigns the default hostname required by the task.

### Step 10: Test the application

```bash
ROUTE_HOST=$(oc get route ex288-docker-app -o jsonpath='{.spec.host}')
echo "http://${ROUTE_HOST}"
curl -s "http://${ROUTE_HOST}"
```

Expected response:

```text
Welcome to Devops-wala
```

---

## 🔍 Part 4: Final Verification

### Check all required resources

```bash
oc get bc,build,is,deploy,pod,svc,route
```

### Check the deployment and pod

```bash
oc get deployment/ex288-docker-app
oc get pods -l app=ex288-docker-app
```

The deployment must show one available replica, and the pod must show `Running` with `READY` equal to `1/1`.

### Check service endpoints

```bash
oc get service/ex288-docker-app
oc get endpoints/ex288-docker-app
```

The endpoint list must not be empty.

### Check the default route hostname

```bash
oc get route/ex288-docker-app \
  -o custom-columns=NAME:.metadata.name,HOST:.spec.host,SERVICE:.spec.to.name
```

### Grading checklist

| Check | Expected result |
|---|---|
| Current project | `task77` |
| BuildConfig name | `ex288-docker-app` |
| ImageStream name | `ex288-docker-app` |
| Deployment name | `ex288-docker-app` |
| Service name | `ex288-docker-app` |
| Route name | `ex288-docker-app` |
| Build strategy | `Docker` |
| Base image reference | `openshift/httpd:2.4-ubi9` |
| Git branch | `main` |
| Context directory | `apps/task77/` |
| Pod status | `Running` |
| Route response | `Welcome to Devops-wala` |

---

## 🛠️ Troubleshooting

### Error: `fatal: not a git repository`

**Cause:** The extracted TAR archive has no `.git` directory.

**Fix:**

```bash
cd /home/student/ex288/devops-wala
git init -b main
```

### Error: the build cannot clone the Git repository

Inspect the build logs:

```bash
oc logs -f bc/ex288-docker-app
```

Confirm the repository URL from the workstation:

```bash
git ls-remote https://git.ocp4.example.com/developer/devops-wala/
```

If the Git server requires authentication, use the read-only credentials and source secret supplied by the lab environment. Do not add credentials to the BuildConfig URL.

### Error: the build cannot find `httpd:2.4-ubi9`

```bash
oc get istag/httpd:2.4-ubi9 -n openshift
oc get bc/ex288-docker-app \
  -o jsonpath='{.spec.strategy.dockerStrategy.from.namespace}/{.spec.strategy.dockerStrategy.from.name}{"\n"}'
```

The result must be:

```text
openshift/httpd:2.4-ubi9
```

### Error: `httpd-foreground: command not found`

**Cause:** `httpd-foreground` belongs to the Docker Hub HTTPD image layout. The required Red Hat UBI9 HTTPD image uses `run-httpd`.

Confirm the inline Dockerfile command:

```bash
oc get bc/ex288-docker-app \
  -o jsonpath='{.spec.source.dockerfile}'
```

### Error: route returns `503 Service Unavailable`

Check the pod, logs, service selector, and endpoints:

```bash
oc get pods
oc logs deployment/ex288-docker-app
oc describe service/ex288-docker-app
oc get endpoints/ex288-docker-app
```

The common causes are a failed pod, an incorrect service port, or an empty endpoint list.

### Error: resource already exists

Inspect the existing object before deleting or replacing it:

```bash
oc get bc,is,deploy,svc,route | grep ex288-docker-app
```

To reset only the application resources while keeping the project:

```bash
oc delete route,service,deployment,buildconfig,imagestream ex288-docker-app
```

> [!WARNING]
> The following command deletes the complete project and all resources inside it. Use it only when a full lab reset is intended.

```bash
oc delete project task77
```

---

## 📚 Official References

- [Creating applications from Git source in OpenShift Container Platform 4.18](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/building_applications/creating-applications)
- [Using Docker build strategies and build arguments](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/builds_using_buildconfig/build-strategies)
- [OpenShift BuildConfig API reference](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/workloads_apis/buildconfig-build-openshift-io-v1)
- [Exposing a service with an OpenShift route](https://docs.redhat.com/en/documentation/openshift_container_platform/4.18/html/ingress_and_load_balancing/configuring-ingress-cluster-traffic)
- [Red Hat HTTPD container usage](https://github.com/sclorg/httpd-container/blob/master/2.4/root/usr/share/container-scripts/httpd/README.md)

---

<div align="center">

### ✅ Task 77 Result

`Git source` ➜ `Docker build` ➜ `ImageStream` ➜ `Deployment` ➜ `Service` ➜ `Route`

</div>
