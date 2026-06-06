# PODMAN in Red Hat Enterprise Linux — Instructor Guide

> **Audience:** Linux administrators, DevOps beginners, Red Hat learners, RHCSA/RHCE-style practice students  
> **Platform:** Red Hat Enterprise Linux 8/9/10 style systems  
> **Goal:** Learn how to install, run, manage, troubleshoot, and automate containers using **Podman** on Red Hat.

---

## Table of Contents

1. [Learning Objectives](#learning-objectives)
2. [What is Podman?](#what-is-podman)
3. [Podman vs Docker: Instructor Notes](#podman-vs-docker-instructor-notes)
4. [Important Red Hat Container Tools](#important-red-hat-container-tools)
5. [Installation on RHEL](#installation-on-rhel)
6. [Rootless vs Rootful Podman](#rootless-vs-rootful-podman)
7. [Podman Command Structure](#podman-command-structure)
8. [Help, Version, and System Information](#help-version-and-system-information)
9. [Working with Container Images](#working-with-container-images)
10. [Running Containers](#running-containers)
11. [Managing Running and Stopped Containers](#managing-running-and-stopped-containers)
12. [Inspecting, Monitoring, and Debugging Containers](#inspecting-monitoring-and-debugging-containers)
13. [Copying Files To and From Containers](#copying-files-to-and-from-containers)
14. [Container Logs](#container-logs)
15. [Environment Variables](#environment-variables)
16. [Port Publishing](#port-publishing)
17. [Volumes, Bind Mounts, and Persistent Data](#volumes-bind-mounts-and-persistent-data)
18. [SELinux Notes for Volumes](#selinux-notes-for-volumes)
19. [Networking with Podman](#networking-with-podman)
20. [Pods in Podman](#pods-in-podman)
21. [Building Images with Containerfile](#building-images-with-containerfile)
22. [Registries, Login, Tagging, and Pushing](#registries-login-tagging-and-pushing)
23. [Saving, Loading, Importing, and Exporting Images](#saving-loading-importing-and-exporting-images)
24. [System Cleanup Commands](#system-cleanup-commands)
25. [Systemd Integration and Quadlet](#systemd-integration-and-quadlet)
26. [Kubernetes YAML with Podman](#kubernetes-yaml-with-podman)
27. [Podman API and Docker Compatibility](#podman-api-and-docker-compatibility)
28. [Useful Configuration Files](#useful-configuration-files)
29. [Troubleshooting Commands](#troubleshooting-commands)
30. [Practice Labs](#practice-labs)
31. [Command Cheat Sheet](#command-cheat-sheet)

---

## Learning Objectives

By the end of this lesson, students should be able to:

- Explain what Podman is and why it is commonly used on Red Hat systems.
- Install Podman and related container tools on RHEL.
- Run containers in rootless and rootful mode.
- Pull, list, inspect, tag, remove, save, and push images.
- Create, start, stop, restart, inspect, log, and remove containers.
- Use volumes and bind mounts for persistent data.
- Create Podman networks and connect containers to them.
- Create and manage pods.
- Build images using `Containerfile`.
- Configure containers to run under `systemd` using Quadlet.
- Troubleshoot common Podman problems.

---

## What is Podman?

**Podman** stands for **Pod Manager**. It is an open source, daemonless container engine used to develop, run, and manage containers and pods.

Key points:

- Podman can run **OCI-compliant containers** (Open Container Initiative (OCI), a Linux Foundation project).
- Podman is **daemonless**, meaning there is no always-running central daemon like Docker Engine.
- Podman supports **rootless containers**, allowing normal users to run containers without becoming `root`.
- Podman can manage:
  - Images
  - Containers
  - Pods
  - Volumes
  - Networks
  - Kubernetes-style YAML workloads
  - Systemd-managed container services

---

## Podman vs Docker: Instructor Notes

| Feature | Podman | Docker |
|---|---|---|
| Daemon | No central daemon | Uses Docker daemon |
| Rootless support | Strong native support | Available, but Docker daemon model differs |
| Pods | Native pod support | Not native in the same Kubernetes-like way |
| Systemd integration | Strong integration | Usually requires service wrapping |
| CLI compatibility | Similar to Docker CLI | Docker CLI |
| Red Hat default direction | Preferred tool on RHEL | Not the default container engine on RHEL |

Instructor explanation:

Podman commands are intentionally similar to Docker commands. For example:

```bash
podman run nginx
podman ps
podman images
podman stop web
```

Many Docker users can replace `docker` with `podman` for common tasks.

---

## Important Red Hat Container Tools

Red Hat container workflow commonly uses the following tools:

| Tool | Purpose |
|---|---|
| `podman` | Run and manage containers, pods, images, volumes, and networks |
| `buildah` | Build container images, especially in scriptable workflows |
| `skopeo` | Inspect, copy, sync, and manage images in remote registries without always pulling them locally |
| `crun` / `runc` | OCI container runtimes used underneath container engines |
| `podman-docker` | Optional compatibility package that lets many `docker` commands call Podman |

---

## Installation on RHEL

### 1. Register the RHEL system

```bash
sudo subscription-manager register
```

**Explanation:** Registers the RHEL system with Red Hat subscription services.

```bash
sudo subscription-manager attach --auto
```

**Explanation:** Automatically attaches an available subscription.

### 2. Install container tools

```bash
sudo dnf install -y container-tools
```

**Explanation:** Installs the Red Hat container tools package group/metapackage, including Podman and related utilities.

### 3. Install only Podman if needed

```bash
sudo dnf install -y podman
```

**Explanation:** Installs only Podman without the broader container toolset.

### 4. Install Buildah and Skopeo individually

```bash
sudo dnf install -y buildah skopeo
```

**Explanation:** Installs image building and image inspection/copying tools.

### 5. Optional Docker-compatible command package

```bash
sudo dnf install -y podman-docker
```

**Explanation:** Provides Docker-compatible command behavior by redirecting many `docker` CLI operations to Podman.

### 6. Verify installation

```bash
podman --version
```

**Explanation:** Displays installed Podman version.

```bash
podman info
```

**Explanation:** Shows host, storage, registry, runtime, rootless/rootful, and system configuration details.

---

## Rootless vs Rootful Podman

### Rootless mode

Rootless mode means the container is run by a normal Linux user.

```bash
podman run --rm registry.access.redhat.com/ubi9/ubi cat /etc/os-release
```

**Explanation:** Runs a temporary UBI container as the current user and prints OS information.

### Rootful mode

Rootful mode means commands are run as `root` or with `sudo`.

```bash
sudo podman run --rm registry.access.redhat.com/ubi9/ubi cat /etc/os-release
```

**Explanation:** Runs the container using root-owned container storage and root privileges.

### Check whether Podman is rootless

```bash
podman info --format '{{.Host.Security.Rootless}}'
```

**Explanation:** Prints `true` if Podman is running rootless.

### Check subordinate UID/GID mapping

```bash
cat /etc/subuid
cat /etc/subgid
```

**Explanation:** Rootless containers use subordinate user and group ID ranges to map container users to host users safely.

### Apply changes after editing subuid/subgid

```bash
podman system migrate
```

**Explanation:** Migrates Podman storage and configuration after changes such as `/etc/subuid` or `/etc/subgid` updates.

### Instructor warning

Avoid using `su` or `su -` for rootless Podman practice because the environment may not be set correctly. Prefer direct login, SSH login, or a proper user session.

---

## Podman Command Structure

General format:

```bash
podman [global-options] <command> [command-options] [arguments]
```

Example:

```bash
podman run -d --name web -p 8080:80 nginx
```

Breakdown:

| Part | Meaning |
|---|---|
| `podman` | Main command |
| `run` | Subcommand to create and start a container |
| `-d` | Run in detached/background mode |
| `--name web` | Name the container `web` |
| `-p 8080:80` | Map host port 8080 to container port 80 |
| `nginx` | Image name |

---

## Help, Version, and System Information

```bash
podman --help
```

**Explanation:** Shows Podman command help.

```bash
podman run --help
```

**Explanation:** Shows help for the `run` subcommand.

```bash
man podman
```

**Explanation:** Opens the Podman manual page.

```bash
man podman-run
```

**Explanation:** Opens the manual page for `podman run`.

```bash
podman version
```

**Explanation:** Shows client and server/API version details.

```bash
podman info
```

**Explanation:** Shows detailed host, runtime, storage, registry, and security information.

```bash
podman system df
```

**Explanation:** Displays disk usage by images, containers, and volumes.

---

## Working with Container Images

### Search for images

```bash
podman search nginx
```

**Explanation:** Searches configured container registries for images matching `nginx`.

```bash
podman search registry.access.redhat.com/ubi
```

**Explanation:** Searches for Red Hat UBI-related images.

### Pull an image

```bash
podman pull registry.access.redhat.com/ubi9/ubi
```

**Explanation:** Downloads the UBI 9 image to local storage.

```bash
podman pull docker.io/library/nginx:latest
```

**Explanation:** Pulls the latest NGINX image from Docker Hub.

### List local images

```bash
podman images
```

**Explanation:** Lists locally available images.

```bash
podman image ls
```

**Explanation:** Alternative form of `podman images`.

### Inspect an image

```bash
podman image inspect registry.access.redhat.com/ubi9/ubi
```

**Explanation:** Displays detailed JSON metadata about an image.

### Show image history

```bash
podman history registry.access.redhat.com/ubi9/ubi
```

**Explanation:** Shows image layers and build history.

### Tag an image

```bash
podman tag registry.access.redhat.com/ubi9/ubi localhost/ubi-demo:v1
```

**Explanation:** Adds a new local name and tag to an existing image.

### Remove an image

```bash
podman rmi localhost/ubi-demo:v1
```

**Explanation:** Removes the specified image tag or image.

```bash
podman image rm nginx
```

**Explanation:** Removes an image using the `image rm` subcommand.

### Remove unused images

```bash
podman image prune
```

**Explanation:** Removes dangling or unused images.

```bash
podman image prune -a
```

**Explanation:** Removes all images not used by containers. Use carefully.

---

## Running Containers

### Run a simple command in a container

```bash
podman run --rm registry.access.redhat.com/ubi9/ubi echo "Hello from Podman"
```

**Explanation:** Runs a command and automatically removes the container after it exits.

### Run an interactive shell

```bash
podman run -it --name ubi-shell registry.access.redhat.com/ubi9/ubi /bin/bash
```

**Explanation:** Starts an interactive Bash shell inside a UBI container.

Options:

| Option | Meaning |
|---|---|
| `-i` | Keep STDIN open |
| `-t` | Allocate a pseudo-terminal |
| `--name` | Assign a container name |

Exit the shell:

```bash
exit
```

### Run in detached mode

```bash
podman run -d --name web nginx
```

**Explanation:** Starts an NGINX container in the background.

### Run with automatic removal

```bash
podman run --rm alpine date
```

**Explanation:** Runs the command and removes the container after completion.

### Run with hostname

```bash
podman run --rm --hostname mycontainer registry.access.redhat.com/ubi9/ubi hostname
```

**Explanation:** Sets the container hostname.

### Run with a custom command

```bash
podman run --rm registry.access.redhat.com/ubi9/ubi uname -r
```

**Explanation:** Runs `uname -r` inside the container.

### Run with a restart policy

```bash
podman run -d --name web --restart=always -p 8080:80 nginx
```

**Explanation:** Configures the container to restart automatically. For production services on RHEL, prefer systemd/Quadlet for reliable lifecycle management.

---

## Managing Running and Stopped Containers

### List running containers

```bash
podman ps
```

**Explanation:** Shows only running containers.

### List all containers

```bash
podman ps -a
```

**Explanation:** Shows running, stopped, created, and exited containers.

### Start a stopped container

```bash
podman start web
```

**Explanation:** Starts an existing stopped container.

### Stop a running container

```bash
podman stop web
```

**Explanation:** Gracefully stops a running container.

### Stop with timeout

```bash
podman stop -t 5 web
```

**Explanation:** Gives the container 5 seconds to stop before forcing termination.

### Restart a container

```bash
podman restart web
```

**Explanation:** Stops and starts the container.

### Kill a container

```bash
podman kill web
```

**Explanation:** Forcefully terminates the container.

### Pause and unpause a container

```bash
podman pause web
podman unpause web
```

**Explanation:** Suspends and resumes container processes.

### Remove a stopped container

```bash
podman rm web
```

**Explanation:** Removes a stopped container.

### Force remove a running container

```bash
podman rm -f web
```

**Explanation:** Stops and removes a running container. Use carefully.

### Remove all stopped containers

```bash
podman container prune
```

**Explanation:** Deletes stopped containers.

### Create but do not start

```bash
podman create --name test registry.access.redhat.com/ubi9/ubi sleep 1000
```

**Explanation:** Creates a container without starting it.

---

## Inspecting, Monitoring, and Debugging Containers

### Inspect a container

```bash
podman inspect web
```

**Explanation:** Shows detailed JSON information about the container.

### Format inspect output

```bash
podman inspect web --format '{{.State.Status}}'
```

**Explanation:** Prints only the container status.

```bash
podman inspect web --format '{{.NetworkSettings.Ports}}'
```

**Explanation:** Displays port mapping information.

### Show running processes inside a container

```bash
podman top web
```

**Explanation:** Lists processes running inside the container.

### Show live resource usage

```bash
podman stats
```

**Explanation:** Shows CPU, memory, network, and block I/O statistics.

```bash
podman stats web
```

**Explanation:** Shows resource usage for one container.

### Execute a command inside a running container

```bash
podman exec web hostname
```

**Explanation:** Runs `hostname` inside the running container.

```bash
podman exec -it web /bin/bash
```

**Explanation:** Opens an interactive shell inside the running container if Bash exists.

```bash
podman exec -it web /bin/sh
```

**Explanation:** Opens a POSIX shell if Bash is unavailable.

### Attach to a container

```bash
podman attach web
```

**Explanation:** Attaches your terminal to the main process of the container.

### View changed files

```bash
podman diff web
```

**Explanation:** Shows filesystem changes made inside the container.

### Wait for a container to exit

```bash
podman wait web
```

**Explanation:** Waits until the container stops and prints its exit code.

---

## Copying Files To and From Containers

### Copy file from host to container

```bash
podman cp index.html web:/usr/share/nginx/html/index.html
```

**Explanation:** Copies `index.html` from the host into the container.

### Copy file from container to host

```bash
podman cp web:/etc/nginx/nginx.conf ./nginx.conf
```

**Explanation:** Copies a file from the container to the current host directory.

### Copy a directory

```bash
podman cp ./site web:/usr/share/nginx/html/
```

**Explanation:** Copies the local `site` directory into the container.

---

## Container Logs

```bash
podman logs web
```

**Explanation:** Shows logs from the container.

```bash
podman logs -f web
```

**Explanation:** Follows container logs in real time.

```bash
podman logs --tail 50 web
```

**Explanation:** Shows the last 50 log lines.

```bash
podman logs --since 10m web
```

**Explanation:** Shows logs from the last 10 minutes.

---

## Environment Variables

### Pass one variable

```bash
podman run --rm -e APP_ENV=dev registry.access.redhat.com/ubi9/ubi env
```

**Explanation:** Sets `APP_ENV=dev` inside the container.

### Pass multiple variables

```bash
podman run --rm \
  -e APP_ENV=prod \
  -e APP_PORT=8080 \
  registry.access.redhat.com/ubi9/ubi env
```

**Explanation:** Sets multiple environment variables.

### Use an environment file

Create `app.env`:

```bash
APP_ENV=prod
APP_PORT=8080
```

Run:

```bash
podman run --rm --env-file app.env registry.access.redhat.com/ubi9/ubi env
```

**Explanation:** Loads environment variables from a file.

---

## Port Publishing

### Publish a container port

```bash
podman run -d --name web -p 8080:80 nginx
```

**Explanation:** Maps host port `8080` to container port `80`.

Test:

```bash
curl http://localhost:8080
```

### Publish on a specific host IP

```bash
podman run -d --name web -p 127.0.0.1:8080:80 nginx
```

**Explanation:** Makes the service reachable only from localhost.

### Publish random host port

```bash
podman run -d --name web -p 80 nginx
```

**Explanation:** Maps container port 80 to a random host port.

Check mapping:

```bash
podman port web
```

**Explanation:** Displays host-to-container port mappings.

---

## Volumes, Bind Mounts, and Persistent Data

Containers are disposable. Use volumes or bind mounts for persistent data.

### Create a named volume

```bash
podman volume create webdata
```

**Explanation:** Creates a Podman-managed volume named `webdata`.

### List volumes

```bash
podman volume ls
```

**Explanation:** Lists Podman volumes.

### Inspect a volume

```bash
podman volume inspect webdata
```

**Explanation:** Shows volume location and metadata.

### Use a named volume

```bash
podman run -d --name web \
  -p 8080:80 \
  -v webdata:/usr/share/nginx/html \
  nginx
```

**Explanation:** Mounts the named volume into the container.

### Use a bind mount

```bash
mkdir -p ~/webcontent
echo "Hello from bind mount" > ~/webcontent/index.html

podman run -d --name web \
  -p 8080:80 \
  -v ~/webcontent:/usr/share/nginx/html:Z \
  nginx
```

**Explanation:** Mounts a host directory into the container. The `:Z` option adjusts SELinux labeling for private container use.

### Read-only mount

```bash
podman run --rm \
  -v ~/webcontent:/content:ro,Z \
  registry.access.redhat.com/ubi9/ubi ls -l /content
```

**Explanation:** Mounts host content as read-only.

### Remove a volume

```bash
podman volume rm webdata
```

**Explanation:** Removes a volume. The volume must not be in use.

### Remove unused volumes

```bash
podman volume prune
```

**Explanation:** Removes volumes not used by containers.

---

## SELinux Notes for Volumes

RHEL commonly uses SELinux in enforcing mode. If a container cannot read or write a bind-mounted directory, check SELinux labels.

### Private label

```bash
-v /host/path:/container/path:Z
```

**Explanation:** Relabels content for private use by one container.

### Shared label

```bash
-v /host/path:/container/path:z
```

**Explanation:** Relabels content so multiple containers can share it.

### Check SELinux mode

```bash
getenforce
```

**Explanation:** Shows whether SELinux is `Enforcing`, `Permissive`, or `Disabled`.

### View file contexts

```bash
ls -Z /host/path
```

**Explanation:** Shows SELinux context labels.

Instructor warning:

Do not disable SELinux just to fix a container issue. First check mount labels, paths, ownership, and AVC denials.

---

## Networking with Podman

### List networks

```bash
podman network ls
```

**Explanation:** Shows available Podman networks.

### Inspect a network

```bash
podman network inspect podman
```

**Explanation:** Displays network configuration.

### Create a custom network

```bash
podman network create appnet
```

**Explanation:** Creates a custom network named `appnet`.

### Run a container on a custom network

```bash
podman run -d --name web --network appnet nginx
```

**Explanation:** Connects the container to `appnet`.

### Connect an existing container to a network

```bash
podman network connect appnet web
```

**Explanation:** Adds an existing container to a network.

### Disconnect a container from a network

```bash
podman network disconnect appnet web
```

**Explanation:** Removes a container from a network.

### Remove a network

```bash
podman network rm appnet
```

**Explanation:** Deletes a custom network.

### Remove unused networks

```bash
podman network prune
```

**Explanation:** Removes unused networks.

### Common network modes

```bash
podman run --network bridge nginx
```

**Explanation:** Uses bridge-style networking.

```bash
podman run --network host nginx
```

**Explanation:** Uses the host network namespace. Use carefully because network isolation is reduced.

```bash
podman run --network none nginx
```

**Explanation:** Starts the container without network access.

---

## Pods in Podman

A **pod** is a group of one or more containers sharing selected namespaces. Podman pods are useful for learning Kubernetes-style application grouping.

### Create a pod

```bash
podman pod create --name mypod -p 8080:80
```

**Explanation:** Creates a pod and publishes host port 8080 to port 80 inside the pod.

### List pods

```bash
podman pod ps
```

**Explanation:** Shows Podman pods.

### Inspect a pod

```bash
podman pod inspect mypod
```

**Explanation:** Shows pod metadata and containers.

### Run a container inside a pod

```bash
podman run -d --name web --pod mypod nginx
```

**Explanation:** Starts an NGINX container inside `mypod`.

### List containers with pod information

```bash
podman ps -a --pod
```

**Explanation:** Shows containers and their associated pod IDs.

### Stop a pod

```bash
podman pod stop mypod
```

**Explanation:** Stops all containers in the pod.

### Start a pod

```bash
podman pod start mypod
```

**Explanation:** Starts containers in the pod.

### Restart a pod

```bash
podman pod restart mypod
```

**Explanation:** Restarts the pod.

### Remove a pod

```bash
podman pod rm mypod
```

**Explanation:** Removes a stopped pod.

### Force remove a pod

```bash
podman pod rm -f mypod
```

**Explanation:** Stops and removes the pod and its containers.

### Remove unused pods

```bash
podman pod prune
```

**Explanation:** Removes stopped pods.

---

## Building Images with Containerfile

A `Containerfile` is like a `Dockerfile`. It describes how to build an image.

### Example project

```bash
mkdir podman-web-demo
cd podman-web-demo
```

Create `index.html`:

```bash
cat > index.html <<'EOF'
<h1>Hello from Podman on Red Hat</h1>
EOF
```

Create `Containerfile`:

```bash
cat > Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi9/ubi-minimal
RUN microdnf -y install nginx && microdnf clean all
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF
```

### Build with Podman

```bash
podman build -t localhost/podman-web-demo:v1 .
```

**Explanation:** Builds an image from the current directory and tags it.

### Build with Buildah

```bash
buildah bud -t localhost/podman-web-demo:v1 .
```

**Explanation:** Builds the image using Buildah. This is common in Red Hat image-building workflows.

### Run the custom image

```bash
podman run -d --name demo-web -p 8080:80 localhost/podman-web-demo:v1
```

**Explanation:** Runs the custom web image.

### Test the application

```bash
curl http://localhost:8080
```

**Explanation:** Verifies that the containerized web server responds.

### Rebuild without cache

```bash
podman build --no-cache -t localhost/podman-web-demo:v2 .
```

**Explanation:** Rebuilds all image layers from scratch.

---

## Registries, Login, Tagging, and Pushing

### Login to a registry

```bash
podman login registry.redhat.io
```

**Explanation:** Authenticates to Red Hat registry.

```bash
podman login quay.io
```

**Explanation:** Authenticates to Quay.io.

### Logout

```bash
podman logout registry.redhat.io
```

**Explanation:** Removes stored credentials for the registry.

### Tag an image for a registry

```bash
podman tag localhost/podman-web-demo:v1 quay.io/YOUR_USER/podman-web-demo:v1
```

**Explanation:** Adds a registry-qualified tag.

### Push an image

```bash
podman push quay.io/YOUR_USER/podman-web-demo:v1
```

**Explanation:** Uploads the image to the registry.

### Inspect a remote image with Skopeo

```bash
skopeo inspect docker://registry.access.redhat.com/ubi9/ubi
```

**Explanation:** Inspects a remote image without first pulling it into local Podman storage.

### Copy an image with Skopeo

```bash
skopeo copy \
  docker://quay.io/source/image:tag \
  docker://registry.example.com/project/image:tag
```

**Explanation:** Copies an image between registries.

---

## Saving, Loading, Importing, and Exporting Images

### Save an image to a tar file

```bash
podman save -o ubi9.tar registry.access.redhat.com/ubi9/ubi
```

**Explanation:** Saves an image as a tar archive.

### Load an image from a tar file

```bash
podman load -i ubi9.tar
```

**Explanation:** Loads an image from a saved archive.

### Export a container filesystem

```bash
podman export -o web-container.tar web
```

**Explanation:** Exports a container filesystem, not the full image metadata.

### Import a filesystem as an image

```bash
podman import web-container.tar localhost/imported-web:v1
```

**Explanation:** Imports a filesystem archive as a new image.

### Instructor note

Use `save/load` for images. Use `export/import` for container filesystems.

---

## System Cleanup Commands

### Show disk usage

```bash
podman system df
```

**Explanation:** Shows container storage usage.

### Remove stopped containers

```bash
podman container prune
```

**Explanation:** Removes stopped containers.

### Remove unused images

```bash
podman image prune
```

**Explanation:** Removes unused/dangling images.

### Remove unused volumes

```bash
podman volume prune
```

**Explanation:** Removes unused volumes.

### Remove unused networks

```bash
podman network prune
```

**Explanation:** Removes unused networks.

### Remove many unused resources

```bash
podman system prune
```

**Explanation:** Removes unused containers, networks, and dangling images.

### Aggressive cleanup

```bash
podman system prune -a --volumes
```

**Explanation:** Removes unused containers, networks, images, and volumes. Use carefully because data can be deleted.

---

## Systemd Integration and Quadlet

For production-style services on RHEL, run containers under `systemd` rather than manually starting them.

Modern Podman recommends **Quadlet** files for systemd integration.

### Rootless Quadlet directory

```bash
mkdir -p ~/.config/containers/systemd
```

**Explanation:** Creates the rootless user Quadlet directory.

### Example Quadlet container file

Create `~/.config/containers/systemd/web.container`:

```ini
[Unit]
Description=Rootless NGINX container managed by Podman Quadlet

[Container]
Image=docker.io/library/nginx:latest
ContainerName=quadlet-web
PublishPort=8080:80

[Service]
Restart=always

[Install]
WantedBy=default.target
```

### Reload user systemd

```bash
systemctl --user daemon-reload
```

**Explanation:** Tells systemd to read the new Quadlet file and generate a service.

### Start the generated service

```bash
systemctl --user start web.service
```

**Explanation:** Starts the container as a user service.

### Enable at user login

```bash
systemctl --user enable web.service
```

**Explanation:** Enables the service for the user session.

### Keep user services running after logout

```bash
sudo loginctl enable-linger $USER
```

**Explanation:** Allows user services to continue after logout.

### Check status

```bash
systemctl --user status web.service
```

**Explanation:** Shows service status.

### View logs

```bash
journalctl --user -u web.service -f
```

**Explanation:** Follows logs for the user service.

### Stop and disable

```bash
systemctl --user stop web.service
systemctl --user disable web.service
```

**Explanation:** Stops and disables the service.

### Legacy/generated systemd unit method

```bash
podman generate systemd --name web --files
```

**Explanation:** Generates a systemd unit file for an existing container. This command still exists, but current Podman documentation marks it as deprecated and recommends Quadlet for new systemd-managed containers.

---

## Kubernetes YAML with Podman

Podman can generate and run Kubernetes-style YAML for local testing.

### Generate Kubernetes YAML from a container or pod

```bash
podman generate kube mypod > mypod.yaml
```

**Explanation:** Creates Kubernetes YAML based on a Podman pod or container.

### Run Kubernetes YAML locally

```bash
podman play kube mypod.yaml
```

**Explanation:** Creates containers/pods from the Kubernetes YAML file.

### Remove resources created by play kube

```bash
podman play kube --down mypod.yaml
```

**Explanation:** Tears down resources created from the YAML.

---

## Podman API and Docker Compatibility

### Enable rootful Podman socket

```bash
sudo systemctl enable --now podman.socket
```

**Explanation:** Enables the Podman API socket for rootful service access.

### Enable rootless Podman socket

```bash
systemctl --user enable --now podman.socket
```

**Explanation:** Enables the Podman API socket for the current user.

### Check the socket

```bash
systemctl --user status podman.socket
```

**Explanation:** Shows the rootless Podman socket status.

### Use Docker-compatible CLI package

```bash
sudo dnf install -y podman-docker
```

**Explanation:** Allows many Docker CLI commands to use Podman behind the scenes.

### Instructor note

Docker compatibility is useful for developer convenience, but administrators should still understand the actual Podman behavior, storage, systemd integration, and rootless model.

---

## Useful Configuration Files

| File | Purpose |
|---|---|
| `/etc/containers/registries.conf` | System-wide registry search and blocking configuration |
| `/etc/containers/policy.json` | Image signature and trust policy |
| `/etc/containers/storage.conf` | Container storage configuration |
| `/etc/containers/containers.conf` | Container engine defaults |
| `~/.config/containers/containers.conf` | User-level container defaults |
| `/etc/subuid` | Subordinate UID mappings for rootless containers |
| `/etc/subgid` | Subordinate GID mappings for rootless containers |
| `~/.local/share/containers/` | Common rootless container storage path |
| `/var/lib/containers/` | Common rootful container storage path |
| `~/.config/containers/systemd/` | Rootless Quadlet files |
| `/etc/containers/systemd/` | System-level Quadlet files |

---

## Troubleshooting Commands

### Check Podman configuration

```bash
podman info
```

**Use when:** You need storage, network, runtime, registry, or rootless details.

### Check disk usage

```bash
podman system df
```

**Use when:** Container storage is consuming disk space.

### View events

```bash
podman events
```

**Use when:** You want to see container lifecycle events.

### Check container logs

```bash
podman logs <container>
```

**Use when:** Application inside the container fails or exits.

### Inspect container state

```bash
podman inspect <container> --format '{{.State.Status}} {{.State.ExitCode}} {{.State.Error}}'
```

**Use when:** You need status, exit code, and error details.

### Check port mapping

```bash
podman port <container>
```

**Use when:** A service is not reachable.

### Check running processes

```bash
podman top <container>
```

**Use when:** You need to confirm the application is running inside the container.

### Enter a container

```bash
podman exec -it <container> /bin/sh
```

**Use when:** You need to inspect the container from inside.

### Rootless namespace troubleshooting

```bash
podman unshare cat /proc/self/uid_map
```

**Use when:** You need to inspect UID mapping for rootless containers.

### Mount container filesystem

```bash
podman mount <container>
```

**Use when:** You need host-side access to a container filesystem.

### Unmount container filesystem

```bash
podman unmount <container>
```

**Use when:** You are finished inspecting the mounted filesystem.

### Reset Podman storage

```bash
podman system reset
```

**Use when:** You want to remove all containers, pods, images, networks, and volumes for that user/root context. This is destructive.

---

## Practice Labs

### Lab 1: First container

Run a temporary UBI container:

```bash
podman run --rm registry.access.redhat.com/ubi9/ubi cat /etc/os-release
```

Expected result: OS information prints and the container is removed.

---

### Lab 2: Run a web server

```bash
podman run -d --name web -p 8080:80 nginx
podman ps
curl http://localhost:8080
```

Clean up:

```bash
podman rm -f web
```

---

### Lab 3: Persistent web content with bind mount

```bash
mkdir -p ~/webcontent
echo '<h1>Podman bind mount lab</h1>' > ~/webcontent/index.html

podman run -d --name web \
  -p 8080:80 \
  -v ~/webcontent:/usr/share/nginx/html:Z \
  nginx

curl http://localhost:8080
```

Clean up:

```bash
podman rm -f web
```

---

### Lab 4: Custom image build

```bash
mkdir podman-lab-build
cd podman-lab-build

cat > index.html <<'EOF'
<h1>Custom image built with Podman</h1>
EOF

cat > Containerfile <<'EOF'
FROM registry.access.redhat.com/ubi9/ubi-minimal
RUN microdnf -y install nginx && microdnf clean all
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

podman build -t localhost/custom-nginx:v1 .
podman run -d --name custom-web -p 8080:80 localhost/custom-nginx:v1
curl http://localhost:8080
```

Clean up:

```bash
podman rm -f custom-web
podman rmi localhost/custom-nginx:v1
```

---

### Lab 5: Pod practice

```bash
podman pod create --name webpod -p 8080:80
podman run -d --name web --pod webpod nginx
podman pod ps
podman ps -a --pod
curl http://localhost:8080
```

Clean up:

```bash
podman pod rm -f webpod
```

---

### Lab 6: Quadlet rootless service

```bash
mkdir -p ~/.config/containers/systemd

cat > ~/.config/containers/systemd/web.container <<'EOF'
[Unit]
Description=Podman Quadlet NGINX Lab

[Container]
Image=docker.io/library/nginx:latest
ContainerName=quadlet-web
PublishPort=8080:80

[Service]
Restart=always

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user start web.service
systemctl --user status web.service
curl http://localhost:8080
```

Clean up:

```bash
systemctl --user stop web.service
rm -f ~/.config/containers/systemd/web.container
systemctl --user daemon-reload
podman rm -f quadlet-web 2>/dev/null || true
```

---

## Command Cheat Sheet

### Installation

```bash
sudo dnf install -y container-tools
sudo dnf install -y podman
sudo dnf install -y buildah skopeo
sudo dnf install -y podman-docker
```

### General

```bash
podman --help
podman <command> --help
podman version
podman info
podman system df
```

### Images

```bash
podman search <image>
podman pull <image>
podman images
podman image ls
podman image inspect <image>
podman history <image>
podman tag <source-image> <target-image>
podman rmi <image>
podman image prune
podman image prune -a
```

### Containers

```bash
podman run <image>
podman run --rm <image> <command>
podman run -it <image> /bin/bash
podman run -d --name <name> <image>
podman create --name <name> <image>
podman ps
podman ps -a
podman start <container>
podman stop <container>
podman restart <container>
podman kill <container>
podman pause <container>
podman unpause <container>
podman rm <container>
podman rm -f <container>
podman container prune
```

### Inspection and troubleshooting

```bash
podman inspect <container-or-image>
podman logs <container>
podman logs -f <container>
podman top <container>
podman stats
podman exec <container> <command>
podman exec -it <container> /bin/sh
podman attach <container>
podman diff <container>
podman wait <container>
podman events
```

### Files

```bash
podman cp <file> <container>:/path
podman cp <container>:/path <file>
podman mount <container>
podman unmount <container>
```

### Ports

```bash
podman run -d -p 8080:80 <image>
podman run -d -p 127.0.0.1:8080:80 <image>
podman port <container>
```

### Volumes

```bash
podman volume create <volume>
podman volume ls
podman volume inspect <volume>
podman run -v <volume>:/container/path <image>
podman run -v /host/path:/container/path:Z <image>
podman volume rm <volume>
podman volume prune
```

### Networks

```bash
podman network ls
podman network create <network>
podman network inspect <network>
podman network connect <network> <container>
podman network disconnect <network> <container>
podman network rm <network>
podman network prune
podman run --network <network> <image>
podman run --network host <image>
podman run --network none <image>
```

### Pods

```bash
podman pod create --name <pod>
podman pod create --name <pod> -p 8080:80
podman pod ps
podman pod inspect <pod>
podman run --pod <pod> <image>
podman ps -a --pod
podman pod start <pod>
podman pod stop <pod>
podman pod restart <pod>
podman pod rm <pod>
podman pod rm -f <pod>
podman pod prune
```

### Build

```bash
podman build -t <image>:<tag> .
podman build --no-cache -t <image>:<tag> .
buildah bud -t <image>:<tag> .
```

### Registry

```bash
podman login <registry>
podman logout <registry>
podman tag <local-image> <registry>/<user>/<image>:<tag>
podman push <registry>/<user>/<image>:<tag>
skopeo inspect docker://<registry>/<image>:<tag>
skopeo copy docker://<source> docker://<destination>
```

### Save and load

```bash
podman save -o image.tar <image>
podman load -i image.tar
podman export -o container.tar <container>
podman import container.tar <image>:<tag>
```

### Kubernetes YAML

```bash
podman generate kube <container-or-pod> > workload.yaml
podman play kube workload.yaml
podman play kube --down workload.yaml
```

### Systemd and Quadlet

```bash
mkdir -p ~/.config/containers/systemd
systemctl --user daemon-reload
systemctl --user start <name>.service
systemctl --user enable <name>.service
systemctl --user status <name>.service
journalctl --user -u <name>.service -f
sudo loginctl enable-linger $USER
```

### Cleanup

```bash
podman container prune
podman image prune
podman image prune -a
podman volume prune
podman network prune
podman pod prune
podman system prune
podman system prune -a --volumes
podman system reset
```

---

## Instructor Closing Summary

Podman is the standard Red Hat-friendly container engine for managing local containers and pods. It is daemonless, supports rootless operation, integrates well with systemd, and uses familiar Docker-like commands. On RHEL, students should become comfortable with the full lifecycle:

1. Install tools.
2. Pull images.
3. Run containers.
4. Inspect and troubleshoot containers.
5. Use volumes and networks.
6. Build images.
7. Use pods.
8. Deploy persistent services with systemd/Quadlet.
9. Clean up safely.

Recommended teaching approach:

- Start with `podman run --rm`.
- Move to detached containers and port publishing.
- Add volumes and SELinux labeling.
- Introduce custom networks.
- Teach pods as a bridge to Kubernetes.
- Finish with image builds and Quadlet services.
