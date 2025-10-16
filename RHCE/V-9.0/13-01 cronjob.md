## Prepare the lab
```
curl -o usercreation_cronjob.yaml https://raw.githubusercontent.com/anishrana2001/Openshift/refs/heads/main/RHCE/V-9.0/usercreation_cronjob.yaml
ansible-navigator run usercreation_cronjob.yaml -m stdout
```

### Your task is to create a cronjob 
- name of the cron should be `anishrana2001`
- User `rajan` should execute `logger "Youtube Channel devops-wala"` every 7 minutes. 
- Create a cronjob playbook with named `mycron.yaml` and it should run only on `lab` host group.
---

### Solution:

## Take a reference from
```
ansible-doc cron
```


### For your references.
```
[student@workstation ansible]$ vim mycron.yaml 

[student@workstation ansible]$ cat mycron.yaml 
---
- name: cron
  hosts: lab
  tasks:
    - name: Ensure a job that runs at 2 and 5 exists. Creates an entry like "0 5,2 * * ls -alh > /dev/null"
      ansible.builtin.cron:
        name: "check dirs"
        minute: "*/7"
        job: 'logger "Youtube Channel devops-wala"'
        user: rajan
  



[student@workstation ansible]$ ansible-navigator run mycron.yaml -m stdout

PLAY [cron] ********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [servera]

TASK [Ensure a job that runs at 2 and 5 exists. Creates an entry like "0 5,2 * * ls -alh > /dev/null"] ***
changed: [servera]

PLAY RECAP *********************************************************************
servera                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


[student@workstation ansible]$  ansible servera -m shell -a 'crontab -l -u rajan'
servera | CHANGED | rc=0 >>
#Ansible: check dirs
*/7 * * * * logger "Youtube Channel devops-wala"
[student@workstation ansible]$ 

```
