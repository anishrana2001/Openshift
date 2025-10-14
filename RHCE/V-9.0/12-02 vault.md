## Write an Ansible vault file named db-vault.yml to configure database credentials for two applications. It must do so as follows:
- Set the username `appuser1` with the password `AlphaSecure123` in the encrypted vault file `/home/student/ansible/db-vault.yml`.
- Set the username `appuser2` with the password `BetaSafe456` in the same encrypted vault file.
- The vault password should be `DBVaultStrong!,` and must be saved in `/home/student/ansible/db-secret.txt`.
---

### Solutions:
### Create the vault file:
```
ansible-vault create /home/student/ansible/db-vault.yml
```
## Add content likes below:
```
appuser1_db_pass: AlphaSecure123
appuser2_db_pass: BetaSafe456
```
### Save the vault password:
```
echo "DBVaultStrong!," > /home/student/ansible/db-secret.txt
```

### Playbook example to use these variables:
```
---
- name: Create database users with vault credentials
  hosts: all
  become: true
  vars_files:
    - /home/student/ansible/db-vault.yml
  tasks:
    - name: Add appuser1 with password from vault
      ansible.builtin.user:
        name: appuser1
        password: "{{ appuser1_db_pass | password_hash('sha512') }}"
    - name: Add appuser2 with password from vault
      ansible.builtin.user:
        name: appuser2
        password: "{{ appuser2_db_pass | password_hash('sha512') }}"
```

### Run the playbook.
```
ansible-playbook your-playbook.yml --vault-password-file /home/student/ansible/db-secret.txt
```


### Question 2: Write an Ansible vault file named `ssh-vault.yml` with SSH private keys for two users. It must do so as follows:
- Store the SSH private key for `alice` as variable `alice_private_key` in an encrypted vault file `/home/student/ansible/ssh-vault.yml`.
- Store the SSH private key for `bob` as variable `bob_private_key` in the same encrypted vault file.
- The vault password should be `StrongSSH!2025` and saved in `/home/student/ansible/ssh-pass.txt`
--- 

### Solution

### Create a vault file.
```
ansible-vault create /home/student/ansible/ssh-vault.yml
```
### Add the content.
```
alice_private_key: |
  -----BEGIN RSA PRIVATE KEY-----
  ...
  -----END RSA PRIVATE KEY-----
bob_private_key: |
  -----BEGIN RSA PRIVATE KEY-----
  ...
  -----END RSA PRIVATE KEY-----
```

### Save the vault password:
```
echo "StrongSSH!2024" /home/student/ansible/ssh-pass.txt
```


```
---
- name: Configure SSH keys using vault
  hosts: all
  become: true
  vars_files:
    - /home/student/ansible/ssh-vault.yml
  tasks:
    - name: Set alice's private key
      ansible.builtin.copy:
        dest: /home/alice/.ssh/id_rsa
        content: "{{ alice_private_key }}"
        owner: alice
        mode: '0600'
    - name: Set bob's private key
      ansible.builtin.copy:
        dest: /home/bob/.ssh/id_rsa
        content: "{{ bob_private_key }}"
        owner: bob
        mode: '0600'
```

### Run the playbook.
```
ansible-playbook your-playbook.yml --vault-password-file /home/student/ansible/ssh-pass.txt
```
