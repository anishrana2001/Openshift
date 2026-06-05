# Containerfile Learning Lab

## Purpose

This single file is designed for students who are learning **what a Containerfile is, why we use it, and how to create one step by step**.

A **Containerfile** is a text file that contains instructions for building a container image. It is similar to a Dockerfile. Tools like **Podman**, **Buildah**, and Docker can use it to create images.

A container image is a packaged environment that contains:

- Application code
- Runtime dependencies
- System packages
- Environment variables
- Startup command
- Configuration needed to run consistently anywhere

We use a Containerfile because it helps us:

- Build repeatable application environments
- Avoid “works on my machine” problems
- Package applications with dependencies
- Deploy applications consistently
- Automate setup steps
- Share applications easily with others

---

## Common Containerfile Instructions

| Instruction | Purpose |
|---|---|
| `FROM` | Selects the base image |
| `ARG` | Defines build-time variables |
| `ENV` | Defines environment variables available inside the container |
| `WORKDIR` | Sets the working directory inside the image |
| `COPY` | Copies files from your local project into the image |
| `ADD` | Copies files like `COPY`, with extra support for URLs and compressed archives |
| `RUN` | Executes commands during image build |
| `EXPOSE` | Documents the port the container listens on |
| `USER` | Defines which user runs the container process |
| `VOLUME` | Defines a mount point for persistent data |
| `LABEL` | Adds metadata to the image |
| `HEALTHCHECK` | Defines a command to check container health |
| `ENTRYPOINT` | Defines the main executable for the container |
| `CMD` | Defines default arguments or the default command |

---

# Task 1: Create Your First Simple Containerfile

## Difficulty: **`Easy`**

## Goal : Create the simplest possible Containerfile that prints a message when the container runs.

## 🧑‍💻 Student Task

### Create a file named `Containerfile` and use:

- `FROM`
- `CMD`

### The container should print:

```text
Hello from my first Containerfile!
```

## Solution

```Containerfile
FROM alpine:latest

CMD ["echo", "Hello from my first Containerfile!"]
```

## Explanation

### `FROM alpine:latest`

This tells the build tool to start with the `alpine` Linux image.

Alpine is commonly used because it is small and lightweight.

### `CMD ["echo", "Hello from my first Containerfile!"]`

This defines the default command that runs when the container starts.

The command uses JSON array format, which is recommended because it avoids shell parsing issues.

## Build Command

```bash
podman build -t task1-hello -f Containerfile .
```

## Run Command

```bash
podman run --rm task1-hello
```

## Expected Output

```text
Hello from my first Containerfile!
```

---

# Task 2: Copy a Script into the Image

## Difficulty : **Beginner**
## How to create a lab?

```bash
mkdir /tmp/project-folder
touch Containerfile app.sh
cat <<EOF > /tmp/project-folder/app.sh
#!/bin/sh
echo "Containerfile copied this script successfully."
EOF
```

## Goal : Create a Containerfile under **`/tmp/project-folder`** directory that copies a shell script **`app.sh`** from this directory into the image and runs it.

### The script should print:

```text
Containerfile copied this script successfully.
```

Then create a Containerfile using:

- `FROM`
- `WORKDIR`
- `COPY`
- `RUN`
- `CMD`



## Solution

## Required Project Structure

```text
project-folder/
├── Containerfile
└── app.sh
```

## app.sh

```bash
#!/bin/sh
echo "Containerfile copied this script successfully."
```
### Let's create a **Containerfile**
```Containerfile
FROM alpine:latest

WORKDIR /app

COPY /tmp/project-folder/app.sh /app/app.sh

RUN chmod +x /app/app.sh

CMD ["/app/app.sh"]
```

## Explanation

### `WORKDIR /app`

This sets `/app` as the working directory inside the image.

If the directory does not exist, it is created automatically.

### `COPY app.sh /app/app.sh`

This copies the local file `app.sh` into the image at `/app/app.sh`.

### `RUN chmod +x /app/app.sh`

This command runs during the build process.

It gives execute permission to the script.

### `CMD ["/app/app.sh"]`

This runs the script when the container starts.

## Build Command

```bash
podman build -t task2-script -f Containerfile .
```

## Run Command

```bash
podman run --rm task2-script
```

## Expected Output

```text
Containerfile copied this script successfully.
```

---

# Task 3: Use ARG and ENV

## Difficulty : **`Intermediate Beginner`**

