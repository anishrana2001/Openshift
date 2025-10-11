### Create a playbook file `/home/student/ansible/apps1.yaml`
- Install `php` and `httpd` packages on `lab`, `preprod` and `production` groups.
- Install `nginx` on `myprod` group.
- Update all packages to the latest version on group `myprod` and perform below tasks.
  - create user `rajan` on this server with UID 1330 , secondary group `devops-wala`, login shell should be `/bin/bash` and comment should be `OCP cluster`
  - Create a group called `devops-wala`.
  - Create a non login shell user `mon_ocp`
---
