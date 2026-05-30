# Task 18: Run a Container as a Systemd User Service

## Objective

Configure a Podman container to run as a systemd user service.

## Scenario

A web container should start automatically and be managed using systemd.

## Tasks

### 1. Create a container

```bash
podman create \
  --name systemd-web \
  -p 8086:8080 \
  registry.access.redhat.com/ubi9/httpd-24
```

### 2. Create the user systemd directory

```bash
mkdir -p ~/.config/systemd/user
```

### 3. Generate a systemd unit file

```bash
podman generate systemd --new --files --name systemd-web
```

### 4. Move the generated file

```bash
mv container-systemd-web.service ~/.config/systemd/user/
```

### 5. Reload user systemd

```bash
systemctl --user daemon-reload
```

### 6. Enable and start the service

```bash
systemctl --user enable --now container-systemd-web.service
```

### 7. Verify the service

```bash
systemctl --user status container-systemd-web.service
curl http://localhost:8086
```

### 8. Enable lingering

```bash
loginctl enable-linger $USER
```

### 9. Stop and clean up

```bash
systemctl --user disable --now container-systemd-web.service
rm -f ~/.config/systemd/user/container-systemd-web.service
systemctl --user daemon-reload
podman rm -f systemd-web
```

## Commands Practiced

```bash
podman generate systemd
systemctl --user
loginctl enable-linger
```

## Expected Output

The web service should be managed by systemd and accessible on port `8086`.

## Validation

```bash
systemctl --user status container-systemd-web.service
curl http://localhost:8086
```

## Questions for Students

1. Why do we use systemd with containers?
2. What is a user service?
3. What does `loginctl enable-linger` do?
4. Why is persistence important for containerized services?

## Cleanup

```bash
systemctl --user disable --now container-systemd-web.service 2>/dev/null || true
rm -f ~/.config/systemd/user/container-systemd-web.service
systemctl --user daemon-reload
podman rm -f systemd-web 2>/dev/null || true
```
