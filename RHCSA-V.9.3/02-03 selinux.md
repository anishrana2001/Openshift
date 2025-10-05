## Prepare the lab. 
```
dnf install httpd -y
sed -i 's/Listen 80/Listen 85/' /etc/httpd/conf/httpd.conf | grep Listen

```

## Question: One web server is running on port `85` and it is not working properly. You need to diganose the issue and resolve it.


## Solution:

### The web server should be started
```
systemctl start httpd.service
```
### Application must be running even after the VM or host machine rebooted.
```
systemctl enable httpd.service
```

## If web server service is running fine and syntax is also good, then you need to check the Selinux context. 
```
semanage port -l | grep http
```

### If the mentioned port is not added then add it.
```
semanage port -a -t http_port_t -p tcp 85
```

### Verify it again. 
```
semanage port -l | grep http
```
### Add the mentioned port in the Firewall list. 
```
firewall-cmd --permanent --add-port=85/tcp
```
### After adding the ports, we need to reload the firewall services. 
```
 firewall-cmd --reload
```

### Verify the port if it is added correctly ?

```
firewall-cmd --list-all
```

### For your references.

```


[root@servera yum.repos.d]# semanage port -l | grep http
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
pegasus_https_port_t           tcp      5989
[root@servera yum.repos.d]# semanage port -a -t http_port_t -p tcp 85

[root@servera yum.repos.d]# semanage port -l | grep http
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
http_port_t                    tcp      85, 80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
pegasus_https_port_t           tcp      5989


[root@servera yum.repos.d]# Environment=OPTIONS=""

[root@servera yum.repos.d]# systemctl start httpd.service

[root@servera yum.repos.d]# systemctl enable httpd.service

[root@servera yum.repos.d]# firewall-cmd --permanent --add-port=85/tcp
success
[root@servera yum.repos.d]#

[root@servera yum.repos.d]# firewall-cmd --reload 
success
[root@servera yum.repos.d]# firewall-cmd --list-all
public (default, active)
  target: default
  ingress-priority: 0
  egress-priority: 0
  icmp-block-inversion: no
  interfaces: ens3 ens4
  sources: 
  services: cockpit dhcpv6-client ssh
  ports: 85/tcp
  protocols: 
  forward: yes
  masquerade: no
  forward-ports: 
  source-ports: 
  icmp-blocks: 
  rich rules: 

```
