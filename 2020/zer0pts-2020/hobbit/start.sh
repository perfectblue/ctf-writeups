#!/bin/sh
stty intr '^]'

qemu-system-x86_64 \
    -m 256M \
    -kernel ./bzImage \
    -initrd ./test.cpio \
    -append "root=/dev/ram rw console=ttyS0 oops=panic panic=1 kaslr quiet" \
    -cpu kvm64,+smep,+smap \
    -monitor /dev/null \
    -netdev user,id=user.0,hostfwd=:127.0.0.1:1234-10.0.2.15:1234   \
    -device e1000,netdev=user.0 \
    -nographic -enable-kvm
