# Junkyard

**Category**: Reverse

94 Points

57 Solves

**Problem description**:
>Wall-E got stuck in a big pile of sh\*t. To protect him from feeling too bad, its software issued an emergency lock down. Sadly, the software had a conscience and its curiosity caused him to take a glance at the pervasive filth. The filth glanced back, and then...
>
>Please free Wall-E. The software was invented by advanced beings, so maybe it is way over your head. Please skill up fast though, Wall-E cannot wait for too long. To unlock it, use the login "73FF9B24EF8DE48C346D93FADCEE01151B0A1644BC81" and the correct password.
>
>Software was leaked a long time ago and is available here

**Solved by**: cts

---

Pretty straightforward problem. Goal is to decrypt an encrypted flag, IV and ciphertext known, but key unknown. However, we can brute-force the keyspace because the program validates input used to generate the key. There is some dead code interspersed in the binary but these are all very obvious. There is also some string encryption but this is easily dumped from static analysis (doing dynamically is also possible, but annoying since gdb sucks).

```c
void __fastcall __noreturn main(int argc, char **argv, char **envp)
{
  char s; // [rsp+40h] [rbp-810h]

  if ( argc != 3 )
    print_result(8u, 0xFFFFFFFF);
  if ( !checkArg(argv[1]) )                     // 0x10 <= len(arg) < 0x40
    print_result(0, 0xFFFFFFFF);
  if ( !checkArg(argv[2]) )
    print_result(1u, 0xFFFFFFFF);               // 0x10 <= len(arg) < 0x40
  decryptString(7, stringsMd5Table[7], &s);
  puts(&s);
  memset(&s, 0, 0x800uLL);
  cc_DoDecrypt(argv[1], argv[2]);
}

void __fastcall __noreturn cc_DoDecrypt(const char *argv1, const char *argv2)
{
  size_t arg1_len; // rax
  size_t arg2_len; // rax
  unsigned __int64 arg1_len_; // rax
  unsigned __int64 arg2_len_; // rax
  int pwFirst; // ebx
  __int64 pw2a; // STC0_8
  int digit; // ST8C_4
  signed int idx; // eax
  signed int idx_; // eax
  __int64 md5InLen; // rax
  size_t md5Len; // rax
  unsigned __int8 k; // [rsp+1Fh] [rbp-11B1h]
  signed int numberOfDigits; // [rsp+7Ch] [rbp-1154h]
  unsigned int stringId; // [rsp+80h] [rbp-1150h]
  unsigned int exitCode; // [rsp+84h] [rbp-114Ch]
  int v19; // [rsp+88h] [rbp-1148h]
  __int64 v20; // [rsp+90h] [rbp-1140h]
  unsigned __int64 j; // [rsp+98h] [rbp-1138h]
  signed __int64 number; // [rsp+A0h] [rbp-1130h]
  signed __int64 numbera; // [rsp+A0h] [rbp-1130h]
  unsigned __int64 i; // [rsp+A8h] [rbp-1128h]
  char *arg1_copy; // [rsp+B0h] [rbp-1120h]
  char *arg2_copy; // [rsp+B8h] [rbp-1118h]
  __int64 stupidSum; // [rsp+C0h] [rbp-1110h]
  char md5In[5]; // [rsp+CBh] [rbp-1105h]
  __int64 v29; // [rsp+D0h] [rbp-1100h]
  __int64 v30; // [rsp+D8h] [rbp-10F8h]
  __int16 v31; // [rsp+E0h] [rbp-10F0h]
  char v32; // [rsp+E2h] [rbp-10EEh]
  _BYTE alphabet[19]; // [rsp+F0h] [rbp-10E0h]
  __int64 v34; // [rsp+110h] [rbp-10C0h]
  __int64 v35; // [rsp+118h] [rbp-10B8h]
  int v36; // [rsp+120h] [rbp-10B0h]
  __int16 v37; // [rsp+124h] [rbp-10ACh]
  char v38; // [rsp+126h] [rbp-10AAh]
  char md5Out; // [rsp+150h] [rbp-1080h]
  char hexOut; // [rsp+180h] [rbp-1050h]
  char hexIn[2048]; // [rsp+1B0h] [rbp-1020h]
  char dst[2056]; // [rsp+9B0h] [rbp-820h]

  arg1_copy = (char *)malloc(0x40uLL);
  arg2_copy = (char *)malloc(0x40uLL);
  arg1_len = strlen(argv1);
  strncpy(arg1_copy, argv1, arg1_len);
  arg2_len = strlen(argv2);
  strncpy(arg2_copy, argv2, arg2_len);
  if ( strlen(argv1) <= 0x3F )
  {
    arg1_len_ = strlen(argv1);
    fill_buf_using_primes(arg1_copy, arg1_len_, 0x40uLL);// 73FF9B24EF8DE48C346D93FADCEE01151B0A1644BC81
                                                // 
                                                // │73FF│9B24│EF8D│E48C│
                                                // │346D│93FA│DCEE│0115│
                                                // │1B0A│1644│BC81│....│
                                                // │....│....│....│....│
                                                // 
                                                // │73FF│9B24│EF8D│E48C│
                                                // │346D│93FA│DCEE│0115│
                                                // │1B0A│1644│BC81│FFB4│
                                                // │D44D│A156│C1FF│B4D4│
                                                // 
  }
  if ( strlen(argv2) <= 0x3F )
  {
    arg2_len_ = strlen(argv2);                  // stupid prime based copys
    fill_buf_using_primes(arg2_copy, arg2_len_, 0x40uLL);
  }
  pwFirst = arg2_copy[(signed int)constant_func_0x00()] - '0';
  pw2a = pwFirst + stupidArray[arg2_copy[(signed int)constant_func_0x2a()]] + 634;
  stupidSum = sum_with_xor(arg1_copy, arg1_copy) + pw2a;// sum_with_xor return 892360
  for ( i = 0LL; i <= 654; ++i )
    stupidArray[i] += stupidSum;
  number = stupidArray[155LL - *arg2_copy];     // number must be XX70Xxxxxxxxxxxxxxxxxxx
                                                // 
  snprintf(hexIn, 0x13uLL, "%lu", number);
  deadCode10();
  alphabet[0] = 'A';                            // A = -9; S = 9 probably lol
  alphabet[1] = 'B';
  alphabet[2] = 'C';
  alphabet[3] = 'D';
  alphabet[4] = 'E';
  alphabet[5] = 'F';
  alphabet[6] = 'G';
  alphabet[7] = 'H';
  alphabet[8] = 'I';
  alphabet[9] = 'J';
  alphabet[10] = 'K';
  alphabet[11] = 'L';
  alphabet[12] = 'M';
  alphabet[13] = 'N';
  alphabet[14] = 'O';
  alphabet[15] = 'P';
  alphabet[16] = 'Q';
  alphabet[17] = 'R';
  alphabet[18] = 'S';
  numberOfDigits = 0;
  v19 = number;
  while ( number && numberOfDigits <= 15 )
  {
    number = ((signed __int64)((unsigned __int128)(0x6666666666666667LL * (signed __int128)number) >> 64) >> 2)
           - (number >> 63);                    // signed division by 10
    ++numberOfDigits;
  }
  numbera = v19;
  while ( numbera && numberOfDigits <= 15 )
  {
    digit = numbera
          - 10
          * (((signed __int64)((unsigned __int128)(0x6666666666666667LL * (signed __int128)numbera) >> 64) >> 2)
           - (numbera >> 63));                  // signed modulo by 10
    numbera = ((signed __int64)((unsigned __int128)(0x6666666666666667LL * (signed __int128)numbera) >> 64) >> 2)
            - (numbera >> 63);                  // signed div by 10
    idx = numberOfDigits++;
    hexIn[idx] = alphabet[digit];
  }
  while ( numberOfDigits <= 15 )
  {
    idx_ = numberOfDigits++;
    hexIn[idx_] = 'a';
  }
  hexEncode(hexIn, dst, 0x10uLL);               // example of hexIn: │9142│43DE│CEBJ│aaaa│
                                                // 914243
                                                // JBECED
                                                // offset from A in alphabet, it's stupid
  for ( k = 5; k <= 8u; ++k )
    md5In[k - 5] = dst[k];
  md5InLen = strlen(md5In);
  MD5(md5In, md5InLen, &md5Out);
  hexEncode(&md5Out, &hexOut, 0x10uLL);
  md5Len = strlen(stringsMd5Table[2]);
  if ( !strncmp(stringsMd5Table[2], &hexOut, md5Len) )// 7303
  {
    stringId = 3;
    exitCode = -1337;
    c_DoDecrypt_and_puts((__int64)hexIn);
  }
  else
  {
    stringId = 4;
    exitCode = -101;
  }
  free(arg1_copy);
  free(arg2_copy);
  print_result(stringId, exitCode);
}
```

Essentially, it takes two inputs in arguments. If they are less than 64 bytes, they are padded to 64 bytes using some contrived algorithm based on prime numbers. Then it calculates a hash based on the two values. The hash's third and fourth digits must be 7 and 0, and there must be at least 5 digits in the hash (ex: 10700). Then it uses this hash to generate a 16-byte (128-bit) AES key to decrypt the flag with.

The keyspace here is very weak, so we can simply extract the key generation algorithm and brute-force it. The gist of it is:

```python
def genkey(hash): # 914243DECEBJaaaa
    out = str(hash)
    while hash:
        out += str('ABCDEFGHIJKLMNOPQRS'[hash%10])
        hash/=10
    out += 'a'*(16-len(out))
    return out

for n in range(10000, 10000000):
    if str(n)[2] == '7' and str(n)[3] == '0':
        key = genkey(stupid)
        cipher = AES.new(key, AES.MODE_CBC, iv)
        plain = cipher.decrypt(ciphertext)
        if plain.startswith('INS{'):
            print plain
```
