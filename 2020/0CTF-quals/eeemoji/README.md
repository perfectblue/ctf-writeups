eeemoji
======

We can provide two bytes of shellcode, and more shellcode at the beginning of mmap region. Send push r10 as two bytes of shellcode, since r10 points to mmap region+4. Then, ret will return there, and then we can write shellcode in two byte increments that reads a second stager. Since utf-32 values are <= 0x110000, we can send "\x04\x00" as the 3rd and 4th bytes as effectively a nop.
