# 🔐 User Management & RBAC in OpenShift

## 🎯 Objective

Master Role-Based Access Control (RBAC) for EX267.

---

## 🧠 Key Resources

| Resource     | Purpose             |
| ------------ | ------------------- |
| Users        | Individual accounts |
| Groups       | Collection of users |
| RoleBindings | Assign permissions  |

---

## 🛠️ Create Project (Namespace)

```bash
oc create namespace myproject
```

---

## 🏷️ Add Labels (Optional)

```bash
oc label namespace myproject opendatahub.io/dashboard='true'
```

---

## 🔑 Grant Permissions

### Grant edit access:

```bash
oc adm policy add-role-to-user edit developer -n myproject
```

---

### Grant to Group:

```bash
oc adm policy add-role-to-group edit my-team -n myproject
```

---

## 🧠 Role Types

| Role  | Access           |
| ----- | ---------------- |
| view  | Read-only        |
| edit  | Modify resources |
| admin | Full control     |

---

## 🔍 Verify Permissions

```bash
oc get rolebindings -n myproject
```

---

## ⚠️ Common Mistakes

* Forgetting namespace
* Wrong role assignment
* Not verifying bindings

---

## 🔥 Exam Scenario

> Grant a user edit access to a project

---

## 🧪 Practice Lab

1. Create namespace
2. Create user/group
3. Assign role
4. Verify access

---

## 💡 Pro Tip

👉 Always check:

```bash
oc whoami
oc project
```

---

## ✅ Summary

* RBAC controls everything
* RoleBindings are key
* Namespace scope matters

---

➡️ Next: Resource Management
