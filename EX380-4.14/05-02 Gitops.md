

# Question: Deploy a Machine Configuration using GITOPS:
## You task is to deploy the `OpenShift GitOps operator` according to the following requirements:
- The operator must install in the `openshift-gitops-operator` project.
- The ArgoCD instance must be `TLS` enabled with r`eencrypt` termination.
- User `punit` is a member of the `admins-team` group.
- The `admins-team` group is the only group configured as `role:admin` with RBAC key policy.
- An ArgoCD instance Git repository exists at `https://git.ocp4.example.com/` with skip server verification enabled. User `developer` user with `d3v3lop3r` as the password.
- An application named `mach-config-motd-deploy` mnust be exists in the Git repository with the Sync Policy configured as `Manual`.
- You can download the file from below URL.
https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/EX380/Console-operator-05-02.yaml
---


### Solution: 

### Deploy the operator from web consloe. After that
```
[student@workstation ~]$ oc -n openshift-gitops get argocd openshift-gitops 
NAME               AGE
openshift-gitops   7m6s

[student@workstation ~]$ oc -n openshift-gitops get cm
NAME                        DATA   AGE
argocd-cm                   18     7m18s
argocd-gpg-keys-cm          0      7m16s
argocd-rbac-cm              3      7m16s
argocd-ssh-known-hosts-cm   1      7m16s
argocd-tls-certs-cm         0      7m16s
kube-root-ca.crt            1      7m19s
openshift-gitops-ca         1      7m17s
openshift-service-ca.crt    1      7m19s

[student@workstation ~]$ 
[student@workstation ~]$ oc -n openshift-apiserver describe cm trusted-ca-bundle | grep cacert

[student@workstation ~]$ oc -n openshift-apiserver describe cm trusted-ca-bundle | grep cabundle
Labels:       config.openshift.io/inject-trusted-cabundle=true

[student@workstation ~]$ oc -n openshift-gitops create cm cluster-root-ca-bundle
configmap/cluster-root-ca-bundle created


[student@workstation ~]$ oc -n openshift-gitops get cm cluster-root-ca-bundle -o yaml | wc -l
8

[student@workstation ~]$ oc -n openshift-gitops label cm cluster-root-ca-bundle config.openshift.io/inject-trusted-cabundle=true
configmap/cluster-root-ca-bundle labeled

[student@workstation ~]$ oc -n openshift-gitops get cm cluster-root-ca-bundle -o yaml | wc -l
3931

[student@workstation ~]$ oc -n openshift-gitops get argocds.argoproj.io openshift-gitops -o yaml > /tmp/argocd-default.yaml

[student@workstation ~]$ oc adm  groups new admins-team
group.user.openshift.io/admins-team created
[student@workstation ~]$ oc adm groups add-users admins-team punit 
group.user.openshift.io/admins-team added: "punit"
[student@workstation ~]$

[student@workstation ~]$ ls -ltr  /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem 
-r--r--r--. 1 root root 219794 Mar  5  2024 /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem


[student@workstation ~]$ oc -n openshift-gitops edit argocd openshift-gitops 
argocd.argoproj.io/openshift-gitops edited



[student@workstation ~]$ oc -n openshift-gitops get argocd openshift-gitops -o yaml
apiVersion: argoproj.io/v1beta1
kind: ArgoCD
metadata:
  creationTimestamp: "2025-09-13T07:14:51Z"
  finalizers:
  - argoproj.io/finalizer
  generation: 2
  name: openshift-gitops
  namespace: openshift-gitops
  resourceVersion: "570043"
  uid: 8417dd11-8127-49b4-bab6-2653dae5b127
spec:
  applicationSet:
    resources:
      limits:
        cpu: "2"
        memory: 1Gi
      requests:
        cpu: 250m
        memory: 512Mi
    webhookServer:
      ingress:
        enabled: false
      route:
        enabled: false
  controller:
    processors: {}
    resources:
      limits:
        cpu: "2"
        memory: 2Gi
      requests:
        cpu: 250m
        memory: 1Gi
    sharding: {}
  grafana:
    enabled: false
    ingress:
      enabled: false
    resources:
      limits:
        cpu: 500m
        memory: 256Mi
      requests:
        cpu: 250m
        memory: 128Mi
    route:
      enabled: false
  ha:
    enabled: false
    resources:
      limits:
        cpu: 500m
        memory: 256Mi
      requests:
        cpu: 250m
        memory: 128Mi
  initialSSHKnownHosts: {}
  monitoring:
    enabled: false
  notifications:
    enabled: false
  prometheus:
    enabled: false
    ingress:
      enabled: false
    route:
      enabled: false
  rbac:
    defaultPolicy: ""
    policy: |
      g, system:cluster-admins, role:admin
      g, cluster-admins, role:admin
      g, admins-team, role:admin          # ⬅️ ⬅️ 👈👈👈👈 Line added. 
    scopes: '[groups]'
  redis:
    resources:
      limits:
        cpu: 500m
        memory: 256Mi
      requests:
        cpu: 250m
        memory: 128Mi
  repo:
    resources:
      limits:
        cpu: "1"
        memory: 1Gi
      requests:
        cpu: 250m
        memory: 256Mi
    volumeMounts:                                                    # ⬅️ ⬅️ 👈👈👈👈 Line added. 
    - mountPath: /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem   # ⬅️ ⬅️ 👈👈👈👈 Line added. 
      name: my-name                    # ⬅️ ⬅️ 👈👈👈👈 Line added. 
      subPath: ca-bundle.crt           # ⬅️ ⬅️ 👈👈👈👈 Line added. 
    volumes:                           # ⬅️ ⬅️ 👈👈👈👈 Line added. 
    - configMap:                       # ⬅️ ⬅️ 👈👈👈👈 Line added. 
        name: cluster-root-ca-bundle   # ⬅️ ⬅️ 👈👈👈👈 Line added. 
      name: my-name                    # ⬅️ ⬅️ 👈👈👈👈 Line added. 
  resourceExclusions: |
    - apiGroups:
      - tekton.dev
      clusters:
      - '*'
      kinds:
      - TaskRun
      - PipelineRun
  server:
    autoscale:
      enabled: false
    grpc:
      ingress:
        enabled: false
    ingress:
      enabled: false
    resources:
      limits:
        cpu: 500m
        memory: 256Mi
      requests:
        cpu: 125m
        memory: 128Mi
    route:
      enabled: true 
      tls:                      # ⬅️ ⬅️ 👈👈👈👈 Line added. 
        termination: reencrypt  # ⬅️ ⬅️ 👈👈👈👈 Line added. 
    service:
      type: ""
  sso:
    dex:
      openShiftOAuth: true
      resources:
        limits:
          cpu: 500m
          memory: 256Mi
        requests:
          cpu: 250m
          memory: 128Mi
    provider: dex
  tls:
    ca: {}
status:
  applicationController: Running
  applicationSetController: Running
  host: openshift-gitops-server-openshift-gitops.apps.ocp4.example.com
  phase: Available
  redis: Running
  repo: Running
  server: Running
  sso: Running
[student@workstation ~]$



```


