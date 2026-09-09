<div align="center">

# 🔴 EX288 Task 3

## Build and Deploy an HTTPD Application on OpenShift

![OpenShift](https://img.shields.io/badge/OpenShift-4.18-EE0000?logo=redhatopenshift&logoColor=white)
![Build](https://img.shields.io/badge/Build-Docker_Strategy-2496ED?logo=docker&logoColor=white)
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

Build and deploy the HTTPD application with the following requirements:

- The application must be built and deployed to the project `task77`.
- The deployed application and its resources must be named
  `ex288-docker-app`.
- The source code is available at
  `https://git.ocp4.example.com/developer/devops-wala/`.
- The application source code directory is `apps/task77/`.
- The Git reference is `main`.
- The `httpd:2.4-ubi9` base image stream must be used from the `openshift`
  namespace.
- The application binary is available at
  `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/Download-dir`.
- The service must be publicly available on the default hostname.
- User `devuser` must have read-only privileges.

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

RUN curl -fL ${CodeBinary} -o /usr/local/apache2/htdocs/index.html

EXPOSE 80

CMD ["httpd-foreground"]
```

The required Red Hat UBI HTTPD image does not use the Docker Hub HTTPD layout.
The correct runtime values are:

| Item | Incorrect repository value | Required UBI HTTPD value |
|---|---|---|
| Document root | `/usr/local/apache2/htdocs` | `/var/www/html` |
| Container port | `80` | `8080` |
| Start command | `httpd-foreground` | `run-httpd` |

Because the source repository is read-only during the task, do not edit and
push its Dockerfile. Use `oc new-build --dockerfile=-` to store a corrected
inline Dockerfile in the `BuildConfig`. OpenShift processes this inline file
after the Git source and therefore replaces the Dockerfile from the selected
context directory.

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

### Step 3: Grant `devuser` read-only access

```bash
oc policy add-role-to-user view devuser -n task77
oc get rolebinding -n task77 -o wide
```

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
  --build-arg=CodeBinary=https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/Download-dir \
  --dockerfile=- <<'EOF'
FROM httpd:2.4-ubi9

ARG CodeBinary

RUN curl -fL "${CodeBinary}" -o /var/www/html/index.html

EXPOSE 8080

CMD ["run-httpd"]
EOF
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

Check the Docker strategy and base image:

```bash
oc get bc/ex288-docker-app -n task77 \
  -o jsonpath='{.spec.strategy.type}{"\n"}{.spec.strategy.dockerStrategy.from.namespace}/{.spec.strategy.dockerStrategy.from.name}{"\n"}'
```

Expected output:

```text
Docker
openshift/httpd:2.4-ubi9
```

Check the build argument:

```bash
oc get bc/ex288-docker-app -n task77 \
  -o jsonpath='{.spec.strategy.dockerStrategy.buildArgs[?(@.name=="CodeBinary")].value}{"\n"}'
```

Check the inline Dockerfile:

```bash
oc get bc/ex288-docker-app -n task77 \
  -o jsonpath='{.spec.source.dockerfile}{"\n"}'
```

Confirm that it contains `/var/www/html/index.html`, `EXPOSE 8080`, and
`CMD ["run-httpd"]`.

### Step 8: Follow and verify the automatically triggered build

```bash
oc logs -f bc/ex288-docker-app -n task77
oc get builds -n task77
oc get istag/ex288-docker-app:latest -n task77
```

The latest build must show the phase `Complete`, and the output image stream tag
must exist.

If you later change the `BuildConfig` and need another build, use:

```bash
oc start-build bc/ex288-docker-app --follow --wait -n task77
```

### Step 9: Deploy the built image

```bash
oc create deployment ex288-docker-app \
  --image=image-registry.openshift-image-registry.svc:5000/task77/ex288-docker-app:latest \
  -n task77

oc rollout status deployment/ex288-docker-app -n task77
```

The deployment uses the image produced by the `BuildConfig` in the same
project.

### Step 10: Create the service

```bash
oc expose deployment ex288-docker-app \
  --name=ex288-docker-app \
  --port=8080 \
  --target-port=8080 \
  -n task77
```

The service provides stable internal access to the application pods.

### Step 11: Create the public route

```bash
oc expose service ex288-docker-app -n task77
```

No hostname is supplied, so the OpenShift Ingress Controller assigns the
default hostname required by the question.

### Step 12: Test the application

```bash
ROUTE_HOST=$(oc get route ex288-docker-app -n task77 \
  -o jsonpath='{.spec.host}')

echo "http://${ROUTE_HOST}"
curl --fail --silent --show-error "http://${ROUTE_HOST}"
```

Expected response:

```text
Welcome to Devops-wala
```

---

## 🔍 Final Verification

### Check all required resources

```bash
oc get bc,build,is,deploy,pod,svc,route -n task77
```

### Check the deployment and pod

```bash
oc get deployment/ex288-docker-app -n task77
oc get pods -l app=ex288-docker-app -n task77
```

The deployment must have one available replica, and the pod must show `Running`
with `READY` equal to `1/1`.

### Check the service endpoints

```bash
oc get service/ex288-docker-app -n task77
oc get endpoints/ex288-docker-app -n task77
```

The endpoint list must not be empty.

### Check the route

```bash
oc get route/ex288-docker-app -n task77 \
  -o custom-columns='NAME:.metadata.name,HOST:.spec.host,SERVICE:.spec.to.name'
```

### Check the read-only role binding

```bash
oc get rolebinding -n task77 -o wide | grep devuser
```

### Grading checklist

| Check | Expected result |
|---|---|
| Current project | `task77` |
| BuildConfig | `ex288-docker-app` |
| ImageStream | `ex288-docker-app` |
| Deployment | `ex288-docker-app` |
| Service | `ex288-docker-app` |
| Route | `ex288-docker-app` |
| Build strategy | `Docker` |
| Base image reference | `openshift/httpd:2.4-ubi9` |
| Git reference | `main` |
| Context directory | `apps/task77/` |
| Build phase | `Complete` |
| Pod status | `Running` and `1/1` |
| Route response | `Welcome to Devops-wala` |
| `devuser` access | `view` role in `task77` |

---

## 🛠️ Troubleshooting

### Error: `fatal: not a git repository`

**Cause:** The extracted archive does not contain Git metadata.

**Fix:**

```bash
cd /home/student/ex288/devops-wala
git init -b main
```

### Error: the build cannot clone the Git repository

Inspect the build logs and test the repository from the workstation:

```bash
oc logs -f bc/ex288-docker-app -n task77
git ls-remote https://git.ocp4.example.com/developer/devops-wala/
```

If the lab Git server requires authentication for build-time cloning, create
and attach the source secret supplied by the instructor. Do not place a
username or password directly in the `BuildConfig` Git URL.

### Error: `curl: (23) Failure writing output to destination`

**Cause:** The original Dockerfile tries to write to
`/usr/local/apache2/htdocs/index.html`, which is not the document root used by
the required UBI HTTPD image.

**Fix:** Confirm that the inline Dockerfile writes to:

```text
/var/www/html/index.html
```

### Error: `httpd-foreground: command not found`

**Cause:** `httpd-foreground` belongs to the Docker Hub HTTPD image layout. The
required Red Hat UBI HTTPD image uses `run-httpd`.

**Fix:**

```bash
oc get bc/ex288-docker-app -n task77 \
  -o jsonpath='{.spec.source.dockerfile}{"\n"}'
```

Confirm that the last instruction is:

```dockerfile
CMD ["run-httpd"]
```

### Error: the build cannot find `httpd:2.4-ubi9`

```bash
oc get istag/httpd:2.4-ubi9 -n openshift
oc get bc/ex288-docker-app -n task77 \
  -o jsonpath='{.spec.strategy.dockerStrategy.from.namespace}/{.spec.strategy.dockerStrategy.from.name}{"\n"}'
```

The second command must return:

```text
openshift/httpd:2.4-ubi9
```

### Error: the route returns `503 Service Unavailable`

Check the pod, logs, service selector, service port, and endpoints:

```bash
oc get pods -n task77
oc logs deployment/ex288-docker-app -n task77
oc describe service/ex288-docker-app -n task77
oc get endpoints/ex288-docker-app -n task77
```

Common causes include a failed pod, using service port `80` instead of `8080`,
or an empty endpoint list.

### Error: a resource already exists

Inspect the existing objects before changing them:

```bash
oc get bc,is,deploy,svc,route -n task77 | grep ex288-docker-app
```

To reset only this application's resources while keeping the project:

```bash
oc delete route,service,deployment,buildconfig,imagestream \
  ex288-docker-app -n task77
```

> [!WARNING]
> The following command deletes the complete project and everything in it. Use
> it only when a full lab reset is intended.

```bash
oc delete project task77
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
