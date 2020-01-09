# matryoshka

**Category**: Reversing

738 Points

55 Solves

**Problem description**:

There was a downloader found on a Mac desktop. It's your job to have layers of fun getting the flag.

Written by malwareunicorn

---

Very standard mach-o reversing, that downloads and mmaps a later stage then jumps to it. Each stage decrypts and runs the next stage based on user input.

```c
int __cdecl __noreturn main(int argc, const char **argv, const char **envp)
{
  int payloadoffset; // eax
  char *ppayload; // rsi
  int v5; // [rsp+68h] [rbp-138h]
  signed int v6; // [rsp+6Ch] [rbp-134h]
  signed int l; // [rsp+70h] [rbp-130h]
  signed int k; // [rsp+74h] [rbp-12Ch]
  signed int j; // [rsp+78h] [rbp-128h]
  signed int i; // [rsp+7Ch] [rbp-124h]
  char read_dst[32]; // [rsp+90h] [rbp-110h]
  char a_flag[32]; // [rsp+B0h] [rbp-F0h]
  char v13; // [rsp+D0h] [rbp-D0h]
  char a_entertheactualflag[26]; // [rsp+E0h] [rbp-C0h]
  __int64 flagfinal; // [rsp+108h] [rbp-98h]
  unsigned __int64 flag34; // [rsp+110h] [rbp-90h]
  unsigned __int64 flag23; // [rsp+118h] [rbp-88h]
  unsigned __int64 flag12; // [rsp+120h] [rbp-80h]
  __uint64_t stage4result; // [rsp+128h] [rbp-78h]
  unsigned int flag_4; // [rsp+134h] [rbp-6Ch]
  unsigned __int64 flag_3; // [rsp+138h] [rbp-68h]
  unsigned __int64 flag_2; // [rsp+140h] [rbp-60h]
  unsigned __int64 flag_1; // [rsp+148h] [rbp-58h]
  __int64 payload_result; // [rsp+150h] [rbp-50h]
  __int64 payloadoffset_; // [rsp+158h] [rbp-48h]
  __uint64_t data; // [rsp+160h] [rbp-40h]
  int v27; // [rsp+16Ch] [rbp-34h]
  void *stage2; // [rsp+170h] [rbp-30h]
  void *mmaped_buf; // [rsp+178h] [rbp-28h]
  void *downloadBuf; // [rsp+180h] [rbp-20h]
  int sockfd; // [rsp+18Ch] [rbp-14h]
  const char **v32; // [rsp+190h] [rbp-10h]
  int v33; // [rsp+198h] [rbp-8h]
  int v34; // [rsp+19Ch] [rbp-4h]

  v34 = 0;
  v33 = argc;
  v32 = argv;
  downloadBuf = 0LL;
  mmaped_buf = 0LL;
  stage2 = 0LL;
  v27 = 0;
  strcpy(a_entertheactualflag, "Enter the actual flag: \n");
  strcpy(a_flag, "fb{AAAAAAAAAAAAAAAAAAAAAAAAAAAA}");
  send_request(&sockfd);
  receive_response(&sockfd, &downloadBuf);
  close(sockfd);
  payloadoffset = check_png_header(downloadBuf);
  payloadoffset_ = payloadoffset;
  if ( !payloadoffset )
    exit(1);
  mmaped_buf = mmap(0uLL, 0x4096uLL, PROT_EXEC|PROT_WRITE|PROT_READ, MAP_EXECUTABLE|MAP_COPY, -1, 0LL);
  ppayload = downloadBuf + payloadoffset_;
  __memcpy_chk(mmaped_buf, downloadBuf + payloadoffset_, 0x4096LL, -1LL);
  payload_result = (mmaped_buf)(0LL, ppayload);
  munmap(mmaped_buf, 0x4096uLL);
  stage2 = mmap(0uLL, 0x4096uLL, PROT_EXEC|PROT_WRITE|PROT_READ, MAP_EXECUTABLE|MAP_COPY, -1, 0LL);
  __memcpy_chk(stage2, downloadBuf + payloadoffset_ + payload_result, 0x4096LL, -1LL);
  data = (stage2)(0LL);
  munmap(stage2, 0x4096uLL);
  munmap(downloadBuf, 0x80000uLL);
  stage4result = _OSSwapInt64(data);
  __asm
  {
    write(1, a_entertheactualflag, 0x18); Low latency system call
    read(0, read_dst, 30); Low latency system call
  }
  for ( i = 7; i >= 0; --i )
    flag_1 = read_dst[i] | (flag_1 << 8);
  for ( j = 15; j >= 8; --j )
    flag_2 = read_dst[j] | (flag_2 << 8);
  for ( k = 23; k >= 16; --k )
    flag_3 = read_dst[k] | (flag_3 << 8);
  for ( l = 27; l >= 24; --l )
    flag_4 = read_dst[l] | (flag_4 << 8);
  flag12 = flag_2 ^ flag_1;
  flag23 = flag_3 ^ flag_2;
  flag34 = flag_4 ^ flag_3;
  flagfinal = flag_4 ^ 0x115C28DA834FEFFDLL;    // system of 4 variables, 4 equations
  if ( (flag_2 ^ flag_1) != 0x3255557376F68LL
    || flag23 != 0x393B415F5A590044LL
    || flag34 != 0x665F336B1A566B19LL
    || flagfinal != stage4result )
  {
    printf("\nDOH!! try harder :( \n");
  }
  else
  {
    v6 = 3;
    v5 = 0;
    while ( v6 < 31 )
      a_flag[v6++] = read_dst[v5++];
    v13 = 10;
    printf("\n%s\n", a_flag);
    printf("\nCongratulations!!\n");
    printf("Created by @malwareunicorn\n");
  }
  exit(0);
}
```

