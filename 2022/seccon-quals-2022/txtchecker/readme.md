* $filepath is not quoted so can inject arbitrary arguments into the file command
* can use `-m /dev/stdin` to allow use to specify a custom magic file:
```
0       string SECCON{A gggg%1000s
>0       string SECCON{A gggg%1000s
>0       string SECCON{A gggg%1000s
...
```
* if the flag matches a bunch of text will be printed and can detect it with timing
* iterate through char by char and get the flag `SECCON{reDo5L1fe}`