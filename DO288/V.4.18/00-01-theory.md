# EX288 — Ways to Create an Application on OpenShift

## Overview

In OpenShift, an application can be created in several ways.  
However, in the **EX288 context**, not all methods are equally important.

As an instructor, I recommend learning these methods in **priority order**:

1. **Image-based deployment with `oc create deployment`**
2. **Image-based deployment with `oc new-app`**
3. **Source-based build and deployment with `oc new-app`**
4. **Helm chart deployment**
5. **Manifest-based deployment with `oc apply -f`**
6. **Supporting methods** such as `oc new-build` and OpenShift templates

The goal is not only to know what is possible, but also to know which method is the **fastest, most practical, and most exam-relevant**.

---

## 1. Image-Based Deployment with `oc create deployment`

This method is valid, but it is less OpenShift-rich than `oc new-app`.

### How it works

- The image is already available
- You create only the deployment manually

### Example
```bash
oc create deployment web1-containerimage \
  --image=registry.example.com/myproject/web1:latest
```

### What gets created

- Deployment
- ReplicaSet
- Pods

### What does not get created automatically

- Service
- Route

### Additional steps
```bash
oc expose deployment web1-containerimage --port=8080
oc expose service/web1-containerimage
```

**Instructor note:**  
This is useful for quick testing, direct Kubernetes-style deployment, or cases where you want manual control.  
But in EX288, `oc new-app` is often the more efficient choice.

---

## 2. Image-Based Deployment with `oc new-app`

This is another important EX288 workflow.

### How it works

- The image is already built
- The image is stored in a registry
- OpenShift deploys the image directly

### When to use it

Use this method when:
- the image already exists
- no source build is required
- you want OpenShift to create the application quickly

### Example
```bash
oc new-app \
  --name=web1 \
  --image=registry.example.com/myproject/web1:latest
```

### What OpenShift usually creates

- Deployment
- Pods
- Service

Sometimes an ImageStream may also be created, depending on how the image is referenced and how OpenShift resolves it.

### Route creation
A route is usually created separately:
```bash
oc expose service/web1
```

**Why this matters in EX288:**  
If the exam provides a ready container image, this is often faster than manually creating a deployment and service.

---

## 3. <u>**New Content**</u>: Architecture of OpenShift Cluster

To better understand how applications are deployed, consider the architecture of an OpenShift cluster:

https://via.placeholder.com/600x400.png?text=OpenShift+Cluster+Architecture

*This diagram illustrates the core components:*

- **Master Nodes (3X masters):** Manage the cluster, API server, scheduler, and controllers.
- **Worker Nodes (3X worknodes):** Run the application containers, Pods, and services.
- **Registry:** Stores container images.
- **Gitlab:** Stores source code, which can be built or deployed directly.

**This architecture supports multiple deployment methods** by providing a scalable, resilient environment for your applications.

---

## 4. Source-Based Build and Deployment with `oc new-app`

This is one of the most important workflows in EX288.

### How it works

- The developer writes application source code
- The source code is stored in Git
- OpenShift pulls the source code
- OpenShift builds the application image
- OpenShift deploys the application
- A Service is usually created automatically
- A Route is usually created separately

### Why this is important

This method is highly relevant when:
- the exam gives you a Git repository
- the build must use a builder image
- the application depends on a private Git repository
- build-time environment variables such as `npm_config_registry` must be set

### Typical workflow

#### Step 1 — Create the Git secret if the repository is private
```bash
oc create secret generic gitlab-secret \
  --from-literal=username=developer \
  --from-literal=password=d3v3lop3r \
  --type=kubernetes.io/basic-auth

oc annotate secret gitlab-secret \
  "build.openshift.io/source-secret-match-uri-1=https://git.ocp4.example.com/*"

oc secret link builder gitlab-secret
```

#### Step 2 — Create the application from source
```bash
oc new-app \
  --name=todo-ssr \
  --build-env npm_config_registry="http://nexus-infra.apps.ocp4.example.com/repository/npm" \
  httpd:2.4-ubi9~https://git.ocp4.example.com/developer/DO288-apps \
  --context-dir=apps/compreview-todo/todo-ssr
```

#### Step 3 — Expose the application
```bash
oc expose service/todo-ssr
```

### What OpenShift usually creates

- BuildConfig
- Build
- ImageStream
- Deployment
- Pods
- Service

### What you may still need to create

- Route
- ConfigMap
- Secret
- volume mounts
- environment variables
- probes and resource settings

**Why this is recommended in EX288:**  
This is one of the best methods because it lets OpenShift handle most of the workflow for you.

---

## 5. Helm Chart Deployment

Helm is a major topic and should be treated as a separate deployment method.

### How it works

- A Helm chart contains templates for application resources
- The chart is installed with values
- Helm manages the release

