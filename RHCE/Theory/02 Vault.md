# Ansible Vault – From Zero to Hero

## 

Do you put real passwords inside your Ansible playbooks or `group_vars` files?  
If yes, you are in danger. Anyone with Git access can see your database password, cloud keys, or SSH keys.  
Ansible Vault solves this in a very simple way.  
In this video, you will learn Ansible Vault from zero to hero, with live examples, and in very simple English.

---

## Chapter 1 – What is Ansible Vault? 

- Ansible Vault is a built‑in feature of Ansible to encrypt sensitive data like passwords, tokens, and keys.  
- It protects the data at rest on disk using AES‑256 encryption.  
- You can keep encrypted files in Git safely, because they look like random characters without the vault password.

### Explain in simple English

Think of Vault as a lock on your YAML files.  
Without the password, the file is unreadable.  
With the password, Ansible can read it automatically during a playbook run.  
You do not need another tool; Vault is already part of Ansible.

---

## Chapter 2 – When and why to use Vault 

### Common use cases

- Store database passwords, API tokens, SSH private keys.  
- Store production inventory variables like `db_password`, `admin_user`, `cloud_secret`.  
- Store any file that must not be visible in plain text but still must live in Git.

### Value‑added advantages

- Files are safe to commit to Git, because they are encrypted.  
- Works smoothly with normal Ansible: the playbook does not change, only the variables are encrypted.  
- Very low setup effort: just one command‑line tool `ansible-vault` and a password.  
- Flexible: you can encrypt full files or only single values using `encrypt_string`.

---

## Chapter 3 – Lab setup 

Tell viewers what you use, so they can follow:

- One control node with Ansible installed.  
- A test project folder `~/ansible-vault-demo`.  
- A simple playbook `site.yml` that uses a secret variable.

### Step 1: Create Vault File
```
ansible-vault create group_vars/webservers/vault.yml
```

```
db_password: "MySuperSecretDBPass123"
api_key: "sk-abc123def456ghi789"
```

### Step 2: View & Edit Vault 
  - View: `ansible-vault view group_vars/webservers/vault.yml` (prompts password).

  - Edit: `ansible-vault edit group_vars/webservers/vault.yml` (add backup_pass: "backup123").

  - Warning: Use strong, unique passwords; store securely (not in repo). [Green Check: ✓ Readable only with pass] [Subtitle: "View without decrypting—secure!"]


### Step 3: Playbook Using Vault
  - Create `install_lamp.yml`:
```
---
- hosts: webservers
  vars_files:
    - group_vars/webservers/vault.yml
  tasks:
    - name: Install Apache + MySQL
      dnf:
        name: ['httpd', 'mariadb-server']
        state: present
    - name: Set DB root password
      mysql_user:
        name: root
        password: "{{ db_password }}"
        state: present
    - name: Debug API key (masked)
      debug:
        msg: "API Key starts with: {{ api_key[:8] }}***"
```

  - Run: `ansible-playbook  install_lamp.yml --ask-vault-pass`


### Step 4: Advanced: Password File 
  - Create a vault file and give `600` file permission.
```
echo -n "vault123!Secure" > .vault_pass.txt
```
```
chmod 600 .vault_pass.txt
```
  - Run the ansible playbook:
```
ansible-playbook install_lamp.yml --vault-password-file .vault_pass.txt
```
  - Env the variable then run without flags.
```
export ANSIBLE_VAULT_PASSWORD_FILE=.vault_pass.txt 
```
```
ansible-playbook install_lamp.yml  .vault_pass.txt
```

### Step 5: Rekey, Decrypt & Best Practices
  - Rekey: ansible-vault rekey vault.yml (change password).
  - Decrypt (rare): ansible-vault decrypt vault.yml.

#### Tips:

  - Multiple vaults: --vault-id prod@site1:vault.yml
  - Integrate with Git: .gitignore vaults; use vault-id for teams.
#### Cleanup & Next Steps
```
ansible-vault encrypt group_vars/webservers/vault.yml  # Re-encrypt if needed
rm .vault_pass.txt  # Secure delete
```