## Goal: Understand the difference between `ARG` and `ENV`.

## 🧑‍💻 Student Task

Create a Containerfile that uses:

- `FROM`
- `ARG`
- `ENV`
- `RUN`
- `CMD`

The image should accept a build-time value called `APP_VERSION` and store it as an environment variable called `VERSION`.

When the container runs, it should print the version.

## Solution

```Containerfile
FROM alpine:latest

ARG APP_VERSION=1.0.0

ENV VERSION=${APP_VERSION}

RUN echo "Building application version: ${VERSION}"

CMD ["sh", "-c", "echo Running application version: $VERSION"]
```

## Explanation

### `ARG APP_VERSION=1.0.0`

`ARG` defines a build-time variable.

It is available only while the image is being built, unless we store it somewhere else.

Here, the default version is `1.0.0`.

### `ENV VERSION=${APP_VERSION}`

`ENV` creates an environment variable inside the image.

Unlike `ARG`, `ENV` is available when the container runs.

### `RUN echo "Building application version: ${VERSION}"`

This runs during the image build.

It prints the version during the build process.

### `CMD ["sh", "-c", "echo Running application version: $VERSION"]`

This runs when the container starts.

We use `sh -c` because `$VERSION` needs shell expansion at runtime.

## Build Command with Default Version

```bash
podman build -t task3-version -f Containerfile .
```

## Build Command with Custom Version

```bash
podman build -t task3-version -f Containerfile --build-arg APP_VERSION=2.5.0 .
```

## Run Command

```bash
podman run --rm task3-version
```

## Expected Output

```text
Running application version: 2.5.0
```

## Important Note

Use `ARG` when the value is needed during image build.

Use `ENV` when the value is needed while the container is running.

---

# Task 4: Install Packages and Run a Small Web Server

## Difficulty: **`Intermediate`**

## Goal : Create a small Python web server image.

## 🧑‍💻 Student Task

Create a Containerfile that uses:

- `FROM`
- `LABEL`
- `WORKDIR`
- `COPY`
- `RUN`
- `EXPOSE`
- `CMD`

Create a simple `index.html` file and serve it using Python.

## Required Project Structure

```text
/tmp/project-folder/
├── Containerfile
└── index.html
```

## index.html

```html
<!DOCTYPE html>
<html>
<head>
    <title>Containerfile Task 4</title>
</head>
<body>
    <h1>Hello from a containerized web server!</h1>
</body>
</html>
```

## Solution

```Containerfile
FROM python:3.12-alpine

LABEL maintainer="student@example.com"
LABEL description="Simple Python web server using Containerfile"

WORKDIR /site

COPY index.html /site/index.html

RUN python --version

EXPOSE 8000

CMD ["python", "-m", "http.server", "8000"]
```

## Explanation

### `FROM python:3.12-alpine`

This uses a Python image based on Alpine Linux.

Python is already installed in this image.

### `LABEL maintainer="student@example.com"`

`LABEL` adds metadata to the image.

It can describe the maintainer, version, description, or project name.

### `WORKDIR /site`

This sets `/site` as the working directory.

### `COPY index.html /site/index.html`

This copies the HTML file into the image.

### `RUN python --version`

This command runs while building the image.

It confirms that Python exists in the image.

### `EXPOSE 8000`

This documents that the container listens on port `8000`.

Important: `EXPOSE` does not publish the port automatically. You still need `-p` when running the container.

### `CMD ["python", "-m", "http.server", "8000"]`

This starts a Python HTTP server on port `8000`.

## Build Command

```bash
podman build -t task4-web -f Containerfile .
```

## Run Command

```bash
podman run --rm -p 8000:8000 task4-web
```

## Test in Browser

Open:

```text
http://localhost:8000
```

---

# Task 5: Use ENTRYPOINT and CMD Together

## How to create a lab?

```bash
mkdir /tmp/project-folder5
cat <<EOF > /tmp/project-folder5/greet.sh
#!/bin/sh
PREFIX=${GREETING_PREFIX:-Hello}
echo "$PREFIX $1"
EOF
```

## Goal : Learn how `ENTRYPOINT` and `CMD` work together.

## 🧑‍💻 Student Task : Create a Containerfile under **`/tmp/project-folder5`** directory that that runs a command-line greeting app.

The container should use:

- `FROM`
- `ARG`
- `ENV`
- `WORKDIR`
- `COPY`
- `RUN`
- `ENTRYPOINT`
- `CMD`

