# Your taks are 
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

```
student@workstation:~$ cat .bash_profile 
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs
 umask 006    ### 
student@workstation:~$

student@workstation:~$ touch file9
student@workstation:~$ ls -ltr file9
-rw-rw----. 1 student student 0 Oct  3 09:58 file9
student@workstation:~$

student@workstation:~$ mkdir dir
student@workstation:~$ ls -ld dir/
drwxrwx--x. 2 student student 6 Oct  3 09:58 dir/
student@workstation:~$

```