The reversing is very easy; the only annoyance is that my IDA doesn't decompile the syscall instruction correctly. We can fix this by setting representation manually (Alt-F2).
As you can see this is a flag checker-style challenge. There is a linear system of 4 64-bit variables (which comprise the flag) and 4 variables.
However we don't know the last equation since it's derived based on the last layer's output which is returned up through the 2nd through 4th stages.
For brevity I will omit the code of the second and third stage. They are trivial addition and xor ciphers on shellcode which then gets jumped to.
If you want to see them I attached the idb anyways.

One key observation is that only 4 bytes of the last part of the flag are used:

```c
for ( l = 27; l >= 24; --l ) 
  flag_4 = read_dst[l] | (flag_4 << 8);
```

Which suggests that `flag_4` will have its highest 32 bits set to zero.
This gives us 32 bits of `flagfinal`: `0x115C28DA????????` which in turn gives us 32 bits (half) of all the other parts of the flag.
E.g.: `0x665F336B1A566B19` = `flag34` = `flag3 ^ flag4` = `0x665F336B1A566B19 ^ 0x00000000????????` => `flag3 = 0x665F336B????????`
And the process can be extended to flag2 and flag1.
So now we know the flag is like `????aWg_????4rd_????k3_f????`

We also now know 32 bits of plaintext from the RC4 cipher, `115C28DA` which allows us to brute-force the decryption key from the keystream.
Here is the stage 4 code that does the RC4 encryption:

```c
char *__fastcall stage4(__int64 a1, __int64 a2, __int64 a3, __int64 a4)
{
  char *result; // rax

  __asm
  {
    write prompt; Low latency system call
    read(0, inputtedKey, 16); Low latency system call
  }
  if ( *(_DWORD *)&inputtedKey[4] == '69Tw' )
  {
    rc4_ksa(inputtedKey, 8i64, keyin);
    rc4_crypt(outputtedCrypt, 48i64, outputtedCrypt, keyin);
    __asm { write(1, outputtedCrypt, 0x28); Low latency system call }
    result = *(char **)outputtedCrypt;
  }
  else
  {
    __asm
    {
      write fail; Low latency system call
      exit(0); Low latency system call
    }
  }
  return result;
}

void __fastcall rc4_ksa(char *input, __int64 len, char *out)
{
  __int64 outIdx; // rax
  signed __int64 rolling_val; // r10
  __int64 i; // rax
  __int64 j; // r9
  __int64 inputIdx; // r10
  char outChar; // xmm0_1

  outIdx = 0i64;
  rolling_val = 0x706050403020100i64;
  while ( outIdx != 32 )
  {
    *(_QWORD *)&out[8 * outIdx] = rolling_val;
    rolling_val += 0x808080808080808i64;
    ++outIdx;
  }                                             // out = 00 01 02 03 04 05 06 07 08 09 0a ... etc
  i = 0i64;
  LOBYTE(j) = 0;
  inputIdx = 0i64;
  do
  {                                             // swaps
    outChar = out[i];
    j = (unsigned __int8)(input[inputIdx] + out[i] + j);
    out[i] = out[j];
    out[j] = outChar;
    if ( len == ++inputIdx )
      inputIdx = 0i64;
    ++i;
  }
  while ( (_BYTE)i );
}

void __fastcall rc4_crypt(char *cipher, __int64 cipherLen, char *out, char *key)
{
  __int64 outIdx; // rax
  __int64 i; // xmm0_8
  __int64 j; // xmm1_8
  __int64 i_; // r11
  char k_i; // r10
  __int64 j_; // r11
  char k_j; // xmm3_1

  outIdx = 0i64;
  LOBYTE(i) = 0;
  LOBYTE(j) = 0;
  while ( cipherLen != outIdx )
  {
    i_ = (unsigned __int8)(i + 1);
    i = (unsigned __int8)(i + 1);
    k_i = key[i_];
    j_ = (unsigned __int8)(j + k_i);
    j = (unsigned __int8)(j + k_i);
    k_j = key[j_];
    key[i] = key[j_];
    key[j] = k_i;
    out[outIdx] = cipher[outIdx] ^ key[(unsigned __int8)(k_j + k_i)];
    ++outIdx;
  }
}
```

RC4 is extremely common CTF reversing problems but luckily it is very easy to recognize.
Nobody really uses this algorithm in the real world anymore except in some malware or implants.
We simply reimplemented RC4 in C then did a parallel ASCII input brute force on a beefy server with 48 cores. It takes about 30 seconds.

Based on the brute the key is "mQrYwT96" and the next 4 bytes of the keystream are `f3 b1 d5 e9` which corresponds to a plaintext of `f0 28 db 91`, so `stage4result = 0x115C28DAF028DB91`. Then we can just work backwards to solve the xor equations to get `fb{Y0_daWg_1_h34rd_u_1ik3_fl4gs}`.
