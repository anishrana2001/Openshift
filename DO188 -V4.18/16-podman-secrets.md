# Task 16: Manage Secrets with Podman

## Objective

Create and use Podman secrets for sensitive runtime values.

## Scenario

An application needs a database password, but the password should not be stored directly in the image.

## Tasks

### 1. Create a secret

```bash
echo -n "redhat123" | podman secret create db_password -
```

### 2. List secrets

```bash
podman secret ls
```

### 3. Inspect secret metadata

```bash
podman secret inspect db_password
```

### 4. Use the secret as an environment variable

```bash
podman run --rm \
  --secret=db_password,type=env,target=DB_PASSWORD \
  registry.access.redhat.com/ubi9/ubi \
  printenv DB_PASSWORD
```

### 5. Remove the secret

```bash
podman secret rm db_password
```

## Commands Practiced

```bash
podman secret create
podman secret ls
podman secret inspect
podman secret rm
```

## Expected Output

The container should print:

```text
redhat123
```

## Validation

```bash
podman secret ls
```

## Questions for Students

1. Why should secrets not be stored in images?
2. What is the difference between environment variables and secrets?
3. How do you list Podman secrets?
4. How do you remove a secret?

## Cleanup

```bash
podman secret rm db_password 2>/dev/null || true
```
