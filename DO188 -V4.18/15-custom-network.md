# Task 15: Create a Custom Network

## Objective

Create a custom Podman network and attach containers to it.

## Scenario

Two containers need to run on the same user-defined network.

## Tasks

### 1. Create a network

```bash
podman network create app-net
```

### 2. List networks

```bash
podman network ls
```

### 3. Inspect the network

```bash
podman network inspect app-net
```

### 4. Run the first container on the custom network

```bash
podman run -d \
  --name net-demo1 \
  --network app-net \
  registry.access.redhat.com/ubi9/ubi \
  sleep 500
```

### 5. Run the second container on the same network

```bash
podman run -d \
  --name net-demo2 \
  --network app-net \
  registry.access.redhat.com/ubi9/ubi \
  sleep 500
```

### 6. Inspect both containers and compare IP addresses

```bash
podman inspect net-demo1 | grep -i ipaddress
podman inspect net-demo2 | grep -i ipaddress
```

### 7. Clean up

```bash
podman stop net-demo1 net-demo2
podman rm net-demo1 net-demo2
podman network rm app-net
```

## Commands Practiced

```bash
podman network create
podman network ls
podman network inspect
podman network rm
```

## Expected Output

Both containers should be connected to the custom network.

## Validation

```bash
podman network inspect app-net
```

## Questions for Students

1. What is the purpose of a custom network?
2. How can you list Podman networks?
3. How can you attach a container to a specific network?
4. Why is container networking important in multi-container applications?

## Cleanup

```bash
podman rm -f net-demo1 net-demo2 2>/dev/null || true
podman network rm app-net 2>/dev/null || true
```
