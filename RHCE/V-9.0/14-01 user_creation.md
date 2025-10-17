### From the below task, we get to know that how to call the variables from multipl files. For an example, let's add the users.

### Question: Your task is to create a user and then add a secondary group. Perform the below tasks
- Download the user list from `https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCE/V-9.0/user_list-14-01.yaml`
- Use the Vault password file `/home/student/ansible/pass-vault.yml` that you created on task 12-01.
- Use the job description `manager`
  -   create a user on `lab` host managed group.
  -   use the password `pw_punit` variable.
  -   It should be the part of `devops` group.
- Use the job description `engineer`.
  - Create a user on `myprod` and `prodcution` host managed group.
  - Assign the password `pw_rajan`
  - The secondary group should be `mon_agent`.
- Password should use `SHA512` hash format.
- Create a playbook called `myuser-list.yaml` under `/home/student/ansible` directory.
