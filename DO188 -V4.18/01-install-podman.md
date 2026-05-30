# Task 01: Install Podman and Verify the Environment

## Objective

Learn what Podman is, install it on a Red Hat-based system, and verify that the container environment is ready.

## Scenario

You are preparing a fresh Linux machine for container practice. Before running containers, you must install Podman and confirm that it works correctly.

## Requirements

- Use RHEL 9, CentOS Stream 9, Fedora, or another Red Hat-based system.
- Use a normal user account such as `student`.
- Do not run all commands as root unless specifically required.

## Tasks

### 1. Install Podman

Install the complete container tools package:

```bash
sudo dnf install -y container-tools
```

If your system does not provide `container-tools`, install Podman directly:

```bash
sudo dnf install -y podman
```

### 2. Check the Podman version

```bash
podman version
```

### 3. Display Podman system information

```bash
podman info
```

### 4. Check Podman help pages

```bash
podman --help
podman run --help
podman image --help
podman container --help
```

### 5. Confirm rootless mode

```bash
podman info | grep -i rootless
```

## Expected Output

You should see:

- Podman version information
- Host and storage information
- Registry configuration
- Rootless status

## Validation

Run:

```bash
podman version
podman info
```

## Questions for Students

1. What is the difference between Podman and Docker?
2. Why is rootless container execution useful?
3. What is the purpose of the `container-tools` package?
4. Which command shows detailed Podman system information?

## Cleanup

No cleanup is required for this task.
