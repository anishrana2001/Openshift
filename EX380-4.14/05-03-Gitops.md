

# Question: Deploy a Machine Configuration using GITOPS:
## You task is to deploy the `OpenShift GitOps operator` according to the following requirements:
- The operator must install in the `openshift-gitops-operator` project.
- The ArgoCD instance must be `TLS` enabled with `reencrypt` termination.
- User `punit` is a member of the `ocpadmins` group.
- The `ocpadmins` group is the only group configured as `role:admin` with RBAC key policy.
- An ArgoCD instance Git repository exists at `https://git.ocp4.example.com/` . User `developer` user with `d3v3lop3r` as the password.
- Create a new project with name `machineconfig` and it should be `Public` in the visibility level.
- An application named `mach-config-motd-deploy` must be exists in the ArgoCD with the Sync Policy configured as `Manual`.

### The Git repository `https://git.ocp4.example.com/developer/machineconfig.git` contains `four` MachineConfig resources as follows:

### A file called 61-datacenter-swissre.yaml which uses the latest ignition version with the following configuration:
- A path exists called `/etc/datacenter-swissre`
- The filesystem is `root`
- The overwrite policy is `true`
- The object is applied only on the nodes marked with machineconfiguration.openshift.io/role: datacenter
-  Sets the permission on /etc/datacenter-swissre on all nodes to `rwx rw r - -`
-  The content of text file `devopswala.txt` must be visible on file `/etc/datacenter-swissre`
-  You can download this file from below URL.
  `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/README.md`

### A file called 61-cloud-swissre.yaml which uses the latest ignition version with the following configuration
  - A path exists called `/etc/cloud-swissre`
  - The filesystem is `root`
  - The overwrite policy is `true`
  - The object is applied only on the nodes marked with machineconfiguration.openshift.io/role: cloud
  - Sets the permission on /etc/cloud-swissre on all nodes to rw - rw - r - -
-  The content of text file `devopswala.txt` must be visible on file `/etc/cloud-swissre`
-  You can download this file from below URL.
  `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/README.md`

### A file called 61-master-swissre.yaml which uses the latest ignition version with the following configuration:
- A path exists called `/etc/master-swissre`
- The filesystem is `root`
- The overwrite policy is `true`
- The object is applied only on the nodes marked with machineconfiguration.openshift.io/role: master
- Sets the permission on /etc/master-swissre on all nodes to `r- - r- - r - -`
-  The content of text file `devopswala.txt` must be visible on file `/etc/master-swissre`
-  You can download this file from below URL.
  `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/README.md`  
 
### A file called 61-worker-swissre.yaml which uses the latest ignition version with the following configuration
  - A path exists called `/etc/worker-swissre`
  - The filesystem is `root`
  - The overwrite policy is `true`
  - The object is applied only on the nodes marked with machineconfiguration.openshift.io/role: worker
  - Sets the permission on `/etc/worker-swissre` on all nodes to `r- - r- - r - -`
-  The content of text file `devopswala.txt` must be visible on file `/etc/worker-swissre`
-  You can download this file from below URL.
  `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/README.md`

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
[student@workstation ~]$ cat devopswala.txt 
Enjoy the content of Openshift 
[student@workstation ~]$ cat devopswala.txt  | base64 -w0 ; echo
RW5qb3kgdGhlIGNvbnRlbnQgb2YgT3BlbnNoaWZ0IAo=
[student@workstation ~]$ 


oc get mc 99-master-chrony-conf-override -o yaml > 61-master-swissre.yaml
vi 61-master-swissre.yaml 


[student@workstation ex380]$ cat 61-master-swissre.yaml 
apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfig
metadata:
  labels:
    machineconfiguration.openshift.io/role: master
  name: 61-master-swissre.yaml 
spec:
  config:
    ignition:
      version: 3.2.0
    storage:
      files:
      - contents:
          source: data:;base64,RW5qb3kgdGhlIGNvbnRlbnQgb2YgT3BlbnNoaWZ0IAo=
        mode: 0444
        overwrite: true
        path: /etc/swissre-master
        filesystem: root
        overwrite: true
[student@workstation ex380]$ 




git clone  https://git.ocp4.example.com/developer/machineconfig.git
cd machineconfig/
cp ../61-master-swissre.yaml .
cd ex380/
cp ../61-master-swissre.yaml .
ls -ltr
git add 61-master-swissre.yaml 
git commit -m "hi"
git push 
```

### Create an application in the ArgoCD.
## After sometime check the machineconfig.
```
[student@workstation ~]$ oc get mc | grep 61-master-swissre.yaml 
61-master-swissre.yaml                                                                        3.2.0             7m38s
[student@workstation ~]$
```
