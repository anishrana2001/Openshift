# ⚙️ Resource Management in RHOAI

## 🎯 Objective

Manage cluster resources efficiently in OpenShift AI.

---

## 🧠 Key Resources in RHOAI

| Resource      | Description      |
| ------------- | ---------------- |
| Projects      | Namespaces       |
| Users         | Access control   |
| Workbenches   | Dev environments |
| PVC           | Storage          |
| Model Servers | Serve ML models  |

---

## 🧪 Create Project

```bash
oc create namespace myproject
```

---

## 🧹 Clean Unused Resources

```bash
oc delete project old-project
```

---

## ⚡ Idle Notebook Culling

### Purpose:

Stop unused notebooks automatically

---

## 🛠️ Configure via ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: notebook-controller-culler-config
  namespace: redhat-ods-applications
data:
  CULL_IDLE_TIME: "240"
  ENABLE_CULLING: "true"
  IDLENESS_CHECK_PERIOD: "1"
```

---

## ⏱️ Key Parameters

* CULL_IDLE_TIME → inactivity time
* ENABLE_CULLING → enable/disable
* CHECK_PERIOD → frequency

---

## 🧠 Advanced: Dashboard Config

```bash
oc get odhdashboardconfigs odh-dashboard-config -n redhat-ods-applications -o yaml
```

---

## 📦 Customize Workbench Size

Example:

```yaml
notebookSizes:
  - name: MediumSmall
    resources:
      limits:
        cpu: "2"
        memory: 16Gi
```

---

## 🧪 Guided Lab

### Step 1: Create Workbench

* Name: `manage-resources-wb`
* Image: Minimal Python

---

### Step 2: Set Idle Timeout

* Go to Settings → Cluster Settings
* Set to **10 minutes**

---

### Step 3: Verify Pod Stops

```bash
oc get pods
```

---

### Step 4: Add Custom Size

* Modify `odh-dashboard-config`
* Add new size

---

## ⚠️ Common Mistakes

* Not enabling culling
* Wrong namespace
* Ignoring resource limits

---

## 🔥 Exam Tip

👉 Resource optimization questions are common!

---

## 💡 Pro Tip

👉 Always monitor:

```bash
oc get pods
oc get pvc
```

---

## ✅ Summary

* Manage resources efficiently
* Use culling to save compute
* Customize workbench sizes

---

➡️ Next: Continue Module 4 🚀
