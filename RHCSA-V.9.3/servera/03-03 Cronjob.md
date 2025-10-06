# Cron Job
### Question:
- Create a user named punit1
- User with UID 1238
- Users must have password `devops-wala`
- User `punit1` create a cronjob with `logger "Devops-wala Youtube channel` and it must execute every 8 minutes. 
---

### Solution:
```
[root@servera ~]# useradd -u 1238 punit1
[root@servera ~]# passwd punit1
```
```
[root@servera ~]# cat /etc/crontab 
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
```

## Special characters can be used to define specific time intervals:

### * : Any value

### , : Separate multiple values (e.g., 1,5,10)

### - : Range of values (e.g., 1-5)

### / : Skip values (e.g., */5 means every 5 minutes)
---


### Syntax of command.
```
* * * * * command to be executed
```

### Let's modify it.
```
[root@servera ~]# crontab -eu punit1
```
```
*/8 * * * * logger "Devops-wala Youtube channel"
```

```
[root@servera ~]# crontab -lu punit1 
*/8 * * * * logger "Devops-wala Youtube channel
[root@servera ~]#
```
### Post checks.
```
sudo tail -f /var/log/syslog | grep -i logger
```







## 1. Editing the Cron File
```
crontab -e
```
## 2. Add a entry and save the file, just like vi editor. 
## Below cronjob execute the command `/home/student/backup.sh` at 17:30 every day. 
```
30 17 * * * /home/student/backup.sh  
```
## 3. How to list the cronjob?
```
crontab -l
```

## 4. How to add the cronjob by user `punit1`?
```
cronjob -ue punit1
```
## 5. How to list the user cronjob?
```
cronjob -u punit1 -l
```
## 6. How to check the logs of cronjob?
```
sudo tail -f /var/log/syslog | grep -i cron
```

## Cron Daemon Options

- The cron daemon can be started, stopped, or restarted using the following commands:

- Start: sudo /etc/init.d/cron start
- Stop: sudo /etc/init.d/cron stop
- Restart: sudo /etc/init.d/cron restart




