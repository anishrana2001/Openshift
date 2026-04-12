# 🛠️ RHOAI Installation on OpenShift

## 🎯 Objective

Install Red Hat OpenShift AI using OperatorHub.

---

## 📋 Prerequisites

* OpenShift Cluster access
* Cluster Admin permissions
* Internet access

---

## 🚀 Step-by-Step Installation

### 🔹 Step 1: Login to OpenShift

```bash
oc login -u kubeadmin -p <password>
```

---

### 🔹 Step 2: Open OperatorHub

* Go to OpenShift Web Console
* Navigate to:
  👉 Operators → OperatorHub

---

### 🔹 Step 3: Search for RHOAI

* Search: **OpenShift AI**
* Select the operator

---

### 🔹 Step 4: Install Operator

* Click Install
* Choose:

  * All namespaces
  * Automatic updates

---

### 🔹 Step 5: Create Data Science Project

* Go to:
  👉 Data Science Projects
* Click **Create Project**

---

## 🧪 CLI Alternative (IMPORTANT)

```bash
oc get operators
oc get csv -A
```

---

## ⚠️ Common Mistakes

* Not selecting correct namespace
* Missing permissions
* Operator not fully installed

---

## 🔥 Exam Tip

👉 Always verify installation using:

```bash
oc get pods -n redhat-ods-applications
```

---

## ✅ Summary

* Installed via OperatorHub
* Requires admin access
* Must verify pods running

---

➡️ Next: Verification & Usage
