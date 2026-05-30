# Task 03: Container Lifecycle Management

## Objective

Learn how to create, start, stop, restart, inspect, and remove containers.

## Scenario

A container has to be created first and started later. You must manage its full lifecycle using Podman commands.

## Tasks

### 1. Create a container without starting it

```bash
podman create --name lifecycle-demo registry.access.redhat.com/ubi9/ubi sleep 500
```

### 2. List all containers

```bash
podman ps -a
```

### 3. Start the container

```bash
podman start lifecycle-demo
```

### 4. List running containers

```bash
podman ps
```

### 5. Restart the container

```bash
podman restart lifecycle-demo
```

### 6. Inspect the container

```bash
podman inspect lifecycle-demo
```

### 7. Stop the container

```bash
podman stop lifecycle-demo
```

### 8. Remove the container

```bash
podman rm lifecycle-demo
```

## Commands Practiced

```bash
podman create
podman start
podman ps
podman restart
podman inspect
podman stop
podman rm
```

## Expected Output

- `podman ps -a` should show the created container.
- `podman ps` should show the running container after start.
- `podman inspect` should return JSON output.

## Validation

```bash
podman ps -a
```

There should be no container named `lifecycle-demo`.

## Questions for Students

1. What is the difference between `podman create` and `podman run`?
2. Which command shows only running containers?
3. Which command shows stopped containers also?
4. What type of output does `podman inspect` provide?

## Cleanup

```bash
podman rm -f lifecycle-demo 2>/dev/null || true
```
