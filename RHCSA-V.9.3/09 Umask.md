# Task 1. Your taks are 
- a) All new creating files for user `rajan` as -rw- rw- --- as default permission.
- b) All new creating directories for user `rajan` as drwx rwx --x as default permission.
---

### Solution:

Default Permission for Files is     : 666
Default Permission for Directory is : 777

#### For file: 
#### The permissions -rw- rw- --- correspond to 660 in numeric form.
#### Umask = (File Permission - Default permission)
#### umask = (666 - 660)
#### umask = 006
#### Explanation:

 -    rwx (7) for the owner: read, write, execute
 -    r-x (5) for the group: read, execute
 -    --- (0) for others: no permissions

#### Directory permission: 750

#### This permission setting allows:

  -  The owner to fully access and modify the directory.
  -  The group to read and traverse the directory.
  -  Others to have no access.

### Soution:

### Edit the .bash_profile file with `umask 006 `
```
vi .bash_profile
```
### Post checks for file: Create a file and then check the permission
### First, we need to source this file.
```
source .bash_profile
```
```
touch file9
```
```
ls -ltr file9
```
### Post checks for Directory: Create a directory and then check the directory permission.

```
mkdir dir
```
```
ls -ld dir/
```


### For your references.
```
rajan@workstation:~$ cat .bash_profile 
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
 umask 006    ### 🤖 ✅ Added this line only
rajan@workstation:~$

rajan@workstation:~$ touch file9
rajan@workstation:~$ ls -ltr file9
-rw-rw----. 1 rajan rajan 0 Oct  3 09:58 file9
rajan@workstation:~$

rajan@workstation:~$ mkdir dir
rajan@workstation:~$ ls -ld dir/
drwxrwx--x. 2 rajan rajan 6 Oct  3 09:58 dir/
rajan@workstation:~$

```



# Task 2. Your taks are 
- a) All new creating files for user `rajan` as -r-- r-- --- as default permission.
- b) All new creating directories for user `rajan` as dr-x r-x --x as default permission.
---

### Solution:
### Edit the file `.bash_profile` with umask 226
```
vi .bash_profile
```
```
source .bash_profile
touch file1 ; ls -l file1
mkdir dir1; ls -ld dir1
```

### For your reference.
```
rajan@workstation:~$ vi .bash_profile

rajan@workstation:~$ cat .bash_profile 
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
 umask 226   ### 🤖 ✅ Added this line only
rajan@workstation:~$


rajan@workstation:~$ source .bash_profile 

rajan@workstation:~$ touch file1 ; ls -l file1
-r--r-----. 1 rajan rajan 0 Oct  3 13:57 file1

rajan@workstation:~$ mkdir dir1; ls -ld dir1
dr-xr-x--x. 2 rajan rajan 6 Oct  3 13:57 dir1
rajan@workstation:~$
```



# Task 3. Your taks are 
- a) All new creating files for user `rajan` as -r-- --- --- as default permission.
- b) All new creating directories for user `rajan` as dr-x --x --x as default permission.
---

### Solution:
### Edit the file `.bash_profile` with umask 266
```
vi .bash_profile
```
```
source .bash_profile
touch file2 ; ls -l file2
mkdir dir2; ls -ld dir2
```
### For your references.

```
rajan@workstation:~$ vi .bash_profile 

rajan@workstation:~$ mkdir dir2; ls -ld dir2
dr-x--x--x. 2 rajan rajan 6 Oct  3 14:02 dir2
rajan@workstation:~$ cat .bash_profile
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
 umask 266   ### 🤖 ✅ Added this line only
rajan@workstation:~$

rajan@workstation:~$ source .bash_profile 

rajan@workstation:~$ touch file2 ; ls -l file2
-r--------. 1 rajan rajan 0 Oct  3 14:01 file2

```
