# 1337

**Category**: Reverse

500 Points

4 Solves

**Problem description**:
n/a

**Solved by**: cts

---

*Writeup by cts*

This was a very tedious reverse, namely because the binary was obfuscated. There are `UPX0` and `UPX1` sections; however, these are just a red herring.
Since the imports aren't destroyed, it's obviously not packed, just obfuscated.

The main obfuscation strategies in play are:
 - Dead code. Specifically, there are dead threads that seem to do important things but don't. Moreover, all of the important functions are jammed with useless loops to make them huge (10k+ basic blocks, makes IDA give up). There is also a lot of dead arithmetic.
 - String encryption with XOR
 - Control flow destruction, namely functions are split up into several chunks separated by long segments of dead code and `nop`s

To attack string encryption, we can simply dump all the strings from the resource table and xor them. The key is easily identified because it's just the resource id.
We can also breakpoint and log the decryption function.

For the dead code, unfortunately we need to patch the binary to jump over the dead code, then in IDA setup function chunks to make it decompile properly.

```c
void __usercall wow(int a1@<ebx>)
{
  char *enterPassword; // eax
  unsigned __int64 tmp; // rax
  unsigned int v3; // et0
  unsigned int v4; // et0
  unsigned int v5; // et0
  unsigned int v6; // et0
  char *goal1; // eax
  char *goal2; // eax
  char *goal3; // eax
  char *goal4; // eax
  char *goal1_; // eax
  int memcmpResult; // eax
  char *flagFormat; // eax
  unsigned int v14; // [esp-28h] [ebp-10BE8h]
  int v15; // [esp-24h] [ebp-10BE4h]
  int v16; // [esp-20h] [ebp-10BE0h]
  unsigned int v17; // [esp-1Ch] [ebp-10BDCh]
  int v18; // [esp-18h] [ebp-10BD8h]
  signed int *v19; // [esp-14h] [ebp-10BD4h]
  int *v20; // [esp-10h] [ebp-10BD0h]
  int v21; // [esp-Ch] [ebp-10BCCh]
  _BYTE *v22; // [esp-8h] [ebp-10BC8h]
  signed int v23; // [esp-4h] [ebp-10BC4h]
  char owoWhatsThis[260]; // [esp+Ch] [ebp-10BB4h]
  char goalBuf[28]; // [esp+110h] [ebp-10AB0h]
  _BYTE userInput[25]; // [esp+12Ch] [ebp-10A94h]
  __int64 memmoveSRc; // [esp+148h] [ebp-10A78h]
  char v28; // [esp+150h] [ebp-10A70h]
  unsigned __int64 v29; // [esp+154h] [ebp-10A6Ch]
  unsigned int v30; // [esp+15Ch] [ebp-10A64h]
  int v31; // [esp+160h] [ebp-10A60h]
  __int64 toMemmove; // [esp+164h] [ebp-10A5Ch]
  __int64 ttoMemmove; // [esp+16Ch] [ebp-10A54h]
  __int64 userInput8; // [esp+174h] [ebp-10A4Ch]
  unsigned __int8 *buf1; // [esp+517Ch] [ebp-BA44h]
  unsigned __int8 *buf2; // [esp+5180h] [ebp-BA40h]
  unsigned int biglyREuslto; // [esp+5184h] [ebp-BA3Ch]
  void *WAOW; // [esp+5188h] [ebp-BA38h]
  int a2; // [esp+518Ch] [ebp-BA34h]
  int v40; // [esp+5190h] [ebp-BA30h]
  int userInputLen; // [esp+A994h] [ebp-622Ch]
  _BYTE *userInput1; // [esp+A998h] [ebp-6228h]
  const char *endOfInput; // [esp+A99Ch] [ebp-6224h]
  unsigned int idx; // [esp+A9A0h] [ebp-6220h]
  char *v45; // [esp+A9A4h] [ebp-621Ch]
  char *owo2; // [esp+A9A8h] [ebp-6218h]
  int v47; // [esp+F9ACh] [ebp-1214h]
  int v48; // [esp+F9B0h] [ebp-1210h]
  _BYTE *v49; // [esp+F9B4h] [ebp-120Ch]
  const char *v50; // [esp+F9B8h] [ebp-1208h]
  char cmp1; // [esp+FFBCh] [ebp-C04h]
  char cmp2; // [esp+FFBDh] [ebp-C03h]
  int savedregs; // [esp+10BC0h] [ebp+0h]

  enterPassword = j_decryptString(11);
  printf(enterPassword);
  *userInput = 0;
  *&userInput[4] = 0;
  *&userInput[8] = 0;
  *&userInput[12] = 0;
  *&userInput[16] = 0;
  *&userInput[20] = 0;
  userInput[24] = 0;
  v23 = 25;
  v22 = userInput;
  scanf("%24s", userInput, 25);
  v50 = userInput;
  v49 = &userInput[1];
  v50 += strlen(v50);
  v48 = ++v50 - &userInput[1];
  v47 = v50 - &userInput[1];
  if ( (v50 - &userInput[1]) / 3.0 < 2.6666666666667 )// < 8
  {
    __halt();
    JUMPOUT(*decryptionShitEarly);
  }
  memset(owoWhatsThis, 0, 260u);
  owo2 = owoWhatsThis;
  *goalBuf = 0;
  *&goalBuf[4] = 0;
  *&goalBuf[8] = 0;
  *&goalBuf[12] = 0;
  *&goalBuf[16] = 0;
  *&goalBuf[20] = 0;
  goalBuf[24] = 0;
  v45 = goalBuf;
  for ( idx = 0; ; idx += 8 )
  {
    endOfInput = userInput;
    userInput1 = &userInput[1];
    endOfInput += strlen(endOfInput);
    userInputLen = ++endOfInput - &userInput[1];
    if ( idx >= endOfInput - &userInput[1] - 7 )
      break;
    userInput8 = 0i64;
    userInput8 = userInput[idx];
    userInput8 |= userInput[idx + 1] << 8;      // basically memcpy
    userInput8 |= userInput[idx + 2] << 16;
    userInput8 |= userInput[idx + 3] << 24;
    LODWORD(tmp) = 0;
    HIDWORD(tmp) = HIDWORD(userInput8) | userInput[idx + 4];
    userInput8 = userInput8 | tmp;
    LODWORD(tmp) = 0;
    HIDWORD(tmp) = HIDWORD(userInput8) | (userInput[idx + 5] << 8);// ok
    userInput8 = userInput8 | tmp;
    userInput8 |= userInput[idx + 6] << 48;     // ok
    userInput8 |= userInput[idx + 7] << 56;
    if ( idx % 2 )
      ttoMemmove = modExp5(userInput8);
    else
      ttoMemmove = j_modexp5(userInput8);
    toMemmove = ttoMemmove;
    v40 = 0;
    v30 = 0;
    v31 = 0;
    v29 = userInput8 >> 58;
    if ( v30 < v29 )
    {
      v3 = __readeflags();
      v23 = v3;
      v22 = 0;
      v21 = 0;
      v20 = &savedregs;
      v19 = &v23;
      v18 = a1;
      v17 = v30;
      v16 = 0;
      v15 = 0;
      v4 = __readeflags();
      __writeeflags(v4);
      v5 = __readeflags();
      __writeeflags(v5);
      v6 = __readeflags();
      v14 = v6;
      jmpDst = a1;
      JUMPOUT(__CS__, 5724515);
    }
    v28 = 0;
    memmoveSRc = toMemmove;
    a2 = idx % 7;
    switch ( idx % 7 )
    {
      case 0u:
        goal1 = decryptThaong(37, 24i64);
        *goalBuf = *goal1;
        *&goalBuf[4] = *(goal1 + 1);
        *&goalBuf[8] = *(goal1 + 2);
        *&goalBuf[12] = *(goal1 + 3);
        *&goalBuf[16] = *(goal1 + 4);
        *&goalBuf[20] = *(goal1 + 5);
        break;
      case 1u:
        goal2 = decryptThaong(38, 24i64);
        *goalBuf = *goal2;
        *&goalBuf[4] = *(goal2 + 1);
        *&goalBuf[8] = *(goal2 + 2);
        *&goalBuf[12] = *(goal2 + 3);
        *&goalBuf[16] = *(goal2 + 4);
        *&goalBuf[20] = *(goal2 + 5);
        break;
      case 2u:
        goal3 = decryptThaong(39, 24i64);
        *goalBuf = *goal3;
        *&goalBuf[4] = *(goal3 + 1);
        *&goalBuf[8] = *(goal3 + 2);
        *&goalBuf[12] = *(goal3 + 3);
        *&goalBuf[16] = *(goal3 + 4);
        *&goalBuf[20] = *(goal3 + 5);
        goto LABEL_17;
      case 3u:
LABEL_17:
        goal4 = decryptThaong(42, 24i64);
        *goalBuf = *goal4;
        *&goalBuf[4] = *(goal4 + 1);
        *&goalBuf[8] = *(goal4 + 2);
        *&goalBuf[12] = *(goal4 + 3);
        *&goalBuf[16] = *(goal4 + 4);
        *&goalBuf[20] = *(goal4 + 5);
        break;
      default:
        goal1_ = decryptThaong(39, 24i64);
        *goalBuf = *goal1_;
        *&goalBuf[4] = *(goal1_ + 1);
        *&goalBuf[8] = *(goal1_ + 2);
        *&goalBuf[12] = *(goal1_ + 3);
        *&goalBuf[16] = *(goal1_ + 4);
        *&goalBuf[20] = *(goal1_ + 5);
        break;
    }
    WAOW = &memmoveSRc;
    a1 = &owo2[idx];
    ((dword_67D3DC + 15))(&owo2[idx], &memmoveSRc, 8u);
  }
  while ( ++idx < 24 )
  {
    if ( !(idx % 24) )
      biglyREuslto = (biglyREuslto >> 24 != 0) - 1;
    cmp2 = goalBuf[idx];                        // correct
    cmp1 = owoWhatsThis[idx];                   // from user
    buf2 = &cmp2;
    buf1 = &cmp1;
    memcmpResult = 8 * ((memmove + 19))(&cmp1, &cmp2, 1u);// memcmp
    LOBYTE(memcmpResult) = memcmpResult == 0;
    biglyREuslto += (idx + 1) * memcmpResult;
  }
  if ( biglyREuslto == 300 )                    // 1 + 2 .. + 24
  {
    flagFormat = j_decryptString(12);
    printf(flagFormat, userInput);
  }
  exit(0);
}

__int64 __cdecl modExp5(__int64 x)
{
  unsigned int result_high_; // edx
  int x2_high; // ebx
  unsigned int x2_low; // esi
  unsigned int result_low_; // ecx
  bool inputted4; // zf
  int y_low2; // edi
  unsigned int bits; // [esp+Ch] [ebp-20h]
  unsigned __int64 x2_; // [esp+10h] [ebp-1Ch]
  signed int y_low; // [esp+18h] [ebp-14h]
  unsigned int x1_high; // [esp+1Ch] [ebp-10h]
  unsigned int y_high; // [esp+20h] [ebp-Ch]
  unsigned int result_high; // [esp+24h] [ebp-8h]
  unsigned int result_low; // [esp+28h] [ebp-4h]
  unsigned int x1_low; // [esp+38h] [ebp+Ch]

  result_high_ = 0;
  result_high = 0;
  x2_high = HIDWORD(x) & 0x3FFFFFFF;
  x2_low = x;
  result_low_ = 1;
  bits = HIDWORD(x) >> 30;
  inputted4 = (HIDWORD(x) & 0x3FFFFFFF | x) == 0;
  result_low = 1;
  y_low2 = 5;
  y_high = 0;
  y_low = 5;
  x1_low = x;
  x1_high = x2_high;
  if ( inputted4 )
    return __PAIR__(result_high_, bits) + result_low_ - 1;
  do
  {
    x2_ = __PAIR__(x2_high, x2_low);
    if ( x2_low & 1 )                           // last bit
    {
      result_high = __PAIR__(y_high, y_low2) * __PAIR__(result_high_, result_low_) >> 32;// result *= y
                                                // power |= logY
      result_low = y_low2 * result_low_;
    }
    x2_low = __PAIR__(x1_high, x1_low) >> 1;    // x2 = x1 >> 1
    x2_high = x1_high >> 1;
    x1_low = __PAIR__(x1_high, x1_low) >> 1;    // x1 = x1 >> 1
    x1_high >>= 1;
    y_low2 = y_low * y_low;
    result_low_ = result_low;
    y_high = __PAIR__(y_high, y_low) * __PAIR__(y_high, y_low) >> 32;// y *= y
    result_high_ = result_high;
    y_low *= y_low;                             // logY <<= 1
  }
  while ( x2_ >= 2 );
  result_low_ = result_low;
  result_high_ = result_high;
  return __PAIR__(result_high_, bits) + result_low_ - 1;
}
char *__fastcall decryptString(char stringId, char xorKey)
{
  void (__stdcall *loadStringA)(HINSTANCE, UINT, LPSTR, int); // esi
  HINSTANCE hMod; // eax
  char *dupedbuf; // esi
  unsigned int idx; // edx

  memset(Buffer, 0, 0x104u);
  loadStringA = (dword_67D2D0 - 52);            // LoadStringA
  hMod = ((dword_67D2C4 + 307))(0);             // GetModuleHandleA
  loadStringA(hMod, stringId, Buffer, 260);
  dupedbuf = _strdup(Buffer);
  idx = 0;
  if ( strlen(dupedbuf) )
  {
    do
    {
      dupedbuf[idx] ^= xorKey;
      ++idx;
    }
    while ( idx < strlen(dupedbuf) );
  }
  return dupedbuf;
}
```

