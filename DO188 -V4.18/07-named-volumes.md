# Task 07: Use Named Volumes for Persistent Data

## Objective

Use Podman named volumes to persist data beyond the container lifecycle.

## Scenario

An application needs to store data even after the container is deleted.

## Tasks

### 1. Create a named volume

```bash
podman volume create appdata
```

### 2. Inspect the volume

```bash
podman volume inspect appdata
```

### 3. Write data to the volume

```bash
podman run --rm \
  -v appdata:/data \
  registry.access.redhat.com/ubi9/ubi \
  bash -c 'echo "Persistent data from Podman volume" > /data/message.txt'
```

### 4. Read the same data from another container

```bash
podman run --rm \
  -v appdata:/data \
  registry.access.redhat.com/ubi9/ubi \
  cat /data/message.txt
```

### 5. List volumes

```bash
podman volume ls
```

### 6. Remove the volume

```bash
podman volume rm appdata
```

## Commands Practiced

```bash
podman volume create
podman volume ls
podman volume inspect
podman volume rm
```

## Expected Output

The second container should display:

```text
Persistent data from Podman volume
```

## Validation

```bash
podman volume ls
```

## Questions for Students

1. What is a named volume?
2. Why is persistent storage important?
3. What happens to volume data when a container is removed?
4. When should you use a named volume instead of a bind mount?

## Cleanup

```bash
podman volume rm appdata 2>/dev/null || true
```
