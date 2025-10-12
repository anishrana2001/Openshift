# Question: Your task is to create a role named `mywebserver` and this role must complet the below jobs.
- Install and start the httpd web server.
- Make sure firewall is `enabled` and firewall should allow to listing web traffic.
- create a `index.html` file with below content under `/var/www/html/` directory on `webserver` host group.
  - Welcome to devops-wala web page hosted on `HOSTNAME` having ip `IP` and runing on OS `OS NAME` with architecture `Architecture details`
  - HOSTNAME = Managed node fully qulified domain name.
  - IP = Managed node IP address.
  - OS NAME = Managed node OS name.
  - Architecture details = Managed node Architecture details like x86_64
- Create a playbook with named `mywebserver.yaml`
---

## Solution: 
  