Basically, the user input must be 24 bytes. Then it's split up into 3 8-byte chunks, which are treated as 64-bit integers and exponentiation base 5 (mod 2^64) is performed. The result QWORD is checked against some decrypted strings.

...but isn't discrete log hard? No, because 2^64 is smooth! So we can use a modified Pollard-Rho I stole from Stackoverflow I found with Google. The function isn't *exactly* exponentiation base 5 beaecuse it has some stupid additions but those are easily reversible.

However, when you do your discrete logs, you get back non-ASCII garbage. Moreover, there are bytes over 7F which get sign-extended to FFFFFFXX when copied into the QWORD...what gives?

At this point there were no solves and several teams were stuck but the problem writer insisted it was not broken. So I checked the resource table, and I saw:

```
STRINGTABLE
LANGUAGE LANG_HEBREW, 0x0
{
  32,   "tRANSLATEmESSAGE"
  34,   "fKQRCVAJoGQQCEG"
  35,   "fMVNgFPHWLStJMGLTP"
  36,   "cAPsMJ@KSpA\\Pe"
  37,   "\xB0u…ו\x08ה\xB9\xBE\x14\x10רD\x7FCר\xB8t„-Fq'ֲ"
  38,   "\xB0u…ו\x08ה\xB9\xBE\x14-ר\x04\x7FEר\xB8t”\xB0Fq7ֲ"
  39,   "\xB0u…ו\x08T\xB9\xBE\x14\x01רD\x7FDר\xB8t”-F\x7F7ֲ"
  42,   "\xB0u…ו\x08ה\xB9\xBED-ר\x04\x7FCר\xB8t”\xB0Fq'ֲ"
}
```

