## You are the admin of `devops-wala` company and you need to install the `httpd` package on `servera`.
## You can use the below URLs:  content.example.com/rhel10.0/x86_64/dvd/BaseOS & content.example.com/rhel10.0/x86_64/dvd/AppStream

## Solution:

## Check if the `YUM` repo is available?

```
ls -ltr /etc/yum.repos.d/
```

## If not there, then you need create a file with any name but `.repo` at the end.

```
cat /etc/yum.repos.d/question12.repo 
[BaseOs]
name = BaseOs
baseurl = http://content.example.com/rhel10.0/x86_64/dvd/BaseOS
enabled = true
gpgcheck = false

[APPs]
name = Apps
baseurl = http://content.example.com/rhel10.0/x86_64/dvd/AppStream
enabled = true
gpgcheck = false
```
## Install the package.
```
dnf install httpd -y
```

### Question END.


## Read the below for more information about the Yum / DNF .
## Yum repository configuration files, typically ending with the `.repo` extension, are located in the `/etc/yum.repos.d/` directory on Red Hat-based Linux distributions like CentOS and RHEL. These files instruct the yum package manager where to find software packages.

## A typical `.repo` file contains one or more sections, each defining a repository. Each repository section starts with a unique ID enclosed in square brackets, like [repository_id].
## In our case `[BaseOs]`

## Key directives within a repository section include:
```
[]
name:
baseurl=
enabled=
gpgcheck=
gpgkey=
```
# 
- name: A human-readable name for the repository.
- baseurl: The URL or path to the repository's files. This can be an http://, https://, ftp://, or file:// address.
- enabled: A flag (0 or 1) to enable or disable the repository. 1 enables it, 0 disables it.
- gpgcheck: A flag (0 or 1) to enable or disable GPG signature checking for packages from this repository. 1 enables checking, ensuring package authenticity.
- gpgkey: The URL or path to the GPG public key used to verify package signatures `if gpgcheck is enabled`.


