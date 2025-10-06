# tar Command to Compress Files in Linux 
# The tar command is commonly used to compress files in Linux when combined with options like -z (gzip) or -j (bzip2).

# The Linux 'tar' stands for tape archive, which is used to create Archive and extract the Archive files. tar command in Linux is one of the important commands that provides archiving functionality in Linux.

# Syntax of `tar` command in Linux
```
tar [options] [archive-file] [file or directory to be archived]
```

### Options

- c : Create an archive
- x : Extracts files & directories from an existing archive.
- f : Specifies the filename of the archive to be created or extracted.
- v : Displays verbose information
- z : Uses gzip compression when creating a tar file (tar.gz)
- j : Uses bzip2 compression when creating a tar file (tar.bz2)
- t : Displays or lists the files and directories contained within an archive.

## Question: Create a backup by using tar file `/root/test1.tar.gz` from the `/var/log/` directories. 
- z : this option is for `tar.gz` or `tar.tgz`
- c : create a tar file.
- v : Verbose mode.
- f : Specifies the filename of the archive.
```
tar cvfz /root/test.tar.gz /var/log/*
```

## Question: Create a backup by using tar file `/root/test2.tar.bz2` from the `/var/log/` directories. 
- j : this option is for `tar.bz2` or `tar.tbz2`
```
tar cvfj /root/test.tar.gz /var/log/*
```

## Question: Your task is to extract the tar file `/root/test1.tar.gz` 
- x : Extract the file

```
tar zxvf /root/test1.tar.gz
```

## Question: Your task is to extract the tar file `/root/test2.tar.bz2`
- x : Extract the file

```
tar jxvf /root/test2.tar.bz2
```


