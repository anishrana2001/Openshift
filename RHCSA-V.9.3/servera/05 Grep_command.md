## Qeustion 1: Find the string `err` from `/var/log/message` file and save the output in the `/root/err.log` file.


## Qeustion 2: Find the string `err` from `/var/log/message` file and save the output in the `/root/err.log` file.

## Qeustion 3: Find the string `err` or `ERR` or `Err` from `/var/log/message` file and save the output in the `/root/err.log` file.

## Qeustion 4: Find the string `err` along with line number from `/var/log/message` file and save the output in the `/root/err.log` file.


# The `grep` command in Linux is a powerful utility used for searching plain-text data sets for lines that match a regular expression. Here are several examples demonstrating its usage:

## Step 1. Basic Search in a Single File:
```
grep "error" logfile.txt
```

## Step 2. Case-Insensitive Search:
### To search for a pattern ignoring case (e.g., "python", "Python", "PYTHON", PytHon), use the -i option:
```
grep -i "python" /var/log/messsage
```


## Step 3. Invert Match (Show Non-Matching Lines):
## To display lines that do not contain a specific pattern, we can use `-v` option: 
```
grep -v warning /var/log/httpd/logs
```
### Or
```
grep -vi warning /var/log/httpd/logs
```


## Step 4. Using grep with Pipes:
### grep is often used in conjunction with other commands via pipes (|) to filter their output. For instance, searching `error` keyword while running python script.
```
python my_network.py | grep  "error"
```

## Step 5. Display Line Numbers:
### To show the line number where the pattern is found, one can use the -n option:
```
grep -n "error" output.log
```

