# Question: You need to set the banner "Welcome to my Youtube Channel 'devops-wala'" for user `punit`. Make sure, whenever he login, you should observe this banner.

### Solution

## Login with `punit` user
```
su - punit
```

### Modify the file `.bash_profile` and add last 2 lines. Save and exit from file.
```
# User specific environment and startup programs
export My_exam="Welcome to my Youtube Channel 'devops-wala'"
echo $My_exa
```

### Logout from `punit` user and login again. You should see the banner.

```
su - punit
```
