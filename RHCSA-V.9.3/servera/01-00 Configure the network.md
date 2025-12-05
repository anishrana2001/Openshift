## Your task is to configure the network details on servera.


 - Hostname : servera.lab.example.com
 - IP Address : 192.168.1.10
 - Netmask : 255.255.255.0
 - Gateway : 192.168.1.1
 - Nameserver: 192.168.1.1
---
### First, you should login into the machine with given root user and password.

### How to set the hostname?
```
hostnamectl set-hostname servera.lab.example.com
```

#### Post checks for hostname ?
```
hostnamectl
```

### How to set the gateway and Nameserver ?
```
nmcli connection modify "Wired connection 1" ipv4.addresses 192.168.1.10/24  ipv4.gateway 192.168.1.1 ipv4.dns 192.168.1.1 ipv4.method manual
```

```
nmcli connection up "Wired connection 1"
```

```
ping 192.168.1.1
```
