# 🎓 DO288 v4.18 — Building Containers, Image Streams & Secure Registry Access

> **Course:** Red Hat OpenShift Developer II (DO288) v4.18
> **Topics:** Building Containers | Image Streams | Secure Registry Access
> **Difficulty:** Intermediate
> **Prerequisites:** Basic Linux, Podman, and OpenShift CLI knowledge

---

## 📋 Table of Contents

- [Overview & Learning Journey](#overview)
- [Task 1 — Build & Fix a Container Image](#task1)
- [Task 2 — Deploy an Application Using Image Streams](#task2)
- [Task 3 — Secure Registry Access with Robot Accounts](#task3)
- [Key Concepts Summary](#summary)

---

## 🗺️ Overview & Learning Journey <a name="overview"></a>

These three tasks are designed as a **progressive learning journey**.
Each task builds naturally on the previous one.

```
TASK 1                      TASK 2                      TASK 3
────────────────────────    ────────────────────────    ────────────────────────
Build & Fix                 Import same image into      Secure the registry
Container Image             an ImageStream              with a Robot Account
      │                           │                           │
      │                           │                           │
      ▼                           ▼                           ▼
Push to Registry ──────► IS-based Deployment ──────► Robot Account Token
      │                           │                           │
      ▼                           ▼                           ▼
oc new-app                  oc new-app -i               oc create deployment
(direct image)              (via ImageStream)           (with secure secret)

COMPLEXITY:  🟢 Low              🟡 Medium                  🔴 High
FOCUS:       Image Building      Image Lifecycle             Security
```

> ### 💡 The Three Questions These Tasks Answer
>
> | Task | Question Answered |
> |---|---|
> | **Task 1** | How do I **build** a production-ready container image for OpenShift? |
> | **Task 2** | How do I **manage** image versions and automate redeployments? |
> | **Task 3** | How do I **secure** registry access without exposing credentials? |

---

## ✅ Task 1 — Build & Fix a Container Image <a name="task1"></a>

> **Goal:** Build a Node.js container image, identify OpenShift
> compatibility issues, fix them step by step, and deploy the
> application using a direct image reference.

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
# Review the Containerfile before building
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

---

### 🏗️ Step 1.5 — Build the Initial Image (v1.0.0)

```bash
podman build -f task1-files-Containerfile \
  -t registry.ocp4.example.com:8443/developer/building-container:1.0.0
```

### 🧪 Step 1.6 — Test the Image Locally Before Pushing

```bash

podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.0
```

> **📌 Best Practice:** Always test locally with `podman run` before
> pushing to the registry. This catches issues early and saves time.

---

### 📤 Step 1.7 — Push the Image to the Registry

```bash
podman push registry.ocp4.example.com:8443/developer/building-container:1.0.0
```

---

### 🔑 Step 1.8 — Login to OpenShift and Create a Project

```bash
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

```bash
oc new-project building-container
```

---

### 🚀 Step 1.9 — Deploy the Application (v1.0.0 — Intentionally Broken)

```bash
oc new-app --name greetings \
  --image=registry.ocp4.example.com:8443/developer/building-container:1.0.0
```

### 🔎 Step 1.10 — Post-Deployment Checks

```bash
oc get all
```

```bash
oc logs deployments/greetings
```

> ### ⚠️ Expected Errors — Root Cause Analysis
>
> | # | Error | Root Cause | Fix Needed |
> |---|---|---|---|
> | 1 | `Running with user ID: 1000690000` | OpenShift ignores `USER root` at runtime | Remove `USER root` |
> | 2 | `EACCES: permission denied /var/cache/` | `/var/cache` not accessible by non-root | Fix group permissions |
> | 3 | `listen EACCES: permission denied 0.0.0.0:80` | Ports 1–1024 are privileged | Change PORT to 8080 |

---

### 🧹 Step 1.11 — Clean Up the Broken Deployment

```bash
# View labels to confirm selector before deletion
oc get all --show-labels
```

```bash
# Delete all resources related to the greetings app
oc delete all --selector app=greetings
```

---

### 🛠️ Step 1.12 — Fix #1: Remove USER root

```bash
vi task1-files-Containerfile
```

```dockerfile
FROM registry.ocp4.example.com:8443/ubi10/nodejs-22-minimal:10.0

ENV PORT=80
EXPOSE ${PORT}

ADD . $HOME

RUN npm ci --omit=dev && rm -rf .npm

# ✅ USER root line has been removed
CMD npm start
```

### 🏗️ Step 1.13 — Rebuild as v1.0.1 and Test


```bash

podman build -f task1-files-Containerfile \
  -t registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

```bash
podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

> **📌 Expected:** USER root error is gone.
> Port 80 and `/var/cache/` errors still remain.
> Press `Ctrl+C` to stop.

---

### 🛠️ Step 1.14 — Fix #2: Change Privileged Port 80 → 8080

```bash
vi task1-files-Containerfile
```

```dockerfile
FROM registry.ocp4.example.com:8443/ubi10/nodejs-22-minimal:10.0

# ✅ Changed from 80 to 8080
ENV PORT=8080
EXPOSE ${PORT}

ADD . $HOME

RUN npm ci --omit=dev && rm -rf .npm

CMD npm start
```

```bash
podman build -f task1-files-Containerfile \
  -t registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

```bash
podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

> **📌 Expected:** Port error is resolved. App listens on 8080.
> `/var/cache/` permission error still persists.
> Press `Ctrl+C` to stop.

---

### 🛠️ Step 1.15 — Fix #3: Correct Group Permissions on /var/cache

```bash
vi task1-files-Containerfile
```

```dockerfile
FROM registry.ocp4.example.com:8443/ubi10/nodejs-22-minimal:10.0

ENV PORT=8080
EXPOSE ${PORT}

ADD . $HOME

RUN npm ci --omit=dev && rm -rf .npm

# ✅ Temporarily switch to root ONLY during build to fix permissions
USER root
RUN chgrp -R 0 /var/cache && \
    chmod -R g=u /var/cache

# ✅ Switch back to non-root for runtime (OpenShift compatible)
USER 1001

CMD npm start
```

> ### 💡 Why This Pattern Works in OpenShift
>
> OpenShift always runs containers with **GID 0** (root group),
> regardless of the UID. By granting the root group write access
> to `/var/cache`, any arbitrary UID assigned by OpenShift can
> write to that directory.
>
> | Command | Purpose |
> |---|---|
> | `USER root` | Elevates to root **during build only** |
> | `chgrp -R 0 /var/cache` | Changes group ownership to GID 0 |
> | `chmod -R g=u /var/cache` | Grants group same permissions as owner |
> | `USER 1001` | Drops to non-root for **runtime** |

---

### 🏗️ Step 1.16 — Final Rebuild of v1.0.1

```bash
podman build -f task1-files-Containerfile \
  -t registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

```bash
# All three issues should now be resolved
podman run --rm registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

> ✅ **No errors!** Press `Ctrl+C` to stop.

---

### 📤 Step 1.17 — Push the Fixed Image (v1.0.1)

```bash
podman push registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

---

### 🚀 Step 1.18 — Redeploy Using the Fixed Image


```bash

oc new-app --name greetings \
  --image=registry.ocp4.example.com:8443/developer/building-container:1.0.1
```

```bash
oc get all
oc logs deployments/greetings
```

---

### 🌐 Step 1.19 — Expose the Application via a Route

```bash
oc expose svc/greetings
oc get route
```

```bash
curl -s http://greetings-building-container.apps.ocp4.example.com | jq
```

> ✅ You should receive a **JSON response** from the Node.js application.

---

### 🔍 Step 1.20 — Inspect the Auto-Created ImageStream

```bash
oc get is
oc get all
```

> ### 📌 Key Insight — Bridge to Task 2
> Even with `oc new-app --image`, OpenShift **automatically creates
> an ImageStream** behind the scenes. However, you have **limited control**
> over how it is configured.
>
> In **Task 2**, we will learn how to create and manage ImageStreams
> **manually** — giving us full control over image lifecycle,
> versioning, and automatic redeployments.

---

## ✅ Task 2 — Deploy an Application Using Image Streams <a name="task2"></a>

> **Goal:** Import the image built in Task 1 into a manually managed
> ImageStream, and deploy an application using the ImageStream reference.
> Learn how ImageStreams enable automatic redeployments when images change.

> **📌 Connection to Task 1:**
> We will use the **same image** pushed in Task 1
> (`building-container:1.0.1`) and import it into an ImageStream.
> This demonstrates the progression from direct image reference
> to managed ImageStream reference.

---

### 🔑 Step 2.1 — Login to OpenShift and Create a New Project

```bash
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

```bash
oc new-project images-streams
```

---

### 🔍 Step 2.2 — Inspect the Remote Image Before Importing

> Use `skopeo` to inspect the remote image metadata before importing.

```bash
skopeo login registry.ocp4.example.com:8443 -u developer -p developer
```

```bash
skopeo inspect \
  docker://registry.ocp4.example.com:8443/redhattraining/hello-world-nginx
```

```bash

skopeo inspect \
  docker://registry.ocp4.example.com:8443/redhattraining/hello-world-nginx
```

---

### 📥 Step 2.3 — Import the Image into an ImageStream

```bash
oc import-image is-hello-world \
  --confirm \
  --from registry.ocp4.example.com:8443/redhattraining/hello-world-nginx
```

> **📌 Command Breakdown:**
>
> | Component | Description |
> |---|---|
> | `oc import-image` | Creates an ImageStream and imports image metadata |
> | `is-hello-world` | Name of the ImageStream to create |
> | `--confirm` | Required to confirm creation of a new ImageStream |
> | `--from` | Source image URL in the external registry |

---

### 🔎 Step 2.4 — Verify the ImageStream

```bash
# List all ImageStream tags
oc get istag
```

```bash
# View detailed ImageStream metadata
oc describe is is-hello-world
```

> **📌 Reading the Output:**
> - The **asterisk (*)** next to a tag = currently active tag
> - The **SHA-256 digest** = exact, immutable image version
> - This ensures you always know **exactly** which image is running

---

### 🚀 Step 2.5 — Deploy the Application Using the ImageStream

```bash
oc new-app --name image-stream-deploy -i is-hello-world
```

> **📌 Key Difference from Task 1:**
>
> | Task 1 | Task 2 |
> |---|---|
> | `--image=registry.../building-container:1.0.1` | `-i is-hello-world` |
> | Direct registry URL reference | ImageStream reference |
> | Manual update required | **Auto-redeploy** on image change |
> | Less control over versioning | Full version history & tagging |

---

### 🔎 Step 2.6 — Verify the Deployment

```bash
oc get all
```

> ✅ You should see a Deployment, ReplicaSet, Pod, and Service.

---

### 🌐 Step 2.7 — Expose the Application via a Route

```bash
oc expose svc/image-stream-deploy
```

```bash
oc get route
```

```bash
curl http://image-stream-deploy-images-streams.apps.ocp4.example.com
```

---

### 🔄 Step 2.8 — Update the ImageStream Tag (Simulate CI/CD Update)

> **📌 What are we doing?**
> We retag the `is-hello-world:latest` ImageStream to point to a
> **different image**. This simulates what happens in a CI/CD pipeline
> when a new image is built and pushed. OpenShift detects the change
> and **automatically redeploys** the application — no manual
> intervention required.

```bash
oc -n images-streams tag \
  registry.ocp4.example.com:8443/redhattraining/php-hello-dockerfile:latest \
  is-hello-world:latest
```

### 🔎 Step 2.9 — Verify the ImageStream Tag Update

```bash
# Confirm the tag now points to the new image
oc -n images-streams get istag
```

```bash
# View the full ImageStream history
oc -n images-streams describe is is-hello-world
```

---

### 🧪 Step 2.10 — Test the Updated Application

```bash
# Watch the new pod roll out automatically
oc get pods -w
```

```bash
# Test — response should reflect the updated image
curl http://image-stream-deploy-images-streams.apps.ocp4.example.com
```

> ✅ The response now comes from the **updated image** with **zero
> manual redeployment steps** — this is the power of ImageStreams!

> ### 📌 Key Insight — Bridge to Task 3
> Now that we understand how to build images (Task 1) and manage
> them with ImageStreams (Task 2), the next question is:
> **How do we securely pull images from a private registry?**
> Using personal credentials in a secret is a security risk.
> Task 3 introduces **Robot Accounts** as the secure solution.

---

## ✅ Task 3 — Secure Registry Access with Robot Accounts <a name="task3"></a>

> **Goal:** Understand the security risk of using personal credentials
> in pull secrets, and replace them with a **Robot Account** token
> for production-grade secure registry access.

---

### 🔧 Step 3.1 — Prepare the Lab

```bash
mkdir -p /home/student/task3/building-container/
cd /home/student/task3/building-container/
```

### 📥 Step 3.2 — Download Files and Build the Image

```bash
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-index.js
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-LocalizationService.js
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-package-lock.json
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task1-files-package.json
wget https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/DO288/V.4.18/task2-files-containerfile
```

```bash
podman login -u developer -p developer registry.ocp4.example.com:8443

podman build -f task2-files-containerfile \
  -t registry.ocp4.example.com:8443/developer/task3-building-container:1.0.0

podman push registry.ocp4.example.com:8443/developer/task3-building-container:1.0.0
```

---

### 🔑 Step 3.3 — Login to OpenShift and Create a Project

```bash
oc login -u developer -p developer https://api.ocp4.example.com:6443
```

```bash
oc new-project images-registry
```

---

### ⚠️ Step 3.4 — Demonstrate the Insecure Approach First

> **📌 Instructor Note:** We intentionally start with the **insecure**
> approach so students understand **why** Robot Accounts are needed.

```bash
oc create secret docker-registry registry-credentials \
  --docker-server=registry.ocp4.example.com:8443 \
  --docker-username=developer \
  --docker-password=developer \
  --docker-email=developer@example.org
```

```bash
oc secrets link default registry-credentials --for=pull
```

```bash
oc create deployment greeting1 \
  --image=registry.ocp4.example.com:8443/developer/task3-building-container:1.0.0
```

```bash
oc get pods
oc get all
```

---

### 🔴 Step 3.5 — Expose the Security Risk

```bash
oc get secret registry-credentials \
  -o jsonpath='{.data.\.dockerconfigjson}' | base64 --decode
```

**Output — password fully exposed in plain text:**

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

> ### 🔴 Why This is a Security Problem
>
> | Risk | Impact |
> |---|---|
> | Password stored as base64 | Easily decoded — **not encrypted** |
> | Personal credentials used | Password change breaks all deployments |
> | Shared across project | All project members can access credentials |
> | No scope limitation | Full account access, not registry-scoped |

---

### 🧹 Step 3.6 — Clean Up the Insecure Configuration


```bash
oc secrets unlink default registry-credentials
oc delete secret/registry-credentials
oc delete deployment greeting1
```

---

### 🤖 Step 3.7 — Create a Robot Account (The Secure Solution)

> **📌 What is a Robot Account?**
>
> | Feature | Personal Credentials | Robot Account |
> |---|---|---|
> | Tied to a person | ✅ Yes | ❌ No |
> | Revocable independently | ❌ No | ✅ Yes |
> | Scoped to repositories | ❌ No | ✅ Yes |
> | Survives password changes | ❌ No | ✅ Yes |
> | Safe to share in teams | ❌ No | ✅ Yes |

**Steps to create the Robot Account:**

1. Navigate to `https://registry.ocp4.example.com:8443`
2. Log in as `developer` / `developer`
3. Click **developer** → **Account Settings**
4. Click the 🤖 **Robot icon** → **Robot Accounts**
5. Click **Create Robot Account**
6. Enter `ocprobot` as the username
7. Click **Create robot account** → Click **Close**
8. Click **developer+ocprobot** to open credentials
9. **Copy the authentication token**

---

### 🔐 Step 3.8 — Create the Secure Pull Secret

```bash
oc create secret docker-registry registry-credentials \
  --docker-server=registry.ocp4.example.com:8443 \
  --docker-username=developer+ocprobot \
  --docker-password=<PASTE_ROBOT_TOKEN_HERE> \
  --docker-email=devops-wala@example.org
```

```bash
oc secrets link default registry-credentials --for=pull
```

---

### 🚀 Step 3.9 — Deploy Using the Secure Robot Account

```bash
oc create deployment greeting2 \
  --image=registry.ocp4.example.com:8443/developer/task3-building-container:1.0.0
```

```bash
oc get pods
oc get all
```

```bash
# Check events if needed
oc get events --sort-by='.lastTimestamp'
oc get event \
  --field-selector type=Warning \
  -o jsonpath='{range .items[]}{.message}{"\n"}{end}'
```

> ✅ Pod is **Running** using the secure robot account token.

---

### 🧹 Step 3.10 — Finish and Clean Up

```bash
oc secrets unlink default registry-credentials
oc delete secret/registry-credentials
oc delete deployment greeting2
rm -rf /home/student/task3/
```

---

## 📚 Key Concepts Summary <a name="summary"></a>

### 🔄 How All Three Tasks Connect

```
TASK 1                    TASK 2                    TASK 3
Build Image               Manage with               Secure the
& Deploy Direct           ImageStream               Registry
      │                         │                         │
      │    same image ──────────┘                         │
      │                                                   │
      └─────────────── any deployment method ─────────────┘
                        needs secure access
```

### 📊 Three Deployment Methods Compared

| Feature | Task 1 `oc new-app --image` | Task 2 `oc new-app -i` | Task 3 `oc create deployment` |
|---|---|---|---|
| **ImageStream** | ✅ Auto-created | ✅ Manually managed | ❌ Not created |
| **Service** | ✅ Auto-created | ✅ Auto-created | ❌ Manual |
| **Route** | ❌ Manual | ❌ Manual | ❌ Manual |
| **Auto-redeploy on update** | ⚠️ Limited | ✅ Full | ❌ No |
| **Best for** | Quick deploy | Production CI/CD | Testing & Debug |

### 🔒 Registry Credential Security

| Approach | Security | Recommended |
|---|---|---|
| Personal credentials in secret | 🔴 Low — base64 exposed | ❌ No |
| Robot account token in secret | 🟢 High — scoped & revocable | ✅ Yes |


---

*DO288 v4.18 — Red Hat OpenShift Developer II*
*Progressive Exercise Series: Build → Manage → Secure*
