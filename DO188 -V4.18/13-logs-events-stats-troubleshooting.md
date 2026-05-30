# Task 13: Logs, Events, Stats, and Troubleshooting

## Objective

Use Podman troubleshooting commands to investigate containers.

## Scenario

You are responsible for checking a running web container and diagnosing a failed container.

## Tasks

### 1. Run a working web container

```bash
podman run -d \
  --name troubleshoot-web \
  -p 8083:8080 \
  registry.access.redhat.com/ubi9/httpd-24
```

### 2. View logs

```bash
podman logs troubleshoot-web
```

### 3. View resource usage

```bash
podman stats --no-stream troubleshoot-web
```

### 4. Inspect port mapping

```bash
podman port troubleshoot-web
```

### 5. Inspect container configuration

```bash
podman inspect troubleshoot-web
```

### 6. Create a failed container

```bash
podman run --name failed-demo registry.access.redhat.com/ubi9/ubi wrong-command
```

### 7. Check status and logs

```bash
podman ps -a
podman logs failed-demo
podman inspect failed-demo
```

### 8. View recent Podman events

```bash
podman events --since 10m
```

Press `Ctrl+C` to exit the event stream if needed.

### 9. Clean up

```bash
podman rm failed-demo
podman stop troubleshoot-web
podman rm troubleshoot-web
```

## Commands Practiced

```bash
podman logs
podman stats
podman port
podman inspect
podman events
```

## Expected Output

- Logs should show web server activity.
- Failed container should show an error state or command failure.
- Events should show recent Podman actions.

## Validation

```bash
podman ps -a
```

## Questions for Students

1. Which command shows container logs?
2. Which command shows CPU and memory usage?
3. How can you check port mappings?
4. Why did `failed-demo` fail?

## Cleanup

```bash
podman rm -f failed-demo troubleshoot-web 2>/dev/null || true
```
