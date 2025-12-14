# Ansible Vault – From Zero to Hero

## Hook (0:00 – 0:45)

Do you put real passwords inside your Ansible playbooks or `group_vars` files?  
If yes, you are in danger. Anyone with Git access can see your database password, cloud keys, or SSH keys.  
Ansible Vault solves this in a very simple way.  
In this video, you will learn Ansible Vault from zero to hero, with live examples, and in very simple English.

---

## Chapter 1 – What is Ansible Vault? (0:45 – 3:00)

### Subtitle‑friendly points

- Ansible Vault is a built‑in feature of Ansible to encrypt sensitive data like passwords, tokens, and keys.  
- It protects the data at rest on disk using AES‑256 encryption.  
- You can keep encrypted files in Git safely, because they look like random characters without the vault password.

### Explain in simple English

Think of Vault as a lock on your YAML files.  
Without the password, the file is unreadable.  
With the password, Ansible can read it automatically during a playbook run.  
You do not need another tool; Vault is already part of Ansible.

---

## Chapter 2 – When and why to use Vault (3:00 – 5:00)

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

## Chapter 3 – Lab setup (5:00 – 6:00)

Tell viewers what you use, so they can follow:

- One control node with Ansible installed.  
- A test project folder `~/ansible-vault-demo`.  
- A simple playbook `site.yml` that uses a secret variable.

No need to go deep here, just briefly show the structure:

