# Task 08: Environment Variables in Containers

## Objective

Pass runtime configuration to containers using environment variables.

## Scenario

An application must receive configuration values such as application name and environment at runtime.

## Tasks

### 1. Run a container with environment variables

```bash
podman run --rm \
  -e APP_NAME=student-app \
  -e APP_ENV=training \
  registry.access.redhat.com/ubi9/ubi \
  printenv
```

### 2. Print selected variables only

```bash
podman run --rm \
  -e APP_NAME=student-app \
  -e APP_ENV=training \
  registry.access.redhat.com/ubi9/ubi \
  bash -c 'echo $APP_NAME && echo $APP_ENV'
```

### 3. Run a detached container with an environment variable

```bash
podman run -d \
  --name env-demo \
  -e COURSE=DO188 \
  registry.access.redhat.com/ubi9/ubi \
  sleep 300
```

### 4. Inspect the environment variable

```bash
podman inspect env-demo | grep COURSE
```

### 5. Clean up

```bash
podman stop env-demo
podman rm env-demo
```

## Commands Practiced

```bash
podman run -e
podman inspect
```

## Expected Output

The variables should appear inside the container.

## Validation

```bash
podman inspect env-demo | grep COURSE
```

## Questions for Students

1. Why should configuration be passed at runtime?
2. What is the difference between `ENV` in a Containerfile and `-e` in `podman run`?
3. Can environment variables store sensitive data safely?
4. What is a better option for passwords or secrets?

## Cleanup

```bash
podman rm -f env-demo 2>/dev/null || true
```
