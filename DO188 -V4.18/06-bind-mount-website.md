# Task 06: Bind Mount a Website Directory

## Objective

Use a bind mount to serve website content from a host directory.

## Scenario

The web team wants to edit HTML files on the host machine and serve them through a container.

## Tasks

### 1. Create a project directory

```bash
mkdir -p ~/podman-labs/site
```

### 2. Create an HTML page

```bash
cat > ~/podman-labs/site/index.html <<EOF
<h1>Welcome to Red Hat Podman Lab</h1>
<p>This page is served from a bind mount.</p>
EOF
```

### 3. Run the HTTPD container with a bind mount

```bash
podman run -d \
  --name web-bind \
  -p 8081:8080 \
  -v ~/podman-labs/site:/var/www/html:Z \
  registry.access.redhat.com/ubi9/httpd-24
```

### 4. Test the page

```bash
curl http://localhost:8081
```

### 5. Modify the host file

```bash
echo "<p>Updated from host directory.</p>" >> ~/podman-labs/site/index.html
```

### 6. Test again

```bash
curl http://localhost:8081
```

### 7. Inspect the container mount

```bash
podman inspect web-bind | grep -i mount -A 20
```

### 8. Clean up

```bash
podman stop web-bind
podman rm web-bind
```

## Commands Practiced

```bash
podman run -v
podman inspect
podman logs
```

## Important Note

The `:Z` option is used on SELinux-enabled systems. It relabels the mounted content so that the container can access it.

## Expected Output

The web page should update after modifying the host file.

## Validation

```bash
curl http://localhost:8081
```

The output should include:

```text
Updated from host directory.
```

## Questions for Students

1. What is a bind mount?
2. Why do we use `:Z` with SELinux?
3. What happens if the host directory does not exist?
4. How is a bind mount different from a named volume?

## Cleanup

```bash
podman rm -f web-bind 2>/dev/null || true
rm -rf ~/podman-labs/site
```
