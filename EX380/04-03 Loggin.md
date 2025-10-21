### Prepare the lab.
```
lab start logging-forward
```

# You need to Install the `OpenShift Logging operator` and configure log forwarding to the syslog server according to the following specifications:

  - The log collector type must be `vector`
  - Application and infrastructure logs must be forwarded to the syslog server on host `utility.lab.example.com`
  - Audit logs must be forwarded to the syslog server on host `utility.lab.example.com`
  - The syslog service on both hosts listens on port tcp/514 and udp/514

---
  - Application logs are tagged with `procID: app`
  - Application logs are tagged with `msgID: app`
---
  - Infrastructure logs are tagged with `procID: infra`
  - Infrastructure logs are tagged with `msgID: infra`
---
  - Audit logs are tagged with `procID: audit`
  - Audit logs are tagged with `msgID: audit`
---
  - All logs are tagged with `appName: ocp-lab`
  - All logs are tagged with `msgID: audit`
---
# Deploy the Event Router component to capture Kubernetes events. One can use the eventrouter image `registry.ocp4.example.com:8443/openshift-logging/eventrouter-rhel9:v0.4`

# The syslog servers have already been fully configured for you to receive logging messages and filter them using the 'msgID' attribute to the following files:

  - `/var/log/openshift/app.log`
  - `/var/log/openshift/infra.log`
  - `/var/log/openshift/audit.log`

# You may verify that the audit logs from the cluster nodes are forwarded to the syslog server by login into the 'utility' server with 'root' username. 
`ssh root@utility`

# You can login to one master01 node to check the logs. 
- `ssh core@master01.ocp4.example.com`
---

### Solution: Create a clusterlogging from web portal.

```

[student@workstation ~]$ cat forward.yaml 
kind: ClusterLogForwarder
apiVersion: logging.openshift.io/v1
metadata:
  name: instance
  namespace: openshift-logging
spec:
  outputs:
    - name: audit-syslog
      type: syslog
      url: tcp://utility.lab.example.com:514
      syslog:
        msgID: audit
        procID: audit
        appName: ocp-lab
    - name: infra-syslog
      type: syslog
      url: tcp://utility.lab.example.com:514
      syslog:
        msgID: infra
        procID: infra
        appName: ocp-lab
    - name: app-syslog
      type: syslog
      url: tcp://utility.lab.example.com:514
      syslog:
        msgID: app
        procID: app
        appName: ocp-lab
  pipelines:
    - name: audit-syslog
      inputRefs:
        - audit
      outputRefs:
        - audit-syslog
    - name: app-syslog
      inputRefs:
        - application
      outputRefs:
        - app-syslog
    - name: infra-syslog
      inputRefs:
        - infrastructure
      outputRefs:
        - infra-syslog



Other terminal
ssh core@master01.ocp4.example.com



Other terminal

ssh root@utility

cd /var/log/openshift
ls -ltr

tail -f infra.log  | grep master01 | grep infra | grep ssh 

```

```
[student@workstation logging-forward]$ cat eventrouter.yml 
apiVersion: template.openshift.io/v1
kind: Template
metadata:
  name: eventrouter-template
  annotations:
    description: "A pod forwarding kubernetes events to OpenShift Logging stack."
    tags: "events,EFK,logging,cluster-logging"
objects:
  - kind: ServiceAccount
    apiVersion: v1
    metadata:
      name: eventrouter
      namespace: ${NAMESPACE}
  - kind: ClusterRole
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: event-reader
    rules:
    - apiGroups: [""]
      resources: ["events"]
      verbs: ["get", "watch", "list"]
  - kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: event-reader-binding
    subjects:
    - kind: ServiceAccount
      name: eventrouter
      namespace: ${NAMESPACE}
    roleRef:
      kind: ClusterRole
      name: event-reader
  - kind: ConfigMap
    apiVersion: v1
    metadata:
      name: eventrouter
      namespace: ${NAMESPACE}
    data:
      config.json: |-
        {
          "sink": "stdout"
        }
  - kind: Deployment
    apiVersion: apps/v1
    metadata:
      name: eventrouter
      namespace: ${NAMESPACE}
      labels:
        component: "eventrouter"
        logging-infra: "eventrouter"
        provider: "openshift"
    spec:
      selector:
        matchLabels:
          component: "eventrouter"
          logging-infra: "eventrouter"
          provider: "openshift"
      replicas: 1
      template:
        metadata:
          labels:
            component: "eventrouter"
            logging-infra: "eventrouter"
            provider: "openshift"
          name: eventrouter
        spec:
          serviceAccount: eventrouter
          containers:
            - name: kube-eventrouter
              image: ${IMAGE}
              imagePullPolicy: IfNotPresent
              resources:
                requests:
                  cpu: ${CPU}
                  memory: ${MEMORY}
              volumeMounts:
              - name: config-volume
                mountPath: /etc/eventrouter
              securityContext:
                allowPrivilegeEscalation: false
                capabilities:
                  drop: ["ALL"]
          securityContext:
            runAsNonRoot: true
            seccompProfile:
              type: RuntimeDefault
          volumes:
          - name: config-volume
            configMap:
              name: eventrouter
parameters:
  - name: IMAGE
    displayName: Image
    value: "registry.ocp4.example.com:8443/openshift-logging/eventrouter-rhel9:v0.4"
  - name: CPU
    displayName: CPU
    value: "100m"
  - name: MEMORY
    displayName: Memory
    value: "128Mi"
  - name: NAMESPACE
    displayName: Namespace
    value: "openshift-logging"
[student@workstation logging-forward]$
```


### How to clear the lab?
```
oc delete -f logforward.yaml
lab finish logging-forward
```
