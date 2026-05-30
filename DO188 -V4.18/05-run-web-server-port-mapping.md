# Task 05: Run a Web Server Container with Port Mapping

## Objective

Run a web server container and expose it to the host using port mapping.

## Scenario

You need to deploy a simple web server container and make it accessible from the host machine.

## Tasks

### 1. Run an Apache HTTPD container

```bash
podman run -d \
  --name web-basic \
  -p 8080:8080 \
  registry.access.redhat.com/ubi9/httpd-24
```

### 2. Verify that the container is running

```bash
podman ps
```

### 3. Check port mapping

```bash
podman port web-basic
```

### 4. Test the web server

```bash
curl http://localhost:8080
```

### 5. View logs

```bash
podman logs web-basic
```

### 6. Stop and remove the container

```bash
podman stop web-basic
podman rm web-basic
```

## Commands Practiced

```bash
podman run -d
podman ps
podman port
podman logs
podman stop
podman rm
```

## Expected Output

- The container should run in detached mode.
- `curl http://localhost:8080` should return a web page or HTTP response.
- `podman logs` should show web server logs.

## Validation

```bash
curl http://localhost:8080
```

## Questions for Students

1. What does `-d` mean?
2. What does `-p 8080:8080` mean?
3. Which port is the host port?
4. Which port is the container port?

## Cleanup

```bash
podman rm -f web-basic 2>/dev/null || true
```
