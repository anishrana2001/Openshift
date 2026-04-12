# 📌 Users, Projects, and Permissions (RHOAI)

## 🎯 Objective

Learn how to manage users and control access in OpenShift AI.

---

## 🧠 Core Concept

RHOAI uses **OpenShift authentication (RHOCP)**.

👉 Any authenticated user can access the dashboard by default.

---

## 👑 Admin Access

Users get admin access if:

* They are part of:

  ```bash
  rhods-admins
  ```
* OR they have:

  ```bash
  cluster-admin role
  ```

---

## 🛠️ Add Users to Admin Group

```bash
oc adm groups add-users rhods-admins user1 user2
```

---

## 🔐 Default Access Control

Configured via:

👉 Dashboard → Settings → User Management

### Controls:

* Admin groups
* Allowed user groups

---

## ⚠️ Important Note

> Dashboard access ≠ Kubernetes permissions

Even if blocked in UI:
👉 Users may still access via CLI

---

## 🧪 Hands-On Lab (Guided)

### Step 1: Verify Access

* Login as `developer`
* Check project list
* Observe missing project

---

### Step 2: Create Group

```yaml
apiVersion: user.openshift.io/v1
kind: Group
metadata:
  name: my-team
users:
  - developer
```

---

### Step 3: Assign Permissions

* Go to RHOAI Dashboard
* Open project
* Add group `my-team`
* Assign **Contributor role**

---

### Step 4: Verify

* Login as developer
* Project should now be visible

---

## 🔥 Exam Tip

👉 Permissions are managed using:

```bash
RoleBindings
```

---

## ✅ Summary

* Users authenticated via OpenShift
* Groups control access
* Projects use RBAC

---

➡️ Next: RBAC Deep Dive
