# Question: Your taks is to select the recommended `tuned` profile for the `servera` and set it as defult.

### Solution

```
[root@servera ~]# dnf install tuned -y

[root@servera ~]# systemctl status tuned.service 
● tuned.service - Dynamic System Tuning Daemon
     Loaded: loaded (/usr/lib/systemd/system/tuned.service; enabled; preset: enabled)
     Active: active (running) since Sun 2025-10-05 13:35:04 UTC; 1h 2min ago
 Invocation: 4068c40d7142466f98d305acfff734b0
       Docs: man:tuned(8)
             man:tuned.conf(5)
             man:tuned-adm(8)
   Main PID: 1042 (tuned)
      Tasks: 4 (limit: 9897)
     Memory: 17.5M (peak: 19M)
        CPU: 1.175s
     CGroup: /system.slice/tuned.service
             └─1042 /usr/bin/python3 -Es /usr/sbin/tuned -l -P

Oct 05 13:35:04 servera systemd[1]: Starting tuned.service - Dynamic System Tuning Daemon...
Oct 05 13:35:04 servera systemd[1]: Started tuned.service - Dynamic System Tuning Daemon.
```
### Command `systemctl enable --now tuned.service` will start and enable the service. So you don't need to run 2 commands. i.e. `systemctl start service_name & `systemctl enable service_name`

```
[root@servera ~]# systemctl enable --now tuned.service
```

### As per the question, check for recommend. Remember the key word `recommend`
```
[root@servera ~]# tuned-adm recommend 
virtual-guest
```

```
[root@servera ~]# tuned-adm profile virtual-guest 

[root@servera ~]# tuned-adm active 
Current active profile: virtual-guest
[root@servera ~]#
```
