# Question 1: You are the adminstrator of devops-wala company and you need to perform below tasks.

- Create a two groups called `admin` and `devops`
- Creata a users
    - `punit` users must be the part of `admin` group. Or you can say that Add `admin` group as a seconday group of these users.
    - User `punit` should have `1234` UID and Add the comment `For OCP Cluster`
    - User `punit` should have home directory `/home/ocp-cluster/`.
    - User `punit` should have login shell `/bin/bash`
    - User `rajan` shoudl have `1235` UID and Add the comment `For Database Cluster`
    - User `rajan` shoudl have home directory `/home/database-cluster`
    - User `rajan` should have login shell `/bin/sh`
     - `harry` users must be the part of `devops` group. Or you can say that Add `devops` group as a seconday group of these users.
    - User `harry` should have `1334` UID and Add the comment `For OCP Cluster`
    - User `harry` should have home directory `/home/harry/`.
    - User `harry` should have login shell `/bin/bash`
    - User `peter` shoudl have `1335` UID and Add the comment `For Database Cluster`
    - User `peter` shoudl have home directory `/home/peter`
    - User `peter` should have login shell `/bin/sh`
- Create a user `mon_ocp` and this user should have non=interactive shell and it should not the part of `devops` and `admin` groups
- All users must have password `devops-wala`.
