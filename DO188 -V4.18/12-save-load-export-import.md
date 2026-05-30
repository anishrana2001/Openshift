# Task 12: Save, Load, Export, and Import

## Objective

Learn the difference between saving images and exporting container filesystems.

## Scenario

You must back up an image and also export a container filesystem for transfer.

## Tasks

### 1. Pull an image

```bash
podman pull registry.access.redhat.com/ubi9/ubi
```

### 2. Save the image to a tar file

```bash
podman save -o ubi9-image.tar registry.access.redhat.com/ubi9/ubi
```

### 3. Remove the image

```bash
podman rmi registry.access.redhat.com/ubi9/ubi
```

### 4. Load the image again

```bash
podman load -i ubi9-image.tar
```

### 5. Create a container

```bash
podman create --name export-demo registry.access.redhat.com/ubi9/ubi
```

### 6. Export the container filesystem

```bash
podman export export-demo -o export-demo.tar
```

### 7. Import it as a new image

```bash
podman import export-demo.tar localhost/imported-ubi:v1
```

### 8. Run the imported image

```bash
podman run --rm localhost/imported-ubi:v1 cat /etc/os-release
```

### 9. Clean up

```bash
podman rm export-demo
podman rmi localhost/imported-ubi:v1
rm -f ubi9-image.tar export-demo.tar
```

## Commands Practiced

```bash
podman save
podman load
podman export
podman import
```

## Expected Output

- The image should be restored using `podman load`.
- The exported filesystem should be imported as a new image.

## Validation

```bash
podman images
```

## Questions for Students

1. What is the difference between `podman save` and `podman export`?
2. What is the difference between `podman load` and `podman import`?
3. Which command preserves image metadata?
4. Which command works with container filesystems?

## Cleanup

```bash
podman rm -f export-demo 2>/dev/null || true
podman rmi localhost/imported-ubi:v1 2>/dev/null || true
rm -f ubi9-image.tar export-demo.tar
```
