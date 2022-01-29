# QLaaS

Category: Clone-And-Pwn

Solves: 23

Solve by: jinmo123

Points: 182

---

## Challenge Description

> Qiling as a Service.
> 
> ```
> nc 47.242.149.197 7600
> ```
> 
> [QLaaS_61a8e641694e10ce360554241bdda977.tar.gz](https://realworldctf-attachment.oss-accelerate.aliyuncs.com/QLaaS_61a8e641694e10ce360554241bdda977.tar.gz)
> 
> Note: read flag using `/readflag`

[Qiling Framework](https://github.com/qilingframework/qiling) is a binary emulation framework
based on unicorn engine with some level of OS emulation support e.g. system calls, Windows APIs.

Example from the official GitHub repository:

```python
from qiling import *

# sandbox to emulate the EXE
def my_sandbox(path, rootfs):
    # setup Qiling engine
    ql = Qiling(path, rootfs)
    # now emulate the EXE
    ql.run()

if __name__ == "__main__":
    # execute Windows EXE under our rootfs
    my_sandbox(["examples/rootfs/x86_windows/bin/x86_hello.exe"], "examples/rootfs/x86_windows")
```

When a file access happens inside the loaded programs, it tries to translate the path into a path inside the root filesystem,
so `open("/", O_RDONLY)` becomes `open("/tmp/...random rootfs path", O_RDONLY)`.
However, this is skipped on `openat` calls.

```python
def ql_syscall_open(ql: Qiling, filename: int, flags: int, mode: int):
    path = ql.os.utils.read_cstring(filename)
    real_path = ql.os.path.transform_to_real_path(path)
    relative_path = ql.os.path.transform_to_relative_path(path)

...

def ql_syscall_openat(ql: Qiling, fd: int, path: int, flags: int, mode: int):
    file_path = ql.os.utils.read_cstring(path)
    # real_path = ql.os.path.transform_to_real_path(path)
    # relative_path = ql.os.path.transform_to_relative_path(path)

...
            ql.os.fd[idx] = ql.os.fs_mapper.open_ql_file(file_path, flags, mode, dir_fd)
```

The file path is passed to `open_cl_file`, which also skips the path translation when `dir_fd` is given.

```python
    def open_ql_file(self, path, openflags, openmode, dir_fd=None):
    ...
            if dir_fd:
                return ql_file.open(path, openflags, openmode, dir_fd=dir_fd)
```

`ql_file.open` does `os.open` without further conversion of the given path. As a result, attackers can escape the
root filesystem path like this:

```c
int dirfd = open("/", O_RDONLY);
int fd = openat(dirfd, "../../../proc/self/mem", O_RDWR);
```

This challenge runs in Linux, and `/proc/self/mem`, `/proc/self/maps` is available for read/writing.
Since `/proc/self/mem` reflects the memory of the current process, writing to this file
results in arbitrary memory write primitive inside the `python` process.
By utilizing this, I overwrote `__free_hook` to point a memory area with read, write, execute permissions,
after writing a shellcode.

[Exploit](./test.c)