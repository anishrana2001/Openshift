# a) All new creating files for user `punit` as -rwx --- --- as default permission.
# b) All new creating directories for user `punit` as drwx ------ as default permission.
---

### Solution:
#### Explanation:

 -    rwx (7) for the owner: read, write, execute
 -    r-x (5) for the group: read, execute
 -    --- (0) for others: no permissions

#### Directory permission: 750

#### This permission setting allows:

  -  The owner to fully access and modify the directory.
  -  The group to read and traverse the directory.
  -  Others to have no access.
