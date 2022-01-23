#!/bin/bash
set -e
cd rootfs
find . | cpio -Hnewc -o > ../myRootfs.cpio
cd ..
ls -l myRootfs.cpio
