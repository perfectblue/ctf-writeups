# Hobbit

Copy `gdbserver` binary and it's library dependencies (see `ldd gdbserver`).
Patch image by running the command:

```sh
cd root
find . | fakeroot cpio --create --format='newc' > ../test.cpio
```

Change the start.sh to use test.cpio image, and to port-forward 1234. Run
`gdbserver :1234 ./chall.hbt` in qemu guest. Run `gdb` on host machine, and then
type in `target remote :1234` to attach to challenge binary.

Running vmmap we see two maps:
```
0xbeef0000 0xbeef1000 rwxp     1000 0      
0xdead0000 0xdead1000 rwxp     1000 0      
0x7ffffffdd000 0x7fffffffe000 rwxp    21000 0      [stack]
0xffffffffff600000 0xffffffffff601000 r-xp     1000 0      [vsyscall]
```

0xbeef0000 is our .text section, and 0xdead0000 is our .dat section. Run these
commands in gdb to dump memory:
```
dump binary memory hobbit 0xbeef0000 0xbeef1000
dump binary memory hobbit_data 0xdead0000 0xdead1000
```

Do some basic REV, find out the binary is just doing some basic XOR on the flag. 
