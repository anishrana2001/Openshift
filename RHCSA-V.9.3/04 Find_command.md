## Prepare the lab for this question.
```

```
# Find Command.


## Prepare the lab for this question.
```

```
## Question 1. Locate all the files with name `devops.txt` in the `/home/student` directory.
```

```

## Question 2. Locate all the files with name `devops.txt` in the `/home/student` directory and save in the /data/question2.txt
```

```

## Question 3. Locate all the files with name `devops.txt` in the `/home/student` directory but owned by user `punit` and copy it under `/data/question3-files`.
```

```

## Question 4. Locate all the files which are owned by user `punit` and copy it under `/data/question4-files/flower`.
```
mkdir -p /data/question4-files/flower 
find / -user punit 
find / -user punit -exec cp -rvf {} /data/question4-files/flower/ \;
ls -latr /data/question4-files/flower/

```

## Qestion 5. Create a script named `question5-find.sh` under `/usr/local/bin` directory and this script must locate all the regular files which are less than `1M` under `/usr/share` directory and save the searched file paths under `/root/question5-find-output.txt` file.

### Solution:
### Create a command.

- path-to-find : /usr/share/
- Regular file: `-type f`
- Size : Less than 1M = `-1M`
- Save Searched files path to `/root/question5-find-output.txt`

### syntax
```
find /path-to-find -type f -size 1M > /root/question5-find-output.txt
```

```
echo "find /path-to-find -type f -size 1M > /root/question5-find-output.txt"
```
### Save the content on mentioned file `/usr/local/bin/question5-find.sh`
```
echo "find /usr/share/ -type f -size -1M > /root/question5-find-output.txt" > /usr/local/bin/question5-find.sh
```
### Give the execute permission.
```
chmod +x /usr/local/bin/question5-find.sh
```
## Run the script. Since the path is `/usr/local/bin` directory. You can execute this command without absolute path. 
## You can also verify it.
```
echo $PATH
```
```
question5-find.sh
```
### Post check!
```
cat /root/question5-find-output.txt
```
