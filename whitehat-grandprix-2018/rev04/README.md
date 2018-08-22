# rev04

**Category**: Reverse

390 Points

11 Solves

**Problem description**:
n/a

**Solved by**: cts, sampritipanda

---

*Writeup by cts*

This challenge was a very tough multistaged Windows rev. The only thing missing was a remote code stub dongle ;)

The only file we are given is `WH2018.exe`. The first thing to notice is that Windows refuses to even load it, indicating the PE header is damaged. 

![](img/1.png)

Let's try to load it in IDA anyways.

![](img/2.png)

Ok...maybe not such a great idea. We better put it under [CFF Explorer][1] instead.

![](img/3.png)

Everything seems normal up to this point...DOS and PE header are OK too.

![](img/4.png)

Hold it! If this is a 32-bit code binary, then why is it a PE64 file? It's rare for 32-bit binaries to be compiled into PE64+ (64-bit) binaries. If you disassemble some of the code too, it's clearly 32-bit. So let's fix that:

![](img/5.png)

Also, fixing that makes the program's icon show up, which means we're on the right track! That means the resources directory got parsed correctly.

![](img/11.png)

Moving on, the rest of this Optional Header seems really messed up as well, namely the Entrypoint:

![](img/6.png)

To recover OEP, we need to unfortunately take a look at the actual binary's contents.

![](img/7.png)

Judging from this, it's pretty obviously packed with UPX 3.08, but the UPX0 and UPX1 sections have been renamed to break the unpacker in case we try to decompress it as-is:

```
> upx394w\upx.exe -d "WH2018.exe"
                       Ultimate Packer for eXecutables
                          Copyright (C) 1996 - 2017
UPX 3.94w       Markus Oberhumer, Laszlo Molnar & John Reiser   May 12th 2017


        File size         Ratio      Format      Name
   --------------------   ------   -----------   -----------
upx: WH2018.exe: NotPackedException: not packed by UPX

Unpacked 0 files.
```

(side note: UPX 3.08 is further evidence that the file is 32-bit. UPX 3.08, unlike newer versions, refuses to pack 64-bit bins.)

Let's just fix that up:

![](img/8.png)

Since we know it's UPX, finding the OEP is pretty trivial. Save the file in CFF Explorer and reopen it in IDA (in 32-bit mode). For 32-bit UPX, the decompression stub begins:

```
UPX1:OEP   60                 pusha
UPX1:OEP+1 BE XX XX XX XX     mov     esi, offset dword_XXXXXXXX
UPX1:OEP+6 8D BE XX XX XX XX  lea     edi, [esi-XXXXXXXXh]
```

So searching for this pattern, we can easily find the decryption stub in WH2018.exe:

![](img/9.png)

IDA reports this is at file offset 9FBC0, so to calculate the OEP we take `OEP = FO + BaseOfCode - .text[PointerToRawData] - FileAlignment = 1E28D0`. `.text[PointerToRawData]` and `FileAlignment` are usually 0x200.

![](img/10.png)

Now the entrypoint shows correctly. And we can even run it!

![](img/12.png)

Let's decompress it now.

```
 upx394w\upx.exe -d "cock.exe"
                       Ultimate Packer for eXecutables
                          Copyright (C) 1996 - 2017
UPX 3.94w       Markus Oberhumer, Laszlo Molnar & John Reiser   May 12th 2017


        File size         Ratio      Format      Name
   --------------------   ------   -----------   -----------
   1872384 <-    823296   43.97%    win32/pe     cock.exe

Unpacked 1 file.
```

Nice. Now we can analyze this bin proper!

[1]: https://ntcore.com/?page_id=388
