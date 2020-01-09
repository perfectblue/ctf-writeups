# KingMaker

13.7 Points

**Problem description**:
```
KingMaker
nc 110.10.147.104 13152

Download
```

It's a very straightforward reversing challenge. No serious obfuscation or packing, which is good. Our task is to deduce the correct series of inputs to win the game and receive the flag. For most of these choices, it's trivial, for example:

```c
  __isoc99_scanf("%d", &input);
  printf("\x1B[H\x1B[J");
  if ( input == 1 )
  {
    game_1();
  }
  else
  {
    if ( input != 2 )
      checkWinLose("SYSTEM : Choose wrong choice!", 0);
    lookAround();
  }
```

It's pretty claer what the logic does. Unfortunately, it's not so easy all the way through. 

```c
__int64 __fastcall game_1_()
{
  __int64 v1; // rsi
  char key; // [rsp+0h] [rbp-10h]
  unsigned __int64 cookie; // [rsp+8h] [rbp-8h]

  cookie = __readfsqword(0x28u);
  // blah blah
  __isoc99_scanf("%s", &key);
  printf("\x1B[H\x1B[J", &key);
  if ( !(unsigned int)checkKey(&key, 1u, 5u) )
    checkWinLose("King : Wrong! Don't you want to be a king?", 0);
  v1 = (unsigned int)dword_6070A8;
  xorBuffer(&part1_crypted, dword_6070A8, &key);
  ((void (__fastcall *)(char *, __int64))part1_crypted)(&key, v1);
  return __readfsqword(0x28u) ^ cookie;
}
```

Look: it's reading a key from stdin, then decrypting code with that key.


```c
_BOOL8 __fastcall checkKey(const char *key, unsigned int keyid, unsigned int keylen)
{
  signed int n; // ST00_4
  FILE *stream; // ST18_8
  char s; // [rsp+20h] [rbp-30h]
  char correctKey; // [rsp+30h] [rbp-20h]
  unsigned __int64 cookie; // [rsp+48h] [rbp-8h]

  n = keylen;
  cookie = __readfsqword(0x28u);
  sprintf(&s, "key%d", keyid);
  stream = fopen(&s, "r");
  fgets(&correctKey, n, stream);
  return strncmp(&correctKey, key, n) == 0;
}
```

Moreover, that key is being checked serverside, so we can't deduce it only by looking at code. We need to perform some kind of cryptographic attack, or look for side-channel on the server. It might be possible to do a timing-attack against `strncmp`, but this seems implausible. Instead, since code is actually low-entropy typically, we are going to try to recover the key from the structure of the code hopefully. We even have the key length (5)

```
Offset(h) 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F

00003410                                         39 07 FF
00003420  D6 24 CC 9A 13 24 C6 0B DB 08 07 FD 37 49 67 76
00003430  33 6C 07 FF 76 94 7E B6 8C 84 16 36 33 84 B4 A0
00003440  CC 93 F0 7E 69 2C 4F 9E C2 BA B0 89 8C 04 15 36
00003450  33 84 A8 A0 CC 93 F0 CC 65 2C 4F 9E EE BA B0 89
00003460  8C AF 19 36 33 84 9C A0 CC 93 07 FB 76 98 07 FF
00003470  F5 D3 00 4F 73 6C F7 76 33 6C 4F 9E 63 B8 B0 89
00003480  8C 3E 76 36 33 D4 4F 76 33 6C A7 97 E0 93 B0 FD
00003490  76 98 CC 8E 32 19 6B FD 36 7F 73 56 33 24 C4 23
000034A0  DB E5 89 C9 3C 5F 0F 76 DB 60 99 89 CC         
```

Also, this is x64, so function prologue will likely resemble:

```
55                      push   rbp
48 89 e5                mov    rbp,rsp
48 83 ec ??             sub    rsp,0x??
?? ?? ?? ??             <saving registers>
64 48 8b 04 25 28 00    mov    rax,QWORD PTR fs:0x28
```

We know that key length is 4 (+1 null terminator), so:
```python
>>> xor(('3907FFD6').decode('hex'), '554889e5'.decode('hex'))
'lOv3'
```

And this works in the game! So, let's decrypt our code.

