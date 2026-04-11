# EX267 Red Hat OpenShift AI - Workbench Creation Lab

## Task Overview
Create a Data Science Workbench with specific configurations and user permissions in OpenShift AI.

- create a **project** `my-lab-pro`
- User `suraj` should create a **workbench** called `myworkbench-wb` under project `my-lab-pro`
- Allow **`rajan`** and **`punit`** users with **`admin`** permission.
- User `suraj` can `edit` the workbench.
- Select the image which contain **`PyTorch** and **Version selection `2024.1`**
- The workbench must have `8GB` **RAM**, `2` **CPU** 
- `2 Gi` **Persistent Storage**.
- Add the **`environment variables`** as **`configMap`** with `var=devops-wala`

---
## How to create a lab for this question?
```
oc login -u admin -p redhatocp  https://api.ocp4.example.com:6443
oc -n openshift-config get secrets htpasswd-secret -o json | jq -r '.data.htpasswd' | base64 --decode > /tmp/htpasswd-ex267.text
htpasswd -b /tmp/htpasswd-ex267.text suraj anishrana2001
htpasswd -b /tmp/htpasswd-ex267.text rajan anishrana2001
htpasswd -b /tmp/htpasswd-ex267.text punit anishrana2001
htpasswd -b /tmp/htpasswd-ex267.text raja anishrana2001
oc -n openshift-config delete secrets htpasswd-secret 
oc -n openshift-config create secret generic htpasswd-secret --from-file htpasswd=/tmp/htpasswd-ex267.text
lab start -t AI263 manage-resources
```

## Prerequisites
- OpenShift AI (RHODS) installed and accessible
- `oc` CLI configured with cluster admin or project admin access
- Users `suraj`, `rajan`, `punit` exist in the cluster

---

## Step-by-Step Solution

### Step 1: Create Project
- Create project from Web GUI.

### Step 2: Assign the given privileges to users.

### Step 3: Login as Suraj User and Create Workbench


### Step 4: Verify Workbench Creation
```bash
# Check workbench status
oc project my-lab-pro
oc get dsworkbench myworkbench-wb -n my-lab-pro -o wide

# Check PVC
oc get pvc -n my-lab-pro

# Check ConfigMap
oc get configmap workbench-config -n my-lab-pro -o yaml
```

---

## Expected Output

### Workbench Status
