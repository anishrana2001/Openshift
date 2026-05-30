# Task 20: Final Assessment Lab - Student Portal Application

## Objective

Combine Podman installation, image build, runtime configuration, persistent storage, networking, troubleshooting, systemd, and image backup.

## Scenario

Your company wants to deploy a small static web application called **Student Portal** using Podman.

## Requirements

Complete the task without using step-by-step instructor commands unless you are stuck.

## Application Requirements

1. Create a project directory:

```bash
~/student-portal
```

2. Create an `index.html` page containing:

```html
<h1>Student Portal</h1>
<p>Deployed using Podman for EX188/DO188 practice.</p>
```

3. Create a `Containerfile` using:

```text
registry.access.redhat.com/ubi9/httpd-24
```

4. Build the image as:

```text
localhost/student-portal:v1
```

5. Run the container with this name:

```text
student-portal-web
```

6. Publish the application on host port:

```text
8090
```

7. Use a named volume called:

```text
student_portal_logs
```

8. Pass this environment variable:

```text
APP_ENV=production
```

9. Verify the application using:

```bash
curl http://localhost:8090
```

10. Generate a systemd user service for the container.

11. Enable and start the service.

12. Simulate a restart by stopping and starting the service.

13. Show logs and inspect output.

14. Save the image as:

```text
student-portal-v1.tar
```

15. Clean up all unused containers and images only after instructor verification.

## Suggested Student Workflow

### 1. Create files

```bash
mkdir -p ~/student-portal
cd ~/student-portal
```

```bash
cat > index.html <<EOF
<h1>Student Portal</h1>
<p>Deployed using Podman for EX188/DO188 practice.</p>
EOF
```

```bash
cat > Containerfile <<EOF
FROM registry.access.redhat.com/ubi9/httpd-24
COPY index.html /var/www/html/index.html
EXPOSE 8080
EOF
```

### 2. Build the image

```bash
podman build -t localhost/student-portal:v1 .
```

### 3. Create the volume

```bash
podman volume create student_portal_logs
```

### 4. Run the container

```bash
podman run -d \
  --name student-portal-web \
  -p 8090:8080 \
  -e APP_ENV=production \
  -v student_portal_logs:/var/log/httpd \
  localhost/student-portal:v1
```

### 5. Test the application

```bash
curl http://localhost:8090
```

### 6. Generate systemd service

```bash
mkdir -p ~/.config/systemd/user
podman generate systemd --new --files --name student-portal-web
mv container-student-portal-web.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now container-student-portal-web.service
```

### 7. Verify service

```bash
systemctl --user status container-student-portal-web.service
curl http://localhost:8090
```

### 8. Save image

```bash
podman save -o student-portal-v1.tar localhost/student-portal:v1
```

## Student Must Submit

```bash
podman images
podman ps -a
podman volume ls
podman inspect student-portal-web
systemctl --user status container-student-portal-web.service
curl http://localhost:8090
ls -lh student-portal-v1.tar
```

## Grading Rubric

| Skill | Marks |
|---|---:|
| Correct project directory and files | 10 |
| Correct Containerfile | 10 |
| Image built with correct tag | 15 |
| Container runs with correct name | 10 |
| Correct port mapping | 10 |
| Named volume used | 10 |
| Environment variable configured | 10 |
| Application test successful | 10 |
| Systemd user service generated and enabled | 15 |
| Image saved as tar archive | 10 |
| Logs and inspect used for verification | 10 |

**Total: 120 marks**

## Cleanup

Use only after instructor verification:

```bash
systemctl --user disable --now container-student-portal-web.service 2>/dev/null || true
rm -f ~/.config/systemd/user/container-student-portal-web.service
systemctl --user daemon-reload
podman rm -f student-portal-web 2>/dev/null || true
podman rmi localhost/student-portal:v1 2>/dev/null || true
podman volume rm student_portal_logs 2>/dev/null || true
rm -rf ~/student-portal
```
