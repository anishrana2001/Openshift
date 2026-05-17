## Prepare the lab.

```bash
oc new-project passthrough
oc get all
```

```bash
# In passthrough termination, the application must already serve HTTPS.
# Example information used in this lab:
# Project      : passthrough
# Service name : todo-https
# Target port  : 8443
# Hostname     : anishrana2001.apps.ocp4.example.com
```

# Passthrough Termination in OpenShift

### Create secure Route with below information

- Create a secure route in `passthrough` project.
- End user traffic must **not decrypt at router level**.
- Router should pass encrypted TLS traffic directly to the backend pod.
- Expose application `https://anishrana2001.apps.ocp4.example.com`
- TLS certificate and private key must be configured **inside the application pod**, not on the route.
- Route termination type must be `passthrough`.
- Service is already created in the given project; you just have to expose the service with HTTPS.
- The application should produce the output.

---

### Important Notes:

- In `passthrough` termination, OpenShift router does **not terminate TLS**.
- The router forwards encrypted traffic directly to the destination pod.
- No `--key`, `--cert`, or `--ca-cert` is required while creating the route.
- Backend application must listen on HTTPS port, for example `8443`.
- If the application is only HTTP, passthrough route will not work properly.
- Passthrough route is useful when the application manages its own certificate.
- Passthrough route can support client certificate authentication, also called two-way TLS or mTLS.

---

### Solution:

### Go to the given project `passthrough`

```bash
oc project passthrough
```

```bash
oc get all
```

### Check the service

```bash
oc get svc
```

```bash
oc describe svc todo-https
```

### Check service port

```bash
oc get svc todo-https -o yaml
```

- Confirm that service is pointing to the HTTPS target port.
- Example target port: `8443`
- In passthrough termination, traffic goes from client → router → pod without TLS decryption at router.

### Check existing route

```bash
oc get route
```

### Delete old route if already present

```bash
oc delete route todo-https
```

> If route is not present, you can ignore the error.

---

## Create Passthrough Route

### We need to create the route with `passthrough` termination.

```bash
oc create route passthrough todo-https \
  --service todo-https \
  --port 8443 \
  --hostname anishrana2001.apps.ocp4.example.com
```

### Command explanation:

- `oc create route passthrough` ==> Creates secure route with passthrough TLS termination.
- `todo-https` ==> Route name.
- `--service todo-https` ==> Service name to expose.
- `--port 8443` ==> Service port where HTTPS application is running.
- `--hostname` ==> External DNS name for the application.

---

## Check Route

```bash
oc get route
```

```bash
oc describe route todo-https
```

### Check route YAML

```bash
oc get route todo-https -o yaml
```

### Expected TLS section:

```yaml
tls:
  termination: passthrough
```

- Only `termination: passthrough` is required in TLS section.
- Route should not contain certificate or private key.
- Certificate is served by backend pod/application.

---

## Optional: Redirect HTTP to HTTPS

### If question asks to redirect insecure traffic, patch the route.

```bash
oc patch route todo-https \
  --type merge \
  -p '{"spec":{"tls":{"insecureEdgeTerminationPolicy":"Redirect"}}}'
```

### Check again

```bash
oc get route todo-https -o yaml
```

### Expected TLS section after patch:

```yaml
tls:
  termination: passthrough
  insecureEdgeTerminationPolicy: Redirect
```

---

## Post Check

### Access application using curl

```bash
curl -k https://anishrana2001.apps.ocp4.example.com
```

- `-k` is used when backend application is using a self-signed certificate.
- If certificate is trusted by your system, then use curl without `-k`.

```bash
curl https://anishrana2001.apps.ocp4.example.com
```

### Verify TLS certificate served by backend pod

```bash
openssl s_client \
  -connect anishrana2001.apps.ocp4.example.com:443 \
  -servername anishrana2001.apps.ocp4.example.com \
  -showcerts
```

- In passthrough route, certificate shown here comes from the application pod.
- Router does not provide the certificate.

---

## Sample Route YAML

```yaml
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: todo-https
  namespace: passthrough
spec:
  host: anishrana2001.apps.ocp4.example.com
  port:
    targetPort: 8443
  tls:
    termination: passthrough
    insecureEdgeTerminationPolicy: Redirect
  to:
    kind: Service
    name: todo-https
```

---

## Quick Difference

| Route Type | TLS Decrypts At | Certificate Stored In Route? | Backend Traffic |
|---|---|---|---|
| Edge | Router | Yes | Usually HTTP |
| Re-encrypt | Router and backend | Yes | HTTPS |
| Passthrough | Application pod | No | HTTPS |

---

## Troubleshooting

### 1. Application not opening

```bash
oc get pods
oc get svc
oc get endpoints todo-https
```

- Check pod is running.
- Check service has endpoints.
- Check correct service port is used in route.

### 2. TLS handshake error

- Backend application may not be serving HTTPS.
- Certificate may be invalid.
- Service target port may be wrong.

### 3. Certificate mismatch error

- Certificate CN/SAN should match route hostname.
- Example hostname: `anishrana2001.apps.ocp4.example.com`

### 4. Route already exists

```bash
oc delete route todo-https
```

Then recreate the passthrough route.

---

## How to delete the lab.

```bash
oc delete route todo-https
oc delete service todo-https
oc delete deployment todo-https
oc delete secret todo-https-tls
oc delete project passthrough
```
