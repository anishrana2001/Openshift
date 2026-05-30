# Task 14: Create and Manage Pods

## Objective

Create a Podman pod and run multiple containers inside it.

## Scenario

You need to run related containers together inside a single pod.

## Tasks

### 1. Create a pod with port mapping

```bash
podman pod create --name webpod -p 8084:8080
```

### 2. List pods

```bash
podman pod ps
```

### 3. Run a web container inside the pod

```bash
podman run -d \
  --name pod-web \
  --pod webpod \
  registry.access.redhat.com/ubi9/httpd-24
```

### 4. Run a support container inside the same pod

```bash
podman run -d \
  --name pod-helper \
  --pod webpod \
  registry.access.redhat.com/ubi9/ubi \
  sleep 500
```

### 5. List containers with pod information

```bash
podman ps -a --pod
```

### 6. Inspect the pod

```bash
podman pod inspect webpod
```

### 7. Display pod processes

```bash
podman pod top webpod
```

### 8. Test the web service

```bash
curl http://localhost:8084
```

### 9. Stop and remove the pod

```bash
podman pod stop webpod
podman pod rm webpod
```

## Commands Practiced

```bash
podman pod create
podman pod ps
podman pod inspect
podman pod top
podman pod stop
podman pod rm
podman ps --pod
```

## Expected Output

- The pod should contain both containers.
- The web service should be accessible on host port `8084`.

## Validation

```bash
podman pod ps
podman ps -a --pod
```

## Questions for Students

1. What is a pod?
2. Why are pods useful?
3. How do containers inside a pod share networking?
4. What is the infra container?

## Cleanup

```bash
podman pod rm -f webpod 2>/dev/null || true
```
