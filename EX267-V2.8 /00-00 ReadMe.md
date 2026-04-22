# 🚀 OpenShift EX267 Certification Guide (v2.8)

Welcome to the complete OpenShift EX267 preparation course.

- You can push the images on Redaht registry `registry.ocp4.example.com:8443`
- One can use the S3 URL `https://minio-ui-minio.apps.ocp4.example.com`.
- `admin` user can use the URL `https://console-openshift-console.apps.ocp4.example.com`
- The password of RHOC is `redhatocp`.
- S3 credentials is `minio` and password is `minio123`
- One can use users name `developer` and same password to upload the images.

| Module | Topic | Link |
|--------|------|------|
|Machine name                |	IP addresses |	Role|
|workstation.lab.example.com |	172.25.250.9	|Graphical workstation for system administration|
|classroom.example.com 	|172.25.254.254	|Router to link the Classroom network to the internet|
|bastion.lab.example.com |	172.25.250.254	|Router to link the Student network to the Classroom network|
|utility.lab.example.com |	172.25.250.253|	Router to link the Student and Cluster networks|
|ceph.ocp4.example.com |	192.168.50.30	|Server with a Red Hat Storage Ceph preinstalled cluster|
|registry.ocp4.example.com |	192.168.50.50|	Server with Quay and GitLab|
|master01.ocp4.example.com |	192.168.50.10	|Control plane node|
|master02.ocp4.example.com |	192.168.50.11	|Control plane node|
|master03.ocp4.example.com |	192.168.50.12	|Control plane node|
|worker01.ocp4.example.com |	192.168.50.13	|Compute node|
|worker02.ocp4.example.com |	192.168.50.14	|Compute node|
|worker03.ocp4.example.com | 192.168.50.15	|Compute node|

## 📚 Course Modules

| Module | Topic | Link |
|--------|------|------|
| 00 | Course Overview | [Start Here](./00-Course-Overview/01-About-Course.md) |
| 01 | OpenShift Architecture | [View](./01-OpenShift-Architecture/) |
| 02 | Projects & Applications | [View](./02-Projects-and-Applications/) |
| 03 | Builds & Images | [View](./03-Builds-and-Images/) |
| 04 | Storage | [View](./04-Storage/) |
| 05 | Networking | [View](./05-Networking/) |
| 06 | Security | [View](./06-Security/) |
| 07 | Troubleshooting | [View](./07-Troubleshooting/) |
| 08 | Practice Tests | [View](./08-Practice-Tests/) |

---

## 🎯 Who is this for?
- DevOps Engineers
- Kubernetes Users
- OpenShift Beginners

---

## 🧪 Exam Tips
- Focus on hands-on
- Practice CLI (`oc`)
- Time management is key

---

## ⭐ Support
If you like this repo, give it a ⭐
