# PWN01

The binary uses scanf to take all of its input. There is also a strlen check. Using this, we can get a stack buffer overflow by adding a null byte near the beginning of the string to bypass the strlen length check. Scanf will keep reading the entire string.

Since there is no stack canary, a bufferoverflow leads to return address control, and we can ROP. However the binary blocks some syscalls, namely open. Instead, we can use the openat syscall.

Looking at the openat docs, we see:

```
   openat()
       The openat() system call operates in exactly the same way as open(), except for the differences described here.

       If the pathname given in pathname is relative, then it is interpreted relative to the directory referred to by the  file  descriptor
       dirfd (rather than relative to the current working directory of the calling process, as is done by open() for a relative pathname).

       If pathname is relative and dirfd is the special value AT_FDCWD, then pathname is interpreted relative to the current working direc‐
       tory of the calling process (like open()).

       If pathname is absolute, then dirfd is ignored.
 ```
 
 The sandbox resolves the pathname with dirfd, so if we pass an invalid dirfd, then the ptrace will resolve pathname with the invalid dirfd, allowing us to bypass the flag file path check.
 
 Then, after we have read the flag, we can just read and print it out.
 
 