...Hebrew???

```
10 00 74 00 52 00 41 00 4E 00 53 00 4C 00 41 00 
54 00 45 00 6D 00 45 00 53 00 53 00 41 00 47 00 
45 00 00 00 0F 00 66 00 4B 00 51 00 52 00 43 00 
56 00 41 00 4A 00 6F 00 47 00 51 00 51 00 43 00 
45 00 47 00 12 00 66 00 4D 00 56 00 4E 00 67 00 
46 00 50 00 48 00 57 00 4C 00 53 00 74 00 4A 00 
4D 00 47 00 4C 00 54 00 50 00 0E 00 63 00 41 00 
50 00 73 00 4D 00 4A 00 40 00 4B 00 53 00 70 00 
41 00 5C 00 50 00 65 00 18 00 B0 00 75 00 26 20 
D5 05 08 00 D4 05 B9 00 BE 00 14 00 10 00 E8 05 
44 00 7F 00 43 00 E8 05 B8 00 74 00 1E 20 2D 00 
46 00 71 00 93 F8 27 00 B2 05 18 00 B0 00 75 00 
26 20 D5 05 08 00 D4 05 B9 00 BE 00 14 00 2D 00 
E8 05 04 00 7F 00 45 00 E8 05 B8 00 74 00 1D 20 
B0 00 46 00 71 00 93 F8 37 00 B2 05 18 00 B0 00 
75 00 26 20 D5 05 08 00 54 00 B9 00 BE 00 14 00 
01 00 E8 05 44 00 7F 00 44 00 E8 05 B8 00 74 00 
1D 20 2D 00 46 00 7F 00 93 F8 37 00 B2 05 00 00 
00 00 18 00 B0 00 75 00 26 20 D5 05 08 00 D4 05 
B9 00 BE 00 44 00 2D 00 E8 05 04 00 7F 00 43 00 
E8 05 B8 00 74 00 1D 20 B0 00 46 00 71 00 93 F8 
27 00 B2 05 00 00 00 00 00 00 00 00 00 00 
   ^^    ^^    ^^    ^^    ^^    ^^    ^^
```

And why are all of the strings in ASCII (upper byte zero), but the 4 goal strings in Unicode (nonzero upper byte)???
In desperation I spun up a VM, changed its system locale to Hebrew (as I remember several weeb VNs don't work without Japanese locale), and voila `LoadStringA` returns different data...great...also the problem author added hint to change locale to Hebrew as I was telling him this.

Finally the discrete log gives correct flag, which is `4.\/3ry.1337.|>45$vV0r|)`.
