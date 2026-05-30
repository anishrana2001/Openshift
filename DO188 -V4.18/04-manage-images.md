# Task 04: Search, Pull, Tag, and Remove Images

## Objective

Learn how to search, pull, inspect, tag, and remove container images.

## Scenario

Your team needs to use a Red Hat UBI image as a base image. You must download it, inspect it, tag it, and clean it up.

## Tasks

### 1. Search for UBI images

```bash
podman search ubi9
```

### 2. Pull a UBI image

```bash
podman pull registry.access.redhat.com/ubi9/ubi
```

### 3. List local images

```bash
podman images
```

### 4. Inspect the image

```bash
podman inspect registry.access.redhat.com/ubi9/ubi
```

### 5. Tag the image

```bash
podman tag registry.access.redhat.com/ubi9/ubi localhost/myubi:v1
```

### 6. Confirm the new tag

```bash
podman images
```

### 7. Remove the custom tag

```bash
podman rmi localhost/myubi:v1
```

## Commands Practiced

```bash
podman search
podman pull
podman images
podman inspect
podman tag
podman rmi
```

## Expected Output

- The UBI image should appear in the local image list.
- The custom tag `localhost/myubi:v1` should appear after tagging.
- The custom tag should disappear after removal.

## Validation

```bash
podman images
```

## Questions for Students

1. What is a container image?
2. What is the difference between an image and a container?
3. Why do we tag images?
4. What is the purpose of `localhost/` in an image name?

## Cleanup

```bash
podman rmi localhost/myubi:v1 2>/dev/null || true
```
