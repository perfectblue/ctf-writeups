# hso-groupie

Exploit JBIG2 bug (CVE-2021-30860) in xpdf codebase.

1. Groom heap and align chunks similarly to [P0 post](https://googleprojectzero.blogspot.com/2021/12/a-deep-dive-into-nso-zero-click.html). (Use pageBitmap and JBIG2Stream::readTextRegionSeg)

2. Overwrite GList and some fields of pageBitmap with JBIG2Bitmap pointers.

3. We can now apply bit operations OR/AND/XOR/XNOR/REPLACE using corrupted pageBitmap. (without building CPU!)

4. Overwrite fields of pageBitmap to w = 0x7fffffff, h = 0x100000, line = 0x1, data = NULL.

5. Use pageBitmap->expand to realloc the pageBitmap->data with mmap sized chunk.

6. Use REPLACE op to put the command on stderr struct and use XOR op to change the function pointer in the table to system function.

7. Trigger error to execute the command.
