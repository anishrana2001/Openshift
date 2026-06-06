
# Task 7: MYSQL Container Image Build and Registry Push Task

This task describes how to update the `Containerfile.MYSQL-db`, build the image, and push it to a private registry so that it meets all the specified requirements.

## 🎯 Prepare the lab for this question.
```bash
mkdir /home/student/task7
mkdir /home/student/task7/db-script/
cat <<EOF > /home/student/task7/db-script/script.sh
#!/bin/bash
echo "Starting MySQL database container..."
EOF
chmod 755 /home/student/task7/db-script/script.sh
touch /home/student/task7/Containerfile.MYSQL-db
```
---

## 1. Containerfile Requirements

Update `/home/student/task7/Containerfile.MYSQL-db` so that it does the following:

### 1.1 Base image

Use `registry.ocp4.example.com:8443/rhel9/mysql-80:latest` as the base image.

### 1.2 Accepts the following build arguments

```bash
DB_APP_VERSION
DB_ROOT_PASSWORD
```

### 1.3 Pass the following environment variables

- `MYSQL_APP_VERSION` → value from `DB_APP_VERSION`
- `MYSQL_ROOT_PASSWORD` → value from `DB_ROOT_PASSWORD`


### 1.4 Copy the script file

Copy the `script.sh` file under `/home/student/task7/db-script/` directory into `/tmp/mydb` directory.

### 1.5 Set the working directory

Set the working directory as `/tmp/mydb`.

### 1.6 Container start command

The container must start by executing the script `run-mysqld`

---

## 2. Building the Image

You must build the image with the following argument values:

- `DB_APP_VERSION = 8.4`
- `DB_ROOT_PASSWORD = devops_wala`
---

## 3. Tagging and Pushing to the Private Registry

### 3.1 Build the image

Build an image tagged **`localhost/mysql-db-cdn:latest`** using the file `/home/student/task7/Containerfile.MYSQL-db`.

### 3.2 Push the image

Push the image `localhost/mysql-db-cdn:latest` to the private registry at **`registry.ocp4.example.com:8443/rhel9/mysqldbcdn:latest`**.

---

# ✅ Solution: Building and Publishing the `MYSQL-db` Image
## Login to registry 
```bash
podman login -u developer -p developer registry.ocp4.example.com:8443
```
## 1. Containerfile Requirements

```dockerfile
# Use mysql:latest as the base image
FROM registry.ocp4.example.com:8443/rhel9/mysql-80:latest

# Declare the required build arguments
ARG DB_APP_VERSION
ARG DB_ROOT_PASSWORD

# Map each build argument into a corresponding environment variable
ENV MYSQL_APP_VERSION="${DB_APP_VERSION}" \
    MYSQL_ROOT_PASSWORD="${DB_ROOT_PASSWORD}"

# Create target directory
RUN mkdir -p /tmp/mydb

# Copy the script.sh file into /mydb directory
COPY --chmod=755 db-script/script.sh /tmp/mydb/script.sh

# Make sure the script is executable
# RUN chmod +x /tmp/mydb/script.sh

# Set the working directory
WORKDIR /tmp/mydb

# Configure the container to start by executing ["run-mysqld"]
CMD ["run-mysqld"]
```

## 2. Building the Image

```bash
cd /home/student/task7/

podman build \
  -f Containerfile.MYSQL-db \
  -t mysql-db-cdn:latest \
  --build-arg DB_APP_VERSION=8.4 \
  --build-arg DB_ROOT_PASSWORD=devops_wala \
```

### After the build finishes, verify the image:

```bash
podman images | grep mysql-db-cdn
```

## 3. Tagging and Pushing to the Private Registry

### 3.1 Tag the image

```bash
podman tag localhost/mysql-db-cdn:latest registry.ocp4.example.com:8443/rhel9/mysql-db-cdn:latest
```

### 3.2 Push the image

```bash
podman push registry.ocp4.example.com:8443/rhel9/mysqldbcdn:latest 
```

## 4. Final Checklist

- [x] `FROM registry.ocp4.example.com:8443/rhel9/mysql-80:latest` used as base image  
- [x] Build arguments defined: `DB_APP_VERSION`, `DB_ROOT_PASSWORD`, `DB_MYSQL_DATABASE`  
- [x] Environment variables set from build args:
  - `MYSQL_APP_VERSION`
  - `MYSQL_ROOT_PASSWORD`
  - `MYSQL_DATABASE`  
- [x] `script.sh` copied into `/mydb/script.sh` and made executable  
- [x] `WORKDIR` set to `/mydb`  
- [x] Container starts with `CMD ["/mydb/script.sh"]`  
- [x] Image built as `localhost/mysql-db-cdn:latest` using the specified build args  
- [x] Image pushed as `registry.ocp4.example.com:8443/rhel9/mysql-db-cdn:latest`
