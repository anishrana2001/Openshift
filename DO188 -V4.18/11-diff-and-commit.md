# Task 11: Inspect Filesystem Changes and Commit an Image

## Objective

Understand container filesystem changes and create an image from a modified container.

## Scenario

A running container was manually changed. You must inspect the changes and save them as a new image.

## Tasks

### 1. Run a container interactively

```bash
podman run -it --name commit-demo registry.access.redhat.com/ubi9/ubi /bin/bash
```

### 2. Create a file inside the container

Inside the container, run:

```bash
echo "Created inside container" > /root/container-note.txt
exit
```

### 3. Check filesystem differences

```bash
podman diff commit-demo
```

### 4. Commit the changed container as a new image

```bash
podman commit commit-demo localhost/ubi-note:v1
```

### 5. Run the new image and verify the file

```bash
podman run --rm localhost/ubi-note:v1 cat /root/container-note.txt
```

### 6. Clean up

```bash
podman rm commit-demo
podman rmi localhost/ubi-note:v1
```

## Commands Practiced

```bash
podman diff
podman commit
podman run
podman rmi
```

## Expected Output

The new image should contain `/root/container-note.txt`.

## Validation

```bash
podman run --rm localhost/ubi-note:v1 cat /root/container-note.txt
```

## Questions for Students

1. What does `podman diff` show?
2. What does `podman commit` do?
3. Is `podman commit` better than using a Containerfile?
4. Why are Containerfiles preferred for repeatable builds?

## Cleanup

```bash
podman rm -f commit-demo 2>/dev/null || true
podman rmi localhost/ubi-note:v1 2>/dev/null || true
```
