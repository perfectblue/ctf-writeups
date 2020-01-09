rev01 writeup
=============

We're given a `WhiteHat.exe` file, which on running asks for a flag. Reversing the binary,
we find this function which is called for checking the flag.

```c
signed int __fastcall sub_40138F(int a1, char *a2)
{
  // Type Info Hidden

  v2 = a1;
  v23 = a1;
  v3 = a2;
  v25 = -125;
  v26 = -7;
  v27 = -127;
  v28 = -24;
  v29 = -121;
  v30 = -23;
  v31 = -123;
  v32 = -86;
  v33 = -117;
  v34 = -6;
  v35 = -114;
  v36 = -60;
  v37 = -115;
  v38 = -13;
  v39 = -109;
  v40 = -14;
  GetNativeSystemInfo(&SystemInfo);
  GetLocalTime(&SystemTime);
  GetLocaleInfoA(0x400u, 0x20001009u, &LCData, 4);
  v4 = 11;
  while ( *(_BYTE *)(v2 + v4) == 75 )
  {
    v4 += 7;
    v24 = v4;
    if ( v4 >= 16 )
    {
      strcpy(v3, "abcdefghiklmopqx");
      v5 = v23;
      v6 = v3 + 1;
      v7 = v23 - (_DWORD)v3;
      v8 = 8;
      do
      {
        *v6 ^= v6[v7];
        v6 += 2;
        --v8;
      }
      while ( v8 );
      v9 = v3;
      v10 = 16;
      do
      {
        v9[v7] = LOBYTE(SystemTime.wDay) ^ (*v9 + v9[v7]);
        *v9 ^= LOBYTE(SystemTime.wYear);
        ++v9;
        --v10;
      }
      while ( v10 );
      *(_BYTE *)(v5 + 16) += LOBYTE(SystemTime.wDayOfWeek);
      v11 = 0;
      while ( *(&v25 + v11 + v3 - &v25) == *(&v25 + v11) )
      {
        if ( ++v11 >= 16 )
        {
          v12 = 0;
          do
          {
            v24 += (unsigned __int8)v3[v12];
            v12 += 4;
          }
          while ( v12 < 16 );
          v13 = FindResourceA(0, (LPCSTR)0x86, "EXE");
          GetLastError();
          v14 = LoadResource(0, v13);
          LockResource(v14);
          v15 = SizeofResource(0, v13);
          v16 = v15;
          v17 = sub_4010FC(v15);
          v18 = (char *)malloc(v17 + 50);
          if ( !v18 || (sub_401000(v16), (result = sub_40111D(v24 / 2 + v18[350000] + 192)) != 0) )
            result = 1;
          return result;
        }
      }
      return 0;
    }
  }
  return 0;
}
```

As we can see, first it checks if `flag[11]` is the character "K",
then it xor's every odd-index of the flag with `abcdefghiklmopqx` and
then xor every byte with the current year modulo 256. It then checks if
this value is equal to a value on the stack setup at the beginning of the
function.

If we reverse this, we can find the input flag which passes these checks.
We keep every even-indexed character empty because those can be anything.

```py
year = 2018

req = '\x83\xf9\x81\xe8\x87\xe9\x85\xaa\x8b\xfa\x8e\xc4\x8d\xf3\x93\xf2'
req = [ord(x) for x in req]
assert len(req) == 16

for i in range(16):
    req[i] ^= year % 256

m = [ord(x) for x in 'abcdefghiklmopqx']
i = 1
fin = [ord('_') for a in range(16)]
for j in range(8):
    fin[i] = req[i] ^ m[i]
    i += 2

print ''.join([chr(x) for x in fin])
```

We get the output from this: `_y_n_m_ _s_K_a_h`

Once this check passes, it calls another function `sub_401000`.

```c
signed int __stdcall sub_40111D(int a1)
{
  // Type Info Hidden

  Buffer = 0;
  memset(&v20, 0, 0x103u);
  FileName = 0;
  memset(&v22, 0, 0x103u);
  memset(&v18, 0, 0x103u);
  GetTempPathA(0x104u, &Buffer);
  GetTempPathA(0x104u, &FileName);
  strcat_s(&Buffer, 0x104u, "b.dll");
  strcat_s(&FileName, 0x104u, "2.exe");
  hResInfo = FindResourceA(0, (LPCSTR)0x8D, "SYS");
  GetLastError();
  v1 = LoadResource(0, hResInfo);
  lpBuffer = LockResource(v1);
  hResInfo = (HRSRC)SizeofResource(0, hResInfo);
  hObject = CreateFileA(&FileName, 0x10000000u, 1u, 0, 2u, 0x80u, 0);
  WriteFile(hObject, lpBuffer, (DWORD)hResInfo, &NumberOfBytesWritten, 0);
  CloseHandle(hObject);
  v2 = FindResourceA(0, (LPCSTR)0x8E, "SYS");
  v3 = v2;
  v4 = LoadResource(0, v2);
  v5 = LockResource(v4);
  hObject = (HANDLE)SizeofResource(0, v3);
  v6 = CreateFileA(&Buffer, 0x10000000u, 1u, 0, 2u, 0x80u, 0);
  WriteFile(v6, v5, (DWORD)hObject, &v11, 0);
  CloseHandle(v6);
  strcpy(&v17, "qa\"apgcvg\"Rv\"v{rg?\"dkngq{q\"`klRcvj?\"");
  v7 = 0;
  do
  {
    *(&v17 + v7) ^= a1 - 48;
    ++v7;
  }
  while ( v7 < 36 );
  strcpy(v25, "p`#pwbqw#Sw");
  v8 = 0;
  do
  {
    v25[v8] ^= a1 - 47;
    ++v8;
  }
  while ( v8 < 11 );
  CommandLine = 0;
  memset(&v24, 0, 0x63u);
  sprintf(&CommandLine, "%d", a1);
  memset(&StartupInfo, 0, 0x44u);
  StartupInfo.cb = 68;
  if ( CreateProcessA(&FileName, &CommandLine, 0, 0, 0, 0, 0, 0, &StartupInfo, &ProcessInformation) )
  {
    WaitForSingleObject(ProcessInformation.hProcess, 0xFFFFFFFF);
    CloseHandle(ProcessInformation.hThread);
    CloseHandle(ProcessInformation.hProcess);
    DeleteFileA(&Buffer);
    DeleteFileA(&FileName);
  }
  return 1;
}
```

Reversing this, we notice that it creates two files `b.dll` and `2.exe`
in the temp folder and runs the `2.exe` process.

If we check the `b.dll` file, it turns out that it is actually a png file
which contains the flag.

![](rev01_flag.png)

We submit the SHA1 hash of the flag wrapped in WhiteHat: `WhiteHat{9e9453a6ad4c8c31c599c4a4233027b6d43cda17}`
