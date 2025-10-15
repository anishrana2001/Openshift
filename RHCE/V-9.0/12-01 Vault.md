### Question 1: Write a ansible vault file named `pass-vault.yml` that creates the `anishrana2001` & `punit` users. It must do so as follows:
- You must set the password for the `anishrana2001` has the password `devops-wala` in the `pass-vault.yml` file under `/home/student/ansible/` directory. Which is encrypted with Ansible Vault. 
- The password for the `punit` user has the password `vtyshshbash` in the `pass-vault.yml` file under `/home/student/ansible/` directory, which is encrypted with Ansible Vault.
- The password for Encrypt and decrypt the vault is `ThisisaStrongpassword` and store in the `mysecret.txt` file under `/home/student/ansible/` directory.
---
	
### Solution:

### The password for Encrypt and decrypt the vault is `ThisisaStrongpassword` and store in the `mysecret.txt` file under `/home/student/ansible/` directory.
```
echo "ThisisaStrongpassword" > /home/student/ansible/mysecret.txt
```

### Update the ansible.cfg file with the new vault file location.
```
vault_password_file=/home/student/ansible/mysecret.txt
```

### Now, create a file which has users' information.
```
ansible-vault create /home/student/ansible/pass-vault.yml
```
### It will ask the password first, use this password `ThisisaStrongpassword` and then add key-value paris.
```
---
anishrana2001: devops-wala
punit: vtyshshbash
```
### Save the file and exit.

### You can see the content of this file only after givnging the right password `ThisisaStrongpassword`. 
```
[student@workstation ansible]$ ansible-vault view --ask-vault-password pass-vault.yml 
Vault password: 
---
anishrana2001: devops-wala
punit: vtyshshbash

[student@workstation ansible]$
```
---
### .
### .
---
---

### Question 2 : Your task is to update vault password from `ThisisaStrongpassword` to `aalotchale` of file `/home/student/ansible/mysecret.txt`

### Solution: 
```
ansible-vault rekey --ask-vault-pass /home/student/ansible/mysecret.txt
```

### Post checks!!
```
ansible-vault view --ask-vault-pass  /home/student/ansible/mysecret.txt
```
