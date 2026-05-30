# Task 19: Pause, Unpause, Kill, and Wait

## Objective

Practice additional container process-control commands.

## Scenario

You need to control a long-running container process using pause, unpause, kill, and wait operations.

## Tasks

### 1. Run a long-running container

```bash
podman run -d \
  --name control-demo \
  registry.access.redhat.com/ubi9/ubi \
  sleep 1000
```

### 2. Pause the container

```bash
podman pause control-demo
```

### 3. Check status

```bash
podman ps -a
```

### 4. Unpause the container

```bash
podman unpause control-demo
```

### 5. Kill the container

```bash
podman kill control-demo
```

### 6. Wait for the container to exit

```bash
podman wait control-demo
```

### 7. Remove the container

```bash
podman rm control-demo
```

## Commands Practiced

```bash
podman pause
podman unpause
podman kill
podman wait
```

## Expected Output

- The container should show a paused state after `podman pause`.
- The container should exit after `podman kill`.
- `podman wait` should return an exit code.

## Validation

```bash
podman ps -a
```

## Questions for Students

1. What does `podman pause` do?
2. How is `podman kill` different from `podman stop`?
3. What does `podman wait` return?
4. When would you use these commands in troubleshooting?

## Cleanup

```bash
podman rm -f control-demo 2>/dev/null || true
```
