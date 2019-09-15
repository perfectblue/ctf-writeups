# Callsite

**Category**: Reversing

100 Points

104 Solves

**Problem description**:

Call me maybe? `nc rev.chal.csaw.io 1001`

---

The binary is a stripped static linked binary. To deal with this I'll use the [signature matcher](https://twitter.com/BinjaDevs/status/1172935298705240065) feature of Binary Ninja. It was my summer internship project at Vector35.

![binja.png](binja.png)

The challenge reads in an address and argument, encrypts(?) the argument, then calls the address with the argument. It also setups a signal handler to catch all segfaults and print "Wrong!".

```C
__int64 __fastcall main(signed int argc, char **argv)
{
  int hashedShit; // ebx
  char *v4; // rdi
  void (__fastcall *address)(_QWORD); // [rsp+8h] [rbp-C0h]
  void (__fastcall __noreturn *sighandler)(__int64, __int64, __int64); // [rsp+10h] [rbp-B8h]
  __int64 v7; // [rsp+18h] [rbp-B0h]
  int v8; // [rsp+98h] [rbp-30h]
  unsigned __int64 v9; // [rsp+A8h] [rbp-20h]

  v9 = __readfsqword(0x28u);
  if ( argc <= 2 )
  {
    v4 = *argv;
    sub_400D30();
  }
  memset(&v7, 0, 0x90uLL);
  v8 = 4;
  sighandler = wrong;
  sub_413FA0(11, &sighandler);
  hashedShit = fcrypt((__int64)argv[2], (__int64)"aa");
  sscanf((__int64)argv[1], (__int64)"%lx", &address);
  address(hashedShit);
  return 0LL;
}

void __fastcall __noreturn wrong(__int64 a1, __int64 a2, __int64 a3)
{
  ++*(_QWORD *)(a3 + 168);
  puts("Wrong!");
  exit(1LL);
}
```

In that case it is extremely trivial to just jump to the code that prints the flag.

```
.text:0000000000400CBB                       win:
.text:0000000000400CBB 008 48 8D 35 FD E1 0C+                lea     rsi, aR_1       ; "r"
.text:0000000000400CC2 008 48 8D 3D 70 95 0B+                lea     rdi, aFlagTxt   ; "flag.txt"
.text:0000000000400CC9 008 E8 52 62 01 00                    call    fopen
.text:0000000000400CCE 008 48 85 C0                          test    rax, rax
.text:0000000000400CD1 008 48 89 C3                          mov     rbx, rax
.text:0000000000400CD4 008 75 18                             jnz     short loc_400CEE
.text:0000000000400CD6 008 EB 30                             jmp     short loc_400D08
```

Of course it will segfault after this and print "Wrong!", but who cares, it prints the flag.

```
$ nc rev.chal.csaw.io 1001
Give me two args, space separated:
0x400cbb lmao
flag{you_got_the_call_site}
Wrong!
```