### When to use it

Use Helm when:
- the application is already packaged as a chart
- the exam asks you to install or customize a chart
- you need upgrades and rollbacks

### Example
```bash
helm repo add myrepo https://charts.example.com
helm repo update

helm install web-helm myrepo/myapp \
  --set image.repository=registry.example.com/myapp \
  --set image.tag=latest
```

### Verify
```bash
helm list
oc get all
```

### Common Helm operations
```bash
helm upgrade web-helm myrepo/myapp --set image.tag=v2
helm rollback web-helm 1
helm uninstall web-helm
```

**Instructor note:**  
In EX288, Helm is very important if the task includes installing a chart, modifying chart values, or upgrading/rolling back a release.

---

## 6. Manifest-Based Deployment with `oc apply -f`

This is a very practical and important fallback method.

### How it works

- The developer writes or edits YAML/JSON manifests
- OpenShift applies the manifests directly

### Example
```bash
oc apply -f deployment.yaml
oc apply -f service.yaml
oc apply -f route.yaml
```

Or:
```bash
oc apply -f ./manifests/
```

### Why this is useful

This method is best when:
- the exam requires exact configuration
- you need full control over resources
- you must define labels, probes, volumes, resource limits, or environment variables precisely

**Instructor note:**  
Even if you create the application with `oc new-app`, you may still need to modify the resulting resources using YAML or `oc edit`.  
This makes manifest knowledge very important in EX288.

---

## 7. Supporting Methods

### Build from Source with `oc new-build`

This is an important supporting workflow.

#### How it works

- You create a build configuration from source
- OpenShift builds an image
- You deploy it separately afterwards

#### Example
```bash
oc new-build \
  --name=web-s2i \
  nodejs:16-ubi9~https://git.ocp4.example.com/developer/DO288-apps \
  --context-dir=apps/myapp
```

#### Then verify the build
```bash
oc get builds
```

#### Then deploy the built image
```bash
oc new-app --image-stream=web-s2i:latest --name=web-s2i
```

**Instructor note:**  
This is useful when you want to separate the build step from the deployment step or the exam expects you to inspect or modify the build configuration first.  
This is valid, but if the task can be solved directly with `oc new-app`, that is often simpler.

---

### OpenShift Templates

Templates are parameterized OpenShift object definitions.

#### How it works

- A template contains placeholders
- `oc process` replaces the placeholders with values
- the output is applied to the cluster

#### Example
```bash
oc process -f template.yaml \
  -p APP_NAME=myapp \
  -p IMAGE_TAG=latest \
  | oc apply -f -
```

#### When to use it

Use templates when:
- the application is packaged as an OpenShift template
- you need reusable parameterized deployments

**Instructor note:**  
Templates are valid, but they are usually lower priority than `oc new-app`, Helm, and YAML manifests for EX288 preparation.

---

## Final Comparison

| Method | Typical Use | Auto-Creation Level | EX288 Priority |
|--------|-------------|---------------------|----------------|
| Image-based `oc create deployment` | Manual deployment from image | Low | Medium |
| Image-based `oc new-app` | Deploy existing image | Medium to High | High |
| Source-based `oc new-app` | Build from Git and deploy | High | Very High |
| Helm | Packaged application deployment | High | High |
| `oc apply -f` | Full declarative control | Depends on manifests | High |
| `oc new-build` + deploy | Separate build and deploy flow | Medium | Medium |
| OpenShift Template | Parameterized OpenShift deployment | Depends on template | Medium to Low |

---

## Instructor Recommendation for EX288

### Focus on these first

#### Tier 1 — Highest priority
- Image-based application creation with `oc create deployment`
- Image-based application creation with `oc new-app`
- Source-based application creation with `oc new-app`
- Helm deployment and customization
- Manifest-based deployment with `oc apply -f`

#### Tier 2 — Important supporting skills
- Creating Git secrets for private repositories
- Exposing services with routes
- Editing environment variables
- Adding volumes and configuration
- Modifying builds and deployments

#### Tier 3 — Secondary methods
- `oc new-build`
- OpenShift templates

---

## Simple Exam Mindset

In EX288, think in this order:

1. Can I solve this with `oc create deployment` or `oc new-app`?
2. If it is packaged, should I use Helm?
3. If I need exact control, should I use YAML with `oc apply -f`?
4. Do I also need a Git secret, service, or route?

---

## Final Conclusion

Yes, there are several ways to create an application on OpenShift.  
But in EX288, the most practical methods are usually:

- **Image-based `oc create deployment`**
- **Image-based `oc new-app`**
- **Source-based `oc new-app`**
- **Helm chart deployment**
- **Manifest-based deployment**

Other methods are valid, but they are usually secondary.

If you prepare with that priority order, your approach will be more aligned with the exam.

---
