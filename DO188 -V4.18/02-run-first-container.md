# Task 02: Run Your First Container

## Objective

Run your first container using Podman and understand basic container execution.

## Scenario

You need to verify that your Podman installation can download and run a Red Hat Universal Base Image container.

## Tasks

### 1. Run a temporary UBI container

```bash
podman run --rm registry.access.redhat.com/ubi9/ubi cat /etc/os-release
```

### 2. Run an interactive container

```bash
podman run -it --name first-ubi registry.access.redhat.com/ubi9/ubi /bin/bash
```

### 3. Run commands inside the container

Inside the container, run:

```bash
cat /etc/os-release
whoami
hostname
exit
```

### 4. List all containers

```bash
podman ps -a
```

### 5. Remove the stopped container

```bash
podman rm first-ubi
```

## Commands Practiced

```bash
podman run
podman ps
podman rm
```

## Expected Output

- The container should show UBI 9 operating system details.
- `whoami` should return the user running inside the container.
- `podman ps -a` should show the stopped container before removal.

## Validation

```bash
podman ps -a
```

There should be no container named `first-ubi`.

## Questions for Students

1. What does the `--rm` option do?
2. What is the difference between `podman run` and `podman create`?
3. Why do we use `-it` for interactive containers?
4. What happens when you type `exit` inside a container shell?

## Cleanup

```bash
podman rm -f first-ubi 2>/dev/null || true
```
