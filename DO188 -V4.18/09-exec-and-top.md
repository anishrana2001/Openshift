# Task 09: Execute Commands Inside a Running Container

## Objective

Use `podman exec` and `podman top` to troubleshoot a running container.

## Scenario

A running container must be checked without stopping the application.

## Tasks

### 1. Start a long-running container

```bash
podman run -d \
  --name exec-demo \
  registry.access.redhat.com/ubi9/ubi \
  sleep 500
```

### 2. Execute commands inside it

```bash
podman exec exec-demo hostname
podman exec exec-demo cat /etc/os-release
```

### 3. Open an interactive shell

```bash
podman exec -it exec-demo /bin/bash
```

Inside the container, run:

```bash
pwd
ls /
exit
```

### 4. Display running processes

```bash
podman top exec-demo
```

### 5. Clean up

```bash
podman stop exec-demo
podman rm exec-demo
```

## Commands Practiced

```bash
podman exec
podman top
podman stop
podman rm
```

## Expected Output

- `podman exec` should run commands inside the active container.
- `podman top` should show the running `sleep` process.

## Validation

```bash
podman top exec-demo
```

## Questions for Students

1. What is the purpose of `podman exec`?
2. How is `podman exec` different from starting a new container?
3. Why is `podman top` useful?
4. What happens if you run `podman exec` against a stopped container?

## Cleanup

```bash
podman rm -f exec-demo 2>/dev/null || true
```
