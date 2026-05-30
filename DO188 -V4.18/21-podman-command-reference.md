# Podman Command Reference Checklist

Use this checklist to track student practice for EX188 / DO188-style Podman tasks.

## Help and Information

```bash
podman --help
podman help
podman version
podman info
```

## Image Management

```bash
podman search
podman pull
podman images
podman inspect
podman tag
podman rmi
podman history
```

## Build Images

```bash
podman build
```

## Container Lifecycle

```bash
podman run
podman create
podman start
podman stop
podman restart
podman rm
podman ps
```

## Container Interaction

```bash
podman exec
podman attach
podman top
podman logs
```

## Troubleshooting

```bash
podman inspect
podman events
podman stats
podman port
podman diff
```

## Backup and Restore

```bash
podman save
podman load
podman export
podman import
```

## Process Control

```bash
podman pause
podman unpause
podman kill
podman wait
```

## Volumes

```bash
podman volume create
podman volume ls
podman volume inspect
podman volume rm
podman volume prune
```

## Networks

```bash
podman network create
podman network ls
podman network inspect
podman network rm
```

## Pods

```bash
podman pod create
podman pod ps
podman pod inspect
podman pod top
podman pod stop
podman pod rm
podman ps --pod
```

## Secrets

```bash
podman secret create
podman secret ls
podman secret inspect
podman secret rm
```

## Kubernetes YAML

```bash
podman generate kube
podman kube play
podman kube down
```

## Systemd

```bash
podman generate systemd
systemctl --user daemon-reload
systemctl --user enable --now
systemctl --user status
loginctl enable-linger
```

## Registry

```bash
podman login
podman logout
podman push
podman pull
```

## Cleanup

```bash
podman system prune
podman container prune
podman image prune
podman volume prune
```
