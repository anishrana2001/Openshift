lab start deploy-introduction
oc login -u admin -p redhatocp https://api.ocp4.example.com:6443
mkdir -p /home/student/ex288/task2/apps/task2/python-webserver

cd /home/student/ex288/task2/apps/task2/python-webserver

cat <<EOF >  /tmp/git.txt 
Username: developer
Password: d3v3lop3r
EOF
cat <<EOF > Dockerfile
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL org.opencontainers.image.title="Devopswala Task2 Web Server"
LABEL org.opencontainers.image.description="Simple Python HTTP Server running on OpenShift"
LABEL org.opencontainers.image.version="2.0"
LABEL org.opencontainers.image.vendor="Devopswala.com Training"
LABEL org.opencontainers.image.author="training@devopswala.com"

USER root

# Install Python and clean package cache
RUN microdnf install -y python3 && \
    microdnf clean all && \
    mkdir -p /devopswala

# Create custom application page
RUN echo '🚀 EX288 Task2 Application Running on OpenShiftCreated by: Devopswala.com Training' > /devopswala/index.html


ENV DOCROOT=/devopswala
ENV APPLICATION="EX288-Task2"

EXPOSE 8080

# OpenShift compatible non-root user
USER 1001

WORKDIR /devopswala

CMD ["python3", "-m", "http.server", "8080"]
EOF


mkdir src
cat <<EOF > src/index.html
<!DOCTYPE html>
<html>
<head>
  <title>2nd Image overriding</title>
</head>
<body>
  <h1>Task 2 Python Webserver </h1>
  <p>If you see this webpage then "COPY" worked correctly!</p>
</body>
</html>
EOF


cd /home/student/ex288/task2/


git init -b main
git checkout -b lab-pythonv3
git config user.name "Student"
git config user.email "student@ocp4.example.com"
git remote add origin https://developer:d3v3lop3r@git.ocp4.example.com/developer/task2-build.git
git config --global credential.helper store
echo "https://developer:d3v3lop3r@git.ocp4.example.com" > ~/.git-credentials
chmod 600 ~/.git-credentials

git add .
git commit -m "Add EX288 practice files for Task2"
git push -u origin lab-pythonv3
rm -rf /home/student/ex288/task2/apps/