```c
void __fastcall __noreturn part1_crypted(__int64 stage1_key)
{
  __int64 v1; // rsi
  int input; // [rsp+14h] [rbp-Ch]
  unsigned __int64 cookie; // [rsp+18h] [rbp-8h]

  cookie = __readfsqword(0x28u);
  j_puts("SYSTEM : We will start test 1\n");
  j_puts("King : The bandits are crossing over the northern border. So, go there and defuse the thief.");
  j_puts("King : Do you want to go there?");
  j_puts("1> I am!");
  j_puts("2> No I'm not");
  __isoc99_scanf("%d", &input);
  printf("\x1B[H\x1B[J");
  if ( input == 1 )
  {
    xorBuffer(sub_40330F, dword_6070B0, (const char *)stage1_key);
    sub_40330F(stage1_key);
  }
  if ( input == 2 )
  {
    v1 = (unsigned int)dword_6070AC;
    xorBuffer(sub_4033FF, dword_6070AC, (const char *)stage1_key);
    sub_4033FF(stage1_key, v1);
  }
  sub_400B58("SYSTEM : Choose wrong choice!", 0LL);
}
```

It looks like the functions it calls are also encrypted, but luckily with the same key. We decrypt those too. At this point, I wanted to focus on deriving all keys. So, I checked xref of `checkKey` function.

```
sub_4012EC+123	call    checkKey
sub_401BFA+123	call    checkKey
sub_40226D+123	call    checkKey
sub_402E4F+12D	call    checkKey
sub_40350D+A7	call    checkKey
```

Process of recovering key is same for all of these. Each call to `checkKey` corresponds to one of the five stage keys.
Luckily, all keys are very short.

- `lOv3`
- `D0l1`
- `HuNgRYT1m3`
- `F0uRS3aS0n`
- `T1kT4kT0Kk`

This is sufficient to decrypt the whole binary. The logic is all very simple. We basically want to get our 5 stats up to 5:
```
brave > 5
wise > 5
kind > 5
decision > 5
sacrifice > 5
```

```c
void __fastcall __noreturn sub_400B58(const char *a1, int a2)
{
  puts(a1);
  if ( a2 == 1 )
  {
    if ( stat1 != 5 || stat2 != 5 || stat3 != 5 || stat4 != 5 || stat5 != 5 )
    {
      j_puts("King : But you couldn't make the points... You can't be a king.");
    }
    else
    {
      j_puts("King : Congratuations to be a king!");
      system("/bin/cat ./flag");
    }
  }
  exit(-1);
}
```

We can xref those 5 statistics to check which codes we want to reach. In fact if we really wanted, we could probably brute-force the inputs to figure out which one is correct options to choose, since the game is relatively short.

One interesting part later on is when the king asks us to decrypt a testament:

```
King : A girl came to ask me to decrypt her grandfather's testament.
King : Get the decrypted testament to me.
King : 'ALICEAWTQJMJXTSPPZVCIDGQYRDINMCP'
King : Can you decrypt this?
1> Yes I can.
2> No I can't
```

Here is the check function:

```c
signed __int64 __fastcall checkTestament(const char *input)
{
  int input_idx; // [rsp+18h] [rbp-78h]
  signed int i; // [rsp+1Ch] [rbp-74h]
  char input_copy[16]; // [rsp+20h] [rbp-70h]
  char alphabet[26]; // [rsp+30h] [rbp-60h]
  char testament[32]; // [rsp+50h] [rbp-40h]
  char v7; // [rsp+72h] [rbp-1Eh]
  unsigned __int64 cookie; // [rsp+78h] [rbp-18h]

  cookie = __readfsqword(0x28u);
  qmemcpy(alphabet, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", sizeof(alphabet));
  strcpy(testament, "ALICEAWTQJMJXTSPPZVCIDGQYRDINMCP");
  v7 = 0;
  input_idx = 0;
  strncpy(input_copy, input, 5uLL);
  for ( i = 5; i < strlen(input); ++i )
  {
    if ( alphabet[(input[i] - 'A' + input_copy[input_idx] - 'A') % 26] != testament[i] )
      return 0LL;
    input_idx = (input_idx + 1) % 5;
  }
  return 1LL;
}
```

This "cipher" seems totally broken...only the first 5 characters matter, and they should be AAAAA. Rest should be the same as rest of the given testament. `AAAAAAWTQJMJXTSPPZVCIDGQYRDINMCP` is correct.

Anyways, the correct inputs are:
```
1
lOv3
1
2
2
3
D0l1
1
2
1
2
2
1
HuNgRYT1m3
2
2
3
F0uRS3aS0n
1
1
AAAAAAWTQJMJXTSPPZVCIDGQYRDINMCP
1
2
T1kT4kT0Kk
3
2
2
1
```

Finally King gives us the flag:

```
You : I will read the document!
King : Congratuations to be a king!
He_C@N'T_see_the_f0rest_foR_TH3_TRee$
```