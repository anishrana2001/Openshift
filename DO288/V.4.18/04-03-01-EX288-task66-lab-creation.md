
<div align="center">

# 🔴 EX288 Task 04-03-01

## Build trigger

![OpenShift](https://img.shields.io/badge/OpenShift-4.18-EE0000?logo=redhatopenshift&logoColor=white)
![Build](https://img.shields.io/badge/Buildpush-2496ED?logo=docker&logoColor=white)
![Project](https://img.shields.io/badge/task66-7B42BC)
![Guide](https://img.shields.io/badge/Guide-Student_Ready-2EA44F)

</div>

---

## 🧪 How to Prepare the Lab?

Run these commands on the workstation as the `student` user. They download the
practice repository, initialize it as a Git repository, and push it to the lab
Git server.

> [!NOTE]
> Use these preparation commands on a fresh lab environment. Do not change the
> application files before attempting the task.

```bash
# 1. Create project and directories. 
oc new-project task66
mkdir -p /home/student/git/task66-python-webserver
cd /home/student/git/task66-python-webserver

# 2. Git Inint
git init

# 3. Create Python Application

cat <<EOF > app.py
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Welcome to python-webserver EX288 Lab"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
EOF

# 4. Create Python Requirements

cat <<EOF > requirements.txt
Flask==3.0.0
EOF


# 5. Commit Application Source

git config user.name "Student"
git config user.email "student@ocp4.example.com"

git add .

git commit -m "Initial Python webserver application"


# 6. Push Application to Git Server


git branch -M main

git remote add origin \
https://developer:d3v3lop3r@git.ocp4.example.com/developer/task66-python-webserver.git

git push -u origin main


# 7. Create External Build Script


mkdir -p /home/student/ex288/task66

cat <<EOF > /home/student/ex288/task66/code66.py
#!/usr/bin/env python3

print("================================")
print("code66.py executed successfully")
print("Post build task completed")
print("================================")
EOF

### Make executable:
chmod +x /home/student/ex288/task66/code66.py

# 8. Create ConfigMap for Build Script

## Since Git is read-only, store the script externally.

oc create configmap code66-script --from-file=/home/student/ex288/task66/code66.py

oc get configmap


# 9. Create Python S2I BuildConfig

oc new-build \
--strategy=source \
--image-stream=python:3.11-ubi9 \
https://developer:d3v3lop3r@git.ocp4.example.com/developer/task66-python-webserver.git \
--name=python-webserver

oc new-app python-webserver:latest
oc expose svc python-webserver

oc get all
```

## Task : A Python3 application named `python-webserver` is running under project `task66`.
A predefined script named `code66.py` under `/home/student/ex288/task66/` is available for you.

Your tasks are to 

- The application is running and available at http://python-webserver-task66.apps.ocp4.example.com
- After a build finished, script `code66` executed at the end.
- This script must be available for future build.
- User has Readonly privileges on GIT repo. 


