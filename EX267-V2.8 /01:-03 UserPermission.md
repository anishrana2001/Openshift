# EX267 Red Hat OpenShift AI - Workbench Creation Lab

## Task Overview
Create a Data Science Workbench with specific configurations and user permissions in OpenShift AI.

**Project**: `my-lab-pro`  
**Workbench**: `myworkbench-wb`  
**Owner**: `suraj`  
**Admin Users**: `rajan`, `punit`  
**Owner Permissions**: `suraj` (edit access)  
**Resources**: 8GB RAM, 2 CPU, 2Gi Storage  
**Image**: PyTorch v2.0.1  
**Environment**: ConfigMap with `var=devops-wala`

---

## Prerequisites
- OpenShift AI (RHODS) installed and accessible
- `oc` CLI configured with cluster admin or project admin access
- Users `suraj`, `rajan`, `punit` exist in the cluster

---

## Step-by-Step Solution

### Step 1: Create Project
```bash
oc new-project my-lab-pro
oc project my-lab-pro
```

### Step 2: Create ConfigMap for Environment Variables
```bash
cat <<EOF | oc apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: workbench-config
  namespace: my-lab-pro
data:
  var: devops-wala
EOF
```

### Step 3: Login as Suraj User and Create Workbench
```bash
# Switch to suraj user context
oc login -u suraj -p <suraj-password> <api-server-url>

# Create workbench using OpenShift AI dashboard or CLI
oc create -f - <<EOF
apiVersion: rhods.redhat.com/v1beta01
kind: DataScienceWorkBench
metadata:
  name: myworkbench-wb
  namespace: my-lab-pro
spec:
  template:
    name: pytorch-2.0.1
    namespace: rhods-notebooks  # Default notebook namespace
  resources:
    limits:
      memory: 8Gi
      cpu: 2
    requests:
      memory: 8Gi
      cpu: 2
  storage:
    pvcStorageClass: ocs-storagecluster-cephfs  # Adjust for your storage class
    pvcSize: 2Gi
  env:
    - name: VAR
      valueFrom:
        configMapKeyRef:
          name: workbench-config
          key: var
EOF
```

### Step 4: Grant Admin Permissions to Rajan and Punit
```bash
# As cluster admin or project owner
oc adm policy add-role-to-user admin rajan -n my-lab-pro
oc adm policy add-role-to-user admin punit -n my-lab-pro
```

### Step 5: Configure Suraj Edit Permissions
```bash
# Suraj already has edit permissions as workbench owner
# Verify permissions
oc auth can-i edit datascienceworkbench --as=suraj -n my-lab-pro
```

### Step 6: Verify Workbench Creation
```bash
# Check workbench status
oc get dsworkbench myworkbench-wb -n my-lab-pro -o wide

# Check PVC
oc get pvc -n my-lab-pro

# Check ConfigMap
oc get configmap workbench-config -n my-lab-pro -o yaml
```

---

## Expected Output

### Workbench Status