### Create a public repository in the classroom GitLab.

## Open a web browser and navigate to https://git.ocp4.example.com. Log in as the developer user with `d3v3lop3r` as the password.

## Click New project, and then click 'Create blank project'. Use 'gitops-admin' as the project slug (repository name), select the 'Public' visibility level, and use the default values for all other fields. Click 'Create project'.
	

```
[student@workstation ~]$ mkdir test
[student@workstation ~]$ cd test/
[student@workstation test]$ git clone https://git.ocp4.example.com/developer/gitops-admin.git
Cloning into 'gitops-admin'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (3/3), done.
[student@workstation test]$ ls -ltr
total 0
drwxr-xr-x. 3 student student 35 Aug 31 04:04 gitops-admin
[student@workstation test]$ cd gitops-admin/
[student@workstation gitops-admin]$ ls -ltr
total 8
-rw-r--r--. 1 student student 6200 Aug 31 04:04 README.md
[student@workstation gitops-admin]$ 

```


[student@workstation gitops-admin]$ cat console.yaml 
apiVersion: operator.openshift.io/v1
kind: Console
metadata:
  name: cluster
  annotations:
    argocd.argoproj.io/sync-options: ServerSideApply=true,Validate=false
spec:
  customization:
    customProductName: Production
[student@workstation gitops-admin]$ 


[student@workstation gitops-admin]$ git add console.yaml

[student@workstation gitops-admin]$ git commit -m "anish.rana" 
[main a4e8208] anish.rana
 Committer: Student User <student@workstation.lab.example.com>
Your name and email address were configured automatically based
on your username and hostname. Please check that they are accurate.
You can suppress this message by setting them explicitly. Run the
following command and follow the instructions in your editor to edit
your configuration file:

    git config --global --edit

After doing this, you may fix the identity used for this commit with:

    git commit --amend --reset-author

 1 file changed, 9 insertions(+)
 create mode 100644 console.yaml


[student@workstation gitops-admin]$ git push
Username for 'https://git.ocp4.example.com': developer 
Password for 'https://developer@git.ocp4.example.com':     "d3v3lop3r"
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 2 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 450 bytes | 450.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
To https://git.ocp4.example.com/developer/gitops-admin.git
   b04a255..a4e8208  main -> main
   
   
## Log in to the Argo CD web console as the admin user.

###    Go back to the Argo CD browser tab.

###    Click LOG IN VIA OPENSHIFT, and then click Red Hat Identity Management. Log in as the admin user with redhatocp as the password, and then allow the user:info permission.

### Create an application with the repository and observe the results.

###    Click CREATE APPLICATION.
```
    Create an application with the information in the following table:
    Field 	Value
    Application Name	gitops-admin
    Project Name	default
    Retry	Checked
    Repository URL	https://git.ocp4.example.com/developer/gitops-admin.git
    Path	.
    Cluster URL	https://kubernetes.default.svc
```
###  Then, click CREATE.