The default output should be:

```text
Hello Student
```

But the user should be able to override the name at runtime.

## Required Project Structure

```text
/tmp/project-folder5/
├── Containerfile
└── greet.sh
```

## Solution
## greet.sh

```bash
#!/bin/sh
PREFIX=${GREETING_PREFIX:-Hello}
echo "$PREFIX $1"
```

## Go to the directory first.
```
cd /tmp/project-folder

### Our Containerfile would be:
```Containerfile
FROM alpine:latest

ARG DEFAULT_PREFIX=Hello

ENV GREETING_PREFIX=${DEFAULT_PREFIX}

WORKDIR /app

COPY greet.sh /app/greet.sh

RUN chmod +x /app/greet.sh

ENTRYPOINT ["/app/greet.sh"]

CMD ["Student"]
```

## Explanation

### `ARG DEFAULT_PREFIX=Hello`

This defines a build-time default greeting prefix.

### `ENV GREETING_PREFIX=${DEFAULT_PREFIX}`

This stores the build-time value as a runtime environment variable.

### `ENTRYPOINT ["/app/greet.sh"]`

`ENTRYPOINT` defines the main executable.

This means the container will always run `/app/greet.sh` unless the entrypoint is explicitly overridden.

### `CMD ["Student"]`

`CMD` provides default arguments to the entrypoint.

Together, this becomes:

```bash
/app/greet.sh Student
```

## Build Command

```bash
podman build -t task5-entrypoint -f Containerfile .
```

## Run with Default Name

```bash
podman run --rm task5-entrypoint
```

## Expected Output

```text
Hello Student
```

## Run with Custom Name

```bash
podman run --rm task5-entrypoint Dikku
```

## Expected Output

```text
Hello Dikku
```

## Build with Custom Greeting Prefix

```bash
podman build -t task5-entrypoint -f Containerfile --build-arg DEFAULT_PREFIX=Welcome .
```

## Run Again

```bash
podman run --rm task5-entrypoint Student
```

## Expected Output

```text
Welcome Student
```

## Important Note

Use `ENTRYPOINT` when you want the container to behave like a fixed executable.

Use `CMD` to provide default arguments that users can override.

---

# Task 6: Full Containerfile with Production-Style Parameters

## Difficulty: **`Advanced`**

## How to create a lab?

```bash
mkdir /tmp/project-folder5/
cat <<EOF > /tmp/project-folder6/app.py
from http.server import HTTPServer, BaseHTTPRequestHandler
import os

APP_NAME = os.getenv("APP_NAME", "Containerfile Demo")
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")
APP_ENV = os.getenv("APP_ENV", "development")

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"healthy")
            return

        self.send_response(200)
        self.end_headers()
        message = f"{APP_NAME} | Version: {APP_VERSION} | Environment: {APP_ENV}"
        self.wfile.write(message.encode())

server = HTTPServer(("0.0.0.0", 8080), Handler)
print("Server running on port 8080")
server.serve_forever()
EOF
cat <<EOF > /tmp/project-folder6/requirements.txt
# No external dependency required for this example.
# Add dependencies here if your app needs them.
EOF

mkdir /tmp/project-folder6/config
echo "mode=demo" > /tmp/project-folder6/config/app.conf
tar -czf /tmp/project-folder6/config.tar.gz /tmp/project-folder6/config
EOF
```

## Goal: Create a complete production-style Containerfile using many important instructions.

✅ Requirements

Your image should satisfy the following requirements:

1. The base image is `python:3.12-alpine` as the base image.
2. Accepts the following build arguments:
	- Application version = `APP_VERSION`
	- Build date = `APP_BUILD_DATE`
	- Application user = `APP_USER`
	- Application home directory = `APP_HOME`
	- Application port = `APP_PORT`
3. Pass the following environment variables:
	- APP_NAME = `Containerfile Production Demo`
	- APP_VERSION -> The value of `APP_VERSION`
	- APP_ENV = `production`
	- PYTHONDONTWRITEBYTECODE = `1`
	- PYTHONUNBUFFERED = `1`
	- APP_HOME -> The value of `APP_HOME`
	- APP_PORT -> The value of `APP_PORT`

4. Add image metadata using LABEL.
    - org.opencontainers.image.title="Containerfile Production Demo"
    - org.opencontainers.image.description="Advanced Containerfile example for students"
    -  org.opencontainers.image.version -> The value of `APP_VERSION`
    -  org.opencontainers.image.created -> The value of `APP_BUILD_DATE`
    -  org.opencontainers.image.authors="student@example.com"

5. Set the working directory to the value of `APP_HOME`
6. Copy the following files into the image `working directory`:
	- **`requirements.txt`**
	- **`app.py`**

7. Add and extract the config.tar.gz archive into the application **working directory**.
    - Install required packages using RUN.


    Install curl inside the image.
        - apk add --no-cache curl

   Install Python dependencies from requirements.txt.
        - pip install --no-cache-dir -r requirements.txt
    - Create a non-root user.
    - Create a log directory:
	    **`/var/log/container-app`**
    - Change ownership of the application directory and log directory to the non-root user.
    - Run the container using the non-root user.
8. Expose port 8080.
9. Create a volume for:
	**`/var/log/container-app`**
10. Add a health check that checks:
	**`http://localhost:8080/health`**
