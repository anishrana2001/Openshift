# ✅ RHOAI Verification & Basic Usage

## 🎯 Objective

Verify installation and start using RHOAI.

---

## 🔍 Verify Installation

Run:

```bash
oc get pods -n redhat-ods-applications
```

✔️ All pods should be in **Running** state

---

## 🌐 Access RHOAI Dashboard

* Go to OpenShift Console
* Navigate:
  👉 AI → Data Science Projects

---

## 🧪 Create First Workbench

1. Click Create Workbench
2. Select environment
3. Launch

---

## 📦 Example Workflow

* Create project
* Launch notebook
* Run Python code

---

## ⚠️ Common Issues

* Pods stuck in Pending
* Insufficient resources
* Operator not ready

---

## 🔧 Troubleshooting Commands

```bash
oc get events
oc describe pod <pod-name>
```

---

## 🔥 Exam Scenario

> Install RHOAI and verify all components are running.

---

## 💡 Pro Tip

👉 Always check namespace:

```bash
oc project
```

---

## ✅ Summary

* Verified pods
* Accessed dashboard
* Created workbench

---

➡️ Next: Continue Module 3 🚀
