# Red Hat EX188 / DO188 Podman Practice Labs

This repository contains instructor-style Podman practice tasks for students preparing for Red Hat EX188 or DO188 container training.

## Lab Structure

Each task is provided as a separate Markdown file.

| No. | Lab |
|---:|---|
| 01 | [Task 01: Install Podman and Verify the Environment](01-install-podman.md) |
| 02 | [Task 02: Run Your First Container](02-run-first-container.md) |
| 03 | [Task 03: Container Lifecycle Management](03-container-lifecycle.md) |
| 04 | [Task 04: Search, Pull, Tag, and Remove Images](04-manage-images.md) |
| 05 | [Task 05: Run a Web Server Container with Port Mapping](05-run-web-server-port-mapping.md) |
| 06 | [Task 06: Bind Mount a Website Directory](06-bind-mount-website.md) |
| 07 | [Task 07: Use Named Volumes for Persistent Data](07-named-volumes.md) |
| 08 | [Task 08: Environment Variables in Containers](08-environment-variables.md) |
| 09 | [Task 09: Execute Commands Inside a Running Container](09-exec-and-top.md) |
| 10 | [Task 10: Build a Custom Image with Containerfile](10-build-custom-image.md) |
| 11 | [Task 11: Inspect Filesystem Changes and Commit an Image](11-diff-and-commit.md) |
| 12 | [Task 12: Save, Load, Export, and Import](12-save-load-export-import.md) |
| 13 | [Task 13: Logs, Events, Stats, and Troubleshooting](13-logs-events-stats-troubleshooting.md) |
| 14 | [Task 14: Create and Manage Pods](14-create-and-manage-pods.md) |
| 15 | [Task 15: Create a Custom Network](15-custom-network.md) |
| 16 | [Task 16: Manage Secrets with Podman](16-podman-secrets.md) |
| 17 | [Task 17: Generate Kubernetes YAML from a Pod](17-generate-kubernetes-yaml.md) |
| 18 | [Task 18: Run a Container as a Systemd User Service](18-systemd-user-service.md) |
| 19 | [Task 19: Pause, Unpause, Kill, and Wait](19-pause-unpause-kill-wait.md) |
| 20 | [Task 20: Final Assessment Lab - Student Portal Application](20-final-assessment-student-portal.md) |

## Additional Reference

| File | Description |
|---|---|
| [21-podman-command-reference.md](21-podman-command-reference.md) | Podman command checklist for students |

## Recommended Order

Complete the labs in numerical order.

## Target Audience

- Red Hat DO188 students
- Red Hat EX188 exam candidates
- Linux administrators learning Podman
- DevOps beginners learning containers

## Lab Requirements

- RHEL 9, CentOS Stream 9, Fedora, or compatible Linux system
- Podman installed
- Internet access to pull container images
- Normal user account with sudo access

## Instructor Notes

These labs are designed to help students practice:

- Installing Podman
- Running containers
- Managing images
- Building images with Containerfile
- Using bind mounts and named volumes
- Managing container logs and events
- Creating pods
- Using custom networks
- Using secrets
- Generating Kubernetes YAML
- Running containers as systemd user services
- Completing a final assessment lab

## Cleanup

Each lab contains its own cleanup section. Students should run cleanup only after validation or instructor verification.
