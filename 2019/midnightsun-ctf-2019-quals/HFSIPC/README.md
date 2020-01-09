# HFSIPC

**Category**: Pwn

558 Points
18 Solves

---

We were provided with a qemu setup with a vulnerable kernel device. Reversing the kernel module, we find that we can alloc, free, edit, and read `channel` data. The structs are shown below:

```C
struct channel_info {
	long id; // identify channels
	long data; // pointer to malloced data
	long malloc_size; // size of malloced data
}
```

Each time we alloc, two mallocs are triggered, one to store channel_info, whose pointer is then stored in a global pointer list. Then another malloc creates the actual data buffer, whose size we provide.

The vulnerability exists in the edit function, where the kernel copies malloc_size + 1 bytes from a provided user land buffer.

So here we have a kernel heap challenge with a one byte overflow. This was my second time doing a kernel challenge, so we tried looking for kernel exploits on the old-ish linux kernel to no avail.

However, it turns out kernel heap is easy. Although I don't know the exact details, kernel heap seems to use a freelist without many checks and without trailing metadata. So essentially, we could use the one byte overflow to point the freelist elsewhere and obtain a chunk overlap.

If we overflow the lsb correctly, we can obtain a chunk that overlaps with a channel_info chunk, thus controlling the data pointer and using which we can obtain arbitrary read and write through the edit and read functions of the device.

If we look at the command line command, we see that smep and smap are enabled:

```
qemu-system-x86_64 \
    -m 128M \
    -cpu max,+smap,+smep,check \
    -kernel ./bzImage \
    -initrd rootfs.img.gz \
    -append 'root=/dev/ram rw console=ttyS0 rdinit=/sbin/init loglevel=3 oops=panic panic=1' \
    -no-reboot \
    -nographic \
    -monitor /dev/null
```

This means we can't do a ret2usr attack. With the arbitrary r/w we could try finding our process's task struct in memory, but since kaslr wasn't enabled for some reason, I opted to overwrite the modprobe string in kernel memory. The modprobe string points to a binary that the kernel runs whenever an unknown file type is run. This, we can point that string to our binary that copies the flag over from /root/flag to us and allow us to read it:

Something like this will work:

```
#!/bin/sh
/bin/cp /root/flag /home/user/flag
/bin/chmod 777 /home/user/flag 
```

Putting this into the exploit, we have:

```C
system("echo -ne '#!/bin/sh\n/bin/cp /root/flag /home/user/flag\n/bin/chmod 777 /home/user/flag' > /home/user/sice.sh");
system("chmod +x /home/user/sice.sh");
system("echo -ne '\\xff\\xff\\xff\\xff' > /home/user/ll");
system("chmod +x /home/user/ll");
system("/home/user/ll");
system("cat /home/user/flag");
```

First kernel challenge I ever solved on a CTF :)

## Flag
midnight{0fF_bY_0n}
