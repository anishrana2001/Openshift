# 🎓 DO288 v4.18 — Building Containers, Secure Registry & Image Streams

> **Course:** Red Hat OpenShift Developer II (DO288) v4.18
> **Topics:** Building Containers | Secure Registry Access | Image Streams
> **Difficulty:** Intermediate
> **Prerequisites:** Basic Linux, Podman, and OpenShift CLI knowledge

---

## 📋 Table of Contents

- [Overview](#overview)
- [Task 1 — Build & Fix a Container Image](#task1)
- [Task 2 — Secure Registry Access with Robot Accounts](#task2)
- [Task 3 — Deploy an Application using Image Streams](#task3)
- [Key Concepts Summary](#summary)

---

## 🗺️ Overview <a name="overview"></a>

These three tasks are designed to progressively build your understanding of
how container images are built, secured, and deployed in OpenShift.

```
TASK 1                    TASK 2                    TASK 3
──────────────────────    ──────────────────────    ──────────────────────
Build & Fix               Secure Registry           Import Image into
Container Image           Access using              ImageStream & Deploy
      │                   Robot Account                     │
      │                         │                           │
      ▼                         ▼                           ▼
Push to Registry ──────► Pull with Secret ──────► IS-based Deployment
      │                         │                           │
      ▼                         ▼                           ▼
oc new-app              oc create deployment        oc new-app -i
(direct image)          (simple deployment)         (via ImageStream)
```

> ### 💡 Core Philosophy
> OpenShift gives you **multiple ways** to deploy an application.
> The method you choose depends on your use case:
>
> | Method | Best For |
> |---|---|
> | `oc new-app --image` | Quick deployments with auto-wiring |
> | `oc create deployment` | Simple testing & debugging |
> | `oc new-app -i` (ImageStream) | Production CI/CD with auto-updates |

---

## ✅ Task 1 — Build & Fix a Container Image <a name="task1"></a>

> **Goal:** Build a Node.js container image, identify OpenShift compatibility
> issues, fix them step by step, and deploy the application.

---

### 🔧 Step 1.1 — Prepare the Lab Directory

```bash
mkdir -p /home/student/task1/building-container/
cd /home/student/task1/building-container/
```

### 📥 Step 1.2 — Download the Source Files

```bash
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-index.js
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-LocalizationService.js
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-package-lock.json
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-package.json
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-Containerfile
```

### 🔍 Step 1.3 — Inspect the Working Directory and Containerfile

```bash
# Confirm you are in the correct directory
pwd
```

```bash
# Review the Containerfile content before building
cat task1-files-Containerfile
```

> **📌 Instructor Note:** Always inspect your Containerfile before building.
> Look for `USER`, `PORT`, and permission-related instructions that may
> cause issues in OpenShift's restricted security environment.

---

### 🔐 Step 1.4 — Login to the Private Registry

```bash
podman login -u developer -p developer registry.ocp4.example.com:8443
```

> **📌 Note:** You must authenticate to the private registry before
> building or pushing images that reference it as a base image source.

---

### 🏗️ Step 1.5 — Build the Initial Image (v1.0.0)

```bash
podman build -f task1-files-Containerfile \
  -t registry.ocp4.example.com:8443/developer/building-container:1.0.0
```

### 🧪 Step 1.6 — Test the Image Locally Before Pushing

> **⚠️ Bug Found & Fixed:**
> The original exercise used a **wrong image name** in the test command.
> The correct image name is `building-container`, not `images-ubi-greetings`.

```bash
# ❌ WRONG (original — incorrect image name):
# podman run --rm registry.ocp4.example.com:8443/developer/images-ubi-greetings:1.0.0

# ✅ CORRECT:
podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.0
```

> **📌 Instructor Note:** Always test your image locally with `podman run`
> before pushing to the registry. This saves time by catching issues early.

---

### 📤 Step 1.7 — Push the Image to the Registry

```bash
podman push registry.ocp4.example.com:8443/developer/building-container:1.0.0
```

---

### 🔑 Step 1.8 — Login to OpenShift

```bash
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

### 📁 Step 1.9 — Create a New Project

```bash
oc new-project building-container
```

---

### 🚀 Step 1.10 — Deploy the Application (v1.0.0)

```bash
oc new-app --name greetings \
  --image=registry.ocp4.example.com:8443/developer/building-container:1.0.0
```

### 🔎 Step 1.11 — Post-Deployment Checks

```bash
# Check all created resources
oc get all
```

```bash
# Check the pod logs to identify issues
oc logs deployments/greetings
```

> ### ⚠️ Expected Errors — Root Cause Analysis
>
> You will observe the following errors in the logs:
>
> | # | Error | Root Cause | Fix |
> |---|---|---|---|
> | 1 | `Running with user ID: 1000690000` | OpenShift **ignores** `USER root` at runtime and assigns a random non-root UID | Remove `USER root` from Containerfile |
> | 2 | `EACCES: permission denied /var/cache/` | `/var/cache` is owned by root group; non-root user cannot write | Fix group permissions with `chgrp` and `chmod` |
> | 3 | `listen EACCES: permission denied 0.0.0.0:80` | Ports **1–1024** are privileged; non-root users cannot bind to them | Change `PORT` from `80` to `8080` |

---

### 🧹 Step 1.12 — Clean Up the Broken Deployment

```bash
# View labels to confirm selector before deletion
oc get all --show-labels
```

```bash
# Delete all resources related to the greetings app
oc delete all --selector app=greetings
```

---

### 🛠️ Step 1.13 — Fix #1: Remove USER root

Edit the Containerfile:

```bash
vi task1-files-Containerfile
```

**Updated Containerfile — Remove USER root (PORT still needs fixing):**

```dockerfile
FROM registry.ocp4.example.com:8443/ubi10/nodejs-22-minimal:10.0

ENV PORT=80
EXPOSE ${PORT}

ADD . $HOME

RUN npm ci --omit=dev && rm -rf .npm

# USER root line has been removed
CMD npm start
```

> **📌 Why remove USER root?**
> OpenShift's Security Context Constraints (SCC) **do not honor** the
> `USER root` instruction at runtime. The container will always run as
> a random non-root UID (e.g., `1000690000`). Keeping `USER root`
> gives a false sense of security without any actual root privileges.

### 🏗️ Step 1.14 — Rebuild as v1.0.1 and Test

> **⚠️ Bug Found & Fixed:**
> The original exercise used an incorrect `podman build` syntax:
> `podman build . -t --image=...` which is invalid.
> The correct syntax is `podman build -f <file> -t <tag>`.

```bash
# ❌ WRONG (original — invalid syntax):
# podman build . -t --image=registry.ocp4.example.com:8443/developer/building-container:1.0.1

# ✅ CORRECT:
podman build -f task1-files-Containerfile \
  -t registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

```bash
podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

> **📌 Expected Result:** The `USER root` error is gone. However, you will
> still see **two remaining errors**:
> - Port 80 permission denied
> - `/var/cache/` permission denied
>
> Press `Ctrl+C` to stop the container.

---

### 🛠️ Step 1.15 — Fix #2: Change Privileged Port 80 → 8080

```bash
vi task1-files-Containerfile
```

**Updated Containerfile — Fix the port:**

```dockerfile
FROM registry.ocp4.example.com:8443/ubi10/nodejs-22-minimal:10.0

# ✅ Changed from 80 to 8080 (non-privileged port)
ENV PORT=8080
EXPOSE ${PORT}

ADD . $HOME

RUN npm ci --omit=dev && rm -rf .npm

CMD npm start
```

### 🏗️ Step 1.16 — Rebuild v1.0.1 and Test Again

```bash
podman build -f task1-files-Containerfile \
  -t registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

```bash
podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

> **📌 Expected Result:** The port error is resolved. The application now
> listens on port **8080**. However, the `/var/cache/` permission error
> **still persists**.
>
> Press `Ctrl+C` to stop the container.

---

### 🛠️ Step 1.17 — Fix #3: Correct Group Permissions on /var/cache

```bash
vi task1-files-Containerfile
```

**Final Containerfile — All fixes applied:**

```dockerfile
FROM registry.ocp4.example.com:8443/ubi10/nodejs-22-minimal:10.0

ENV PORT=8080
EXPOSE ${PORT}

ADD . $HOME

RUN npm ci --omit=dev && rm -rf .npm

# Temporarily switch to root ONLY during build to fix permissions
USER root
RUN chgrp -R 0 /var/cache && \
    chmod -R g=u /var/cache

# Switch back to non-root user for runtime (OpenShift compatible)
USER 1001

CMD npm start
```

> ### 💡 Why This Pattern Works in OpenShift
>
> OpenShift runs containers with **arbitrary UIDs** but **always GID 0**
> (root group). By granting the root group the same permissions as the
> owner, any arbitrary UID assigned by OpenShift can write to `/var/cache`.
>
> | Command | Purpose |
> |---|---|
> | `USER root` | Elevates to root **during build only** |
> | `chgrp -R 0 /var/cache` | Changes group ownership to GID 0 (root group) |
> | `chmod -R g=u /var/cache` | Grants group same permissions as the file owner |
> | `USER 1001` | Drops back to non-root for **runtime** |

---

### 🏗️ Step 1.18 — Final Rebuild of v1.0.1

```bash
podman build -f task1-files-Containerfile \
  -t registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

```bash
# All three issues should now be resolved
podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

> ✅ **No errors!** Press `Ctrl+C` to stop the container.

---

### 📤 Step 1.19 — Push the Fixed Image (v1.0.1)

```bash
podman push registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

---

### 🚀 Step 1.20 — Redeploy Using the Fixed Image

> **⚠️ Bug Found & Fixed:**
> The original exercise redeployed using `1.0.0` (the broken image)
> instead of `1.0.1` (the fixed image). This has been corrected below.

```bash
# ❌ WRONG (original — deploys broken image):
# oc new-app --name greetings \
#   --image=registry.ocp4.example.com:8443/developer/building-container:1.0.0

# ✅ CORRECT — deploy the fixed image:
oc new-app --name greetings \
  --image=registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

### 🔎 Step 1.21 — Verify the Deployment

```bash
oc get all
```

```bash
oc logs deployments/greetings
```

> ✅ The pod should now be in **Running** state with no errors.

---

### 🌐 Step 1.22 — Expose the Application via a Route

```bash
# Naming convention: <service>-<project>.apps.<domain>
oc expose svc/greetings
```

```bash
# Verify the route was created
oc get route
```

```bash
# Test the application
curl -s http://greetings-building-container.apps.ocp4.example.com | jq
```

> ✅ You should receive a **JSON response** from the Node.js greeting application.

---

### 🔍 Step 1.23 — Inspect the Auto-Created ImageStream

> **📌 Key Insight:**
> Even when using `oc new-app --image`, OpenShift **automatically creates
> an ImageStream** behind the scenes. However, you have less control over
> its configuration compared to creating one manually (covered in Task 3).

```bash
# View the auto-created ImageStream
oc get is
```

```bash
# View all resources in the project
oc get all
```

> In **Task 3**, we will learn how to create and manage ImageStreams manually
> for greater control over image lifecycle and automatic redeployments.

---

## ✅ Task 2 — Secure Registry Access with Robot Accounts <a name="task2"></a>

> **Goal:** Understand the security risk of using personal credentials in
> pull secrets, and learn how to use **Robot Accounts** as a secure alternative.

---

### 🔧 Step 2.1 — Prepare the Lab

```bash
mkdir -p /home/student/task2/building-container/
cd /home/student/task2/building-container/
```

### 📥 Step 2.2 — Download Files and Build the Image

```bash
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-index.js
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-LocalizationService.js
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-package-lock.json
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-package.json
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task2-files-containerfile
```

```bash
# Login, build, and push the image
podman login -u developer -p developer registry.ocp4.example.com:8443

podman build -f task2-files-containerfile \
  -t registry.ocp4.example.com:8443/developer/task2-building-container:1.0.0

podman push registry.ocp4.example.com:8443/developer/task2-building-container:1.0.0
```

---

### 🔑 Step 2.3 — Login to OpenShift and Create Project

```bash
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

```bash
oc new-project images-registry
```

---

### 🔐 Step 2.4 — Create a Pull Secret Using Personal Credentials

> **📌 Instructor Note:** We will first demonstrate the **insecure approach**
> using personal credentials, then show why it is a security risk,
> and finally replace it with a **Robot Account**.

```bash
oc create secret docker-registry registry-credentials \
  --docker-server=registry.ocp4.example.com:8443 \
  --docker-username=developer \
  --docker-password=developer \
  --docker-email=developer@example.org
```

### 🔗 Step 2.5 — Link the Secret to the Default Service Account

```bash
oc secrets link default registry-credentials --for=pull
```

> **📌 Why link to the service account?**
> Pods in OpenShift use the `default` service account by default.
> By linking the pull secret to this account, all pods in the project
> can pull images from the private registry **without embedding credentials
> directly in the deployment manifest**.

---

### 🚀 Step 2.6 — Deploy Using oc create deployment

```bash
oc create deployment greeting1 \
  --image=registry.ocp4.example.com:8443/developer/task2-building-container:1.0.0
```

> **📌 Note:** Unlike `oc new-app`, the `oc create deployment` command
> creates **only** a Deployment resource. No Service, Route, or ImageStream
> is created automatically.

### 🔎 Step 2.7 — Verify the Deployment

```bash
oc get pods
oc get all
```

```bash
# Check for warning events if pods are not starting
oc get events --sort-by='.lastTimestamp'
```

```bash
# Filter only warning events with detailed messages
oc get event \
  --field-selector type=Warning \
  -o jsonpath='{range .items[]}{.message}{"\n"}{end}'
```

> **📌 Further Reading on jsonpath:**
> `https://kubernetes.io/docs/reference/kubectl/jsonpath/`

---

### ⚠️ Step 2.8 — Demonstrate the Security Risk

> Anyone with access to this project can **decode the secret** and
> retrieve the plain-text password:

```bash
oc get secret registry-credentials \
  -o jsonpath='{.data.\.dockerconfigjson}' | base64 --decode
```

**Expected output — your password is fully exposed:**

```json
{
  "auths": {
    "registry.ocp4.example.com:8443": {
      "username": "developer",
      "password": "developer",
      "email": "developer@example.org",
      "auth": "ZGV2ZWxvcGVyOmRldmVsb3Blcg=="
    }
  }
}
```

> ### 🔴 Security Risk Summary
>
> | Risk | Impact |
> |---|---|
> | Password stored in base64 | Easily decoded — **not encrypted** |
> | Personal credentials used | If password changes, deployment breaks |
> | Shared across project | All project members can access credentials |
> | No scope limitation | Full account access, not registry-scoped |

---

### 🧹 Step 2.9 — Clean Up the Insecure Configuration

> **⚠️ Bug Found & Fixed:**
> The original cleanup command used `wrong-registry-credentials` as the
> secret name, which does not exist. The correct name is `registry-credentials`.

```bash
# ❌ WRONG (original — incorrect secret name):
# oc secrets unlink default wrong-registry-credentials

# ✅ CORRECT:
oc secrets unlink default registry-credentials

# Delete the insecure secret
oc delete secret/registry-credentials

# Delete the deployment
oc delete deployment greeting1
```

---

### 🤖 Step 2.10 — Create a Robot Account (Secure Solution)

> **📌 What is a Robot Account?**
> A Robot Account is a **non-personal, scoped credential** for a container
> registry. It provides a token that:
> - Does **not** expose your personal password
> - Can be **revoked** without affecting your user account
> - Can be **scoped** to specific repositories
> - Does **not expire** when you change your personal password

**Steps to create the Robot Account:**

1. Navigate to `https://registry.ocp4.example.com:8443`
2. Log in as `developer` / `developer`
3. Click **developer** → **Account Settings**
4. Click the 🤖 **Robot icon** in the left sidebar → **Robot Accounts**
5. Click **Create Robot Account**
6. Enter `ocprobot` as the robot account username
7. Click **Create robot account** to confirm
8. You may skip the *Add permissions* step by clicking **Close**
9. Click **developer+ocprobot** to open the credentials page
10. **Copy the authentication token** from the *Username & Robot Account* section

---

### 🔐 Step 2.11 — Create a Secure Pull Secret Using the Robot Account

```bash
oc create secret docker-registry registry-credentials \
  --docker-server=registry.ocp4.example.com:8443 \
  --docker-username=developer+ocprobot \
  --docker-password=<PASTE_ROBOT_TOKEN_HERE> \
  --docker-email=devops-wala@example.org
```

> **📌 Replace** `<PASTE_ROBOT_TOKEN_HERE>` with the token copied in Step 2.10.

### 🔗 Step 2.12 — Link the Secure Secret to the Default Service Account

```bash
oc secrets link default registry-credentials --for=pull
```

---

### 🚀 Step 2.13 — Redeploy Using the Secure Secret

```bash
oc create deployment greeting2 \
  --image=registry.ocp4.example.com:8443/developer/task2-building-container:1.0.0
```

### 🔎 Step 2.14 — Verify the Deployment

```bash
oc get pods
oc get all
```

```bash
# Check events if needed
oc get events --sort-by='.lastTimestamp'
```

```bash
oc get event \
  --field-selector type=Warning \
  -o jsonpath='{range .items[]}{.message}{"\n"}{end}'
```

> ✅ The pod should now be in **Running** state using the secure robot account token.

---

### 🧹 Step 2.15 — Finish and Clean Up the Lab

> **⚠️ Bug Found & Fixed:**
> Same as Step 2.9 — the cleanup used the wrong secret name.
> Corrected below.

```bash
# ❌ WRONG (original — incorrect secret name):
# oc secrets unlink default wrong-registry-credentials

# ✅ CORRECT:
oc secrets unlink default registry-credentials

# Delete the secret
oc delete secret/registry-credentials

# Delete the deployment
oc delete deployment greeting2

# Remove the local working directory
rm -rf /home/student/task2/
```

---

## ✅ Task 3 — Deploy an Application Using Image Streams <a name="task3"></a>

> **Goal:** Learn how to import an external image into an OpenShift
> ImageStream and deploy an application using the ImageStream reference
> instead of a direct image URL.

---

### 🔑 Step 3.1 — Login to OpenShift

```bash
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

### 📁 Step 3.2 — Create a New Project

> **⚠️ Bug Found & Fixed:**
> The original exercise called `oc new-project images-streams` **twice**.
> The second call is removed here. A project only needs to be created once.

```bash
oc new-project images-streams
```

---

### 🔍 Step 3.3 — Inspect the Remote Image Before Importing

> You can use either `skopeo` or `podman` to inspect the remote image
> before importing it into OpenShift.

**Option A — Using skopeo (recommended for inspection):**

```bash
skopeo login registry.ocp4.example.com:8443 -u developer -p developer
```

```bash
skopeo inspect docker://registry.ocp4.example.com:8443/redhattraining/hello-world-nginx
```

**Option B — Using podman:**

```bash
podman login registry.ocp4.example.com:8443 -u developer -p developer
```

> **⚠️ Bug Found & Fixed:**
> The original used `podman inspect docker://...` which is **invalid syntax**.
> `podman inspect` works on local images only.
> Use `skopeo inspect` for remote images.

```bash
# ❌ WRONG (original — invalid for remote images):
# podman inspect docker://registry.ocp4.example.com:8443/redhattraining/hello-world-nginx

# ✅ CORRECT — use skopeo for remote image inspection:
skopeo inspect docker://registry.ocp4.example.com:8443/redhattraining/hello-world-nginx
```

---

### 📥 Step 3.4 — Import the Image into an ImageStream

```bash
oc import-image is-hello-world \
  --confirm \
  --from registry.ocp4.example.com:8443/redhattraining/hello-world-nginx
```

> **📌 What does this command do?**
>
> | Component | Description |
> |---|---|
> | `oc import-image` | Creates an ImageStream and imports image metadata |
> | `is-hello-world` | The name of the ImageStream to create |
> | `--confirm` | Required flag to confirm creation of a new ImageStream |
> | `--from` | The source image URL in the external registry |

---

### 🔎 Step 3.5 — Verify the ImageStream

```bash
# List all ImageStream tags in the current project
oc get istag
```

```bash
# View detailed metadata of the ImageStream
oc describe is is-hello-world
```

> **📌 Reading the output:**
> - The **asterisk (*)** next to a tag indicates it is the **currently active**
>   tag pointing to a specific SHA-256 image digest.
> - The SHA-256 digest ensures you are always referencing an **exact,
>   immutable version** of the image.

---

### 🚀 Step 3.6 — Deploy the Application Using the ImageStream

> **⚠️ Bug Found & Fixed:**
> The original command used `-i images-streams/is-hello-world` which
> references the project name in the ImageStream path. Since we are already
> **inside** the `images-streams` project, the project prefix is not needed.

```bash
# ❌ WRONG (original — unnecessary project prefix when already in project):
# oc new-app --name image-steam-deploy -i images-streams/is-hello-world

# ✅ CORRECT:
oc new-app --name image-stream-deploy -i is-hello-world
```

> **📌 Key Difference from Task 1:**
> In Task 1, we used `--image=<registry-url>` (direct image reference).
> Here, we use `-i <imagestream-name>` (ImageStream reference).
> OpenShift will now **watch the ImageStream** and trigger redeployments
> automatically when the image is updated.

### 🔎 Step 3.7 — Verify the Deployment

```bash
oc get all
```

> ✅ You should see a Deployment, ReplicaSet, Pod, and Service created.

---

### 🌐 Step 3.8 — Expose the Application via a Route

> **⚠️ Bug Found & Fixed:**
> The original exposed `svc hello` which does not match the app name
> `image-steam-deploy`. The service name matches the app name.

```bash
# ❌ WRONG (original — wrong service name):
# oc expose svc hello

# ✅ CORRECT:
oc expose svc/image-stream-deploy
```

```bash
# Verify the route was created
oc get route
```

```bash
# Test the application
curl http://image-stream-deploy-images-streams.apps.ocp4.example.com
```

---

### 🔄 Step 3.9 — Update the ImageStream Tag to a New Image

> **📌 What are we doing here?**
> We are **retagging** the `is-hello-world:latest` ImageStream tag to point
> to a **different image** (`php-hello-dockerfile`). This simulates an
> image update in a CI/CD pipeline. OpenShift will detect the change
> and **automatically redeploy** the application.

```bash
oc -n images-streams tag \
  registry.ocp4.example.com:8443/redhattraining/php-hello-dockerfile:latest \
  is-hello-world:latest
```

### 🔎 Step 3.10 — Verify the ImageStream Tag Update

```bash
# Confirm the tag now points to the new image
oc -n images-streams get istag
```

```bash
# View the full ImageStream history
oc -n images-streams describe is is-hello-world
```

> **📌 What to look for:**
> The `is-hello-world:latest` tag should now reference the SHA-256 digest
> of the `php-hello-dockerfile` image. OpenShift will trigger a new
> rollout automatically.

---

### 🧪 Step 3.11 — Test the Updated Application

```bash
# Wait for the new pod to be ready
oc get pods -w
```

```bash
# Test the application — output should reflect the new image
curl http://image-stream-deploy-images-streams.apps.ocp4.example.com
```

> ✅ The response should now come from the **updated image** without any
> manual redeployment — this is the power of ImageStreams!

---

## 📚 Key Concepts Summary <a name="summary"></a>

### 🔄 Three Deployment Methods Compared

```
METHOD 1                  METHOD 2                  METHOD 3
oc new-app --image        oc create deployment      oc new-app -i
──────────────────────    ──────────────────────    ──────────────────────
✅ ImageStream (auto)     ❌ No ImageStream          ✅ ImageStream (manual)
✅ Service (auto)         ❌ No Service              ✅ Service (auto)
❌ Route (manual)         ❌ No Route                ❌ Route (manual)
⚠️ Limited IS control    ✅ Simplest approach       ✅ Full IS control
Best: Quick deploy        Best: Testing/Debug        Best: Production CI/CD
```

### 🔒 Registry Credential Security

| Approach | Security Level | Recommended |
|---|---|---|
| Personal credentials in secret | 🔴 Low — password exposed via base64 | ❌ No |
| Robot account token in secret | 🟢 High — scoped, revocable token | ✅ Yes |

### 💡 ImageStream Benefits

| Scenario | Without ImageStream | With ImageStream |
|---|---|---|
| Image updated in registry | ❌ Pod keeps old image | ✅ Triggers automatic redeployment |
| Rollback to previous version | ❌ Manual & complex | ✅ Easy — retag previous IS version |
| Multiple environments (dev/prod) | ❌ Hard to manage | ✅ Use IS tags per environment |
| Audit trail of image versions | ❌ Not available | ✅ IS keeps full history |

### 🐛 Bugs Fixed in This Document

| Task | Location | Bug | Fix Applied |
|---|---|---|---|
| Task 1 | Step 1.6 | Wrong image name in `podman run` test | Corrected to `building-container` |
| Task 1 | Steps 1.14, 1.16, 1.18 | Invalid `podman build . -t --image=` syntax | Corrected to `podman build -f ... -t ...` |
| Task 1 | Step 1.20 | Redeployed broken `v1.0.0` instead of fixed `v1.0.1` | Corrected to use `v1.0.1` |
| Task 2 | Steps 2.9, 2.15 | `oc secrets unlink` used non-existent secret name | Corrected to `registry-credentials` |
| Task 3 | Step 3.2 | `oc new-project` called twice | Removed duplicate call |
| Task 3 | Step 3.3 | `podman inspect docker://...` invalid for remote images | Replaced with `skopeo inspect` |
| Task 3 | Step 3.6 | Unnecessary project prefix in `-i` flag | Removed project prefix |
| Task 3 | Step 3.8 | Wrong service name `svc hello` | Corrected to `svc/image-stream-deploy` |

---

*DO288 v4.18 — Red Hat OpenShift Developer II*
*Combined Exercise: Building Containers | Secure Registry | Image Streams*
