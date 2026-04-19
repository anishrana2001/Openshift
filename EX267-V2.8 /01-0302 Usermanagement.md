
### Create a Lab for this question. Chapter 5: User and Resource Management
```
oc login -u admin -p redhatocp  https://api.ocp4.example.com:6443
oc -n openshift-config get secrets htpasswd-secret -o json | jq -r '.data.htpasswd' | base64 --decode > /tmp/htpasswd-ex267.text
htpasswd -b /tmp/htpasswd-ex267.text suraj anishrana2001
htpasswd -b /tmp/htpasswd-ex267.text rajan anishrana2001
htpasswd -b /tmp/htpasswd-ex267.text punit anishrana2001
htpasswd -b /tmp/htpasswd-ex267.text raja anishrana2001
oc -n openshift-config delete secrets htpasswd-secret 
oc -n openshift-config create secret generic htpasswd-secret --from-file htpasswd=/tmp/htpasswd-ex267.text
```

Create one group called `devops-wala` and this group must have `developer`, `rajan` and `punit` users.
These users must able to access to the RHOAI dashboard but are not administrators or member of any other groups.
Ensure that administrator access to the RHOAI dashboard is available only to `suraj` and the following users.
	- `raja`
	- Andrew
	
Ensure that no one can access the RHOAI dashboard except `admin` users and members of the `devops-wala` group.



oc adm groups add-users rhods-admins <username1> <username2>


Your goals:

1. Group `devops-wala` contains only `developer`, `rajan`, `punit`.
- Members of `devops-wala`:
	- Can access the RHOAI dashboard.
	- Are not admins.
	- Are not in any other RHOAI-relevant groups.

Admin access to RHOAI is only for:

- `suraj` users (existing)
- `raja`

No one else can access the RHOAI dashboard.


### 1. Create and populate the `devops-wala` group
```bash
#### Create the group
```
oc adm groups new `devops-wala` `developer` `rajan` `punit`
```
####  If the group exists already, reset membership explicitly
```
oc adm groups add-users `devops-wala` `developer` `rajan` `punit`
```

####  Make sure *only* these are members:
```
oc get group `devops-wala` -o yaml
```
#### If you find extra users in the YAML (users: list), remove them:

```
oc adm groups remove-users `devops-wala` <extra-user1> <extra-user2>
```

#### Result: Group `devops-wala` now contains only `developer`, `rajan`, `punit`.

### 2. Create an RHOAI “user” role (non-admin)
#### In many setups there is an existing cluster role that grants basic RHOAI dashboard access (often something like rhods-user / ods-user / similar). If your cluster already has one, reuse it; otherwise, you’d create a custom one.

#### Example if a cluster role named rhods-user already exists:

```
oc get clusterrole | grep -i rhods
```
####  suppose you see: **rhods-user**
#### Then bind it to the `devops-wala` group:

```
oc adm policy add-cluster-role-to-group rhods-user `devops-wala`
```
#### This gives dashboard access without admin privileges.
#### If you needed to define a minimal custom cluster role, it might look like this (name: rhods-dashboard-user):

bash
cat <<'EOF' | oc apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: rhods-dashboard-user
rules:
  - apiGroups: [""]  # example, adjust to RHOAI API groups
    resources: ["pods"]
    verbs: ["get", "list"]
  # (in real clusters, you’d use the official RHOAI user role definition)
EOF
Then:

```
oc adm policy add-cluster-role-to-group rhods-dashboard-user `devops-wala`
```
### 3. Create an RHOAI admin role binding for `raja` and andrew
Again, there is typically a built-in RHOAI admin cluster role (for example rhods-admin / ods-admin / similar). Reuse that if available:

```
oc get clusterrole | grep -i rhods
``
####  suppose you see: rhods-admin
#### Bind that admin role to `raja` and andrew as users, not via `devops-wala`:

```
oc adm policy add-cluster-role-to-user rhods-admin `raja`

```
### 4. Ensure `devops-wala` members are not admins and not in other groups
#### 4.1 Remove admin roles from `devops-wala` if any
#### If earlier bindings granted admin to the whole group, remove them:


####  Check for existing bindings mentioning `devops-wala`
```
oc get clusterrolebindings -o wide | grep `devops-wala`
```

# For each binding that gives admin-level access (e.g., rhods-admin, cluster-admin),
# remove the group subject
```
oc adm policy remove-cluster-role-from-group rhods-admin `devops-wala`
oc adm policy remove-cluster-role-from-group cluster-admin `devops-wala`
```
#### 4.2 Ensure they aren’t in any other RHOAI groups
#### If your environment uses other groups (e.g., rhods-users, data-scientists), check and clean:

```
oc get groups
```
####  For each extra group G:
oc get group G -o yaml | grep -E '`developer`|`rajan`|`punit`'

# If they appear, remove them:
oc adm groups remove-users G `developer` `rajan` `punit`
Result: `developer`, `rajan`, `punit` only belong to `devops-wala` (plus any non‑RHOAI groups that are irrelevant) and have user‑level RHOAI access, not admin.

5. Block dashboard access for everyone else
You want: only `suraj` + `raja` + andrew + `devops-wala` to access RHOAI.

Typical pattern:

Make sure the RHOAI dashboard is not relying on a wildcard “everyone” binding like system:authenticated → RHOAI‑user role.

If such a binding exists, remove it and then explicitly bind only the groups/users you want.

5.1 Remove broad access bindings
Find bindings that grant RHOAI user access to system:authenticated, system:authenticated:oauth, or generic groups:

bash
oc get clusterrolebindings -o wide | grep -i rhods
# or grep the specific RHOAI user role name
oc get clusterrolebindings -o wide | grep -i 'rhods-user'
If you see something like:

ClusterRole: rhods-user → Group: system:authenticated

remove that binding:

bash
oc adm policy remove-cluster-role-from-group rhods-user system:authenticated
oc adm policy remove-cluster-role-from-group rhods-user system:authenticated:oauth
Now no generic user will have RHOAI user access.

5.2 Keep only explicit bindings
At this point, access should be:

Admins: those with cluster-admin + `raja` + andrew bound to the RHOAI admin role.

Users: members of `devops-wala` group bound to the RHOAI user role.

No one else: because we removed any broad role bindings.

You can verify with:

bash
oc auth can-i get <some RHOAI resource> --as `developer`
oc auth can-i get <some RHOAI resource> --as `raja`
oc auth can-i get <some RHOAI resource> --as randomuser
Where <some RHOAI resource> is a resource that the dashboard uses (e.g., in the redhat-ods-applications namespace). In an exam, you just need to show that `developer` can see the dashboard but cannot perform admin actions, while `raja`/andrew can, and a random user cannot access it at all.

Summary
Group `devops-wala` created with exactly `developer`, `rajan`, `punit`.

`devops-wala` bound to a non‑admin RHOAI user cluster role → they can open the RHOAI dashboard.

`raja` and andrew bound to the RHOAI admin cluster role.

Any “everyone” binding (system:authenticated) to RHOAI user/admin roles removed, so only `suraj` + `raja` + andrew + `devops-wala` can access the dashboard.

If you tell me the exact RHOAI user/admin cluster role names from oc get clusterrole | grep -i rhods, I can rewrite these commands with their precise names for your cluster.

