#!/bin/bash

set -e

python firmware_dump.py
cp exploit_firmware rootfs/lib/firmware/chaos

gcc run.c -o rootfs/home/chaos/run -static
strip -s rootfs/home/chaos/run
cd rootfs
rm -f ../rootfs.cpio; find . -print0 | fakeroot cpio --null -o --format=newc > ../rootfs.cpio
cd ..


./qemu-system-x86_64 \
  -kernel ./bzImage \
  -initrd ./rootfs.cpio \
  -nographic \
  -monitor none \
  -cpu qemu64 \
  -append "console=ttyS0 kaslr panic=1" \
  -no-reboot \
  -m 512M \
  -device chaos,sandbox=./sandbox \
  -s
