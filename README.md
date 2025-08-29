# BMMB852Work

## Q: What version is your samtools command in the bioinfo environment?

``` samtools --version ```

### Output:
samtools 1.22.1
Using htslib 1.22.1
Copyright (C) 2025 Genome Research Ltd.

Samtools compilation details:
    Features:       build=configure curses=yes 
    CC:             x86_64-apple-darwin13.4.0-clang
    CPPFLAGS:       -D_FORTIFY_SOURCE=2 -isystem /Users/colecaron/micromamba/envs/bioinfo/include -mmacosx-version-min=10.15
    CFLAGS:         -Wall -march=core2 -mtune=haswell -mssse3 -ftree-vectorize -fPIC -fstack-protector-strong -O2 -pipe -isystem /Users/colecaron/micromamba/envs/bioinfo/include -fdebug-prefix-map=/opt/mambaforge/envs/bioconda/conda-bld/samtools_1752528673986/work=/usr/local/src/conda/samtools-1.22.1 -fdebug-prefix-map=/Users/colecaron/micromamba/envs/bioinfo=/usr/local/src/conda-prefix
    LDFLAGS:        -Wl,-headerpad_max_install_names -Wl,-dead_strip_dylibs -Wl,-rpath,/Users/colecaron/micromamba/envs/bioinfo/lib -L/Users/colecaron/micromamba/envs/bioinfo/lib
    HTSDIR:         
    LIBS:           
    CURSES_LIB:     -ltinfow -lncursesw

HTSlib compilation details:
    Features:       build=configure libcurl=yes S3=yes GCS=yes libdeflate=yes lzma=yes bzip2=yes plugins=yes plugin-path=/Users/colecaron/micromamba/envs/bioinfo/libexec/htslib htscodecs=1.6.4
    CC:             x86_64-apple-darwin13.4.0-clang
    CPPFLAGS:       -D_FORTIFY_SOURCE=2 -isystem /Users/colecaron/micromamba/envs/bioinfo/include -mmacosx-version-min=10.15
    CFLAGS:         -Wall -march=core2 -mtune=haswell -mssse3 -ftree-vectorize -fPIC -fstack-protector-strong -O2 -pipe -isystem /Users/colecaron/micromamba/envs/bioinfo/include -fdebug-prefix-map=/opt/mambaforge/envs/bioconda/conda-bld/htslib_1752523221334/work=/usr/local/src/conda/htslib-1.22.1 -fdebug-prefix-map=/Users/colecaron/micromamba/envs/bioinfo=/usr/local/src/conda-prefix -fvisibility=hidden
    LDFLAGS:        -Wl,-headerpad_max_install_names -Wl,-dead_strip_dylibs -Wl,-rpath,/Users/colecaron/micromamba/envs/bioinfo/lib -L/Users/colecaron/micromamba/envs/bioinfo/lib -fvisibility=hidden -rdynamic

HTSlib URL scheme handlers present:
    built-in:	 file, preload, data
    Google Cloud Storage:	 gs+http, gs+https, gs
    libcurl:	 gophers, smtp, wss, smb, rtsp, tftp, pop3, smbs, imaps, pop3s, ws, ftps, ftp, gopher, imap, http, https, sftp, smtps, scp, dict, mqtt, telnet
    S3 Multipart Upload:	 s3w+https, s3w+http, s3w
    Amazon S3:	 s3+https, s3, s3+http
    crypt4gh-needed:	 crypt4gh
    mem:	 mem

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

