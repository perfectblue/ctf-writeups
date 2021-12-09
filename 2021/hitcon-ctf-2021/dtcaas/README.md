# dtcaas

This challenge was a 0day challenge of the linux device tree compiler parser, [dtc](https://kernel.googlesource.com/pub/scm/utils/dtc/dtc/+/45f3d1a095dd3440578d5c6313eba555a791f3fb). We tried fuzzing dtb files, but the crashes discovered were all unexploitable. After code reviewing dtb parsing, we quickly determined that dtb was very difficult to exploit due to proper bounds checking.

Then, after code reviewing dts parsing, we quickly discovered the incbin primitive. This looked like an appealing primitive because we could include /dev/stdin. Looking at the incbin copy\_file function, we quickly discovered a ssize\_t and unsigned int overflow mismatch. The bug is:

```C
if (d.len + ret < d.len)
  die("Overflow reading file into data\n");
```

If we provide the size 0x100000010. Then it will only allocate a 0x10 sized chunk, but fread 0x100000010 bytes. This leads to a controlled heap overflow. From here the exploit is simple: heap groom the heap such that there are two freed tcache chunks on the heap such that the lower addressed chunk is at the top of the freelist, and we can claim a chunk above both tcache chunks to fread into. Additionally, since we are allowed two executions, we can use the first execution to leak /proc/self/maps. After this, we allocate two tcache chunks to get arbitrary write. It turns out one\_gadget works on free\_hook.

After solving, we found that this did not work remote. We spent 1.5 hours figuring out what the issue was, and it turns out /dev/stdin didn't work with socat for some reason (even though the author said it worked for him later on). Then, Qwaz had the great idea of placing our payload into the dts file as a comment, and leaking the temporary directory through the first run. This way, we do not need /dev/stdin.

```
drwxr-xr-x 2 root   root     4096 Dec  3 15:33 .
drwxr-xr-x 4 root   root     4096 Dec  2 14:15 ..
-rw------- 1 dtcaas dtcaas     50 Dec  2 15:42 .bash_history
-rw-r--r-- 1 root   root       47 Dec  2 15:50 .read_me_4_the_s3cr3t_f1ag
-rwxr-xr-x 1 root   root   505592 Dec  2 14:25 dtc
-rwxr-xr-x 1 root   root      150 Dec  2 14:25 run.sh
```

```
hitcon{Device Tree Compiler as a Scapegoat :D}
```