11. Use ENTRYPOINT and CMD so that the final container command becomes:
	- **`python app.py`**




## Full Solution

## Required Project Structure

```text
project-folder/
├── Containerfile
├── app.py
├── requirements.txt
└── config.tar.gz
```


## Go to the mentioned directory.
```bash
cd /tmp/project-folder6/
```
### Our Containerfile would be :
```Containerfile
FROM python:3.12-alpine

ARG APP_VERSION=1.0.0
ARG APP_BUILD_DATE=unknown
ARG APP_USER=appuser
ARG APP_HOME=/opt/container-app
ARG APP_PORT=8080

ENV APP_NAME="Containerfile Production Demo" \
    APP_VERSION=${APP_VERSION} \
    APP_ENV=production \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    APP_HOME=${APP_HOME} \
    APP_PORT=${APP_PORT}

LABEL org.opencontainers.image.title="Containerfile Production Demo" \
      org.opencontainers.image.description="Advanced Containerfile example for students" \
      org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.created="${APP_BUILD_DATE}" \
      org.opencontainers.image.authors="student@example.com"

WORKDIR ${APP_HOME}

COPY requirements.txt ${APP_HOME}/requirements.txt
COPY app.py ${APP_HOME}/app.py

ADD config.tar.gz ${APP_HOME}/

RUN apk add --no-cache curl \
    && pip install --no-cache-dir -r requirements.txt \
    && addgroup -S ${APP_USER} \
    && adduser -S ${APP_USER} -G ${APP_USER} \
    && mkdir -p /var/log/container-app \
    && chown -R ${APP_USER}:${APP_USER} ${APP_HOME} /var/log/container-app

USER ${APP_USER}

EXPOSE ${APP_PORT}

VOLUME ["/var/log/container-app"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:${APP_PORT}/health || exit 1

ENTRYPOINT ["python"]

CMD ["app.py"]
```

## Explanation

### `FROM python:3.12-alpine`

This selects the base image.

It includes Python and uses Alpine Linux to keep the image small.

### `ARG APP_VERSION=1.0.0`

This defines a build-time variable.

You can override it while building the image.

Example:

```bash
podman build -t task6-full -f Containerfile --build-arg APP_VERSION=3.0.0 .
```

### `ARG APP_BUILD_DATE=unknown`

This allows the build date to be passed into the image metadata.

Example:

```bash
podman build -t task6-full -f Containerfile --build-arg APP_BUILD_DATE=2026-05-20 .
```

### `ARG APP_USER=appuser`

This defines the Linux user that will be created inside the image.

Running containers as non-root is a better security practice.

### `ARG APP_HOME=/opt/container-app`

This allows the application directory to be customized during build.

### `ARG APP_PORT=8080`

This defines the application port.

It is later used in `ENV`, `EXPOSE`, and `HEALTHCHECK`.

### `ENV APP_NAME="Containerfile Production Demo"`

This sets the application name available at runtime.

### `ENV APP_VERSION=${APP_VERSION}`

This stores the build-time version as a runtime environment variable.

### `ENV APP_ENV=production`

This tells the application it is running in production mode.

### `ENV PYTHONDONTWRITEBYTECODE=1`

This prevents Python from writing `.pyc` files.

This keeps the container cleaner.

### `ENV PYTHONUNBUFFERED=1`

This makes Python logs appear immediately in the container output.

This is useful for debugging and production logs.

### `LABEL ...`

Labels add useful metadata to the image.

