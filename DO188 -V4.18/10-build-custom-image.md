# Task 10: Build a Custom Image with Containerfile

## Objective

Build a custom web server image using a Containerfile.

## Scenario

You need to package a static website into a custom container image.

## Tasks

### 1. Create a project directory

```bash
mkdir -p ~/podman-labs/custom-web
cd ~/podman-labs/custom-web
```

### 2. Create an HTML file

```bash
cat > index.html <<EOF
<h1>Custom Image Built by Student</h1>
<p>This image was created using Podman build.</p>
EOF
```

### 3. Create a Containerfile

```bash
cat > Containerfile <<EOF
FROM registry.access.redhat.com/ubi9/httpd-24
LABEL description="DO188 custom web image"
COPY index.html /var/www/html/index.html
EXPOSE 8080
EOF
```

### 4. Build the image

```bash
podman build -t localhost/custom-web:v1 .
```

### 5. Run the image

```bash
podman run -d \
  --name custom-web \
  -p 8082:8080 \
  localhost/custom-web:v1
```

### 6. Test it

```bash
curl http://localhost:8082
```

### 7. Check image history

```bash
podman history localhost/custom-web:v1
```

### 8. Clean up the container

```bash
podman stop custom-web
podman rm custom-web
```

## Commands Practiced

```bash
podman build
podman run
podman history
podman images
```

## Expected Output

The custom web page should be available on port `8082`.

## Validation

```bash
curl http://localhost:8082
podman images | grep custom-web
```

## Questions for Students

1. What is a Containerfile?
2. What does the `FROM` instruction do?
3. What does the `COPY` instruction do?
4. Why should an image be tagged?

## Cleanup

```bash
podman rm -f custom-web 2>/dev/null || true
podman rmi localhost/custom-web:v1 2>/dev/null || true
rm -rf ~/podman-labs/custom-web
```
