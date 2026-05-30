# Task 17: Generate Kubernetes YAML from a Pod

## Objective

Generate Kubernetes YAML from a Podman pod and recreate the pod from the YAML file.

## Scenario

A local pod must be converted into a Kubernetes-style YAML file for review and reuse.

## Tasks

### 1. Create a pod

```bash
podman pod create --name kube-demo -p 8085:8080
```

### 2. Run a container inside the pod

```bash
podman run -d \
  --name kube-web \
  --pod kube-demo \
  registry.access.redhat.com/ubi9/httpd-24
```

### 3. Generate Kubernetes YAML

```bash
podman generate kube kube-demo > kube-demo.yaml
```

### 4. View the YAML file

```bash
cat kube-demo.yaml
```

### 5. Stop and remove the pod

```bash
podman pod stop kube-demo
podman pod rm kube-demo
```

### 6. Recreate the pod from YAML

```bash
podman kube play kube-demo.yaml
```

### 7. Verify the pod and application

```bash
podman pod ps
podman ps -a --pod
curl http://localhost:8085
```

### 8. Clean up

```bash
podman kube down kube-demo.yaml
rm -f kube-demo.yaml
```

## Commands Practiced

```bash
podman generate kube
podman kube play
podman kube down
```

## Expected Output

The pod should be recreated from the generated YAML file.

## Validation

```bash
podman pod ps
curl http://localhost:8085
```

## Questions for Students

1. What is Kubernetes YAML?
2. Why would you generate Kubernetes YAML from Podman?
3. What does `podman kube play` do?
4. What does `podman kube down` do?

## Cleanup

```bash
podman kube down kube-demo.yaml 2>/dev/null || true
rm -f kube-demo.yaml
```
