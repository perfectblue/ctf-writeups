# The Rise of Sky

Category: Pwn

Solves: 2

Solve by: setuid0, VoidMercy, jinmo123

Points: 477

---

## Challenge Description

> Lo and behold, here be live streaming on the SKY810.
> 
> ```
> nc 47.242.246.203 9999
> ```
> 
> [attachment](./TheRiseOfSky_243b31708c56461abf307e572c3c4472.bin)

An CramFS Filesystem image is given. The filesystem image can be mounted in Linux, and the mounted filesystem had a RTSP daemon inside it.

```
$ checksec ./usr/bin/server
    Arch:     em_rce-32-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX disabled
    PIE:      No PIE (0x8000)
    RWX:      Has RWX segments
```

`/usr/bin/server` is an ELF file with [C-SKY 810 CPU](https://github.com/c-sky). There is an official toolchain for compiler and disassembler; we built buildroot, qemu and binutils-gdb from c-sky for testing and disassembling the binary.
However, IDA Pro, Binary Ninja and Ghidra does not support it.
While radare2 seemed to [support C-SKY](https://github.com/radareorg/radare2/pull/11448) as a variant of MCore CPU, the disassembler didn't work well in this case. (endian issue?) So we relied on the output of `objdump` command.

We also ran `strings` against the daemon, it seemed like [Micro-RTSP](https://github.com/geeksville/Micro-RTSP/blob/master/src/CRtspSession.cpp) project
has the exact same string as the binary has.

## Vulnerability

There is a buffer-overflow vulnerability in Micro-RTSP (10000 - 1024) which the destination buffer is in `.bss` section:

```c++
bool CRtspSession::ParseRtspRequest(char const * aRequest, unsigned aRequestSize)
{
    char CmdName[RTSP_PARAM_STRING_MAX];
    static char CurRequest[RTSP_BUFFER_SIZE]; // Note: we assume single threaded, this large buf we keep off of the tiny stack
    unsigned CurRequestSize;

    Init();
    CurRequestSize = aRequestSize;
    memcpy(CurRequest,aRequest,aRequestSize); // [1]
...
    static char CP[1024];
...
    ClientPortPtr = strstr(CurRequest,"client_port");
    if (ClientPortPtr != nullptr)
    {
        TmpPtr = strstr(ClientPortPtr,"\r\n");
        if (TmpPtr != nullptr)
        {
            TmpPtr[0] = 0x00;
            strcpy(CP,ClientPortPtr); // [2]
```

[1] copies the request from the socket, and [2] copies `client_port` part.
Since `aRequestSize` and the size of `CurRequest` have the maximum size of `RTSP_BUFFER_SIZE` bytes (10000) and `CP` is 1024 bytes,
we can overwrite up to 8976 bytes on the `.bss` section since `CP` is defined as a `static` variable.

However, after reproducing the vulnerability against the given binary, we found that it actually triggers a **stack buffer overflow**, modifying
the PC register. After analysis, it seemed like instead of `stack -> .bss` flow, it had `.bss -> stack` flow of `strcpy`.

Since the binary does not have NX enabled, we set the return address to point our request buffer, which contains the [shellcode](./shellcode.S).

[Exploit](./sice.py)