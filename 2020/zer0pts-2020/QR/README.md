# QR Puzzle

```sh
./chall encrypted.qr <(tac key) /dev/stdout | grep -v '+' | tr '10' '& '
```
