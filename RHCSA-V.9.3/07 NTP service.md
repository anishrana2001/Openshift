# Qeustion: You need to sync `servera` with ntp `classroom.example.com`




### Check the status of NTP service.
```
systemctl status chronyd.service 
```
```        
[root@servera ~]# systemctl status chronyd.service 
● chronyd.service - NTP client/server
     Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; preset: enabled)
     Active: active (running) since Sun 2025-10-05 15:39:21 UTC; 1h 0min ago
 Invocation: e8d2fb61b5274f27a73ea49a263974b5
       Docs: man:chronyd(8)
             man:chrony.conf(5)
   Main PID: 967 (chronyd)
      Tasks: 1 (limit: 9897)
     Memory: 4.4M (peak: 5.2M)
        CPU: 60ms
     CGroup: /system.slice/chronyd.service
             └─967 /usr/sbin/chronyd -F 2

Oct 05 15:39:21 servera.lab.example.com chronyd[967]: commandkey directive is no longer supported
Oct 05 15:39:21 servera.lab.example.com chronyd[967]: generatecommandkey directive is no longer supported
Oct 05 15:39:21 servera.lab.example.com chronyd[967]: Could not open keyfile /etc/chrony.keys
Oct 05 15:39:21 servera.lab.example.com chronyd[967]: Frequency -10.753 +/- 1.013 ppm read from /var/lib/chrony/drift
Oct 05 15:39:21 servera.lab.example.com chronyd[967]: Loaded seccomp filter (level 2)
Oct 05 15:39:21 servera.lab.example.com systemd[1]: Started chronyd.service - NTP client/server.
Oct 05 15:39:22 servera chronyd[967]: Source 172.25.254.254 offline
Oct 05 15:39:23 servera chronyd[967]: Source 172.25.254.254 online
Oct 05 15:39:27 servera chronyd[967]: Selected source 172.25.254.254
Oct 05 15:39:27 servera chronyd[967]: System clock wrong by 0.754377 seconds  ⬅️ ⬅️ 👈👈👈👈
[root@servera ~]# 
```

### Set the system clock. 
```
timedatectl set-ntp true 
```
```
[root@servera ~]# timedatectl set-ntp true 
[root@servera ~]# 
```

### Update the ntp server `server classroom.example.com iburst`
```
vi /etc/chrony.conf 
```
### Verify if we added correctly or not. 
```
[root@servera ~]# cat /etc/chrony.conf | grep classroom
server classroom.example.com iburst
```
```
#server 0.rhel.pool.ntp.org iburst
#server 1.rhel.pool.ntp.org iburst
#server 2.rhel.pool.ntp.org iburst
#server 3.rhel.pool.ntp.org iburst
#server 172.25.254.254 iburst    ⬅️ ⬅️ 👈👈👈👈 Comment this line
server classroom.example.com iburst     ⬅️ ⬅️ 👈👈👈👈  Added this line

# Ignore stratum in source selection.
stratumweight 0

```
### Restart the NTP service & check the status.

```
systemctl restart chronyd.service
```
```
[root@servera ~]# systemctl restart chronyd.service 
[root@servera ~]# systemctl status chronyd.service 
● chronyd.service - NTP client/server
     Loaded: loaded (/usr/lib/systemd/system/chronyd.service; enabled; preset: enabled)
     Active: active (running) since Sun 2025-10-05 16:40:53 UTC; 32s ago
 Invocation: 29a5bc908796461e9712712b5948c71a
       Docs: man:chronyd(8)
             man:chrony.conf(5)
    Process: 5453 ExecStart=/usr/sbin/chronyd $OPTIONS (code=exited, status=0/SUCCESS)
   Main PID: 5455 (chronyd)
      Tasks: 1 (limit: 9897)
     Memory: 920K (peak: 2.9M)
        CPU: 32ms
     CGroup: /system.slice/chronyd.service
             └─5455 /usr/sbin/chronyd -F 2

Oct 05 16:40:53 servera systemd[1]: Starting chronyd.service - NTP client/server...
Oct 05 16:40:53 servera chronyd[5455]: chronyd version 4.6.1 starting (+CMDMON +NTP +REFCLOCK +RTC +PRIVDROP +SCFILTER +SIGND +ASYNCDNS +NTS +SECHASH +IPV6 +DEBUG)
Oct 05 16:40:53 servera chronyd[5455]: commandkey directive is no longer supported
Oct 05 16:40:53 servera chronyd[5455]: generatecommandkey directive is no longer supported
Oct 05 16:40:53 servera chronyd[5455]: Could not open keyfile /etc/chrony.keys
Oct 05 16:40:53 servera chronyd[5455]: Frequency -14.588 +/- 0.100 ppm read from /var/lib/chrony/drift
Oct 05 16:40:53 servera chronyd[5455]: Loaded seccomp filter (level 2)
Oct 05 16:40:53 servera systemd[1]: Started chronyd.service - NTP client/server.
Oct 05 16:40:58 servera chronyd[5455]: Selected source 172.25.254.254 (classroom.example.com)  ⬅️ ⬅️ 👈👈👈👈
[root@servera ~]#
```


### Make sure you have enable NTP service. 
```
[root@servera yum.repos.d]# systemctl enable chronyd-restricted.service 
Created symlink '/etc/systemd/system/multi-user.target.wants/chronyd-restricted.service' → '/usr/lib/systemd/system/chronyd-restricted.service'.
[root@servera yum.repos.d]# 
```



