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
podman build
