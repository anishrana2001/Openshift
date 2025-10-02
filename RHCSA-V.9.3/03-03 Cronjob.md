# Cron Job

## Create a user named punit1
## Create a user named rajesh with UID 1238
## Users must have password `devops-wala`

## User `punit1` create a cronjob with `logger "Devops-wala Youtube channel"` and it must execute every 8 minutes. 
---

### Solution:
```
[root@servera ~]# useradd -u 1238 punit1
[root@servera ~]# passwd punit1
```
### Syntax of command.
```
* * * * * command to be executed
```

### Let's modify it.
```
*/8 * * * * logger "Devops-wala Youtube channel"
```



### * * * * * command to be executed
### 
### - - - - -

### | | | | |

### | | | | +----- day of the week (0 - 6) (Sunday=0)

### | | | +------- month (1 - 12)

### | | +--------- day of the month (1 - 31)

### | +----------- hour (0 - 23)

### +------------- min (0 - 59)
---

## Special characters can be used to define specific time intervals:

### * : Any value

### , : Separate multiple values (e.g., 1,5,10)

### - : Range of values (e.g., 1-5)

### / : Skip values (e.g., */5 means every 5 minutes)
---

## 1. Editing the Cron File
## crontab -e
## 2. Add a entry and save the file, just like vi editor. 
## Below cronjob execute the command `/home/student/backup.sh` at 17:30 every day. 
```
30 17 * * * /home/student/backup.sh  
```
## 3. How to list the cronjob?
```
crontab -l
```

## 4. How to add the cronjob by user `harry`?
```
cronjob -ue harry
```
## 5. How to list the user cronjob?
```
cronjob -u harry -l
```


## Cron Daemon Options

- The cron daemon can be started, stopped, or restarted using the following commands:

- Start: sudo /etc/init.d/cron start
- Stop: sudo /etc/init.d/cron stop
- Restart: sudo /etc/init.d/cron restart



