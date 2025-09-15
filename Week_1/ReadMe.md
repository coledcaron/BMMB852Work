# BMMB852Work

## Q: What version is your samtools command in the bioinfo environment?

``` samtools --version ```

### Output:
```
samtools 1.22.1 <br>
Using htslib 1.22.1 <br>
Copyright (C) 2025 Genome Research Ltd.
```
## Q: Show commands needed to create a nested directory structure.

```
mkdir first
cd first
mkdir second
cd second
```


### Output: 
A folder labeled "second" within another folder labeled "first"

## Q: Show commands that create files in different directories.
```
touch first/second/third.txt
touch first/fourth.txt
```
### Output: 
A text file named "third" in "second" folder and a text file named "fourth" in "first" folder.

## Q: Show how to access these files using relative and absolute paths.

Relative Paths:
```
cat first/second/third.txt
cat first/fourth.txt
```
Absolute Paths:
```
cat Users/colecaron/first/second/third.txt
cat Users/colecaron/first/fourth.txt
```

### Output: 
Displays the contents of third.txt or fourth.txt respectively. The relative path would work on any device that has run the previous code, while the absolute path only works on my computer (or any computer with the same filesystem).