The labels used here follow the Open Container Initiative style.

They describe the image title, description, version, creation date, and author.

### `WORKDIR ${APP_HOME}`

This sets the working directory to the application directory.

All following relative commands run from this location.

### `COPY requirements.txt ${APP_HOME}/requirements.txt`

This copies the dependency file into the image.

### `COPY app.py ${APP_HOME}/app.py`

This copies the Python application into the image.

### `ADD config.tar.gz ${APP_HOME}/`

`ADD` can automatically extract compressed archives.

Here, `config.tar.gz` is extracted into the application directory.

Use `COPY` for normal file copying.

Use `ADD` only when you need special features like archive extraction.

### `RUN apk add --no-cache curl ...`

This executes several setup commands during image build:

1. Installs `curl`
2. Installs Python dependencies
3. Creates a system group
4. Creates a system user
5. Creates a log directory
6. Changes file ownership

The commands are chained with `&&` so the build fails if any command fails.

### `USER ${APP_USER}`

This switches from root to the non-root application user.

This improves security.

### `EXPOSE ${APP_PORT}`

This documents that the application listens on port `8080` by default.

Remember: `EXPOSE` does not publish the port automatically.

You still need `-p` when running the container.

### `VOLUME ["/var/log/container-app"]`

This marks `/var/log/container-app` as a place for persistent or external data.

Logs written here can be mounted from the host system.

### `HEALTHCHECK ...`

This checks whether the application is healthy.

It sends a request to:

```text
http://localhost:8080/health
```

If the request fails, the container may be marked unhealthy.

### `ENTRYPOINT ["python"]`

This defines the main executable.

The container will run Python by default.

### `CMD ["app.py"]`

This provides the default argument to `ENTRYPOINT`.

Together, the final runtime command becomes:

```bash
python app.py
```

🏗️ Build the Image

```bash
cd /tmp/project-folder6/
```
```bash
podman build -t task6-full -f Containerfile \
  --build-arg APP_VERSION=3.0.0 \
  --build-arg APP_BUILD_DATE=2026-05-20 \
  --build-arg APP_USER=appuser \
  --build-arg APP_HOME=/opt/container-app \
  --build-arg APP_PORT=8080 \
  .
```

## ▶️ Run the Container
### Run the container using:
```bash
podman run --rm -p 8080:8080 task6-full
```

## 🧪 Test the Application

### Open the following URL in the browser:

```text
http://localhost:8080
```

### Expected response:

```text
Containerfile Production Demo | Version: 3.0.0 | Environment: production
```

## 🩺 Test Health Endpoint

```bash
curl http://localhost:8080/health
```

Expected response:

```text
healthy
```

## 🔁 Runtime Override Test

### You can override environment variables at runtime:

```bash
podman run --rm -p 8080:8080 \
  -e APP_NAME="Custom Runtime App" \
  -e APP_ENV=staging \
  task6-full
```

### Expected browser response:

```text
Custom Runtime App | Version: 3.0.0 | Environment: staging
```

---

# Final Summary for Students

A Containerfile is a build recipe for a container image.

The most important instructions are:

| Instruction | When to Use |
|---|---|
| `FROM` | Always required; selects the base image |
| `ARG` | For build-time values |
| `ENV` | For runtime environment variables |
| `WORKDIR` | To organize commands inside the image |
| `COPY` | To copy application files |
| `ADD` | To copy and extract archives when needed |
| `RUN` | To install packages or prepare files during build |
| `USER` | To avoid running as root |
| `EXPOSE` | To document the listening port |
| `VOLUME` | To define persistent data locations |
| `HEALTHCHECK` | To check whether the container is working |
| `ENTRYPOINT` | To define the main executable |
| `CMD` | To define default command or arguments |

## Best Practices

1. Use small base images when possible.
2. Prefer `COPY` over `ADD` unless you need archive extraction.
3. Use `ARG` for build-time values.
4. Use `ENV` for runtime values.
5. Run containers as a non-root user.
6. Keep images small by cleaning package caches.
7. Use `HEALTHCHECK` for long-running services.
8. Use JSON format for `CMD` and `ENTRYPOINT`.
9. Keep one main process per container.
10. Do not store secrets directly inside the Containerfile.

## Practice Challenge

After completing all six tasks, try to create your own Containerfile for one of these:

- A Node.js app
- A Java app
- A Python Flask app
- A static HTML website
- A shell-script automation tool

